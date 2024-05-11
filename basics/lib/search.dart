import 'dart:io';

import 'package:basics/addstudent.dart';
import 'package:basics/database/databasesqflite.dart';
import 'package:basics/updatestudent.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}
 List <Map<String,dynamic>> _studentData = [];
// ignore: non_constant_identifier_names
final SearchController= TextEditingController();



class _SearchPageState extends State<SearchPage> {
  Future<void>fetchStudentData()async{
  List<Map<String,dynamic>>students = await getAllStudentDataFrom();
  if (SearchController.text.isNotEmpty) {
    students=students.where((student) =>student["studentname"].toString().toLowerCase().contains(SearchController.text.toLowerCase())).toList();
  }
  setState((){
    _studentData = students;
   
  });
}

 @override
  void initState(){
  fetchStudentData();
  super.initState();
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text('STUDENT LIST ',
          style: TextStyle(
            color: Colors.black,
          
          ),
          ),
          backgroundColor: const Color.fromARGB(255, 245, 37, 22),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [const SizedBox(
            height: 15 ,
            
          ),
          TextFormField(
            controller: SearchController,onChanged: (value) {
              fetchStudentData();
            },
                decoration:const InputDecoration(border: OutlineInputBorder(),labelText: 'Search  ',prefixIcon: Icon(Icons.search)
              ),
              ),const SizedBox(height: 10,),
           _studentData.isEmpty?const Text("Student data is not available..")   : Expanded(
                 child: ListView.separated(
                  itemCount: _studentData.length ,
                  itemBuilder: (context, index) {
                    final student =_studentData[index];
                    final id =student['id'];
                    final imageurl =student['imagesrc'];
                    final name = student['studentname'];
                 return ListTile(
                  title: Text(name),
                       leading: CircleAvatar(
                                   radius: 40,
                                   backgroundImage:FileImage(File(imageurl))
                       ),
                       subtitle: Text(id.toString()),
                     trailing: Row(mainAxisSize: MainAxisSize.min,children: [
                      IconButton(onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UpdateStudent(
                        id: id,
                        age: student['age'],
                        name: name,
                        department: student['department'],
                        imagesrc: imageurl,number: student['number'],
                      ),
                      ),);
                     }, 
                     icon: const Icon(Icons.edit)),IconButton(onPressed: () {showDialog(context: context, builder: (context){return(AlertDialog(title: const Text("Delete The Student Information"),
                     content: const Text("Are you sure you want to delete"),
                     actions: [
                      ElevatedButton(onPressed: (){
                        Navigator.of(context).pop();
                      },
                       child: const Text("Cancel")),
                     
                     ElevatedButton(onPressed: ()  async {

                    await  deleteStudentDetailsFrom(id);
                    fetchStudentData();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    snakBarFunction(context, "Successfully Delete the student Details", Colors.green);
                     },
                      child: const Text("Ok"))
                     
                     ],
                     
                     )
                     );
                     },
                     );
                     }, 
                     icon: const Icon(Icons.delete))
                     ],),); },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10 ,
                    );
                  },
                 ),
               ),
        ],
        ),
      ) ,
    
    );
  }
}