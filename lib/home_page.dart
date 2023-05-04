import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Body of State()

  //Audio Recogniation
  bool islistening = false; //Status
  SpeechToText speechToText = SpeechToText(); //
  var recognizedText =
      "hold the botton and start speaking"; //to store recognized audio

  //Chat-GPT Implementation
  String promptResponse = "";
  late OpenAI? chatGPT;

  //AIPrompt Function
  Future getReply(String inputMessage) async {
    // final request =
    //     ChatCompleteText(model: ChatModel.gpt_4_32k_0314, messages: [
    //   Map.of({"role": "user", "content": inputMessage})
    // ]);
    final request =
        CompleteText(prompt: inputMessage, model: Model.ada, maxTokens: 200);
    final response = await chatGPT!.onCompletion(request: request);
    setState(
      () {
        print(response!.choices[0].text);
        promptResponse = response.choices[0].text;
      },
    );
  }

  //initState()
  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: "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",
        baseOption:
            HttpSetup(receiveTimeout: const Duration(milliseconds: 60000)));
    super.initState();
  }

  //Dispose
  @override
  void dispose() {
    // chatGPT?.close();
    // chatGPT?.genImgClose();
    chatGPT!..cancelAIGenerate();
    super.dispose();
  }

  //Build method
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
            alignment: AlignmentDirectional.center,
            height: 1000,
            width: 350,
            color: Colors.amberAccent,
            child: Center(
              child: Column(
                children: [
                  Text(recognizedText),
                  Text(promptResponse),
                ],
              ),
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
                                //recognized text from Audio
                                recognizedText = result.recognizedWords;
                                getReply(recognizedText);
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
                // getReply(recognizedText);
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
