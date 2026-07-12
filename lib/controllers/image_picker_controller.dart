import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  final RxString imagePath = ''.obs;

  Future pickImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imagePath.value = image.path;
      Get.back();
    }
  }

  void clearImage() {
    imagePath.value = '';
  }
}
