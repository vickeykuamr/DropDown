 import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPlatfrom extends StatefulWidget {
  const AddPlatfrom({Key? key}) : super(key: key);

  @override
  State<AddPlatfrom> createState() => _AddPlatfromState();
}

class _AddPlatfromState extends State<AddPlatfrom> {
  final List<String> platform2 = [
    'Station',
    'PlatForm'
  ];
  String? platform22;

  TextEditingController AddPlatfrom = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Platform"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(

              children: [
                Container(

                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 3)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .hintColor,
                        ),
                      ),
                      items: platform2
                          .map((item) =>
                          DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                          .toList(),
                      value: platform22,
                      onChanged: (value) {
                        setState(() {
                          platform22 = value as String;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Container(child: platform22 == 'Station' ? Container(child: Column(
                  children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 3)
                      ),
                      child: TextField(
                      ),
                    ),
                    SizedBox(height: 10,),
                    _Drop(),
                  ],
                ),) : null,),
                Container(child: platform22 == 'PlatForm' ? Container(child: Column(
                  children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 3)
                      ),
                      child: TextField(
                      ),
                    ),
                    SizedBox(height: 10,),
                    _Drop(),
                    SizedBox(height: 10,),
                    SecondDrop(),
                  ],
                ),) : null,),
                SizedBox(height: 20,),
                CupertinoButton(
                  color: Colors.black12,
                    child: Text("Add",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),), onPressed: (){})

              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<String> Division1 = [
    'Division 1',
    'Division 2',
    'Division 3',
  ];
  String? Divis1;

  Widget _Drop() {
    return Container(

      width: 300,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45, width: 3)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(
            'Division',
            style: TextStyle(
              fontSize: 14,
              color: Theme
                  .of(context)
                  .hintColor,
            ),
          ),
          items: Division1
              .map((item) =>
              DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
              .toList(),
          value: Divis1,
          onChanged: (value) {
            setState(() {
              Divis1 = value as String;
            });
          },
        ),
      ),
    );
  }
  final List<String> Plat1 = [
    'Station 1',
    'Station 2',
    'Station 3',
  ];
  String? Plat11;
  Widget SecondDrop() {
    return Container(

      width: 300,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45, width: 3)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(
            'Station',
            style: TextStyle(
              fontSize: 14,
              color: Theme
                  .of(context)
                  .hintColor,
            ),
          ),
          items: Plat1
              .map((item) =>
              DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
              .toList(),
          value: Plat11,
          onChanged: (value) {
            setState(() {
              Plat11 = value as String;
            });
          },
        ),
      ),
    );
  }
}