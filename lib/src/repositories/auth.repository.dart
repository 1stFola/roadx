import 'dart:io';

import 'package:roadx/src/helpers/connection.helper.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/AuthenticationRequest.dart';
import 'package:roadx/src/models/response.model.dart';
import 'package:roadx/src/repositories/sources/network/auth.service.dart';

class AuthRepository {
  AuthService api = AuthService();

  Future<ResponseModel> login(String login, String senha) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.login(login, senha);
    } else {
      response.message = "Device offline";
    }

    return response;
  }
  Future<ResponseModel> socialLogin(AuthenticationRequest user) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.socialLogin(user);
    } else {
      response.message = "Device offline";
    }

    return response;
  }
  Future<ResponseModel> register(String firstName, String lastName, String email, String password) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.register(firstName, lastName, email, password);
    } else {
      response.message = "Device offline";
    }

    return response;
  }
  // Future<ResponseModel> validateAccount(String email) async {
  //   ResponseModel response = ResponseModel();
  //
  //   final hasConnection = await ConnectionHelper.hasConnection();
  //
  //   if (hasConnection) {
  //     response = await this.api.validateAccount(email);
  //   } else {
  //     response.message = "Device offline";
  //   }
  //
  //   return response;
  // }
  Future<ResponseModel> confirmRegister(String email, String code) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.confirmRegister(email, code);
    } else {
      response.message = "Device offline";
    }

    return response;
  }
  Future<ResponseModel> passwordCreate(String email) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.passwordCreate(email);
    } else {
      response.message = "Device offline";
    }

    return response;
  }
  Future<ResponseModel> passwordReset(String email, String code) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.passwordReset(email, code);
    } else {
      response.message = "Device offline";
    }

    return response;
  }

  Future<ResponseModel> uploadPicture(File file, String type) async {

    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.uploadPicture(file, type);
    } else {
      response.message = "Device offline";
    }

    return response;
  }

  Future<ResponseModel> editProfile(UserDetails user) async {

    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.editProfile(user);
    } else {
      response.message = "Device offline";
    }

    return response;
  }


  Future<ResponseModel> getUserProfile() async {

    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.getUserProfile();
    } else {
      response.message = "Device offline";
    }

    return response;
  }
}
