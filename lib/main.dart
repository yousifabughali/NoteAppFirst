import 'package:flutter/material.dart';
import 'package:note_app/provider/note_provider.dart';
// import 'package:note_app/screens/edit_note.dart';
import 'package:note_app/screens/lunch_screen.dart';
import 'package:note_app/screens/new_note.dart';
import 'package:note_app/screens/note.dart';
import 'package:note_app/storage/db/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await DbProvider().initDb();
  runApp(EasyLocalization(
  supportedLocales: [
  Locale('en'),
  Locale('ar'),
  ],
  path: 'assets/localization',
  child: MyApp(),),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteProvider>(create: (_) => NoteProvider()),
      ],
      child:const MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
      designSize: const Size(392.72727272727275, 781.0909090909091),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(

          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          // initialRoute: '/Lunch_Screen',
          routes: {
            // I can use instead of initialRoute, the '/' to navigate to the home
            '/': (context) => const LunchScreen(),
            '/Note_Screen': (context) => const NoteApp(),
            // '/Edit_Note' : (context) => const EditNote(),
            '/New_Note': (context) => const NewNote(),
          },
        );
      },
    );
  }
}