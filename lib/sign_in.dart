import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
bool isSignedIn = false;
GoogleSignInAccount googleSignInAccount;

Future<String> signInWithGoogle() async {
  //await googleSignIn.signOut();
  googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    name = user.displayName;
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }
    email = user.email;
    imageUrl = user.photoUrl;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    isSignedIn = true;
    firebaseMessaging.subscribeToTopic('notifications');
    return 'signInWithGoogle succeeded: $user';
  }
  return 'signInWithGoogle failed';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Sign Out");
  isSignedIn = false;
}
