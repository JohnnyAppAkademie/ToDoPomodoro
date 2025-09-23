// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My TodoPomodoro App`
  String get appTitle {
    return Intl.message(
      'My TodoPomodoro App',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __localication_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__localication_0__',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get german {
    return Intl.message('German', name: 'german', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `_________END_________`
  String get __localication_1__ {
    return Intl.message(
      '_________END_________',
      name: '__localication_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __loading_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__loading_0__',
      desc: '',
      args: [],
    );
  }

  /// `Currently loading the user`
  String get user_load {
    return Intl.message(
      'Currently loading the user',
      name: 'user_load',
      desc: '',
      args: [],
    );
  }

  /// `Currently loading the tasks`
  String get task_load {
    return Intl.message(
      'Currently loading the tasks',
      name: 'task_load',
      desc: '',
      args: [],
    );
  }

  /// `_________END_________`
  String get __loading_1__ {
    return Intl.message(
      '_________END_________',
      name: '__loading_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __error_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__error_0__',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get error_login {
    return Intl.message(
      'Login failed',
      name: 'error_login',
      desc: '',
      args: [],
    );
  }

  /// `Task name can not be empty`
  String get error_tag_name {
    return Intl.message(
      'Task name can not be empty',
      name: 'error_tag_name',
      desc: '',
      args: [],
    );
  }

  /// `Tag name can not be empty`
  String get error_task_name {
    return Intl.message(
      'Tag name can not be empty',
      name: 'error_task_name',
      desc: '',
      args: [],
    );
  }

  /// `_________END_________`
  String get __error_1__ {
    return Intl.message(
      '_________END_________',
      name: '__error_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __general_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__general_0__',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `ok`
  String get ok {
    return Intl.message('ok', name: 'ok', desc: '', args: []);
  }

  /// `_________END_________`
  String get __general_1__ {
    return Intl.message(
      '_________END_________',
      name: '__general_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __login_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__login_0__',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Email`
  String get login_email {
    return Intl.message(
      'Please enter your Email',
      name: 'login_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Password`
  String get login_password {
    return Intl.message(
      'Please enter your Password',
      name: 'login_password',
      desc: '',
      args: [],
    );
  }

  /// `Did you not make an account yet?`
  String get login_no_account {
    return Intl.message(
      'Did you not make an account yet?',
      name: 'login_no_account',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get login_register {
    return Intl.message('Register', name: 'login_register', desc: '', args: []);
  }

  /// `_________END_________`
  String get __login_1__ {
    return Intl.message(
      '_________END_________',
      name: '__login_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __registration_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__registration_0__',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Enter a username`
  String get registration_username {
    return Intl.message(
      'Enter a username',
      name: 'registration_username',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Email`
  String get registration_email {
    return Intl.message(
      'Enter a Email',
      name: 'registration_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Password`
  String get registration_password {
    return Intl.message(
      'Enter a Password',
      name: 'registration_password',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registration_register {
    return Intl.message(
      'Register',
      name: 'registration_register',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful`
  String get registration_success {
    return Intl.message(
      'Registration successful',
      name: 'registration_success',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get registration_failed {
    return Intl.message(
      'Registration failed',
      name: 'registration_failed',
      desc: '',
      args: [],
    );
  }

  /// `_________END_________`
  String get __registration_1__ {
    return Intl.message(
      '_________END_________',
      name: '__registration_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __home_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__home_0__',
      desc: '',
      args: [],
    );
  }

  /// `Selfcare is important`
  String get home_selfcare_header {
    return Intl.message(
      'Selfcare is important',
      name: 'home_selfcare_header',
      desc: '',
      args: [],
    );
  }

  /// `So take care during your day, take your breaky and breathe.`
  String get home_selfcare_1 {
    return Intl.message(
      'So take care during your day, take your breaky and breathe.',
      name: 'home_selfcare_1',
      desc: '',
      args: [],
    );
  }

  /// `Find your own Rhythm throughout the day using this app.`
  String get home_selfcare_2 {
    return Intl.message(
      'Find your own Rhythm throughout the day using this app.',
      name: 'home_selfcare_2',
      desc: '',
      args: [],
    );
  }

  /// `Finish your tasks in your own pace, without stress or forgetting them.`
  String get home_selfcare_3 {
    return Intl.message(
      'Finish your tasks in your own pace, without stress or forgetting them.',
      name: 'home_selfcare_3',
      desc: '',
      args: [],
    );
  }

  /// `Adding Task / Tag`
  String get add_header {
    return Intl.message(
      'Adding Task / Tag',
      name: 'add_header',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to add?`
  String get add_text {
    return Intl.message(
      'What do you want to add?',
      name: 'add_text',
      desc: '',
      args: [],
    );
  }

  /// `_________END_________`
  String get __home_1__ {
    return Intl.message(
      '_________END_________',
      name: '__home_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __tag_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__tag_0__',
      desc: '',
      args: [],
    );
  }

  /// `Tag`
  String get tag {
    return Intl.message('Tag', name: 'tag', desc: '', args: []);
  }

  /// `No Tags`
  String get no_tags {
    return Intl.message('No Tags', name: 'no_tags', desc: '', args: []);
  }

  /// `Entry`
  String get task_entry {
    return Intl.message('Entry', name: 'task_entry', desc: '', args: []);
  }

  /// `Entries`
  String get task_entries {
    return Intl.message('Entries', name: 'task_entries', desc: '', args: []);
  }

  /// `Tag-Creation`
  String get tag_setting_create {
    return Intl.message(
      'Tag-Creation',
      name: 'tag_setting_create',
      desc: '',
      args: [],
    );
  }

  /// `Tag-Adjustment`
  String get tag_setting_adjust {
    return Intl.message(
      'Tag-Adjustment',
      name: 'tag_setting_adjust',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Tag name`
  String get tag_setting_tag_name {
    return Intl.message(
      'Enter a Tag name',
      name: 'tag_setting_tag_name',
      desc: '',
      args: [],
    );
  }

  /// `Add Tasks`
  String get tag_setting_add_task {
    return Intl.message(
      'Add Tasks',
      name: 'tag_setting_add_task',
      desc: '',
      args: [],
    );
  }

  /// `Select Tasks`
  String get tag_setting_selection {
    return Intl.message(
      'Select Tasks',
      name: 'tag_setting_selection',
      desc: '',
      args: [],
    );
  }

  /// `Delete Tag`
  String get delete_tag_header {
    return Intl.message(
      'Delete Tag',
      name: 'delete_tag_header',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure, you want to delete this Tag?`
  String get delete_tag_text_1 {
    return Intl.message(
      'Are you sure, you want to delete this Tag?',
      name: 'delete_tag_text_1',
      desc: '',
      args: [],
    );
  }

  /// `This action can not be undone.`
  String get delete_tag_text_2 {
    return Intl.message(
      'This action can not be undone.',
      name: 'delete_tag_text_2',
      desc: '',
      args: [],
    );
  }

  /// `Delete Tag`
  String get delete_tag_confirm {
    return Intl.message(
      'Delete Tag',
      name: 'delete_tag_confirm',
      desc: '',
      args: [],
    );
  }

  /// `_________END_________`
  String get __tag_1__ {
    return Intl.message(
      '_________END_________',
      name: '__tag_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __task_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__task_0__',
      desc: '',
      args: [],
    );
  }

  /// `Task`
  String get task {
    return Intl.message('Task', name: 'task', desc: '', args: []);
  }

  /// `No Tasks`
  String get no_task {
    return Intl.message('No Tasks', name: 'no_task', desc: '', args: []);
  }

  /// `Task-Creation`
  String get task_setting_create {
    return Intl.message(
      'Task-Creation',
      name: 'task_setting_create',
      desc: '',
      args: [],
    );
  }

  /// `Task-Adjustment`
  String get task_setting_adjust {
    return Intl.message(
      'Task-Adjustment',
      name: 'task_setting_adjust',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Taskname`
  String get task_setting_task {
    return Intl.message(
      'Enter a Taskname',
      name: 'task_setting_task',
      desc: '',
      args: [],
    );
  }

  /// `Associated Tags`
  String get task_setting_tag {
    return Intl.message(
      'Associated Tags',
      name: 'task_setting_tag',
      desc: '',
      args: [],
    );
  }

  /// `Duration of the Task`
  String get task_setting_duration {
    return Intl.message(
      'Duration of the Task',
      name: 'task_setting_duration',
      desc: '',
      args: [],
    );
  }

  /// `Delete Task`
  String get delete_task {
    return Intl.message('Delete Task', name: 'delete_task', desc: '', args: []);
  }

  /// `Deleting Task?`
  String get delete_task_header {
    return Intl.message(
      'Deleting Task?',
      name: 'delete_task_header',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure, you want to delete this Task?`
  String get delete_task_text_1 {
    return Intl.message(
      'Are you sure, you want to delete this Task?',
      name: 'delete_task_text_1',
      desc: '',
      args: [],
    );
  }

  /// `This action can not be undone.`
  String get delete_task_text_2 {
    return Intl.message(
      'This action can not be undone.',
      name: 'delete_task_text_2',
      desc: '',
      args: [],
    );
  }

  /// `Delete Task`
  String get delete_task_confirm {
    return Intl.message(
      'Delete Task',
      name: 'delete_task_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Remove Task`
  String get remove_task {
    return Intl.message('Remove Task', name: 'remove_task', desc: '', args: []);
  }

  /// `Removing Task?`
  String get remove_task_header {
    return Intl.message(
      'Removing Task?',
      name: 'remove_task_header',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure, you want to remove this Task?`
  String get remove_task_text_1 {
    return Intl.message(
      'Are you sure, you want to remove this Task?',
      name: 'remove_task_text_1',
      desc: '',
      args: [],
    );
  }

  /// `Remove Task`
  String get remove_task_confirm {
    return Intl.message(
      'Remove Task',
      name: 'remove_task_confirm',
      desc: '',
      args: [],
    );
  }

  /// `_________END_________`
  String get __task_1__ {
    return Intl.message(
      '_________END_________',
      name: '__task_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __history_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__history_0__',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `No History found`
  String get no_history {
    return Intl.message(
      'No History found',
      name: 'no_history',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get history_today {
    return Intl.message('Today', name: 'history_today', desc: '', args: []);
  }

  /// `Yesterday`
  String get history_yesterday {
    return Intl.message(
      'Yesterday',
      name: 'history_yesterday',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get history_end {
    return Intl.message('End', name: 'history_end', desc: '', args: []);
  }

  /// `Not finished`
  String get history_not_finished {
    return Intl.message(
      'Not finished',
      name: 'history_not_finished',
      desc: '',
      args: [],
    );
  }

  /// `_________END_________`
  String get __history_1__ {
    return Intl.message(
      '_________END_________',
      name: '__history_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __pomodoro_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__pomodoro_0__',
      desc: '',
      args: [],
    );
  }

  /// `Total time:`
  String get pomodoro_total_time {
    return Intl.message(
      'Total time:',
      name: 'pomodoro_total_time',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pomodoro_pause {
    return Intl.message('Pause', name: 'pomodoro_pause', desc: '', args: []);
  }

  /// `Resume`
  String get pomodoro_resume {
    return Intl.message('Resume', name: 'pomodoro_resume', desc: '', args: []);
  }

  /// `Phase`
  String get pomodoro_phase {
    return Intl.message('Phase', name: 'pomodoro_phase', desc: '', args: []);
  }

  /// `Idle`
  String get phase_idle {
    return Intl.message('Idle', name: 'phase_idle', desc: '', args: []);
  }

  /// `Pomodoro`
  String get phase_pomodoro {
    return Intl.message('Pomodoro', name: 'phase_pomodoro', desc: '', args: []);
  }

  /// `Short Break`
  String get phase_short_break {
    return Intl.message(
      'Short Break',
      name: 'phase_short_break',
      desc: '',
      args: [],
    );
  }

  /// `Long Break`
  String get phase_long_break {
    return Intl.message(
      'Long Break',
      name: 'phase_long_break',
      desc: '',
      args: [],
    );
  }

  /// `Paused`
  String get phase_paused {
    return Intl.message('Paused', name: 'phase_paused', desc: '', args: []);
  }

  /// `Finished`
  String get phase_finished {
    return Intl.message('Finished', name: 'phase_finished', desc: '', args: []);
  }

  /// `_________END_________`
  String get __pomodoro_1__ {
    return Intl.message(
      '_________END_________',
      name: '__pomodoro_1__',
      desc: '',
      args: [],
    );
  }

  /// `________BEGIN________`
  String get __setting_0__ {
    return Intl.message(
      '________BEGIN________',
      name: '__setting_0__',
      desc: '',
      args: [],
    );
  }

  /// `Reset data`
  String get setting_reset_app_data {
    return Intl.message(
      'Reset data',
      name: 'setting_reset_app_data',
      desc: '',
      args: [],
    );
  }

  /// `Logged out`
  String get setting_logged_out {
    return Intl.message(
      'Logged out',
      name: 'setting_logged_out',
      desc: '',
      args: [],
    );
  }

  /// `Date reset`
  String get setting_data_reset {
    return Intl.message(
      'Date reset',
      name: 'setting_data_reset',
      desc: '',
      args: [],
    );
  }

  /// `Edit your profile`
  String get setting_edit_profile {
    return Intl.message(
      'Edit your profile',
      name: 'setting_edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new Username`
  String get setting_enter_username {
    return Intl.message(
      'Enter your new Username',
      name: 'setting_enter_username',
      desc: '',
      args: [],
    );
  }

  /// `_________END_________`
  String get __setting_1__ {
    return Intl.message(
      '_________END_________',
      name: '__setting_1__',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
