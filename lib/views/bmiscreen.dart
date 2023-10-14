import 'package:bmilogin/functions/bmifunctions.dart';
import 'package:bmilogin/models/bmidatamodel.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final appfunctions = Functions();
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String? _gender;
  DateTime? _selectedDate;
  int _age = 0;
  double? _bmi;
  String? _comment;
  String? address;
  double weight = 0.0;
  String? name;
  double? height;
  String data = '';

  void submit() {
    setState(() {
      // weight = double.parse(_weightController.text);
      // double height = weight / 100.0; // Convert height from cm to meters

      // Calculate age
      DateTime currentDate = DateTime.now();
      _age = currentDate.year - _selectedDate!.year;
      if (currentDate.month < _selectedDate!.month ||
          (currentDate.month == _selectedDate!.month &&
              currentDate.day < _selectedDate!.day)) {
        _age--;
      }

      // Calculate BMI
      _bmi = weight / ((height! / 100) * (height! / 100));
      // _bmi = weight! / (height * height);
      // _bmi = bmi.toStringAsFixed(2);

      // Check BMI threshold and add comment
      if (_bmi! < 18.5) {
        _comment = 'Oops!underweight Person';
      } else if (_bmi! >= 18.5 && _bmi! < 25) {
        _comment = 'Enjoy! Healthy Person';
      } else if (_bmi! >= 25 && _bmi! < 30) {
        _comment = 'Oops! overweight Person';
      } else {
        _comment = 'Obese Person';
      }
    });
  }

  void resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      _addressController.clear();
      _nameController.clear();
      _weightController.clear();
      _heightController.clear();
      _gender = null;
      _selectedDate = null;
      _age = 0;
      _bmi = null;
      _comment = null;
      address = null;
      weight = 0.0;
      name = null;
      height = null;
      data = '';
    });
  }

  String? printData() {
    if (_formKey.currentState!.validate()) {
      submit();

      data = '';
      data += '✓ User Name: ${_nameController.text}\n';
      data += '✓ Address: ${_addressController.text}\n';
      data += '✓ Gender: $_gender\n';
      data +=
          '✓ Date of Birth: ${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}\n';
      data += '✓ Age: $_age\n';
      data += '✓ Weight: $weight kg\n';
      data += '✓ Height: $height cm\n';
      data += '✓ BMI: ${_bmi?.toStringAsFixed(2)}\n';
      data += '✓ Comment: $_comment';
    }
  }

  printAll() {
    print(_nameController.text);
    print(_addressController.text);
    print(_gender!);
    print(_bmi!.toStringAsFixed(2));
    print(_comment!);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(19980),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
      ),
      body: Container(
        // Background color for the column
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Gender:'),
                    Radio(
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    Icon(Icons.male),
                    Text('Male'),
                    Radio(
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    Icon(Icons.female),
                    Text('Female'),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Date of Birth:'),
                    SizedBox(width: 10.0),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        setState(() {
                          if (selectedDate == null) {
                            final selectedDate = DateTime.now();
                          } else {
                            _selectedDate = selectedDate;
                          }
                        });
                      },
                      icon: Icon(Icons.calendar_month),
                      label: Text('Select Date'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Icons.balance),
                  ),
                  onChanged: (value) {
                    setState(() {
                      weight = double.tryParse(value) ?? 0.0;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your weight';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.straighten),
                  ),
                  onChanged: (value) {
                    setState(() {
                      height = double.tryParse(value) ?? 0.0;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    printAll();
                    printData();
                    final bmidata = BmiDatModel(
                        name: _nameController.text,
                        address: _addressController.text,
                        gender: _gender!,
                        bmi: _bmi!.toStringAsFixed(2),
                        bmiComment: _comment!);
                    appfunctions.addBmiData(bmidata);
                    if (_formKey.currentState!.validate()) {
                      submit();

                      // ignore: unused_local_variable
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Calculate BMI'),
                      SizedBox(width: 8.0),
                      Icon(Icons.calculate),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: resetForm,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Reset'),
                      SizedBox(width: 8.0),
                      Icon(Icons.refresh),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                if (_bmi != null)
                  Column(
                    children: [
                      Text(
                        data,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )

                      // Text(
                      //   'BMI: ${_bmi?.toStringAsFixed(2)}',
                      //   style: TextStyle(
                      //     fontSize: 20.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // SizedBox(height: 8.0),
                      // Text(
                      //   'Comment: $_comment',
                      //   style: TextStyle(
                      //     fontSize: 20.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          printData();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('User Information'),
                content: Text(data),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.print),
      ),
    );
  }
}
