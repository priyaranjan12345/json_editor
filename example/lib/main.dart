import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:json_editor/json_editor.dart';
import 'notifier/theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ThemeNotifier();

    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            brightness: themeNotifier.theme,
            appBarTheme: const AppBarTheme(
              elevation: 1,
            ),
          ),
          home: MyHomePage(themeNotifier: themeNotifier),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.themeNotifier}) : super(key: key);

  final ThemeNotifier themeNotifier;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  JsonElement? _elementResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JsonEditor'),
        actions: [
          Row(
            children: [
              Switch(
                value: widget.themeNotifier.isDarkMode,
                onChanged: (b) {
                  widget.themeNotifier.toggleTheme(b);
                },
              ),
              const Text('Dark Mode'),
            ],
          ),
          const VerticalDivider(),
          ElevatedButton(
            onPressed: () {
              _elementResult?.toPrettyString();
            },
            child: const Text('format Json'),
          ),
          const VerticalDivider(),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ObjectDemoPage(
                    obj: _elementResult?.toObject(),
                  ),
                ),
              );
            },
            child: const Text('Object Demo'),
          ),
          const VerticalDivider(),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ElementDemoPage(
                    element: _elementResult,
                  ),
                ),
              );
            },
            child: const Text('Element Demo'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Theme(
          data: widget.themeNotifier.isDarkMode
              ? ThemeData.dark()
              : ThemeData.light(),
          child: JsonEditor.string(
            jsonString: '''
                {
                  // This is a comment
                  "name": "young chan",
                  "number": 100,
                  "boo": true,
                  "user": {"age": 20, "tall": 1.8},
                  "cities": ["beijing", "shanghai", "shenzhen"]
                }''',
            onValueChanged: (value) {
              _elementResult = value;
            },
          ),
        ),
      ),
    );
  }
}

// Object demo
class ObjectDemoPage extends StatelessWidget {
  const ObjectDemoPage({Key? key, this.obj}) : super(key: key);

  final Object? obj;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: JsonEditor.object(
          object: obj,
          onValueChanged: (value) {
            var json = value.toJson();
            var fromJson = JsonElement.fromJson(json);
            log(fromJson.toString());
          },
        ),
      ),
    );
  }
}

// Element demo
class ElementDemoPage extends StatelessWidget {
  const ElementDemoPage({Key? key, this.element}) : super(key: key);

  final JsonElement? element;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: JsonEditor.element(
          element: element,
          onValueChanged: (value) {
            var json = value.toJson();
            var fromJson = JsonElement.fromJson(json);
            log(fromJson.toString());
          },
        ),
      ),
    );
  }
}

/// vertival devider
class VerticalDivider extends StatelessWidget {
  const VerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: double.infinity,
        width: 2,
      ),
    );
  }
}
