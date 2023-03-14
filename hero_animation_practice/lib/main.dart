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
        primarySwatch: Colors.blue,
      ),
      home: const HeroAnimationRouteA(),
    );
  }
}





class HeroAnimationRouteA extends StatelessWidget {
  const HeroAnimationRouteA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: InkWell(
          onTap: (){
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context,animation,secondaryAnimation){
                      return FadeTransition(
                        opacity: animation,
                        child: Scaffold(
                          appBar: AppBar(
                            title: const Text("原圖"),
                          ),
                          body: const HeroAnimationRouteB(),
                        ),
                      );
                    }
                )
            );
          },
          child: Hero(
            tag: "hello",
            child: ClipOval(
              child: Image.asset(
                'assets/iamge_one.jpg',
                width: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroAnimationRouteB extends StatelessWidget {
  const HeroAnimationRouteB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: "hello",
        child: Image.asset("assets/iamge_one.jpg"),
      ),
    );
  }
}


