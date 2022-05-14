import 'dart:convert';

import 'package:application3/models/messageTilawaModel1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageTestTeacher extends StatefulWidget {
   final String idtest;
  final String idstudent;
  final String username;
  const MessageTestTeacher({Key? key,required this.idstudent,required this.idtest,required this.username}) : super(key: key);

  @override
  State<MessageTestTeacher> createState() => _MessageTestTeacherState();
}

class _MessageTestTeacherState extends State<MessageTestTeacher> {

  final recorder=FlutterSoundRecorder();

  @override
  void initState(){
    super.initState();
    initRecorder();
  }

  @override
  void dispose(){
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async{
     final status=await Permission.microphone.request();
     if(status != PermissionStatus.granted){
       throw 'Microphone permission not granted';
     }

     await recorder.openRecorder();
     recorder.setSubscriptionDuration(
       const Duration(milliseconds: 500)
     );
  }

  Future record() async{
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async{
    await recorder.stopRecorder();
  }

  static Future<List<MessageTilawa>> getmessageTilawa(BuildContext context) async{
   final assetBundel = DefaultAssetBundle.of(context);
   final data= await assetBundel.loadString('assets/MessageTilawa.json');
   final body = json.decode(data);
   return body.map<MessageTilawa>(MessageTilawa.fromJson).toList();
  } 

  late String note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:   AppBar(
         leading: IconButton(icon: Icon(Icons.arrow_back,),onPressed: (){
        Navigator.of(context).pop();
      },),
        title: Row(
          children: [
             VerticalDivider(width: 20,),
             Text("18",style: TextStyle(fontFamily: 'Cairo'),),
             VerticalDivider(),
              Text("النساء",style: TextStyle(fontFamily: 'Cairo'),),
              VerticalDivider(width: 25,),
               Text("الى",style: TextStyle(fontFamily: 'Cairo'),),
               VerticalDivider(width: 20,),
               Text("20",style: TextStyle(fontFamily: 'Cairo'),),
               VerticalDivider(),
                Text("البقرة",style: TextStyle(fontFamily: 'Cairo'),),
                Text("من",style: TextStyle(fontFamily: 'Cairo'),),
          ],
        ),
             
        elevation: 10,
        backgroundColor: Colors.brown[400]
      ),
     
      body: Stack(
        children: <Widget>[
          
          Container(
            width: double.infinity,
            
            height: 600,
            child: FutureBuilder<List<MessageTilawa>>(
            future: getmessageTilawa(context),
            builder: (context,snapchot){
              final messagesTilawa=snapchot.data;
              return ListView.builder(
  itemCount: messagesTilawa?.length ??  0,
  shrinkWrap: true,
  padding: EdgeInsets.only(top: 10,bottom: 10),

  itemBuilder: (context, index){
    final messageTilawa=messagesTilawa![index];
    return Container(
      padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Align(
        alignment: (messageTilawa.sender != widget.username?Alignment.topLeft:Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (messageTilawa.sender  != widget.username?Colors.grey.shade200:Colors.brown[200]),
          ),
          padding: EdgeInsets.all(16),
          child: Text(messageTilawa.audio ,style: TextStyle(fontSize: 15),),
        ),
      ),
    );
  },
);
            },
          ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 310,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown
                    ),
                    onPressed: () async{
                      if(recorder.isRecording){
                        await stop();
                      }else{
                        await record();
                      }
                      setState(() {
                        
                      });
                    },
                     child: Icon(recorder.isRecording?Icons.stop:Icons.mic),
                     ),
                  Row(
                    children: [
                      SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: "ملاحظة",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      print("envoyer");
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.brown,
                    elevation: 0,
                  ),
                    ],
                  ),
                  Text("00:00",style: TextStyle(fontSize: 30,fontFamily: 'Cairo',fontWeight: FontWeight.w600),),
                  Divider(color: Colors.white,),
                  Text("العلامة",style: TextStyle(fontFamily: 'Cairo',),),
                  Container(
                    margin: EdgeInsets.only(right:20,left: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 101, 74, 64),width: 5)
                      
                    ),
                    height: 60,
                    width: 60,
                    child:  TextFormField(
                      
                      textAlign: TextAlign.center,
                       onChanged: (text){
                         note=text;
                       },
                
                style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600,fontFamily: ' Cairo'),
                cursorColor: Color.fromARGB(255, 101, 74, 64),
                
                 decoration: InputDecoration(
                   border: InputBorder.none,
                   
                   

                   
                 ),),
                  ),
                ],
                
              ),
            ),
            
          ),
        ],
      ),
    );
  }
}