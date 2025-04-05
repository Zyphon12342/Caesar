import 'package:mongo_dart/mongo_dart.dart';
import '../config/mongodb_config.dart';

class MongoDBService {
  static final MongoDBService _instance = MongoDBService._internal();
  factory MongoDBService() => _instance;
  MongoDBService._internal();

  late Db _db;
  late DbCollection _usersCollection;

  Future<void> initialize() async {
    try {
      _db = await Db.create(MongoDBConfig.mongoDbUrl);
      await _db.open();
      _usersCollection = _db.collection(MongoDBConfig.usersCollection);
      print('MongoDB initialized successfully');
    } catch (e) {
      print('Error initializing MongoDB: $e');
      rethrow;
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      final user = await _usersCollection.findOne(where.eq('email', email));
      return user != null;
    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      await _usersCollection.insert(userData);
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      return await _usersCollection.findOne(where.eq('id', userId));
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _usersCollection.update(
        where.eq('id', userId),
        {'\$set': updates},
      );
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.remove(where.eq('id', userId));
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      await _db.close();
    } catch (e) {
      print('Error closing MongoDB connection: $e');
    }
  }
} 