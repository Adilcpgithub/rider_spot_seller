import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/auth/auth_serviece.dart';
import 'package:ride_spot/features/auth/presentation/blocs/bloc_login/login_bloc.dart';
import 'package:ride_spot/features/auth/presentation/widgets/custom_text_button.dart';
import 'package:ride_spot/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:ride_spot/features/dashboard/presentation/screens/drawer_controll_page.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/app_logo.dart';
import 'package:ride_spot/utility/custom_scaffol_message.dart';
import 'package:ride_spot/utility/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailorPhoneNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              CustomNavigation.pushAndRemoveUntil(
                  context, const AdminHomePage());

              _emailorPhoneNumberController.clear();
              _passwordController.clear();
            }
            if (state is LoginFailed) {
              showUpdateNotification(
                  context: context,
                  message: 'Login  failed',
                  color: const Color.fromARGB(255, 236, 89, 79));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: deviceHeight / 2,
                child: Center(
                  child: FadeInLeft(
                    child: Image.asset(
                      appLogo(),
                      height: deviceWidth - 100,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  height: 480,
                  width: deviceWidth > 400 ? 600 : deviceWidth,
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 5, color: CustomColor.lightpurple)),
                    color: const Color(0xFFF4F3EF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 5),
                          child: SizedBox(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  color: CustomColor.lightpurple,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        ///////1
                        CustomTextFormField(
                          controller: _emailorPhoneNumberController,
                          labelText: ' Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Email';
                            }

                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),

                        CustomTextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be 6 or more numbers';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          labelText: ' Password  ',
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            bool isLoading;
                            log('ssss');
                            if (state is LoginLoading) {
                              log('sss true ');
                              isLoading = true;
                            } else {
                              log('sss true ');
                              isLoading = false;
                            }
                            return CustomTextbutton(
                                buttonColor: CustomColor.lightpurple,
                                isLoading: isLoading,
                                buttomName: 'LOG IN',
                                voidCallBack: () async {
                                  await _submittion(context);
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submittion(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(LogIn(
          email: _emailorPhoneNumberController.text.trim(),
          password: _passwordController.text.trim()));
    }
  }
}
