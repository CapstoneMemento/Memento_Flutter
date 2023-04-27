import 'package:flutter/material.dart';
import 'package:memento_flutter/api/note_api.dart';
import 'package:memento_flutter/screen/note/note_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/loading.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen();

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Future noteList;

  @override
  void initState() {
    super.initState();
    noteList = NoteAPI.fetchNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: noteList,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                padding: const EdgeInsets.only(top: 16, bottom: 80),
                children: snapshot.data
                    .map<Widget>((item) => ListTile(
                          title: Text(
                            item["title"],
                            style: CustomTheme.themeData.textTheme.titleSmall,
                          ),
                          subtitle: Text(
                            item["content"],
                            maxLines: 2,
                          ),
                          trailing: const Icon(Icons.add),
                          onTap: () {
                            // 해당 노트 화면으로 이동
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => NoteScreen(
                                          noteId: item["id"],
                                        ))));
                          },
                        ))
                    .toList());
          } else {
            return Loading();
          }
        }));
  }
}
