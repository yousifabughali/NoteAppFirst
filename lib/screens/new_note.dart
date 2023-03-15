import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/provider/note_provider.dart';
import 'package:provider/provider.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  late TextEditingController _contentTextEditing, _titleTextEditing;
  Color _selectedColor = Color(0xff2196f3);

  @override
  void initState() {
    super.initState();
    _contentTextEditing = TextEditingController();
    _titleTextEditing = TextEditingController();
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
            onPressed: () async => performSave(),
          ),
        ],
        elevation: 2,
        backgroundColor: _selectedColor,
        centerTitle: true,
        title: Text(
          'New Note'.tr(),
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
              decoration:  InputDecoration(
                hintText: 'Enter the title'.tr(),
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

              decoration:  InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter the Content'.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performSave() async {
    if (CheckData()) {
      await save();
    }
  }

  bool CheckData() {
    if (_contentTextEditing.text.isNotEmpty &&
        _titleTextEditing.text.isNotEmpty) {
      return true;
    }
    showSnackBar(message: 'Enter required data', error: true);
    return false;
  }

  void showSnackBar({required String message, bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red : Colors.green,
    ));
  }

  Future<void> save() async {
    bool created = await Provider.of<NoteProvider>(context, listen: false)
        .create(note: note);
    print(created);
    if (created) {
      clear();
      Navigator.pop(context);
    }
    String message = created ? 'Created Successfully' : 'Created failed';
    showSnackBar(message: message, error: !created);
  }

  NoteModel get note {
    NoteModel newNote = NoteModel();
    newNote.content = _contentTextEditing.text;
    newNote.title = _titleTextEditing.text;
    newNote.note_color = _selectedColor;
    return newNote;
  }

  void clear() {
    _contentTextEditing.text = '';
    _titleTextEditing.text = '';
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
                height: 250.h,
                color: value,

                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.delete),
                        title:  Text('Delete'.tr()),
                        onTap: () {
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

                           // widget.note_color=color,
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
}
