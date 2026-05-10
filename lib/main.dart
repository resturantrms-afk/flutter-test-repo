import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurnt_rms/bloc/cart_bloc/cart_bloc.dart';
import 'package:restaurnt_rms/bloc/menu_bloc/menu_bloc.dart';
import 'package:restaurnt_rms/bloc/menu_bloc/menu_event.dart';
import 'package:restaurnt_rms/repositories/menu_repository.dart';
import 'package:restaurnt_rms/bloc/order_history_bloc/order_history_bloc.dart';
import 'package:restaurnt_rms/screens/menu_screen.dart';
import 'package:restaurnt_rms/screens/welcome_screen.dart';
import 'package:restaurnt_rms/screens/details_screen.dart';
import 'package:restaurnt_rms/screens/cart_screen.dart';
import 'package:restaurnt_rms/screens/status_screen.dart';
import 'package:restaurnt_rms/screens/order_history_screen.dart';
import 'package:restaurnt_rms/model/menu_item.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final String? tableParam = state.uri.queryParameters['table'];
        final int tableNumber = int.tryParse(tableParam ?? '1') ?? 1;
        return WelcomeScreen(tableNumber: tableNumber);
      },
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) {
        final int tableNumber = state.extra as int? ?? 1;
        return MenuScreen(tableNumber: tableNumber);
      },
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final MenuItem item = state.extra as MenuItem;
        return DetailsScreen(menuItem: item);
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(path: '/status', builder: (context, state) => const StatusScreen()),
    GoRoute(
      path: '/history',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
  ],
);

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MenuRepository>(
          create: (context) => MockMenuRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MenuBloc>(
            create: (context) {
              final repo = context.read<MenuRepository>();
              return MenuBloc(repository: repo)..add(LoadMenu());
            },
          ),

          BlocProvider<CartBloc>(create: (context) => CartBloc()),
          BlocProvider<OrderHistoryBloc>(create: (context) => OrderHistoryBloc()),
        ],
        child: MaterialApp.router(
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(
              0xFF271C15,
            ), // Background Color
            cardColor: const Color(0xFF342720), // Cards Color
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFE88328), // Buttons Color
              secondary: Color(0xFFE88328),
              surface: Color(0xFF271C15),
              surfaceContainerHighest: Color(
                0xFF453429,
              ), // Unclicked sort Color
              onPrimary: Colors.white,
            ),

            textTheme: TextTheme(
              displayLarge: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFF5E6DC),
              ),
              bodyLarge: GoogleFonts.beVietnamPro(
                color: const Color(0xFFF5E6DC),
              ),
              bodyMedium: GoogleFonts.beVietnamPro(
                color: const Color(0xFFF5E6DC),
              ),
              labelLarge: GoogleFonts.beVietnamPro(
                color: const Color(0xFF2A1E17),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
