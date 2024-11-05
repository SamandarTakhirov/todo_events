part of 'main_bloc.dart';

class MainState extends Equatable {
  final DateTime? dateTime;
  final List<EventModel> eventModels;
  final bool isLoading;
  final bool? isSucces;
  final DateTime focusedDay;

  const MainState({
    required this.focusedDay,
    this.dateTime,
    this.eventModels = const [],
    this.isLoading = false,
    this.isSucces,
  });

  @override
  List<Object?> get props => [
        dateTime,
        eventModels,
        isLoading,
        isSucces,
        focusedDay,
      ];

  MainState copyWith({
    List<EventModel>? eventModels,
    DateTime? dateTime,
    bool? isLoading,
    ValueGetter<bool?>? isSucces,
    DateTime? focusedDay,
  }) {
    return MainState(
      dateTime: dateTime ?? this.dateTime,
      eventModels: eventModels ?? this.eventModels,
      isLoading: isLoading ?? this.isLoading,
      isSucces: isSucces != null ? isSucces() : this.isSucces,
      focusedDay: focusedDay ?? this.focusedDay,
    );
  }
}
