import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/bookings_repo.dart';
import '../data/models/booking_request_model.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingsRepo _bookingsRepo;

  BookingCubit(this._bookingsRepo) : super(BookingInitial());

  Future<void> createBooking(BookingRequestModel request) async {
    emit(BookingLoading());
    try {
      final bookingId = await _bookingsRepo.createBooking(request);
      emit(BookingCreated(bookingId));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> getBookingById(String id) async {
    emit(BookingLoading());
    try {
      final booking = await _bookingsRepo.getBookingById(id);
      emit(BookingLoaded(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> getStudentBookings(String studentId) async {
    emit(BookingLoading());
    try {
      final bookings = await _bookingsRepo.getStudentBookings(studentId);
      emit(BookingsListLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    emit(BookingLoading());
    try {
      await _bookingsRepo.cancelBooking(bookingId);
      emit(BookingCancelled());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
