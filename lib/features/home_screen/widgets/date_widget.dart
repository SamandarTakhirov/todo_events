import 'package:calendar/core/utils/context_utils.dart';
import 'package:calendar/features/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../core/models/event_model.dart';

class DateWidget extends StatefulWidget {
  final DateTime dateTime;
  final bool isSelected;
  const DateWidget({
    required this.dateTime,
    required this.isSelected,
    super.key,
  });

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  void initState() {
    context.read<MainBloc>().add(GetEventsByDate(
          dateTime: widget.dateTime,
        ));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    context.read<MainBloc>().add(GetEventsByDate(
          dateTime: widget.dateTime,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${widget.dateTime.day}',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: widget.isSelected ? AppColors.white : AppColors.black,
          ),
        ),
        BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return SizedBox(
              height: 3,
              width: 12,
              child: EventIndecator(
                events: state.eventModels,
              ),
            );
          },
        ),
      ],
    );
  }
}

class EventIndecator extends StatelessWidget {
  final List<EventModel> events;

  const EventIndecator({
    required this.events,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: events
          .take(3)
          .map((e) => Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: e.convertColor,
                ),
              ))
          .toList(),
    );
  }
}
