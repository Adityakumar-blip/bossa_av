import 'package:Bossa/model/address_model.dart';
import 'package:Bossa/model/user_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/services/services.dart';
import 'package:Bossa/util/resource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService extends GetxService {
  static SessionService get() => Get.find<SessionService>();

  final _api = Api();

  Future<bool> checkUser() async {
    var per = await SharedPreferences.getInstance();

    var isLogin = per.getBool("isLogin");
    if (isLogin != null && isLogin == true) {
      return true;
    }
    return false;
  }

  Future<bool> checkSlider() async {
    var per = await SharedPreferences.getInstance();
    bool? checkSlide;
    try {
      checkSlide = per.getBool("isViewSlider");
      if (checkSlide == null || checkSlide == false) {
        return false;
      }
      return checkSlide;
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut() async {
    var per = await SharedPreferences.getInstance();

    per.setBool('isLogin', false);

    Get.offAllNamed(Routes.LOGIN);
  }

  Future<String?> getUuid() async {
    var per = await SharedPreferences.getInstance();
    return per.getString("uuid");
  }

  Future<Resource<UserModel>> getUserInfo() async {
    var response = await _api.fetchUserDetails();
    return response;
  }

  Future<Address?> getUserAddress() async {
    return await _api.getUserAddress();
  }

  Future<void> getInitUserAddress() async {
    final _storage = Get.put<StorageService>(StorageService());
    var address = _storage.getUserAddress();

    if (address == null) {
      address = (await getUserAddress()) as Future<Address?>;
      _storage.setUserAddress(await address);
    }
  }

  Future<SessionService> init() async {
    bool check = await checkUser();
    var per = await SharedPreferences.getInstance();
    per.setBool("homeLoad", false);
    if (check) {
      per.setBool("homeLoad", true);
      if (per.getString('lat') == null && per.getString('long') == null) {
        var location = await GeoLocationService.get().getLowAccPostion();
        String? latitude = location!.coords.latitude.toString();
        String? longitude = location.coords.longitude.toString();
        per.setString("lat", latitude);
        per.setString("long", latitude);
      }

      await getInitUserAddress();
      await getRestaurant();
      await getSpecails();
      await advertisementData();
    }

    return this;
  }

  Future<void> getRestaurant() async {
    final _storage = Get.put<StorageService>(StorageService());
    final res = await Api.getRestautantlist();
    _storage.setRestaurant(res);
  }

  Future<void> getSpecails() async {
    final _storage = Get.put<StorageService>(StorageService());
    final specials = await Api.getSpecials();
    _storage.setSpecials(specials);
  }

  Future<void> advertisementData() async {
    final _storage = Get.put<StorageService>(StorageService());
    final adverts = await Api.advertisement();
    _storage.setAdvert(adverts);
  }
}
