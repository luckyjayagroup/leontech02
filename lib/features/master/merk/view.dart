import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leontech/core/utils/function.dart';
class ListMerk extends StatefulWidget {
  const ListMerk({super.key});

  @override
  State<ListMerk> createState() => _ListMerkState();
}

class _ListMerkState extends State<ListMerk> {
   String res ='';

  getdata()async{
    var response = await http.get(Uri.parse("https://api.luckyjayagroup.com/merkbarang?limit=10"));
    if (response.statusCode == 200) {
      res = response.body;
      res = decryptData(res);
      var jsonResponse = jsonDecode(res);
      if((jsonResponse as Map<String,dynamic>).containsKey('data')){

        res = 'OK';

      }else{
        res =  "not ok \n${jsonResponse.runtimeType}";
      }
      
      // res = jsonResponse['data'].toString();
      
    setState(() {
      
    });
    }else{
      res = response.statusCode.toString();
    }
    
    }
  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Encryption')),
      body: Column(
        children: [
          ElevatedButton(onPressed: getdata, child: const Text('Proses')),
          Text(res),


        ],
      ),
    );
    
  }
}