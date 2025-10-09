import '../models/user.dart';

class ReservationService {
  static final List<User> _users = [];

  static void addUser(User user) {
    _users.add(user);
  }

  static User? validateUser(String email, String password) {
    try {
      return _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
