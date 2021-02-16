import 'package:flutter/material.dart';
import 'package:study_material_app/user.dart';
import 'Animation/CustomWidgets.dart';
import 'database/DatabaseHelper.dart';

class UserForm extends StatefulWidget {
  static const String id = 'UserForm';
  final User user;
  final state = _UserFormState();

  UserForm(this.user);
  @override
  _UserFormState createState() => state;
}

class _UserFormState extends State<UserForm> {
  final form = GlobalKey<FormState>();
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController presentController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  void moveBack() {
    Navigator.pop(context);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void onSave() async {
    int result;
    if (widget.user.id == null) {
      result = await helper.insert(widget.user);
      if (result != 0) {
        _showAlertDialog('Status', 'Note Saved Successfully');
      } else {
        _showAlertDialog('Status', 'Problem Saving Note');
      }
    } else {
      result = await helper.update(widget.user);
      if (result > 0) {
        _showAlertDialog('Status', 'Note updated Successfully');
      } else {
        _showAlertDialog('Status', 'Problem updating Note');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    presentController.text = widget.user.present.toString();
    totalController.text = widget.user.total.toString();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Background(
              height1: 280.0,
              height2: 150.0,
              height3: 100.0,
              height4: 100.0,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Material(
                elevation: 1,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400.withOpacity(0.5),
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 10.0, //extend the shadow
                      )
                    ],
                  ),
                  child: Form(
                    key: form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                initialValue: widget.user.subject,
                                onChanged: (String value) {
                                  setState(() {
                                    widget.user.subject = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Subject Name',
                                  hintText: 'Enter your subject name',
                                  icon: Icon(Icons.copy),
                                  isDense: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await helper.delete(widget.user.id);
                                moveBack();
                                _showAlertDialog(
                                    'Status', 'Subject deleted successfully.');
                              },
                            ),
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  initialValue: widget.user.present.toString(),
                                  onChanged: (String value) {
                                    setState(() {
                                      widget.user.present = int.parse(value);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Present',
                                    hintText: 'Total no. of present',
                                    icon: Icon(Icons.copy),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: widget.user.total.toString(),
                                  onChanged: (String value) {
                                    setState(() {
                                      widget.user.total = int.parse(value);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Total classes',
                                    hintText: 'Number of classes occured',
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          setState(() {
            print(widget.user);
            onSave();
            moveBack();
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }
}