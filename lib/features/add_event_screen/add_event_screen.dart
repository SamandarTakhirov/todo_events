import 'package:calendar/core/extensions/date_formatter.dart';
import 'package:calendar/core/models/event_model.dart';
import 'package:calendar/core/utils/context_utils.dart';
import 'package:calendar/features/bloc/main_bloc.dart';
import 'package:calendar/router/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import 'widgets/text_input.dart';

class AddEventScreen extends StatefulWidget {
  final EventModel? eventModel;
  const AddEventScreen({
    this.eventModel,
    super.key,
  });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late final TextEditingController eventNameController;
  late final TextEditingController eventInfoController;
  late final TextEditingController eventLocationController;
  final ValueNotifier<int> colorCode = ValueNotifier<int>(0);

  late DateTime startTime;
  late DateTime endTime;

  String getColor(int index) {
    if (index < 0 || index >= Colors.primaries.length) {
      throw ArgumentError('Index out of range for Colors.primaries');
    }
    Color color = Colors.primaries[index];
    String hexColor =
        '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    return hexColor;
  }

  String dateFormat({required String formatCode, required DateTime dateTime}) {
    return DateFormat(formatCode).format(dateTime).toString();
  }

  bool checkInfo(
    String eventNameController,
    String eventInfoController,
    DateTime? startTime,
    DateTime? endTime,
  ) {
    return eventNameController != "" &&
        eventInfoController != "" &&
        startTime != null &&
        endTime != null;
  }

  @override
  void initState() {
    eventNameController =
        TextEditingController(text: widget.eventModel?.eventName);
    eventInfoController =
        TextEditingController(text: widget.eventModel?.eventInfo);
    eventLocationController =
        TextEditingController(text: widget.eventModel?.eventLocation);
    startTime = widget.eventModel?.eventStartTime ?? DateTime.now();
    endTime = widget.eventModel?.eventFinalTime ?? DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    eventInfoController.dispose();
    eventLocationController.dispose();
    eventNameController.dispose();
    super.dispose();
  }

  void addEvent(MainState state) {
    checkInfo(
      eventNameController.text,
      eventInfoController.text,
      startTime,
      endTime,
    )
        ? context.read<MainBloc>().add(
              AddEvent(
                EventModel(
                  eventFinalTime: endTime,
                  eventStartTime: startTime,
                  color: getColor(colorCode.value),
                  eventInfo: eventInfoController.text,
                  eventLocation: eventLocationController.text,
                  eventName: eventNameController.text,
                  createdAt: state.dateTime == null
                      ? DateTime.now().dateFormat()
                      : state.dateTime!.dateFormat(),
                ),
                state.dateTime == null ? DateTime.now() : state.dateTime!,
              ),
            )
        : false;

    context.pop();
  }

  void updateEvent(MainState state) {
    checkInfo(
      eventNameController.text,
      eventInfoController.text,
      startTime,
      endTime,
    )
        ? context.read<MainBloc>().add(
              UpdateEvent(
                  widget.eventModel!.copyWith(
                    eventFinalTime: endTime,
                    eventStartTime: startTime,
                    color: getColor(colorCode.value),
                    eventInfo: eventInfoController.text,
                    eventLocation: eventLocationController.text,
                    eventName: eventNameController.text,
                    createdAt: state.dateTime?.dateFormat(),
                  ),
                  state.dateTime!),
            )
        : false;

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            leading: IconButton(
              onPressed: () => context.pushReplacementNamed(Routes.home),
              icon: const Icon(CupertinoIcons.back),
            ),
            centerTitle: true,
            title: Text(
              dateFormat(
                  formatCode: "dd.MM.yyyy",
                  dateTime: DateTime(
                    state.dateTime?.year ?? DateTime.now().year,
                    state.dateTime?.month ?? DateTime.now().month,
                    state.dateTime?.day ?? DateTime.now().day,
                  )),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: [
                TextInput(
                  textEditingController: eventNameController,
                  size: 60,
                  inputName: "Event name",
                ),
                TextInput(
                  maxLines: 10,
                  textInputAction: TextInputAction.newline,
                  textEditingController: eventInfoController,
                  size: size.height * 0.2,
                  inputName: "Event description",
                ),
                TextInput(
                  textEditingController: eventLocationController,
                  size: 60,
                  inputName: "Event location",
                ),
                Text(
                  "Priority color",
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.065,
                  width: size.width,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.inputColor,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        controller: ScrollController(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.1,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: GestureDetector(
                                onTap: () {
                                  colorCode.value = index;
                                },
                                child: ValueListenableBuilder<int>(
                                    valueListenable: colorCode,
                                    builder: (context, value, child) {
                                      return ColoredBox(
                                        color: AppColors.black,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            value == index ? 2.0 : 0,
                                          ),
                                          child: ColoredBox(
                                            color: Colors.primaries[index],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemCount: Colors.primaries.length,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Event Time",
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Start Time",
                            style: context.textTheme.bodyMedium,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: size.width * 0.3,
                              child: CupertinoDatePicker(
                                initialDateTime: startTime,
                                use24hFormat: true,
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (value) {
                                  startTime = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "End Time",
                            style: context.textTheme.bodyMedium,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: size.width * 0.3,
                              child: CupertinoDatePicker(
                                use24hFormat: true,
                                initialDateTime: endTime,
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (value) {
                                  endTime = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.selectDay,
                      fixedSize: Size(size.width, 60),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onPressed: () {
                      if (widget.eventModel != null) {
                        updateEvent(state);
                      } else {
                        addEvent(state);
                      }
                    },
                    child: Text(
                      widget.eventModel == null ? "Add" : "Update",
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
