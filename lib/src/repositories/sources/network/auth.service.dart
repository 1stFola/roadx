import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:roadx/src/helpers/http/http.helper.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/ErrorInfo.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/AuthenticationRequest.dart';
import 'package:roadx/src/models/response.model.dart';
import './base/endpoints.dart' as Endpoints;

class AuthService {
  Future<ResponseModel> login(String email, String password) async {
    ResponseModel response = ResponseModel();
    UserDetails user;

    final String url = Endpoints.auth.login;

    final payload = {"email": email.trim(), "password": password};

    final retAuth = HttpHelper.post(url, body: payload);

    await retAuth.then((res) {
      if(res.data['error'] != null){
        ErrorInfo error = ErrorInfo.fromJson(res.data['error']);
        response.status = false;
        response.message = error.message;
      }else {
        String token = res.data["accessToken"];
        StorageHelper.set(StorageKeys.token, token);
        user = UserDetails.fromJson(res.data['data']);
        StorageHelper.set(StorageKeys.client, jsonEncode(user));
        response.status = true;
        response.data = user;
      }
    }).catchError((e) {
      StorageHelper.set(StorageKeys.token, "");
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }
  Future<ResponseModel> socialLogin(AuthenticationRequest user) async {
    ResponseModel response = ResponseModel();
    UserDetails user;

    final String url = Endpoints.auth.socialLogin;

    final retAuth = HttpHelper.post(url, body: user);

    await retAuth.then((res) {
      if(res.data['error'] != null){
        ErrorInfo error = ErrorInfo.fromJson(res.data['error']);
        response.status = false;
        response.message = error.message;
      }else {
        String token = res.data["accessToken"];
        StorageHelper.set(StorageKeys.token, token);
        user = UserDetails.fromJson(res.data['data']);
        StorageHelper.set(StorageKeys.client, jsonEncode(user));
        response.status = true;
        response.data = user;
      }
    }).catchError((e) {
      StorageHelper.set(StorageKeys.token, "");
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> register(
      String firstName, String lastName, String email, String password) async {
    ResponseModel response = ResponseModel();
    final String url = Endpoints.auth.register;

    final payload = {
      "first_name": firstName,
      "email": email,
      "password": password,
      "last_name": lastName
    };

    final retAuth = HttpHelper.post(url, body: payload);

    await retAuth.then((res) {
      if(res.data['error'] != null){
        ErrorInfo error = ErrorInfo.fromJson(res.data['error']);
        response.status = false;
        response.message = error.message;
      }else {
        response.status = true;
        response.message = res.statusMessage;
        StorageHelper.set(StorageKeys.email, email);
      }
    }).catchError((e) {
      if(e.response != null && e.response.data != null && e.response.data['error'] != null){
        ErrorInfo error = ErrorInfo.fromJson(e.response.data['error']);
        response.status = false;
        response.message = error.message;
      }else {
        response.status = false;
        //response.data = e;
        response.message = e.message;
      }
    });

    return response;
  }

  // Future<ResponseModel> validateAccount(String email) async {
  //   ResponseModel response = ResponseModel();
  //   final String url = Endpoints.auth.passwordCreate + "/" + email;
  //
  //   final retAuth = HttpHelper.post(url);
  //   await retAuth.then((res) {
  //     response.status = true;
  //     response.message = res.statusMessage;
  //   }).catchError((e) {
  //     response.status = false;
  //     response.data = e;
  //     if (e.response.statusCode == 401) {
  //       response.message = e.response.data;
  //     } else {
  //       response.message = e.message;
  //     }
  //   });
  //
  //   return response;
  // }

  Future<ResponseModel> confirmRegister(String email, String code) async {
    ResponseModel response = ResponseModel();
    UserDetails user;

    final payload = {
      "token": code,
      "email": email,
    };

    final String url =
        Endpoints.auth.confirmAccount;
    final retAuth = HttpHelper.post(url, body: payload);

    await retAuth.then((res) {
      if(res.data['error'] != null){
        ErrorInfo error = ErrorInfo.fromJson(res.data['error']);
        response.status = false;
        response.message = error.message;
      }else {
        String token = res.data["accessToken"];
        StorageHelper.set(StorageKeys.token, token);
        user = UserDetails.fromJson(res.data['data']);
        StorageHelper.set(StorageKeys.client, jsonEncode(user));
        response.status = true;
        response.data = user;
        response.message = res.statusMessage;
      }
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> passwordCreate(String email) async {
    ResponseModel response = ResponseModel();

    final payload = {"email": email};

    final String url = Endpoints.auth.passwordCreate;
    final retAuth = HttpHelper.post(url, body: payload);

    await retAuth.then((res) {
      response.status = true;
      response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> passwordReset(String email, String token) async {
    ResponseModel response = ResponseModel();

    final payload = {"email": email, "token": token};

    final String url = Endpoints.auth.passwordReset;
    final retAuth = HttpHelper.post(url, body: payload);

    await retAuth.then((res) {
      response.status = true;
      response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }



  @override
  Future<ResponseModel> uploadPicture(File file, String type) async {

    ResponseModel response = ResponseModel();

    UserDetails user;

    String fileName = file.path
        .split('/')
        .last;

    final String url = Endpoints.user.profile_picture+type;
    FormData formData = FormData.fromMap({
      "type": type,
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final retAuth = HttpHelper.post(url, body: formData);

    await retAuth.then((res) {
      user = UserDetails.fromJson(res.data);
      StorageHelper.set(StorageKeys.client, jsonEncode(user));
      response.status = true;
      response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });
    return response;

  }


  @override
  Future<ResponseModel> editProfile(UserDetails user) async {

    ResponseModel response = ResponseModel();

    final String url = Endpoints.user.update;
    final retAuth = HttpHelper.post(url, body: user);

    await retAuth.then((res) {
      UserDetails userD = UserDetails.fromJson(res.data);
      StorageHelper.set(StorageKeys.client, jsonEncode(userD));
      response.data= userD;
      response.status = true;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  @override
  Future<ResponseModel> getUserProfile() async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.user.details;
    final retAuth = HttpHelper.get(url);

    await retAuth.then((res) {
      UserDetails userD = UserDetails.fromJson(res.data);
      StorageHelper.set(StorageKeys.client, jsonEncode(userD));
      response.data= userD;
      response.status = true;
      response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }


}
