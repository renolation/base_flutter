import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class RecordDialog extends StatefulWidget {
  const RecordDialog({super.key});

  @override
  State<RecordDialog> createState() => _RecordDialogState();
}

class _RecordDialogState extends State<RecordDialog> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  String? _recordedPath;
  bool _isRecording = false;

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleRecord() async {
    if (!_isRecording) {
      if (await _recorder.hasPermission()) {
        await _recorder.start(const RecordConfig(), path: 'myFile.m4a');
        setState(() => _isRecording = true);
      }
    } else {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _recordedPath = path;
      });
    }
  }

  Future<void> _playRecording() async {
    if (_recordedPath != null) {
      await _player.play(DeviceFileSource(_recordedPath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 150),
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.mic_none_sharp, size: 96),
            onPressed: _toggleRecord,
          ),
          if (_recordedPath != null && !_isRecording)
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 48),
              onPressed: _playRecording,
            ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
              // Add more buttons as needed
            ],
          ),
        ],
      ),
    );
  }
}

// Usage in your code:

