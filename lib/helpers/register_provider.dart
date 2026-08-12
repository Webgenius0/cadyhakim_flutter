
import 'package:provider/provider.dart';

import '../provider/onboarding_provider.dart';


var providers = [
  ChangeNotifierProvider<OnboardingProvider>(create: (context) => OnboardingProvider()),
];
