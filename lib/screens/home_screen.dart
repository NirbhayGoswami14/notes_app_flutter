import 'package:database_example/database/database_helper.dart';
import 'package:database_example/screens/create_note_screen.dart';
import 'package:database_example/widgets/notes_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  List<NotesModel> notesData = [];

  @override
  void initState() {
    super.initState();

    createDatabase();
    createPwDatabase();
    _getData();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text('My Notes')),
        body:noteList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            var result= await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNoteScreen(_getData)),);
            if(result==true)
            {
                  _getData();
            }
          } ,
          tooltip: 'Create Note',
          backgroundColor: Colors.indigo,
          shape: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none),
          child: const Icon(Icons.add),
        ));
  }

  void _getData() async {
    print('yay');
    var tempNotes = await getNotes();
    setState(() {
      notesData = tempNotes;
    });
  }

  Widget noteList() {
    print(notesData.length);

    if(notesData.isNotEmpty)
      {
        return Column(
          children: [
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  return NotesItem(notesData[index],_getData);
                },
                itemCount: notesData.length,
                padding: EdgeInsets.all(10),),
            ),
          ],
        );
      }
    else
      {
        return const Center(child: Text('Create Note',style:TextStyle(color:Colors.black,fontSize:18,fontWeight: FontWeight.w600),),);
      }

  /*  return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          return NotesItem(notesData[index]);
        },
        itemCount: notesData.length,
        padding: EdgeInsets.all(10),
      ),
    );*/
  }
}
