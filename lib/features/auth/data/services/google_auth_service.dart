import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  GoogleAuthService({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Prompts Google Sign In, authenticates with Firebase, and returns the Firebase ID token.
  /// Returns `null` if the user cancels the sign-in prompt.
  Future<String?> getFirebaseIdToken() async {
    try {
      // 1. Sign out first to allow account switching if previously signed in
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      // 2. Trigger Google Sign-In dialog
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User aborted the dialog
        debugPrint('ℹ️ [GoogleAuth] Sign-in was cancelled by user');
        return null;
      }

      // 3. Obtain authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Authenticate with Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // 6. Retrieve Firebase ID Token
      final String? idToken = await userCredential.user?.getIdToken();
      debugPrint('✅ [GoogleAuth] Obtained Firebase ID token: ${idToken != null ? "SUCCESS" : "NULL"}');
      return idToken;
    } catch (e, stack) {
      debugPrint('❌ [GoogleAuth] Error during Google Sign-in: $e\n$stack');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('⚠️ [GoogleAuth] Error during sign-out: $e');
    }
  }
}
