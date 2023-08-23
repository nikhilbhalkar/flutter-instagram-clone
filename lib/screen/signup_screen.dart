import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled4logintuyotrial/resources/auth_methods.dart';
import 'package:untitled4logintuyotrial/screen/login_screen.dart';
import 'package:untitled4logintuyotrial/utility/colorsuse.dart';
import 'package:untitled4logintuyotrial/utility/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_screen_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utility/dimensions.dart';
import '../widget/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  //final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void signUpUser()async{
    setState(() {
      _isLoading = true;
    });
     String res = await AuthMethods().signupUser(
                  email: _emailController.text,
                  password: _passwordController.text,
                  username: _usernameController.text,
                  bio: _bioController.text,
                  file: _image!,
                );
                  setState(() {
                      _isLoading = false;
                 });
               if(res!='success')
               {
                showSnackBar(res,context);
               }
               else{
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                       mobileScreenLayout: MobileScreenLayout()
                       )
                  ));

               }
             
  }

  
  void navigateToLogin()
  {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LOginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding:MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width /3)
            :  const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 35,
            ),

            //svg image
            SvgPicture.asset(
              'assets/Instagram_logo.svg',
              height: 64,
            ),

            //circular widget to accept and show our selected file
            Stack(children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                          'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                    ),
              Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  )),
            ]),
            const SizedBox(
              height: 20,
            ),
            //input for email
            TextFieldInput(
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),

            const SizedBox(
              height: 20,
            ),

            TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
                isPass: true),

            const SizedBox(
              height: 20,
            ),

            //textfield for pass

            TextFieldInput(
              hintText: 'Enter the password',
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
              isPass: true,
            ),
            const SizedBox(
              height: 20,
            ),

            TextFieldInput(
              hintText: 'Enter your bio',
              textInputType: TextInputType.text,
              textEditingController: _bioController,
            ),

            const SizedBox(
              height: 20,
            ),
            //login button
            InkWell(
              onTap:signUpUser,
              child: _isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),)
              : Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
                child: const Text('Sign up'),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //transition to signing up

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Don't have an account? "),
                ),
                GestureDetector(
                  onTap:navigateToLogin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
