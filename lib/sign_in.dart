import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

GoogleSignInAccount googleSignInAccount;
String name;
String email;
String imageUrl;
bool isSignedIn = false;
bool canEdit = false;
bool canGetList = false;
bool canLive = false;
bool canScan = false;
bool canNotify = false;

Future<String> signInWithGoogle() async {
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

    print(user.email + " trying to access");

    QuerySnapshot qs = await Firestore.instance
        .collection('extra_access_users')
        .where('email_id', isEqualTo: user.email)
        .getDocuments();
    if (qs.documents.length != 0) {
      print("User found as extra_access_user");
      canEdit = qs.documents[0].data['can_edit'];
      canGetList = qs.documents[0].data['can_get_list'];
      canLive = qs.documents[0].data['can_live'];
      canScan = qs.documents[0].data['can_scan'];
      canNotify = qs.documents[0].data['can_notify'];
      isSignedIn = true;
    } else {
      signOutGoogle();
      return 'signInWithGoogle failed';
    }

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

    firebaseMessaging.subscribeToTopic('notifications');
    print("Succeded sign in");
    return 'signInWithGoogle succeeded: $user';
  }
  print("Signing out because sign in failed, no account found");
  await googleSignIn.signOut();
  return 'signInWithGoogle failed';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Sign Out");
  isSignedIn = false;
}
