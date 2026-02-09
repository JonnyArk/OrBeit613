/// OrBeit Services - Auth Service Interface
///
/// Defines the contract for authentication operations.
/// Supports anonymous sign-in (MVP) with hooks for
/// email/password and provider-based auth later.
///
/// **Sovereign OS Context:**
/// Authentication is the "key to the gate" — without it,
/// no building can be placed and no data leaves the device.

/// Auth state representation
class AuthState {
  /// Firebase UID
  final String uid;

  /// Whether the user is signed in anonymously
  final bool isAnonymous;

  /// User email (null for anonymous users)
  final String? email;

  /// Display name (null for anonymous users)
  final String? displayName;

  const AuthState({
    required this.uid,
    required this.isAnonymous,
    this.email,
    this.displayName,
  });

  @override
  String toString() => 'AuthState(uid: $uid, anon: $isAnonymous)';
}

/// Abstract interface for authentication
abstract class AuthService {
  /// Returns the current auth state, or null if not signed in
  AuthState? get currentUser;

  /// Stream of auth state changes
  Stream<AuthState?> get authStateChanges;

  /// Signs in anonymously (creates a temporary account)
  /// This is the MVP flow — no UI needed
  Future<AuthState> signInAnonymously();

  /// Signs in with email and password (future use)
  Future<AuthState> signInWithEmail(String email, String password);

  /// Creates a new account with email and password (future use)
  Future<AuthState> createAccount(String email, String password);

  /// Signs out the current user
  Future<void> signOut();

  /// Gets the current user's ID token for API calls
  /// Returns null if not signed in
  Future<String?> getIdToken({bool forceRefresh = false});

  /// Checks if the user is currently authenticated
  bool get isAuthenticated;
}
