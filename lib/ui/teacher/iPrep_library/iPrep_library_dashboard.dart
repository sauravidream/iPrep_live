import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/dashboard_test_widget.dart';
import 'package:idream/custom_widgets/subject_home_page_widget.dart';
import 'package:idream/model/subject_model.dart';
import 'package:idream/model/test_model.dart';
import 'package:idream/provider/bell_animation_provider.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/dashboard/extra_books/extra_book_widget.dart';
import 'package:idream/ui/dashboard/stem_videos/stem_projects_widget.dart';
import 'package:idream/ui/dashboard/test_prep_web_page.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IprepLibraryDashboard extends StatefulWidget {
  const IprepLibraryDashboard({Key? key}) : super(key: key);

  @override
  _IprepLibraryDashboardState createState() => _IprepLibraryDashboardState();
}

class _IprepLibraryDashboardState extends State<IprepLibraryDashboard>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  Future? _subjectList;
  Future? _testPrepData;

  @override
  void initState() {
    super.initState();
    Provider.of<BellAnimationProvider>(context, listen: false)
        .initialiseHearAnimation(this);

    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    ));
    animation.forward();
    _subjectList = dashboardRepository.fetchSubjectList();
    _testPrepData = testRepository.fetchTestPrepPopularExamsList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (BuildContext context, networkProvider, Widget? child) {
        return networkProvider.isAvailable == true
            ? _mainDashboardPageWidget()
            : const NetworkError();
      },
    );
  }

  Widget _mainDashboardPageWidget() {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        left: 16,
        right: 16,
      ),
      child: ListView(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: const Color(0xFF212121),
                fontSize: 17,
              ),
              children: [
                TextSpan(
                  text: 'Your ',
                  style: TextStyle(
                    fontWeight: FontWeight.values[4],
                  ),
                ),
                TextSpan(
                  text: 'Subjects',
                  style: TextStyle(
                    fontWeight: FontWeight.values[5],
                  ),
                ),
              ],
            ),
          ),
          getSubjectListWidgets(dashboardScreenState),
          ExtraBooksContainer(),

          /* FutureBuilder(
            future: _subjectList,
            builder: (context, subjects) {
              if (subjects.hasData) {
                return FadeTransition(
                  opacity: _fadeInFadeOut,
                  child: StemProjectsWidget(
                    subjectList: subjects.data as List<SubjectModel>?,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),*/

          StemProjectsWidget(),
          FutureBuilder(
            future: _testPrepData,
            builder: (context, testData) {
              if (testData.hasData) {
                return InkWell(
                  onTap: () async {
                    WebViewCookie? sessionCookie;
                    String? userName = await getStringValuesSF("fullName");
                    String? userEmail = await getStringValuesSF("email");
                    String? userMobileNo =
                        await getStringValuesSF("mobileNumber");
                    String? userProfileImage =
                        await getStringValuesSF("profilePhoto");
                    userMobileNo = userMobileNo!.replaceAll("+91-", "");
                    if (userMobileNo == '') {
                      userMobileNo = null;
                    }

                    CookieManager? cookieManager = CookieManager();
                    sessionCookie = WebViewCookie(
                      name: 'ip_user',
                      value:
                          "${userName ?? "John Doe"}|${userEmail ?? ""}|${userMobileNo ?? '1234567890'}|${userProfileImage ?? 'https://secure.gravatar.com/avatar/?s=96&d=mm'}",
                      domain: '.iprep.in',
                    );
                    cookieManager.setCookie(sessionCookie);
                    if (!mounted) return;
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => TestPrepWebPage(
                          cookieManager: cookieManager,
                          link: "https://exams.iprep.in/",
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: const Color(0xFF212121),
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: 'Your ',
                              style: TextStyle(
                                fontWeight: FontWeight.values[4],
                              ),
                            ),
                            TextSpan(
                              text: 'Test Preparations',
                              style: TextStyle(
                                fontWeight: FontWeight.values[5],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "assets/images/forward_icon.png",
                        height: 25,
                        width: 25,
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          FutureBuilder(
            future: _testPrepData,
            builder: (context, testData) {
              if (testData.hasData) {
                return getTestWidgets(
                    testPrepData: testData.data as List<TestPrepModel>);
              } else {
                return Container();
              }
            },
          ),
          getShareAppWidget(),
        ],
      ),
    );
  }

  getSubjectListWidgets(DashboardScreenState? dashboardScreenState) {
    return Container(
      padding: const EdgeInsets.only(
        top: 18,
      ),
      child: FutureBuilder(
        initialData: null,
        future: _subjectList,
        builder: (context, subjects) {
          if (subjects.connectionState == ConnectionState.none &&
              subjects.hasData == null) {
            return Container();
          } else if (subjects.connectionState == ConnectionState.done &&
              subjects.data == null) {
            return Container(
              alignment: Alignment.center,
              child: const Text("No data available. Please try later."),
            );
          } else if (subjects.hasData) {
            List<SubjectModel>? _subjectList =
                subjects.data as List<SubjectModel>?;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // number of items per row
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 7
                        : 4,
                // vertical spacing between the items
                mainAxisSpacing: 0,
                // horizontal spacing between the items
                crossAxisSpacing: 0,
                mainAxisExtent: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).orientation == Orientation.landscape
                        ? 7
                        : 4),
              ),
              itemCount: _subjectList!.length,
              itemBuilder: (BuildContext ctx, index) {
                return SubjectWidget(
                  dashboardScreenState: dashboardScreenState,
                  subjectImagePath:
                      (_subjectList[index].subjectIconPath != null &&
                              _subjectList[index].subjectIconPath!.isNotEmpty)
                          ? _subjectList[index].subjectIconPath
                          : Constants.defaultSubjectImagePath,
                  subjectName: _subjectList[index].subjectName,
                  subjectColor: (_subjectList[index].subjectColor != null &&
                          _subjectList[index].subjectColor!.isNotEmpty)
                      ? (int.parse(
                              _subjectList[index].subjectColor!.substring(1, 7),
                              radix: 16) +
                          0xFF000000)
                      : Constants.defaultSubjectHexColor,
                  subjectID: _subjectList[index].subjectID,
                  subjectShortName: _subjectList[index].shortName ?? "",
                );
              },
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: const Text("Loading..."),
            );
          }
        },
      ),
    );
  }

  getTestWidgets({required List<TestPrepModel> testPrepData}) {
    return Container(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 18,
      ),
      // child: GridView.count(
      //   shrinkWrap: true,
      //   crossAxisCount: 2,
      //   mainAxisSpacing: 16,
      //   crossAxisSpacing: 16,
      //   physics: const NeverScrollableScrollPhysics(),
      //   childAspectRatio: 164 / 66,
      //   children: List.generate(
      //     testPrepData.length,
      //     (index) {
      //       return TestWidget(
      //         testName: testPrepData[index].name,
      //         testId: testPrepData[index].id,
      //         testImagePath: testPrepData[index].icon,
      //         testWebLink: testPrepData[index].href,
      //       );
      //     },
      //   ),
      // ),
    );
  }

  getShareAppWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 0,
      ),
      child: Stack(
        children: [
          Image.asset(
            "assets/images/share_image.png",
            height: 212,
            width: double.maxFinite,
            fit: BoxFit.scaleDown,
          ),
          InkWell(
            onTap: () async {
              var _deepLinkUrl =
                  await shareEarnRepository.prepareDeepLinkForAppDownload();
              await shareEarnRepository.shareContent(
                  context: context, content: _deepLinkUrl.toString());
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invite your friends to download iPrep",
                    style: TextStyle(
                        color: const Color(0xFF212121),
                        fontSize: 16,
                        fontWeight: FontWeight.values[5]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Get Rs. 100 as iPrep Cash & share the joy of\nLearning Unlimited",
                    style: TextStyle(
                        color: const Color(0xFF9E9E9E),
                        fontSize: 12,
                        fontWeight: FontWeight.values[4]),
                  ),
                  getShareButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getShareButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19.0),
          ),
          minimumSize: const Size(90, 38),
          side: const BorderSide(
            color: const Color(0xFF0070FF),
          ),
        ),
        child: Text(
          "Share",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.values[4],
            color: const Color(0xFF212121),
          ),
        ),
        onPressed: () async {
          var _deepLinkUrl =
              await shareEarnRepository.prepareDeepLinkForAppDownload();
          await shareEarnRepository.shareContent(
              context: context, content: _deepLinkUrl.toString());
        },
      ),
    );
  }
}
