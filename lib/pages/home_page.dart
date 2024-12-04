// ignore_for_file: await_only_futures, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:myapp/pages/add_note_page.dart';
import 'package:myapp/pages/notes_page.dart';
import 'package:myapp/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final PageController pageController = PageController();
  int selectedIndex = 0;
  List<Widget> pages = [];

  void _onNoteSaved() {
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    pages = [
      const NotesPage(),
      AddNotePage(onNoteSaved: _onNoteSaved),
      const ProfilePage(),
    ];
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: MyBottomNav(
        selectedIndex: selectedIndex,
        controller: pageController,
      ),
    );
  }

  void _onPageChanged(index) {
    selectedIndex = index;
  }

  Widget _buildPage() {
    return PageView(
      controller: pageController,
      onPageChanged: _onPageChanged,
      children: pages,
    );
  }
}

class MyBottomNav extends StatelessWidget {
  const MyBottomNav(
      {super.key, required this.selectedIndex, required this.controller});
  final int selectedIndex;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        iconSize: 28,
        currentIndex: selectedIndex,
        onTap: _onTapFunction,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: ''),
        ]);
  }

  void _onTapFunction(int index) {
    controller.jumpToPage(index);
  }
}
