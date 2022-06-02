import 'package:application3/widgets/scaffold.dart';

import '../mixins/chat.dart';
import '../pages/start_revision.dart';
import 'package:flutter/material.dart';

class ListeRevision extends StatelessWidget with TilawaHeadersMixin {
  ListeRevision({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      pageTitle: 'المراجعات',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const StartRevision();
          }));
        },
        label: Text(
          "بدء مراجعة",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.brown[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: tilawatListBuilder(),
    );
  }
}
