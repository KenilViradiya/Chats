import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitledchat/utils/ToastUtils.dart';

class chatscreen extends StatefulWidget {
  final String receiverid;
  final String receivername;

  chatscreen({required this.receiverid, required this.receivername});

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentuserid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final TextEditingController msgtext = TextEditingController();

  // Get messages stream
  Stream<QuerySnapshot> _getmessage() {
    return _firestore
        .collection('chats')
        .doc(getchatid(widget.receiverid))
        .collection('message')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Create a unique chat ID based on the current user ID and receiver ID
  String getchatid(String receiverid) {
    return currentuserid.compareTo(receiverid) < 0
        ? '$currentuserid + $receiverid'
        : '$receiverid + $currentuserid';
  }

  // Send a message to Firestore
  void sendmessage() async {
    String msg = msgtext.text.trim();
    if (msg.isEmpty) {
      ToastUtils.showtoast('No Message Written');
      return; // Exit if the message is empty
    }

    await _firestore
        .collection('chats')
        .doc(getchatid(widget.receiverid)) // Correctly reference the chat document
        .collection('message')
        .add({
      'senderId': currentuserid, // ID of the user sending the message
      'receiverId': widget.receiverid, // ID of the receiver
      'message': msg, // The message text
      'timestamp': FieldValue.serverTimestamp(), // Timestamp for sorting
    }).then((value) {
      print("Message sent: $msg"); // Debugging output
    });

    msgtext.clear(); // Clear the input field after sending
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receivername),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getmessage(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages found.')); // Improved message
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // To show the latest message at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msg = messages[index];
                    bool issender = msg['senderId'] == currentuserid; // Check if the message is sent by the current user
                    return Align(
                      alignment: issender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: issender ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(msg['message']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgtext,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendmessage(); // Call the send message function
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
