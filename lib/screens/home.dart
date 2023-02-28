import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/subject_list_screen.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';
import 'package:memento_flutter/widgets/modal_bottom_sheet.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: Text("내 암기장"),
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
