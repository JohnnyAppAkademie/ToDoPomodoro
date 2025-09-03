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
import 'package:todopomodoro/src/view/login/pages/login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final profileController = PageController(viewportFraction: 0.75);

  late String profilPicture;
  int currentPage = 0;

  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    profileController.dispose();
    super.dispose();
  }

  Future<void> _register(BuildContext context) async {
    setState(() => _isLoading = true);

    final userProvider = context.read<UserProvider>();

    final success = await userProvider.register(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      profilePath: profilPicture,
    );

    setState(() => _isLoading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? 'Erfolg' : 'Fehler'),
        content: Text(
          success
              ? 'Registrierung erfolgreich!'
              : 'Registrierung fehlgeschlagen! E-Mail evtl. schon vorhanden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const LoginPage())),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> profilePictures = [
      "assets/pictures/profile/profile_1.png",
      "assets/pictures/profile/profile_2.png",
      "assets/pictures/profile/profile_3.png",
    ];

    profilPicture = profilePictures[0];

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrierung"),
        titleTextStyle: context.textStyles.light.labelLarge,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.wgap10),
          child: Column(
            children: [
              /* Username */
              CustomContainer(
                childWidget: CustomTextField(
                  textController: usernameController,
                  focusNode: FocusNode(),
                  onChanged: (String value) {},
                  topic: 'Enter a Username',
                  isPassword: false,
                ),
              ),
              SizedBox(height: context.hgap5),

              /* Email */
              CustomContainer(
                childWidget: CustomTextField(
                  textController: emailController,
                  focusNode: FocusNode(),
                  onChanged: (String value) {},
                  topic: 'Enter a Email',
                  isPassword: false,
                ),
              ),
              SizedBox(height: context.hgap5),

              /* Passwort */
              CustomContainer(
                childWidget: CustomTextField(
                  textController: passwordController,
                  focusNode: FocusNode(),
                  onChanged: (String value) {},
                  topic: 'Enter a Password',
                  isPassword: true,
                ),
              ),
              SizedBox(height: context.hgap5),

              /* Bildauswahl */
              SizedBox(
                height: context.screenHeight * 0.25,
                width: context.screenWidth * 0.95,
                child: CustomContainer(
                  childWidget: Row(
                    children: [
                      // Zurück-Pfeil
                      IconButton(
                        icon: Icon(
                          Icons.arrow_left,
                          size: 32,
                          color: currentPage > 0
                              ? context.appStyle.writingHighlight
                              : Colors.grey.withValues(alpha: 0.3),
                        ),
                        onPressed: currentPage > 0
                            ? () {
                                profileController.previousPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                      ),

                      // Bildbereich
                      Expanded(
                        child: PageView.builder(
                          controller: profileController,
                          itemCount: profilePictures.length,
                          onPageChanged: (page) {
                            setState(() {
                              profilPicture = profilePictures[page];
                              currentPage = page;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Center(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  profilePictures[index],
                                ),
                                radius: 80,
                              ),
                            );
                          },
                        ),
                      ),

                      // Weiter-Pfeil
                      IconButton(
                        icon: Icon(
                          Icons.arrow_right,
                          size: 32,
                          color: currentPage < profilePictures.length - 1
                              ? context.appStyle.writingHighlight
                              : Colors.grey.withValues(alpha: 0.3),
                        ),
                        onPressed: currentPage < profilePictures.length - 1
                            ? () {
                                profileController.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: context.hgap5),

              /* Login */
              _isLoading
                  ? CircularProgressIndicator(
                      color: context.appStyle.writingHighlight,
                    )
                  : PinkButton(
                      func: () => _register(context),
                      label: 'Registrieren',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
