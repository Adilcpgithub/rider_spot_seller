import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/auth/auth_serviece.dart';
import 'package:ride_spot/auth_screen/login_screen.dart';
import 'package:ride_spot/pages/bottom_navigation_page.dart';
import 'package:ride_spot/utility/colors.dart';

import '../blocs/sign_up/bloc/sign_up_bloc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedCountryCode = '+91';
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    // double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          final signUpBloc = context.read<SignUpBloc>();
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: deviceHeight / 3,
                  child: Center(
                    child: Image.asset(
                      'asset/NutraNest.png',
                      height: 180,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Form(
                    autovalidateMode: state.activateValidation
                        ? AutovalidateMode.onUserInteraction
                        : null,
                    key: _formKey,
                    child: Container(
                      height: 600,
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
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            //1///////////////////////
                            SizedBox(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: deviceHeight * 0.002),
                                child: CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Name';
                                    }
                                    return null;
                                  },
                                  controller: _nameController,
                                  onChanged: (name) =>
                                      signUpBloc.add(NameChanged(name)),
                                  labelText: ' Name  ',
                                ),
                              ),
                            ),
                            //2//////////////////
                            SizedBox(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: deviceHeight * 0.002),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Phone';
                                        }
                                        final mobileRegex =
                                            RegExp(r'^[0-9]{7,10}$');
                                        if (!mobileRegex.hasMatch(value)) {
                                          return 'Please enter a valid mobile number (7 to 10 digits)';
                                        }
                                        return null;
                                      },
                                      controller: _phoneController,
                                      labelText: 'Phone Number',
                                      keyboardType: TextInputType.number,
                                      onChanged: (phone) =>
                                          signUpBloc.add(PhoneChanged(phone)),
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CountryCodePicker(
                                              onChanged: (countryCode) {
                                                selectedCountryCode =
                                                    countryCode.dialCode!;
                                                print(selectedCountryCode);
                                                context.read<SignUpBloc>().add(
                                                    TogglePickerVisibility());
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
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //3///////////////////
                            SizedBox(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: deviceHeight * 0.002),
                                child: CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Email';
                                    }
                                    final emailRegex =
                                        RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  labelText: ' Email  ',
                                  onChanged: (email) =>
                                      signUpBloc.add(EmailChanged(email)),
                                ),
                              ),
                            ),
                            //4////////////////////////
                            SizedBox(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: deviceHeight * 0.002),
                                child: CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be 6 or more numbers';
                                    }
                                    return null;
                                  },
                                  controller: _passwordController,
                                  labelText: ' Password  ',
                                  onChanged: (password) =>
                                      signUpBloc.add(PasswordChanged(password)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: deviceHeight * 0.002),
                              child: CustomTextbutton(
                                  buttomName: 'SING UP',
                                  voidCallBack: () async {
                                    await _submittion(context);
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: deviceHeight * 0.002),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: deviceHeight * 0.02),
                                    child: const Text(
                                      'Already having an account?   ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: const Text(
                                      'Login',
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
                                              const LoginScreen(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            var curvedAnimation =
                                                CurvedAnimation(
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
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'By continuing, you agree to Perfect match’s',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        'Terms of Service, Privacy Policy',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.white,
                                            decorationThickness: 1.5,
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submittion(BuildContext context) async {
    final signUpBloc = context.read<SignUpBloc>();
    signUpBloc.add(ActivateValidation());

    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () async => false, // Prevent back button dismissal
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );

        // Perform sign up
        final response = await authService.createUserWithEmailAndPassword(
          name: _nameController.text.trim(),
          phoneNumber: selectedCountryCode + _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Always close the dialog first
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        // Handle the response
        if (response.success) {
          _clearFormFields();

          // Navigate to success screen
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    BottomNavigationPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // For example, a fade transition
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          }
        } else if (context.mounted) {
          // Show error message if registration failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? 'Registration failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Ensure to close the dialog in case of an error
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An unexpected error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _clearFormFields() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.text = ''; // Use this for password fields
  }
}
