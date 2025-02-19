import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class UserDetailScreen extends StatelessWidget {
  final String userId;

  const UserDetailScreen({super.key, required this.userId});

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
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
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
                Text("Phone: ${user['phone'] ?? 'Not provided'}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                // Address
                Text("Address: ${user['address'] ?? 'Not available'}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                // Date of Birth

                // Date Joined
                Text("Date Joined: ${user['createdAt']?.toDate() ?? 'Unknown'}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 20),
                // Add any other relevant information here
              ],
            ),
          );
        },
      ),
    );
  }
}
