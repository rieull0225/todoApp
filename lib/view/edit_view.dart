import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toodat_test/model/task.dart';


class EditViewController extends GetxController {
  EditViewController(this.task);

  final Task task;
  @override
  void onInit() {
    super.onInit();
    textController.text = task.name;
    update();
  }

  TextEditingController textController = TextEditingController();
}

class EditView extends StatelessWidget {
  const EditView({required this.task,super.key});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditViewController>(
      init: EditViewController(task),
        builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: const Text("수정하기"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              TextFormField(
                controller: controller.textController,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  Get.back(result:controller.textController.text);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                    child: Text("저장"),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
