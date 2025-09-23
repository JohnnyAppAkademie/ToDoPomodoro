import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My TodoPomodoro App'**
  String get appTitle;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @user_load.
  ///
  /// In en, this message translates to:
  /// **'Currently loading the user'**
  String get user_load;

  /// No description provided for @task_load.
  ///
  /// In en, this message translates to:
  /// **'Currently loading the tasks'**
  String get task_load;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Email'**
  String get enter_email;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Password'**
  String get enter_password;

  /// No description provided for @info_no_account.
  ///
  /// In en, this message translates to:
  /// **'Did you not make an account yet?'**
  String get info_no_account;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @registration_success.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registration_success;

  /// No description provided for @registration_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registration_failed;

  /// No description provided for @registration_username.
  ///
  /// In en, this message translates to:
  /// **'Enter a username'**
  String get registration_username;

  /// No description provided for @registration_email.
  ///
  /// In en, this message translates to:
  /// **'Enter a Email'**
  String get registration_email;

  /// No description provided for @registration_pass.
  ///
  /// In en, this message translates to:
  /// **'Enter a Password'**
  String get registration_pass;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get ok;

  /// No description provided for @selfcare.
  ///
  /// In en, this message translates to:
  /// **'Selfcare is important'**
  String get selfcare;

  /// No description provided for @s_1.
  ///
  /// In en, this message translates to:
  /// **'So take care during your day, take your breaky and breathe.'**
  String get s_1;

  /// No description provided for @s_2.
  ///
  /// In en, this message translates to:
  /// **'Find your own Rhythm throughout the day using this app.'**
  String get s_2;

  /// No description provided for @s_3.
  ///
  /// In en, this message translates to:
  /// **'Finish your tasks in your own pace, without stress or forgetting them.'**
  String get s_3;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @no_tags.
  ///
  /// In en, this message translates to:
  /// **'No Tags'**
  String get no_tags;

  /// No description provided for @task_entry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get task_entry;

  /// No description provided for @task_entries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get task_entries;

  /// No description provided for @tag_setting_create.
  ///
  /// In en, this message translates to:
  /// **'Tag-Creation'**
  String get tag_setting_create;

  /// No description provided for @tag_setting_adjust.
  ///
  /// In en, this message translates to:
  /// **'Tag-Adjustment'**
  String get tag_setting_adjust;

  /// No description provided for @add_task.
  ///
  /// In en, this message translates to:
  /// **'Add Tasks'**
  String get add_task;

  /// No description provided for @selection_task.
  ///
  /// In en, this message translates to:
  /// **'Select Tasks'**
  String get selection_task;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @no_task.
  ///
  /// In en, this message translates to:
  /// **'No Tasks'**
  String get no_task;

  /// No description provided for @task_setting_create.
  ///
  /// In en, this message translates to:
  /// **'Task-Creation'**
  String get task_setting_create;

  /// No description provided for @task_setting_adjust.
  ///
  /// In en, this message translates to:
  /// **'Task-Adjustment'**
  String get task_setting_adjust;

  /// No description provided for @enter_task.
  ///
  /// In en, this message translates to:
  /// **'Enter a Taskname'**
  String get enter_task;

  /// No description provided for @associated_tag.
  ///
  /// In en, this message translates to:
  /// **'Associated Tags'**
  String get associated_tag;

  /// No description provided for @enter_duration_task.
  ///
  /// In en, this message translates to:
  /// **'Duration of the Task'**
  String get enter_duration_task;

  /// No description provided for @delete_task.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get delete_task;

  /// No description provided for @remove_task.
  ///
  /// In en, this message translates to:
  /// **'Remove Task'**
  String get remove_task;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @not_finished.
  ///
  /// In en, this message translates to:
  /// **'Not finished'**
  String get not_finished;

  /// No description provided for @total_time.
  ///
  /// In en, this message translates to:
  /// **'Total time:'**
  String get total_time;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @short_break.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get short_break;

  /// No description provided for @long_break.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get long_break;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @reset_app_data.
  ///
  /// In en, this message translates to:
  /// **'Reset data'**
  String get reset_app_data;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit your profile'**
  String get edit_profile;

  /// No description provided for @enter_username.
  ///
  /// In en, this message translates to:
  /// **'Enter your new Username'**
  String get enter_username;

  /// No description provided for @error_login.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get error_login;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
