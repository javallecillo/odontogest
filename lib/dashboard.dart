import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String rolUsuario;

  const DashboardScreen({super.key, required this.rolUsuario});

  @override
  Widget build(BuildContext context) {
    // Colores oficiales extraídos exactamente de tu styleguide.css
    const colorPrincipal = Color(0xff2F405A);   // --colores-principal
    const colorSecundario = Color(0xffE6ABAA);  // --colores-secundario (Rosa)
    const colorCrema = Color(0xffF8FCED);       // --colores-blanco (Fondo general)
    const colorBlanco = Color(0xffFFFFFF);      // --colores-inputs (Tarjetas)

    return Scaffold(
      backgroundColor: colorCrema,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Banner Superior Azul (.nav) y Tarjeta de Usuario (.img) superpuesta
              SizedBox(
                height: 180, 
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Fondo Azul Oscuro (.nav: height 136px)
                    Container(
                      width: double.infinity,
                      height: 120,
                      color: colorPrincipal,
                    ),
                    
                    // Tarjeta Rosa del Usuario (.img: top 73px, left 15px, right 15px, height 90px)
                    Positioned(
                      top: 60,
                      left: 15,
                      right: 15,
                      height: 90,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: colorSecundario, // Rosa original de Figma
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Avatar (.ellipse + .cuenta)
                            const CircleAvatar(
                              radius: 28.5,
                              backgroundColor: colorPrincipal,
                              child: Icon(
                                Icons.person, 
                                color: colorSecundario, 
                                size: 35
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Textos del Usuario (.lbl-user y .lbl-description)
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dra. Sarai Orellana',
                                    style: TextStyle(
                                      fontFamily: 'Inter-SemiBold',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: colorPrincipal,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Odontólogo - Clinica Dental Ortonova',
                                    style: TextStyle(
                                      fontFamily: 'Inter-Medium',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: colorPrincipal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botón Cerrar Sesión (.cerrar-sesion)
                            IconButton(
                              icon: const Icon(Icons.logout, color: colorPrincipal, size: 25),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Título: Módulos del Sistema (.lbl-user-2: top 193px -> ajustado a padding)
              const Padding(
                padding: EdgeInsets.only(left: 30.0, top: 24.0, bottom: 20.0),
                child: Text(
                  'Módulos del Sistema',
                  style: TextStyle(
                    fontFamily: 'Inter-SemiBold',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: colorPrincipal,
                  ),
                ),
              ),

              // 3. Grilla de Módulos (.nav-2 y .nav-3: Blancas con sombra suave)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    // Módulo 1: Agenda de Citas
                    Expanded(
                      child: _buildFigmaModuleCard(
                        context,
                        icon: Icons.calendar_month_rounded,
                        title: 'Agenda de Citas',
                        subtitle: 'Control de Horarios',
                        colorPrincipal: colorPrincipal,
                        colorBlanco: colorBlanco,
                      ),
                    ),
                    const SizedBox(width: 25), // Espaciado intermedio proporcional
                    // Módulo 2: Expedientes
                    Expanded(
                      child: _buildFigmaModuleCard(
                        context,
                        icon: Icons.folder_shared_rounded,
                        title: 'Expedientes',
                        subtitle: 'Historiales clínicos',
                        colorPrincipal: colorPrincipal,
                        colorBlanco: colorBlanco,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tarjeta Blanca Limpia con Sombra Delicada (Fiel a .nav-2 y .nav-3 de Figma)
  Widget _buildFigmaModuleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color colorPrincipal,
    required Color colorBlanco,
  }) {
    return Container(
      height: 136, // Alto exacto del CSS (.nav-2)
      decoration: BoxDecoration(
        color: colorBlanco,
        borderRadius: BorderRadius.circular(24), // Radio suave de Figma
        boxShadow: [
          BoxShadow(
            color: colorPrincipal.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 36, color: colorPrincipal),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter-Bold',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorPrincipal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter-Medium',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: colorPrincipal.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}