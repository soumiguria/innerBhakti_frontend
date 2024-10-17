import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String trackUrl;

  AudioPlayerScreen({required this.trackUrl});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _animationController;
  bool isLiked = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Load the audio when the screen initializes
    _loadAudio();

    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  Future<void> _loadAudio() async {
    try {
      // Load the audio from the provided URL
      await _audioPlayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.trackUrl)));
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print('Error loading audio: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _shareAudio() {
    Share.share('Check out this relaxing audio: ${widget.trackUrl}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Relaxing Audio',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[100]!, Colors.teal[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal[100]!,
                  Colors.teal[200]!,
                  Colors.teal[400]!,
                  Colors.teal[600]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Animated Background Circles
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: CirclePainter(_animationController),
                child: Container(),
              );
            },
          ),
          // Main content
          Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  // Audio position slider
                  StreamBuilder<Duration?>(
                    // Stream for duration
                    stream: _audioPlayer.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                        // Stream for current position
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          var position = snapshot.data ?? Duration.zero;
                          return Slider(
                            activeColor: Colors.teal,
                            inactiveColor: Colors.teal[200],
                            min: 0.0,
                            max: duration.inMilliseconds.toDouble(),
                            value: position.inMilliseconds
                                .toDouble()
                                .clamp(0.0, duration.inMilliseconds.toDouble()),
                            onChanged: (value) {
                              _audioPlayer
                                  .seek(Duration(milliseconds: value.toInt()));
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Showing current time and total time
                  StreamBuilder<Duration?>(
                    // Stream for total duration
                    stream: _audioPlayer.durationStream,
                    builder: (context, snapshot) {
                      final totalDuration = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                        // Stream for current position
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final currentPosition =
                              snapshot.data ?? Duration.zero;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 40),
                  // Control and Action Buttons (Rewind, Play/Pause, Forward)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.replay_10, () {
                        _audioPlayer.seek(
                            _audioPlayer.position - Duration(seconds: 10));
                      }),
                      StreamBuilder<PlayerState>(
                        // Stream for player state
                        stream: _audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;

                          // Play/Pause button
                          if (isLoading) {
                            return CircularProgressIndicator(
                                color: Colors.teal);
                          } else if (processingState ==
                                  ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return CircularProgressIndicator(
                                color: Colors.teal);
                          } else if (playing != true) {
                            return _buildControlButton(
                                Icons.play_arrow, _audioPlayer.play);
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return _buildControlButton(
                                Icons.pause, _audioPlayer.pause);
                          } else {
                            return _buildControlButton(Icons.replay,
                                () => _audioPlayer.seek(Duration.zero));
                          }
                        },
                      ),
                      _buildActionButton(Icons.forward_10, () {
                        _audioPlayer.seek(
                            _audioPlayer.position + Duration(seconds: 10));
                      }),
                    ],
                  ),
                  SizedBox(height: 40),
                  // Like and Share Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Like Button
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                      ),
                      SizedBox(width: 40), // Spacing between buttons
                      // Share Button
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.white, size: 40),
                        onPressed: _shareAudio,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Control Button Widget
  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return ClipOval(
      child: Material(
        color: Colors.teal[300],
        child: InkWell(
          splashColor: Colors.teal[200],
          onTap: onPressed,
          child: SizedBox(
            width: 80,
            height: 80,
            child: Icon(
              icon,
              color: Colors.white,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }

  // Action Button Widget
  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 40),
      onPressed: onPressed,
    );
  }
}

// Custom painter for circular animated colors
class CirclePainter extends CustomPainter {
  final Animation<double> animation;

  CirclePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // Set the color to teal
    paint.color = Colors.teal.withOpacity(0.3);

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2 * (0.2 + i * 0.2) * animation.value,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
