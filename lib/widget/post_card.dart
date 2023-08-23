import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled4logintuyotrial/resources/firestore_methods.dart';
import 'package:untitled4logintuyotrial/screen/comments_screen.dart';
import 'package:untitled4logintuyotrial/utility/colorsuse.dart';
import 'package:untitled4logintuyotrial/utility/utils.dart';
import 'package:untitled4logintuyotrial/widget/like_animation.dart';

import '../utility/dimensions.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String username = "";
  String email = "";
  String photoUrl = "";
  String uid = "";
  int commentlength = 0;

  @override
  void initState() {
    super.initState();
    getUsername();
    getComments();
  }

void getComments()async{
try 
{
  
  QuerySnapshot snap =  await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
  commentlength = snap.docs.length;
} catch (e) 
{
  showSnackBar(e.toString(), context);
}
setState(() {
  
});
}



  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
      email = (snap.data() as Map<String, dynamic>)['email'];
      uid = (snap.data() as Map<String, dynamic>)['uid'];

      photoUrl = (snap.data() as Map<String, dynamic>)['photoUrl'];
    });
  }

  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color:  width > webScreenSize ? secondaryColor : mobileBackgroundColor
        )
      ),
      
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    'Delete',
                                  ]
                                      .map((e) => InkWell(
                                            onTap: ()async {
                                              FirestoreMethods().deletePost(widget.snap['postId'],widget.snap['uid']);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ));
                    },
                    icon: Icon(Icons.more_vert)),
              ],
            ),
          ),
          //Image section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods()
                  .likePost(widget.snap['postId'], uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(microseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 120,
                    ),
                    isAnmating: isLikeAnimating,
                    duration: const Duration(microseconds: 400),
                    onEnd: () {
                      isLikeAnimating = false;
                    },
                  ),
                )
              ],
            ),
          ),

          //Lik comment section
          Row(
            children: [
              LikeAnimation(
                isAnmating: true,
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postId'], uid, widget.snap['likes']);
                  },
                  icon: Icon(Icons.favorite),
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>  CommentScreen(
                      snap: widget.snap,
                     
                    ))),
                icon: Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.bookmark_border)),
              )),
            ],
          ),

          //Description and numberr of cumments

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            color: primaryColor,
                          ),
                          children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.snap['description'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'view all $commentlength comments',
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
