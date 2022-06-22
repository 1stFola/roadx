import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/helpers/validator/register.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/AuthenticationRequest.dart';
import 'package:roadx/src/pages/chooseRide/choose_ride_widget.dart';
import 'package:roadx/src/pages/home/home_widget.dart';
import 'package:roadx/src/repositories/auth.repository.dart';
import 'package:roadx/src/widgets/toast.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends ChangeNotifier with Register {

  AuthRepository _repository = new AuthRepository();


  final _userController = BehaviorSubject<UserDetails>();
  final _loadingController = BehaviorSubject<bool>();
  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _mobileNumberController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _workplaceController = BehaviorSubject<String>();
  final _numberPlateController = BehaviorSubject<String>();
  final _vehicleModelController = BehaviorSubject<String>();
  final _vehicleCategoryController = BehaviorSubject<String>();
  final _hasAcController = BehaviorSubject<String>();

  Function(UserDetails) get userChanged => _userController.sink.add;
  Function(String) get firstNameChanged => _firstNameController.sink.add;
  Function(String) get lastNameChanged => _lastNameController.sink.add;
  Function(String) get mobileNumberChanged => _mobileNumberController.sink.add;
  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;
  Function(String) get addressChanged => _addressController.sink.add;
  Function(String) get workplaceChanged => _workplaceController.sink.add;
  Function(String) get numberPlateChanged => _numberPlateController.sink.add;
  Function(String) get vehicleModelChanged => _vehicleModelController.sink.add;
  Function(String) get vehicleCategoryChanged => _vehicleCategoryController.sink.add;
  Function(String) get hasAcChanged => _hasAcController.sink.add;



  Stream<bool> get loading => _loadingController.stream;
  void _setLoading(bool value) => _loadingController.sink.add(value);

  Stream<UserDetails> get user => _userController.stream;
  void _setUser(UserDetails value) => _userController.sink.add(value);

  Stream<String> get firstName => _firstNameController.stream.transform(nameValidator);
  Stream<String> get lastName => _lastNameController.stream.transform(nameValidator);
  Stream<String> get mobileNumber => _mobileNumberController.stream.transform(nameValidator);
  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get address => _addressController.stream;
  Stream<String> get workplace => _workplaceController.stream;
  Stream<String> get numberPlate => _numberPlateController.stream;
  Stream<String> get vehicleModel => _vehicleModelController.stream;
  Stream<String> get vehicleCategory => _vehicleCategoryController.stream;
  Stream<String> get hasAc => _hasAcController.stream.transform(nullValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  void _setFirstName(UserDetails value) => _firstNameController.sink.add(value.first_name != null ? value.first_name : "");
  void _setLastName(UserDetails value) => _lastNameController.sink.add(value.last_name != null ? value.last_name : "");
  void _setMobileNumber(UserDetails value) => _mobileNumberController.sink.add(value.phone != null ? value.phone : "");
  void _setAddress(UserDetails value) => _addressController.sink.add(value.address != null ? value.address : "");
  void _setWorkplace(UserDetails value) => _workplaceController.sink.add(value.workplace != null ? value.workplace : "");
  void _setNumberPlate(UserDetails value) => _numberPlateController.sink.add(value.number_plate != null ? value.number_plate : "");


  Stream<bool> get submitCheck =>
      Rx.combineLatest2(email, password, (e, p) => true);


  Stream<bool> get submitCheckProfile =>
      Rx.combineLatest3(firstName, lastName, mobileNumber, (e, p, m) => true);

  AuthBloc(){
    loadClient();
  }



  socialNetworkLogin(AuthenticationRequest user, BuildContext context) async {
    _setLoading(true);
    final ret = await _repository.socialLogin(user);
    _setLoading(false);
    if (ret.status) {

      loadClient();

      await StorageHelper.getBool(StorageKeys.REDIRECT_CHOOSE_RIDE) ?
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => new ChooseRideWidget())) :
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => new HomePage()));
    }else{
      CustomToast.show(ret.message);
    }

  }


  submit(BuildContext context) async {

    _setLoading(true);

    final ret = await _repository.login(_emailController.value, _passwordController.value);
    _setLoading(false);
    if (ret.status) {

      loadClient();

      await StorageHelper.getBool(StorageKeys.REDIRECT_CHOOSE_RIDE) ?
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => new ChooseRideWidget())) :
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => new HomePage()));

    }else{
      CustomToast.show(ret.message);
    }
  }

  submitProfile(BuildContext context) async {
    _setLoading(true);
    UserDetails user = new UserDetails();
    user.first_name = _firstNameController.value;
    user.last_name = _lastNameController.value;
    user.phone = _mobileNumberController.value;
    user.address = _addressController.value;
    user.workplace = _workplaceController.value;
    user.number_plate = _numberPlateController.value;
    user.vehicle_category = _vehicleCategoryController.value;
    user.vehicle_model = _vehicleModelController.value;

    final ret = await _repository.editProfile(user);
    _setLoading(false);

    if (ret.status) {
      loadClient();
      CustomToast.show("Your profile has been updated");
    }else{
      CustomToast.show(ret.message);
    }
    notifyListeners();
  }

  takeImage(File image, String type) async {
    _setLoading(true);
    final ret = await _repository.uploadPicture(image, type);
    _setLoading(false);

    if (ret.status) {
      loadClient();
      CustomToast.show("Your "+type+" has been updated");
    }else{
      CustomToast.show(ret.message);
    }
    notifyListeners();
  }



  Future<UserDetails> loadClient() async {
    var userData = await StorageHelper.get(StorageKeys.client);
    if (userData != null && userData != "") {
      var res = UserDetails.fromJson(jsonDecode(userData));
      _setUser(res);
      _setFirstName(res);
      _setLastName(res);
      _setMobileNumber(res);
      _setAddress(res);
      _setWorkplace(res);
      _setNumberPlate(res);
      return res;
    }else{
      StorageHelper.setBool(StorageKeys.SHOW_FIRST_TIMER_MODAL, true);
    }
    return null;
  }

  void logout() {
    StorageHelper.set(StorageKeys.token, "");
    StorageHelper.set(StorageKeys.email, "");
    StorageHelper.set(StorageKeys.client, "");
    _setUser(null);

  }

}

abstract class BaseBloc {
  void dispose();
}

