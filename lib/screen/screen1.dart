import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gemini_ai/models/Messege.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const key = 'AIzaSyAIE5erKYMOQ-a07SQv3ksv1EYOs-sTr3s';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: key);
  TextEditingController solo = TextEditingController();

  List<Messege> chatmessege = [];

  void sendmessege() async {
    chatmessege.add(
      Messege(
        isuser: true,
        messege: solo.text,
        date: DateTime.now(),
      ),
    );
    final content = [Content.text(solo.text)];
    final response = await model.generateContent(content);
    chatmessege.add(
      Messege(
        isuser: false,
        messege: response.text ?? '',
        date: DateTime.now(),
      ),
    );
    solo.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: chatmessege.length,
              itemBuilder: (context, index) => BubbleNormal(color: Colors.blueAccent,
                text: chatmessege[index].messege,
                isSender: chatmessege[index].isuser,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: solo,
                      
                      decoration: InputDecoration(
                        hintText: 'type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      
                    ),
                  ),
                  Gap(15),
                  ElevatedButton(
                      onPressed: () {
                        sendmessege();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20)),
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
