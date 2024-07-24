import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location/location.dart';
import 'package:travelcompany/intro/thank_page.dart';

import '../location_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('users');

  LocationService? _locationService;

  LocationData? myLocation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _myPointController = TextEditingController();


  final TextEditingController _gasOilController = TextEditingController();
  final TextEditingController _gasCylinderController = TextEditingController();
  final TextEditingController _whiteOilController = TextEditingController();


  String _selectedValue = '';
  bool _isSelected = false;

  Map<String, int> items = {
    'زيت الغاز': 0,
    'اسطوانة الغاز': 0,
    'نفط أبيض': 0,
  };

  late final String documentId;

  final List<ContainerOption> _containerOptions = [
    ContainerOption(
        color: Colors.red,
        value: 1,
        title: 'طريق \n كربلاء – '
            'النجف'),
    ContainerOption(
        color: Colors.red, value: 2, title: 'طريق \n كربلاء – بابل'),
    ContainerOption(
        color: Colors.red,
        value: 3,
        title: 'طريق \n كربلاء – '
            'بغداد'),
    ContainerOption(
        color: Colors.red, value: 4, title: 'مركز \n المدينة القديمة'),
    ContainerOption(color: Colors.red, value: 5, title: 'قضاء \n الحسينية'),
    ContainerOption(color: Colors.red, value: 6, title: 'قضاء الهندية'),
    ContainerOption(color: Colors.red, value: 7, title: 'قضاء عين التمر'),
    ContainerOption(color: Colors.red, value: 8, title: 'قضاء الجدول الغربي'),
    ContainerOption(color: Colors.red, value: 9, title: 'قضاء الحر'),
  ];

  final List<ContainerOption> _containerOptionsValue = [
    ContainerOption(color: Colors.red, value: 1, title: ''),
  ];

  void _submitForm() async {


    if (_isSelected == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            dismissDirection:DismissDirection.up,
            content: Text('الرجاء اختر موقع الموكب')),
      );
      return;
    }
    if (myLocation == null) {

      getLocation();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            dismissDirection:DismissDirection.up,
            content: Text('الرجاء فتح خاصية تحديد المواقع في '
                'الهاتف')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> newData = {
          'name': _nameController.text,
          'phone': _phoneController.text,
          'mypoint': _myPointController.text,
          'position': _selectedValue,
          'زيت الغاز': _gasOilController.text,
          'اسطوانة الغاز': _gasCylinderController.text,
          'نفط أبيض': _whiteOilController.text,

          'lat': myLocation!.latitude,
          'long': myLocation!.longitude,
          'created_at': FieldValue.serverTimestamp(),
          // 'age': int.parse(_ageController.text),
        };
        DocumentReference? documentReference;
        await _collection.add(newData);
/*
        documentReference!.update({
          for (var item in items.entries) item.key: item.value,
        }).then((_) {


          print('Document successfully updated!');
        }).catchError((error) {
          print('Failed to update document: $error');
        });*/

        _nameController.text = '';
        _phoneController.text = '';
        _myPointController.text = '';
        _selectedValue = '';
        _isSelected = false;
        setState(() {
          items = {
            'زيت الغاز': 0,
            'اسطوانة الغاز': 0,
            'نفط أبيض': 0,
          };

        });

        print('Data added to Firestore');
        gotoThankPage();



      } catch (e) {
        print('Error adding data to Firestore: $e');
      }
    }
  }

  getLocation() async {
    var location = Location();
    myLocation = await location.getLocation();

    print(myLocation!.latitude);
    print(myLocation!.longitude);
  }
  gotoThankPage(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ThankPage()),
    );
  }

  @override
  void initState() {
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('شركة توزيع المنتجات النفطية'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [

                      Image.asset('assets/mawakeb.png', width: 100,),
                      TextFormField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'إسم كفيل الموكب'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'اكتب إسم الكفيل';
                          }
                          if (value!.length < 5) {
                            return 'أكتب الاسم الثلاثي';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType:TextInputType.phone,
                        decoration: const InputDecoration(
                            labelText: 'رقم هاتف كفيل '
                                'الموكب'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'ادخل رقم الهاتف';
                          }
                          if (!value.contains('0', 0) &&
                              !value.contains('٠', 0)) {
                            return 'الرقم غير صحيح';
                          }
                          if (value.length != 11)
                            return 'عدد أرقام الموبايل غير صحيح';
                          /* if (!value.contains('@')||!value.contains('.')) {
                            return 'Please enter real email';
                          }*/
                          // You can add more complex email validation here
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _myPointController,
                        decoration: const InputDecoration(
                            labelText: 'أقرب نقطة داله أو رقم'
                                ' أقرب عمود'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال اقرب نقطة داله';
                          }

                          return null;
                        },
                      ),

                      //   RadioButtonForm(),
                      // SizedBox(height: 20,),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('موقع  الموكب'),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          // spacing : 10.0,
                          crossAxisAlignment: WrapCrossAlignment
                              .center, // Aligns items with space
                          // between them
                          children: _containerOptions.map((option) {
                            bool isSelected = option.title == _selectedValue;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSelected = true;
                                  _selectedValue = option.title;
                                  if (kDebugMode) {
                                    print(_selectedValue);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width/4,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected ? option.color : Colors.grey,
                                    //  border: Border.all(color: option.color, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      option.title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _gasOilController,
                        decoration:
                        const InputDecoration(labelText: 'زيت الغاز'),

                      ),
                      TextFormField(
                        controller: _gasCylinderController,

                        decoration: const InputDecoration(
                            labelText: 'اسطوانة الغاز'),


                      ),
                      TextFormField(
                        controller: _whiteOilController,
                        decoration: const InputDecoration(
                            labelText: 'نفط أبيض'),

                      ),
                    ],
                  ),
                /*  Column(
                    children: items.keys.map((option) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(option, style: TextStyle(fontWeight:
                            FontWeight.bold, fontSize: 16),),
                          ),
                          IconButton(
                            onPressed: () => setState(
                                () => items[option] = items[option]! + 1),
                            icon: Icon(Icons.add),
                          ),
                          Text('${items[option]}'),
                          IconButton(
                            onPressed: () => setState(() {
                              if (items[option]! > 0)
                                items[option] = items[option]! - 1;
                            }),
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      );
                    }).toList(),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('ارسل'),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerOption {
  final Color color;
  final int value;
  final String title;

  ContainerOption(
      {required this.color, required this.value, required this.title});
}
