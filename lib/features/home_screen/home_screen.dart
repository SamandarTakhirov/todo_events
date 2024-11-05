import 'package:calendar/core/models/event_model.dart';
import 'package:calendar/core/utils/context_utils.dart';
import 'package:calendar/features/bloc/main_bloc.dart';
import 'package:calendar/router/app_routes.dart';
import 'package:calendar/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import 'widgets/date_widget.dart';
import 'widgets/event_widget.dart';
import 'widgets/select_year_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  int startingEmptyDays(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday;
  }

  void _previousMonth() {
    context.read<MainBloc>().add(PreviousMonth());
  }

  void _nextMonth() {
    context.read<MainBloc>().add(NextMonth());
  }

  String dateFormat({required String formatCode, required DateTime dateTime}) {
    return DateFormat(formatCode).format(dateTime).toString();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        toolbarHeight: size.height * 0.09,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return const SelectYearWidget();
                  },
                );
              },
              child: Column(
                children: [
                  Text(
                    dateFormat(
                      dateTime: DateTime(state.focusedDay.weekday),
                      formatCode: 'EEEE',
                    ),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dateFormat(
                          dateTime: DateTime(state.focusedDay.year),
                          formatCode: 'yyyy',
                        ),
                        style: context.textTheme.titleMedium,
                      ),
                      Icon(
                        size: size.height * 0.02,
                        CupertinoIcons.chevron_down,
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            int daysInCurrentMonth = daysInMonth(state.focusedDay);
            int emptyStartDays = startingEmptyDays(state.focusedDay);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat(
                        formatCode: 'MMMM',
                        dateTime: DateTime(
                            state.focusedDay.year, state.focusedDay.month),
                      ),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.gray,
                          ),
                          onPressed: _previousMonth,
                          icon: const Icon(CupertinoIcons.chevron_back),
                        ),
                        IconButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.gray,
                          ),
                          onPressed: _nextMonth,
                          icon: const Icon(CupertinoIcons.chevron_right),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((day) => Text(
                            day,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.weekColor,
                            ),
                          ))
                      .toList(),
                ),
                Expanded(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                    ),
                    itemCount: daysInCurrentMonth + emptyStartDays,
                    itemBuilder: (context, index) {
                      if (index < emptyStartDays) {
                        return const SizedBox.shrink();
                      } else {
                        int day = index - emptyStartDays + 1;
                        DateTime currentDay = DateTime(
                            state.focusedDay.year, state.focusedDay.month, day);
                        bool isToday = currentDay.year == DateTime.now().year &&
                            currentDay.month == DateTime.now().month &&
                            currentDay.day == DateTime.now().day;
                        return GestureDetector(
                          onTap: () {
                            context.read<MainBloc>().add(
                                  GetEventsByDate(dateTime: currentDay),
                                );
                          },
                          child: BlocBuilder<MainBloc, MainState>(
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? AppColors.weekColor
                                        : state.dateTime == currentDay
                                            ? AppColors.selectDay
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: BlocProvider(
                                      create: (context) =>
                                          MainBloc(DatabaseService.instance),
                                      child: DateWidget(
                                        dateTime: currentDay,
                                        isSelected:
                                            state.dateTime == currentDay,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Schedule",
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.appColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          )),
                      onPressed: () => context.pushNamed(Routes.add),
                      child: const Text("+ Add Event"),
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<MainBloc, MainState>(
                    builder: (context, state) {
                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                        controller: ScrollController(),
                        itemCount: state.eventModels.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: size.height * 0.01,
                        ),
                        itemBuilder: (context, index) {
                          final EventModel event = state.eventModels[index];
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                Routes.eventView,
                                extra: state.eventModels[index],
                              );
                            },
                            child: EventWidget(
                              color: event.convertColor,
                              deadline: event.eventFinalTime,
                              startTime: event.eventStartTime,
                              eventDescription: event.eventInfo,
                              eventName: event.eventName,
                              location: event.eventLocation,
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
