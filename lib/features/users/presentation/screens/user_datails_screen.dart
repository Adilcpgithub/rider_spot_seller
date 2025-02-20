import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ride_spot/features/users/presentation/blocs/user_detail/user_detail_bloc.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "User Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: CustomColor.lightpurple,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User not found"));
          }

          var user = snapshot.data!.data() as Map<String, dynamic>;
          context.read<UserDetailBloc>().add(AddressToggleEvent(
              showAddress: user['addresses'] != null ? true : false,
              haveAddress: user['addresses'] != null));
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Stack(alignment: Alignment.center, children: [
                    SizedBox(
                      width: 280, // Adjust size as needed
                      height: 280,
                      child:
                          Lottie.asset('asset/Animation - 1739873295791.json'),
                    ),
                    CircleAvatar(
                      radius: 90,
                      backgroundColor:
                          Colors.white, // Placeholder background color
                      backgroundImage: user['profileImage'] != null
                          ? NetworkImage(user['profileImage'])
                          : null,

                      child: user['profileImage'] == null
                          ? const Icon(Icons.person_rounded,
                              size: 110, color: Colors.black45) // Fallback icon
                          : null,
                    )
                  ]),
                ),

                const SizedBox(height: 100),
                // Name
                Text("Name: ${user['name']}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 10),
                // Email
                Text("Email: ${user['email']}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                // Phone
                Text("Phone: ${user['phoneNumber'] ?? 'Not provided'}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),

                //! Address
                Row(
                  children: [
                    Text(
                      "Address: ${user['addresses'] != null ? '' : 'Not provided'}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      //Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
                    ),
                    BlocBuilder<UserDetailBloc, UserDetailState>(
                      builder: (context, state) {
                        bool showAddress;
                        bool haveAddress;
                        if (state is ShowAddressDetail &&
                            state.showAddress == true) {
                          showAddress = true;
                        } else {
                          showAddress = false;
                        }
                        if (state is ShowAddressDetail &&
                            state.haveAddress == true) {
                          haveAddress = true;
                        } else {
                          haveAddress = false;
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: IconButton(
                                onPressed: () {
                                  context.read<UserDetailBloc>().add(
                                      AddressToggleEvent(
                                          haveAddress: haveAddress,
                                          showAddress: !showAddress));
                                },
                                icon: haveAddress
                                    ? Icon(
                                        showAddress == true
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_up,
                                        color: Colors.blue,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    )
                  ],
                ),
                BlocBuilder<UserDetailBloc, UserDetailState>(
                  builder: (context, state) {
                    if (user["addresses"] != null &&
                        user["addresses"] is List &&
                        user["addresses"].isNotEmpty) {
                      if (state is ShowAddressDetail && state.showAddress) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (user["addresses"][0]["houseName"] != null)
                                Text(
                                  "Housename: ${user["addresses"][0]["houseName"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (user["addresses"][0]["postOffice"] != null)
                                Text(
                                  "Postoffice: ${user["addresses"][0]["postOffice"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (user["addresses"][0]["pinCode"] != null)
                                Text(
                                  "Pincode: ${user["addresses"][0]["pinCode"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (user["addresses"][0]["district"] != null)
                                Text(
                                  "District: ${user["addresses"][0]["district"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    //  color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (user["addresses"][0]["state"] != null)
                                Text(
                                  "State: ${user["addresses"][0]["state"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
