import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eval/flutter_eval.dart';
import 'package:flutter_eval/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define a global navigator key to manage navigation
  static final GlobalKey<NavigatorState> globalNavigatorKey =
      GlobalKey<NavigatorState>();

  void navigateToPage(String page) {
    globalNavigatorKey.currentState?.pushNamed(page);
  }

  @override
  Widget build(BuildContext context) {
    return HotSwapLoader(
      uri:
          'https://drive.google.com/uc?export=download&id=1fVk7BiAKSO8PsmgFGUyxb_4lF2kQ-Jo-',
      loading: const CircularProgressIndicator(),
      child: MaterialApp(
        navigatorKey: globalNavigatorKey, // Set global key for navigation
        routes: {
          '/page1': (context) => const Page1(),
          '/page2': (context) => const Page2(),
        },
        title: 'Flutter Eval Navigation',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HotSwap(
          id: '#myHomePage',
          args: [
            $BuildContext.wrap(context),
            // for navigation, we need to handle this from main function my passing closures
            $Closure((runtime, target, args) {
              navigateToPage(args[0]!.$value as String);
              return null;
            }),
          ],
          childBuilder: (context) => MyHomePage(
            navigateToPage: navigateToPage, // Pass function explicitly
          ),
        ),
      ),
    );
  }
}

// Updated MyHomePage to accept navigateToPage function
class MyHomePage extends StatelessWidget {
  final void Function(String) navigateToPage;
  const MyHomePage({super.key, required this.navigateToPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => navigateToPage("/page1"),
          child: const Text("Go to Page 1"),
        ),
      ),
    );
  }
}

// Placeholder Page1
class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page 1")),
      body: Center(
        child: Text("This is Page 1"),
      ),
    );
  }
}

// Placeholder Page2
class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page 2")),
      body: Center(
        child: Text("This is Page 2"),
      ),
    );
  }
}
