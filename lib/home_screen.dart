import 'package:contact_app/database_service.dart';
import 'package:contact_app/screens/add_note_page.dart';
import 'package:contact_app/screens/note_view.dart';
import 'package:contact_app/widgets/build_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _showDeleteDialog(BuildContext context, Note deleteNote) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you sure you want to delete this note?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog.
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Perform the delete action here.
                DataBaseService().deleteNote(deleteNote.id);
                Navigator.of(context).pop();
                _refreshNotes();
// Dismiss the dialog.
// Optionally, call a callback to delete the item.
              },
            ),
          ],
        );
      },
    );
  }

  late Future<List<Note>> _noteFuture;

  @override
  void initState() {
    super.initState();
    _noteFuture = DataBaseService().readNote();
  }

  void _refreshNotes() {
    setState(() {
      _noteFuture = DataBaseService().readNote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Note>>(
        future: _noteFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final dataList = snapshot.data!;

            return GridView.builder(
              itemCount: dataList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final note = dataList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteViewPage(
                          note: Note(
                              id: note.id,
                              title: note.title,
                              content: note.content,
                              createdTime: note.createdTime),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            note.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _showDeleteDialog(context, note);
                                  },
                                  child: const Icon(Icons.delete)),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNote(
                                                  index: index,
                                                  note: Note(
                                                      id: note.id,
                                                      title: note.title,
                                                      content: note.content,
                                                      createdTime:
                                                          note.createdTime),
                                                  isEdit: true,
                                                )));
                                  },
                                  child: const Icon(Icons.edit_note))
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: BuildTextWidget(
                                text: DateFormat('dd-MM-yyy  h:mm a')
                                    .format(note.createdTime.toDate()),
                                Fontsize: 9,
                                Fontcolor: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text("No notes available"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNote()),
          );
          _refreshNotes(); // Refresh notes after adding a new note
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
