import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:note_app/provider/note_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/note_card.dart';

class NoteApp extends StatefulWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  @override
  void initState() {
    Provider.of<NoteProvider>(context, listen: false).read();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 2,
        backgroundColor:  Colors.blue,
        centerTitle: true,
        title: Text(
          'app_name'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontFamily: 'Open Sans',
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            if(context.locale.toString()=='ar'){
              context.setLocale(Locale('en',));
            }else{
              context.setLocale(Locale('ar'));
            }
          }, icon: Icon(Icons.language),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
          child: const Icon(
            Icons.add,
            size: 40,
          ),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 145, 4, 114), Colors.blue],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/New_Note');
        },
      ),
      body:
          Consumer<NoteProvider>(builder: (context, NoteProvider provider, child) {
        if (provider.notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning,
                  size: 80,
                  color: Colors.grey.shade800,
                ),
                Text(
                  'NO NOTES',
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: provider.notes.length,
            itemBuilder: (context, index) {
              return NoteCard(
                deviceSize: deviceSize,
                id: provider.notes[index].id,
                title: provider.notes[index].title,
                content: provider.notes[index].content,
                note_color: provider.notes[index].note_color,
              );
            },
          );
        }
      }),
    );
  }
}
