import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class EditDoctorProfileScreen extends StatefulWidget {
  const EditDoctorProfileScreen({Key? key, required this.documentSnapshot})
      : super(key: key);
  final DocumentSnapshot documentSnapshot;

  @override
  State<EditDoctorProfileScreen> createState() =>
      _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
  DocumentSnapshot? documentSnapshot;
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode? _autoValidate = AutovalidateMode.disabled;
  final FirebaseServices _services = FirebaseServices();
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseStorage storage = FirebaseStorage.instance;
  File? imagePicked;
  String? imgUrl;
  String? profilePicUrl;

  TextEditingController nameController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController mondayTimings = TextEditingController();
  TextEditingController tuesdayTimings = TextEditingController();
  TextEditingController wednesdayTimings = TextEditingController();
  TextEditingController thursdayTimings = TextEditingController();
  TextEditingController fridayTimings = TextEditingController();
  TextEditingController saturdayTimings = TextEditingController();
  TextEditingController sundayTimings = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  @override
  void initState() {
    setState(() {
      documentSnapshot = widget.documentSnapshot;
    });
    setState(() {
      aboutMeController.text = documentSnapshot?['doctor_about'];
      mondayTimings.text = documentSnapshot?['consultation_timings']['monday'];
      tuesdayTimings.text =
          documentSnapshot?['consultation_timings']['tuesday'];
      wednesdayTimings.text =
          documentSnapshot?['consultation_timings']['wednesday'];
      thursdayTimings.text =
          documentSnapshot?['consultation_timings']['thursday'];
      fridayTimings.text = documentSnapshot?['consultation_timings']['friday'];
      saturdayTimings.text =
          documentSnapshot?['consultation_timings']['saturday'];
      sundayTimings.text = documentSnapshot?['consultation_timings']['sunday'];
      nameController.text = documentSnapshot?['doctor_name'];
      specializationController.text =
          documentSnapshot?['doctor_specialization'];
      profilePicUrl = documentSnapshot?['doctor_profile_picture'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    Future galleryImage() async {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      final pickedImageFile = File(pickedImage!.path);
      setState(() {
        imagePicked = pickedImageFile;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(70, 212, 153, 1),
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            autovalidateMode: _autoValidate,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black38,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 64,
                            backgroundImage: imagePicked != null
                                ? FileImage(imagePicked!) as ImageProvider
                                : NetworkImage(
                                    profilePicUrl.toString(),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () {
                            //TODO
                            galleryImage();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    color: Colors.black38)
                              ],
                            ),
                            child: ClipOval(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(70, 212, 153, 1),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Full Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your name";
                              }
                              return null;
                            },
                            cursorColor: const Color.fromRGBO(70, 212, 153, 1),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: nameController,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Specialization",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your specialization";
                              }
                              return null;
                            },
                            cursorColor: const Color.fromRGBO(70, 212, 153, 1),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: specializationController,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Consultation Timings",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          doctorTimeTable("Monday", mondayTimings),
                          doctorTimeTable("Tuesday", tuesdayTimings),
                          doctorTimeTable("Wednesday", wednesdayTimings),
                          doctorTimeTable("Thursday", thursdayTimings),
                          doctorTimeTable("Friday", fridayTimings),
                          doctorTimeTable("Saturday", saturdayTimings),
                          doctorTimeTable("Sunday", sundayTimings),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "About",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, right: 4, left: 4, bottom: 12),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tell something about yourself";
                                }
                                return null;
                              },
                              controller: aboutMeController,
                              cursorColor:
                                  const Color.fromRGBO(70, 212, 153, 1),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Colors.black),
                    backgroundColor: Colors.white),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (imagePicked != null) {
                      progressDialog.show(
                        max: 100,
                        msg: "Uploading Image",
                        progressValueColor:
                            const Color.fromRGBO(70, 212, 153, 1),
                        progressBgColor: Colors.white,
                      );
                      Reference ref = storage.ref().child(
                          "uploads/doctor_profile_picture/doctor_${user?.displayName?.toLowerCase().split(" ")[0]}");
                      UploadTask uploadTask = ref.putFile(imagePicked!);
                      uploadTask.then((res) async {
                        String firebaseStorageUrl =
                            await res.ref.getDownloadURL();
                        setState(() {
                          imgUrl = firebaseStorageUrl.toString();
                          progressDialog.close();
                        });
                      }).then(
                        (value) async => await _services
                            .updateDoctorProfile(
                              doctorId: user?.uid,
                              doctorName: nameController.text,
                              doctorSpecialization:
                                  specializationController.text,
                              doctorAbout: aboutMeController.text,
                              doctorProfilePic: imgUrl == null
                                  ? profilePicUrl
                                  : imgUrl.toString(),
                              mondayTiming: mondayTimings.text,
                              tuesdayTiming: tuesdayTimings.text,
                              wednesdayTiming: wednesdayTimings.text,
                              thursdayTiming: thursdayTimings.text,
                              fridayTiming: fridayTimings.text,
                              saturdayTiming: saturdayTimings.text,
                              sundayTiming: sundayTimings.text,
                            )
                            .then(
                              (value) => {
                                Fluttertoast.showToast(
                                  msg:
                                      "Your profile has been successfully updated",
                                  backgroundColor: Colors.grey.shade200,
                                  textColor: Colors.black,
                                ).then(
                                  (value) => {
                                    Future.delayed(
                                      const Duration(milliseconds: 2000),
                                      () {
                                        Restart.restartApp();
                                      },
                                    ),
                                  },
                                ),
                              },
                            ),
                      );
                    } else {
                      _services
                          .updateDoctorProfile(
                            doctorId: user?.uid,
                            doctorName: nameController.text,
                            doctorSpecialization: specializationController.text,
                            doctorAbout: aboutMeController.text,
                            doctorProfilePic: imgUrl == null
                                ? profilePicUrl
                                : imgUrl.toString(),
                            mondayTiming: mondayTimings.text,
                            tuesdayTiming: tuesdayTimings.text,
                            wednesdayTiming: wednesdayTimings.text,
                            thursdayTiming: thursdayTimings.text,
                            fridayTiming: fridayTimings.text,
                            saturdayTiming: saturdayTimings.text,
                            sundayTiming: sundayTimings.text,
                          )
                          .then(
                            (value) => {
                              Fluttertoast.showToast(
                                msg:
                                    "Your profile has been successfully updated",
                                backgroundColor: Colors.grey.shade200,
                                textColor: Colors.black,
                              ).then(
                                (value) => {
                                  Future.delayed(
                                    const Duration(milliseconds: 2000),
                                    () {
                                      Restart.restartApp();
                                    },
                                  ),
                                },
                              ),
                            },
                          );
                    }
                  } else {
                    setState(() => _autoValidate = AutovalidateMode.always);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: const BorderSide(
                    color: Color.fromRGBO(70, 212, 153, 1),
                  ),
                  backgroundColor: const Color.fromRGBO(70, 212, 153, 1),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Update Details",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doctorTimeTable(dayName, TextEditingController timingController) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 10, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dayName,
            style: const TextStyle(fontSize: 15),
          ),
          SizedBox(
            width: 150,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter $dayName timings";
                }
                return null;
              },
              cursorColor: const Color.fromRGBO(70, 212, 153, 1),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              controller: timingController,
            ),
          )
        ],
      ),
    );
  }
}
