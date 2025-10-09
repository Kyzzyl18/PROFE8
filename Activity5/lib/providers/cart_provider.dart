import 'package:flutter/material.dart';
import '../models/reservation.dart';

class CartProvider extends ChangeNotifier {
  final List<Reservation> _reservations = [];
  final List<Reservation> _pendingReservations = [];

  List<Reservation> get reservations => _reservations;
  List<Reservation> get pendingReservations => _pendingReservations;

  void addPendingReservation(Reservation reservation) {
    _pendingReservations.add(reservation);
    notifyListeners();
  }

  void confirmReservation(Reservation reservation) {
    _pendingReservations.remove(reservation);
    _reservations.add(reservation.copyWith(paid: true));
    notifyListeners();
  }

  void removePendingReservation(Reservation reservation) {
    _pendingReservations.remove(reservation);
    notifyListeners();
  }
}
