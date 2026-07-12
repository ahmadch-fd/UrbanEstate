import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MessageAttachmentController extends GetxController {
  final RxString selectedFilePath = ''.obs;
  final RxString selectedFileName = ''.obs;
  final RxString selectedFileType = ''.obs;
  final RxString errorMessage = ''.obs;

  bool get hasAttachment => selectedFilePath.value.isNotEmpty;
  bool get isImageSelected => selectedFileType.value == 'image';

  Future<void> pickImageFromGallery() async {
    try {
      errorMessage.value = '';
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      _selectFile(
        path: image.path,
        name: image.name,
        extension: image.name.split('.').last,
      );
    } catch (error) {
      errorMessage.value = 'Could not open gallery: $error';
    }
  }

  Future<void> pickDocument() async {
    try {
      errorMessage.value = '';
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );
      final file = result?.files.single;
      if (file == null || file.path == null) return;

      _selectFile(path: file.path!, name: file.name, extension: file.extension);
    } on MissingPluginException {
      errorMessage.value =
          'Document picker is installing. Fully stop the app and run it again.';
    } catch (error) {
      errorMessage.value = 'Could not open files: $error';
    }
  }

  void clearAttachment() {
    selectedFilePath.value = '';
    selectedFileName.value = '';
    selectedFileType.value = '';
    errorMessage.value = '';
  }

  void _selectFile({
    required String path,
    required String name,
    required String? extension,
  }) {
    selectedFilePath.value = path;
    selectedFileName.value = name;
    selectedFileType.value = _attachmentType(extension);
  }

  String _attachmentType(String? extension) {
    final value = extension?.toLowerCase() ?? '';
    const imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'};
    return imageExtensions.contains(value) ? 'image' : 'file';
  }
}
