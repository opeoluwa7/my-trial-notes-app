// ignore_for_file: await_only_futures, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myapp/auth/firebase_auth.dart';
import 'package:myapp/auth/notes_firestore.dart';
import 'package:myapp/pages/add_note_page.dart';
import 'package:myapp/pages/login_or_register.dart';
import 'package:myapp/pages/notes_page.dart';
import 'package:myapp/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BaseAuth auth = BaseAuth();
  final NoteService noteService = NoteService();
  final PageController pageController = PageController();
  int selectedIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
       NotesPage(
        noteService: noteService,
      ),
      AddNotePage(onNoteSaved: () {
        setState(() {
          pageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        });
      }),
      const ProfilePage(),
    ];
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> signUserOut() async {
    await auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginOrRegister()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            unselectedItemColor: Colors.grey,
            iconSize: 30,
            currentIndex: selectedIndex,
            onTap: (int index) {
              setState(() {
                pageController.jumpToPage(index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined), label: ''),
            ]));
  }
}
