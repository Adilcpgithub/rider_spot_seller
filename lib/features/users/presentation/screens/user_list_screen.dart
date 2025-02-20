import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/features/users/presentation/blocs/user_detail/user_detail_bloc.dart';
import 'package:ride_spot/features/users/presentation/screens/user_datails_screen.dart';
import 'package:ride_spot/features/users/presentation/widgets/user_screen_wigets.dart';
import 'package:ride_spot/utility/navigation.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  // Dummy user data

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailBloc()..add(FetchUsersEvent()),
      child: Scaffold(
        body: BlocBuilder<UserDetailBloc, UserDetailState>(
          builder: (context, state) {
            if (state is UserDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is UserDetailLoaded) {
              if (state.users.isEmpty) {
                return const Center(child: Text('No users found.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserDetailBloc>().add(FetchUsersEvent());
                },
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      elevation: 2,
                      child: ListTile(
                        onTap: () {
                          CustomNavigation.push(
                              context,
                              UserDetailScreen(
                                //!change here also dont forgote
                                userId: user['documentId'] ?? '',
                              ));
                        },
                        leading: GestureDetector(
                          onTap: () {
                            UserScreenWigets.showProfileDialog(
                                context, user['profileImage'] ?? '');
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Colors.white, // Placeholder background color
                              backgroundImage: user['profileImage'] != null
                                  ? NetworkImage(user['profileImage'])
                                  : null,

                              child: user['profileImage'] == null
                                  ? const Icon(Icons.person_rounded,
                                      size: 33,
                                      color: Colors.black45) // Fallback icon
                                  : null,
                            ),
                          ),
                        ),
                        title: Text(
                          user["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user["email"]),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('Unexpected state.'));
          },
        ),
      ),
    );
  }
}
