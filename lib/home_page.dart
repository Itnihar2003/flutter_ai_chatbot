import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  var text = "hold the botton and start speaking";
  bool islistening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 80, 3, 87),
        title: const Text(
          "CHAT_BOT",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 252, 250, 250)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 38.0),
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 600,
            width: 350,
            color: Colors.amberAccent,
            child: Center(
              child: Text(text),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: islistening,
        duration: const Duration(milliseconds: 2000),
        glowColor: Colors.blue,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) {
            setState(
              () async {
                if (!islistening) {
                  var available = await speechToText.initialize();
                  if (available) {
                    setState(
                      () {
                        islistening = true;
                        speechToText.listen(
                          onResult: (result) {
                            setState(
                              () {
                                text = result.recognizedWords;
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                }
              },
            );
          },
          onTapUp: (details) {
            setState(
              () {
                islistening = false;
              },
            );
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 35,
            child: Icon(
              islistening ? Icons.mic_external_off : Icons.mic,
              color: const Color.fromARGB(255, 244, 242, 235),
            ),
          ),
        ),
      ),
    );
  }
}
