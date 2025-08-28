import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';

class SelectDateField extends StatefulWidget {
  final bool isRange; // To determine whether to select a time range or single time.
  final bool isDatePicker; // New parameter to determine whether to pick a date or time.
  final String? nameFiled;
  const SelectDateField({super.key, this.isRange = false, this.isDatePicker = false, this.nameFiled}); // Default to time picker.

  @override
  State<SelectDateField> createState() => _SelectDateFieldState();
}

class _SelectDateFieldState extends State<SelectDateField> {
  String? startTime = '';
  String? endTime = '';
  String? selectedDate = ''; // For the date selection

  // Method to select a single time
  Future<void> selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarycolor,
              onSurface: Colors.black,
              secondary: AppColors.primarycolor,
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        startTime = picked.format(context);
      });
    }
  }

  // Method to select a time range (start and end times)
  Future<void> selectTimeRange() async {
    TimeOfDay? pickedStart = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarycolor,
              onSurface: Colors.black,
              secondary: AppColors.primarycolor,
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;

    if (pickedStart != null) {
      TimeOfDay? pickedEnd = await showTimePicker(
        context: context,
        initialTime: pickedStart,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primarycolor,
                onSurface: Colors.black,
                secondary: AppColors.primarycolor,
              ),
              buttonTheme: const ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Colors.black,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (!mounted) return;

      if (pickedEnd != null) {
        setState(() {
          startTime = pickedStart.format(context);
          endTime = pickedEnd.format(context);
        });
      }
    }
  }

  // Method to pick a date
  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarycolor,
              onSurface: Colors.black,
              secondary: AppColors.primarycolor,
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;

    if (pickedDate != null) {
      setState(() {
        // Format the date into Arabic (or locale-specific format)
        selectedDate = DateFormat.yMMMMd('ar').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.nameFiled != null)
          Text(
            '${widget.nameFiled}',
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
        if (widget.nameFiled != null)
          const SizedBox(
            height: 10,
          ),
        GestureDetector(
          onTap: () {
            if (widget.isDatePicker) {
              selectDate(); // Pick date if isDatePicker is true
            } else if (widget.isRange) {
              selectTimeRange(); // Pick time range
            } else {
              selectTime(); // Pick single time
            }
          },
          child: Container(
            padding: const EdgeInsets.only(top: 13, bottom: 13, right: 20, left: 12),
            decoration: ShapeDecoration(
              color: const Color.fromARGB(255, 232, 232, 232).withOpacity(0.02),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 35,
                  offset: Offset(0, 9),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  widget.isDatePicker
                      ? (selectedDate!.isEmpty)
                          ? 'اختر التاريخ'.tr()
                          : selectedDate!
                      : widget.isRange
                          ? (startTime!.isEmpty && endTime!.isEmpty)
                              ? 'اختر وقت من والى'.tr()
                              : 'من $startTime إلى $endTime'
                          : (startTime!.isEmpty)
                              ? 'اختر الوقت'.tr()
                              : startTime!,
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                // SvgPicture.asset(
                //   widget.isDatePicker ? AppIcons.calendar : AppIcons.timeIcon,
                //   colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
