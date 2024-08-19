import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_clone/core/common/errors/exception.dart';
import 'package:spotify_clone/features/auth/data/model/user_model.dart';

abstract interface class AuthDatasource {
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> userSignIn({
    required String email,
    required String password,
  });
}

class AuthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw ServerException('Registration timed out');
        },
      );

      if (response.user == null) {
        throw ServerException('Registration failed: user is null!');
      }

      await fireStore.collection('Users').doc(response.user!.uid).set(
        {
          'userName': name,
          'email': response.user!.email,
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw ServerException('Firestore write timed out');
        },
      );
      // To check if user data is added to firesore or not!!!
      print('User added to Firestore');
      return UserModel.fromJson({
        'uid': response.user!.uid,
        'name': name,
        'email': response.user!.email,
      });
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'weak-password':
          msg = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          msg = 'An account already exists with that email.';
          break;
        case 'invalid-email':
          msg = 'The email address is invalid.';
          break;
        default:
          msg = 'Registration failed: ${e.message}';
      }
      print('FirebaseAuthException during registration: $msg');
      throw ServerException(msg);
    } catch (e) {
      print('Unexpected error during registration: ${e.toString()}');
      throw ServerException(
          'An unexpected error occurred during registration: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> userSignIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw ServerException('Sign-in timed out');
        },
      );

      if (response.user == null) {
        throw ServerException('Sign-in failed: User is null.');
      }

      final userDoc = await fireStore
          .collection('Users')
          .doc(response.user!.uid)
          .get()
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw ServerException('Firestore read timed out');
      });

      if (!userDoc.exists) {
        throw ServerException('User data not found in database!');
      }

      final userData = userDoc.data()!;
      print('User data retrieved from Firestore: ${userData['email']}');

      return UserModel.fromJson({
        'uid': response.user!.uid,
        'name': userData['userName'],
        'email': userData['email'],
      });
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'wrong-password':
          msg = 'Incorrect password provided.';
          break;
        case 'user-not-found':
          msg = 'No user found with that email.';
          break;
        case 'invalid-email':
          msg = 'The email address is invalid.';
          break;
        default:
          msg = 'Sign-in failed: ${e.message}';
      }
      print('FirebaseAuthException during sign-in: $msg');
      throw ServerException(msg);
    } catch (e) {
      print('Unexpected error during sign-in: ${e.toString()}');
      throw ServerException(
          'An unexpected error occurred during sign-in: ${e.toString()}');
    }
  }
}
