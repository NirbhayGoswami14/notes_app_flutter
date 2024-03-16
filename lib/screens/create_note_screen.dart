import 'package:database_example/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateNoteScreen extends StatefulWidget {
  CreateNoteScreen(this.getData, {super.key});

  void Function() getData;

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  bool isChecked = false ;
  bool isPPC=false;

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_noteController.text.isNotEmpty ||
            _titleController.text.isNotEmpty) {
            insertData(_titleController.text, _noteController.text,
              DateFormat('yyyy-MM-dd  hh:mm a').format(DateTime.now()),isPPC?1:0);
          Navigator.pop(context, true);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Note'),
        ),
        body: Column(children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            style: const TextStyle(fontSize: 25),
          ),
          Expanded(
            child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                    hintText: 'Note',
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                style: const TextStyle(fontSize: 18),
                maxLines: 80),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isChecked
                  ? Text('Remove Password Protection') : Text('Make Password Protected'),
              Checkbox(
                  value: isChecked,
                  onChanged: (value) async {

                      if(await getPassword()=='' || getPassword().toString().isEmpty)
                        {
                          showPasswordDialog();

                        }
                    setState((){
                      isChecked = value!;
                      isPPC=value;
                    });
                  },activeColor:Colors.indigo),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                  'Edited :${DateFormat('yyyy-MM-dd  hh:mm a').format(DateTime.now())}'),
            ),
          )
        ]),
      ),
    );
  }

  void showPasswordDialog() {
    var passController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 250,
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              isChecked = false;
                              isPPC = false;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                          )),
                    ),
                    const Text('Set Your Password'),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        contentPadding:EdgeInsets.all(10),
                          prefixIcon:Icon(Icons.lock,color:Colors.black,),
                          hintText: 'Password',
                          border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (passController.text.isEmpty) {
                          Navigator.pop(context);
                          setState(() {
                            isChecked = false;
                            isPPC = false;
                          });
                        } else {
                          insertPassword(passController.text.toString());

                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Set',
                        style: TextStyle(fontSize: 15),
                      ),
                        style: ElevatedButton.styleFrom(backgroundColor:Colors.indigo),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        barrierDismissible: false);
  }
}
