import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 59;
  Timer? _timer;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes : $secs';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: Colors.grey),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('OTP Input Field'),
      ),
      body: Center(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'We just sent an SMS',
              style: TextStyle(
                color: Color.fromRGBO(30, 60, 87, 1),
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Enter the security code we sent to \n+62 8123456789',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(30, 60, 87, 1),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Pinput(
              length: 4,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: Color.fromRGBO(110, 17, 231, 1)),
                ),
              ),
              onCompleted: (pin) {
                log('PIN ENTERED : $pin');
              },
            ),
            SizedBox(height: 8),
            SizedBox(
              width: screenWidth * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(110, 17, 231, 1),
                ),
                onPressed: () {},
                child: Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
            Text(
              'Did not receive the code?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(30, 60, 87, 1),
                fontSize: 16,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _isResendEnabled ? () {} : null,
                  child: Text(
                    'Resend',
                    style: TextStyle(
                      color: _isResendEnabled
                          ? Color.fromRGBO(110, 17, 231, 1)
                          : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(_formatTime(_counter)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
