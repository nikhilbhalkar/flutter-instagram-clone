import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled4logintuyotrial/screen/add_post_screen.dart';
import 'package:untitled4logintuyotrial/screen/feed_screen.dart';
import 'package:untitled4logintuyotrial/screen/profile_screen.dart';
import 'package:untitled4logintuyotrial/screen/search_screen.dart';

const webScreenSize = 600;

 List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  Text('fav'),
];
