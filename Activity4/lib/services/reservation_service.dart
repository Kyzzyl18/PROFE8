import '../models/reservation.dart';
import '../models/user.dart';

class ReservationService {
  static final List<Reservation> _reservations = [];
  static final List<User> _users = [];

  static List<Reservation> getReservations() {
    return _reservations;
  }

  static void addReservation(Reservation reservation) {
    _reservations.add(reservation);
  }

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
