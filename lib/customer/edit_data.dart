import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditDataCustomer extends StatefulWidget {
  const EditDataCustomer({super.key});

  @override
  State<EditDataCustomer> createState() => _EditDataCustomerState();
}

class _EditDataCustomerState extends State<EditDataCustomer> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController dateController = TextEditingController();
  late TextEditingController careerController = TextEditingController();
  late TextEditingController incomeController = TextEditingController();
  late TextEditingController sexController = TextEditingController();
  late TextEditingController statusController = TextEditingController();
  CollectionReference custimerCollection =
      FirebaseFirestore.instance.collection("customer");

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final customerData = await custimerCollection.doc(currentUser.email).get();

    setState(() {
      sexController = TextEditingController(text: customerData['sex']);
      dateController =
          TextEditingController(text: customerData['date_of_birth']);
      statusController = TextEditingController(text: customerData['status']);
      incomeController = TextEditingController(text: customerData['income']);
      careerController = TextEditingController(text: customerData['career']);
    });
  }

  Future<void> saveChanges() async {
    try {
      if (formKey.currentState!.validate()) {
        await custimerCollection.doc(currentUser.email).update({
          'sex': sexController.text,
          'date_of_birth': dateController.text,
          'status': statusController.text,
          'career': careerController.text,
          'income': incomeController.text
        });

        formKey.currentState!.reset();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to update profile.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(159, 203, 114, 1),
        centerTitle: true,
        title: const Text(
          'แก้ไขข้อมูลส่วนตัว',
        ),
        actions: [
          InkWell(
            onTap: () async {
              saveChanges();
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 25),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
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
        border: const UnderlineInputBorder(),
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
