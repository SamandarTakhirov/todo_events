part of 'main_bloc.dart';

sealed class MainEvent {
  const MainEvent();
}

class GetEventsByDate extends MainEvent {
  final DateTime dateTime;

  const GetEventsByDate({
    required this.dateTime,
  });
}

class GetAllEvents extends MainEvent {}

class AddEvent extends MainEvent {
  final EventModel event;
  final DateTime dateTime;

  const AddEvent(
    this.event,
    this.dateTime,
  );
}

class UpdateFocusedDay extends MainEvent {
  final DateTime focusedDay;

  UpdateFocusedDay(this.focusedDay);
}

class UpdateEvent extends MainEvent {
  final EventModel event;
  final DateTime dateTime;
  const UpdateEvent(
    this.event,
    this.dateTime,
  );
}

class DeleteEvent extends MainEvent {
  final int id;
  final DateTime dateTime;

  const DeleteEvent(
    this.id,
    this.dateTime,
  );
}

class NextMonth extends MainEvent {}

class PreviousMonth extends MainEvent {}
