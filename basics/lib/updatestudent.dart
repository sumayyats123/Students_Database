import 'dart:io';

import 'package:basics/addstudent.dart';
import 'package:basics/database/databasesqflite.dart';
import 'package:basics/search.dart';
import 'package:basics/studentmodel.dart';
import 'package:flutter/material.dart';

class UpdateStudent extends StatefulWidget {
  const UpdateStudent(
  {super.key,
  required this.id,
  required this.name,
  required this.age,
  required this.department,
 required this.number, 
required this.imagesrc});

final int id;
final String name;
final int age;
final String department;
final double number;
final dynamic imagesrc;




  @override
  State<UpdateStudent> createState() => _MyWidgetState();
 




}
class _MyWidgetState extends State<UpdateStudent >{


  final formkey=GlobalKey<FormState>();
  File? selectedimage;

  late  TextEditingController studentidcontroller;
  late  TextEditingController studentNamecontroller;
  late  TextEditingController  agecontroller;
  late  TextEditingController  departcontroller;
  late  TextEditingController  phonenocontroller;
  



  @override
  
  void initState(){
  
   int number =widget.number.toInt();
    
   studentidcontroller=TextEditingController(text: widget.id.toString());
   studentNamecontroller=TextEditingController(text: widget.name);
   agecontroller=TextEditingController(text: widget.age.toString());
   departcontroller=TextEditingController(text: widget.department);
   phonenocontroller=TextEditingController(text: number.toString());
   super.initState();
  
  }



  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
            title: const Text('Update Student Information',
            style: TextStyle(
              color: Colors.black,
            
            ),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 229, 42, 29),
            
          ),
          
             body: SingleChildScrollView(
               child: Center(
               child: Padding(
                 padding: const EdgeInsets.all(15.0),
                 child:Form(key:formkey,
                   child: Column(
                   children: [
                    const SizedBox(height: 40),
                   InkWell(onTap: ()async{File? pickedImage =
                   await selectimagefromGallery(context);
                   setState(() {
                     selectedimage = pickedImage;
                   });},
                     child: CircleAvatar(backgroundImage: selectedimage !=null?FileImage(selectedimage!):FileImage(File(widget.imagesrc!)),
                     radius: 60,
                      backgroundColor: const Color.fromARGB(255, 255, 43, 28),
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
                     const SizedBox(
                    height: 30 ,
                   ), TextFormField(controller: departcontroller,validator: (value) {if(value!.isEmpty){
                    return "Please enter your department";
                   }else{return null;}
                     
                   },
                    decoration:const InputDecoration(border: OutlineInputBorder(),labelText: 'Department ',prefixIcon: Icon(Icons.school)
                    ),
                    ),
                     const SizedBox(
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
                    decoration:const InputDecoration(border: OutlineInputBorder(),labelText: 'Phone Number',prefixIcon: Icon(Icons.call)
                    ),
                     ),
                     const SizedBox(
                      height: 40  ,
                     ),
                     SizedBox(width: double.infinity,
                     height: 40 ,
                    
                   
                       child : ElevatedButton(
                        onPressed: ()async{
                        if(formkey.currentState!.validate())
                        {
                          if(selectedimage !=null||widget.imagesrc!=null){
                              final student=  StudentModel(
                              department: departcontroller.text,
                              id: int.parse(studentidcontroller.text),
                              age: int.parse(agecontroller.text),
                              name: studentNamecontroller.text,
                              phonenumber: phonenocontroller.text,
                              imageurl:selectedimage!=null? selectedimage!.path:widget.imagesrc,
                            );
                            await updateStudentDetailsFrom(student);
                            studentNamecontroller.clear();
                               agecontroller.clear();
                               departcontroller.clear();
                               phonenocontroller.clear();
                               studentidcontroller.clear();
                              setState(() {
                                selectedimage =null;
                              });
                              // ignore: use_build_context_synchronously
                              snakBarFunction(context, "Uploaded sucessfully", Colors.green);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchPage(),));
                          }
                          else{
                            snakBarFunction(context,
                            "Please select student image",
                            Colors.redAccent);
                          }

                         }
                       }, child: const Text('Update',style: TextStyle(color: Colors.black),
                       ),style:ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 34, 19))),
                     ),
                 
                     const SizedBox(height: 15),
                     SizedBox(
                      width: double.infinity ,
                      height:40 ,
                       child: OutlinedButton(
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color.fromARGB(255, 237, 37, 23),
                        
                        ),
                        ),
                        
                        
                        onPressed: (){studentNamecontroller.clear();
                        agecontroller.clear();
                        departcontroller.clear();
                        phonenocontroller.clear();
                        studentidcontroller.clear();

                        }, child: const Text("Clear",
                       style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black),
                       ),
                       ),
                     ),

                   
                   ],
               ),
                       ),
             )
    ),
             ),
    );
         
      
  }
}