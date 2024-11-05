import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calendar/core/models/event_model.dart';
import 'package:calendar/services/database_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final DatabaseService database;

  MainBloc(this.database) : super(MainState(focusedDay: DateTime.now())) {
    on<MainEvent>(
      (event, emit) => switch (event) {
        GetEventsByDate e => _getEventsByDate(e, emit),
        GetAllEvents e => _getAllEvents(e, emit),
        AddEvent e => _addEvent(e, emit),
        UpdateEvent e => _updateEvent(e, emit),
        DeleteEvent e => _deleteEvent(e, emit),
        NextMonth e => _nextMonth(e, emit),
        PreviousMonth e => _previousMonth(e, emit),
        UpdateFocusedDay e => _updateFocusedDay(e, emit),
        _ => null,
      },
    );
  }

  Future<void> _getEventsByDate(
      GetEventsByDate event, Emitter<MainState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      isSucces: () => null,
    ));

    try {
      final List<EventModel> events =
          await database.getEventsByDate(event.dateTime);
      emit(state.copyWith(
        dateTime: event.dateTime,
        eventModels: events,
        isLoading: false,
        isSucces: () => true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSucces: () => false,
      ));
    }

    emit(state.copyWith(
      isSucces: () => null,
    ));
  }

  Future<void> _getAllEvents(
      GetAllEvents event, Emitter<MainState> emit) async {
    emit(state.copyWith(
      isLoading: true,
    ));
    try {
      final List<EventModel> events = await database.getAllEvents();

      emit(state.copyWith(
        dateTime: DateTime.now(),
        eventModels: events,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _addEvent(AddEvent event, Emitter<MainState> emit) async {
    try {
      await database.addNewEvent(event.event);
      add(GetEventsByDate(
        dateTime: event.dateTime,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _updateEvent(UpdateEvent event, Emitter<MainState> emit) async {
    try {
      await database.updateEvent(event.event);
      add(GetEventsByDate(
        dateTime: event.dateTime,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _deleteEvent(DeleteEvent event, Emitter<MainState> emit) async {
    try {
      await database.delateEvent(event.id);
      add(GetEventsByDate(
        dateTime: event.dateTime,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  FutureOr<void> _nextMonth(NextMonth event, Emitter<MainState> emit) {
    final date = state.focusedDay;
    emit(state.copyWith(focusedDay: DateTime(date.year, date.month + 1)));
  }

  FutureOr<void> _previousMonth(PreviousMonth event, Emitter<MainState> emit) {
    final date = state.focusedDay;
    emit(state.copyWith(focusedDay: DateTime(date.year, date.month - 1)));
  }

  void _updateFocusedDay(UpdateFocusedDay event, Emitter<MainState> emit) {
    emit(state.copyWith(focusedDay: event.focusedDay));
  }
}
