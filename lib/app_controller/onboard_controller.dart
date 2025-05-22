import 'package:get/get.dart';

class OnBoardController extends GetxController {
  RxBool isButtonClicked = false.obs;

  void toggleButton() {
    isButtonClicked.value = !isButtonClicked.value;
  }
}
