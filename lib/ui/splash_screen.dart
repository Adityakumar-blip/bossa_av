import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  @mustCallSuper
  @protected
  void dispose() {
    // TODO: implement dispose

    print('dispose called.............');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      }
      if (_pageController.positions.isNotEmpty) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 6.0,
      width: isActive ? 50.0 : 25.0,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFEDCC40)
            : _currentPage == 0
                ? Colors.black
                : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          color: _currentPage == 0
              ? const Color(0xffF1F2F4)
              : const Color(0xff575757),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: _currentPage == 0
                    ? const Color(0xffF1F2F4)
                    : const Color(0xff575757),
                height: _currentPage == 0
                    ? SizeConfig.screenHeight * 0.95
                    : _currentPage == 1
                        ? SizeConfig.screenHeight * 0.92
                        : SizeConfig.screenHeight * 0.85,
                child: PageView(
                  physics: const ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: <Widget>[
                    // screen 1
                    Center(
                      child: SizedBox(
                        height: SizeConfig.blockSizeVertical * 60,
                        width: SizeConfig.blockSizeHorizontal * 80,
                        child: Image.asset('assets/images/pmck_logo2.png'),
                      ),
                    ),

                    //screen 2
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 60,
                          width: SizeConfig.blockSizeHorizontal * 70,
                          child: const Image(
                            image: AssetImage(
                              'assets/images/pmck_logo2.png',
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 0.3),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical * 6,
                                  fontFamily: 'Muli-Bold'),
                            ),
                            Text(
                              'BOSSA REWARDS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical * 3,
                                  fontFamily: 'Muli-Bold'),
                              //    style: kTitleStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: Text(
                            'The loyalty app that gives back',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeVertical * 2,
                                fontFamily: 'Muli'),
                            //    style: kTitleStyle,
                          ),
                        ),
                      ],
                    ),

                    //screen 3
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 60,
                          width: SizeConfig.blockSizeHorizontal * 70,
                          child: const Image(
                            image: AssetImage(
                              'assets/images/pmck_logo2.png',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Earn Points',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeVertical * 5,
                                fontFamily: 'Muli-Bold'),
                            //    style: kTitleStyle,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text(
                              'Earn points by visiting the stores to get awesome loyalty gifts to redeem at any time',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.blockSizeVertical * 2,
                                  fontFamily: 'Muli'),
                              //    style: kTitleStyle,
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 2),
              _currentPage == 2
                  ? Container(
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.screenWidth * 0.5,
                      alignment: Alignment.bottomCenter,
                      color: const Color(0xff575757),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            width: 200,
                            text: "GET STARTED",
                            onTap: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.setBool("isViewSlider", true);
                              preferences.setBool("isLogin", false);
                              _pageController.dispose();
                              Get.offAllNamed(Routes.LOGIN);
                            },
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
