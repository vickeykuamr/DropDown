import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

import 'AddPlatform.dart';
import 'Notification/noi.dart';
import 'Notification/notification class.dart';


class Sfd extends StatefulWidget {
  const Sfd({Key? key}) : super(key: key);

  @override
  State<Sfd> createState() => _SfdState();
}

class _SfdState extends State<Sfd> {
  final List<String> items = [
    'Moradabad',
    'Varanasi',
    'delhi',

  ];
  String? selectedValue;
  final List<String> platform = [
    'PlatForm 1',
    'PlatForm 2',
    'PlatForm 3',
    'PlatForm 4',
  ];
  String? selectedValue2;

  List<String> list = [];
  List<String> stationlist =[];
  int itemLenght = 0;

  var voltage_phase1,voltage_phase2,voltage_phase3;
  var current_phase1,current_phase2,current_phase3;

  Future SfdApi (String station) async{
    var Sefurl = 'http://213.136.93.74/PowerManagementSystem/api/station?station=$station';
    try{
      var respones = await http.get(Uri.parse(Sefurl));
      if(respones.statusCode==200){
        var data = jsonDecode(respones.body.toString());
        for(int i= 0; i<data.length;i++){
          list.add(data[i]['platform']);
          
        }
        print(list);
      }else{}
    }catch(ex){
      print(ex);
    }
    setState(() {
    });
  }
  NotificationApi notificationApi =NotificationApi();

Future SfdUrl (String st,String pf) async{
    try{
      var uri ="http://213.136.93.74/PowerManagementSystem/api/Power_ms_get?Station=$st&platform=$pf";
      var res = await http.get(Uri.parse(uri));
      if(res.statusCode==200){
        print(res.body);
        var data2 = jsonDecode(res.body);

        voltage_phase1=data2[0]['voltage_phase1'].toString();
        current_phase1=data2[0]['current_phase1'].toString();
        voltage_phase2=data2[0]['voltage_phase2'].toString();
        current_phase2=data2[0]['current_phase2'].toString();
        voltage_phase3=data2[0]['voltage_phase3'].toString();
        current_phase3=data2[0]['current_phase3'].toString();

        volage1=double.parse(data2[0]['voltage_phase1']);
        volage2=double.parse(data2[0]['voltage_phase2']);
        volage3=double.parse(data2[0]['voltage_phase3']);
        Ampere1=double.parse(data2[0]['current_phase1']);
        Ampere2=double.parse(data2[0]['current_phase2']);
        Ampere3=double.parse(data2[0]['current_phase3']);

        print(volage1);
        print(volage2);
        print(volage3);
        
        if(volage1>=222){
          notificationApi.sendNotification(
              "Red Alert",
              "High Ampere");
        }
      }
    }catch(ex){}
}

Future SelectedStation () async{
    try{
      var ST ="http://213.136.93.74/PowerManagementSystem/api/StationName";
      var Station = await http.get(Uri.parse(ST));
      var stationdata = jsonDecode(Station.body);
      if(Station.statusCode==200){
        for(int i= 0; i<stationdata.length;i++){
          stationlist.add(stationdata[i]['station']);
        }
      }
    }catch(ex){}
  setState(() {
  });
}

double volage1 = 0.0;
double volage2 = 0.0;
double volage3 = 0.0;

double Ampere1 = 0.0;
double Ampere2 = 0.0;
double Ampere3 = 0.0;



@override
  void initState() {
    super.initState();
    SelectedStation();
    notificationApi.initialiseNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SFD"),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (contexr)=>Noti()));
        },icon: Icon(Icons.add)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Row(
                  children: [
                              //DropDown Station
                    Container(
                      width: 160,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: 3)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            'Select Station',
                            style: TextStyle(fontSize: 14, color: Them.of(context.hintColor),
                          ),
                          items: stationlist.map((item) =>
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
                          value: selectedValue,
                          onChanged: (value) {
                            SfdApi(value.toString());
                            list.clear();
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),              //DropDown Platform
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: 3)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            'PTF',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme
                                  .of(context)
                                  .hintColor,
                            ),
                          ),
                          items: list
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
                          value: selectedValue2,
                          onChanged: (value) {
                            setState(() {
                              selectedValue2 = value as String;
                            });
                            SfdUrl(selectedValue.toString(),value.toString());
                          },
                        ),
                      ),
                    ),
                  ],)
                ),
              ),
              SizedBox(height: 20,),
               Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              width: 320,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.red.shade200,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.black)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), 
                        child: Text("Phase 1", style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),),
                      )),
                  Center(child: Divider( thickness: 2,height: 1,color: Colors.black)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("voltage", style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w600,color: Colors.black),),
                            SizedBox(height: 7,),                               
                            Text(voltage_phase1.toString(), style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,color: Colors.black),),
                            Row(
                              children: [
                                volage1>=1 &&  volage1 < 250? Container(margin: EdgeInsets.only(left: 10), width: 20, height: 20, decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)
                                ),):Container(),
                                volage2>=1 && volage2 > 250 && volage2 < 260?Container(margin:
                                EdgeInsets.only(left: 13), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                volage3 >=1 && volage3 > 260?Container(margin:
                                EdgeInsets.only(left: 16), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("Ampere", style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w600,color: Colors.black),),
                            SizedBox(height: 7,),
                            Text(current_phase1.toString(), style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,color: Colors.black),),
                            Row(
                              children: [
                                Ampere1 > 1 && Ampere1 < 45?Container(margin:
                                EdgeInsets.only(left: 18), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                Ampere2 > 1 &&Ampere2 > 45 && Ampere2 < 55?Container(margin:
                                EdgeInsets.only(left: 13), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                Ampere3 > 1 && Ampere3 > 50?Container(margin:
                                EdgeInsets.only(left: 16), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.only(left: 20),
              width: 320,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.black)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Phase 2", style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),),
                      )),
                  Center(child: Divider( thickness: 2,height: 1,color: Colors.black)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(

                          children: [
                            Text("voltage", style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w600,color: Colors.black),),
                            SizedBox(height: 7,),
                            Text(voltage_phase2.toString(), style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,color: Colors.black),),
                            Row(
                              children: [
                                volage1>=1 && volage1 < 250? Container(margin:
                                EdgeInsets.only(left: 10), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                volage2>=1 &&  volage2 > 250 && volage2 < 260?Container(margin:
                                EdgeInsets.only(left: 13), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                volage3>=1 &&volage3 > 260?Container(margin:
                                EdgeInsets.only(left: 16), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("current", style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w600,color: Colors.black),),
                            SizedBox(height: 7,),
                            Text(current_phase2.toString(), style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,color: Colors.black),),
                            Row(
                              children: [
                                Ampere1 > 1 && Ampere1 < 45?Container(margin:
                                EdgeInsets.only(left: 18), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                Ampere2 > 1 && Ampere2 > 45 && Ampere2 < 55?Container(margin:
                                EdgeInsets.only(left: 13), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                Ampere3 > 1 && Ampere3 > 50?Container(margin:
                                EdgeInsets.only(left: 16), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
                SizedBox(height: 15,),
               Container(
              margin: EdgeInsets.only(left: 20),
              width: 320,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.black)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Phase 3", style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),),
                      )),
                  Center(child: Divider( thickness: 2,height: 1,color: Colors.black)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(

                          children: [
                            Text('voltage', style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w600,color: Colors.black),),
                            SizedBox(height: 7,),
                            Text(voltage_phase3.toString(), style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,color: Colors.black),),
                            Row(
                              children: [
                                volage1>=1 && volage1 < 250? Container(margin:
                                EdgeInsets.only(left: 10), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                volage2>=1 &&  volage2 > 250 && volage2 < 260?Container(margin:
                                EdgeInsets.only(left: 13), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                                volage3>=1 &&  volage3 > 260?Container(margin:
                                EdgeInsets.only(left: 16), width: 20, height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)
                                  ),):Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: EdgeInsets.only(top:10),
                          child: Column(
                            children: [
                              Text("current", style: TextStyle(fontSize: 15,
                                  fontWeight: FontWeight.w600,color: Colors.black),),
                              SizedBox(height: 7,),
                              Text(current_phase3.toString(), style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),),
                              Row(
                                children: [
                                  Ampere1 > 1 && Ampere1 < 45?Container(margin:
                                  EdgeInsets.only(left: 18), width: 20, height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10)
                                    ),):Container(),
                                  Ampere2 > 1 && Ampere2 > 45 && Ampere2 < 55?Container(margin:
                                  EdgeInsets.only(left: 13), width: 20, height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(10)
                                    ),):Container(),
                                  Ampere3 > 1 && Ampere3 > 50?Container(margin:
                                  EdgeInsets.only(left: 16), width: 20, height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10)
                                    ),):Container(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPlatfrom()));
          },
         child: Text("Add\nPTF"),),
    );
  }

}