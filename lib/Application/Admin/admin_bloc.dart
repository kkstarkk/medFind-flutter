import 'package:bloc/bloc.dart';
import 'package:medfind_flutter/Domain/Admin/User.dart';
import 'package:medfind_flutter/Infrastructure/Admin/Repository/admin_repository.dart';
import 'package:medfind_flutter/Infrastructure/_Shared/return_data_type.dart';
import '../../Domain/Admin/APharamcy.dart';
part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository adminRepo;
  AdminBloc(this.adminRepo) : super(Idle()) {
    on<LoadUsers>(_loadUsers);
    on<LoadUser>(_loadUser);
    on<UpdateUser>(_updateUser);
    on<DeleteUser>(_deleteUser);
    on<ChangerRole>(_changeRole);
    on<LoadPharmacies>(_loadPharmacies);
    on<LoadPharmacy>(_loadPharmacy);
    on<DeletePharmacy>(_deletePharmacy);
    on<UpdatePharmacy>(_updatePharmacy);
    on<Error>(_handleError);
  }

  //_____________________ users ______________\\
  // load users
  void _loadUsers(LoadUsers event, Emitter emit) async {
    emit(Loading());
    Return result = await adminRepo.getUsers();
    print(result.hasError);
    if (!result.hasError) {
      emit(UsersLoaded(result.value));
    } else {
      emit(LoadingFailed(msg: "Error loading Users"));
    }
  }

  //retrive a user
  void _loadUser(LoadUser event, Emitter emit) async {
    emit(Loading());
    Return result = await adminRepo.getUser(event.id);
    print(result.hasError);
    if (!result.hasError) {
      emit(UserLoaded(result.value));
    } else {
      emit(LoadingFailed(msg: "Error loading  user"));
    }
  }

  //
  void _updateUser(UpdateUser event, Emitter emit) async {
    emit(Loading());

    Return result = await adminRepo.updateUser(event.user);
    print(result.hasError);
    if (!result.hasError) {
      emit(UserLoaded(result.value));
    } else {
      emit(UpdateFailed(msg: "Error on update"));
    }
  }

  void _deleteUser(DeleteUser event, Emitter emit) async {
    emit(Loading());
    Return result = await adminRepo.removeUser(event.id);
    if (!result.hasError) {
      emit(UserDeleted(event.id));
    } else {
      emit(DeleteFailed(msg: "Error while deleting " + result.error));
    }
  }

  void _changeRole(ChangerRole event, Emitter emit) async {
    emit(Loading());
    Return? result;
    try {
      result = await adminRepo.changeRole(event.id, event.role);
    } catch (ex) {
      print(ex.toString());
    }

    if (!result!.hasError) {
      print("eror__________");
      emit(RoleChanged(event.id));
    } else {
      emit(ChangeFailed(event.id));
    }
  }

  //____________________ pharmacies ________________\\

  void _loadPharmacies(LoadPharmacies event, Emitter emit) async {
    emit(Loading());
    Return result = await adminRepo.getPharmacies();
    if (!result.hasError) {
      emit(PharmaciesLoaded(result.value));
    } else {
      emit(LoadingFailed(msg: "Error loading Pharmacies"));
    }
  }

  void _loadPharmacy(LoadPharmacy event, Emitter emit) async {
    emit(Loading());
    Return result = await adminRepo.getPharmacy(event.id);

    if (!result.hasError) {
      emit(PharmacyLoaded(result.value));
    } else {
      emit(LoadingFailed(msg: "Error loading pharmacy"));
    }
  }

  void _deletePharmacy(DeletePharmacy event, Emitter emit) async {
    Return result = await adminRepo.removePharmacy(event.id);
    if (!result.hasError) {
      emit(PharmacyDeleted(event.id));
    } else {
      emit(DeleteFailed(msg: "Error while deleting " + result.error));
    }
  }

  void _updatePharmacy(UpdatePharmacy event, Emitter emit) async {
    emit(Loading());
    Return result = await adminRepo.updatePharmacy(event.pharmacy);

    if (!result.hasError) {
      emit(PharmacyLoaded(result.value));
    } else {
      emit(UpdateFailed(msg: "Error on update"));
    }
  }

  void _handleError(Error event, Emitter emit) async {
    emit(ErrorState(msg: event.msg));
    await Future.delayed(Duration(seconds: 2));
    event.data is APharmacy
        ? emit(PharmacyLoaded(event.data))
        : emit(UserLoaded(event.data));
  }
}
