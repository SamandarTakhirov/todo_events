import 'package:calendar/core/utils/context_utils.dart';
import 'package:flutter/cupertino.dart';

class EventWidget extends StatelessWidget {
  final String eventName;
  final String eventDescription;
  final DateTime? startTime;
  final DateTime? deadline;
  final String? location;
  final Color color;

  const EventWidget({
    required this.eventName,
    required this.eventDescription,
    required this.color,
    required this.startTime,
    required this.deadline,
    this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        SizedBox(
          width: size.width,
          height: size.height * 0.015,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width,
          height: size.width * 0.3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventName,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      Text(
                        eventDescription,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.clock,
                            color: color,
                          ),
                          Text(
                            "${startTime!.hour}:${startTime!.minute}-${deadline!.hour}:${deadline!.minute}",
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      location != null
                          ? Row(
                              children: [
                                Icon(
                                  CupertinoIcons.location,
                                  color: color,
                                ),
                                Text(
                                  location!,
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
