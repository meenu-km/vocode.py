import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';
import 'package:click_to_copy/click_to_copy.dart';

class Home extends StatelessWidget {
  CodeController? _codeController;
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
                  fontFamily: 'SourceCode', fontSize: 20,
                  ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: Icon(
          Icons.settings_voice,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //backgroundColor: Image.asset('assets/img.png').color,
    );
  }
}
