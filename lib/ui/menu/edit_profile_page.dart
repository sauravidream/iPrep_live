import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/menu/board_update_screen.dart';
import 'package:idream/ui/onboarding/name_class_selection_screen.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';
import 'package:idream/ui/view_profile_page.dart';

import '../../custom_widgets/dialog_box.dart';
import '../../custom_widgets/loading_widget.dart';
import '../onboarding/login_options.dart';
import 'app_drawer.dart';

_EditProfilePageState? _editProfilePageState;
// ignore: unused_element
String? _imageUrl;
final picker = ImagePicker();
bool _showLoader = false;

class EditProfilePage extends StatefulWidget {
  final bool coachApp;
  // ignore: use_key_in_widget_constructors
  const EditProfilePage({this.coachApp = false});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  getParsableDate() {
    try {
      return DateFormat.yMMMd().parse(dobController.text);
    } catch (e) {
      return DateTime.now();
    }
  }

  bool _canEditMobileNumber = false;
  bool _canEditEmail = false;

  _initialiseLocalVar() {
    if ((updatedAppUser.city == "null" ||
            updatedAppUser.city == "null" &&
                updatedAppUser.city == "null" &&
                appUser!.userProfile != null &&
                appUser!.userProfile!.location != null) &&
        (updatedAppUser.city == null ||
            updatedAppUser.city == null &&
                updatedAppUser.city == null &&
                appUser!.userProfile != null &&
                appUser!.userProfile!.location != null)) {
      String address =
          "${appUser!.userProfile!.location!.locationName} ${appUser!.userProfile!.location!.thoroughfare} ${appUser!.userProfile!.location!.subLocality} ${appUser!.userProfile!.location!.locality} ${appUser!.userProfile!.location!.administrativeArea} ${appUser!.userProfile!.location!.postalCode}";
      String state =
          appUser!.userProfile!.location!.administrativeArea.toString();
      String city = appUser!.userProfile!.location!.locality.toString();
      updatedAppUser.city = city;
      updatedAppUser.address = address;
      updatedAppUser.state = state;
    }

    nameController.text = updatedAppUser.fullName ?? "";
    ageController.text = updatedAppUser.age ?? "";
    genderController.text = updatedAppUser.gender ?? '';
    dobController.text = updatedAppUser.dateOfBirth ?? "";
    mobileController.text = updatedAppUser.mobile ?? "";
    parentContactController.text = updatedAppUser.parentContact ?? "";
    emailController.text = updatedAppUser.email ?? "";
    addressController.text = updatedAppUser.address ?? "";
    stateController.text = updatedAppUser.state ?? "";
    cityController.text = updatedAppUser.city ?? "";
    schoolController.text = updatedAppUser.school ?? "";

    _canEditMobileNumber = mobileController.text.isNotEmpty ? false : true;
    _canEditEmail = emailController.text.isNotEmpty ? false : true;
    gender = updatedAppUser.gender ?? "Male";
  }

  @override
  void initState() {
    profileEdited = false;
    super.initState();

    _initialiseLocalVar();
    if (mobileController.text == 'null') {
      mobileController.text = '';
    }
    if (schoolController.text == 'null') {
      schoolController.text = '';
    }
    if (ageController.text == 'null') {
      ageController.text = '';
    }
    if (parentContactController.text == 'null') {
      parentContactController.text = '';
    }
    if (dobController.text == 'null') {
      dobController.text = '';
    }
    if (addressController.text == 'null' || addressController.text == null) {
      addressController.text = '';
    }
    if (cityController.text == 'null' || cityController.text == null) {
      cityController.text = '';
    }
    if (gender == "null") {
      gender = 'Male';
    }
  }

