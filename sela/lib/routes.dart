import 'package:flutter/material.dart';
import 'package:sela/components/loading_screen.dart';
import 'package:sela/components/new_custom_bottom_navbar.dart';
import 'package:sela/screens/admin/nav_bar_admin.dart';
import 'package:sela/screens/create_post/post_page.dart';
import 'package:sela/screens/details/details_screen.dart';
import 'package:sela/screens/forgot_password/forgot_password_screen.dart';
import 'package:sela/screens/home/components/individuals/all_individuals.dart';
import 'package:sela/screens/home/components/search_field.dart';
import 'package:sela/screens/home/home_screen.dart';
import 'package:sela/screens/login_success/login_success.dart';
import 'package:sela/screens/my_posts/edit_post_page.dart';
import 'package:sela/screens/my_posts/my_posts_page.dart';
import 'package:sela/screens/notification/notification_page.dart';
import 'package:sela/screens/profile/components/help_center.dart';
import 'package:sela/screens/profile/components/my_account_page.dart';
import 'package:sela/screens/profile/profile_screen.dart';
import 'package:sela/screens/saved/saved_screen.dart';
import 'package:sela/screens/sign_in/sign_in_screen.dart';
import 'package:sela/screens/sign_up/sign_up_screen.dart';
import 'package:sela/screens/splash/splash_screen.dart';

import 'models/my_post_model.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/home/components/organizations/all_organizations.dart';
import 'screens/otp/otp_screen.dart';

// use name routs instead of routes
// all routes should be in routs map and should be final
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  SavedScreen.routeName: (context) => SavedScreen(),
  PostPage.routeName: (context) => PostPage(),
  MyPostsPage.routeName: (context) => const MyPostsPage(),
  AllOrganizationsScreen.routeName: (context) => const AllOrganizationsScreen(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  EditPostPage.routeName: (context) => EditPostPage(
        post: ModalRoute.of(context)!.settings.arguments as MyPost,
      ),
  MyAccountPage.routeName: (context) => const MyAccountPage(),
  HelpCenterPage.routeName: (context) => const HelpCenterPage(),
  AllIndividualsScreen.routeName: (context) => const AllIndividualsScreen(),
  NotificationPage.routeName: (context) => const NotificationPage(),
  MainScreen.routeName: (context) => const MainScreen(),
  MainScreenAdmin.routeName: (context) => const MainScreenAdmin(),
  LoadingScreen.routeName: (context) => const LoadingScreen(),
};
