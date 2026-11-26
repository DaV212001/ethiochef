import 'package:ethiochef/config/storage_config.dart';
import 'package:ethiochef/main.dart' as app;
import 'package:ethiochef/models/food.dart';
import 'package:ethiochef/screens/profile/layout/route_list.dart';
import 'package:ethiochef/screens/recipe/layout/recipe_tabs.dart';
import 'package:ethiochef/screens/recipe/recipe_screen.dart';
import 'package:ethiochef/services/ad_service.dart';
import 'package:ethiochef/services/authorization_service.dart';
import 'package:ethiochef/services/firsebase_service.dart';
import 'package:ethiochef/widgets/category/category_card.dart';
import 'package:ethiochef/widgets/youtube_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpRealTime(WidgetTester tester, Duration duration) async {
  const step = Duration(milliseconds: 250);
  final steps = (duration.inMilliseconds / step.inMilliseconds).ceil();
  for (int i = 0; i < steps; i++) {
    await Future.delayed(step);
    await tester.pump();
  }
}

Future<void> smoothDrag(
  WidgetTester tester,
  Finder target,
  Offset totalDelta, {
  int steps = 12,
}) async {
  if (target.evaluate().isEmpty) return;
  final center = tester.getCenter(target.first);
  final gesture = await tester.startGesture(center);
  final stepOffset = Offset(
    totalDelta.dx / steps,
    totalDelta.dy / steps,
  );
  for (int i = 0; i < steps; i++) {
    await gesture.moveBy(stepOffset);
    await tester.pump(const Duration(milliseconds: 35));
  }
  await gesture.up();
  await pumpRealTime(tester, const Duration(milliseconds: 600));
}

Future<void> notifyHostRecorder(String action) async {
  try {
    await http
        .get(Uri.parse('http://127.0.0.1:45678/$action'))
        .timeout(const Duration(seconds: 10));
  } catch (e) {
    debugPrint('[EthioChef Demo] Host recorder notice ($action): $e');
  }
}

