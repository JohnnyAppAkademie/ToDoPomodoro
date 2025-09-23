// ignore_for_file: use_build_context_synchronously

/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show HistoryProvider, UserProvider;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart' show HistoryEntry;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Lade die History einmal beim Start
    final userID = context.read<UserProvider>().currentUser!.uID;
    Future.microtask(() => context.read<HistoryProvider>().loadHistory(userID));
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final historyList = historyProvider.history;

    if (historyList.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(title: S.of(context).history),
        body: Center(
          child: Text(
            S.of(context).no_history,
            style: context.textStyles.dark.bodyLarge,
          ),
        ),
      );
    }

    // Sortiere die History absteigend nach Startzeit
    final sortedHistory = List<HistoryEntry>.from(historyList)
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    // Gruppiere nach Datum
    final groupedHistory = _groupByDate(sortedHistory);

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).history),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.hgap2,
          horizontal: context.wgap5,
        ),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: groupedHistory.length,
            itemBuilder: (context, index) {
              final date = groupedHistory.keys.elementAt(index);
              final entries = groupedHistory[date]!;

              return CustomContainer(
                childWidget: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.wgap5,
                    vertical: context.hgap2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Datum Label
                      Padding(
                        padding: EdgeInsets.only(top: context.hgap2),
                        child: Container(
                          height: context.screenHeight * 0.05,
                          decoration: BoxDecoration(
                            color: context.appStyle.buttonBackgroundLight
                                .withValues(alpha: 0.75),
                          ),
                          child: Center(
                            child: Text(
                              _formatDateLabel(date),
                              style: context.textStyles.dark.labelMedium,
                            ),
                          ),
                        ),
                      ),
                      // Tasks vom Tag
                      ...entries.map((entry) {
                        final startTime = _formatTime(entry.startedAt);
                        final endTime = entry.finished && entry.endedAt != null
                            ? _formatTime(entry.endedAt!)
                            : S.of(context).history_not_finished;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: context.appStyle.columnBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Icon(
                              entry.finished
                                  ? Icons.check
                                  : Icons.cancel_outlined,
                              color: entry.finished
                                  ? context.appStyle.buttonBackgroundprimary
                                  : context.appStyle.writingLight,
                            ),
                            title: Text(
                              entry.taskName,
                              style: context.textStyles.light.labelMedium,
                            ),
                            subtitle: Text(
                              "${S.of(context).start}: $startTime\n${S.of(context).history_end}: $endTime",
                              style: context.textStyles.light.labelSmall,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Gruppiert History-Einträge nach Datum
  Map<DateTime, List<HistoryEntry>> _groupByDate(List<HistoryEntry> history) {
    final Map<DateTime, List<HistoryEntry>> grouped = {};
    for (final entry in history) {
      final dateKey = DateTime(
        entry.startedAt.year,
        entry.startedAt.month,
        entry.startedAt.day,
      );
      grouped.putIfAbsent(dateKey, () => []).add(entry);
    }
    return grouped;
  }

  /// Formatiert Datum (Heute, Gestern oder dd.MM.yyyy)
  String _formatDateLabel(DateTime date) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return S.of(context).history_today;
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return S.of(context).history_yesterday;
    } else {
      return "${_twoDigits(date.day)}.${_twoDigits(date.month)}.${date.year}";
    }
  }

  /// Formatiert Zeit in HH:mm
  String _formatTime(DateTime date) {
    final hours = _twoDigits(date.hour);
    final minutes = _twoDigits(date.minute);
    return "$hours:$minutes";
  }

  /// Hilfsfunktion für zweistellige Zahlen
  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
