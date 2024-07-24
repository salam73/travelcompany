import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart' as ll;

class FirestoreExample extends StatelessWidget {
  FirestoreExample({super.key});

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('/users');

  Future<void> openGoogleMaps(double latitude, double longitude) async {
    var myuri = Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: '/maps/@$latitude,$longitude,14z?entry=ttu');
    if (!await launchUrl(myuri, mode: LaunchMode.inAppWebView)) {
      throw 'Could not open Google Maps';
    }
  }



  Future<void> _openMap(double lat, double lng, String name) async {

    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: Coords(lat, lng),
      title: name,
    );

  }

  Future<void> _launchInBrowser(Uri url) async {
    // final url2 = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (!await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معلومات التسجيل'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              _collection.orderBy('created_at', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No data available.');
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final item = snapshot.data!.docs[index];




                Timestamp firebaseTimestamp = (item['created_at']);
                print(firebaseTimestamp.toString());

                // Convert Firebase Timestamp to DateTime
                DateTime dateTime = firebaseTimestamp.toDate();
                print(dateTime);

                DateTime utcDateTime = dateTime.toUtc();

                tz.Location baghdad = tz.getLocation('Asia/Baghdad');

                // Convert UTC time to Baghdad time
                tz.TZDateTime baghdadTime = tz.TZDateTime.from(utcDateTime, baghdad);

                // Format the time for display
                String formattedBaghdadTime = ll.DateFormat('HH:mm:ss').format(baghdadTime);
                String formattedBaghdadDate = ll.DateFormat('yyyy-MM-dd').format(baghdadTime);



                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SelectableText(
                       'الوقت :$formattedBaghdadTime \n'
                       'التاريخ :$formattedBaghdadDate \n'
                        'الاسم :${item['name']} \n'
                        'موبايل :${item['phone']} \n'
                        'اقرب نقطه :${item['mypoint']} \n'
                        'موقع الموكب :${item['position'].replaceAll('\n', ' ')} \n'
                        'موقع جوجل:${item['lat'] ?? ''},${item['long'] ?? ''}\n'
                        'زيت الغاز :${item['زيت الغاز']}\n'
                        'اسطوانة الغاز :${item['اسطوانة الغاز']}\n'
                        'نفط أبيض :${item['نفط أبيض']}',
                        style: const TextStyle(fontSize: 16),
                      ),

                      /*    SelectableText('موبايل :${item['phone']}', style: const TextStyle
                        (fontSize: 16),),
                        SelectableText('اقرب نقطه :${item['mypoint']}', style: const TextStyle
                          (fontSize: 16),),
                        SelectableText('موقع الموكب :${item['position']}', style: const TextStyle
                          (fontSize: 16),),
                           SelectableText('زيت الغاز :${item['زيت الغاز']}', style: const TextStyle
                        (fontSize: 16),),
                      SelectableText('اسطوانة الغاز :${item['اسطوانة الغاز']}', style: const TextStyle
                        (fontSize: 16),),
                      SelectableText('نفط أبيض :${item['نفط أبيض']}', style: const TextStyle
                        (fontSize: 16),),

                        SelectableText('${item['lat']??''} , ${item['long']??''}',
                        style:
                        const
                        TextStyle
                          (fontSize: 16),),*/
                      ElevatedButton(
                          onPressed: () {
                            // openGoogleMaps(item['lat'],item['long']);

                            _openMap(item['lat'], item['long'],item['name']??'hussain');

                            //    _launchInBrowser(toLaunch);
                          },
                          child: const Text('google '
                              'map')),
                      const Divider(
                        thickness: 2,
                        indent: 0,
                        endIndent: 130,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

        /* floatingActionButton: FloatingActionButton(
          onPressed:_setData,
          child: const Text('+'),

        ),*/
      ),
    );
  }
}
