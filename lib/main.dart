import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int multiplyBy = 1;
  int multiplyCost = 18;
  int autoclick = 1;
  int autoclickCost = 24;

  bool soundEgg = false;
  bool soundChick = false;
  bool soundChicken = false;
  bool soundNuggets = false;



  Future<void> playAudio() async {
    final player = AudioPlayer();
    await player.setAsset('soundsEffects/plop.mp3');
    player.setVolume(0.5);
    player.play();
  }

  String _checkLanding(eggsNb) {
    var buttonImgPath = 'images/firstEgg.png';

    if (eggsNb >= 1000 ) {
      buttonImgPath = 'images/finalEgg.png';
      if (!soundEgg){
        playAudio();
        soundEgg = true;
      }
    }

    if (eggsNb >= 10000) {
      buttonImgPath = 'images/firstChick.png';
      if (!soundChick){
        playAudio();
        soundChick = true;
      }
    }
    if (eggsNb >= 100000) {
      buttonImgPath = 'images/chicken.png';
      if (!soundChicken){
        playAudio();
        soundChicken = true;
      }
    }
    if (eggsNb >= 1000000) {
      buttonImgPath = 'images/nuggets.png';
      if (!soundNuggets){
        playAudio();
        soundNuggets = true;
      }
    }

    if (eggsNb < 1000) {
      soundEgg = false;
    }
    if (eggsNb < 10000) {
      soundChick = false;
    }
    if (eggsNb < 100000) {
      soundChicken = false;
    }
    if (eggsNb < 1000000) {
      soundNuggets = false;
    }

    return buttonImgPath;
  }

  void _incrementCounter() {
    setState(() {
      _counter = _counter+(1 * multiplyBy);
      _checkLanding(_counter);
    });
  }

  void _buyIncrementMultiply() {
    setState(() {
      var cost = multiplyBy * 18;

      if (_counter >= cost) {
        _counter = _counter - cost;
        multiplyBy++;
      }
    });
  }

  void _buyIncrementAutoclick() {
    setState(() {

      var cost = autoclick * 24;

      if (_counter >= cost) {
        _counter = _counter - cost;
        autoclick++;
      }
    });
  }

  void _autoclickEachSecond() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter= _counter + (autoclick-1);
      });
    });
  }

  void _loadParameters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
      multiplyBy = (prefs.getInt('multiplyBy') ?? 1);
      autoclick = (prefs.getInt('autoclick') ?? 1);
    });
  }

  void _autoSaving() {
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('counter', _counter);
        await prefs.setInt('multiplyBy', multiplyBy);
        await prefs.setInt('autoclick', autoclick);

      });
  }

  void _initGame() async {
    _loadParameters();
    _autoSaving();
    _autoclickEachSecond();
  }


  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue,
                Colors.lightGreenAccent,
              ]
            ),
          ),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '$_counter',
                  style: GoogleFonts.dongle(
                    textStyle: TextStyle (
                      color: HexColor('#FFFFFF'),
                      fontSize: 75,
                    ),
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),

              TextButton(
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(splashFactory: NoSplash.splashFactory),
                  child: Image.asset(_checkLanding(_counter),
                    height: 250,
                    width: 250,

                  )),
              SizedBox(
                height: 40,
              ),
              Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Column(
                        children: <Widget> [
                          TextButton(
                              onPressed: _buyIncrementMultiply,
                              style: ElevatedButton.styleFrom(splashFactory: NoSplash.splashFactory),
                              child: Image.asset("images/hand.png",
                                  height: 50,
                                  width: 50,
                              )),

                          Text("+$multiplyBy/click",
                              style: TextStyle(
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                  color: Colors.white
                              )),
                          Text("${multiplyCost*multiplyBy} 🥚",
                              style: TextStyle(
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                  color: Colors.white
                              )),
                        ]
                    ),
                    SizedBox(
                      width: 75,
                    ),
                    Column(
                        children: <Widget> [
                          TextButton(
                              onPressed: _buyIncrementAutoclick,
                              style: ElevatedButton.styleFrom(splashFactory: NoSplash.splashFactory),
                              child: Image.asset("images/cursor.png",
                                  height: 50,
                                  width: 50
                              )),

                          Text("+${autoclick-1}/s",
                              style: TextStyle(
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                  color: Colors.white
                              )),
                          Text("${autoclick*autoclickCost} 🥚",
                              style: TextStyle(
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                  color: Colors.white
                              )),
                        ]
                    )


                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
