import 'package:flutter/material.dart';

import '../database_service.dart';

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
              DataBaseService().deleteNote(deleteNote
                  .id); // Optionally, call a callback to delete the item.
            },
          ),
        ],
      );
    },
  );
}
