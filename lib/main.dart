import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OdontoGest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar el texto de los inputs
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  
  bool _isLoading = false;

  // Función principal que conectará con tu API en Laragon
  Future<void> _conectarLogin() async {
    final String usuario = _usuarioController.text.trim();
    final String contrasena = _contrasenaController.text;

    // Validación básica en el cliente
    if (usuario.isEmpty || contrasena.isEmpty) {
      _mostrarAlerta("Por favor, llena todos los campos.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // REGLA DE ORO: 10.0.2.2 apunta al localhost de tu PC desde el emulador de Android
    //final url = Uri.parse('http://10.0.2.2:8080/odontogest-api/login.php');
    final url = Uri.parse('http://localhost:8080/odontogest-api/login.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': usuario,
          'contrasena': contrasena,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Autenticación Exitosa
        String nombreRol = data['usuario']['rol'];
        _mostrarAlerta("¡Bienvenido! Rol: $nombreRol", esExito: true);
      } else {
        // Credenciales incorrectas o error devuelto por la API
        String mensajeError = data['error'] ?? "Error desconocido.";
        _mostrarAlerta(mensajeError);
      }
    } catch (e) {
      // Error si no encuentra el servidor de Laragon
      _mostrarAlerta("No se pudo conectar al servidor. Verifica que Laragon esté encendido.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _mostrarAlerta(String mensaje, {bool esExito = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esExito ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_hospital, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Clínica Ortonova',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const Text('Sistema OdontoGest', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              
              // Input de Usuario
              TextField(
                controller: _usuarioController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              // Input de Contraseña
              TextField(
                controller: _contrasenaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              // Botón de Ingresar con validador de carga
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _conectarLogin,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Ingresar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}