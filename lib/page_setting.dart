import 'package:flutter/material.dart';

import 'package:google_demo/widgets/base_text_field.dart';
import 'package:google_demo/widgets/base_button.dart';
import 'package:google_demo/services/prefs.dart';
import 'package:google_demo/services/google_sheet_service.dart';
import 'package:provider/provider.dart';

class PageSetting extends StatefulWidget {
  const PageSetting({super.key});

  @override
  State<PageSetting> createState() => _Setting();
}

class _Setting extends State<PageSetting> {
  final TextEditingController controller = TextEditingController();
  String saveUrl = 'not';

  Future<void> saveData() async {
    await Prefs.saveBaseUrl(controller.text);
  }

  void _onClickTest() async {
    final success = await context.read<GoogleSheetService>().getUserInfo();

    _showResultDialog(success);
  }

  Future<void> _showResultDialog(bool success) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(success ? "Success" : "Failed"),
          content: Text(
            success ? "정상적인 URL 입니다" : "URL을 확인하거나 시트를 확인해주세요.",
          )
        );
      },
    );
  }

  void _onClickSave() {
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("데이터를 채워주세요.")));
    } else {
      saveData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("저장")));
      setState(() {
        saveUrl = controller.text;
      });
      controller.clear();
    }
  }

  void setSaveUrl() async {
    String? url = await Prefs.getBaseUrl();

    setState(() {
      saveUrl = url.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    setSaveUrl();
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
                  BaseTextField(size: 300, text: 'Url', controller: controller),
                  SizedBox(
                    width: 300,
                    child: Text(saveUrl),
                  ),
                ],
              ),
            ),
          ),
          BaseButton(
            size: Size(200, 60),
            text: '테스트',
            onPressed: _onClickTest,
            icon: Icons.check_box,
          ),
          SizedBox(height: 16),
          BaseButton(
            size: Size(300, 80),
            text: '저장',
            onPressed: _onClickSave,
            icon: Icons.save,
          ),
        ],
      ),
    );
  }
}
