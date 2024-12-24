import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/auth/auth_serviece.dart';
import 'package:ride_spot/auth_screen/sign_up_screen.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/login/bloc/login_bloc.dart';
import 'package:ride_spot/pages/bottom_navigation_page.dart';
import 'package:ride_spot/utility/colors.dart';

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
  String selectedCountryCode = '+91';

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: deviceHeight / 2,
                  child: Center(
                    child: Image.asset(
                      'asset/NutraNest.png',
                      height: 180,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: state.activateValidation
                      ? AutovalidateMode.onUserInteraction
                      : null,
                  child: Container(
                    height: 480,
                    width: deviceWidth > 400 ? 600 : deviceWidth,
                    decoration: const BoxDecoration(
                      color: CustomColor.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 5),
                            child: Flexible(
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          ///////1
                          CustomTextFormField(
                            controller: _emailorPhoneNumberController,
                            labelText: state.isEmailVisible
                                ? ' Email'
                                : 'Phone Number',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return state.isEmailVisible
                                    ? 'Please enter Email'
                                    : 'Please enter Number';
                              }
                              if (state.isEmailVisible) {
                                final emailRegex =
                                    RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                              }
                              if (!state.isEmailVisible) {
                                final mobileRegex = RegExp(r'^[0-9]{7,10}$');
                                if (!mobileRegex.hasMatch(value)) {
                                  return 'Please enter a valid mobile number (7 to 10 digits)';
                                }
                              }

                              return null;
                            },
                            keyboardType: state.isEmailVisible
                                ? TextInputType.text
                                : TextInputType.number,
                            prefixIcon: state.isEmailVisible
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CountryCodePicker(
                                          onChanged: (countryCode) {
                                            selectedCountryCode =
                                                countryCode.dialCode!;
                                            print(selectedCountryCode);
                                            context
                                                .read<LoginBloc>()
                                                .add(ToggleEmailVisibility());
                                          },
                                          initialSelection: 'IN',
                                          favorite: const ['+1', 'IN'],
                                          showFlag: false,
                                          showCountryOnly: false,
                                          showOnlyCountryWhenClosed: false,
                                          alignLeft: false,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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

                          Padding(
                            padding: EdgeInsets.only(
                                top: deviceHeight * 0.01,
                                bottom: deviceHeight * 0.01),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '      Forgot Password ? ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),

                          CustomTextbutton(
                              buttomName: 'LOG IN',
                              voidCallBack: () async {
                                await _submittion(
                                    context, state.isEmailVisible);
                              }),
                          Padding(
                            padding: EdgeInsets.only(
                                top: deviceHeight * 0.019,
                                bottom: deviceHeight * 0.019),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don’t have an account?  ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                                GestureDetector(
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            SignUpScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var curvedAnimation = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves
                                                .easeInOut, // Choose any curve here
                                          );

                                          return FadeTransition(
                                            opacity: curvedAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: deviceHeight * 0.012),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Login as',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                GestureDetector(
                                  child: const Text(
                                    ' Guest',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _submittion(BuildContext context, bool isEmailVisible) async {
    context.read<LoginBloc>().add(ActivateValidation());

    AuthResponse response;
    if (_formKey.currentState?.validate() ?? false) {
      response = await authService.logInUserWithEmailAndPassword(
          email: _emailorPhoneNumberController.text,
          password: _passwordController.text);
      // }

      if (response.success) {
        log('login  success');

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BottomNavigationPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut, // Choose any curve here
              );

              return FadeTransition(
                opacity: curvedAnimation,
                child: child,
              );
            },
          ),
        );

        _emailorPhoneNumberController.clear();
        _passwordController.clear();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? 'Registration failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Function(String)? onChanged;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final String? errorText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.floatingLabelBehavior,
    this.errorText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          onChanged: onChanged,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 18, color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2196F3).withOpacity(0.1),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
            hintText: hintText,
            prefixIcon: prefixIcon,

            errorText: errorText, // Show error text here
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              // Keep color same as enabled
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }
}

class CustomTextbutton extends StatelessWidget {
  final String buttomName;
  final VoidCallback voidCallBack;
  final Color color;
  const CustomTextbutton(
      {super.key,
      required this.buttomName,
      required this.voidCallBack,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 57, // Fixed height for button
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 57),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: color,
        ),
        onPressed: voidCallBack,
        child: Text(
          buttomName,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
