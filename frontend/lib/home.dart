import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';
import 'package:click_to_copy/click_to_copy.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CodeController? _codeController;

  var isListening = false;
  var text;
  SpeechToText speechToText = stt.SpeechToText();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final source = "Write your code here...";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: python,
      // theme: monokaiSublimeTheme,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 16, 79, 24),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "voCode.py",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontFamily: "Aldrich"),
            ),
            SizedBox(
              width: 410,
            ),
            Text(
              "Help",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromARGB(0, 6, 35, 2).withOpacity(.62),
                    BlendMode.color),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: CodeField(
                controller: _codeController!,
                textStyle: TextStyle(
                  fontFamily: 'SourceCode',
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AvatarGlow(
        glowColor: Colors.black,
        endRadius: 75.0,
        animate: true,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        repeatPauseDuration: Duration(microseconds: 1000),
        showTwoGlows: true,
        // onPressed: () {

        // },
        // child:GestureDetector(

        //   onTapDown: (details){
        //     setState((){
        //       isListening = true;
        //     }
        //   );},
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                      print(text);
                    });
                  });
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            // Icon(
            //   Icons.settings_voice,
            // ),
            backgroundColor: Colors.black,
            radius: 35,
            child: Icon(
              isListening
                  ? Icons.settings_voice
                  : Icons.settings_voice_outlined,
            ),
          ),
        ),
        // ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //backgroundColor: Image.asset('assets/img.png').color,
    );
  }
}
