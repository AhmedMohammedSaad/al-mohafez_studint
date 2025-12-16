abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? avatarUrl;

  UpdateProfileEvent({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.avatarUrl,
  });
}

class UpdatePasswordEvent extends ProfileEvent {
  final String newPassword;

  UpdatePasswordEvent(this.newPassword);
}

class LogoutEvent extends ProfileEvent {}

class DeleteAccountEvent extends ProfileEvent {}
