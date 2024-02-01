import 'package:flutter/material.dart';

import '../services/service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de connexion'),
            content: Text('Une erreur s\'est produite lors de la connexion.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    void _goToAccueil() {
      Navigator.pushReplacementNamed(context, '/accueil');
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 17, 17),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.redAccent[700]),
        backgroundColor: Color.fromARGB(255, 17, 17, 17),
        title: Text(
          'Login',
          style: TextStyle(color: Colors.redAccent[700]),
        ),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre adresse e-mail';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent[700])),
                    child: isloading
                        ? SizedBox(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                            width: 20,
                            height: 20,
                          )
                        : Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                    onPressed: () async {
                      if (isloading) return;
                      setState(() => isloading = true);
                      await Future.delayed(Duration(seconds: 2));
                      setState(() => isloading = false);
                      if (_formKey.currentState!.validate()) {
                        final String? token = await Service.login(
                          _emailController.text,
                          _passwordController.text,
                        );

                        if (token != null) {
                          print('Token: $token');
                          _goToAccueil();
                        } else {
                          print('Échec de la connexion');
                          _showErrorDialog();
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.redAccent[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
