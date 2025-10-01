

class LessonResponse {
  final String image; // base64 string
  final String response;
  final WidgetData widget;

  LessonResponse({
    required this.image,
    required this.response,
    required this.widget,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) {
    return LessonResponse(
      image: json['image'] as String,
      response: json['response'] as String,
      widget: WidgetData.fromJson(json['widget']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'response': response,
      'widget': widget.toJson(),
    };
  }
}

class WidgetData {
  final TapWidget tapToRecordWidget;
  final TapWidget tapToSpeechWidget;

  WidgetData({
    required this.tapToRecordWidget,
    required this.tapToSpeechWidget,
  });

  factory WidgetData.fromJson(Map<String, dynamic> json) {
    return WidgetData(
      tapToRecordWidget:
      TapWidget.fromJson(json['tap_to_record_widget']),
      tapToSpeechWidget:
      TapWidget.fromJson(json['tap_to_speech_widget']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tap_to_record_widget': tapToRecordWidget.toJson(),
      'tap_to_speech_widget': tapToSpeechWidget.toJson(),
    };
  }
}

class TapWidget {
  final String content;
  final String position;

  TapWidget({
    required this.content,
    required this.position,
  });

  factory TapWidget.fromJson(Map<String, dynamic> json) {
    return TapWidget(
      content: json['content'] as String,
      position: json['position'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'position': position,
    };
  }
}
