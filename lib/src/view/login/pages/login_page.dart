// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show UserProvider;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

/* Page - Import */
import 'package:todopomodoro/src/view/view.dart'
    show RegistrationPage, AuthWrapper;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    setState(() => _isLoading = true);

    final userProvider = context.read<UserProvider>();

    final success = await userProvider.login(
      userController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!success) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Fehler'),
          content: const Text('Login fehlgeschlagen!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthWrapper()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        titleTextStyle: context.textStyles.light.labelLarge,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wgap10),
          child: Column(
            children: [
              SizedBox(height: context.hgap5),

              Text("Welcome", style: context.textStyles.dark.titleSmall),
              SizedBox(height: context.hgap10),

              CustomContainer(
                childWidget: CustomTextField(
                  textController: userController,
                  focusNode: FocusNode(),
                  topic: "Please enter your Email or Username",
                  isPassword: false,
                  onChanged: (value) => {},
                ),
              ),
              SizedBox(height: context.hgap5),

              CustomContainer(
                childWidget: CustomTextField(
                  textController: passwordController,
                  focusNode: FocusNode(),
                  topic: 'Please enter your Password',
                  isPassword: true,
                  onChanged: (value) => {},
                ),
              ),
              SizedBox(height: context.hgap5),

              _isLoading
                  ? CircularProgressIndicator(
                      color: context.appStyle.writingHighlight,
                    )
                  : PinkButton(
                      func: () => _login(context),
                      label: 'Login',
                      icon: Icons.login,
                    ),

              SizedBox(height: context.hgap5),
              Text(
                "Did you not made an account yet?",
                style: context.textStyles.dark.labelSmall,
              ),
              SizedBox(height: context.hgap2),
              PinkButton(
                func: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                ),
                label: "Register",
                icon: Icons.add_box,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
