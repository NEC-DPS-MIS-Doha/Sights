import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:avatars/avatars.dart';
import 'dart:convert';
import 'package:location/location.dart';
import './Post/Article.dart';
import './Post/RateReviewPage.dart';

Map location = {'formatted': 'Loading Location Data...'};

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.user})
      : super(key: key);

  final String title;
  final User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    getLocation().then((value) {
      if (value['error'] == 'denied') {
        location = {'formatted': 'Please grant permission'};
      }
      // TODO: Add error handling
      setState(() {
        location = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String? username =
        (widget.user?.displayName == '' || widget.user?.displayName == null)
            ? 'User'
            : widget.user?.displayName;
    debugPrint(widget.user.toString());

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Transform.scale(
              scale: .70,
              child: FittedBox(
                fit: BoxFit.cover,
                child: InkWell(
                    borderRadius: BorderRadius.circular(42),
                    onTap: () {},
                    child: Avatar(
                      name: username,
                    )),
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Good Evening, $username!",
                    style: const TextStyle(
                        fontSize: 22.5, fontWeight: FontWeight.w700)),
                const SizedBox(
                  height: 10,
                ),
                Opacity(
                    opacity: 0.75,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Icon(Icons.location_on_rounded),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Text("${location['formatted']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100,
                                  overflow: TextOverflow.ellipsis,
                                )))
                      ],
                    )),
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showPostOptions(context, widget);
          },
          tooltip: 'Post',
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.account_circle_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_rounded),
                onPressed: () {},
              ),
              const SizedBox(
                width: 75,
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}

