import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 6)
class User extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String phoneNumber;
  @HiveField(5)
  final String fullName;
  @HiveField(6)
  final String gender;
  @HiveField(7)
  final String nationality;
  @HiveField(8)
  final String city;
  @HiveField(9)
  final String country;
  @HiveField(10)
  final String religion;
  @HiveField(11)
  final String physique;
  @HiveField(12)
  final String skinColour;
  @HiveField(13)
  final String prayer;
  @HiveField(14)
  final String religiosity;
  @HiveField(15)
  final String beard;
  @HiveField(16)
  final String smoking;
  @HiveField(17)
  final String financialStatus;
  @HiveField(18)
  final String employment;
  @HiveField(19)
  final String income;
  @HiveField(20)
  final String healthStatus;
  @HiveField(21)
  final String specifications;
  @HiveField(22)
  final String aboutYou;
  @HiveField(23)
  final String job;
  @HiveField(24)
  final DateTime birthDate;
  @HiveField(25)
  final String civilIdNo;
  @HiveField(26)
  late String imageUrl;
  @HiveField(27)
  final int childrenNumber;
  @HiveField(28)
  final double height;
  @HiveField(29)
  final double weight;
  @HiveField(30)
  final bool isBlock;
  @HiveField(31)
  late List<String> fcm;
  @HiveField(32)
  final String token;
  @HiveField(33)
  final String socialStatus;
  @HiveField(34)
  final String educational;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.phoneNumber,
      required this.fullName,
      required this.gender,
      required this.nationality,
      required this.city,
      required this.country,
      required this.religion,
      required this.physique,
      required this.skinColour,
      required this.prayer,
      required this.religiosity,
      required this.beard,
      required this.smoking,
      required this.financialStatus,
      required this.employment,
      required this.income,
      required this.healthStatus,
      required this.specifications,
      required this.aboutYou,
      required this.job,
      required this.birthDate,
      required this.civilIdNo,
      this.imageUrl = '',
      required this.childrenNumber,
      required this.height,
      required this.weight,
      required this.isBlock,
      required this.token,
      required this.socialStatus,
      required this.educational,
      required this.fcm});

  factory User.fromJson(int id, String email, String name,
      Map<String, dynamic> profile, String token, bool isBlocked) {
    List<String> fcmResponse = [];
    if (profile['fire_base_token'].runtimeType == String) {
      fcmResponse.add(profile['fire_base_token']);
    } else {
      List<dynamic> dyn = profile['fire_base_token'];
      fcmResponse = dyn.map((e) => e.toString()).toList();
    }
    return User(
        id: id,
        email: email,
        name: name,
        phoneNumber: profile['phone_number'],
        gender: profile['gender'],
        nationality: profile['nationality'],
        city: profile['city'],
        job: profile['job'],
        birthDate: DateTime.parse(profile['birthdate']),
        civilIdNo: profile['civil_id_no'],
        childrenNumber: profile['children_number'],
        height: profile['height'].toDouble(),
        weight: profile['weight'].toDouble(),
        socialStatus: profile['social_status'],
        fcm: fcmResponse,
        isBlock: isBlocked,
        token: token,
        aboutYou: profile['aboutYou'],
        beard: profile['beard'],
        country: profile['country'],
        employment: profile['employment'],
        financialStatus: profile['financialStatus'],
        fullName: profile['fullName'],
        healthStatus: profile['healthStatus'],
        imageUrl: '$kbaseImageUrl${profile['image_url']}',
        income: profile['income'],
        physique: profile['physique'],
        prayer: profile['prayer'],
        religion: profile['religion'],
        religiosity: profile['religiosity'],
        skinColour: profile['skinColour'],
        smoking: profile['smoking'],
        specifications: profile['specifications'],
        educational: profile['educational']);
  }

  dynamic getProp(String key) => toMap()[key];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'gender': gender,
      'nationality': nationality,
      'city': city,
      'country': country,
      'religion': religion,
      'physique': physique,
      'skinColour': skinColour,
      'prayer': prayer,
      'religiosity': religiosity,
      'beard': beard,
      'smoking': smoking,
      'financialStatus': financialStatus,
      'employment': employment,
      'income': income,
      'healthStatus': healthStatus,
      'specifications': specifications,
      'aboutYou': aboutYou,
      'job': job,
      'birthDate': birthDate.millisecondsSinceEpoch,
      'civilIdNo': civilIdNo,
      'imageUrl': imageUrl,
      'childrenNumber': childrenNumber,
      'height': height,
      'weight': weight,
      'isBlock': isBlock,
      'fcm': fcm,
      'token': token,
      'socialStatus': socialStatus,
      'educational': educational,
    };
  }
}
