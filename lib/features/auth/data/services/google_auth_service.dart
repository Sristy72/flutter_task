import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  GoogleAuthService({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Prompts Google Sign-In, authenticates with Firebase, and returns the
  /// Firebase ID token via user.getIdToken().
  /// Returns `null` if the user cancels the sign-in prompt.
  /// NOTE: Firebase ID tokens expire after 1 hour — always call this right
  /// before sending to the backend, never cache the result.
  Future<String?> getFirebaseIdToken() async {
    try {
      // 1. Sign out first to allow account switching
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      // 2. Trigger Google Sign-In dialog
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      // 3. Obtain Google OAuth credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Build Firebase credential from Google OAuth tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Authenticate with Firebase using the credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // 6. Get the Firebase ID token — this is the token sent to the backend.
      //    Never use googleAuth.idToken here; the backend requires a Firebase ID token.
      final String? idToken =
          await userCredential.user?.getIdToken(true); // forceRefresh=true

      if (idToken == null) {
        throw Exception('Failed to obtain Firebase ID token from user.');
      }

      return idToken;
    } catch (e, stack) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (_) {}
  }
}
