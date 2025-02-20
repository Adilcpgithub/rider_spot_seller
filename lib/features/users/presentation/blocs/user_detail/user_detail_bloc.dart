// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserDetailBloc() : super(UserDetailLoading()) {
    on<FetchUsersEvent>((event, emit) async {
      emit(UserDetailLoading());

      try {
        // Fetch the users collection from Firestore
        QuerySnapshot usersSnapshot = await _db.collection('users').get();

        List<Map<String, dynamic>> users = [];
        for (var doc in usersSnapshot.docs) {
          // Assuming each user document contains name, email, etc.
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
          userData['documentId'] = doc.id;
          users.add(userData);
        }

        // Emit the loaded state with users
        emit(UserDetailLoaded(users: users));
      } catch (e) {
        emit(UserDetailError(message: e.toString()));
      }
    });
    on<AddressToggleEvent>((event, emit) {
      emit(ShowAddressDetail(
          showAddress: event.showAddress, haveAddress: event.haveAddress));
    });
  }
}
