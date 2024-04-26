import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/Dashboared/models/petrol_price.dart';

class FuelPricesesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<String?> getCurrentUserUID() async {
    return _authService.getCurrentUserUID();
  }

  Future<void> savePriceData(String type, PetrolPrice priceData) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        await _firestore
            .collection('users')
            .doc('Owner')
            .collection('Owner')
            .doc(uid)
            .collection('fuel_prices')
            .add({
          'type': type,
          'date': priceData.date,
          'price': priceData.price,
        });
      } else {
        throw Exception('User is not logged in!');
      }
    } catch (e) {
      print("Error adding fuel price: $e");
      rethrow;
    }
  }

  Future<PetrolPrice?> getLastAddedPetrolPrice() async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid == null) {
        throw Exception('User is not logged in!');
      }

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc('Owner')
          .collection('Owner')
          .doc(uid)
          .collection('fuel_prices')
          .where('type', isEqualTo: 'petrol')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      var doc = snapshot.docs.first;
      var date = (doc['date'] as Timestamp).toDate();
      var price = (doc['price'] as double);
      print(date);
      print(price);

      return PetrolPrice(date, price);
    } catch (e) {
      print("Error fetching last petrol price: $e");
      rethrow;
    }
  }

  // Function to fetch the last added diesel price from Firestore
  Future<PetrolPrice?> getLastAddedDieselPrice() async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid == null) {
        throw Exception('User is not logged in!');
      }
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc('Owner')
          .collection('Owner')
          .doc(uid)
          .collection('fuel_prices')
          .where('type', isEqualTo: 'diesel')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      var doc = snapshot.docs.first;
      var date = (doc['date'] as Timestamp).toDate();
      var price = (doc['price'] as double);

      return PetrolPrice(date, price);
    } catch (e) {
      print("Error fetching last added diesel price: $e");
      rethrow;
    }
  }
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> getCurrentUserUID() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid;
  }
}
