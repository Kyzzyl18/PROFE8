import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/custom_button.dart';

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({Key? key}) : super(key: key);

  @override
  _MediaPlayerScreenState createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/videos/sample_video.mp4')
          ..initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoController,
                autoPlay: false,
                looping: false,
              );
            });
          });
  }

  void _playAudio() async {
    if (_isAudioPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('audio/sample_audio.mp3'));
    }
    setState(() {
      _isAudioPlaying = !_isAudioPlaying;
    });
  }

  void _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isAudioPlaying = false;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Media Player',
              style: TextStyle(fontFamily: 'Roboto'))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: _chewieController != null
                  ? Chewie(controller: _chewieController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: _isAudioPlaying ? 'Pause Audio' : 'Play Audio',
                    onPressed: _playAudio,
                    type: ButtonType.elevated,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    icon: _isAudioPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    text: 'Stop Audio',
                    onPressed: _stopAudio,
                    type: ButtonType.elevated,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    icon: Icons.stop,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
