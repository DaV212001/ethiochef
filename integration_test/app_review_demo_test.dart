import 'package:ethiochef/config/storage_config.dart';
import 'package:ethiochef/main.dart' as app;
import 'package:ethiochef/screens/profile/layout/route_list.dart';
import 'package:ethiochef/screens/recipe/layout/recipe_tabs.dart';
import 'package:ethiochef/services/ad_service.dart';
import 'package:ethiochef/services/authorization_service.dart';
import 'package:ethiochef/services/firsebase_service.dart';
import 'package:ethiochef/widgets/category/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

      app.main();

      // 1. Wait for Home screen & recipe data to load
      for (int i = 0; i < 45; i++) {
        await Future.delayed(const Duration(milliseconds: 350));
        await tester.pump();
        if (find.byType(CategoryCard).evaluate().isNotEmpty && i > 6) {
          break;
        }
      }
      await pumpRealTime(tester, const Duration(seconds: 3));

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
        await smoothDrag(tester, homeScroll, const Offset(0, 340));
        await pumpRealTime(tester, const Duration(seconds: 1));
      }

      // 3. Open a recipe to showcase video playback, ingredients & steps
      final cards = find.byType(CategoryCard);
      if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 5));

        // Switch to Steps tab if present, then scroll down to view details
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
          await smoothDrag(tester, recipeScroll, const Offset(0, -280));
          await pumpRealTime(tester, const Duration(seconds: 2));
        }

        // Navigate back to Home
        final backBtn = find.byIcon(Icons.arrow_back);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn.first, warnIfMissed: false);
          await pumpRealTime(tester, const Duration(seconds: 2));
        } else {
          await tester.pageBack();
          await pumpRealTime(tester, const Duration(seconds: 2));
        }
      }

      // 4. Browse Categories tab
      final categoriesTab = find.text('Categories');
      if (categoriesTab.evaluate().isNotEmpty) {
        await tester.tap(categoriesTab.last, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 3));
      }

      // 5. Switch to Profile tab (Guest Mode) -> Sign In
      final profileTab = find.text('Profile');
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab.last, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 2));
      }

      final signInBtn = find.text('Sign In');
      if (signInBtn.evaluate().isNotEmpty) {
        await tester.tap(signInBtn.first, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 2));
      }

      // 6. Enter test credentials: 944070484 / 12345678
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length >= 2) {
        await tester.enterText(textFields.at(0), '944070484');
        await pumpRealTime(tester, const Duration(milliseconds: 500));

        await tester.enterText(textFields.at(1), '12345678');
        await pumpRealTime(tester, const Duration(milliseconds: 500));

        FocusManager.instance.primaryFocus?.unfocus();
        await pumpRealTime(tester, const Duration(milliseconds: 600));

        final submitSignIn = find.widgetWithText(ElevatedButton, 'Sign In');
        if (submitSignIn.evaluate().isNotEmpty) {
          await tester.tap(submitSignIn.first, warnIfMissed: false);
        } else {
          final signInText = find.text('Sign In');
          if (signInText.evaluate().isNotEmpty) {
            await tester.tap(signInText.last, warnIfMissed: false);
          }
        }
      }

      // Wait for live backend authentication
      bool loggedIn = false;
      for (int i = 0; i < 40; i++) {
        await Future.delayed(const Duration(milliseconds: 350));
        await tester.pump();
        loggedIn = await AuthService.isUserLoggedIn();
        if (loggedIn && i > 4) {
          break;
        }
      }
      debugPrint('[EthioChef Demo] Login completed: loggedIn=$loggedIn');
      await pumpRealTime(tester, const Duration(seconds: 3));

      // Ensure we are on Profile tab showing the authenticated user
      if (find.text('Profile').evaluate().isNotEmpty &&
          find.text('Delete Account').evaluate().isEmpty) {
        await tester.tap(find.text('Profile').last, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 2));
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
      if (deleteAccountFinder.evaluate().isNotEmpty) {
        await tester.ensureVisible(deleteAccountFinder.last);
        await pumpRealTime(tester, const Duration(seconds: 1));
        await tester.tap(deleteAccountFinder.last, warnIfMissed: false);
        await pumpRealTime(tester, const Duration(seconds: 4));

        // Dismiss confirmation dialog to keep test account active
        final cancelBtn = find.text('Cancel');
        if (cancelBtn.evaluate().isNotEmpty) {
          await tester.tap(cancelBtn.last, warnIfMissed: false);
          await pumpRealTime(tester, const Duration(seconds: 2));
        }
      } else {
        debugPrint('[EthioChef Demo] Delete Account tile was not visible.');
      }

      debugPrint('[EthioChef Demo] Guideline 2.1 demo flow finished.');
    },
  );
}
