import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  static const routeName = "logs";

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final ScrollController _controller = ScrollController();

  bool showFab = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      double showoffset = 50.0;

      if (_controller.offset > showoffset) {
        setState(() {
          showFab = true;
        });
      } else {
        setState(() {
          showFab = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logger = HMLogger();
    final entries = logger.entries;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.advanced.logs.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              logger.clearLogs();
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              logger.shareLogs();
            },
          ),
        ],
      ),
      body: ListView.separated(
        controller: _controller,
        separatorBuilder: (context, index) => Divider(
          height: 0,
          color: context.theme.brightness == Brightness.dark
              ? Colors.white70
              : Colors.grey[600],
        ),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _LogEntry(entry, index);
        },
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward_rounded),
              onPressed: () {
                _controller.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
            )
          : null,
    );
  }
}

class _LogEntry extends StatelessWidget {
  const _LogEntry(this.entry, this.index);

  final LogEntry entry;
  final int index;

  Widget colorStatusIndicator(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget buildLeadingIcon(LogLevel level) => switch (level) {
        LogLevel.INFO => colorStatusIndicator(Colors.blue),
        LogLevel.SEVERE => colorStatusIndicator(Colors.redAccent),
        LogLevel.WARNING => colorStatusIndicator(Colors.orangeAccent),
        _ => colorStatusIndicator(Colors.grey)
      };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: buildLeadingIcon(entry.level),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "#$index ",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.grey[600],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: entry.message,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
          style: const TextStyle(fontSize: 14.0, fontFamily: "Inconsolata"),
        ),
      ),
      subtitle: Text(
        "[${entry.context1}] Logged on ${DateFormat("HH:mm:ss.SSS").format(entry.timestamp)}",
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
