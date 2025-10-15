import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';

class HomeBindings implements Bindings {
  @override 
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
    // lazyPut itu buat ngehemat memori
    // jadi controller ini bakal di buat ketika di butuhkan saja
  }
}