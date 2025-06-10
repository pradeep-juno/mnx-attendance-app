import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app_model/admin_message_model.dart';

class AdminMessageController extends GetxController {
  final headerController = ''.obs;
  final bodyController = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var messages = <AdminMessageModel>[].obs;
  var headerMessage = ''.obs;
  var bodyMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final snapshot = await _firestore
          .collection('adminMessages')
          .orderBy('timestamp', descending: true)
          .get();

      messages.value = snapshot.docs.map((doc) {
        return AdminMessageModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    }
  }

  Future<void> sendMessage() async {
    if (headerController.value.trim().isEmpty || bodyController.value.trim().isEmpty) {
      Get.snackbar('Error', 'Header and Body cannot be empty');
      return;
    }

    AdminMessageModel msg = AdminMessageModel(
      header: headerController.value.trim(),
      message: bodyController.value.trim(),
      timestamp: DateTime.now(),
    );

    try {
      DocumentReference docRef = await _firestore.collection('adminMessages').add(msg.toMap());
      await docRef.update({'adminMessageId': docRef.id});
      fetchMessages();
      headerController.value = '';
      bodyController.value = '';
      Get.snackbar('Success', 'Message sent successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    }
  }
}

