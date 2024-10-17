import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innerbhakti_frontend/screens/audio_players_screen.dart';
import 'dart:convert';

class ProgramDetailsScreen extends StatefulWidget {
  final String programId;
  final String imageUrl;

  ProgramDetailsScreen({required this.programId, required this.imageUrl});

  @override
  _ProgramDetailsScreenState createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? programDetails;
  bool isLoading = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    fetchProgramDetails();

    // Initialize animation controller for fade transition
    _controller = AnimationController(
      duration: Duration(milliseconds: 500), // Control the fade-in speed
      vsync: this,
    );
    _controller.forward(); // Start the animation
  }

  Future<void> fetchProgramDetails() async {
    try {
      final response = await http.get(Uri.parse(
          'https://innerbhakti-backend.onrender.com/api/programs/${widget.programId}'));
      if (response.statusCode == 200) {
        setState(() {
          programDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print(
            'Failed to load program details with status code: ${response.statusCode}');
        throw Exception('Failed to load program details');
      }
    } catch (error) {
      print('Error fetching program details: $error');
    }
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Cleans up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          'Program Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : programDetails == null
              ? Center(child: Text('Error loading program details'))
              : FadeTransition(
                  opacity: _controller, // Apply fade animation
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Hero(
                          tag: widget.programId, // Hero animation tag
                          child: Image.network(
                            widget.imageUrl,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image,
                                  size: 100, color: Colors.grey);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            programDetails!['name'],
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                programDetails!['description'] ??
                                    'Immerse yourself in a transformative journey through this program, designed to offer deep insights and practical guidance on [specific topic]. Whether you\'re a seasoned practitioner or a newcomer, this program offers something for everyone. Explore a variety of engaging tracks, ranging from meditative practices to thought-provoking lectures, each crafted to enhance your understanding and well-being. Dive in to explore these enriching resources at your own pace, and unlock the potential for personal growth, relaxation, and mindfulness.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Available Tracks',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[700],
                            ),
                          ),
                        ),
                        // List of tracks
                        ListView.builder(
                          physics:
                              NeverScrollableScrollPhysics(), // Prevents the ListView from scrolling independently
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: programDetails!['tracks'].length,
                          itemBuilder: (context, index) {
                            final track = programDetails!['tracks'][index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  track['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal[600],
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.teal[300],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AudioPlayerScreen(
                                        trackUrl: track['audioUrl'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
