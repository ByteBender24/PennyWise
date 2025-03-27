import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSignUp = false; // Default to Login Screen

  void _handleAuth() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    
    if (email.isNotEmpty && password.isNotEmpty) {
      User? user;
      if (isSignUp) {
        user = await _authService.signUpWithEmail(email, password);
      } else {
        user = await _authService.signInWithEmail(email, password);
      }

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${isSignUp ? "Sign-up" : "Login"} successful!")),
        );
        Navigator.pop(context); // Close Auth Screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${isSignUp ? "Sign-up" : "Login"} failed! Try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter email and password!")),
      );
    }
  }

  void _handleGoogleSignIn() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-in successful!")),
      );
      Navigator.pop(context); // Close Auth Screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-in failed! Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isSignUp ? "Sign Up" : "Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleAuth,
              child: Text(isSignUp ? "Sign Up" : "Login"),
            ),
            Divider(),
            SignInButton(
              Buttons.Google,
              text: "Continue with Google",
              onPressed: _handleGoogleSignIn,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isSignUp = !isSignUp;
                });
              },
              child: Text(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
