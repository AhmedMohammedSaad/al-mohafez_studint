import '../data/models/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingCreated extends BookingState {
  final String bookingId;

  BookingCreated(this.bookingId);
}

class BookingLoaded extends BookingState {
  final BookingModel booking;

  BookingLoaded(this.booking);
}

class BookingsListLoaded extends BookingState {
  final List<BookingModel> bookings;

  BookingsListLoaded(this.bookings);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}

class BookingCancelled extends BookingState {}
