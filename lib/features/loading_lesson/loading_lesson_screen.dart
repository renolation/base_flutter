import 'package:base_flutter/features/home/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingLessonScreen extends StatefulWidget {
  const LoadingLessonScreen({super.key});

  @override
  State<LoadingLessonScreen> createState() => _LoadingLessonScreenState();
}

class _LoadingLessonScreenState extends State<LoadingLessonScreen> {

  LessonResponse? lessonResponse;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callDio();
  }


  void callDio() async {
    final dio = Dio();
    final response = await dio.get('https://37b530e059dd.ngrok-free.app/');
    setState(() {
      lessonResponse = LessonResponse.fromJson(response.data);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: lessonResponse == null ? const CircularProgressIndicator() : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lesson Title: ${lessonResponse!.response}'),
            TextButton(onPressed: () {
              context.pushNamed('test', extra: lessonResponse);
            }, child: Text('Next')),
                ],
        )
      ),
    );
  }
}
