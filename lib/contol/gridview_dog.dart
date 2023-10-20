import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petkub2/All%20data%20dog/dog_first.dart';

class MyDataOdDog extends StatefulWidget {
  const MyDataOdDog({Key? key}) : super(key: key);

  @override
  State<MyDataOdDog> createState() => _MyDataOdDogState();
}

enum DogStatus {
  all,
  father,
  mother,
  son,
  sold,
  sell,
  male,
  female,
  pom,
  yok,
  bloo
}

class _MyDataOdDogState extends State<MyDataOdDog> {
  CollectionReference dogCollection =
      FirebaseFirestore.instance.collection("dog");

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    dogCollection = FirebaseFirestore.instance.collection("dog");
  }

  final firstMatchIndex = 0;
  String search = '';
  String searchQuery = '';
  String dadsearchQuery = '';
  String momsearchQuery = '';
  TextEditingController searchController = TextEditingController();

  void debouncedSearch(String value) {
    if (selectedSearchType == 'all') {
      setState(() {
        searchQuery = value;
      });
    } else if (selectedSearchType == 'father') {
      setState(() {
        dadsearchQuery = value;
      });
    } else if (selectedSearchType == 'mother') {
      setState(() {
        momsearchQuery = value;
      });
    }
  }

  DogStatus selectedStatus = DogStatus.all;

  String? selectedSearchType = 'all';
  List<String> selectedSpecies = [];

  List<String> selectedSex = [];

  List<String> selectedVaccine = [];

  List<String> selectedColor = [];

  void toggleSelection(String option, List<String> selectedList) {
    setState(() {
      if (selectedList.contains(option)) {
        selectedList.remove(option);
      } else {
        selectedList.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      appBar: AppBar(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(83, 129, 36, 1),
        title: const Text('ข้อมูลสุนัข'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dogCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('ไม่มีข้อมูลสุนัข'),
            );
          }

          final dogs = snapshot.data!.docs;

          final filteredDogs = dogs.where((dog) {
            final dogData = dog.data() as Map<String, dynamic>;
            final idDog = dogData['id_dog'] ?? '';
            final idMom = dogData['mom'] ?? '';
            final idDad = dogData['dad'] ?? '';
            final dogStatus = dogData['Dogstatus'] ?? '';
            final status = dogData['status'] ?? '';
            final sell = dogData['Status_sell'] ?? '';
            final sex = dogData['sex'] ?? '';
            final species = dogData['species'] ?? '';
            final vaccine1 = dogData['vaccinetype1'] ?? '';
            final vaccine2 = dogData['vaccinetype2'] ?? '';
            final color = dogData['color'] ?? '';
            bool isFiltered = false;

            if (selectedSpecies.isNotEmpty &&
                !selectedSpecies.contains(species.toLowerCase())) {
              isFiltered = true;
            }

            // Apply filter logic based on selectedSex
            if (selectedSex.isNotEmpty &&
                !selectedSex.contains(sex.toLowerCase())) {
              isFiltered = true;
            }
            if (selectedVaccine.isNotEmpty &&
                !selectedVaccine.contains(vaccine1.toLowerCase()) &&
                !selectedVaccine.contains(vaccine2.toLowerCase())) {
              isFiltered = true;
            }
            if (selectedColor.isNotEmpty &&
                !selectedColor.contains(color.toLowerCase())) {
              isFiltered = true;
            }

            switch (selectedStatus) {
              case DogStatus.all:
                break;
              case DogStatus.father:
                if (status != 'พ่อพันธุ์') {
                  return false;
                }
                break;
              case DogStatus.mother:
                if (status != 'แม่พันธุ์') {
                  return false;
                }
                break;
              case DogStatus.son:
                if (status != 'อื่นๆ') {
                  return false;
                }
                break;
              case DogStatus.sold:
                if (sell != 'มีบ้านแล้ว') {
                  return false;
                }
                break;
              case DogStatus.sell:
                if (sell != 'กำลังหาบ้าน') {
                  return false;
                }
                break;
              case DogStatus.male:
                if (sex != 'เพศผู้') {
                  return false;
                }
                break;
              case DogStatus.female:
                if (sex != 'เพศเมีย') {
                  return false;
                }
                break;
              case DogStatus.pom:
                if (species != 'ปอมเมอเรเนียน') {
                  return false;
                }
                break;
              case DogStatus.yok:
                if (species != 'ยอร์คเชียร์เทอร์เรีย') {
                  return false;
                }
                break;
              case DogStatus.bloo:
                if (species != 'บลูด็อก') {
                  return false;
                }
                break;
            }

            return (idDog.contains(searchQuery) &&
                !isFiltered &&
                idDad.contains(dadsearchQuery) &&
                idMom.contains(momsearchQuery) &&
                dogStatus.contains(search));
          }).toList();
          final totalDogsCount = dogs.length;
          int fatherCount = 0;
          int motherCount = 0;
          int babyCount = 0;
          int maleCount = 0;
          int femaleCount = 0;
          int sellCount = 0;
          int soldCount = 0;
          int pomCount = 0;
          int yokCount = 0;
          int blueCount = 0;

          //  เงื่อนไขในการนับจำนวนสุนัข
          if (selectedStatus == DogStatus.father) {
            fatherCount =
                dogs.where((doc) => doc['status'] == 'พ่อพันธุ์').length;
          } else if (selectedStatus == DogStatus.mother) {
            motherCount =
                dogs.where((doc) => doc['status'] == 'แม่พันธุ์').length;
          } else if (selectedStatus == DogStatus.son) {
            babyCount = dogs.where((doc) => doc['status'] == 'อื่นๆ').length;
          } else if (selectedStatus == DogStatus.male) {
            maleCount = dogs.where((doc) => doc['sex'] == 'เพศผู้').length;
          } else if (selectedStatus == DogStatus.female) {
            femaleCount = dogs.where((doc) => doc['sex'] == 'เพศเมีย').length;
          } else if (selectedStatus == DogStatus.sell) {
            sellCount =
                dogs.where((doc) => doc['Status_sell'] == 'กำลังหาบ้าน').length;
          } else if (selectedStatus == DogStatus.sold) {
            soldCount =
                dogs.where((doc) => doc['Status_sell'] == 'มีบ้านแล้ว').length;
          } else if (selectedStatus == DogStatus.pom) {
            pomCount =
                dogs.where((doc) => doc['species'] == 'ปอมเมอเรเนียน').length;
          } else if (selectedStatus == DogStatus.yok) {
            yokCount = dogs
                .where((doc) => doc['species'] == 'ยอร์คเชียร์เทอร์เรีย')
                .length;
          } else if (selectedStatus == DogStatus.bloo) {
            blueCount = dogs.where((doc) => doc['species'] == 'บลูด็อก').length;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 105,
                      child: DropdownButtonFormField<String>(
                        value: selectedSearchType,
                        onChanged: (value) {
                          setState(() {
                            selectedSearchType = value;
                          });
                          searchController.clear();
                          debouncedSearch('');
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'all',
                            child: Text('ทั้งหมด'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'father',
                            child: Text('ลูกพ่อ'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'mother',
                            child: Text('ลูกแม่'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(229, 227, 227, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: searchController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'ค้นหาด้วยรหัสสุนัข',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      searchController.clear();
                                      debouncedSearch('');
                                    },
                                    child: const Icon(Icons.cancel),
                                  ),
                                ),
                                onChanged: (val) {
                                  EasyDebounce.debounce(
                                    'searchDebounce', // debounce identifier
                                    const Duration(
                                        milliseconds: 800), // debounce duration
                                    () => debouncedSearch(
                                        val), // function to be executed
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showFilterBottomSheet(context);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(229, 227, 227, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/sort.png',
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  right: 8,
                  left: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedStatus = DogStatus.all;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: selectedStatus == DogStatus.all
                              ? const Color.fromRGBO(229, 227, 227, 1)
                              : const Color.fromRGBO(229, 227, 227, 1),
                        ),
                        child: const Text(
                          '  ทั้งหมด ',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.father, 'พ่อพันธุ์',
                          const Color.fromRGBO(255, 228, 193, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.mother, 'แม่พันธุ์',
                          const Color.fromRGBO(255, 253, 146, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.son, 'ลูก',
                          const Color.fromRGBO(207, 255, 203, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.sold, 'ขายแล้ว',
                          const Color.fromRGBO(218, 255, 246, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.sell, 'กำลังหาบ้าน',
                          const Color.fromRGBO(218, 212, 255, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.male, 'เพศผู้',
                          const Color.fromRGBO(255, 226, 235, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.female, 'เพศเมีย',
                          const Color.fromRGBO(255, 228, 193, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.pom, 'ปอมเมอเรเนียน',
                          const Color.fromRGBO(255, 253, 146, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.yok, 'ยอร์คเชียร์เทอร์เรีย',
                          const Color.fromRGBO(207, 255, 203, 1)),
                      const SizedBox(
                        width: 10,
                      ),
                      buildStatusButton(DogStatus.bloo, 'บลูด็อก',
                          const Color.fromRGBO(218, 255, 246, 1))
                    ],
                  ),
                ),
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (selectedStatus == DogStatus.all)
                    textCount('ทั้งหมด : $totalDogsCount  ตัว'),
                  if (selectedStatus == DogStatus.father)
                    textCount('พ่อพันธุ์: $fatherCount  ตัว'),
                  if (selectedStatus == DogStatus.mother)
                    textCount('แม่พันธุ์: $motherCount  ตัว'),
                  if (selectedStatus == DogStatus.son)
                    textCount('ลูก: $babyCount  ตัว'),
                  if (selectedStatus == DogStatus.sold)
                    textCount('สนุัขที่ขายแล้ว: $soldCount  ตัว'),
                  if (selectedStatus == DogStatus.sell)
                    textCount('สุนัขที่หาบ้าน: $sellCount  ตัว'),
                  if (selectedStatus == DogStatus.male)
                    textCount('เพศผู้: $maleCount  ตัว'),
                  if (selectedStatus == DogStatus.female)
                    textCount('เพศเมีย: $femaleCount  ตัว'),
                  if (selectedStatus == DogStatus.pom)
                    textCount('พันธุ์ปอมเมอเรีเนียน: $pomCount  ตัว'),
                  if (selectedStatus == DogStatus.yok)
                    textCount('พันธุ์ยอร์คทิเซีย: $yokCount  ตัว'),
                  if (selectedStatus == DogStatus.bloo)
                    textCount('พันธุ์บลูด็อก: $blueCount  ตัว'),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GridView.builder(
                    reverse: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemCount: filteredDogs.length,
                    itemBuilder: (context, index) {
                      final dogData =
                          filteredDogs[index].data() as Map<String, dynamic>;
                      final idDog = dogData['id_dog'] ?? '';
                      final status = dogData['status'] ?? '';
                      final species = dogData['species'] ?? '';
                      final sex = dogData['sex'] ?? '';
                      // final date = dogData['date_of_birth'] ?? '';

                      final imageprofile = dogData['profileImage'] ?? '';
                      final sell = dogData['Status_sell'] ?? '';
                      final price = dogData['price'] ?? '';
                      bool isSoldOut = sell == 'มีบ้านแล้ว';
                      // final age = calculateAge(date);
                      // final ageString = '${age.years} ปี ${age.months} เดือน';

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfileDog(
                                      dog: filteredDogs[index].reference)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              if (isSoldOut)
                                Positioned(
                                    left: 7,
                                    child: Image.asset(
                                      'images/sold.png',
                                      height: 35,
                                    )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 45,
                                      backgroundColor: const Color.fromRGBO(
                                          159, 203, 114, 1),
                                      child: CircleAvatar(
                                        radius: 43,
                                        backgroundImage:
                                            NetworkImage(imageprofile),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$status : $idDog',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '$species | $sex',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 3,
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '฿ $price',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget textCount(String title) => Padding(
        padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
  Widget buildStatusButton(DogStatus status, String label, Color color) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedStatus = status;
        });
      },
      style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: color),
      child: Text(
        '  $label  ',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'สายพันธุ์',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FilterChip(
                            label: const Text('ปอมเมอเรเนียน'),
                            selected: selectedSpecies.contains('ปอมเมอเรเนียน'),
                            onSelected: (bool value) {
                              setState(() {
                                setState(() {
                                  toggleSelection(
                                      'ปอมเมอเรเนียน', selectedSpecies);
                                });
                              });
                            }),
                      ),
                      Expanded(
                        child: FilterChip(
                            label: const Text('ยอร์คเชียร์เทอร์เรีย'),
                            selected: selectedSpecies
                                .contains('ยอร์คเชียร์เทอร์เรีย'),
                            onSelected: (bool value) {
                              setState(() {
                                toggleSelection(
                                    'ยอร์คเชียร์เทอร์เรีย', selectedSpecies);
                              });
                            }),
                      ),
                      Expanded(
                        child: FilterChip(
                            label: const Text('บลูด็อก'),
                            selected: selectedSpecies.contains('บลูด็อก'),
                            onSelected: (bool value) {
                              setState(() {
                                toggleSelection('บลูด็อก', selectedSpecies);
                              });
                            }),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'เพศ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: FilterChip(
                              label: const Text('เพศผู้'),
                              selected: selectedSex.contains('เพศผู้'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('เพศผู้', selectedSex);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('เพศเมีย'),
                              selected: selectedSex.contains('เพศเมีย'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('เพศเมีย', selectedSex);
                                });
                              })),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'วัคซีน',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: FilterChip(
                              label: const Text('พาร์โวไวรัส'),
                              selected: selectedVaccine.contains('พาร์โวไวรัส'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection(
                                      'พาร์โวไวรัส', selectedVaccine);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('ไวรัสไข้หัดสุนัข'),
                              selected:
                                  selectedVaccine.contains('ไวรัสไข้หัดสุนัข'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection(
                                      'ไวรัสไข้หัดสุนัข', selectedVaccine);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('เรบีส์ (พิษสุนัขบ้า)'),
                              selected: selectedVaccine
                                  .contains('เรบีส์ (พิษสุนัขบ้า)'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection(
                                      'เรบีส์ (พิษสุนัขบ้า)', selectedVaccine);
                                });
                              })),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: FilterChip(
                              label: const Text('พาราอินฟลูเอนซ่าไวรัส'),
                              selected: selectedVaccine
                                  .contains('พาราอินฟลูเอนซ่าไวรัส'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection(
                                      'พาราอินฟลูเอนซ่าไวรัส', selectedVaccine);
                                });
                              })),
                    ],
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'สีสุนัข',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: FilterChip(
                              label: const Text('ส้ม'),
                              selected: selectedColor.contains('ส้ม'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('ส้ม', selectedColor);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('แบล็คแทน'),
                              selected: selectedColor.contains('แบล็คแทน'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('แบล็คแทน', selectedColor);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('บีเวอร์'),
                              selected: selectedColor.contains('บีเวอร์'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('บีเวอร์', selectedColor);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('ไตรคัลเลอร์'),
                              selected: selectedColor.contains('ไตรคัลเลอร์'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('ไตรคัลเลอร์', selectedColor);
                                });
                              })),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: FilterChip(
                              label: const Text('ขาว'),
                              selected: selectedColor.contains('ขาว'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('ขาว', selectedColor);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('ปาร์ตี้'),
                              selected: selectedColor.contains('ปาร์ตี้'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('ปาร์ตี้', selectedColor);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('ส้มอ่อน'),
                              selected: selectedColor.contains('ส้มอ่อน'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('ส้มอ่อน', selectedColor);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('ครีม'),
                              selected: selectedColor.contains('ครีม'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('ครีม', selectedColor);
                                });
                              })),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: FilterChip(
                              label: const Text('ขาวดำ'),
                              selected: selectedColor.contains('ขาวดำ'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('ขาวดำ', selectedColor);
                                });
                              })),
                      Expanded(
                          child: FilterChip(
                              label: const Text('ช็อกโกแลต'),
                              selected: selectedColor.contains('ช็อกโกแลต'),
                              onSelected: (bool value) {
                                setState(() {
                                  toggleSelection('ช็อกโกแลต', selectedColor);
                                });
                              })),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedSpecies.clear();
                                  selectedSex.clear();
                                  selectedVaccine.clear();
                                  selectedColor.clear();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor:
                                    const Color.fromRGBO(159, 203, 114, 1),
                              ),
                              child: const Text(
                                '        ล้าง       ',
                                style: TextStyle(color: Colors.black),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }),
          );
        });
  }
}
