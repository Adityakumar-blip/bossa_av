import 'package:get/get.dart';
import 'package:Bossa/onlines/Address/add_address_screen.dart';
import 'package:Bossa/onlines/Address/address_controller.dart';
import 'package:Bossa/onlines/Address/address_screen.dart';
import 'package:Bossa/onlines/Checkout/checkout_controller.dart';
import 'package:Bossa/onlines/Checkout/checkout_screen.dart';
import 'package:Bossa/onlines/Detail/detail_controller.dart';
import 'package:Bossa/onlines/Detail/detail_screen.dart';
import 'package:Bossa/onlines/My_Bag/my_bag_controller.dart';
import 'package:Bossa/onlines/My_Bag/my_bag_screen.dart';
import 'package:Bossa/onlines/My_Bag/payment_fail.dart';
import 'package:Bossa/onlines/My_Bag/payment_success.dart';
import 'package:Bossa/onlines/Order_Favourite/order_favourite_controller.dart';
import 'package:Bossa/onlines/Order_Favourite/order_favourite_screen.dart';
import 'package:Bossa/onlines/Order_History/order_history_controller.dart';
import 'package:Bossa/onlines/Order_History/order_history_screen.dart';
import 'package:Bossa/onlines/Order_Main_Page/order_main_controller.dart';
import 'package:Bossa/onlines/Order_Main_Page/order_main_screen.dart';
import 'package:Bossa/onlines/Payment/payment_controller.dart';
import 'package:Bossa/onlines/Payment/payment_screen.dart';
import 'package:Bossa/onlines/Profile/profile_controller.dart';
import 'package:Bossa/onlines/Profile/profile_screen.dart';
import 'package:Bossa/onlines/Restuarent_Menu_Page/reasurant_menu_controller.dart';
import 'package:Bossa/onlines/Restuarent_Menu_Page/reasurant_menu_page.dart';
import 'package:Bossa/ui/about_us.dart';
import 'package:Bossa/ui/create_account.dart';
import 'package:Bossa/ui/forgot_password.dart';
import 'package:Bossa/ui/health_screen.dart';
import 'package:Bossa/ui/home_view.dart';
import 'package:Bossa/ui/login.dart';
import 'package:Bossa/ui/my_profile.dart';
import 'package:Bossa/ui/new_password.dart';
import 'package:Bossa/ui/newsController.dart';
import 'package:Bossa/ui/notification_screen.dart';
import 'package:Bossa/ui/preferred_Store.dart';
import 'package:Bossa/ui/rate_restaurant.dart';
import 'package:Bossa/ui/redeem_history.dart';
import 'package:Bossa/ui/restaurants_details.dart';
import 'package:Bossa/ui/restaurants_page.dart';
import 'package:Bossa/ui/reward_dashboard.dart';
import 'package:Bossa/ui/root.dart';
import 'package:Bossa/ui/splash_screen.dart';
import 'package:Bossa/ui/stores_screens.dart';
import 'package:Bossa/ui/transaction_history.dart';
import 'package:Bossa/ui/vouchersList.dart';

import 'ui/enter_code.dart';
import 'ui/news_screen.dart';
import 'ui/redeem_code.dart';
import 'ui/redeem_restaurant.dart';

abstract class Routes {
  static const DASHBOARD = "/";
  static const HOME = "/home";
  static const LOGIN = "/login";
  static const SIGNUP = "/signup";
  static const FORGOTPASSWORD = "/forgotPassword";
  static const SPLASH = "/splashScreen";
  static const ABOUTUS = "/aboutUs";
  static const PROFILE = "/profile";
  static const NOTIFICATION = "/notificationScreen";
  static const REWARDDASH = "/rewardDash";
  static const HEALTH = "/healthScreen";
  static const NEWS = "/newsScreen";
  static const CREATEACCOUNT = "/createAccount";
  static const CONTACTRESTUARANT = "/contactRestuarant";
  static const RATESRESTAURANT = "/rateRestaurant";
  static const RESTAURANTDETAILS = "/restuarantDetails";
  static const RESTUARANTPAGE = "/restuarantPage";
  static const REDEEMCODE = "/redeemCode";
  static const REDEEMHISTORY = "/redeemHistory";
  static const REDEEMRESTUARANT = "/redeemRestuarant";
  static const ENTERCODE = "/enterCode";
  static const PREFERREDSTORE = "/preferredStore";
  static const VOUCHERLIST = "/voucherList";
  static const TRANSACTIONHISTORY = "/TransactionHistory";

  static const NEWPASSWORD = "/newPassword";
  static const SPURCARD = "/spurCard";
  static const ROCCOCARD = "/roccoCard";
  static const MEMBERCARD = "/memberCard";
  static const JOHNCARD = "/johnCard";
  static const PANAROTTISCARD = "/panarottisCard";
  static const COVIDQUESTION = "/covidQuestion";
  static const COVID = "/covid";
  static const SHAREDAPP = "/sharedApp";
  static const ROOT = '/root';
  static const NEWSDETAIL = '/newsDetail';
  static const STOREPAGE = '/storePage';
  static const DISPLAYNOTIFCATION = '/displayNotification';

  static const ONLINEDETAIL = "/onlineDash";
  static const ONLINEADDRESS = "/onlineAddress";
  static const ONLINECHECK = "/onlineCheck";
  static const ONLINEMYBAG = "/onlineMyBag";
  static const ONLINEFAV = "/onlineFavourite";
  static const ONLINEORDERMAIN = "/onlineOrderMain";
  static const ONLINEORDERHISTORY = "/onlineOrderHistory";
  static const ONLINEPAYMENT = "/onlinePay";
  static const ONLINEPROFILE = "/onlineProfile";
  static const ONLINEREASURANT = "/onlineReasurant";
  // static const ONLINEADDADRESS = "/onlineAddAddress";
  static const EARNPOINTS = "/earnpoints";
  static const PAYMENTFAIL = "/paymentFail";
  static const PAYMENTSUCCES = "/paymentSuccess";

