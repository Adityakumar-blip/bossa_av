import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/ui/JohnClubCard.dart';
import 'package:Bossa/ui/PanarottisCard.dart';
import 'package:Bossa/ui/RocoLoveCard.dart';
import 'package:Bossa/ui/SpurFamilyCard.dart';
import 'package:Bossa/ui/contact_restaurant.dart';
import 'package:Bossa/ui/create_account.dart';
import 'package:Bossa/ui/home_view.dart';
import 'package:Bossa/ui/membershipCard.dart';
import 'package:Bossa/ui/news_screen.dart';
import 'package:Bossa/ui/notification_screen.dart';
import 'package:Bossa/ui/rate_restaurant.dart';
import 'package:Bossa/ui/redeem_history.dart';
import 'package:Bossa/ui/restaurants_details.dart';
import 'package:Bossa/ui/restaurants_page.dart';
import 'package:Bossa/ui/reward_dashboard.dart';
import 'package:Bossa/ui/root_controller.dart';
import 'package:Bossa/ui/share_app.dart';
import 'package:Bossa/ui/transaction_history.dart';
import 'package:Bossa/ui/vouchersList.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/bottom_bar.dart';

import '../network/api.dart';
import 'about_us.dart';
import 'forgot_password.dart';
import 'health_screen.dart';
import 'my_profile.dart';
import 'newsController.dart';
import 'stores_screens.dart';

