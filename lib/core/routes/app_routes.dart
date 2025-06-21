// app_routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/On_Board/on_boarding.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/presentation/view/chatbot.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/lina/presentation/view/line_screen.dart';
import 'package:flutter_mindmed_project/features/authentication/presentation/view/doctor_register_screen.dart';
import 'package:flutter_mindmed_project/features/doctor/data/doctor_model.dart';
import 'package:flutter_mindmed_project/features/doctor/presentation/view/ask_doctor_service.dart';
// import 'package:flutter_mindmed_project/features/doctor/presentation/view/doctor_book_screen.dart';
import 'package:flutter_mindmed_project/features/entertainment/daily_challenge_screen.dart';
import 'package:flutter_mindmed_project/features/entertainment/entermainment_screen.dart';
import 'package:flutter_mindmed_project/features/entertainment/games_home.dart';
import 'package:flutter_mindmed_project/features/entertainment/mood_tracker_screen.dart';
import 'package:flutter_mindmed_project/features/home/presentation/doctorService_book_screen.dart';
import 'package:flutter_mindmed_project/features/more/presentation/view/country.dart';
import 'package:flutter_mindmed_project/features/more/presentation/view/emargancy_call.dart';
import 'package:flutter_mindmed_project/features/payment/presentation/view/payment_doctor_screen.dart';
import 'package:flutter_mindmed_project/features/payment/presentation/view/payment_product_screen.dart';
import 'package:flutter_mindmed_project/features/payment/presentation/view/payment_profile.dart';
import 'package:flutter_mindmed_project/features/payment/presentation/view/payment_test_screen.dart';
import 'package:flutter_mindmed_project/features/products/presentation/view/cart_screen.dart';
import 'package:flutter_mindmed_project/features/products/presentation/view/product_details_screen.dart';
import 'package:flutter_mindmed_project/features/products/presentation/view/products_screen.dart';
import 'package:flutter_mindmed_project/features/splash_screen/presentation/view/splash_screen.dart';
import 'package:flutter_mindmed_project/features/test/data/test.dart';
import 'package:flutter_mindmed_project/features/test/presentation/view/depression_scale_result.dart';
import 'package:flutter_mindmed_project/features/test/presentation/view/personality_disorder_result.dart';
import 'package:flutter_mindmed_project/staff%20Screen/Doctor_home.dart';
import 'package:flutter_mindmed_project/staff%20Screen/Staff_main_navigation_screen.dart';
import 'package:flutter_mindmed_project/staff%20Screen/doctor_Profile.dart';
import '../../features/ai_service/view/ai_service_screen.dart';
import '../../features/artical/data/model_blog.dart';
import '../../features/artical/presentation/view/blog_service.dart';
import '../../features/artical/presentation/view/details_blog.dart';
import '../../features/authentication/presentation/view/authentication.dart';
import '../../features/authentication/presentation/view/signin_screen.dart';
import '../../features/authentication/presentation/view/signup_screen.dart';
import '../../features/doctor/presentation/view/doctor_screen.dart';
import '../../features/fqas/presentation/view/fqas_service.dart';
import '../../features/home/presentation/view/home_screen.dart';
import '../../features/main_navigation/presentation/view/main_navigation_screen.dart';
import '../../features/more/presentation/view/about.dart';
import '../../features/more/presentation/view/contact_us.dart';
import '../../features/more/presentation/view/language.dart';
import '../../features/more/presentation/view/more.dart';
import '../../features/profile_user/presentation/view/profile.dart';
import '../../features/test/presentation/view/do_test.dart';
import '../../features/test/presentation/view/test_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String personalityDisorderResult = '/personalityDisorderResult';
  static const String onBoardingScreen = '/onBoardingScreen';
  static const String aiServiceScreen = '/aiServiceScreen';
  static const String chatScreen = '/chatScreen';
  static const String linaScreen = '/linaScreen';
  static const String authentication = '/authentication';
  static const String signinScreen = '/signinScreen';
  static const String signupScreen = '/signupScreen';
  static const String DoctorRegistration = '/DoctorRegistration';
  static const String mainNavigationScreen = '/mainNavigationScreen';
  static const String homeScreen = '/homeScreen';
  static const String profile = '/profile';
  static const String profileDetails = '/profileDetails';
  static const String paymentProfile = '/paymentProfile';
  static const String doctorprofile = '/DoctorProfileScreen';
  static const String fqasScreen = '/fqasService';
  static const String blogScreen = '/blogScreen';
  static const String detailsBlog = '/detailsBlog';
  static const String more = '/more';
  static const String about = '/about';
  static const String contactUs = '/contactUs';
  static const String language = '/language';
  static const String testScreen = '/testScreen';
  static const String doTest = '/doTest';
  static const String depressionScaleResult = '/depressionScaleResult';
  static const String productsScreen = '/productsScreen';
  static const String detailsProduct = '/detailsProduct';
  static const String cartScreen = '/cartScreen';
  static const String doctor = '/doctor';
  static const String doctorHomeScreen = '/doctorHomeScreen';
  static const String StaffScreen = '/StaffScreen';
  static const String askDoctor = '/askDoctor';
  static const String doctorBookingScreen = '/DoctorBookingScreen';
  static const String doctorServiceBookingScreen =
      '/doctorServiceBookingScreen';
  static const String country = '/country';
  static const String emargancyCall = '/emarfancyCall';
  static const String paymentProductScreen = '/paymentProductScreen';
  static const String paymenttestScreen = '/paymentTestScreen';
  static const String paymentDoctorScreen = '/paymentDoctorScreen';

  static const String intertainment_Home = '/intertainment_Home';
  static const String mood_tracker = '/mood_tracker';
  static const String daily_challenge = '/daily_challenge';
  static const String games = '/games';
  static const String heartRateMonitor = '/heartRateMonitor';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplachScreen());
      case onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case aiServiceScreen:
        return MaterialPageRoute(builder: (_) => const AiServiceScreen());
      case chatScreen:
        return MaterialPageRoute(builder: (_) => ChatScreen());
      case linaScreen:
        return MaterialPageRoute(builder: (_) => const LynaModel(title: ''));
      case authentication:
        return MaterialPageRoute(builder: (_) => const Authentication());
      case signinScreen:
        return MaterialPageRoute(builder: (_) => const SigninScreen());
      case signupScreen:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case DoctorRegistration:
        return MaterialPageRoute(
            builder: (_) => const DoctorRegistrationScreen());
      case mainNavigationScreen:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const Profile());
      case paymentProfile:
        return MaterialPageRoute(builder: (_) => const PaymentProfile());
      case doctorprofile:
        return MaterialPageRoute(builder: (_) => const DoctorProfileScreen());
      case fqasScreen:
        return MaterialPageRoute(builder: (_) => const FqasScreen());
      case blogScreen:
        return MaterialPageRoute(builder: (_) => const BlogScreen());
      case detailsBlog:
        final args = settings.arguments as ModelBlog;
        return MaterialPageRoute(
            builder: (_) => const DetailsBlog(),
            settings: RouteSettings(arguments: args));
      case more:
        return MaterialPageRoute(builder: (_) => const More());
      case about:
        return MaterialPageRoute(builder: (_) => const About());
      case contactUs:
        return MaterialPageRoute(builder: (_) => const ContactUs());
      case language:
        return MaterialPageRoute(builder: (_) => const Language());
      case doctor:
        return MaterialPageRoute(builder: (_) => DoctorScreen());
      case doctorHomeScreen:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());
      case StaffScreen:
        return MaterialPageRoute(
            builder: (_) => const StaffMainNavigationScreen());
      case testScreen:
        return MaterialPageRoute(builder: (_) => const TestScreen());
      case intertainment_Home:
        return MaterialPageRoute(builder: (_) => Intertainment_Home());
      case mood_tracker:
        return MaterialPageRoute(builder: (_) => const MoodTrackerScreen());
      case daily_challenge:
        return MaterialPageRoute(builder: (_) => DailyChallengeScreen());
      case games:
        return MaterialPageRoute(builder: (_) => const GamesHome());
      case doTest:
        final Test doTest = settings.arguments as Test;
        return MaterialPageRoute(
          builder: (_) {
            return DoTest(
              test: doTest,
            );
          },
        );
      case depressionScaleResult:
        final Map doTest = settings.arguments as Map;

        return MaterialPageRoute(
          builder: (_) => DepressionScaleResult(
            test: doTest['test'],
            totalSorce: doTest['totalScore'],
          ),
        );
      case productsScreen:
        return MaterialPageRoute(
          builder: (_) => const ProductsScreen(),
        );

      case personalityDisorderResult:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => PersonalityDisorderResultScreen(
            answers: args['answers'],
          ),
        );
      case detailsProduct:
        final dataDetailsProduct = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => DetailsProduct(
                  title: dataDetailsProduct['title'],
                  about: dataDetailsProduct['about'],
                  image: dataDetailsProduct['image'],
                  price: dataDetailsProduct['price'],
                ));

      case cartScreen:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case askDoctor:
        return MaterialPageRoute(builder: (_) => const AskDoctor());
      case paymentProductScreen:
        final dataPrice = settings.arguments as double;
        return MaterialPageRoute(
            builder: (_) => PaymentProductScreen(
                  price: dataPrice,
                  
                ));
      case paymenttestScreen:
        final data = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => PaymentTestScreen(
                  test: data['test'],
                  nameTest: data['nameTest'],
                  price: data['price'],
                ));
      case paymentDoctorScreen:
        final data = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => PaymentDoctorScreen(
                  price: data['price'],
                  imageDoctor: data['image'],
                  nameDoctor: data['nameDoctor'],
                  timeDoctor: data['timeDoctor'],
                ));
      // case AppRoutes.doctorBookingScreen:
      //   final DoctorModel doctor = settings.arguments as DoctorModel;
      //   return MaterialPageRoute(
      //     builder: (_) => DoctorBookingScreen(
      //       doctor: doctor,
      //       doctorDetailsId: doctor.doctorDetails.id, // Pass doctor_details ID
      //     ),
      //   );
      case AppRoutes.doctorServiceBookingScreen:
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        final DoctorModel doctor = args['doctor'];
        final int serviceId = args['serviceId'];
        return MaterialPageRoute(
          builder: (_) => DoctorServiceBookingScreen(
            doctor: doctor,
            doctorDetailsId: doctor.doctorDetails.id, // Pass doctor_details ID
            serviceId: serviceId, // Pass serviceId
          ),
        );
      case country:
        return MaterialPageRoute(builder: (_) => const Country());

      case emargancyCall:
        return MaterialPageRoute(builder: (_) => const EmargancyCall());
      // default:
      //   return MaterialPageRoute(
      //     builder: (_) => Scaffold(
      //       body: Center(
      //         child: Text('No route defined for ${settings.name}'),
      //       ),
      //     ),
      //   );
    }
  }
}
