import 'dart:ui';

import 'package:calendar/core/extensions/date_formatter.dart';

class EventModel {
  final int? id;
  final String? createdAt;
  final String color;
  final String eventName;
  final String eventInfo;
  final DateTime? eventStartTime;
  final DateTime? eventFinalTime;
  final String? eventLocation;

  const EventModel({
    this.id,
    this.createdAt,
    this.color = "",
    this.eventFinalTime,
    this.eventStartTime,
    this.eventInfo = "",
    this.eventName = "",
    this.eventLocation,
  });

  Map<String, Object?> toJson() {
    return {
      if (id != null) 'id': id,
      'createdAt': createdAt ?? DateTime.now().dateFormat(),
      'eventFinalTime': eventFinalTime?.toIso8601String(),
      'eventStartTime': eventStartTime?.toIso8601String(),
      'color': color,
      'eventInfo': eventInfo,
      'eventLocation': eventLocation,
      'eventName': eventName,
    };
  }

  factory EventModel.fromJson(Map<String, Object?> json) {
    return EventModel(
      id: json['id'] as int,
      createdAt: json['createdAt'] as String,
      eventFinalTime: json['eventFinalTime'] != null
          ? DateTime.parse(json['eventFinalTime'] as String)
          : null,
      eventStartTime: json['eventStartTime'] != null
          ? DateTime.parse(json['eventStartTime'] as String)
          : null,
      eventInfo: json['eventInfo'] as String,
      eventName: json['eventName'] as String,
      eventLocation: json['eventLocation'] as String,
      color: json['color'] as String,
    );
  }

  Color get convertColor => Color(int.parse(color));

  DateTime get convertDate => DateTime.parse(createdAt!);

  EventModel copyWith({
    int? id,
    String? createdAt,
    String? color,
    String? eventName,
    String? eventInfo,
    DateTime? eventStartTime,
    DateTime? eventFinalTime,
    String? eventLocation,
  }) {
    return EventModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      eventName: eventName ?? this.eventName,
      eventInfo: eventInfo ?? this.eventInfo,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventFinalTime: eventFinalTime ?? this.eventFinalTime,
      eventLocation: eventLocation ?? this.eventLocation,
    );
  }
}
