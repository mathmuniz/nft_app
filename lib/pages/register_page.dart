import 'package:flutter/material.dart';
import 'package:nft_app/components/my_loading_circle.dart';
import 'package:nft_app/services/auth_service.dart';
import 'package:nft_app/services/database/database_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _auth = AuthService();
  final _db = DatabaseService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  void register() async {
    if (passwordController.text == confirmPasswordController.text) {
      showLoadingCircle(context);

      try {
        await _auth.registerEmailPassword(emailController.text, passwordController.text);

        if (mounted) hideLoadingCircle(context);

        await _db.saveUserInfoInFirebase(nome: nameController.text, email: emailController.text);

      } catch (e) {

        if (mounted) hideLoadingCircle(context);
        if (mounted) {
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text(e.toString()),
            ),
          );
        }
      }
    } else {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Senhas não estão iguais!"),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Icon(Icons.person_sharp, size: 72, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 50),
                  Text("Insira seus dados para criar uma conta!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16
                    ),
                  ),
                        
                  const SizedBox(height: 25),
              
                  MyTextField(controller: nameController, hintText: "Insira seu nome", obscureText: false,),
                  
                  const SizedBox(height: 10),
                        
                  MyTextField(controller: emailController, hintText: "Insira o Email", obscureText: false,),
                  
                  const SizedBox(height: 10),
                  
                  MyTextField(controller: passwordController, hintText: "Insira a Senha", obscureText: true,),
                  
                  const SizedBox(height: 10),
              
                  MyTextField(controller: confirmPasswordController, hintText: "Confirme sua Senha", obscureText: true,),
                  
                  const SizedBox(height: 25),
              
                  MyButton(text: "Registrar", onTap: register,
                  ),
              
                  const SizedBox(height: 50),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Já tem conta?", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                      const SizedBox(width: 5),
                      GestureDetector(onTap: widget.onTap, 
                      child: Text("Entrar", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}