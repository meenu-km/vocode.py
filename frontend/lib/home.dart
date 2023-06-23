import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';
import 'package:click_to_copy/click_to_copy.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' show get;
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart' as http;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CodeController? _codeController;

  var isListening = false;
  var parsedText;
  var queryText;
  var finalText = '';
  //String englishText = 'define a number';
  var source = "Write your code here...";
  //List<String> sourceLines = [];

  SpeechToText speechToText = stt.SpeechToText();
  Future<dynamic> getData(String englishText) async {
    final url = Uri.http('localhost:8000', '/', {'englishText': englishText});

    //final response = await http.get(url);
    final response = await http.BrowserClient().get(url);

    //print(response);
    // source=response.body;
    if (response.statusCode == 200) {
      print(response.body);
      //source=response.body;
      // sourceLines = source.split('\n');
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    //final source = "Write your code here...";

    _codeController = CodeController(
      text: source,
      language: python,
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
      body: SingleChildScrollView(
        child: Column(
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
      ),
      floatingActionButton: AvatarGlow(
        glowColor: Colors.black,
        endRadius: 75.0,
        animate: true,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        repeatPauseDuration: Duration(microseconds: 1000),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(
                    onResult: (result) {
                      setState(() {
                        parsedText = result.recognizedWords;

                        // print(text);
                      });
                    },
                  );
                });
              }
            }
          },
          onTapUp: (details) {
            //   setState(() {

            //     isListening = false;
            //   });
            //   speechToText.stop();
            //  print(text);
            // //  var parsedJson = json.encode(text);
            //    getData(englishText);

            setState(() {
              isListening = false;
            });
            speechToText.stop();
            print(parsedText);
            var parsedJson = json.encode(parsedText);
            getData(parsedJson).then((response) {
              setState(() {
                finalText = response['output'];
                finalText = finalText.replaceAll("\n'''", "");
                finalText = finalText.replaceAll("\n '''", "");
                if (source == "Write your code here...") {
                  source = "\n$finalText";
                } else {
                  source += "\n$finalText";
                }
                // Append the new code below the previous code
                _codeController?.text = source;
              });
            }).catchError((error) {
              print('Error: $error');
            });
            //        source += "\n$finalText"; // Append the new code below the previous code
            // _codeController?.text = source;//this two is where change need
          },
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 35,
            child: Icon(
              isListening
                  ? Icons.settings_voice
                  : Icons.settings_voice_outlined,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
