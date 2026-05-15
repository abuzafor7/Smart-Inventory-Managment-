import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory, size: 80, color: Color(0xFFE4002B)),
            const SizedBox(height: 40),
            TextField(decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 20),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE4002B), minimumSize: const Size(double.infinity, 55)),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen())),
              child: const Text('LOGIN', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}