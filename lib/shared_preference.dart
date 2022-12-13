import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager{
  Future<String?> getUserId() async{
    final spf = await SharedPreferences.getInstance();
    try{
      return spf.getString('userId');
    } catch (e){  }
    return null;
  }

  void setUserId(String? userId) async{
    final spf = await SharedPreferences.getInstance();
    spf.setString('userId', userId!);
  }
}