  @override
  Widget build(BuildContext context) {
    _editProfilePageState = this;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: false,
              leadingWidth: 36,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 11,
                  ),
                  child: Image.asset(
                    "assets/images/back_icon.png",
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
              title: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.values[5],
                  color: const Color(0xFF212121),
                ),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 73,
                              width: 73,
                              margin: const EdgeInsets.only(
                                top: 10,
                                bottom: 8,
                              ),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: (appUser!.profilePhoto != null)
                                        ? appUser!.profilePhoto!
                                        : Constants.defaultProfileImagePath,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          strokeWidth: 0.5,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  // CircleAvatar(
                                  //   backgroundImage: NetworkImage(
                                  //     (appUser.profilePhoto != null)
                                  //         ? appUser.profilePhoto
                                  //         : Constants.defaultProfileImagePath,
                                  //   ),
                                  //   radius: ScreenUtil()
                                  //       .setSp(36, ),
                                  // ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () async {
                                        var result =
                                            await showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) =>
                                              myActionSheet(context),
                                        );
                                        if (result != null) {
                                          setState(() {
                                            _showLoader = true;
                                          });
                                          await updateProfilePhoto(
                                              context, result);
                                        }
                                      },
                                      child: Image.asset(
                                        "assets/images/edit_profile_icon.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            /*FutureBuilder(
                            future: _getSavedFullName(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                print('itemNo in FutureBuilder: ${snapshot.data}');
                                return*/
                            Text(
                              updatedAppUser.fullName ?? "",
                              // snapshot.data,
                              style: TextStyle(
                                  color: const Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.values[5]),
                            ),
                            /*;
                              } else
                                return Text('Loading...');
                            },
                          ),*/
                            if (!widget.coachApp)
                              Container(
                                width: 121,
                                margin: const EdgeInsets.only(
                                  top: 6,
                                  bottom: 6,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          "Class",
                                          style: TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        /*FutureBuilder(
                                      future: _getClass(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          print(
                                              'itemNo in FutureBuilder: ${snapshot.data}');
                                          return*/
                                        if (updatedAppUser.classID!.length > 1)
                                          Text(
                                            updatedAppUser.classID!
                                                    .substring(0, 2) +
                                                getSuffix(int.parse(
                                                    updatedAppUser.classID!
                                                        .substring(0, 2))),
                                            // snapshot.data,
                                            style: TextStyle(
                                                color: const Color(0xFF212121),
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.values[4]),
                                          )
                                        else
                                          Text(
                                            updatedAppUser.classID! +
                                                getSuffix(int.parse(
                                                    updatedAppUser.classID!)),
                                            // snapshot.data,
                                            style: TextStyle(
                                                color: const Color(0xFF212121),
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.values[4]),
                                          )

                                        /*;
                                        } else
                                          return Text('Loading...');
                                      },
                                    ),*/
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          "Board",
                                          style: TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        /*FutureBuilder(
                                      future: _getBoard(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          print(
                                              'itemNo in FutureBuilder: ${snapshot.data}');
                                          return */
                                        Text(
                                          updatedAppUser.educationBoard ??
                                              updatedAppUser.boardID!,
                                          // snapshot.data,
                                          style: TextStyle(
                                              color: const Color(0xFF212121),
                                              fontSize: 16,
                                              fontWeight: FontWeight.values[4]),
                                        ), /*;
                                        } else
                                          return Text('Loading...');
                                      },
                                    ),*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            loginInfoWidget(),
                            if (!widget.coachApp) ...[
                              updateClassButton(context, _editProfilePageState),
                            ],

                            if (!widget.coachApp) ...[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: Text(
                                  "Basic Information",
                                  style: TextStyle(
                                    color: const Color(0xFF212121),
                                    fontSize: 12,
                                    fontWeight: FontWeight.values[4],
                                  ),
                                ),
                              ),
                            ],

                            if (widget.coachApp)
                              const SizedBox(
                                height: 24,
                              ),
                            Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: EditProfileTextWidget(
                                leadingImagePath: "assets/images/user_icon.png",
                                placeholder: "Name",
                                textController: nameController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  debugPrint(value);
                                  if (!value!.isNotEmpty &&
                                      !RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                          .hasMatch(value)) {
                                    return "Check your name";
                                  }

                                  profileEdited = false;

                                  return null;
                                },
                              ),
                            ),
                            EditProfileTextWidget(
                              leadingImagePath: "assets/images/age_icon.png",
                              placeholder: "Age",
                              textController: ageController,
                              keyboardType: TextInputType.number,
                              textInputFormatter: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),

                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/gender_icon.png",
                                  height: 21,
                                  width: 18,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: dropdownButton(
                                      setState, genderController),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),

                            // EditProfileTextWidget(
                            //   leadingImagePath: "assets/images/gender_icon.png",
                            //   placeholder: "Sex",
                            //   textController: genderController,
                            // ),
                            GestureDetector(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: getParsableDate(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  helpText: "Select Date of Birth",
                                  errorFormatText: 'Enter valid date',
                                  errorInvalidText: 'Enter date in valid range',
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData
                                          .dark(), // This will change to light theme.
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  dobController.text =
                                      DateFormat.yMMMd().format(picked);
                                  setState(() {
                                    profileEdited = true;
                                  });
                                }
                              },
                              child: EditProfileTextWidget(
                                leadingImagePath: "assets/images/dob_icon.png",
                                placeholder: "Date of Birth",
                                textController: dobController,
                                enabled: false,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                top: 4,
                              ),
                              child: Text(
                                "Contact Information",
                                style: TextStyle(
                                  color: const Color(0xFF212121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.values[4],
                                ),
                              ),
                            ),
                            EditProfileTextWidget(
                              leadingImagePath: "assets/images/telephone.png",
                              placeholder: "Mobile",
                              textController: mobileController,
                              enabled: _canEditMobileNumber,
                              keyboardType: TextInputType.phone,
                              textInputFormatter: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                            if (!widget.coachApp)
                              EditProfileTextWidget(
                                leadingImagePath: "assets/images/telephone.png",
                                placeholder: "Parent's contact",
                                textController: parentContactController,
                                keyboardType: TextInputType.number,
                                textInputFormatter: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                              ),
                            EditProfileTextWidget(
                              leadingImagePath: "assets/images/mail_icon.png",
                              placeholder: "Email",
                              textController: emailController,
                              enabled: _canEditEmail,
                              keyboardType: TextInputType.emailAddress,
                              validator: (input) {
                                if (input!.isNotEmpty &&
                                    !input.isValidEmail()) {
                                  profileEdited = false;
                                  return "Check your email";
                                }
                                return null;
                              },
                              autoValidate: AutovalidateMode.always,
                            ),
                            EditProfileTextWidget(
                              leadingImagePath:
                                  "assets/images/address_icon.png",
                              placeholder: "Address",
                              textController: addressController,
                            ),
                            EditProfileTextWidget(
                              leadingImagePath: "assets/images/state_icon.png",
                              placeholder: "State",
                              textController: stateController,
                            ),
                            EditProfileTextWidget(
                              leadingImagePath: "assets/images/city_icon.png",
                              placeholder: "City",
                              textController: cityController,
                            ),
                            if (!widget.coachApp)
                              EditProfileTextWidget(
                                leadingImagePath:
                                    "assets/images/school_icon.png",
                                placeholder: "School",
                                textController: schoolController,
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(13.0),
                                primary: const Color(0xffEF4444),
                                backgroundColor: Colors.deepOrange[50],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Delete Account'),
                              onPressed: () {
                                displayDeleteUserAccount(context);
                              },
                            ),

                            const SizedBox(
                              height: 159,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: getUpdateProfileButton(context, widget, mounted),
                      )
                    ],
                  ),
                ),
                if (_showLoader) const FullPageLoader()
              ],
            )),
      ),
    );
  }
}

enum Questions { question1, question2, question3, question4 }

Future<void> displayDeleteUserAccount(context) async {
  Questions question = Questions.question1;
  String selectedAns = 'I don’t need it anymore';
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          contentPadding: const EdgeInsets.only(bottom: 20),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actionsPadding: const EdgeInsets.only(bottom: 29),
          titlePadding: const EdgeInsets.only(top: 40),
          title: const Text('Are you Sure you want to delete your Account?',
              style: TextStyle(
                  fontSize: 18, color: Color(0xFF334155), fontFamily: "Inter"

                  //334155
                  ),
              textAlign: TextAlign.center),
          content: const SizedBox(
            height: 46,
          ),
          actions: [
            customButton(
              bText: "Yes",
              onTap: () {
                Navigator.of(context).pop();
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        contentPadding: const EdgeInsets.only(bottom: 20),
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        actionsPadding: const EdgeInsets.only(bottom: 29),
                        titlePadding: const EdgeInsets.only(
                            top: 40, left: 34, right: 39, bottom: 20),
                        titleTextStyle: const TextStyle(),
                        alignment: Alignment.center,
                        title: const Text('Why are you deleting your account?',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF334155),
                              fontFamily: "Inter",

                              //334155
                            ),
                            textAlign: TextAlign.start),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              ListTile(
                                title: const Text('I don’t need it anymore'),
                                leading: Radio<Questions>(
                                  value: Questions.question1,
                                  groupValue: question,
                                  onChanged: (Questions? value) {
                                    setState(() {
                                      question = value!;
                                      selectedAns = 'I don’t need it anymore';
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('It’s too expensive'),
                                leading: Radio<Questions>(
                                  value: Questions.question2,
                                  groupValue: question,
                                  onChanged: (Questions? value) {
                                    setState(() {
                                      question = value!;
                                      selectedAns = 'It’s too expensive';
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('I’m switching to other app'),
                                leading: Radio<Questions>(
                                  value: Questions.question3,
                                  groupValue: question,
                                  onChanged: (Questions? value) {
                                    setState(() {
                                      question = value!;
                                      selectedAns =
                                          'I’m switching to other app';
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Others'),
                                leading: Radio<Questions>(
                                  value: Questions.question4,
                                  groupValue: question,
                                  onChanged: (Questions? value) {
                                    setState(() {
                                      question = value!;
                                      selectedAns = 'Others';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          customButton(
                            bText: "Cancel",
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          customButton(
                            //0077FF
                            color: const Color(0xFF0077FF),
                            bText: "Next",
                            onTap: () {
                              Navigator.of(context).pop();
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      actionsOverflowButtonSpacing: 20,
                                      actionsOverflowAlignment:
                                          OverflowBarAlignment.center,
                                      actionsOverflowDirection:
                                          VerticalDirection.up,
                                      contentPadding: const EdgeInsets.only(
                                          bottom: 20, left: 15, right: 15),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      actionsPadding: const EdgeInsets.only(
                                          bottom: 29, top: 20),
                                      titlePadding: const EdgeInsets.only(
                                          top: 40,
                                          left: 34,
                                          right: 39,
                                          bottom: 20),
                                      titleTextStyle: const TextStyle(),
                                      alignment: Alignment.center,
                                      title: const Text('Delete Your Account',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF334155),
                                            fontFamily: "Inter",

                                            //334155
                                          ),
                                          textAlign: TextAlign.start),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                                'We’re sorry to see you go. Are you sure you don’t want to reconsider?',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF334155),
                                                  fontFamily: "Inter",

                                                  //334155
                                                ),
                                                textAlign: TextAlign.start),
                                            const SizedBox(
                                              height: 11,
                                            ),
                                            Container(
                                              height: 1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .88,
                                              color: const Color(0xFFDEDEDE),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                                "Before you go please know we are on a mission to improve iPrep and make it best learning application for K12.",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF334155),
                                                  fontFamily: "Inter",

                                                  //334155
                                                ),
                                                textAlign: TextAlign.start),
                                            const SizedBox(
                                              height: 27,
                                            ),
                                            const Text(
                                                '\u2022 We offer Access to Multiple Categories of Enjoyable and Engaging Content',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF334155),
                                                  fontFamily: "Inter",

                                                  //334155
                                                ),
                                                textAlign: TextAlign.start),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            const Text(
                                                '\u2022 Unlimited access to content of all classes',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF334155),
                                                  fontFamily: "Inter",

                                                  //334155
                                                ),
                                                textAlign: TextAlign.start),
                                            const SizedBox(
                                              height: 32,
                                            ),
                                            Container(
                                              height: 1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .88,
                                              color: const Color(0xFFDEDEDE),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            customButton(
                                              width: 161,
                                              color: const Color(0xFF0077FF),
                                              bText: "No, Keep my Account",
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                              child: customButton(
                                                width: 161,
                                                color: const Color(0xFFDC2626),
                                                bText: "Delete Account",
                                                onTap: () {
                                                  bool loader = false;
                                                  Navigator.of(context).pop();
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible:
                                                        true, // user must tap button!
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  setState) {
                                                        return loader == false
                                                            ? AlertDialog(
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(12.0))),
                                                                actionsOverflowButtonSpacing:
                                                                    20,
                                                                actionsOverflowAlignment:
                                                                    OverflowBarAlignment
                                                                        .center,
                                                                actionsOverflowDirection:
                                                                    VerticalDirection
                                                                        .up,
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            20,
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15),
                                                                actionsAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                actionsPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            29,
                                                                        top:
                                                                            20),
                                                                titlePadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 40,
                                                                        left:
                                                                            34,
                                                                        right:
                                                                            39,
                                                                        bottom:
                                                                            20),
                                                                titleTextStyle:
                                                                    const TextStyle(),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                title: const Text(
                                                                    'Deleting your account will do the following:',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Color(
                                                                          0xFF334155),
                                                                      fontFamily:
                                                                          "Inter",

                                                                      //334155
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start),
                                                                content:
                                                                    SingleChildScrollView(
                                                                        child:
                                                                            ListBody(
                                                                  children: [
                                                                    Row(
                                                                      children: const [
                                                                        Icon(
                                                                          Icons
                                                                              .highlight_remove,
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                        Text(
                                                                            '  Log you out of all devices',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xFF334155),
                                                                              fontFamily: "Inter",

                                                                              //334155
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.start),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      children: const [
                                                                        Icon(
                                                                          Icons
                                                                              .highlight_remove,
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                        Text(
                                                                            '  Delete all your account information',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xFF334155),
                                                                              fontFamily: "Inter",

                                                                              //334155
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.start),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )),
                                                                actions: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            20),
                                                                    child:
                                                                        customButton(
                                                                      width:
                                                                          161,
                                                                      color: const Color(
                                                                          0xFFDC2626),
                                                                      bText:
                                                                          "Delete Account",
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          loader =
                                                                              true;
                                                                        });
                                                                        userRepository.deleteUserAccount(
                                                                            context,
                                                                            selectedAns);
                                                                        // Navigator.of(
                                                                        //         context)
                                                                        //     .pop();
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : const LoadingWidget();
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      );
                    });
                  },
                );
              },
            ),
            customButton(
              bText: "No",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    },
  );
}

Widget customButton({
  String? bText,
  GestureTapCallback? onTap,
  Color? color,
  double? width,
}) {
  return Material(
    borderRadius: BorderRadius.circular(8),
    color: color ?? const Color(0xFFF4F4F5),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: const Color(0xFFF4F4F5),
          color: Colors.transparent,
        ),
        height: 40,
        width: width ?? 115,
        child: Text(
          bText ?? '',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: color != null
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF64748B),
              fontFamily: "Inter"

              //334155
              ),
        ),
      ),
    ),
  );
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension NameValidator on String {
  bool isValidName() {
    return RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(this);
  }
}

Widget dropdownButton(setState, genderController) {
  return DropdownButtonFormField(
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelText: 'Sex',
      labelStyle: TextStyle(
        height: 0,
        color: const Color(0xFF9E9E9E), //#212121
        fontSize: 12,
        fontWeight: FontWeight.values[4],
      ),
    ),
    hint: Text(
      gender,
      style: TextStyle(
        color: const Color(0xFF212121),
        fontSize: 12,
        fontWeight: FontWeight.values[3],
      ),
    ),
    isExpanded: true,
    iconSize: 30.0,
    style: TextStyle(
      color: const Color(0xFF212121),
      fontSize: 12,
      fontWeight: FontWeight.values[3],
    ),
    elevation: 20,
    items: [
      'Male',
      'Female',
    ].map(
      (val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      },
    ).toList(),
    onChanged: (dynamic val) {
      setState(
        () {
          profileEdited = true;
          gender = val.toString();
          genderController.text = val.toString();
        },
      );
    },
  );
}

class EditProfileTextWidget extends StatelessWidget {
  final String? leadingImagePath;
  final String? placeholder;
  final TextEditingController? textController;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? textInputFormatter;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autoValidate;

  // ignore: use_key_in_widget_constructors
  const EditProfileTextWidget({
    this.leadingImagePath,
    this.placeholder,
    this.textController,
    this.enabled = true,
    this.keyboardType,
    this.textInputFormatter,
    this.validator,
    this.autoValidate = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: TextFormField(
        autocorrect: false,
        enabled: enabled,
        autovalidateMode: autoValidate,
        keyboardType: keyboardType,
        controller: textController,
        inputFormatters: textInputFormatter,
        validator: validator,
        onChanged: (value) {
          // ignore: avoid_print
          print(value);
          if (!profileEdited) {
            // ignore: invalid_use_of_protected_member
            _editProfilePageState!.setState(() {
              profileEdited = true;
            });
          }
        },
        style: TextStyle(
            color: const Color(0xFF212121),
            fontSize: 14,
            fontWeight: FontWeight.values[4]),
        decoration: InputDecoration(
          icon: Image.asset(
            leadingImagePath!,
            height: 21,
            width: 18,
          ),
          labelText: placeholder,
          labelStyle: TextStyle(
              height: 0,
              color: const Color(0xFF9E9E9E), //#212121
              fontSize: 12,
              fontWeight: FontWeight.values[4]),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}

updateClassButton(context, _EditProfilePageState? _editProfilePageState) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 22,
    ),
    child: ElevatedButton(
      // elevation: 0,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: const Size(171, 36),
        side: const BorderSide(
          color: Color(0xFFC9C9C9),
        ),
      ),

      child: Text(
        "Change Class / Board",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.values[4],
          color: const Color(0xFF666666),
        ),
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => BoardUpdateScreen(),
          ),
        );
        // ignore: invalid_use_of_protected_member
        _editProfilePageState!.setState(() {});
      },
    ),
  );
}

Widget loginInfoWidget() {
  return Container(
    alignment: Alignment.center,
    height: 36,
    // width: 216,
    color: const Color(0xFFFFFFFF),
    child: Text(
      "Logged in via: ${FirebaseAuth.instance.currentUser?.phoneNumber == null || FirebaseAuth.instance.currentUser?.phoneNumber == '' ? FirebaseAuth.instance.currentUser?.email : FirebaseAuth.instance.currentUser?.phoneNumber}",
      style: const TextStyle(color: Color(0x77666666)),
    ),
  );
}

getUpdateProfileButton(BuildContext context, EditProfilePage widget, mounted) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 22,
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary:
            profileEdited ? const Color(0xFF0077FF) : const Color(0xFFDEDEDE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        minimumSize: const Size(double.maxFinite, 60),
      ),
      child: Text(
        "Update Profile",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.values[5],
          color: const Color(0xFFFFFFFF),
        ),
      ),
      onPressed: () async {
        try {
          if ((profileEdited || (emailController.text.isNotEmpty)) &&
              nameController.text.isNotEmpty) {
            await userRepository.updateUserProfile();

            // use for navigate to the dashboard to the user screen if use is coach or student

            if (widget.coachApp) {
              if (!mounted) return;
              await Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => const DashboardCoach(),
                ),
                (Route<dynamic> route) => false,
              );
            } else if (!widget.coachApp) {
              if (!mounted) return;
              await Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            }
            if (!mounted) return;
            SnackbarMessages.showSuccessSnackbar(context,
                message: Constants.profileUpdationSuccess);
          } else {
            SnackbarMessages.showErrorSnackbar(context,
                error: Constants.noInformationToUpdate);
          }
        } catch (e) {
          SnackbarMessages.showErrorSnackbar(context,
              error: Constants.noInformationToUpdate);
        }
      },
    ),
  );
}

Future updateProfilePhoto(BuildContext context, String imageSource) async {
  try {
    // ignore: prefer_typing_uninitialized_variables
    var pickedFile;
    if (imageSource == "Camera") {
      // ignore: avoid_print
      print("Open Camera");
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else if (imageSource == "Gallery") {
      // ignore: avoid_print
      print("Open Gallery");
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }
    if (pickedFile != null && pickedFile.path != null) {
      File? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: const IOSUiSettings(
            title: 'Cropper',
          ));

      if (croppedFile != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref =
            storage.ref().child("image1" + DateTime.now().toString());
        UploadTask uploadTask = ref.putFile(croppedFile);

        await uploadTask.then((res) async {
          res.ref.getDownloadURL().then((value) async {
            if (value != null) {
              bool _response = await (userRepository
                  .updateUserProfileAndBatchesWithProfilePhoto(
                      profilePhotoUrl: value));
              if (_response) {
                // ignore: invalid_use_of_protected_member
                _editProfilePageState!.setState(() {
                  _imageUrl = value;
                });
                SnackbarMessages.showSuccessSnackbar(context,
                    message: Constants.profileUpdationSuccess);
              } else {
                SnackbarMessages.showErrorSnackbar(context,
                    error: Constants.profilePhotoUpdationBackEndError);
              }
            }
          });
        });
      } else {
        SnackbarMessages.showErrorSnackbar(context,
            error: Constants.imageProcessingError);
      }
    }
  } catch (e) {
    SnackbarMessages.showErrorSnackbar(context,
        error: Constants.profilePhotoUpdateCatchError);
    // ignore: avoid_print
    print(e.toString());
  } finally {
    // ignore: invalid_use_of_protected_member
    _editProfilePageState!.setState(() {
      _showLoader = false;
    });
  }
}

myActionSheet(context) {
  return CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        onPressed: () async {
          Navigator.pop(context);
          await Navigator.push(
              context, CupertinoPageRoute(builder: (_) => ViewProfilePhoto()));
        },
        child: const Text("View Photo"),
      ),
      CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop("Camera");
        },
        child: const Text("Take Photo"),
      ),
      CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop("Gallery");
        },
        child: const Text("Choose Photo from Gallery"),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Cancel"),
    ),
  );
}
