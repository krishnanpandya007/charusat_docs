import 'dart:io';
import 'dart:typed_data';

import 'package:charusat_docs/screens/splash_screen.dart';
import 'package:charusat_docs/screens/upload_document.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CometeePage extends StatefulWidget {
  List<String> navigationStack = [];
  dynamic globalMap;
  Map<String, dynamic>? contactMap;

  CometeePage(
      {super.key,
      required this.navigationStack,
      required this.globalMap,
      required this.contactMap});

  @override
  State<CometeePage> createState() => _CometeePageState();
}

class _CometeePageState extends State<CometeePage> {
// get map from context
  // if type==list then its terminating committee or sub-committee

  late String mapType = 'committee'; // committee | docs

  late dynamic focusedMap;
  List<dynamic> focusMapList = [];
  bool canEditDocument = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    focusedMap = widget.globalMap;
    for (final e in widget.navigationStack) {
      focusedMap = focusedMap[e];
    }
    if (focusedMap is Map) {
      // Select committee
      mapType = 'committee';
      setState(() {
        focusMapList = (focusedMap).keys.toList();
      });
    } else {
      final supabase = Supabase.instance.client;
      // get current comittee email list
      List<String> adminEmails = [];
      (widget.contactMap?[widget.navigationStack[0]] as Map)
          .forEach((key, personList) {
        for (final person in personList) {
          adminEmails.add(person['email']);
        }
      });
      print(adminEmails);
      if (supabase.auth.currentUser != null) {
        if (adminEmails.contains(supabase.auth.currentUser?.email)) {
          canEditDocument = true;
        }
      }
      mapType = 'docs';
      for (final fileDetail in focusedMap) {
        focusMapList.add(fileDetail['name']);
      }
      setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.navigationStack.length > 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                canEditDocument && mapType == 'docs'
                    ? FloatingActionButton(
                        onPressed: () {
                          // upload new document
                          // take its name and file
                          // upload to bucket
                          // add entry to Committee
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => UploadDocumentScreen(
                                    navigationStack: widget.navigationStack,
                                  )));
                        },
                        child: Icon(Icons.upload_file),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 15.0,
                ),
                (FloatingActionButton.extended(
                  icon: Icon(Icons.person),
                  label: Text('Contact'),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      // context and builder are
                      // required properties in this widget
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,

                      builder: (BuildContext context) {
                        // we set up a container inside which
                        // we create center column and display text

                        // Returning SizedBox instead of a Container
                        return SingleChildScrollView(
                          child: SizedBox(
                            // height: 200,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  ...getContactPersonsOfType('Process Owners'),
                                  ...getContactPersonsOfType('Co-ordinators'),
                                  ...getContactPersonsOfType('DCE'),
                                  ...getContactPersonsOfType('DIT'),
                                  ...getContactPersonsOfType('DCSE'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ))
              ],
            )
          : null,
      appBar: AppBar(
        title: Text(
          'Charusat Docs',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[500],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.0, bottom: 10.0, top: 10.0),
              color: Colors.blue[100],
              child: Row(
                children: widget.navigationStack.map((navigationPath) {
                  return Row(children: [
                    Text(navigationPath),
                    Icon(Icons.arrow_right)
                  ]);
                }).toList(),
              )),
          Expanded(
            // height: 700,
            child: focusMapList.isEmpty
                ? Center(child: Text("No Documents"))
                : ListView.separated(
                    itemCount: focusMapList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text((focusMapList)[index]),
                        onTap: mapType == 'docs'
                            ? () async {
                                final Uint8List file = await supabase.storage
                                    .from("Documents")
                                    .download(widget.navigationStack.join('/') +
                                        '/' +
                                        (focusMapList)[index])
                                    .catchError((e) {
                                });
                                DocumentFileSavePlus().saveFile(file, widget.navigationStack.join('_') + '_' + (focusMapList)[index], 'application/pdf');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Done! check your downloads folder...'),
                                  ),
                                );
                                // Directory? d = await getDownloadsDirectory();
                                // OpenFile.open("${d?.path}/${(focusMapList)[index]}");
                                // File a = File(widget.navigationStack.join('_') + '_' + (focusMapList)[index]);
                                // print(a.path);
                                // print(a.uri);
                                // OpenFile.open(a.path);
                              }
                            : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => CometeePage(
                                              navigationStack: [
                                                ...widget.navigationStack,
                                                focusMapList[index]
                                              ],
                                              globalMap: widget.globalMap,
                                              contactMap: widget.contactMap,
                                            )));
                              },
                        // leading: canEditDocument ? IconButton(onPressed: (){}, icon: Icon(Icons.upload_file_outlined)) : SizedBox(),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            canEditDocument && mapType == 'docs'
                                ? IconButton(
                                    onPressed: () async {
                                      //delete document from bucket and from database entry in Committee
                                      // delete a file, delete an entry
                                      final List<FileObject> objects =
                                          await supabase.storage
                                              .from("Documents")
                                              .remove([
                                        widget.navigationStack.join('/') +
                                            '/' +
                                            (focusMapList)[index]
                                      ]).catchError((err) {
                                        print("Unable To Delete file");
                                        print(err);
                                      });
                                      dynamic data = await supabase
                                          .from('Committee')
                                          .select('child')
                                          .eq('name',
                                              widget.navigationStack[0]);
                                      data = data[0];
                                      data = data['child'];
                                      if(data is List){
                                        for (var i = 0;
                                              i < data.length;
                                              i++) {
                                            if (data[i]["name"] ==
                                                (focusMapList)[index]) {
                                              data.removeAt(i);
                                              break;
                                            }
                                          }
                                      } else {
                                        List<String> tmpNavStk = widget
                                            .navigationStack
                                            .map((e) => e)
                                            .toList();
                                        tmpNavStk.removeAt(0);
                                        // insertValue(data, tmpNavStk, );
                                        dynamic current = data;
                                        // Traverse through the keys to reach the target list
                                        for (int i = 0;
                                            i < tmpNavStk.length - 1;
                                            i++) {
                                          current = current[tmpNavStk[i]];
                                          if (current is! Map) {
                                            throw Exception(
                                                "Key path is invalid: ${tmpNavStk.sublist(0, i + 1).join(' -> ')}");
                                          }
                                        }
                                        dynamic targetList =
                                            current[tmpNavStk.last];
                                        if (targetList is List) {
                                          for (var i = 0;
                                              i < targetList.length;
                                              i++) {
                                            if (targetList[i]["name"] ==
                                                (focusMapList)[index]) {
                                              targetList.removeAt(i);
                                              break;
                                            }
                                          }
                                          // targetList.remo({"name": (focusMapList)[index], "path": widget.navigationStack.join('/') + '/' + ((focusMapList)[index]?? 'Document.pdf')});
                                        } else {
                                          throw Exception(
                                              "Target is not a list: ${tmpNavStk.join(' -> ')}");
                                        }
                                      }
                                      await supabase
                                          .from("Committee")
                                          .update({'child': data})
                                          .eq('name', widget.navigationStack[0])
                                          .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Document deleted!!')),
                                            );

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ct) =>
                                                        SplashScreen()));
                                          });
                                    },
                                    icon: Icon(Icons.delete_outline))
                                : SizedBox(),
                            Icon(
                              mapType == 'committee'
                                  ? Icons.arrow_forward_ios_rounded
                                  : Icons.open_in_new_rounded,
                              size: 15.0,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext ctx, int length) {
                      return Divider();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> getContactPersonsOfType(String type) {
    return <Widget>[
      Chip(
          label: Text(
        type,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
      )),
      // (widget.contactMap![widget.navigationStack[0]][type]).map((val) => )
      ...widget.contactMap?[widget.navigationStack[0]][type].map((val) {
        return Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 18.0,
                ),
                Text(val['name'])
              ],
            ),
            ListTile(
              title: Text(val['email']),
              leading: Icon(Icons.email_outlined),
              contentPadding: EdgeInsets.zero,
              onTap: () {},
            ),
          ],
        );
      }),
      SizedBox(
        height: 20.0,
      ),
    ];
  }
}
