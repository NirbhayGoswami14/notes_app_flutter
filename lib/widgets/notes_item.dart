import 'package:database_example/database/database_helper.dart';
import 'package:database_example/model/notes_model.dart';
import 'package:database_example/screens/update_note_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NotesItem extends StatefulWidget {
  NotesItem(this.notesData, this.getData, {super.key});

  NotesModel notesData;
  void Function() getData;


  @override
  State<NotesItem> createState() => _NotesItemState();
}

class _NotesItemState extends State<NotesItem> {
    int? temp;

    @override
  void initState() {
    // TODO: implement initState
    temp=widget.notesData.isPPC;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() async {
        if(widget.notesData.isPPC==1)
          {
             showPasswordDialog();
          }
        else
          {
            var result= await Navigator.of(context).push(MaterialPageRoute(builder:(context) => UpdateNoteScreen(widget.notesData),));
            print(result);
            if(result==true)
            {
              print(result);
              widget.getData();
            }
          }


      },
      child: Card(

        elevation: 5,
        shape: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none),
        child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical:8),
              child: Column(
                  children: [
                    Align(alignment:Alignment.topRight,child: Visibility(visible:widget.notesData.isPPC==1?true:false,child:const Icon(Icons.lock,size:20,))),

                    const SizedBox(height: 10,),
                Text(
                  widget.notesData.title.toString(),
                  overflow:TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:10),
                  child: Visibility(
                    visible: widget.notesData.isPPC==1?false:true,
                    child: Text(
                      widget.notesData.note.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      maxLines:widget.notesData.isPPC==1?2:10,
                    ),
                  ),
                )
              ]),
            ),
        ),
    );
  }

    void showPasswordDialog() async {
    dynamic result;
    var pass1=false;

    var passController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
             builder: (context, setState) =>SimpleDialog(
              contentPadding: const EdgeInsets.all(10),
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passController,
                      obscureText: true,
                      cursorColor: Colors.indigo,
                      decoration: InputDecoration(
                        contentPadding:const EdgeInsets.all(10),
                        hintText: 'Password',
                        prefixIcon:Icon(Icons.lock,color:Colors.black,),
                        errorText:pass1?"Enter correct password":null,
                        border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var pass = await getPassword();

                        if (passController.text.toString() != pass) {
                          setState(() {
                            print("dddd");
                            pass1=passController.text.toString()!=pass;
                            print(pass1);
                          });
                        } else {
                          Navigator.pop(context);
                          result = await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) =>
                                UpdateNoteScreen(widget.notesData),
                          ));
                          if (result == true) {
                            print(result);
                            widget.getData();
                          }
                        }
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 15),
                      ),
                      style:ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    )
                  ],
                ),
              ],

            ),
          );
        },
        barrierDismissible: false);
  }
}
