import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  Animation animation;
  AnimationController _animationController;
  Animation<double> _width;
  Animation<Color> _colorAnimation;
  Animation<BorderRadius> _borderAnimation;
  Animation<TextStyle> _textStyleTween;
  Animation<double> _textContainerHeight;
  Animation<double> _paddingAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
        print("I am being called ${_width.value}");
      });

    _textContainerHeight = Tween<double>(
      begin: 0,
      end: 50,
    ).animate(_animationController);

    _textStyleTween = TextStyleTween(
        begin: TextStyle(
          fontSize: 0,
          color: Colors.black,
        ),
        end: TextStyle(
          color: Colors.white,
          fontSize: 20,
        )).animate(_animationController);

    _width = Tween<double>(
      begin: 100.0,
      end: 300.0,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc));

    _colorAnimation =
        ColorTween(begin: Colors.greenAccent, end: Colors.deepOrange).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInSine));

    _borderAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(100), end: BorderRadius.circular(10))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInSine));

    _paddingAnimation = Tween<double>().animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Transform.scale(
        scale: 50,
        child: Container(
            child: Container(
              height: _textContainerHeight.value,
              child: Center(
                  child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: "Hello World", hintText: "Hello Moto"),
                    style: _textStyleTween.value,
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: "Hello World", hintText: "Hello Moto"),
                    style: _textStyleTween.value,
                  )
                ],
              )),
            ),
            height: _width.value,
            width: _width.value,
            decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: _borderAnimation.value)),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
