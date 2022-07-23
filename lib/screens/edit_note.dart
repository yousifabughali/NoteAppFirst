import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/provider/note_provider.dart';
import 'package:provider/provider.dart';

class EditNote extends StatefulWidget {
  late int id;
  late String title;
  late String content;
  late Color note_color;


  EditNote({Key? key,required this.id, required this.title, required this.content,required this.note_color})
      : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController _contentTextEditing, _titleTextEditing;
   late Color _selectedColor= widget.note_color;
  NoteModel get note {
    NoteModel newNote = NoteModel();
    newNote.id= widget.id;
    newNote.content = _contentTextEditing.text;
    newNote.title = _titleTextEditing.text;
    newNote.note_color=_selectedColor;
    return newNote;
  }

  @override
  void initState() {
    super.initState();
    _contentTextEditing = TextEditingController();
    _titleTextEditing = TextEditingController();
    _titleTextEditing.text = widget.title;
    _contentTextEditing.text = widget.content;

  }

  @override
  void dispose() {
    _contentTextEditing.dispose();
    _titleTextEditing.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => {
              _noteEditSheet(context),
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: ()  async  {
              performEdit();

    }
          ),
        ],
        elevation: 2,
        backgroundColor: widget.note_color,
        centerTitle: true,
        title: Text(
          'Edit Note'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontFamily: 'Open Sans',
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 0),
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              controller: _titleTextEditing,
              decoration: InputDecoration(
                hintText: 'Enter the title',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              controller: _contentTextEditing,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter the Content'.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _noteEditSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          final ValueNotifier<Color> _colorNotifier = ValueNotifier(_selectedColor);

          return ValueListenableBuilder(
              valueListenable: _colorNotifier,
              builder: (BuildContext context,Color value, child) {
                return Container(
                  height: 225.h,
                  color: value,

                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                          leading: const Icon(Icons.delete),
                          title:  Text('Delete'.tr()),
                          onTap: () {
                            deleteNote(id: note.id);
                            //  Navigator.pop<Scaffold>(context);
                          }),
                      ListTile(
                          leading: const Icon(Icons.content_copy),
                          title:  Text('Duplicate'.tr()),
                          onTap: () {}),
                      ListTile(
                          leading: const Icon(Icons.share),
                          title:  Text('Share'.tr()),
                          onTap: () {}),
                      MaterialColorPicker(
                        colors: fullMaterialColors,
                        selectedColor: _selectedColor,
                        onColorChange: (color) =>
                            setState(() => {
                            widget.note_color=color,
                            _colorNotifier.value=color,
                             _selectedColor = color,
                            }),
                        spacing: 5,
                      ),
                    ],
                  ),
                );
              },

          );

        });
    }
    Future<void> performEdit() async{
      if(CheckData()){
        await editing();
      }
    }
    void showSnackBar({required String message, bool error = false}) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ));
    }

    bool CheckData() {
      if (_contentTextEditing.text.isNotEmpty &&
          _titleTextEditing.text.isNotEmpty) {
        return true;
      }
      showSnackBar(message: 'Enter required data', error: true);
      return false;
    }




    Future<void> editing() async{
      bool edited=await Provider.of<NoteProvider>(context,listen: false).update(note: note);
      String message= edited ? 'Edited Successfully' : 'Edited failed';
      showSnackBar(message: message,error: !edited);
      setState(() {
        if(edited){
          Navigator.pop(context);
        }
      });

    }


    Future<void> deleteNote({required id}) async {
      bool deleted = await Provider.of<NoteProvider>(context, listen: false)
          .delete(id: id);

      String message = 'Delete failed';
      if(!deleted){
        showSnackBar(message: message, error: !deleted);
        return;
      }

       Navigator.pushNamedAndRemoveUntil(context, '/Note_Screen', (route) => false);
     // Navigator.pushReplacementNamed(context, '/Note_Screen');
      }

    }


