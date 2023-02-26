import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/note_list_screen.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          title: const Text("특허법"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(children: [
            Container(
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(width: 1, color: Colors.black26))),
              child: ListTile(
                title: const Text("발명의 종류"),
                subtitle: const Text("저장한 판례 10개"),
                trailing: const Icon(Icons.playlist_add),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoteListScreen()));
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(width: 1, color: Colors.black26))),
              child: ListTile(
                title: const Text("PCT"),
                subtitle: const Text("저장한 판례 12개"),
                trailing: const Icon(Icons.playlist_add),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoteListScreen()));
                },
              ),
            )
          ]),
        ));
  }
}
