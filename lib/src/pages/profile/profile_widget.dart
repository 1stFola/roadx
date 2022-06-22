import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/repositories/auth.repository.dart';
import 'package:roadx/src/values/colors.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:roadx/src/widgets/button.dart';
import 'package:roadx/src/widgets/dropdown.dart';
import 'package:roadx/src/widgets/edit_text.dart';
import 'package:roadx/src/widgets/loading.dart';

class ProfileWidget extends StatefulWidget {
  @override
  createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with TickerProviderStateMixin {


  AuthBloc authBloc;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    authBloc = Provider.of<AuthBloc>(context);
  }


  AnimationController stateController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }


  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.mediaLibrary,
      Permission.photos,
    ].request();

    //If it doesnt have Permission
    if (!await Permission.camera.status.isGranted || !await Permission.mediaLibrary.status.isGranted || !await Permission.photos.status.isGranted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserDetails>(
        stream: authBloc.user,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ));
          return view(context, snapshot.data);
        });
  }

  @override
  Widget view(BuildContext context, UserDetails user) {
    return Loading(
        message: "Loading message",
        status: authBloc.loading,
        child: new Scaffold(
        appBar: CustomAppBar(
            height: 180,
            child: Stack(children: <Widget>[
              Image.asset(
                "assets/images/profile_header.png",
                fit: BoxFit.fitWidth,
                height: 160,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppBar(
                    centerTitle: true,
                    title: Text(
                      "Upgrade Your Profile",
                      style: new TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.transparent,
                    leading: new IconButton(
                        color: Colors.white,
                        icon: new Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                          ;
                        }),
                    elevation: 0,
                  ),
                  Container(
                    child: new GestureDetector(
                      onTap: () => selectImage(context),
                      child: new Center(
                        child: user != null && user.image != null
                            ? new CircleAvatar(
                                radius: 45.0,
                                backgroundColor: Colors.white,
                                backgroundImage: Utils.getImage(user.image),
                              )
                            : new CircleAvatar(
                                radius: 45.0,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    new AssetImage("assets/images/avatar.jpg"),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ])),
        body: SingleChildScrollView(
            child: new Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      EditText(
                        labelText: "First Name",
                        onChange: authBloc.firstNameChanged,
                        value: authBloc.firstName,
                      ),
                      EditText(
                        labelText: "Last Name",
                        onChange: authBloc.lastNameChanged,
                        value: authBloc.lastName,
                      ),
                      EditText(
                        labelText: "Mobile Number",
                        onChange: authBloc.mobileNumberChanged,
                        keyboardType: TextInputType.phone,
                        value: authBloc.mobileNumber,
                      ),
                      EditText(
                        labelText: "Address",
                        onChange: authBloc.addressChanged,
                        value: authBloc.address,
                      ),
                      EditText(
                        labelText: "Work Place",
                        onChange: authBloc.workplaceChanged,
                        value: authBloc.workplace,
                      ),
                      EditText(
                        labelText: "Vehicle  Category",
                        onChange: authBloc.vehicleCategoryChanged,
                        value: authBloc.vehicleCategory,
                      ),
                      EditText(
                        labelText: "Vehicle Model",
                        onChange: authBloc.vehicleModelChanged,
                        value: authBloc.vehicleModel,
                      ),
                      EditText(
                        labelText: "Driver’s Plate Number",
                        onChange: authBloc.numberPlateChanged,
                        value: authBloc.numberPlate,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "Does your vehicle have AC?",
                        style: TextStyle(
                          color: Color(0xffc4c4c4),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      StreamBuilder<String>(
                        stream: authBloc.hasAc,
                        initialData: "NO",
                        builder: (context, snapshot) =>
                            new DropdownButton<String>(
                          hint: Text("Does your vehicle have AC?"),
                          isExpanded: true,
                          value: snapshot.data,
                          items: <String>['YES', 'NO'].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: authBloc.hasAcChanged,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      StreamBuilder<bool>(
                        stream: authBloc.submitCheckProfile,
                        builder: (context, snapshot) => CustomButton(
                          onPress: snapshot.hasData
                              ? () => authBloc.submitProfile(context)
                              : null,
                          label: "Save",
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ])))));
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Add Picture"),
          children: <Widget>[
            Divider(),
            SimpleDialogOption(
                child: Text("Photo with Camera"), onPressed: handleTakePhoto),
            Divider(),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChooseFromGallery),
            Divider(),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  handleTakePhoto() async {
    Navigator.pop(context);
    final PickedFile image = await _picker.getImage(
        maxHeight: 500, maxWidth: 500, source: ImageSource.camera);
    _cropImage(image.path);

    // setState(() {
    //   authBloc.takeImage(File(image.path), 'picture');
    // });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    final PickedFile image = await _picker.getImage(
        maxHeight: 500, maxWidth: 500, source: ImageSource.gallery);
    _cropImage(image.path);

    // setState(() {
    //   _cropImage(image.path);
      // authBloc.takeImage(File(image.path), 'picture');
    // });
  }

  _cropImage(filePath) async {

    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
        ]
            : [
          CropAspectRatioPreset.square,
        ],
        compressQuality: 60,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Roadx Cropper',
            toolbarColor: backgroundColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Roadx Cropper',
        ));

    if (croppedImage != null) {
      authBloc.takeImage(croppedImage, 'profile');
    }
  }

}
