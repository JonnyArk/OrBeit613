/// OrBeit Services - Auth Service Implementation
///
/// Firebase Authentication implementation.
/// MVP: Anonymous sign-in on app launch (silent, no UI).
/// Future: Email/password, provider-based auth.
///
/// **Security Model:**
/// - Anonymous auth tied to Firebase UID
/// - UID used as Firestore document path key
/// - ID token attached to Cloud Function calls
/// - Auto-refresh handled by Firebase SDK

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';

/// Firebase-backed authentication service
class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth;

  AuthServiceImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  AuthState? get currentUser {
    final user = _auth.currentUser;
    return user != null ? _toAuthState(user) : null;
  }

  @override
  Stream<AuthState?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      return user != null ? _toAuthState(user) : null;
    });
  }

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  Future<AuthState> signInAnonymously() async {
    try {
      // Check if already signed in
      if (_auth.currentUser != null) {
        debugPrint('[Auth] Already signed in: ${_auth.currentUser!.uid}');
        return _toAuthState(_auth.currentUser!);
      }

      debugPrint('[Auth] Signing in anonymously...');
      final credential = await _auth.signInAnonymously();
      final user = credential.user;

      if (user == null) {
        throw Exception('Anonymous sign-in returned null user');
      }

      debugPrint('[Auth] Anonymous sign-in successful: ${user.uid}');
      return _toAuthState(user);
    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] Firebase Auth error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('[Auth] Unexpected auth error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthState> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;

      if (user == null) {
        throw Exception('Email sign-in returned null user');
      }

      debugPrint('[Auth] Email sign-in successful: ${user.uid}');
      return _toAuthState(user);
    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] Email sign-in error: ${e.code}');
      rethrow;
    }
  }

  @override
  Future<AuthState> createAccount(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;

      if (user == null) {
        throw Exception('Account creation returned null user');
      }

      debugPrint('[Auth] Account created: ${user.uid}');
      return _toAuthState(user);
    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] Account creation error: ${e.code}');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    debugPrint('[Auth] Signing out...');
    await _auth.signOut();
    debugPrint('[Auth] Sign out complete');
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      return await user.getIdToken(forceRefresh);
    } catch (e) {
      debugPrint('[Auth] Error getting ID token: $e');
      return null;
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  AuthState _toAuthState(User user) {
    return AuthState(
      uid: user.uid,
      isAnonymous: user.isAnonymous,
      email: user.email,
      displayName: user.displayName,
    );
  }
}
