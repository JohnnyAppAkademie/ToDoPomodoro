import 'package:flutter/material.dart';
import 'package:todopomodoro/style.dart';

/// __AppHeaderWidget__ - Klasse
/// <br> Erstellt das Header - Widget. <br>
/// <br> __Required__:
/// * Der Title der Seite [String : title]
/// * Der Subtext des Titels [String : subtitle]
/// * Flag um Return-Button anzuzeigen [bool : returnButton]
class AppHeaderWidget extends StatelessWidget {
  /// __AppHeader__ - Konstructor
  /// <br>  Erstellt einen AppHeader ( es ist keine AppBar ). <br>
  /// <br>__Required__:
  /// * Titel der Page __[String : titel]__
  ///
  /// <br>__Optional__:
  /// * Der Sub-Titel der Page __[String : subtitle]__
  /// * Ist es eine Stack-Navigation ? __[bool: returnButton]__
  /// * * Stack-Navigator Funktion für den Button __[VoidCallback: callBack]
  const AppHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.returnButton = false,
    this.callBack,
  });

  final String title;
  final String? subtitle;
  final bool returnButton;
  final VoidCallback? callBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 5, right: 5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColours.label,
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Titel zentriert
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColours.lightText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (returnButton == true) ...[
                // Links: optionaler Zurückbutton
                Align(
                  alignment: Alignment.centerLeft,
                  child: returnButton
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColours.buttonUnpressed,
                          ),
                          onPressed: callBack,
                        )
                      : SizedBox(width: 48), // Platzhalter
                ),
              ],
              // Rechts: Profilbutton
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.person, color: AppColours.lightText),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          height: 35,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            color: AppColours.label,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: Offset(0, 4), // Schatten nach unten
              ),
            ],
          ),
          child: Column(
            children: [
              if (subtitle != null) ...[
                SizedBox(height: 5),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.italicHeader,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
