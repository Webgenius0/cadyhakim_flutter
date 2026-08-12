import '../constants/app_constants.dart';
import '../helpers/di.dart';

Future<void> totalDataClean() async {
  await appData.write(kKeyIsLoggedIn, false);
  await appData.write(kKeyIsExploring, false);
  appData.write(kKeyLanguage, kKeyEnglish);
  appData.write(kKeyCountryCode, countriesCode[kKeyEnglish]);
  appData.write(kKeySelectedLocation, false);
  
  await appData.write(kKeySelectedLat, 22.818285677915657);
  await appData.write(kKeySelectedLng, 89.5535583794117);
}
