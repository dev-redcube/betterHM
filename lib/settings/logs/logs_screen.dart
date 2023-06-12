import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final Set<LogLevel> selectedLevels = LogLevel.values.toSet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.advanced.logs.title),
      ),
      body: Column(
        children: [
          logsFilter(),
          Expanded(
            child: StreamBuilder(
              stream: Isar.getInstance()
                  ?.logEntries
                  .filter()
                  .allOf(
                      selectedLevels, (q, element) => q.levelEqualTo(element))
                  .sortByTimestamp()
                  .limit(500)
                  .watch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(),
                  );
                }
                final List<LogEntry> entries = snapshot.data!;
                return ListView(
                  children: entries
                      .map((e) => Text(
                            "${e.level.name.toUpperCase()}: ${e.tag} ${e.message}",
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget logsFilter() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        child: Wrap(
          children: LogLevel.values
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(e.name),
                      onSelected: (value) {
                        setState(() {
                          value
                              ? selectedLevels.add(e)
                              : selectedLevels.remove(e);
                        });
                      },
                      selected: selectedLevels.contains(e),
                    ),
                  ))
              .toList(),
        ),
      );
}
