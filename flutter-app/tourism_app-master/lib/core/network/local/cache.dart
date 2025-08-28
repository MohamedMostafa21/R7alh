import 'package:hive_flutter/adapters.dart';
import 'package:tourism_app/features/authentication/login/data/models/login_model.dart';

Box? userCache;
String userCacheBoxKey = 'userCache';
// keys

String sliderValueKey = 'slider_value_key';
String hoursWorkedKey = 'hours_worked_key';
String rememberMeKey = 'rememberMeKey';
String onBoardingKey = 'onBoardingKey';
String userCacheKey = 'userCacheKey';
String checkInKey = 'checkInKey';

// value
bool onBoardingValue = true;
bool rememberMe = false;
bool checkInCache = false;
LoginModel ? userCacheValue;
