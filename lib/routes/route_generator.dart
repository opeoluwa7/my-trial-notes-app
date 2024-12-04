import 'package:flutter/material.dart';
import 'package:myapp/auth_gate.dart';
import 'package:myapp/pages/edit_page.dart';
import 'package:myapp/pages/home_page.dart';

class RouteGenerator {
  final void Function() onNoteSaved;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String noteId;
  RouteGenerator(this.titleController, this.contentController, this.noteId,
      {required this.onNoteSaved});

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/edit':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditPage(
              onNoteSaved: args['onNoteSaved'],
              titleController: args['titleController'],
              contentController: args['contentController'],
              noteId: args['noteId']),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: const Center(
                child: Text('Something went wrong'),
              ),
            ));
  }
}
