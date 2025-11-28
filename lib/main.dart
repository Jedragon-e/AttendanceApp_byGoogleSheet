import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:google_demo/page_adduser.dart';
import 'package:google_demo/page_attendance.dart';
import 'package:google_demo/page_setting.dart';

import 'package:google_demo/services/google_sheet_service.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider<GoogleSheetService>(
      create: (_) => GoogleSheetService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fluter App',

      // 한국어 로케일 적용
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko'), // 한국어
      ],
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _PageState();
}

class _PageState extends State<MainWidget> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  bool isLoading = true;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> loadData() async {
    await context.read<GoogleSheetService>().getUserInfo();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [const PageAddUser(), const PageAttendance(), const PageSetting()];
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_rounded),
            label: '수강생 추가',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: '출석 체크',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
