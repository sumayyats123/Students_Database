
import 'dart:io';

import 'package:basics/database/databasesqflite.dart';
import 'package:basics/search.dart';
import 'package:basics/studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentDetailsPage extends StatefulWidget {
 const StudentDetailsPage({super.key});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final formkey=GlobalKey<FormState>();
  final studentidcontroller=TextEditingController();
  final studentNamecontroller=TextEditingController();
  final agecontroller=TextEditingController();
  final departcontroller=TextEditingController();
  final phonenocontroller=TextEditingController();
  File? selectedimage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(
            title: const Text('Student Information',
            style: TextStyle(
              color: Colors.black,
            
            ),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 229, 42, 29),
            actions: [IconButton(onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const SearchPage()));
            }, icon: const Icon(Icons.person_search,color: Colors.black,))],
          ),
          
             body: SingleChildScrollView(
               child: Center(
               child: Padding(
                 padding: const EdgeInsets.all(15.0),
                 child:Form(key:formkey,
                   child: Column(
                   children: [const SizedBox(height: 40),
                   InkWell(onTap: ()async{File? pickedImage =
                   await selectimagefromGallery(context);
                   setState(() {
                     selectedimage = pickedImage;
                   });},
                     child: CircleAvatar(backgroundImage: selectedimage !=null?FileImage(selectedimage!):null,
                     radius: 60,
                      backgroundColor: const Color.fromARGB(255, 255, 43, 28),
                      child:selectedimage == null
                     ? const Icon(Icons.photo_camera,
                     size: 30 ,
                     color: Colors.black,
                      ):const Icon(null)
                     ),
                   ),
                   const SizedBox(
                    height:30 ,
                   ),
                   const SizedBox(
                    height: 30  ,
                   ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller:studentidcontroller,validator: (value) {if(value!.isEmpty)
                      {return"Enter your student ID ";}
                      else{return null;}
                    },
                     
                    decoration:const InputDecoration(border: OutlineInputBorder(),labelText: 'Student Id',prefixIcon: Icon(Icons.person_4  )),
                    ),
                   
                   const SizedBox(
                    height: 30  ,
                   ),

                   TextFormField(controller: studentNamecontroller,validator: (value) {if(value!.isEmpty)
                   {return "Please enter your name";} else if(value.length<3){
                    return "Atleast 3 charecters";
                   }else{return null;}
                     
                   },
                    decoration:const InputDecoration(border: OutlineInputBorder(),labelText: 'Student Name',prefixIcon: Icon(Icons.person)),
                    
                   ),
                   const SizedBox(
                    height: 30 ,
                   ),
                    TextFormField(controller: agecontroller,validator: (value) {if(value!.isEmpty)
                      {return"Enter your Age";}
                      else{return null;}
                    },
                     
                    decoration:const InputDecoration(border: OutlineInputBorder(),labelText: 'Age'),
                    ),
                     SizedBox(
                    height: 30 ,
                   ), TextFormField(controller: departcontroller,validator: (value) {if(value!.isEmpty){
                    return "Please enter your department";
                   }else{return null;}
                     
                   },
                    decoration:InputDecoration(border: OutlineInputBorder(),labelText: 'Department ',prefixIcon: Icon(Icons.school)
                    ),
                    ),
                     SizedBox(
                    height: 30 ,
                     ),
                      TextFormField(controller: phonenocontroller,validator: (value) {if(value!.isEmpty){
                        return " Please enter your phone number ";
                      }
                      else if(value.length<=9||value.length>10){
                        return "Invalid number";
                      }else{
                        return null ;
                      }
                      
                        
                      },
                    decoration:InputDecoration(border: OutlineInputBorder(),labelText: 'Phone Number',prefixIcon: Icon(Icons.call)
                    ),
                     ),
                     SizedBox(
                      height: 40  ,
                     ),
                     SizedBox(width: double.infinity,
                     height: 40 ,
                       child: ElevatedButton(
                        onPressed: ()async{
                        if(formkey.currentState!.validate())
                        {
                          if(selectedimage !=null){
                              final student=  StudentModel(
                              department: departcontroller.text,
                              id: int.parse(studentidcontroller.text),
                              age: int.parse(agecontroller.text),
                              name: studentNamecontroller.text,
                              phonenumber: phonenocontroller.text,
                              imageurl: selectedimage!.path,
                            );
                            await addstudentToDB(student,context);
                            studentNamecontroller.clear();
                               agecontroller.clear();
                               departcontroller.clear();
                               phonenocontroller.clear();
                               studentidcontroller.clear();
                              setState(() {
                                selectedimage =null;
                              });
                          }
                          else{
                            snakBarFunction(context,
                            "Please select student image",
                            Colors.redAccent);
                          }

                         }
                       }, child: Text('SAVE ',style: TextStyle(color: Colors.black),
                       ),style:ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 34, 19))),
                     ),
                     SizedBox(height: 15),
                     SizedBox(
                      width: double.infinity ,
                      height:40 ,
                       child: OutlinedButton(
                        style: OutlinedButton.styleFrom(side: BorderSide(color: const Color.fromARGB(255, 237, 37, 23),
                        
                        ),
                        ),
                        
                        
                        onPressed: (){studentNamecontroller.clear();
                        agecontroller.clear();
                        departcontroller.clear();
                        phonenocontroller.clear();
                        studentidcontroller.clear();

                        }, child: Text("Clear",
                       style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black),
                       ),
                       ),
                     ),
                   ], 
                   
                   ),
                 ),
               ),
                       ),
             ),
         
      ),
    );
  }
}
Future<File?> selectimagefromGallery (BuildContext context)async{
File? image;
try{
  final pickedImage =  
  await ImagePicker().pickImage(source: ImageSource.gallery);
  if(pickedImage != null){
    image = File(pickedImage.path);
  }
}catch(error){
snakBarimage(error.toString(), context);
}return image;
}
void snakBarimage(String content,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(content)));
}
void snakBarFunction(BuildContext context,String content,Color color){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(content),backgroundColor: color,));
}