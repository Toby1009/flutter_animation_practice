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
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  late AnimationController _controller;

  double turns = 0.0;
  bool isClicked = false;
  Color customBlackColor = const Color.fromARGB(255, 53, 53, 53);
  Color customWhiteColor = const Color.fromARGB(255, 237,237, 237);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800)
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customWhiteColor,
      body: Center(
          child: AnimatedRotation(
            curve: Curves.easeOutExpo,
            turns: turns,
            duration: const Duration(seconds: 1),
            child: GestureDetector(
              onTap: (){
                if(isClicked){
                  setState(()=> turns -= 1/4);
                  _controller.reverse();
                }else{
                  setState(()=> turns += 1/4);
                  _controller.forward();
                }
                isClicked = !isClicked;
              },
              child: AnimatedContainer(
                curve: Curves.easeOutExpo,
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: customWhiteColor,
                  boxShadow:   [
                    BoxShadow(
                      blurRadius: 30,
                      offset: isClicked
                          ? Offset(20, -20)
                          : Offset(20, 20),
                      color: Colors.grey,
                    ),
                    BoxShadow(
                      blurRadius: 30,
                      offset:  isClicked
                          ? Offset(-20, 20)
                          : Offset(-20, -20),
                      color: Colors.white,
                    )
                  ]
                ),
                child:   SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        progress: _controller,
                      size: 100,
                      color: customBlackColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
