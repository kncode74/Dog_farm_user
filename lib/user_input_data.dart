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
        if (formKey.currentState!.validate()) {
          return await collectionRef.doc(currentUser.email).set({
            'date_of_birth': dateController.text,
            'career': careerController.text,
            'income': incomeController.text,
            'sex': sexController.text,
            'status': statusController.text,
            "Email": currentUser.email,
            'image': currentUser.photoURL,
          });
        }
      } catch (error) {
        // ignore: avoid_print
        print("Something went wrong. $error");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all the required fields.')),
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

  Future<void> selectDateFromPicker(BuildContext context, value) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 10),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        value.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  List<String> job = [
    'อาชีพอิสระ',
    'อาชีพรับจ้าง',
    'อาชีพรับข้าราชการ',
    'พนักงานออฟฟิศ',
    'เจ้าของธุรกิจ/ค้าขาย',
    'Infurencer',
  ];
  List<String> income = [
    'ตำ่กว่า 10 000 บาท',
    '10 000-20 000',
    '20 000-30 000',
    'มากกว่า 30 000 บาท'
  ];
  List<String> sex = ['ชาย', 'หญิง'];
  List<String> status = ['โสด(ตัวคนเดียว)', 'มีครอบครัว'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/logo.png',
                      height: 150,
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ลงทะเบียนเจ้าของฟาร์ม',
                      style: TextStyle(fontSize: 23),
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'กรอกข้อมูลสำหรับฟาร์มสุนัข',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'วันเกิด',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            selectDateFromPicker(context, dateController),
                        icon: const Icon(Icons.calendar_today_outlined),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกวันเกิด';
                    }
                    return null;
                  },
                ),
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
                ElevatedButton(
                  onPressed: () {
                    sendUserDataToDB();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyNavigator()));
                  },
                  child: const Text('Continue'),
                ),
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
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        labelText: label,
        suffixIcon: DropdownButton<String>(
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return hinttext;
        }
        return null;
      },
    );
  }
}
