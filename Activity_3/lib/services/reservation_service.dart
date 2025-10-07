import '../models/reservation.dart';

class ReservationService {
  static final List<Reservation> _reservations = [];

  static void addReservation(Reservation reservation) {
    _reservations.add(reservation);
  }

  static List<Reservation> getReservations() {
    return _reservations;
  }
}
