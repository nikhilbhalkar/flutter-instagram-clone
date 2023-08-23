import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled4logintuyotrial/resources/storage_method.dart';
import 'package:untitled4logintuyotrial/models/user.dart' as model;



class AuthMethods{

  final FirebaseAuth _auth  = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //signup
  Future<String>signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  })async
  {
    // ignore: unused_label

    String res = "nikhil some error occured";
    try
    {
      
      // ignore: unnecessary_null_comparison
      if(email.isNotEmpty||password.isNotEmpty||username.isNotEmpty||bio.isNotEmpty||file!= null)
          {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);



        //add user to database

        model.User user = model.User(


          username:username,
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl, 
          bio: bio,
          followers:[],
          following: [],
        );




        await  _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);

         /* await _firestore.collection('users').add({
            'username':username,
            'uid':cred.user!.uid,
            'email': email,
            'bio': bio,
            'followers':[],
            'following': [],
          });
          */


        res ="success";
      }
    }
    /*on FirebaseException catch(err){
      if(err.code == 'invalid-email')
      {
        res='The email is badly formated';

      }
      else if(err.code=='weak-password')
      {
         res = 'Password should be at least 6 character';
      }
      
    }*/
    catch (err)
    {
      res = err.toString();
      print('nikhil nikhil');
    }
    return res;
  }

  //logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try 
    {
     if(email.isNotEmpty || password.isNotEmpty)
     {
       await _auth.signInWithEmailAndPassword(email: email, password: password); 
       res ="success";
     } else{
      res="Please enter all the fields";
     }
    } 
    catch (err) 
    {
      res = err.toString();
      
         print('nikhil1111111111111000000000000000000000000000000000000');
   
    }
    return res;
  }
  Future<void> signOut()async{
    await _auth.signOut();
  }
}