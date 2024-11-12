import 'package:flutter/material.dart';
import 'package:nft_app/components/my_button.dart';
import 'package:nft_app/components/my_loading_circle.dart';
import 'package:nft_app/components/my_text_field.dart';
import 'package:nft_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;


  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _auth = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  void login() async {

    showLoadingCircle(context);

    try {
      await _auth.loginEmailPassword(emailController.text, passwordController.text);

      if (mounted) hideLoadingCircle(context);
    } catch (e) {
      if (mounted) hideLoadingCircle(context);
      if (mounted) {
        showDialog(context: context, builder: (context) => AlertDialog(
          title: Text(e.toString()),
          ),
        );
      }
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
                  Text("Bem vindo de volta, você fez falta!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16
                    ),
                  ),
                        
                  const SizedBox(height: 25),
                        
                  MyTextField(controller: emailController, hintText: "Insira o Email", obscureText: false,),
                  
                  const SizedBox(height: 10),
                  
                  MyTextField(controller: passwordController, hintText: "Insira a Senha", obscureText: true,),
                  
                  const SizedBox(height: 10),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Esqueceu a senha?", style: TextStyle(color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),),),
                  
                  const SizedBox(height: 25),
              
                  MyButton(text: "Entrar", onTap: login,
                  ),
              
                  const SizedBox(height: 50),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Não tem uma conta?", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                      const SizedBox(width: 5),
                      GestureDetector(onTap: widget.onTap, 
                      child: Text("Cadastre-se", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
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