Future<Map> getLocation() async {
  var location = Location();

  if (!await location.serviceEnabled()) {
    if (!await location.requestService()) {
      return {};
    }
  }

  var permission = await location.hasPermission();
  if (permission == PermissionStatus.denied) {
    permission = await location.requestPermission();
    if (permission != PermissionStatus.granted) {
      return {};
    }
  }
  debugPrint("DATATATATA");
  LocationData loc = await location.getLocation();

  debugPrint("${loc.latitude} ${loc.longitude}");
  // var response = '''{
  //   "documentation" : "https://opencagedata.com/api",
  // "licenses" : [
  // {
  // "name" : "see attribution guide",
  // "url" : "https://opencagedata.com/credits"
  // }
  // ],
  // "rate" : {
  // "limit" : 2500,
  // "remaining" : 2498,
  // "reset" : 1662422400
  // },
  // "results" : [
  // {
  // "annotations" : {
  // "DMS" : {
  // "lat" : "37\u00b0 25' 20.51616'' N",
  // "lng" : "122\u00b0 5' 2.92560'' W"
  // },
  // "FIPS" : {
  // "county" : "06085",
  // "state" : "06"
  // },
  // "MGRS" : "10SEG8103742122",
  // "Maidenhead" : "CM87wk91vi",
  // "Mercator" : {
  // "x" : -13590344.968,
  // "y" : 4472175.573
  // },
  // "OSM" : {
  // "edit_url" : "https://www.openstreetmap.org/edit?way=23733663#map=16/37.42237/-122.08415",
  // "note_url" : "https://www.openstreetmap.org/note/new#map=16/37.42237/-122.08415&layers=N",
  // "url" : "https://www.openstreetmap.org/?mlat=37.42237&mlon=-122.08415#map=16/37.42237/-122.08415"
  // },
  // "UN_M49" : {
  // "regions" : {
  // "AMERICAS" : "019",
  // "NORTHERN_AMERICA" : "021",
  // "US" : "840",
  // "WORLD" : "001"
  // },
  // "statistical_groupings" : [
  // "MEDC"
  // ]
  // },
  // "callingcode" : 1,
  // "currency" : {
  // "alternate_symbols" : [
  // "US"
  // ],
  // "decimal_mark" : ".",
  // "disambiguate_symbol" : "US",
  // "html_entity" : "",
  // "iso_code" : "USD",
  // "iso_numeric" : "840",
  // "name" : "United States Dollar",
  // "smallest_denomination" : 1,
  // "subunit" : "Cent",
  // "subunit_to_unit" : 100,
  // "symbol" : "qr",
  // "symbol_first" : 1,
  // "thousands_separator" : ","
  // },
  // "flag" : "\ud83c\uddfa\ud83c\uddf8",
  // "geohash" : "9q9hvut114wcb3egkzz4",
  // "qibla" : 19.25,
  // "roadinfo" : {
  // "drive_on" : "right",
  // "road" : "Amphitheatre Parkway",
  // "speed_in" : "mph"
  // },
  // "sun" : {
  // "rise" : {
  // "apparent" : 1662385440,
  // "astronomical" : 1662379980,
  // "civil" : 1662383820,
  // "nautical" : 1662381960
  // },
  // "set" : {
  // "apparent" : 1662344940,
  // "astronomical" : 1662350340,
  // "civil" : 1662346560,
  // "nautical" : 1662348420
  // }
  // },
  // "timezone" : {
  // "name" : "America/Los_Angeles",
  // "now_in_dst" : 1,
  // "offset_sec" : -25200,
  // "offset_string" : "-0700",
  // "short_name" : "PDT"
  // },
  // "what3words" : {
  // "words" : "pipe.third.fleet"
  // }
  // },
  // "bounds" : {
  // "northeast" : {
  // "lat" : 37.422683,
  // "lng" : -122.0827584
  // },
  // "southwest" : {
  // "lat" : 37.4220644,
  // "lng" : -122.0849617
  // }
  // },
  // "components" : {
  // "ISO_3166-1_alpha-2" : "US",
  // "ISO_3166-1_alpha-3" : "USA",
  // "ISO_3166-2" : [
  // "US-CA"
  // ],
  // "_category" : "building",
  // "_type" : "building",
  // "building" : "Google Building 40",
  // "city" : "Mountain View",
  // "continent" : "North America",
  // "country" : "United States",
  // "country_code" : "us",
  // "county" : "Santa Clara County",
  // "postcode" : "94043",
  // "road" : "Amphitheatre Parkway",
  // "state" : "California",
  // "state_code" : "CA"
  // },
  // "confidence" : 10,
  // "formatted" : "Google Building 40, Amphitheatre Parkway, Mountain View, CA 94043, United States of America",
  // "geometry" : {
  // "lat" : 37.4223656,
  // "lng" : -122.084146
  // }
  // }
  // ],
  // "status" : {
  // "code" : 200,
  // "message" : "OK"
  // },
  // "stay_informed" : {
  // "blog" : "https://blog.opencagedata.com",
  // "twitter" : "https://twitter.com/OpenCage"
  // },
  // "thanks" : "For using an OpenCage API",
  // "timestamp" : {
  // "created_http" : "Mon, 05 Sep 2022 13:20:47 GMT",
  // "created_unix" : 1662384047
  // },
  // "total_results" : 1
  // }''';
  try {
    //TODO: Replace with acutal code here, just uncomment this
    var response = await Dio().get(
        'https://api.opencagedata.com/geocode/v1/json?q=${'${loc.latitude},'} ${loc.longitude}&pretty=1&key=05df1a30fe6f4243be7362c6468dada9');
    debugPrint('${'${loc.latitude},'} ${loc.longitude}');
    return jsonDecode(response.toString())['results'][0];
  } catch (e) {
    debugPrint(e.toString());
  }
  return {'error': 'denied'};
}

void showPostOptions(context, widget) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ArticlePostPage(
                            location: location, user: widget.user)),
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.article_rounded),
                  title: Text('Article'),
                  subtitle: Text('Create an article about this place'),
                )),
            InkWell(
                onTap: () {},
                child: const ListTile(
                  leading: Icon(Icons.camera_alt_rounded),
                  title: Text('Photo or Video'),
                  subtitle: Text('Post a photo or video of this place'),
                )),
            InkWell(
                onTap: () {
                  showRateReviewSheet(context, widget);
                },
                child: const ListTile(
                  leading: Icon(Icons.star_rate_rounded),
                  title: Text('Rate and Review'),
                  subtitle:
                      Text('Rate this place and if you want, post a review'),
                )),
          ],
        );
      });
}
