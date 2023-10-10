import 'package:flutter/material.dart';
import 'package:petkub2/contol/gridview_dog.dart';
import 'package:petkub2/contol/select_detect.dart';

import 'contol/phofile_of_user.dart';

class MyNavigator extends StatefulWidget {
  const MyNavigator({super.key});

  @override
  State<MyNavigator> createState() => _MyNavigatorState();
}

class _MyNavigatorState extends State<MyNavigator> {
  final List<Widget> _tapList = [
    const SelectDetection(),
    const MyDataOdDog(),
    const MyProfileUsers(),
  ];
  int _selectIndex = 0;
  void navigateBottomNavigationBar(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      body: Stack(
        children: [
          _tapList.elementAt(_selectIndex),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 105, vertical: 20),
            child: Align(
              alignment: const Alignment(0.0, 1.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  backgroundColor: const Color.fromRGBO(240, 239, 239, 1),
                  onTap: navigateBottomNavigationBar,
                  currentIndex: _selectIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'images/6927609.png',
                        height: 36,
                        color: _selectIndex == 0
                            ? const Color.fromRGBO(64, 148, 58, 1)
                            : null,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'images/pawprint.png',
                        height: 32,
                        color: _selectIndex == 1
                            ? const Color.fromRGBO(64, 148, 58, 1)
                            : null,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'images/menu.png',
                        height: 35,
                        color: _selectIndex == 2
                            ? const Color.fromRGBO(64, 148, 58, 1)
                            : null, // เช็ค index เพื่อกำหนดสี
                      ),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
