// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show UserProvider;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class SettingUserProfile extends StatefulWidget {
  const SettingUserProfile({super.key});

  @override
  State<SettingUserProfile> createState() => _SettingUserProfileState();
}

class _SettingUserProfileState extends State<SettingUserProfile> {
  late final UserProvider userController;

  @override
  void initState() {
    super.initState();
    userController = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Column(
            spacing: context.wgap5,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userController.currentUser!.username,
                    style: context.textStyles.dark.labelMedium,
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: context.appStyle.labelBackground.withValues(
                  alpha: 0.30,
                ),
                backgroundImage: AssetImage(
                  userController.currentUser!.profilePath,
                ),
                radius: context.screenWidth * 0.25,
              ),
            ],
          ),
          Positioned(
            top: context.hgap5,
            right: context.screenWidth * 0.15,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appStyle.writingLight,
              ),
              child: IconButton(
                onPressed: () async {
                  await _editProfile(context);
                },
                icon: Icon(
                  Icons.edit,
                  color: context.appStyle.writingHighlight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _editProfile(BuildContext context) async {
    final List<String> profilePictures = [
      "assets/pictures/profile/profile_1.png",
      "assets/pictures/profile/profile_2.png",
      "assets/pictures/profile/profile_3.png",
    ];

    int currentPage = 0;
    final PageController pageController = PageController(
      initialPage: 0,
      viewportFraction: 1,
    );

    final TextEditingController usernameController = TextEditingController(
      text: userController.currentUser!.username,
    );

    return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                children: [
                  // Hintergrund mit Blur-Effekt
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                  ),

                  // Zentrierte Benutzeroberfläche
                  Center(
                    child: Container(
                      width: context.screenWidth * 0.9,
                      height: context.screenHeight * 0.65,
                      decoration: BoxDecoration(
                        color: context.appStyle.background,
                        border: Border.all(
                          color: context.appStyle.writingDark,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Titelbereich
                              Container(
                                height: context.screenHeight * 0.06,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: context.appStyle.labelBackground,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Edit your profile",
                                    style: context.textStyles.light.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: context.hgap1),

                              // Name
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.wgap5,
                                ),
                                child: CustomContainer(
                                  childWidget: CustomTextField(
                                    textController: usernameController,
                                    focusNode: FocusNode(),
                                    onChanged: (String value) {},
                                    topic: "Enter your new Username",
                                    isPassword: false,
                                  ),
                                ),
                              ),
                              SizedBox(height: context.hgap5),

                              // Bildauswahl
                              SizedBox(
                                height: context.screenHeight * 0.33,
                                width: context.screenWidth * 0.40,
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount: profilePictures.length,
                                  onPageChanged: (page) {
                                    setState(() => currentPage = page);
                                  },
                                  itemBuilder: (context, index) {
                                    return CircleAvatar(
                                      key: ValueKey<int>(index),
                                      backgroundImage: AssetImage(
                                        profilePictures[index],
                                      ),
                                      radius: context.screenWidth * 0.22,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: context.hgap2),

                              // Speichern-Button
                              Container(
                                height: context.screenHeight * 0.06,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: context.appStyle.labelBackground,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: context.hgap1,
                                  horizontal: context.wgap2,
                                ),
                                child: PinkButton(
                                  func: () async {
                                    final newProfilePath =
                                        profilePictures[currentPage];
                                    await userController.updateProfilePicture(
                                      newProfilePath,
                                    );
                                    await userController.updateUsername(
                                      usernameController.text.trim(),
                                    );
                                    Restart.restartApp();
                                  },
                                  label: "Save",
                                  icon: Icons.save,
                                ),
                              ),
                            ],
                          ),
                          // Exit-Button
                          Positioned(
                            right: context.screenWidth * 0.02,
                            top: context.screenWidth * 0.01,

                            child: IconButton(
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: context.appStyle.writingLight,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          // Weiter-Pfeil
                          Positioned(
                            top: context.screenHeight * 0.35,
                            right: context.screenWidth * 0.02,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.appStyle.buttonBackgroundLight,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_right,
                                  size: context.hgap5,
                                  color:
                                      currentPage < profilePictures.length - 1
                                      ? context.appStyle.writingHighlight
                                      : context.appStyle.labelBackground
                                            .withValues(alpha: 0.3),
                                ),
                                onPressed:
                                    currentPage < profilePictures.length - 1
                                    ? () {
                                        pageController.nextPage(
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    : null,
                              ),
                            ),
                          ),

                          // Zurück-Pfeil
                          Positioned(
                            top: context.screenHeight * 0.35,
                            left: context.screenWidth * 0.02,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.appStyle.buttonBackgroundLight,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_left,
                                  size: context.hgap5,
                                  color: currentPage > 0
                                      ? context.appStyle.writingHighlight
                                      : context.appStyle.labelBackground
                                            .withValues(alpha: 0.3),
                                ),
                                onPressed: currentPage > 0
                                    ? () {
                                        pageController.previousPage(
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                          curve: Curves.easeIn,
                                        );
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
