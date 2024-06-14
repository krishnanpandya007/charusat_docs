import 'dart:async';

import 'package:charusat_docs/screens/cometee.dart';
import 'package:charusat_docs/screens/signin.dart';
import 'package:charusat_docs/supabase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool dataLoaded = false;
  Map<String, dynamic> globalMap = {};
  Map<String, dynamic> contactMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // load data
    loadData() async {



      final supabase = Supabase.instance.client;
      
      await Timer(Duration(seconds: 2), (){});

      if(supabase.auth.currentSession == null || StorageService.getUserSession == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => SignIn())));  
      }
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(supabase.auth.currentUser?.email ?? 'Sign in please')),
          );

      final committeeInfo = await supabase.from("Committee").select().order('id', ascending: true);
      final contactInfo = await supabase.from("Contact").select().order('id', ascending: true);

      print("HelloPrinter:::");
      // print(contactInfo);
      for (final entry in committeeInfo){

        globalMap[entry['name']] = entry['child'];

      }

      for (final entryj in contactInfo){

        contactMap[entryj['committee']] = entryj['contacts'];

      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => CometeePage(navigationStack: [], globalMap: globalMap, contactMap: contactMap,))));  

    }
    loadData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20.0,),
          Text('DEPSTAR DOCS'),
        ],
      ),),
    );
  }
}