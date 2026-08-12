import 'package:numynd/features/audio_screen/data/send_audio_rx.dart';
import 'package:numynd/features/auth/data/forget_pass_data/forget_pass_rx.dart';
import 'package:numynd/features/auth/data/login_data/login_rx.dart';
import 'package:numynd/features/auth/data/signup_data/signup_rx.dart';
import 'package:numynd/features/favourite_screen/data/get_favourite_song_data/get_favourite_song_rx.dart';
import 'package:numynd/features/favourite_screen/data/post_favourite_data/post_favourite_rx.dart';
import 'package:numynd/features/favourite_screen/model/get_favourite_song_model.dart';
import 'package:numynd/features/home_screen/data/get_all_song_rx.dart';
import 'package:numynd/features/home_screen/data/get_today_rx.dart';
import 'package:numynd/features/home_screen/model/get_all_song_model.dart';
import 'package:numynd/features/home_screen/model/get_today_model.dart';
import 'package:numynd/features/notification/data/send_data_rx.dart';
import 'package:numynd/features/profile_screen.dart/data/change_pass_data/change_password_rx.dart';
import 'package:numynd/features/profile_screen.dart/data/get_profile_data/get_profile_rx.dart';
import 'package:numynd/features/profile_screen.dart/data/update_profile_data/update_profile_rx.dart';
import 'package:numynd/features/profile_screen.dart/model/profile_model.dart';
import 'package:numynd/features/setting_screen/data/delete_account/delete_rx.dart';
import 'package:numynd/features/setting_screen/data/logout_data/logout_rx.dart';
import 'package:numynd/features/social_login/data/social_login_rx.dart';
import 'package:rxdart/subjects.dart';

PostSocailLoginRX postSocailLoginRX = PostSocailLoginRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

PostSigninRX postSigninRXObj = PostSigninRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

PostSignupRX postSignupRXObj = PostSignupRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

PostLogOutRX postLogOutRX = PostLogOutRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

PostResetPassApiRX postResetPassApiRX = PostResetPassApiRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

GetAllSongRX getAllSongRXObj = GetAllSongRX(
  empty: GetAllMusic(),
  dataFetcher: BehaviorSubject<GetAllMusic>(),
);

GetTodaySongRX getTodaySongRXObj = GetTodaySongRX(
  empty: GetTodaySongModel(),
  dataFetcher: BehaviorSubject<GetTodaySongModel>(),
);

PostForgetPassRX postForgetPassRXObj = PostForgetPassRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

PostUpdateProfileApiRX postUpdateProfileApiRX = PostUpdateProfileApiRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

GetProfileInfoRX getProfileInfoRXObj = GetProfileInfoRX(
  empty: GetProfile(),
  dataFetcher: BehaviorSubject<GetProfile>(),
);

GetFavouriteSongRX getFavouriteSongRXObj = GetFavouriteSongRX(
  empty: GetFavouriteSong(),
  dataFetcher: BehaviorSubject<GetFavouriteSong>(),
);

PostFavouriteRX postFavouriteRXObj = PostFavouriteRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

PostSendAudioRX postSendAudioRXObj = PostSendAudioRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

PostFCMRX postFCMRXObj = PostFCMRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);

PostDeleteAccountRX postDeleteAccountRX = PostDeleteAccountRX(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map<String, dynamic>>(),
);
