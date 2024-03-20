import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robochat/constants.dart';
import 'package:robochat/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10).r,
        margin: const EdgeInsets.all(5).r,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                message.message!,
                style: TextStyle(
                  fontSize: 14.5.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              "${message.messageTime!.hour.toString()}:${message.messageTime!.minute.toString()}  ${message.messageTime!.day.toString()}-${message.messageTime!.month.toString()}-${message.messageTime!.year.toString()}",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CHatBubbleOthers extends StatelessWidget {
  final MessageModel message;
  const CHatBubbleOthers({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10).r,
        margin: const EdgeInsets.all(5).r,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 228, 228),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.r),
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message == "Account no longer exists    "
                  ? "Deleted Account"
                  : message.id!,
              style: GoogleFonts.notoSans(
                fontSize: 12.5.sp,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
              child: message.message == "Account no longer exists    "
                  ? Text(
                      message.message!,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      message.message!,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
            Text(
              "${message.messageTime!.hour.toString()}:${message.messageTime!.minute.toString()}  ${message.messageTime!.day.toString()}-${message.messageTime!.month.toString()}-${message.messageTime!.year.toString()}",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
