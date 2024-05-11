


import 'package:basics/addstudent.dart';
import 'package:basics/studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

late Database database;
Future<void>initializeDatabase()async{
  database =await openDatabase("student.db",version: 2,
onCreate: (Database database,int version)async{
    await database.execute(
      'CREATE TABLE student(id INTEGER PRIMARY KEY,studentname TEXT,age INTEGER,department TEXT,number REAL,imagesrc)'
    );
  },onUpgrade: (Database  database ,int oldversion,int newversion)async{
   if(oldversion< 2){
    await database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
   }
  });
}  
Future<void> addstudentToDB(StudentModel value,BuildContext context) async {

final existngRecord =await database.query(
  'student',
  where: 'id =?',
  whereArgs: [value.id],
);
if(existngRecord.isEmpty){
  await database.rawInsert(
     "INSERT INTO student(id,studentname,age,department,number,imagesrc)VALUES(?,?,?,?,?,?)",
 [
  value.id,
  value.name,
  value.age,
  value.department,
  value.phonenumber,
  value.imageurl
 ] );
 snakBarFunction(context ,"The student Details are upload successfuly", Colors.green );
}
 else{snakBarFunction(context ,"The student Id is also present in the database", Colors.red);
  }

}
Future<List<Map<String,dynamic>>>getAllStudentDataFrom()async{
  final value =await database.rawQuery("SELECT * FROM student"); 
  return value;
} 

Future<void>deleteStudentDetailsFrom(int id ) async{
  await database.rawDelete('DELETE FROM student WHERE id = ?', [id]);
}

Future<void> updateStudentDetailsFrom(StudentModel updatedStudent)async{
  final updateDta =await database.update(
    'student',{

   'id':updatedStudent.id,
   'studentname':updatedStudent.name,
   'age':updatedStudent.age,
   'department': updatedStudent.department,
   'number':updatedStudent.phonenumber,
   'imagesrc':updatedStudent.imageurl,


    },
    where: 'id=?',
    whereArgs: [updatedStudent.id] 
    );
}





