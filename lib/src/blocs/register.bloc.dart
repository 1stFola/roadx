import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadx/src/helpers/validator/register.dart';
import 'package:roadx/src/pages/register/confirm_register_widget.dart';
import 'package:roadx/src/repositories/auth.repository.dart';
import 'package:roadx/src/widgets/toast.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends ChangeNotifier with Register {

  AuthRepository _repository = new AuthRepository();

  final _loadingController = BehaviorSubject<bool>();
  final _emailController = BehaviorSubject<String>();
  final _isDriverController = BehaviorSubject<int>();
  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(int) get isDriverChanged => _isDriverController.sink.add;
  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get firstNameChanged => _firstNameController.sink.add;
  Function(String) get lastNameChanged => _lastNameController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

//  _acceptController.sink.add(false);

  Stream<bool> get loading => _loadingController.stream;
  void _setLoading(bool value) => _loadingController.sink.add(value);

  Stream<int> get isDriver => _isDriverController.stream;
  Stream<String> get firstName => _firstNameController.stream.transform(nullValidator);
  Stream<String> get lastName => _lastNameController.stream.transform(nullValidator);
  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck =>
      Rx.combineLatest4(firstName, email, password, lastName, (a, e, p, q) => true);

  submit(BuildContext context) async {

    _setLoading(true);

    final ret = await _repository.register(_firstNameController.value, _lastNameController.value, _emailController.value,
        _passwordController.value, );

    _setLoading(false);

    if (ret.status) {
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new ConfirmRegisterWidget()));
    }else{
      CustomToast.show(ret.message);
    }

  }

  @override
  void dispose() {
    _loadingController?.close();
    _emailController?.close();
    _passwordController?.close();
    _firstNameController?.close();
    _firstNameController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}

