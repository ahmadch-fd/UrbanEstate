import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urban_estate/models/message_thread.dart';
import 'package:urban_estate/models/posted_property.dart';

class MessageService {
  MessageService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<AppMessageThread>> fetchThreads() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const [];

    final response = await _client
        .from('conversations')
        .select(
          'id, property_id, owner_id, buyer_id, updated_at, '
          'properties(title), '
          'owner:profiles!conversations_owner_id_fkey(full_name, avatar_url), '
          'buyer:profiles!conversations_buyer_id_fkey(full_name, avatar_url)',
        )
        .or('buyer_id.eq.$userId,owner_id.eq.$userId')
        .order('updated_at', ascending: false);

    final threads = <AppMessageThread>[];
    for (final item in response) {
      final map = Map<String, dynamic>.from(item as Map);
      final messages = await fetchMessages(map['id'].toString());
      threads.add(_threadFromConversation(map, messages, userId));
    }

    return threads;
  }

  static Future<AppMessageThread?> openThreadForProperty(
    PostedProperty property,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || userId == property.ownerId) return null;

    final response = await _client
        .from('conversations')
        .upsert({
          'property_id': property.id,
          'buyer_id': userId,
          'owner_id': property.ownerId,
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'property_id,buyer_id,owner_id')
        .select(
          'id, property_id, owner_id, buyer_id, updated_at, '
          'properties(title), '
          'owner:profiles!conversations_owner_id_fkey(full_name, avatar_url), '
          'buyer:profiles!conversations_buyer_id_fkey(full_name, avatar_url)',
        )
        .single();

    return _threadFromConversation(
      Map<String, dynamic>.from(response),
      const [],
      userId,
    );
  }

  static Future<List<AppChatMessage>> fetchMessages(
    String conversationId,
  ) async {
    late final List<dynamic> response;

    try {
      response = await _client
          .from('messages')
          .select(
            'id, sender_id, body, attachment_url, attachment_type, created_at',
          )
          .eq('conversation_id', conversationId)
          .order('created_at');
    } on PostgrestException catch (error) {
      if (_isMissingAttachmentColumn(error)) {
        response = await _client
            .from('messages')
            .select('id, sender_id, body, created_at')
            .eq('conversation_id', conversationId)
            .order('created_at');
      } else {
        rethrow;
      }
    }

    final messages = response.map<AppChatMessage>((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return AppChatMessage(
        id: map['id'].toString(),
        senderId: map['sender_id']?.toString() ?? '',
        text: map['body']?.toString() ?? '',
        attachmentUrl: map['attachment_url']?.toString(),
        attachmentType: map['attachment_type']?.toString(),
        createdAt:
            DateTime.tryParse(map['created_at']?.toString() ?? '') ??
            DateTime.now(),
      );
    }).toList();

    messages.sort((first, second) {
      final timeOrder = first.createdAt.compareTo(second.createdAt);
      if (timeOrder != 0) return timeOrder;

      return first.id.compareTo(second.id);
    });
    return messages;
  }

  static Future<AppChatMessage?> sendMessage({
    required String conversationId,
    required String text,
    File? attachment,
    String attachmentName = '',
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final trimmedText = text.trim();
    if (trimmedText.isEmpty && attachment == null) return null;

    final uploadedAttachment = await _uploadMessageAttachment(
      attachment,
      originalName: attachmentName,
    );

    late final Map<String, dynamic> response;

    try {
      response = await _client
          .from('messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': userId,
            'body': trimmedText,
            if (uploadedAttachment != null)
              'attachment_url': uploadedAttachment.url,
            if (uploadedAttachment != null)
              'attachment_type': uploadedAttachment.type,
          })
          .select(
            'id, sender_id, body, attachment_url, attachment_type, created_at',
          )
          .single();
    } on PostgrestException catch (error) {
      if (_isMissingAttachmentColumn(error)) {
        throw const MessageSetupException(
          'Run the updated supabase_setup.sql once to enable message attachments.',
        );
      }
      rethrow;
    }

    await _client
        .from('conversations')
        .update({'updated_at': DateTime.now().toIso8601String()})
        .eq('id', conversationId);

    final map = Map<String, dynamic>.from(response);
    return AppChatMessage(
      id: map['id'].toString(),
      senderId: map['sender_id']?.toString() ?? '',
      text: map['body']?.toString() ?? '',
      attachmentUrl: map['attachment_url']?.toString(),
      attachmentType: map['attachment_type']?.toString(),
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  static Future<_UploadedMessageAttachment?> _uploadMessageAttachment(
    File? file, {
    required String originalName,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || file == null) return null;

    final fileName = _safeFileName(originalName, fallbackPath: file.path);
    final extension = fileName.split('.').last.toLowerCase();
    final type = _isImageExtension(extension) ? 'image' : 'file';
    final path = '$userId/${DateTime.now().microsecondsSinceEpoch}_$fileName';

    try {
      await _client.storage
          .from('message-files')
          .upload(path, file, fileOptions: const FileOptions(upsert: true));
    } on StorageException catch (error) {
      if (_isMissingMessageBucket(error)) {
        throw const MessageSetupException(
          'Create the message-files bucket and run its storage policies in Supabase.',
        );
      }
      rethrow;
    }

    final url = _client.storage.from('message-files').getPublicUrl(path);
    return _UploadedMessageAttachment(url: url, type: type);
  }

  static AppMessageThread _threadFromConversation(
    Map<String, dynamic> map,
    List<AppChatMessage> messages,
    String currentUserId,
  ) {
    final owner = map['owner'] is Map
        ? Map<String, dynamic>.from(map['owner'] as Map)
        : <String, dynamic>{};
    final buyer = map['buyer'] is Map
        ? Map<String, dynamic>.from(map['buyer'] as Map)
        : <String, dynamic>{};
    final property = map['properties'] is Map
        ? Map<String, dynamic>.from(map['properties'] as Map)
        : <String, dynamic>{};
    final isOwner = map['owner_id']?.toString() == currentUserId;
    final contact = isOwner ? buyer : owner;

    return AppMessageThread(
      id: map['id'].toString(),
      ownerId: map['owner_id']?.toString() ?? '',
      contactName: _profileName(contact, fallback: isOwner ? 'Buyer' : 'Owner'),
      contactAvatarUrl: contact['avatar_url']?.toString(),
      propertyId: map['property_id']?.toString() ?? '',
      propertyTitle: property['title']?.toString() ?? 'Property',
      messages: messages,
    );
  }

  static String _profileName(
    Map<String, dynamic> profile, {
    required String fallback,
  }) {
    final name = profile['full_name']?.toString().trim() ?? '';
    return name.isEmpty ? fallback : name;
  }

  static bool _isMissingAttachmentColumn(PostgrestException error) {
    return error.code == '42703' &&
        (error.message.contains('attachment_url') ||
            error.message.contains('attachment_type'));
  }

  static bool _isMissingMessageBucket(StorageException error) {
    final statusCode = error.statusCode?.toString();
    return statusCode == '404' ||
        error.message.toLowerCase().contains('bucket not found');
  }

  static bool _isImageExtension(String extension) {
    const imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'};
    return imageExtensions.contains(extension);
  }

  static String _safeFileName(
    String originalName, {
    required String fallbackPath,
  }) {
    final fallbackName = fallbackPath.split(Platform.pathSeparator).last;
    final name = originalName.trim().isEmpty ? fallbackName : originalName;
    final safeName = name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return safeName.isEmpty ? 'attachment' : safeName;
  }
}

class _UploadedMessageAttachment {
  const _UploadedMessageAttachment({required this.url, required this.type});

  final String url;
  final String type;
}

class MessageSetupException implements Exception {
  const MessageSetupException(this.message);

  final String message;

  @override
  String toString() => message;
}
