import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //debugShowCheckedModeBanner: false,
        backgroundColor: Colors.yellow,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(
                    width: 280,
                    height: 300,
                    image: AssetImage("assets/images/Techdemy-logo-onboarding.png",)
                ),
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Build Your Career',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.black,
                      wordSpacing: 1,
                      letterSpacing: 0.5
                  ),
                ),
                Text(
                  'Let"s put your creativity on \n the development highway',
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 15.0, color: Colors.black,wordSpacing: 2,),
                ),
                SizedBox(
                  height: 30,
                ),
                /*ElevatedButton(
                  child: Text('LOGIN', style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side:BorderSide(color: Colors.black)
                      ),
                      minimumSize: Size(130, 45)
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context,'/homepage');
                  },
                ),*/
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text('LOGIN', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                              side:BorderSide(color: Colors.black)
                          ),
                          minimumSize: Size(130, 45)
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context,'/login');
                      },
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      child: Text('SIGNUP',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                              side:BorderSide(color: Colors.black)
                          ),
                          minimumSize: Size(130, 45)
                      ),
                      onPressed: (){
                          Navigator.pushNamed(context, '/signup');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
