import 'package:flutter/material.dart';

import 'package:google_demo/services/google_sheet_service.dart';

import 'package:google_demo/widgets/base_text_field.dart';
import 'package:google_demo/widgets/base_button.dart';
import 'package:provider/provider.dart';

class PageAddUser extends StatefulWidget {
  const PageAddUser({super.key});

  @override
  State<PageAddUser> createState() => _AddUserState();
}

class _AddUserState extends State<PageAddUser> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController memoController = TextEditingController();

  Future<void> updateData() async {
    await context.read<GoogleSheetService>().getUserInfo();
  }

  Future<void> sendData() async {
    await context.read<GoogleSheetService>().sendUserData(
      nameController.text,
      int.tryParse(ageController.text.trim()) ?? 0,
      memoController.text,
    );
  }

  void _onClickSend() {
    if (nameController.text == '') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이름을 써주세요.')));
    } else {
      sendData();
      updateData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('수강생 정보 저장 중...')));

      nameController.clear();
      ageController.clear();
      memoController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  BaseTextField(
                    size: 300,
                    text: '이름',
                    controller: nameController,
                  ),
                  BaseTextField(
                    size: 300,
                    text: '나이',
                    controller: ageController,
                  ),
                  BaseTextField(
                    size: 300,
                    text: '메모',
                    controller: memoController,
                  ),
                ],
              ),
            ),
          ),
          BaseButton(
            size: Size(300, 80),
            text: '전송',
            onPressed: _onClickSend,
            icon: Icons.save,
          ),
        ],
      ),
    );
  }
}
