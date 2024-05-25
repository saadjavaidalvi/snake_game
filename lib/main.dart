import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

enum Action {
  top,
  bottom,
  left,
  right,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // double top = 0;
  double bottom = 250;
  double left = 250;
  // double right = 0;
  bool hasPressed = false;
  Action lastAction = Action.right;

  Offset dotOffset = const Offset(250, 250);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Start Game"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  startMoving();
                },
                child: const Text('Start')),
          ],
        ),
      );
    });
  }

  randomDotCreate() {
    Random random = Random();
    double dotBottom = random.nextInt(500) * 1.0;
    double dotLeft = random.nextInt(500) * 1.0;
    dotOffset = Offset(dotLeft, dotBottom);
    setState(() {});
  }

  startMoving() async {
    randomDotCreate();
    Duration duration = const Duration(milliseconds: 20);
    while (bottom < 490 && left < 490 && bottom > 0 && left > 0) {
      if (lastAction.index == Action.left.index) {
        await Future.delayed(duration);
        left = left - 1;
      }
      if (lastAction.index == Action.right.index) {
        await Future.delayed(duration);
        left = left + 1;
      }
      if (lastAction.index == Action.top.index) {
        await Future.delayed(duration);
        bottom++;
      }
      if (lastAction.index == Action.bottom.index) {
        await Future.delayed(duration);
        bottom--;
      }
      if (isInRange(dotOffset.dy, bottom) && isInRange(dotOffset.dx, left)
          // bottom == dotOffset.dy && left == dotOffset.dx
          ) {
        randomDotCreate();
      }
      setState(() {});
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "GAME OVER!!!",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetValues();
              startMoving();
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }

  bool isInRange(double val1, double val2) {
    return ((val1 + 5) > val2 && val2 > val1 - 5);
  }

  resetValues() {
    bottom = 250;
    left = 250;
    lastAction = Action.right;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
          ),
          Container(
            height: 500,
            width: 500,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: dotOffset.dy,
                  left: dotOffset.dx,
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  bottom: bottom,
                  left: left,
                  duration: const Duration(
                    milliseconds: 1,
                  ),
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (lastAction == Action.top ||
                          lastAction == Action.bottom) {
                        lastAction = Action.left;
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.arrow_left_outlined),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (lastAction == Action.left ||
                              lastAction == Action.right) {
                            lastAction = Action.top;
                            setState(() {});
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (lastAction == Action.left ||
                              lastAction == Action.right) {
                            lastAction = Action.bottom;
                            setState(() {});
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (lastAction == Action.top ||
                          lastAction == Action.bottom) {
                        lastAction = Action.right;
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.arrow_right_outlined),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