class RootView extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
   
    RootControler controller = Get.put(RootControler());

    return WillPopScope(
        onWillPop: controller.onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: GetBuilder<RootControler>(
              global: true,
              builder: (ind) => IndexedStack(
                index: ind.selectedNav.value,
                children: [
                  Navigator(
                    key: Get.nestedKey(NavConst.homeNav),
                    initialRoute: Routes.HOME,
                    onGenerateRoute: (route) {
                      switch (route.name) {
                        case Routes.HOME:
                          return MaterialPageRoute(builder: ((context) {
                            return HomeView();
                          }));
                        case Routes.STOREPAGE:
                          return GetPageRoute(
                              routeName: Routes.STOREPAGE,
                              page: () => StoresScreen(data: route.arguments));
                        case Routes.HEALTH:
                          return GetPageRoute(
                              routeName: Routes.HEALTH,
                              page: () => HealthScreen());
                        case Routes.NEWS:
                          return GetPageRoute(
                            routeName: Routes.NEWS,
                            page: () => NewsPage(data: route.arguments),
                          );
                        case Routes.NEWSDETAIL:
                          return GetPageRoute(
                              routeName: Routes.NEWSDETAIL,
                              page: () => NewsDetails(
                                    data: route.arguments,
                                  ));
                        case Routes.RESTUARANTPAGE:
                          return GetPageRoute(
                            routeName: Routes.RESTUARANTPAGE,
                            page: () => RestaurantsPage(id: NavConst.homeNav),
                          );
                        case Routes.RESTAURANTDETAILS:
                          return GetPageRoute(
                              routeName: Routes.RESTAURANTDETAILS,
                              page: () =>
                                  RestaurantDetails(data: route.arguments));
                        case Routes.CONTACTRESTUARANT:
                          return GetPageRoute(
                              routeName: Routes.CONTACTRESTUARANT,
                              page: () => ContactRestaurant(
                                    data: route.arguments,
                                  ));
                        case Routes.RATESRESTAURANT:
                          return GetPageRoute(
                              routeName: Routes.RATESRESTAURANT,
                              page: () => RateRestaurant(
                                    data: route.arguments,
                                  ));
                      }
                      return null;
                    },
                  ),
                  Navigator(
                    key: Get.nestedKey(NavConst.notifyNav),
                    initialRoute: Routes.NOTIFICATION,
                    onGenerateRoute: (route) {
                      switch (route.name) {
                        case Routes.NOTIFICATION:
                          return MaterialPageRoute(builder: ((context) {
                            return const NotificationScreen();
                          }));
                        case Routes.DISPLAYNOTIFCATION:
                          return GetPageRoute(
                            routeName: Routes.DISPLAYNOTIFCATION,
                            page: () => DisplayNotification(
                              data: route.arguments,
                            ),
                          );
                        case Routes.SHAREDAPP:
                          return GetPageRoute(
                              routeName: Routes.SHAREDAPP,
                              page: () => const ShareApp());
                        case Routes.NEWS:
                          return GetPageRoute(
                              routeName: Routes.NEWS, page: () => NewsPage());
                        case Routes.ABOUTUS:
                          return GetPageRoute(
                              routeName: Routes.ABOUTUS,
                              page: () => const AboutUs());
                        case Routes.RESTAURANTDETAILS:
                          return GetPageRoute(
                              routeName: Routes.RESTAURANTDETAILS,
                              page: () => RestaurantDetails(
                                    data: route.arguments,
                                  ));
                        case Routes.RATESRESTAURANT:
                          return GetPageRoute(
                              routeName: Routes.RATESRESTAURANT,
                              page: () => RateRestaurant(
                                    data: route.arguments,
                                  ));
                        case Routes.CONTACTRESTUARANT:
                          return GetPageRoute(
                              routeName: Routes.CONTACTRESTUARANT,
                              page: () => ContactRestaurant(
                                    data: route.arguments,
                                  ));
                        case Routes.RESTUARANTPAGE:
                          return GetPageRoute(
                            routeName: Routes.RESTUARANTPAGE,
                            page: () => RestaurantsPage(id: NavConst.notifyNav),
                          );
                        case Routes.REWARDDASH:
                          return GetPageRoute(
                              routeName: Routes.REWARDDASH,
                              page: () => RewardsDashboard());
                        case Routes.PROFILE:
                          return GetPageRoute(
                              routeName: Routes.PROFILE,
                              page: () => MyProfile(
                                    data: route.arguments,
                                  ));
                        case Routes.NEWSDETAIL:
                          return GetPageRoute(
                              routeName: Routes.NEWSDETAIL,
                              page: () => NewsDetails(
                                    data: route.arguments,
                                  ));
                      }
                      return null;
                    },
                  ),
                  Navigator(
                    key: Get.nestedKey(NavConst.rewardnav),
                    initialRoute: Routes.REWARDDASH,
                    onGenerateRoute: (route) {
                      switch (route.name) {
                        case Routes.REWARDDASH:
                          return MaterialPageRoute(builder: ((context) {
                            return RewardsDashboard();
                          }));
                        case Routes.EARNPOINTS:
                          return GetPageRoute(
                              routeName: Routes.EARNPOINTS,
                              page: () => EarnPoints(data: route.arguments));
                        case Routes.VOUCHERLIST:
                          return GetPageRoute(
                              routeName: Routes.VOUCHERLIST,
                              page: () => VoucherList(data: route.arguments));
                        case Routes.REDEEMHISTORY:
                          return GetPageRoute(
                              routeName: Routes.REDEEMHISTORY,
                              page: () => RedeemHistory(data: route.arguments));
                        case Routes.TRANSACTIONHISTORY:
                          return GetPageRoute(
                              routeName: Routes.TRANSACTIONHISTORY,
                              page: () => TransactionHistory(data: route.arguments));
                        case Routes.PROFILE:
                          return GetPageRoute(
                            routeName: Routes.PROFILE,
                            page: () => MyProfile(data: route.arguments),
                          );
                        case Routes.FORGOTPASSWORD:
                          return GetPageRoute(
                              routeName: Routes.FORGOTPASSWORD,
                              page: () =>
                                  ForgotPassword(data: route.arguments));
                        case Routes.CREATEACCOUNT:
                          return GetPageRoute(
                              routeName: Routes.CREATEACCOUNT,
                              page: () => CreateAccount(data: route.arguments));
                        case Routes.MEMBERCARD:
                          return GetPageRoute(
                              routeName: Routes.MEMBERCARD,
                              page: () =>
                                  MembershipCard(data: route.arguments));
                        case Routes.SPURCARD:
                          return GetPageRoute(
                              routeName: Routes.SPURCARD,
                              page: () =>
                                  SpurFamilyCard(data: route.arguments));
                        case Routes.PANAROTTISCARD:
                          return GetPageRoute(
                              routeName: Routes.PANAROTTISCARD,
                              page: () =>
                                  PanarottisCard(data: route.arguments));
                        case Routes.JOHNCARD:
                          return GetPageRoute(
                              routeName: Routes.JOHNCARD,
                              page: () => JohnClubCard(data: route.arguments));
                        case Routes.ROCCOCARD:
                          return GetPageRoute(
                              routeName: Routes.ROCCOCARD,
                              page: () => RocoLoveCard(data: route.arguments));
                      }
                      return null;
                    },
                  ),
                  const AboutUs(),
                  Navigator(
                      key: Get.nestedKey(NavConst.profile),
                      initialRoute: Routes.PROFILE,
                      onGenerateRoute: (route) {
                        switch (route.name) {
                          case Routes.PROFILE:
                            return MaterialPageRoute(builder: ((context) {
                              return MyProfile(
                                data: route.arguments,
                              );
                            }));
                          case Routes.FORGOTPASSWORD:
                            return GetPageRoute(
                                routeName: Routes.FORGOTPASSWORD,
                                page: () =>
                                    ForgotPassword(data: route.arguments));
                          case Routes.CREATEACCOUNT:
                            return GetPageRoute(
                                routeName: Routes.CREATEACCOUNT,
                                page: () =>
                                    CreateAccount(data: route.arguments));
                          case Routes.MEMBERCARD:
                            return GetPageRoute(
                                routeName: Routes.MEMBERCARD,
                                page: () =>
                                    MembershipCard(data: route.arguments));
                          case Routes.SPURCARD:
                            return GetPageRoute(
                                routeName: Routes.SPURCARD,
                                page: () =>
                                    SpurFamilyCard(data: route.arguments));
                          case Routes.PANAROTTISCARD:
                            return GetPageRoute(
                                routeName: Routes.PANAROTTISCARD,
                                page: () =>
                                    PanarottisCard(data: route.arguments));
                          case Routes.JOHNCARD:
                            return GetPageRoute(
                                routeName: Routes.JOHNCARD,
                                page: () =>
                                    JohnClubCard(data: route.arguments));
                          case Routes.ROCCOCARD:
                            return GetPageRoute(
                                routeName: Routes.ROCCOCARD,
                                page: () =>
                                    RocoLoveCard(data: route.arguments));
                        }
                        return null;
                      })
                ],
              ),
            ),
            bottomNavigationBar: BottomBar(controller.selectedNav)));
  }
}
