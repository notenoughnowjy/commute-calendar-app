import 'package:commute_calendar/feature/calendar/presentation/pages/calendar_page.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/calendar',
    routes: [
      GoRoute(path: '/calendar', builder: (context, state) => const CalendarPage()),
    ],
  );
}