Finder findPreferredRecipeCard(WidgetTester tester) {
  final allCards = find.byType(CategoryCard);
  final elements = allCards.evaluate().toList();
  for (final el in elements) {
    final widget = el.widget as CategoryCard;
    if (widget.name == null &&
        widget.food.video != null &&
        Food.parseVideoUrl(widget.food.video) != null) {
      return find.byWidget(widget);
    }
  }
  for (final el in elements) {
    final widget = el.widget as CategoryCard;
    if (widget.name == null) {
      return find.byWidget(widget);
    }
  }
  return allCards.first;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'App Store Guideline 2.1 Demo Flow (Launch, Browse Recipes, Video, Sign In, Delete Account)',
    (WidgetTester tester) async {
      // Prevent native iOS permission / full-screen ad overlays from interrupting recording
      FirebaseService.skipPermissionRequest = true;
      AdService.skipAppOpenAds = true;

      // Ensure clean guest start
      await ConfigPreference.init();
      await AuthService.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('savedRecipes');
      await prefs.remove('ethioChef_authorization_token');
      await ConfigPreference.logOut();

      // Start screen recording right as the app launches (skips "Test starting..." splash)
      await notifyHostRecorder('start');
      app.main();

      // 1. Wait for Home screen & recipe data to load
      for (int i = 0; i < 45; i++) {
        await Future.delayed(const Duration(milliseconds: 350));
        await tester.pump();
        if (find.byType(CategoryCard).evaluate().isNotEmpty && i > 6) {
          break;
        }
      }
      await pumpRealTime(tester, const Duration(seconds: 2));

      // Dismiss any unexpected update dialog if shown
      if (find.byType(Dialog).evaluate().isNotEmpty) {
        await tester.tapAt(const Offset(20, 20));
        await pumpRealTime(tester, const Duration(seconds: 1));
      }

      // 2. Showcase Home screen: browse meal tabs & scroll recipe carousels
      final lunchTab = find.text('Lunch');
      if (lunchTab.evaluate().isNotEmpty) {
        await tester.tap(lunchTab.first, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 2));
      }

      final homeScroll = find.byType(CustomScrollView);
      if (homeScroll.evaluate().isNotEmpty) {
        await smoothDrag(tester, homeScroll, const Offset(0, -340));
        await pumpRealTime(tester, const Duration(seconds: 2));
      }

      // 3. Open a recipe (preferring one with a video) to showcase video, ingredients & steps
      final cards = find.byType(CategoryCard);
      expect(cards, findsWidgets, reason: 'Home screen should display recipe cards');

      final recipeCard = findPreferredRecipeCard(tester);
      await tester.ensureVisible(recipeCard);
      await pumpRealTime(tester, const Duration(milliseconds: 500));
      await tester.tap(recipeCard, warnIfMissed: false);
      await pumpRealTime(tester, const Duration(seconds: 5));

      // If an embedded video player loaded without external fallback, tap play briefly
      final ytPlayer = find.byType(YoutubeVideoPlayer);
      if (ytPlayer.evaluate().isNotEmpty &&
          find.text('Watch on YouTube').evaluate().isEmpty &&
          find.text('Play Video').evaluate().isEmpty) {
        await tester.tap(ytPlayer.first, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 3));
      }

      // Switch to Steps tab if present, scroll down, then scroll back up to expose back button
      final stepsTab = find.text('Steps');
      if (stepsTab.evaluate().isNotEmpty) {
        await tester.tap(stepsTab.first, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 2));
      }

      final recipeScroll = find.ancestor(
        of: find.byType(RecipeScreenTab),
        matching: find.byType(SingleChildScrollView),
      );
      if (recipeScroll.evaluate().isNotEmpty) {
        await smoothDrag(tester, recipeScroll, const Offset(0, -260));
        await pumpRealTime(tester, const Duration(seconds: 2));
        await smoothDrag(tester, recipeScroll, const Offset(0, 260));
        await pumpRealTime(tester, const Duration(seconds: 1));
      }

      // Navigate back to Home cleanly
      if (find.byType(RecipeScreen).evaluate().isNotEmpty) {
        final backBtn = find.byIcon(Icons.arrow_back);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn.first, warnIfMissed: false);
          await pumpRealTime(tester, const Duration(seconds: 2));
        }
      }
      if (find.byType(RecipeScreen).evaluate().isNotEmpty) {
        Navigator.of(tester.element(find.byType(RecipeScreen))).pop();
        await pumpRealTime(tester, const Duration(seconds: 2));
      }
      expect(
        find.byType(RecipeScreen),
        findsNothing,
        reason: 'Should navigate back from RecipeScreen to MainScreen',
      );

      // 4. Browse Categories tab
      final categoriesTab = find.text('Categories');
      expect(categoriesTab, findsWidgets);
      await tester.tap(categoriesTab.last, warnIfMissed: false);
      await pumpRealTime(tester, const Duration(seconds: 3));

      // 5. Switch to Profile tab (Guest Mode) -> Sign In
      final profileTab = find.text('Profile');
      expect(profileTab, findsWidgets);
      await tester.tap(profileTab.last, warnIfMissed: false);
      await pumpRealTime(tester, const Duration(seconds: 2));

      final signInBtn = find.text('Sign In');
      expect(signInBtn, findsWidgets);
      await tester.tap(signInBtn.first, warnIfMissed: false);
      await pumpRealTime(tester, const Duration(seconds: 2));

      // 6. Enter test credentials: 944070484 / 12345678
      final textFields = find.byType(TextField);
      expect(textFields.evaluate().length, greaterThanOrEqualTo(2));
      await tester.enterText(textFields.at(0), '944070484');
      await pumpRealTime(tester, const Duration(milliseconds: 500));

      await tester.enterText(textFields.at(1), '12345678');
      await pumpRealTime(tester, const Duration(milliseconds: 500));

      FocusManager.instance.primaryFocus?.unfocus();
      await pumpRealTime(tester, const Duration(milliseconds: 600));

      final submitSignIn = find.widgetWithText(ElevatedButton, 'Sign In');
      if (submitSignIn.evaluate().isNotEmpty) {
        await tester.ensureVisible(submitSignIn.first);
        await pumpRealTime(tester, const Duration(milliseconds: 300));
        await tester.tap(submitSignIn.first, warnIfMissed: false);
      } else {
        final signInText = find.text('Sign In');
        await tester.ensureVisible(signInText.last);
        await tester.tap(signInText.last, warnIfMissed: false);
      }

      // Wait for live backend authentication
      bool loggedIn = false;
      for (int i = 0; i < 45; i++) {
        await Future.delayed(const Duration(milliseconds: 350));
        await tester.pump();
        loggedIn = await AuthService.isUserLoggedIn();
        if (loggedIn && i > 4) {
          break;
        }
      }
      debugPrint('[EthioChef Demo] Login completed: loggedIn=$loggedIn');
      expect(loggedIn, isTrue, reason: 'Login with 944070484 / 12345678 should succeed');
      await pumpRealTime(tester, const Duration(seconds: 3));

      // Ensure we are on Profile tab showing the authenticated user and RouteList
      for (int i = 0; i < 20; i++) {
        if (find.text('Delete Account').evaluate().isNotEmpty) {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 350));
        await tester.pump();
      }

      // 7. Scroll Profile screen to reveal and showcase Delete Account flow
      final profileScroll = find.ancestor(
        of: find.byType(RouteList),
        matching: find.byType(SingleChildScrollView),
      );
      if (profileScroll.evaluate().isNotEmpty) {
        await smoothDrag(tester, profileScroll, const Offset(0, -420));
        await pumpRealTime(tester, const Duration(seconds: 1));
      }

      final deleteAccountFinder = find.text('Delete Account');
      expect(
        deleteAccountFinder,
        findsWidgets,
        reason: 'Signed-in Profile screen must show Delete Account option',
      );
      await tester.ensureVisible(deleteAccountFinder.last);
      await pumpRealTime(tester, const Duration(seconds: 1));
      await tester.tap(deleteAccountFinder.last, warnIfMissed: false);
      await pumpRealTime(tester, const Duration(seconds: 4));

      // Verify confirmation modal is displayed, then dismiss to keep demo account active
      final cancelBtn = find.text('Cancel');
      expect(cancelBtn, findsWidgets, reason: 'Delete Account dialog should show Cancel');
      await tester.tap(cancelBtn.last, warnIfMissed: false);
      await pumpRealTime(tester, const Duration(seconds: 2));

      debugPrint('[EthioChef Demo] Guideline 2.1 demo flow finished.');
      await notifyHostRecorder('stop');
    },
  );
}
