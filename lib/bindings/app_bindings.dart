import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies(){
    Get.put<NewsController>(NewsController(), permanent: true);
    // permanent: true itu biar dia ga ke hapus dari memori
    // jadi controller ini bakal selalu ada selama aplikasi di buka
    // jadi ini tuh buat ngasih tau getx kalo controller ini bakal di pake terus
  }
}