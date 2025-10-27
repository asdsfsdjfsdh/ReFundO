import 'dart:math';
import 'dart:convert';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';

class PasswordHasher {
  static const int _iterations = 1000;
  static const int _keyLength = 32;//

  //生成随机盐值
  static String generateRandomSalt(){
    final Random random = Random();
    final saltBytes = List<int>.generate(16, (index) => random.nextInt(256));
    return base64.encode(saltBytes);
  }

  //使用PBKDF2算法进行密码哈希处理
  static String hashPassword(String password, String salt){
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    final saltBytes = utf8.encode(salt);
    final passwordBytes = utf8.encode(password);
    
    pbkdf2.init(Pbkdf2Parameters(saltBytes, _iterations, _keyLength));
    final derivedKey = pbkdf2.process(passwordBytes);
    
    return base64.encode(derivedKey);
  }

  //验证密码
  static bool verifyPassword(String password, String salt, String hashedPassword){
    final hashedInputPassword = hashPassword(password, salt);
    return hashedInputPassword == hashedPassword;
  }
}