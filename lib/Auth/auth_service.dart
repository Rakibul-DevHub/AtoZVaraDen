import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'auth_screen.dart';

/// Centralized authentication service that seamlessly bridges Firebase Authentication
/// with offline/local fallback state without throwing runtime errors when Firebase
/// is not initialized or configured.
class AuthService {
  /// Checks safely if Firebase has been initialized.
  static bool get isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Gets the current Firebase user safely, or returns null if Firebase is not active.
  static User? get currentFirebaseUser {
    if (!isFirebaseAvailable) return null;
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (_) {
      return null;
    }
  }

  /// Returns true if either a Firebase session exists or local demo state is logged in.
  static bool get isLoggedIn {
    return currentFirebaseUser != null || LocalAuthState().isLoggedIn;
  }

  /// Gets active user ID (Firebase UID or fallback local UID).
  static String get currentUserId {
    return currentFirebaseUser?.uid ?? LocalAuthState().uid;
  }

  /// Gets active user display name.
  static String get currentUsername {
    if (currentFirebaseUser?.displayName != null &&
        currentFirebaseUser!.displayName!.trim().isNotEmpty) {
      return currentFirebaseUser!.displayName!;
    }
    if (isLoggedIn) {
      return LocalAuthState().username;
    }
    return 'Guest User';
  }

  /// Gets active user email address.
  static String get currentUserEmail {
    if (currentFirebaseUser?.email != null &&
        currentFirebaseUser!.email!.trim().isNotEmpty) {
      return currentFirebaseUser!.email!;
    }
    if (isLoggedIn) {
      return LocalAuthState().email;
    }
    return 'Sign in to access your account';
  }

  /// Safe sign out across both Firebase and local state.
  static Future<void> signOut() async {
    if (isFirebaseAvailable) {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        debugPrint('Firebase sign out notice: $e');
      }
    }
    LocalAuthState().isLoggedIn = false;
  }
}
