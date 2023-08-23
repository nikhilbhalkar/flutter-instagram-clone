import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled4logintuyotrial/resources/firestore_methods.dart';
import 'package:untitled4logintuyotrial/utility/colorsuse.dart';

import '../widget/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  String username = "";
  String email = "";
  String postUrl = "";
  String uid = "";
  final TextEditingController _commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
      email = (snap.data() as Map<String, dynamic>)['email'];
      postUrl = (snap.data() as Map<String, dynamic>)['photoUrl'];
      uid = (snap.data() as Map<String, dynamic>)['uid'];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _commentcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished',descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if(snapshot.connectionState ==ConnectionState.waiting){
                 return const Center(
                  child: CircularProgressIndicator(),
                 );
          }
          return ListView.builder(
            itemCount:( snapshot.data! as dynamic).docs.length,
            itemBuilder: (context,Index)=>CommentCart(
              snap:( snapshot.data! as dynamic).docs[Index].data(),
            ));
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage('$postUrl'),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: TextField(
                controller: _commentcontroller,
                decoration: InputDecoration(
                  hintText: 'Comment as ' + '$username',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await FirestoreMethods().postComment(widget.snap['postId'],
                  _commentcontroller.text, uid, username, postUrl);
                  setState(() {
                    _commentcontroller.text = "";
                  });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: const Text(
                'POST',
                style: TextStyle(color: blueColor),
              ),
            ),
          ),
        ]),
      )),
    );
  }
}
