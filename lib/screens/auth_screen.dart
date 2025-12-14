// Pantalla de Autenticación (Login y Registro)
// EXPLICAR EN EXPOSICIÓN: Esta pantalla permite a los usuarios:
// - Iniciar sesión con email y contraseña
// - Crear una cuenta nueva (registro)
// - Cambiar entre modo login y registro
// Usa Riverpod para manejar el estado de autenticación

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

/// Widget principal de la pantalla de autenticación
/// ConsumerStatefulWidget permite usar Riverpod y tener estado local
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  // Variable para alternar entre login y registro
  bool _isLogin = true;

  // Key para validar el formulario
  // EXPLICAR: GlobalKey permite acceder al estado del formulario desde fuera
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para los campos del formulario
  // EXPLICAR: TextEditingController permite leer y modificar el texto de un TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Variable para checkbox de términos y condiciones
  bool _acceptTerms = false;

  /// Limpiar recursos al destruir el widget
  /// EXPLICAR: Los controladores deben liberarse para evitar memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Función para enviar el formulario
  /// EXPLICAR: Se ejecuta al presionar botón de Login o Registro
  Future<void> _submit() async {
    // Validar campos del formulario
    if (!_formKey.currentState!.validate()) return;

    // Si es registro, validar que se aceptaron los términos
    if (!_isLogin && !_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos')),
      );
      return;
    }

    try {
      if (_isLogin) {
        // Modo LOGIN: llamar a login del provider
        // EXPLICAR: ref.read obtiene el notifier para ejecutar acciones
        await ref
            .read(authProvider.notifier)
            .login(_emailController.text.trim(), _passwordController.text);
      } else {
        // Modo REGISTRO: llamar a register del provider
        // Convertir datos a Map para el provider
        await ref.read(authProvider.notifier).register({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'phone': _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        });
      }

      // Mostrar mensaje de éxito
      // EXPLICAR: mounted verifica si el widget sigue en el árbol
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isLogin ? '¡Bienvenido!' : '¡Cuenta creada exitosamente!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );

        // Navegar al home screen automáticamente
        // EXPLICAR: pushReplacementNamed reemplaza la pantalla actual
        // para que el usuario no pueda volver atrás a la pantalla de login
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      // Mostrar mensaje de error si falla el login/registro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observar el estado de autenticación
    // EXPLICAR: ref.watch escucha cambios y reconstruye el widget
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        // Gradiente de fondo morado
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple, Colors.deepPurple.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Cremosos',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(_isLogin ? 'Inicia sesión' : 'Crea tu cuenta'),
                        const SizedBox(height: 24),
                        if (!_isLogin) ...[
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'Ingresa tu nombre'
                                : null,
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Ingresa email'
                              : !v.contains('@')
                              ? 'Email inválido'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        if (!_isLogin) ...[
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Teléfono (opcional)',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Ingresa contraseña'
                              : !_isLogin && v.length < 6
                              ? 'Mínimo 6 caracteres'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        if (!_isLogin) ...[
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirmar',
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v != _passwordController.text
                                ? 'No coinciden'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            value: _acceptTerms,
                            onChanged: (v) =>
                                setState(() => _acceptTerms = v ?? false),
                            title: const Text('Acepto términos'),
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isLogin ? 'INICIAR SESIÓN' : 'REGISTRARSE',
                                  ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            _isLogin = !_isLogin;
                            _formKey.currentState?.reset();
                          }),
                          child: Text(
                            _isLogin
                                ? '¿No tienes cuenta? Regístrate'
                                : '¿Ya tienes cuenta? Inicia sesión',
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Credenciales de prueba:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.deepPurple.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '👨‍💼 Admin: admin@cremosos.com / 123456',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '👥 Clientes:',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• María García: maria.garcia@email.com / 123456',
                                style: TextStyle(fontSize: 10),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '• Carlos López: carlos.lopez@email.com / 123456',
                                style: TextStyle(fontSize: 10),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '• Ana Martínez: ana.martinez@email.com / 123456',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
