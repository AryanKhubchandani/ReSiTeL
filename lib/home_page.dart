import 'package:flutter/material.dart';

import 'archive_page.dart';
import 'camera_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  int _page = 1;
  late PageController _c;

  @override
  void initState() {
    _c = PageController(
      keepPage: true,
      initialPage: _page,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 0.0,
        child: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: _getColor()),
          unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.shifting,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _page,
          onTap: (index) {
            this._c.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutSine);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'archive',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.camera_alt_outlined,
              ),
              label: 'camera',
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _c,
        onPageChanged: (newPage) {
          setState(() {
            _page = newPage;
          });
        },
        children: <Widget>[
          Archive(),
          CameraPage(),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (_page) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }
}
