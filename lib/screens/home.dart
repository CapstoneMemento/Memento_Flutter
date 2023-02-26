import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/subject_list_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/modal_bottom_sheet.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("내 암기장"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleTextStyle: CustomTheme.themeData.textTheme.titleLarge,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(children: [
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(width: 1, color: Colors.black26))),
            child: ListTile(
              title: const Text("특허법"),
              subtitle: const Text("저장한 판례 22개"),
              trailing: const Icon(Icons.notifications_none),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SubjectListScreen()));
              },
            ),
          )
        ]),
      ),
      floatingActionButton: const ModalBottomSheet(),
    );
  }
}
