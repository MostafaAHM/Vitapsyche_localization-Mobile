import 'package:audio_session/audio_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/data/chat_provider.dart';
// import 'package:flutter_mindmed_project/firebase_options.dart';
// import 'package:flutter_mindmed_project/notification_service.dart';
import 'package:provider/provider.dart';
import 'features/ai_service/service/chat_bot/data/chat_service.dart';
import 'features/products/presentation/cubit/cart_cubit.dart';
import 'my_app.dart';
// import 'notification_service.dart'; // استيراد ملف الإشعارات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Initialize audio session
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.music());

// // Initialize notifications
//   await NotificationService.init();
//   // Schedule a repeating notification every minute
//   await NotificationService.showRepeatingNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        Provider<ChatService>(create: (_) => ChatService()),
        BlocProvider<CartCubit>(create: (context) => CartCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  void toggleLocale() {
    _locale =
        _locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    notifyListeners();
  }
}
