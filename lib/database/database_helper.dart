

import 'package:flutter/material.dart';
import 'package:path/path.dart'as path;
import 'package:sqflite/sqflite.dart';

import '../model/notes_model.dart';

String id='id';
String title='title';
String note='note';
String time='time';
String pass='pass';
String isPassProtected="isPassProtected";
//Database? database;
Future<Database> createDatabase() async
{
  var database=await openDatabase(path.join(await getDatabasesPath(),'notes.db'),onCreate: (db, version) {
    db.execute('CREATE TABLE notes($id INTEGER PRIMARY KEY AUTOINCREMENT,$title TEXT,$note TEXT,$time TEXT,$isPassProtected INTEGER)');
  },version:1);

  return database;
}


void insertData(String title1,String note1,String time1,int isPPC) async
{
  var database= await createDatabase();
  database.insert('notes',{
    title:title1,
    note:note1,
    time:time1,
    isPassProtected:isPPC
  });
}



Future<List<NotesModel>> getNotes() async
{
  var database=await createDatabase();
  List<Map<String, Object?>>? records=await database.query('notes');
 // var list=records.map((e) => NotesModel(e[id].toString(), e[title] as String, e[note] as String, e[time] as String)).toList();

  var list =List.generate(records?.length??0, (index){
    return NotesModel(records[index][id].toString(),records[index][title] as String?,records[index][note] as String?,records[index][time] as String?,records[index][isPassProtected] as int?);
  });
  return list;

}
void updateNote(String id,String title1,String note1,String time1,int isPPC) async
{ 
  var database=await createDatabase();
  database.update('notes', {title:title1, note:note1, time:time1,isPassProtected:isPPC},where:'id=$id');
}

void deleteNote(String id) async
{
  var database=await createDatabase();
  database.delete('notes',where:'id=$id');
}



Future<Database> createPwDatabase() async
{
  var database=await openDatabase(path.join(await getDatabasesPath(),'pw.db'),onCreate: (db, version) {
    db.execute('CREATE TABLE password($id INTEGER PRIMARY KEY AUTOINCREMENT,$pass TEXT)');
  },version:1);

  return database;
}

void insertPassword(String password) async
{
  var database= await createPwDatabase();
  database.insert('password',{
    pass:password,
  });
}

Future<String> getPassword() async
{
  var database=await createPwDatabase();
  List<Map<String, Object?>>? records=await database.query('password');
  // var list=records.map((e) => NotesModel(e[id].toString(), e[title] as String, e[note] as String, e[time] as String)).toList();


  if(records.isEmpty)
    {
      return '';
    }
  String str=records[0][pass] as String;

  return str;

}
