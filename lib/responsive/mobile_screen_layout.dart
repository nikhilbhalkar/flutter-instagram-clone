import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled4logintuyotrial/utility/colorsuse.dart';
import 'package:untitled4logintuyotrial/utility/dimensions.dart';
//import 'package:provider/provider.dart';
//import '../models/user.dart';
//import '../provider/user_provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";
  String email = "";
  int _page = 0;
  late PageController pageController;



  @override
  void initState() {
    super.initState();
    getUsername();
    pageController = PageController();
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
void dispose() {
   
    super.dispose();
    pageController.dispose();
  }

void navigationTabed(int page)
{
    pageController.jumpToPage(page);
}

void onPageChanged(int page)
{
    setState(() {
      _page = page;
    });
}

  @override
  Widget build(BuildContext context) {
    /* final User? user = Provider.of<UserProvider>(context).getUser;
  
    print('111111111111111111111111111111111111111111111');
    print(user?.username);
    print(user?.email);
     print('111111111111111111111111111111111111111111111');
   
    return user == null? const Center(child: CircularProgressIndicator(),)
    :  Center(
      child: Text(user.username),
    );*/
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics:const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
        
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
              ), label: '', backgroundColor: primaryColor
            ),
            BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            color: _page == 1 ? primaryColor : secondaryColor,
            ), label: '', backgroundColor: primaryColor
            ),
            BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? primaryColor : secondaryColor,
              ), label: '', backgroundColor: primaryColor
            ),
            BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 3 ? primaryColor : secondaryColor,
              ), label: '', backgroundColor: primaryColor
            ),
            
            BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 4 ? primaryColor : secondaryColor,
              ), label: '', backgroundColor: primaryColor
            ),
      ],
      onTap: navigationTabed,
      ),
    );
  }
}
