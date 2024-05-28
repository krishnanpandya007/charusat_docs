import 'package:charusat_docs/screens/cometee.dart';
import 'package:flutter/material.dart';
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

      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => CometeePage(navigationStack: [], globalMap: globalMap, contactMap: contactMap,))));  

    }
    loadData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('CHARUSAT DOCS'),),
    );
  }
}