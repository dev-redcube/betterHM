import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/logs/log_details_screen.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.advanced.logs.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () async {
              await logger.clearLogs();
              if (mounted) setState(() {});
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
      body: FutureBuilder(
          future: logger.entries(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<LogEntry> entries = snapshot.data!;
              return ListView.separated(
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
              );
            }
            return const SizedBox.shrink();
          }),
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
        LogLevel.INFO => colorStatusIndicator(Colors.blueAccent),
        LogLevel.SEVERE => colorStatusIndicator(Colors.redAccent),
        LogLevel.WARNING => colorStatusIndicator(Colors.orangeAccent),
        _ => colorStatusIndicator(Colors.grey)
      };

  Color getTileColor(LogLevel level, Brightness brightness) => switch (level) {
        LogLevel.INFO => Colors.transparent,
        LogLevel.SEVERE => brightness == Brightness.dark
            ? Colors.redAccent.withOpacity(0.25)
            : Colors.redAccent.withOpacity(0.075),
        LogLevel.WARNING => brightness == Brightness.dark
            ? Colors.orangeAccent.withOpacity(0.25)
            : Colors.orangeAccent.withOpacity(0.075),
        _ => Colors.transparent
      };

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.grey[600];
    return ListTile(
      tileColor: getTileColor(entry.level, context.theme.brightness),
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: buildLeadingIcon(entry.level),
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () {
        context.pushNamed(LogDetailsScreen.routeName,
            pathParameters: {"id": entry.id.toString()});
      },
      title: RichText(
        maxLines: 20,
        text: TextSpan(
          children: [
            TextSpan(
              text: "#$index ",
              style: TextStyle(
                color: titleColor,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: entry.message,
              style: TextStyle(
                color: titleColor,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
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
