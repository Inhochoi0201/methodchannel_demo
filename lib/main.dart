import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MethodChannelDemo()
    );
  }
}

class MethodChannelDemo extends StatelessWidget {
  MethodChannelDemo({Key? key}) : super(key: key);
  final controller = Get.put(MethodChannelDemoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Android Native Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(()=> Text('안드로이드 버전: ${controller._version.value}')),
            Obx(()=> Text('베터리 :${controller._battery.value}%')),
            Obx(()=> Text('네이티브 현재 값: ${controller._value.value}')),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              controller.getAndroidVersionName();
            }, child: const Text('안드로이드 모델네임 얻기')),
            ElevatedButton(onPressed: (){
              controller.getBatteryLevel();
            }, child: const Text('베터리 얻기')),
            ElevatedButton(onPressed: (){
              controller.getValue();
            }, child: const Text('네이티브 값 얻기'))
          ],
        ),
      ),
    );
  }
}

class MethodChannelDemoController extends GetxController {
  RxString _value = 'connecting...'.obs;
  RxString _battery = 'waiting...'.obs;
  RxString _version = 'waiting...'.obs;
  static const platform = MethodChannel('example.com/value');

  Future<void> getValue() async {
    String value;
    try {
      value = await platform.invokeMethod('getValue');
    } on PlatformException catch (e) {
      value = '네이티브 코드 에러 : ${e.message}';
    }
    _value.value = value;
  }

  Future<void> getBatteryLevel() async {
    String battery;
    int result;
    try {
      result = await platform.invokeMethod('getBatteryLevel'); // 안드로이드에서 작성한 메서드 invoke
      battery = '$result'; // int to String
    } on PlatformException catch (e) {
      battery = '베터리 확인 불가능 : ${e.message}';
    }
    _battery.value = battery;
  }

  Future<void> getAndroidVersionName() async {
    String name;
    try {
      name = await platform.invokeMethod('getAndroidModelName');
    } on PlatformException catch (e) {
      name = '버전 확인 실패 : ${e.message}';
    }
    _version.value = name;
  }
}