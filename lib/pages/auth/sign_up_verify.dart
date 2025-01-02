import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:style_line/app/router.dart';
import 'package:style_line/services/db/cache.dart';
import 'package:style_line/services/db/request_helper.dart';
import 'dart:convert';

import 'package:style_line/services/snack_bar.dart';
import 'package:style_line/style/app_colors.dart';
import 'package:style_line/style/app_style.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({super.key, required this.phoneNumber});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _smsController = TextEditingController();
  late PinTheme currentPinTheme;
  bool isLoading = false;
  OtpTimerButtonController controller = OtpTimerButtonController();

  @override
  void initState() {
    super.initState();
    currentPinTheme = defaultPinTheme;
  }

  @override
  void dispose() {
    _smsController.dispose();
    super.dispose();
  }

  void _onCodeChanged(String value) {
    setState(() {
      currentPinTheme = defaultPinTheme;
    });
  }

  Future<void> resendVerificationCode(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('https://paygo.app-center.uz/services/zyber/api/auth/resend'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone_number': phoneNumber.trim()}),
      );
      print(phoneNumber);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackBarService.showSnackBar(context, data['message'], false);
      } else {
        SnackBarService.showSnackBar(
            context, data['message'] ?? 'Xatolik yuz berdi.', true);
      }
    } catch (e) {
      SnackBarService.showSnackBar(
          context, 'Internetga ulanishda xatolik: $e', true);
    }
  }

  Future<void> _verifyCode() async {
    String enteredCode = _smsController.text.trim();

    if (enteredCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tasdiqlash kodi 6 raqamdan iborat bo‘lishi kerak.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await requestHelper.post(
        '/services/zyber/api/auth/verify',
        {
          'phone_number': widget.phoneNumber,
          'verification_code': enteredCode,
        },
      );

      if (response['accessToken'] != null && response['refreshToken'] != null) {
        cache.setString('user_token', response['accessToken']);
        cache.setString('refresh_token', response['refreshToken']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tasdiqlash muvaffaqiyatli o’tdi.')),
        );
        context.go(
          Routes.homePage,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xatolik: Tokenlar olinmadi.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik yuz berdi: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: AppColors.grade1,
        title: Text(
          'phone_verify',
          style: AppStyle.fontStyle.copyWith(color: Colors.white, fontSize: 20),
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Lottie.asset('assets/lottie/sms_verify.json',
                  width: 200, height: 200),
              SizedBox(height: 20),
              Text(
                'enter_sms',
                style: AppStyle.fontStyle
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ).tr(),
              SizedBox(height: 10),
              Text(
                'we_send_sms',
                style: AppStyle.fontStyle.copyWith(color: Colors.grey),
              ).tr(),
              SizedBox(height: 10),
              Text(
                maskPhoneNumber(widget.phoneNumber),
                style: AppStyle.fontStyle.copyWith(color: AppColors.grade1),
              ),
              SizedBox(height: 20),
              OtpTimerButton(
                controller: controller,
                height: 60,
                text: Text(
                  'resend_code',
                  style: AppStyle.fontStyle.copyWith(color: AppColors.grade1),
                ).tr(),
                duration: 60,
                radius: 30,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                buttonType: ButtonType.text_button,
                loadingIndicator: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.red,
                ),
                loadingIndicatorColor: Colors.red,
                onPressed: () {
                  resendVerificationCode(widget.phoneNumber);
                },
              ),
              Pinput(
                length: 6,
                controller: _smsController,
                defaultPinTheme: currentPinTheme,
                followingPinTheme: followPinTheme,
                errorPinTheme: errorPinTheme,
                onChanged: _onCodeChanged,
                onCompleted: (_) => _verifyCode(),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grade1,
                        elevation: 5,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'phone_verify',
                        style: AppStyle.fontStyle
                            .copyWith(color: AppColors.backgroundColor),
                      ).tr(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

final PinTheme followPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
    borderRadius: BorderRadius.circular(20),
  ),
);

final PinTheme defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromRGBO(77, 77, 77, 1)),
    borderRadius: BorderRadius.circular(20),
  ),
);

final PinTheme errorPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.red),
    borderRadius: BorderRadius.circular(20),
  ),
);

final PinTheme successPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.green),
    borderRadius: BorderRadius.circular(20),
  ),
);

String maskPhoneNumber(String phoneNumber) {
  if (phoneNumber.length >= 11) {
    return phoneNumber.replaceRange(4, 10, '******');
  }
  return phoneNumber;
}
