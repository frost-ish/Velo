import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:velo/Helpers/theme.dart';
import 'package:dotted_line/dotted_line.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kPrimaryColor),
      body: Container(
        child: ListView.builder(
          itemCount: 20,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              margin: EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.green,
                            ),
                            Text(''),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                          child: DottedLine(
                            direction: Axis.vertical,
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
