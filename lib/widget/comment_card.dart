import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCart extends StatefulWidget {
   final snap;
  const CommentCart({Key? key,required this.snap}): super(key: key);

  @override
  State<CommentCart> createState() => _CommentCartState();
}

class _CommentCartState extends State<CommentCart> {
  String username = "";
  String email = "";




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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
               widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: '  ${widget.snap['text']}',
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate()
                      ),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child:const Icon(Icons.favorite_outline,size: 16,),
          ),
        ],
      ),
    );
  }
}
