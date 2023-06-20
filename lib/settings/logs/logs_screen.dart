import 'dart:convert';
import 'dart:io';

import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key, this.levels});

  final Set<LogLevel>? levels;

  static const routeName = "logs";

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  late final Set<LogLevel> selectedLevels;

  @override
  initState() {
    super.initState();
    selectedLevels = widget.levels ?? LogLevel.values.toSet();
  }

  shareFile() async {
    final dir = await getTemporaryDirectory();
    final timestamp = now().millisecondsSinceEpoch ~/ 1000;
    final file = File("${dir.path}/logs-$timestamp.json");
    await file.writeAsString(jsonEncode(await LoggerStatic().dump()));
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: t.settings.advanced.logs.shareFile,
    );
    await file.delete();
  }

  shareJson() async {
    final json = jsonEncode(await LoggerStatic().dump());
    await Share.share(json, subject: t.settings.advanced.logs.shareJson);
  }

  deleteLogs(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settings.advanced.logs.clear.title),
        content: Text(t.settings.advanced.logs.clear.description),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) context.pop();
            },
            child: Text(t.settings.advanced.logs.clear.cancel),
          ),
          TextButton(
            onPressed: () async {
              await LoggerStatic().clearLogs();
              if (mounted) context.pop();
            },
            child: Text(
              t.settings.advanced.logs.clear.confirm,
              style: TextStyle(color: context.theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.advanced.logs.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () async => await deleteLogs(context),
            tooltip: t.settings.advanced.logs.clear.title,
          ),
          IconButton(
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () async => await shareFile(),
            tooltip: t.settings.advanced.logs.shareFile,
          ),
          IconButton(
            icon: const Icon(Icons.upload_rounded),
            onPressed: () async => await shareJson(),
            tooltip: t.settings.advanced.logs.shareJson,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logsFilter(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: LoggerStatic().stream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(),
                    );
                  }
                  return SelectionArea(
                    child: ListView(
                      children: snapshot.data!
                          .where((element) =>
                              selectedLevels.contains(element.level))
                          .map((e) => Text(
                                "${e.level.name.toUpperCase()}: ${e.tag} ${e.message}",
                              ))
                          .toList(),
                    ),
                  );
                },
              ),
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
