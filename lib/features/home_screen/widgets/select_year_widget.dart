import 'package:calendar/features/bloc/main_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectYearWidget extends StatelessWidget {
  const SelectYearWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      height: size.height * 0.35,
      child: CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        use24hFormat: true,
        mode: CupertinoDatePickerMode.monthYear,
        onDateTimeChanged: (value) {
          context.read<MainBloc>().add(UpdateFocusedDay(value));
        },
      ),
    );
  }
}
