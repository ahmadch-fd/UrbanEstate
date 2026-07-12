import 'dart:io';

import 'package:get/get.dart';
import 'package:urban_estate/models/message_thread.dart';
import 'package:urban_estate/models/posted_property.dart';
import 'package:urban_estate/services/auth_service.dart';
import 'package:urban_estate/services/message_service.dart';

class MessageController extends GetxController {
  final RxList<AppMessageThread> threads = <AppMessageThread>[].obs;
  final RxnString activeThreadId = RxnString();
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxString errorMessage = ''.obs;
  String? _loadedUserId;

  AppMessageThread? get activeThread {
    final id = activeThreadId.value;
    if (id == null) return null;

    return threads.firstWhereOrNull((thread) => thread.id == id);
  }

  @override
  void onInit() {
    super.onInit();
    loadThreads();
  }

  Future<void> loadThreads() async {
    final currentUserId = AuthService.currentUser?.id;
    if (currentUserId == null) {
      clearMessages();
      return;
    }

    if (_loadedUserId != currentUserId) {
      threads.clear();
      activeThreadId.value = null;
      _loadedUserId = currentUserId;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      threads.assignAll(await MessageService.fetchThreads());
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openThreadForProperty(PostedProperty property) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final thread = await MessageService.openThreadForProperty(property);
      await loadThreads();
      if (thread != null) activeThreadId.value = thread.id;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void openThread(String threadId) {
    activeThreadId.value = threadId;
  }

  void closeThread() {
    activeThreadId.value = null;
  }

  void clearMessages() {
    threads.clear();
    activeThreadId.value = null;
    errorMessage.value = '';
    isLoading.value = false;
    isSending.value = false;
    _loadedUserId = null;
  }

  Future<void> sendMessage(
    String text, {
    String attachmentPath = '',
    String attachmentName = '',
  }) async {
    final thread = activeThread;
    if (thread == null || isSending.value) return;
    if (text.trim().isEmpty && attachmentPath.isEmpty) return;

    isSending.value = true;
    errorMessage.value = '';

    try {
      final message = await MessageService.sendMessage(
        conversationId: thread.id,
        text: text,
        attachment: attachmentPath.isEmpty ? null : File(attachmentPath),
        attachmentName: attachmentName,
      );
      if (message == null) return;

      final index = threads.indexWhere((item) => item.id == thread.id);
      if (index == -1) return;

      threads[index] = thread.copyWith(messages: [...thread.messages, message]);
      await loadThreads();
      activeThreadId.value = thread.id;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isSending.value = false;
    }
  }
}
