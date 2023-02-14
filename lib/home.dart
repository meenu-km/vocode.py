import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 16, 79, 24),
        title: Row(
          children: [
            Row(
              children: [
                Text(
                  "voCodes.py",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      fontFamily: "Aldrich"),
                ),
              ],
            ),
            SizedBox(
              width: 410,
            ),
            Row(
              children: [
                Text(
                  "Help",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
