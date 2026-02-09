/// OrBeit Providers - Auth Provider
///
/// Riverpod providers for authentication state.
/// Provides reactive access to the current auth state
/// and the auth service instance.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/auth_service_impl.dart';

/// Auth service provider
/// Override in ProviderScope if custom instance is needed
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceImpl();
});

/// Current auth state stream
final authStateProvider = StreamProvider<AuthState?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Current user (synchronous, can be null)
final currentUserProvider = Provider<AuthState?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

/// Whether the user is currently authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isAuthenticated;
});
