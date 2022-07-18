// SharedPreference Const
const String isPrayerNotificationActiveKey = 'prayer_shared_key';
const String isFajerNotificationActiveKey = 'fajer_shared_key';
const String isDuharNotificationActiveKey = 'duhar_shared_key';
const String isMagrbNotificationActiveKey = 'magrb_shared_key';
const String isIshaNotificationActiveKey = 'ish_shared_key';
const String isAsrNotificationActiveKey = 'asr_shared_key';
const String kIsShafiKey = 'madhab_key';
const String kIsShi3iKey = 'shi3i_key';
const String kIsFirstTimeKey = 'firstTime_key';
const String kChangeHijriDate = 'change_hijri_date';

//Change Prayer Time Keys Use Prayer.nameOfSalah

//Notification Channel
const String kContentChannelGroupKey = 'content_group_channel';
const String kPrayerChannelGroupKey = 'prayer_times_group';
const String kVersesChannleKey = 'verse_channel';
const String kFcmChannleKey = 'fcm_channel';
const String kDuasChannleKey = 'dua_channel';
const String kHadithChannleKey = 'hadith_channel';
const String kFajerChannleKey = 'fajer_time';
const String kduharChannleKey = 'duhar_time';
const String kAsrChannleKey = 'asr_time';
const String kMaghrbChannleKey = 'magrb_time';
const String kishaChannleKey = 'isha_time';
const String reminderChannelKey = 'reminder_channel_key';

// Hive Const (local Database)
const String kNotificationBoxName = 'prayer_notification';
const String kVerseBoxName = 'verse';
const String kDuaBoxName = 'dua';
const String kHadithBoxName = 'hadith';
const String kUpdateContentBoxName = 'update_content';
const String kFcmBoxName = 'fcmBox';
const String kNewVerseBoxName = 'new_verse';
const String kReminderBoxName = 'reminder_box';

// App Urls
const String baseUrl = 'https://app.albaqer.org/api/';

const String kGetVersesUrl = '${baseUrl}verses?page=';
const String kGetPreviousVersesUrl = '${baseUrl}previous_verses?page=';
const String kGetPreviousHadithUrl = '${baseUrl}previous_hadith?page=';
const String kGetHadithUrl = '${baseUrl}hadith?page=';
const String kGetUpdateUrl = '${baseUrl}updated';
const String kAppAdUrl = '${baseUrl}app_ad';
const String kAboutUsUrl = '${baseUrl}about_us';
const String kCallUsUrl = '${baseUrl}call_us';
const String kHoliday = '${baseUrl}holiday';
const String kNotification = '${baseUrl}notification';
