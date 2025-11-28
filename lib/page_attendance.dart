import 'package:flutter/material.dart';

import 'package:google_demo/services/google_sheet_service.dart';

import 'package:google_demo/widgets/base_button.dart';
import 'package:google_demo/widgets/base_toggle_button.dart';
import 'package:provider/provider.dart';

class PageAttendance extends StatefulWidget {
  const PageAttendance({super.key});

  @override
  State<PageAttendance> createState() => _Attendance();
}

class _Attendance extends State<PageAttendance> {
  DateTime? selectedDate;
  bool isMorning = true;
  List<String> selectedUsers = [];  // 수강한 유저 리스트
  List<String> allUsers = [];       // 전체 유저 리스트

  void _onDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      locale: Locale('ko'),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  String makeDateText(DateTime? date) {
    if (date == null) {
      return "날짜 선택";
    } else {
      return "${date.year}-${date.month}-${date.day}";
    }
  }

  void _onAttendanceTime(bool value) {
    isMorning = value;
  }

  // 수강생 선택
  void _onSelectStudent(BuildContext context) async {
    allUsers = context.read<GoogleSheetService>().names;
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        List<String> tempSelected = List.from(selectedUsers);
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('수강생', textAlign: TextAlign.center),
              content: SizedBox(
                width: 400,
                height: 550, // 다이얼로그 높이 지정 (필요 시 조절)
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    final member = allUsers[index];
                    final isSelected = tempSelected.contains(member);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 72),
                          backgroundColor: isSelected
                              ? Colors.deepPurple.shade100
                              : Colors.grey[200],
                          foregroundColor: isSelected
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () {
                          setStateDialog(() {
                            if (isSelected) {
                              tempSelected.remove(member);
                            } else {
                              tempSelected.add(member);
                            }
                          });
                        },
                        child: Text(
                          member,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedUsers),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, tempSelected),
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedUsers = selected;
      });
    }
  }

  Future<void> sendData() async {
    String time = isMorning ? '오전' : '오후';
    String date = makeDateText(selectedDate);

    await context.read<GoogleSheetService>().sendAttendanceData(
      selectedUsers,
      date,
      time,
    );

    setState(() {
      selectedDate = DateTime.now();
      selectedUsers.clear();
    });
  }

  void _onClickSend() {
    if (selectedUsers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("데이터를 채워주세요.")));
    } else {
      sendData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("출석 저장 중...")));
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
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
                  BaseButton(
                    size: Size(300, 50),
                    text: makeDateText(selectedDate),
                    onPressed: _onDate,
                  ),
                  BaseToggleButton(
                    size: Size(300, 50),
                    firstLabel: '오전',
                    secondLabel: '오후',
                    onChanged: _onAttendanceTime,
                  ),

                  BaseButton(
                    size: Size(300, 50),
                    text: '수강생',
                    onPressed: () => _onSelectStudent(context),
                  ),
                  if (selectedUsers.isNotEmpty)
                    Wrap(
                      spacing: 8, // 가로 간격
                      runSpacing: 8, // 세로 간격
                      children: selectedUsers
                          .map((m) => Chip(label: Text(m)))
                          .toList(),
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
