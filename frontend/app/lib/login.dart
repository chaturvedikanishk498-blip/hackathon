import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'student_dashboard.dart';
import 'parent_dashboard.dart';
import 'teacher_dashboard.dart';
import 'admin_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, parent, teacher, admin }

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen>
    with TickerProviderStateMixin {
  UserRole _selectedRole = UserRole.student;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _bgController;
  late AnimationController _cardController;
  late Animation<double> _cardSlide;
  late Animation<double> _cardFade;

  final Map<UserRole, RoleConfig> _roleConfigs = {
    UserRole.student: RoleConfig(
      label: 'Student',
      icon: Icons.school_rounded,
      emoji: '🎓',
      gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      accentColor: const Color(0xFF667EEA),
      bgColor: const Color(0xFFF0EEFF),
      description: 'Access your classes, assignments & grades',
    ),
    UserRole.parent: RoleConfig(
      label: 'Parent',
      icon: Icons.family_restroom_rounded,
      emoji: '👨‍👩‍👧',
      gradient: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
      accentColor: const Color(0xFF11998E),
      bgColor: const Color(0xFFE8FDF5),
      description: 'Monitor your child\'s progress & attendance',
    ),
    UserRole.teacher: RoleConfig(
      label: 'Teacher',
      icon: Icons.cast_for_education_rounded,
      emoji: '📚',
      gradient: [const Color(0xFFFC5C7D), const Color(0xFF6A82FB)],
      accentColor: const Color(0xFFFC5C7D),
      bgColor: const Color(0xFFFFF0F4),
      description: 'Manage classes, grades & student reports',
    ),
    UserRole.admin: RoleConfig(
      label: 'Admin',
      icon: Icons.admin_panel_settings_rounded,
      emoji: '🛡️',
      gradient: [const Color(0xFFFF8008), const Color(0xFFFFC837)],
      accentColor: const Color(0xFFFF8008),
      bgColor: const Color(0xFFFFF8EE),
      description: 'Full school management & analytics',
    ),
  };

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
       vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _cardSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    _cardController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _cardController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchRole(UserRole role) {
    if (_selectedRole == role) return;
    _cardController.reset();
    setState(() => _selectedRole = role);
    _cardController.forward();
  }


void _login() async {
  if (_emailController.text.trim().isEmpty ||
      _passwordController.text.trim().isEmpty) {
    _showSnack('Please fill in all fields');
    return;
  }

  FocusScope.of(context).unfocus();
  setState(() => _isLoading = true);

  try {
    final email = _emailController.text.trim();

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: _passwordController.text.trim(),
    );

    if (_selectedRole == UserRole.student && email != "student@gmail.com") {
      _showSnack("Please use Student account");
      return;
    }

    if (_selectedRole == UserRole.parent && email != "parent@gmail.com") {
      _showSnack("Please use Parent account");
      return;
    }

    if (_selectedRole == UserRole.teacher && email != "teacher@gmail.com") {
      _showSnack("Please use Teacher account");
      return;
    }

    if (_selectedRole == UserRole.admin && email != "admin@gmail.com") {
      _showSnack("Please use Admin account");
      return;
    }

    Widget dashboard;

    switch (_selectedRole) {
      case UserRole.student:
        dashboard = const StudentDashboard();
        break;
      case UserRole.parent:
        dashboard = const ParentDashboard();
        break;
      case UserRole.teacher:
        dashboard = const TeacherDashboard();
        break;
      case UserRole.admin:
        dashboard = const AdminDashboard();
        break;
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => dashboard),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-credential' ||
        e.code == 'wrong-password' ||
        e.code == 'user-not-found') {
      _showSnack("Invalid email or password");
    } else {
      _showSnack(e.message ?? "Login failed");
    }
  } catch (e) {
    print("ERROR: $e");
    _showSnack("Something went wrong");
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _roleConfigs[_selectedRole]!;

    return Scaffold(
      backgroundColor: config.bgColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: config.bgColor,
        child: Stack(
          children: [
            // Animated Background Blobs 
            Positioned.fill(
              child: _buildBlobBackground(config),
            ),
            // Safe flexible layout mapping (Fixes constrained/flex bugs when keyboard pops up in ScrollViews)
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 32),
                              _buildHeader(),
                              const SizedBox(height: 28),
                              _buildRoleSelector(config),
                            ],
                          ),
                          AnimatedBuilder(
                            animation: _cardController,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(0, _cardSlide.value),
                              child: Opacity(
                                opacity: _cardFade.value,
                                child: child,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24, top: 24),
                              child: _buildLoginCard(config),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlobBackground(RoleConfig config) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, _) {
        final t = _bgController.value;
        return Stack(
          children: [
            Positioned(
              top: -60 + math.sin(t * math.pi) * 20,
              right: -80 + math.cos(t * math.pi) * 15,
              child: _blob(220, config.gradient[0].withOpacity(0.18)),
            ),
            Positioned(
              bottom: 100 + math.cos(t * math.pi) * 25,
              left: -60 + math.sin(t * math.pi) * 10,
              child: _blob(180, config.gradient[1].withOpacity(0.15)),
            ),
            Positioned(
              top: 200 + math.sin(t * math.pi * 1.5) * 15,
              left: 40 + math.cos(t * math.pi) * 10,
              child: _blob(100, config.gradient[0].withOpacity(0.10)),
            ),
          ],
        );
      },
    );
  }

  Widget _blob(double size, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _roleConfigs[_selectedRole]!.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _roleConfigs[_selectedRole]!.accentColor.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text('EC', style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            )),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'EduConnect',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Smart School Management',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.45),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector(RoleConfig config) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: config.accentColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: UserRole.values.map((role) {
            final rc = _roleConfigs[role]!;
            final isSelected = _selectedRole == role;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque, // Critical optimization for fully transparent Tap spaces
                onTap: () => _switchRole(role),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: rc.gradient)
                        : null,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: rc.accentColor.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(rc.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 2),
                      Text(
                        rc.label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : Colors.black.withOpacity(0.5),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLoginCard(RoleConfig config) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: config.accentColor.withOpacity(0.12),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
          const BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: config.gradient),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(config.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${config.label} Login',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      config.description,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.black.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _buildTextField(
            controller: _emailController,
            label: 'Email / ID',
            hint: 'Enter your email',
            icon: Icons.alternate_email_rounded,
            config: config,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
            config: config,
            isPassword: true,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: config.accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLoginButton(config),
          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 16),
          _buildSSOButtons(config),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required RoleConfig config,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: config.bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: config.accentColor.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && _obscurePassword,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontSize: 14,
              ),
              prefixIcon: Icon(icon, color: config.accentColor, size: 20),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black38,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(RoleConfig config) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: config.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: config.accentColor.withOpacity(0.4),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In as ${config.label}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black.withOpacity(0.1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.black.withOpacity(0.1))),
      ],
    );
  }

  Widget _buildSSOButtons(RoleConfig config) {
    return Row(
      children: [
        Expanded(
          child: _ssoButton(
            label: 'Google',
            icon: Icons.g_mobiledata_rounded,
            color: const Color(0xFFEA4335),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ssoButton(
            label: 'Microsoft',
            icon: Icons.window_rounded,
            color: const Color(0xFF00A4EF),
          ),
        ),
      ],
    );
  }

  Widget _ssoButton({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleConfig {
  final String label;
  final IconData icon;
  final String emoji;
  final List<Color> gradient;
  final Color accentColor;
  final Color bgColor;
  final String description;

  const RoleConfig({
    required this.label,
    required this.icon,
    required this.emoji,
    required this.gradient,
    required this.accentColor,
    required this.bgColor,
    required this.description,
  });
}
