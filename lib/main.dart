import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dashboard.dart';

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
        scaffoldBackgroundColor: const Color(0xffF8FCED), // Fondo crema general
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _conectarLogin() async {
    String usuario = _userController.text.trim();
    String contrasena = _passwordController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      _mostrarAlerta("Por favor, llena todos los campos");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // URL optimizada para pruebas en el navegador web
      final url = Uri.parse('http://localhost:8080/odontogest-api/login.php');

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
        String nombreRol = data['usuario']['rol'];

        if (!mounted) return;

        ScaffoldMessenger.of(context).clearSnackBars();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(rolUsuario: nombreRol),
          ),
        );
      } else {
        String mensajeError = data['error'] ?? "Error desconocido.";
        _mostrarAlerta(mensajeError);
      }
    } catch (e) {
      _mostrarAlerta("No se pudo conectar al servidor. Verifica que Laragon esté encendido.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarAlerta(String mensaje, {bool esExito = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, textAlign: TextAlign.center),
        backgroundColor: esExito ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final esHorizontal = size.width > size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF8FCED), // Mantiene el fondo crema limpio de base
      resizeToAvoidBottomInset: true, 
      body: SafeArea(
        top: false, 
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // 1. Encabezado Azul Ortonova con Arco Adaptativo Inteligente
                      ClipPath(
                        clipper: ArcoFigmaClipper(esHorizontal: esHorizontal),
                        child: Container(
                          width: size.width,
                          // Ajuste dinámico de la altura del fondo para que no asfixie al logo
                          height: esHorizontal ? size.height * 0.52 : size.height * 0.38,
                          color: const Color(0xff2F405A),
                          child: SafeArea(
                            bottom: false,
                            child: Center(
                              child: Padding(
                                // Distribución de aire equilibrada: más espacio abajo para que no choque con la curva
                                padding: EdgeInsets.only(
                                  left: 24.0, 
                                  right: 24.0, 
                                  top: esHorizontal ? 10.0 : 20.0, 
                                  bottom: esHorizontal ? 35.0 : 100.0
                                ),
                                child: Image.asset(
                                  'assets/logo_ortonova.png',
                                  // Escala proporcional perfecta en ambas orientaciones
                                  height: esHorizontal ? size.height * 0.28 : size.height * 0.19,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 2. Formulario inferior
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: esHorizontal ? size.width * 0.15 : 40.0, 
                            vertical: esHorizontal ? 10.0 : 20.0
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Inicio de Sesión',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2F405A),
                                ),
                              ),
                              SizedBox(height: esHorizontal ? 15 : 25),

                              // Campo de Usuario
                              _buildTextField(
                                controlador: _userController,
                                etiqueta: 'Usuario:',
                                ocultar: false,
                              ),
                              const SizedBox(height: 22),

                              // Campo de Contraseña
                              _buildTextField(
                                controlador: _passwordController,
                                etiqueta: 'Contraseña:',
                                ocultar: true,
                              ),
                              SizedBox(height: esHorizontal ? 20 : 35),

                              // Botón Ingresar
                              SizedBox(
                                width: esHorizontal ? size.width * 0.35 : size.width * 0.60,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _conectarLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff2F405A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(color: Color(0xffF8FCED))
                                      : const Text(
                                          'Ingresar',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffF8FCED),
                                          ),
                                        ),
                                ),
                              ),
                              
                              if (!esHorizontal) const Spacer(),
                              const SizedBox(height: 25),

                              // Pie de página comercial
                              Text(
                                'OdontoGest Mobile Suite - Versión 1.0.0',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: const Color(0xff2F405A).withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }  
  // Widget reutilizable para mantener los inputs idénticos al Figma (CORREGIDO: con const optimizado y withValues)
  Widget _buildTextField({
    required TextEditingController controlador,
    required String etiqueta,
    required bool ocultar,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff2F405A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), // Formato moderno para Flutter 3.44+
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controlador,
            obscureText: ocultar,
            cursorColor: const Color(0xff2F405A),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffFFFFFF), // Relleno Blanco
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: const Color(0xffE6ABAA).withValues(alpha: 0.60), // Rosa con 60% opacidad en formato moderno
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xff2F405A), // Azul al enfocar
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Recortador personalizado adaptativo al giro de pantalla
class ArcoFigmaClipper extends CustomClipper<Path> {
  final bool esHorizontal;

  ArcoFigmaClipper({required this.esHorizontal});

  @override
  Path getClip(Size size) {
    Path path = Path();
    
    // Si la pantalla es horizontal, suavizamos la altura del arco para ganar espacio vertical
    double alturaArcoEfectiva = esHorizontal ? 30.0 : 50.0;
    double profundidadPuntoControl = esHorizontal ? 65.0 : 110.0;

    // Trazamos el inicio izquierdo
    path.lineTo(0, size.height - alturaArcoEfectiva);

    // Puntos para generar la curva cóncava perfecta hacia arriba
    var puntoControl = Offset(size.width / 2, size.height - profundidadPuntoControl);
    var puntoDestino = Offset(size.width, size.height - alturaArcoEfectiva);

    path.quadraticBezierTo(puntoControl.dx, puntoControl.dy, puntoDestino.dx, puntoDestino.dy);
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant ArcoFigmaClipper oldClipper) {
    return oldClipper.esHorizontal != esHorizontal;
  }
}