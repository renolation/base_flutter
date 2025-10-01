import 'dart:convert';
import 'package:base_flutter/features/lesson/record_dialog.dart';
import 'package:record/record.dart';

import 'package:base_flutter/features/home/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

enum PositionEnum {
  topLeft('top_left'),
  topRight('top_right'),
  bottomLeft('bottom_left'),
  bottomRight('bottom_right');

  final String value;
  const PositionEnum(this.value);
}

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.lessonResponse});

  final LessonResponse lessonResponse;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {

    final record = AudioRecorder();



    Widget containerText(String text) {
      return InkWell(
        onTap: () async {
          var result = await flutterTts.speak(text);
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(16.0),
          width: 300,
          height: 120,
          color: Colors.black54,
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      );
    }

    Widget buildTapToRecordWidget(String position, String content) {
      switch (position) {
        case 'top_left':
          return Align(alignment: Alignment.topLeft, child: containerText(content));
        case 'top_right':
          return Align(alignment: Alignment.topRight, child: containerText(content));
        case 'bottom_left':
          return Align(alignment: Alignment.bottomLeft, child: containerText(content));
        case 'bottom_right':
          return Align(alignment: Alignment.bottomRight, child: containerText(content));
        default:
          return const SizedBox.shrink();
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(base64Decode(widget.lessonResponse.image)),
            fit: BoxFit.cover, // Optional: Adjust as needed
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight,),
            Text(widget.lessonResponse.widget.tapToRecordWidget.position),
            buildTapToRecordWidget(
              widget.lessonResponse.widget.tapToRecordWidget.position,
              widget.lessonResponse.widget.tapToRecordWidget.content,
            ),
            Spacer(),
            Text(widget.lessonResponse.widget.tapToSpeechWidget.position),
            buildTapToRecordWidget(
              widget.lessonResponse.widget.tapToSpeechWidget.position,
              widget.lessonResponse.widget.tapToSpeechWidget.content,
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: RecordDialog(),
                  ),
                );
              },
              icon: Icon(Icons.mic, size: 48),
            ),
          ],
        ),
      ),
    );
  }
}
