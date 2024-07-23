import 'package:contact_app/database_service.dart';
import 'package:contact_app/widgets/build_text_widget.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final Note? note;
  final bool isEdit;
  final int? index;

  const AddNote({
    Key? key,
    this.note,
    this.isEdit = false,
    this.index,
  }) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitData() async {
    if (widget.isEdit && widget.note != null) {
      // Update existing note
      await DataBaseService().updateNote(
        widget.note!.id,
        _titleController.text,
        _contentController.text,
      );
    } else {
      // Add new note
      await DataBaseService.addNote(
        _titleController,
        _contentController,
      );
    }

    Navigator.pop(context, true);
// Indicate that a change has been made
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BuildTextWidget(
          text: widget.isEdit ? 'Edit Note' : 'Add Note',
          Fontsize: 20,
          Fontcolor: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.deepPurple),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Add Content',
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.deepPurple),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: _submitData,
                child: const Icon(Icons.done),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
