import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petkub2/bottom_navigator.dart';

class InputDataForUser extends StatefulWidget {
  const InputDataForUser({Key? key}) : super(key: key);

  @override
  State<InputDataForUser> createState() => _InputDataForUserState();
}

class _InputDataForUserState extends State<InputDataForUser> {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("customer");

  final TextEditingController dateController = TextEditingController();
  final TextEditingController careerController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  sendUserDataToDB() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;

    if (currentUser != null && currentUser.email != null) {
      try {
        final docSnapshot = await collectionRef.doc(currentUser.email).get();

        if (docSnapshot.exists) {
          // Document already exists, navigate to MyNavigator directly
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyNavigator()),
          );
        } else {
          // Document doesn't exist, add user data
          if (formKey.currentState!.validate()) {
            await collectionRef.doc(currentUser.email).set({
              'date_of_birth': dateController.text,
              'career': careerController.text,
              'income': incomeController.text,
              'sex': sexController.text,
              'status': statusController.text,
              'Email': currentUser.email,
              'image': currentUser.photoURL,
            });

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const MyNavigator()),
            // );
          }
        }
      } catch (error) {
        // ignore: avoid_print
        print("Something went wrong. $error");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the required fields.'),
        ),
      );
    }
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    collectionRef = FirebaseFirestore.instance.collection("customer");
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  final formKey = GlobalKey<FormState>();
  List<String> age = [
    'ต่ำกว่า 18 ปี',
    '18 - 20 ปี',
    '21 - 25 ปี',
    '26 - 30 ปี',
    '31 - 35 ปี',
    '36 - 40 ปี',
    '40 - 45 ปี',
    '46 - 50 ปี',
    'มากกว่า 50 ปี '
  ];
  List<String> job = [
    'อาชีพอิสระ',
    'อาชีพรับจ้าง',
    'อาชีพรับข้าราชการ',
    'พนักงานออฟฟิศ',
    'เจ้าของธุรกิจ/ค้าขาย',
    'Infurencer',
    'นักเรียน/นักศึกษา'
  ];
  List<String> income = [
    'ตำ่กว่า 10 000 บาท',
    '10 000-20 000',
    '20 000-30 000',
    'มากกว่า 30 000 บาท'
  ];
  List<String> sex = ['ชาย', 'หญิง', 'เพศทางเลือก', 'ไม่ระบุ'];
  List<String> status = ['โสด(ตัวคนเดียว)', 'มีครอบครัว'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/soonak Logo.png',
                      height: 120,
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ลงทะเบียนเพื่อดูข้อมูลสุนัข',
                      style: TextStyle(fontSize: 23),
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'กรอกข้อมูลส่วนตัว',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                widgetDropdown(dateController, age.join(','), dateController,
                    'กรอกอายุ', 'กรุณากรอกอายุ'),
                const SizedBox(height: 16),
                widgetDropdown(careerController, job.join(','),
                    careerController, 'กรอกอาชีพ', 'กรุณากรอกอาชีพ'),
                const SizedBox(height: 16),
                widgetDropdown(incomeController, income.join(','),
                    incomeController, 'กรอกรายได้ ', 'กรุณากรอกรายได้'),
                const SizedBox(height: 16),
                widgetDropdown(sexController, sex.join(','), sexController,
                    'กรอกเพศ', 'กรุณากรอกเพศ'),
                const SizedBox(height: 16),
                widgetDropdown(statusController, status.join(','),
                    statusController, 'กรอกสถานะ', 'กรุณากรอกสถานะ'),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(20, 39, 122, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () => sendUserDataToDB(),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '  บันทึกข้อมูล  ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )
                          ],
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetDropdown(TextEditingController controller, String list, data,
      String label, String hinttext) {
    List<String> valuesList =
        list.split(','); // Convert comma-separated string to a list

    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        labelText: label,
        suffixIcon: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: valuesList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
                onTap: () {
                  setState(() {
                    data.text = value;
                  });
                },
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return hinttext;
        }
        return null;
      },
    );
  }
}
