import 'package:flutter/material.dart';
import 'package:nft_app/pages/login_page.dart';
import 'package:nft_app/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool isLogin = true;

  void toggleLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPage(onTap: toggleLogin,);
    } else {
      return RegisterPage(onTap: toggleLogin,);
    }
  }
}