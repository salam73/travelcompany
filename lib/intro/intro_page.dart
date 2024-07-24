import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home_page.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});

  _launchUrl(String? phoneNumber) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (!await launchUrl(smsLaunchUri)) {
      throw Exception('Could not launch $smsLaunchUri');
    }
  }

  InkWell inputPhone(String phone){
    return  InkWell(
      onTap: () => _launchUrl(phone),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(phone, style: TextStyle(fontSize: 18),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double windowsHeight=MediaQuery.of(context).size.height;
    double windowsWidth=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            //appBar: AppBar(),
            body: Container(
              width: windowsWidth,
              height: windowsHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                      'assets/mmg.png'), // Replace with your image path
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                     Text('السلام عليكم ورحمة الله وبركاته', style:
                    TextStyle(fontSize: windowsHeight/35),),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RichText(
                      //  textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        text:  TextSpan(
                          text: 'وزارة النفط\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:  windowsHeight/35,
                            fontWeight: FontWeight.bold,
                          ),
                          children:  <TextSpan>[
                            TextSpan(
                                text: 'شركة توزيع المنتجات النفطية'
                                    '\n'
                                    'هياة توزيع الفرات الاوسط'
                                    '\n'
                                    'فرع كربلاء المقدسة'
                                    '\n\n'
                                    'خدمة زوار الامام الحسين "عليه السلام " شرف لنا '
                                    '\n'
                                    'عظم الله اجورنا واجوركم'
                                    '\n'
                                    'لطلب المنتجات النفطية يرجى الضغط على ادخال البيانات'
                                    '\n'
                                    'للإستفسار يرجى التواصل مع الهواتف  التالية'
                                    ,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:  windowsHeight/35,
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),

                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Text('ادخال البيانات')),
                    SizedBox(height: 20,),

                    Column(
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            inputPhone('07807788447'),
                            inputPhone('07733332118'),


                          ],
                        ), Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            inputPhone('07708013889'),
                            inputPhone('07707111110'),



                          ],
                        ),Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            inputPhone('07722933625'),
                            inputPhone('07717645192'),

                          ],
                        ),
                        inputPhone('07735156426'),

                      ],
                    ),

                    SizedBox(height: 20,),

                  ],
                ),
              ),
            )),
      ),
    );
  }
}
