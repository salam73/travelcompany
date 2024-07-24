import 'package:flutter/material.dart';

class ThankPage extends StatefulWidget {
  const ThankPage({super.key});

  @override
  State<ThankPage> createState() => _ThankPageState();
}

class _ThankPageState extends State<ThankPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(
                  'assets/hus.jpeg'), // Replace with your image path
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          child: Container(
            child:  Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
              onTap:(){

              },
                    child:  Container(

                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(

                          'شكرا على التسجيل'
                              '\n'
                              'سوف نقوم بالاتصال بأقرب وقت',
                          style: TextStyle(
                              fontSize: 25, color: Colors.white, fontWeight:
                          FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
