import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/helpers/validator/register.dart';
import 'package:roadx/src/pages/chooseRide/choose_ride_widget.dart';
import 'package:roadx/src/pages/home/home_widget.dart';
import 'package:roadx/src/repositories/auth.repository.dart';
import 'package:roadx/src/widgets/toast.dart';
import 'package:rxdart/rxdart.dart';

class ValidateRegisterBloc extends ChangeNotifier with Register {

  AuthRepository _repository = new AuthRepository();

  final _loadingController = BehaviorSubject<bool>();
  final _emailController = BehaviorSubject<String>();
  final _codeController = BehaviorSubject<String>();
  Function(String) get codeChanged => _codeController.sink.add;
  Function(String) get emailChanged => _emailController.sink.add;

  Stream<bool> get loading => _loadingController.stream;
  void _setLoading(bool value) => _loadingController.sink.add(value);
  void _setEmail(String value) => _emailController.sink.add(value);

  Stream<String> get code => _codeController.stream.transform(nameValidator);
  Stream<String> get email => _emailController.stream.transform(emailValidator);


  Stream<bool> get submitCheck => code.map((code) => true);

  submit(BuildContext context) async {

    await StorageHelper.get(StorageKeys.email).then((value) => {
      _setEmail(value)
    });

    _setLoading(true);
    final ret = await _repository.confirmRegister(_emailController.value, _codeController.value);
    _setLoading(false);

    if (ret.status) {
      StorageHelper.setBool(StorageKeys.SUCCESS_REGISTER, true);
      if(await StorageHelper.getBool(StorageKeys.REDIRECT_CHOOSE_RIDE)){
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new ChooseRideWidget()));
      }else{
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new HomePage()));
      }
    }else{
      CustomToast.show(ret.message);
    }
  }

  // generateToken(BuildContext context) async {
  //   await StorageHelper.get(StorageKeys.email).then((value) => {
  //     _setEmail(value)
  //   });
  //   _setLoading(true);
  //   final ret = await _repository.validateAccount(_emailController.value);
  //   _setLoading(false);
  //
  //   if (ret.status) {
  //     CustomToast.show("Token has been sent to your email address");
  //   }else{
  //     CustomToast.show(ret.message);
  //   }
  // }

  @override
  void dispose() {
    _loadingController?.close();
    _emailController?.close();
    _codeController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}

