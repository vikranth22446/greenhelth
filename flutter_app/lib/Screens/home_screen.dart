import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_helth/Models/Student.dart';
import 'package:green_helth/Services/FaceRecognitionApi.dart';
import 'package:green_helth/Widgets/StudentInfo.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> feed = FaceRecognitionApi.getPreviousScans();
  BadgeLevel currentBadgeLevel = BadgeLevel.GreenBadge;

  Map<BadgeLevel, String> badgePictures = {
    BadgeLevel.GreenBadge: "green_logo_mesh_texture.png",
    BadgeLevel.YellowBadge: "yellow_logo_mesh_texture.png",
    BadgeLevel.RedBadge: "red_logo_mesh_texture.png",
  };

  Map<BadgeLevel, String> badgeIdentifiers = {
    BadgeLevel.GreenBadge: "GREEN",
    BadgeLevel.YellowBadge: "YELLOW",
    BadgeLevel.RedBadge: "RED",
  };

  Map<BadgeLevel, String> badgeRemarks = {
    BadgeLevel.GreenBadge: "You're good to go on campus!",
    BadgeLevel.YellowBadge: "Fill out the clearance survey!",
    BadgeLevel.RedBadge: "Please social distance!",
  };

  Map<BadgeLevel, Color> badgeColors = {
    BadgeLevel.GreenBadge: Color.fromRGBO(11, 192, 127, 1),
    BadgeLevel.YellowBadge: Color.fromRGBO(245, 224, 34, 1),
    BadgeLevel.RedBadge: Color.fromRGBO(242, 48, 118, 1),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dashbord",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.settings,
                  size: 25,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/Images/oski_bear.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: badgeColors[currentBadgeLevel]!,
                        width: 6.0,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 6,),
                      Text(
                        "Your COVID compliance status is: ",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            badgeIdentifiers[currentBadgeLevel]!,
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: badgeColors[currentBadgeLevel]!
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                  'assets/Textures/' +
                                      badgePictures[currentBadgeLevel]!,
                                  fit: BoxFit.fitWidth),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        badgeRemarks[currentBadgeLevel]!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text(
              "Feed",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Today's Identifications",
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic
              ),
            ),
            SizedBox(height: 10,),
            Column(
              children: [
                for (var s in feed)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                        'assets/Textures/' +
                                            badgePictures[s.badgeLevel]!,
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "SID: " + s.studentID,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      "Email: " + s.email,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd MMM yyyy')
                                      .format(s.lastUpdated),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm:ss').format(s.lastUpdated),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
