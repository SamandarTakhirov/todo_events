import 'package:calendar/constants/app_colors.dart';
import 'package:calendar/core/models/event_model.dart';
import 'package:calendar/core/utils/context_utils.dart';
import 'package:calendar/features/bloc/main_bloc.dart';
import 'package:calendar/router/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EventViewScreen extends StatefulWidget {
  final EventModel eventModel;
  const EventViewScreen({
    required this.eventModel,
    super.key,
  });

  @override
  State<EventViewScreen> createState() => _EventViewScreenState();
}

class _EventViewScreenState extends State<EventViewScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.selectDay,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.white,
              fixedSize: const Size(30, 30),
              shape: const CircleBorder(),
            ),
            onPressed: () {
              context.pop();
            },
            child: const Icon(
              color: AppColors.black,
              CupertinoIcons.chevron_back,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(
                Routes.add,
                extra: widget.eventModel,
              );
            },
            icon: Row(
              children: [
                const Icon(
                  Icons.edit,
                  color: AppColors.white,
                ),
                Text(
                  "Edit",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          if (state.isSucces == true) context.pop();
          if (state.isSucces == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("You not delete"),
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.2,
              width: size.width,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.selectDay,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.eventModel.eventName,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.eventModel.eventInfo,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.clock,
                            color: AppColors.white,
                          ),
                          Text(
                            "${widget.eventModel.eventStartTime!.hour}:${widget.eventModel.eventStartTime!.minute}-${widget.eventModel.eventFinalTime!.hour}:${widget.eventModel.eventFinalTime!.minute}",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.location,
                            color: AppColors.white,
                          ),
                          Text(
                            widget.eventModel.eventLocation ?? "",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                      // : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${widget.eventModel.eventInfo}\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vel ex sit amet neque dignissim mattis non eu est. Etiam pulvinar est mi, et porta magna accumsan nec. Ut vitae urna nisl. Integer gravida sollicitudin massa, ut congue orci posuere sit amet. Aenean laoreet egestas est, ut auctor nulla suscipit non. ",
                    style: context.textTheme.bodyMedium?.copyWith(),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.35),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 174, 169),
                  fixedSize: Size(size.width, 60),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onPressed: () {
                  context.read<MainBloc>().add(DeleteEvent(
                        widget.eventModel.id!,
                        widget.eventModel.convertDate,
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.delete,
                      color: AppColors.red,
                    ),
                    Text(
                      "Delete Event",
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
