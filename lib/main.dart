import 'dart:ui';

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
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut), // 0 to 0.75s
      ),
    );

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -250,
          left: -180,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
import 'dart:ui';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut), // 0 to 0.75s
      ),
    );

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -250,
          left: -180,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
import 'dart:ui';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<Offset> _textPositionAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced from 2s to 1.5s
      vsync: this,
    );

    // Logo position animation from bottom to center
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 9.0),
      end: const Offset(0.0, -0.6),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut), // 0 to 0.75s
      ),
    );

    // Logo size animation with three stages using TweenSequence
    _logoSizeAnimation = TweenSequence<double>([
      // Stage 1: Swipe in at 200 (0% to 50%)
      TweenSequenceItem(
        tween: ConstantTween<double>(200.0),
        weight: 50.0, // 0.75s (50% of 1.5s)
      ),
      // Stage 2: Grow from 200 to 220 (50% to 75%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 210.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
      // Stage 3: Shrink from 220 to 180 (75% to 100%)
      TweenSequenceItem(
        tween: Tween<double>(begin: 210.0, end: 180.0),
        weight: 25.0, // 0.375s (25% of 1.5s)
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text position animation (unchanged timing, just faster)
    _textPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 0.75, curve: Curves.easeIn), // 0.75s to 1.125s
      ),
    );

    // Text reveal animation (faster)
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            const Interval(0.5, 1.0, curve: Curves.easeInOut), // 0.75s to 1.5s
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -250,
          left: -180,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _logoPositionAnimation, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 44),
                      // Animated Logo
                      Container(
                        height: _logoSizeAnimation.value,
                        width: _logoSizeAnimation.value,
                        child: Image.asset(
                          'assets/images/AuraVPN_Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // Animated Text Reveal
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _textRevealAnimation.value,
                          child: Image.asset(
                            'assets/images/Aura_vpn_text copy.png',
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -250,
          left: -180,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -250,
          left: -180,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -250,
          left: -180,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                radius: 3.5,
                radius: 3.5,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],


                
class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                radius: 3.5,
                radius: 3.5,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],



class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -250,
          left: -180,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
class GradientBackground extends StatelessWidget {
  final Widget? child;
  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12064F),
                Color(0xFF12064F),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -250,
          left: -180,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.5,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
}
}
}
}
}
}
}
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
}
}
}
}
}
}
}
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -280,
          right: -200,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2,
                colors: [
                  Color(0xff3F42FF),
                  Colors.transparent,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
}
}
}
}
}
}
}
}
}
}
}å