  static final pnPages = {
    "About Us": Routes.ABOUTUS,
    "HowZaT": Routes.REWARDDASH,
    "Notifications": Routes.NOTIFICATION,
    "Health": Routes.HEALTH,
    "Restaurants": Routes.RESTUARANTPAGE,
    "News & Promotions": Routes.NEWS,
    "My Profile": Routes.PROFILE
  };
}

class AppPages {
  static var routes = [
    GetPage(name: Routes.DASHBOARD, page: () => RootView()),
    GetPage(name: Routes.HOME, page: () => HomeView()),
    GetPage(name: Routes.LOGIN, page: () => const Login()),
    GetPage(name: Routes.SPLASH, page: () => SplashScreen()),
    GetPage(name: Routes.ABOUTUS, page: () => const AboutUs()),
    GetPage(name: Routes.PROFILE, page: () => MyProfile()),
    GetPage(name: Routes.NOTIFICATION, page: () => const NotificationScreen()),
    GetPage(name: Routes.REWARDDASH, page: () => RewardsDashboard()),
    GetPage(name: Routes.HEALTH, page: () => HealthScreen()),
    GetPage(
        name: Routes.NEWS,
        page: () => NewsPage(),
        binding: BindingsBuilder.put(() => NewsController())),
    GetPage(name: Routes.CREATEACCOUNT, page: () => CreateAccount()),
    GetPage(name: Routes.FORGOTPASSWORD, page: () => ForgotPassword()),
    GetPage(name: Routes.NEWPASSWORD, page: () => NewPassword()),
    GetPage(name: Routes.CONTACTRESTUARANT, page: () => HealthScreen()),
    GetPage(name: Routes.RATESRESTAURANT, page: () => RateRestaurant()),
    GetPage(name: Routes.RESTAURANTDETAILS, page: () => RestaurantDetails()),
    GetPage(name: Routes.RESTUARANTPAGE, page: () => RestaurantsPage()),
    GetPage(name: Routes.REDEEMCODE, page: () => RedeemCode()),
    GetPage(name: Routes.REDEEMHISTORY, page: () => RedeemHistory()),
    GetPage(name: Routes.REDEEMRESTUARANT, page: () => RedeemRestaurant()),
    GetPage(name: Routes.ENTERCODE, page: () => EnterCode()),
    GetPage(name: Routes.PREFERREDSTORE, page: () => PreferredStore()),
    GetPage(name: Routes.VOUCHERLIST, page: () => VoucherList()),
    GetPage(name: Routes.EARNPOINTS, page: () => EarnPoints()),
    GetPage(
        name: Routes.DISPLAYNOTIFCATION,
        page: () => DisplayNotification(
              data: const ["", "", "", ""],
            ),
        arguments: const ["", "", "", ""]),
    GetPage(
      name: Routes.STOREPAGE,
      page: () => StoresScreen(),
    ),
    GetPage(name: Routes.NEWSDETAIL, page: () => NewsDetails()),
    GetPage(
        name: Routes.ONLINEDETAIL,
        page: () => DetailScreen(),
        binding: BindingsBuilder.put(() => DetailController())),
    GetPage(
        name: Routes.ONLINEADDRESS,
        page: () => const AddressScreen(),
        binding: BindingsBuilder.put(() => AddressController())),
    GetPage(
        name: Routes.ONLINECHECK,
        page: () => CheckOutScreen(dn: ""),
        binding: BindingsBuilder.put(() => CheckOutController())),
    GetPage(
        name: Routes.ONLINEMYBAG,
        page: () => MyBagScreen(),
        binding: BindingsBuilder.put(() => MyBagController())),
    GetPage(
        name: Routes.ONLINEFAV,
        page: () => OrderFavouriteScreen(),
        binding: BindingsBuilder.put(() => OrderFavouriteController())),
    GetPage(
        name: Routes.ONLINEORDERHISTORY,
        page: () => OrderHistoryScreen(),
        binding: BindingsBuilder.put(() => OrderHistoryController())),
    GetPage(
        name: Routes.ONLINEORDERMAIN,
        page: () => OrderMainScreen(),
        binding: BindingsBuilder.put(() => OrderMainController())),
    GetPage(
        name: Routes.ONLINEPAYMENT,
        page: () => PaymentScreen(),
        binding: BindingsBuilder.put(() => PaymentController())),
    GetPage(
        name: Routes.ONLINEPROFILE,
        page: () => ProfileScreen(),
        binding: BindingsBuilder.put(() => ProfileController())),
    GetPage(
        name: Routes.ONLINEREASURANT,
        page: () => ReasurantMenuScreen(),
        binding: BindingsBuilder.put(() => ReasurantMenuController())),
    // GetPage(
    //     name: Routes.ONLINEADDADRESS,
    //     page: () => AddAddressScreen(),
    //     binding: BindingsBuilder.put(() => AddressController())),
    GetPage(
        name: Routes.PAYMENTSUCCES,
        page: () => PaymentSuccess(),
        binding: BindingsBuilder.put(() => PaymentController())),
    GetPage(
        name: Routes.PAYMENTFAIL,
        page: () => PaymentFail(),
        binding: BindingsBuilder.put(() => PaymentController())),
         GetPage(
        name: Routes.TRANSACTIONHISTORY,
        page: () => TransactionHistory(),
        // binding: BindingsBuilder.put(() => PaymentController())
        )
  ];
}
