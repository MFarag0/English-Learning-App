import 'package:go_router/go_router.dart';
import 'package:kalimati_app/core/navigations/shell_scaffold.dart';
import 'package:kalimati_app/features/auth/presentation/screens/add_package.dart';
import 'package:kalimati_app/features/auth/presentation/screens/edit_package.dart';
import 'package:kalimati_app/features/auth/presentation/screens/login_screen.dart';
import 'package:kalimati_app/features/auth/presentation/screens/teacher_packages.dart';
import 'package:kalimati_app/features/games/flashcards/presentation/screens/flashcards_details.dart';
import 'package:kalimati_app/features/games/flashcards/presentation/screens/flashcards_list.dart';
import 'package:kalimati_app/features/home/presentation/screens/gamelist.dart';
import 'package:kalimati_app/features/games/match/presentation/screens/matching_list.dart';
import 'package:kalimati_app/features/games/match/presentation/screens/matching_details.dart';
import 'package:kalimati_app/features/games/unscramble/presentation/screens/unscramble_details.dart';
import 'package:kalimati_app/features/games/unscramble/presentation/screens/unscramble_list.dart';
import 'package:kalimati_app/features/home/presentation/screens/home.dart';
import 'package:kalimati_app/features/home/presentation/screens/packages_list.dart';


class AppRouter {
  static final route = GoRouter(
    initialLocation: "/home",
    routes: [
      ShellRoute(
        builder: (context, state, child) {
        final currentSelection = state.uri.toString();
        if (currentSelection.startsWith('/home')) {
          return ShellScaffold(currentIndex: 0, child: child,);
        } 
        else if (currentSelection.startsWith('/games')) {
          return ShellScaffold(currentIndex: 1, child: child,);
        }
        else {
          return ShellScaffold(currentIndex: 2, child: child,);
        }
        
      },
      routes: [
        GoRoute(
          path: '/home',
          builder:(context, state) => const Home(),
        ),
        GoRoute(
          path: '/packages',
          builder:(context, state) => const PackagesList(),
        ),
        
        GoRoute(
          path: '/games',
          builder:(context, state) => const Gamelist(),
        ),
        
      ]
      ),
          GoRoute(
          path: '/flashcards',
          builder:(context, state) => const FlashcardsList(),
        ),
        GoRoute(
          path: '/unscramble',
          builder:(context, state) => const UnscrambleList(),
        ),
        GoRoute(
          path: '/match',
          builder:(context, state) => const MatchingList(),
        ),
        GoRoute(
          path: "/login",

          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: "/teacher-packages/:id",
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TeacherPackages(userId: id);
          },
        ),
          GoRoute(
            path: "/flashcards/:id",
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return Flashcards(packageId: id);
            },
          ),
          GoRoute(
            path: "/unscramble/:id",
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return Unscramble(packageId: id);
            },
          ),
          GoRoute(
            path: "/match/:id",
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return Matching(packageId: id);
            },
          ),
          GoRoute(
            path: "/editPackage/:id",
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EditPackage(packageId: id);
            },
          ),
          GoRoute(
            path: "/addPackage/:id",
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return AddPackageScreen(userId: id);
            },
          ),
    ],
      );

    
    
  
}
