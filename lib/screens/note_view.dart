import 'package:contact_app/home_screen.dart';
import 'package:contact_app/widgets/build_text_widget.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';

class NoteViewPage extends StatefulWidget {
  final Note note;
  const NoteViewPage({
    super.key,
    required this.note,
  });

  @override
  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BuildTextWidget(
                text: 'ViewNote', Fontsize: 20, Fontcolor: Colors.white),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: BuildTextWidget(
                text: widget.note.title,
                Fontsize: 16,
                Fontcolor: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: BuildTextWidget(
                  text: widget.note.content,
                  Fontsize: 13,
                  Fontcolor: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
