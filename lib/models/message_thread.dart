class AppMessageThread {
  const AppMessageThread({
    required this.id,
    required this.ownerId,
    required this.contactName,
    required this.propertyId,
    required this.propertyTitle,
    required this.messages,
    this.contactAvatarUrl,
  });

  final String id;
  final String ownerId;
  final String contactName;
  final String? contactAvatarUrl;
  final String propertyId;
  final String propertyTitle;
  final List<AppChatMessage> messages;

  AppChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;

  String get previewText {
    final message = lastMessage;
    if (message == null) return propertyTitle;
    if (message.text.isNotEmpty) return message.text;
    if (message.isImageAttachment) return 'Photo';
    if (message.hasAttachment) return 'File';
    return propertyTitle;
  }

  AppMessageThread copyWith({List<AppChatMessage>? messages}) {
    return AppMessageThread(
      id: id,
      ownerId: ownerId,
      contactName: contactName,
      contactAvatarUrl: contactAvatarUrl,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      messages: _sortedMessages(messages ?? this.messages),
    );
  }

  static List<AppChatMessage> _sortedMessages(List<AppChatMessage> messages) {
    final sorted = [...messages];
    sorted.sort((first, second) {
      final timeOrder = first.createdAt.compareTo(second.createdAt);
      if (timeOrder != 0) return timeOrder;

      return first.id.compareTo(second.id);
    });
    return sorted;
  }
}

class AppChatMessage {
  const AppChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.attachmentUrl,
    this.attachmentType,
  });

  final String id;
  final String senderId;
  final String text;
  final String? attachmentUrl;
  final String? attachmentType;
  final DateTime createdAt;

  bool get hasAttachment => attachmentUrl != null && attachmentUrl!.isNotEmpty;
  bool get isImageAttachment => attachmentType == 'image';
  bool get isFileAttachment => hasAttachment && !isImageAttachment;

  String get attachmentName {
    if (!hasAttachment) return 'Attachment';

    final uri = Uri.tryParse(attachmentUrl!);
    final segment = uri == null || uri.pathSegments.isEmpty
        ? 'Attachment'
        : Uri.decodeComponent(uri.pathSegments.last);
    final separatorIndex = segment.indexOf('_');
    if (separatorIndex == -1 || separatorIndex == segment.length - 1) {
      return segment;
    }

    return segment.substring(separatorIndex + 1);
  }
}
