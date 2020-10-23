import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final String title;

  const HomeView({Key key, this.title}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //initialize firebase DB
  final db = FirebaseFirestore.instance;

  String task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          dialogForToDo();
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                  return ListTile(
                    title: Text(snapshot.data.docs.length.toString()),
                  );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  //for show dialog
  void dialogForToDo() {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add ToDo'),
          content: Form(
            key: _formKey,
            autovalidate: true,
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Write todo",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Field cannot be empty';
                }
                return null;
              },
              onChanged: (_value) {
                task = _value;
              },
            ),
          ),
          actions: [
            RaisedButton(
              color: Colors.blue,
              child: Text('Add Note'),
              onPressed: () {
                db.collection('task').add({'tasks': task});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
