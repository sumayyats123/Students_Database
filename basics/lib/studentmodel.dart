class StudentModel {
final int? id;
final String name;
final int? age;
final String department;
final String imageurl;
final dynamic phonenumber;

  StudentModel(
    {required this.id,
    required this.name,
    required this.age,
    required this.department,
    required this.imageurl,
    required this.phonenumber});
}