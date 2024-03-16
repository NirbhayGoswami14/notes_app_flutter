

import 'package:database_example/database/database_helper.dart';
import 'package:database_example/model/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class UpdateNoteScreen extends StatefulWidget {
  UpdateNoteScreen(this.notesData, {super.key});
  NotesModel  notesData;
  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  late bool isChecked;
 late bool isPPC;
  final _titleController=TextEditingController();
  final _noteController=TextEditingController();
  @override
  void initState() {
    _titleController.text=widget.notesData.title.toString();
    _noteController.text=widget.notesData.note.toString();
    isChecked=widget.notesData.isPPC==1?true:false;
    isPPC=isChecked;
  }
  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async{
        if(_noteController.text.isNotEmpty || _titleController.text.isNotEmpty)
        {
          updateNote(widget.notesData.id.toString(),_titleController.text, _noteController.text,DateFormat('yyyy-MM-dd  hh:mm a').format(DateTime.now()),isPPC?1:0);
          Navigator.pop(context,true);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Note'),
        ),
        body: Column(children: [
          TextField(
            controller:_titleController,
            decoration: const InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            style: const TextStyle(fontSize:25),),
          Expanded(
            child: TextField(
                controller:_noteController,
                decoration: const InputDecoration(
                    hintText: 'Note',
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                style: const TextStyle(fontSize:18),
                maxLines:80),
          ), Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isChecked ? Text('Remove Password Protection') : Text('Make Password Protected'),
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
            padding: EdgeInsets.only(bottom:25),
            child: Row(

              children: [
                const Spacer(),
                Align(alignment: Alignment.bottomCenter, child: Text('Edited :${widget.notesData.time}'),),
                const Spacer(),
                Align(alignment: Alignment.centerRight, child: IconButton(icon:const Icon(Icons.more_vert), onPressed: () {
                  showModalBottomSheet(context: context, builder:(context) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Align( alignment: Alignment.centerLeft,child: TextButton.icon(onPressed: (){
                        deleteNote(widget.notesData.id.toString());
                        Navigator.pop(context);
                        Navigator.pop(context,true);
                      },icon:Icon(Icons.delete,),label:Text('Delete'),)),
                     SizedBox(height: 5,),
                      Align( alignment: Alignment.centerLeft,child: TextButton.icon(onPressed: (){
                        Navigator.pop(context);
                        Share.share('${widget.notesData.title.toString()}\n\n${widget.notesData.note.toString()}');
                      },icon:Icon(Icons.share),label:Text('Share'),))
                    ],),
                  );
                },); },),),
              ],
            ),
          )
        ]),
      ),
    );
  }

  void showPasswordDialog()
  {
    var passController=TextEditingController();
    showDialog(context: context, builder:(context) {
      return Dialog(
        child: Container(
          height: 250,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Align(alignment:Alignment.topRight,child: IconButton(onPressed: (){
                Navigator.pop(context);
                setState(() {
                  isChecked=false;
                  isPPC=false;
                });
              }, icon:const Icon(Icons.close,size:20,)),),
              const Text('Set Your Password'),
              const SizedBox(height: 20,),
              TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock,color:Colors.black,),
                          border:  OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    const SizedBox(height: 20,),
              ElevatedButton(onPressed: () {
                if(passController.text.isEmpty)
                {
                  Navigator.pop(context);
                  setState(() {
                    isChecked=false;
                    isPPC=false;
                  });
                }
                else{
                  insertPassword(passController.text.toString());

                  Navigator.pop(context);
                }
              }, child:const Text('Set',style: TextStyle(fontSize: 15),), style: ElevatedButton.styleFrom(backgroundColor:Colors.indigo),)
            ],),
          ),
        ),
      );
    },barrierDismissible: false);
  }
}