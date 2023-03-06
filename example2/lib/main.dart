import 'package:flutter/material.dart';
import 'dart:math' show pi;


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

        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}


enum CircleSide { left, right }

extension ToPath on CircleSide{
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(
        offset,
        radius: Radius.elliptical(size.width/2 , size.height /2),
        clockwise: clockwise
    );
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {

  final CircleSide side;

  const HalfCircleClipper({
    required this.side
  });

  @override
  Path getClip(Size size) =>side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

extension on VoidCallback{
  Future<void> delayed(Duration duration)=>
      Future.delayed(duration,this);
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {

  late AnimationController _counterClockwiseRotaionController;
  late Animation<double> _counterClockwiseRotaionAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _counterClockwiseRotaionController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1)
    );
    _counterClockwiseRotaionAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
          parent: _counterClockwiseRotaionController,
          curve: Curves.bounceOut
      )
    );

    _flipController = AnimationController(
        vsync: this,
        duration: const Duration(
          seconds: 1,
        )
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi
    ).animate(
      CurvedAnimation(
          parent: _flipController,
          curve: Curves.bounceOut)
    );

    _counterClockwiseRotaionController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
       _flipAnimation = Tween<double>(
         begin: _flipAnimation.value,
         end: _flipAnimation.value + pi,
       ).animate(
         CurvedAnimation(
             parent: _flipController,
             curve: Curves.bounceOut
         ),
       );
       _flipController
       ..reset()
       ..forward();
      }
    });

    _flipController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
       _counterClockwiseRotaionAnimation = Tween<double>(
         begin: _counterClockwiseRotaionAnimation.value,
         end: _counterClockwiseRotaionAnimation.value + - (pi/2)
       ).animate(
         CurvedAnimation(
             parent: _counterClockwiseRotaionController,
             curve: Curves.bounceOut
         )
       );
       _counterClockwiseRotaionController
         ..reset()
         ..forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _counterClockwiseRotaionController.dispose();
    _counterClockwiseRotaionController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _counterClockwiseRotaionController
      ..reset()
      ..forward.delayed(
          const Duration(seconds: 1)
      );

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _counterClockwiseRotaionController,
          builder: (context,child){
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockwiseRotaionAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _flipController,
                    builder: (context,child){
                      return Transform(
                        transform: Matrix4.identity()
                        ..rotateY(_flipAnimation.value),
                        alignment: Alignment.centerRight,
                        child: ClipPath(
                          clipper: const HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: const Color(0xff0057b7),
                          ),
                        ),
                      );
                    }
                  ),
                  AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context,child){
                      return Transform(
                        transform: Matrix4.identity()
                        ..rotateY(_flipAnimation.value),
                        alignment: Alignment.centerLeft,
                        child: ClipPath(
                          clipper: const HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: const Color(0xffffd700),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
