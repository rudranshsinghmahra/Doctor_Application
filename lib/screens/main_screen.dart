import 'dart:async';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_app/provider.dart';
import 'package:doctors_app/services/firebase_services.dart';
import 'package:doctors_app/widgets/appointment_summary_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/auth_bloc.dart';
import 'doctor_profile_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseServices service = FirebaseServices();
  OrderProvider orderProvider = OrderProvider();
  StreamSubscription<User?>? loginStateSubscription;
  User? user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Appointments',
    'Waiting Approval',
    'Accepted',
    'Cancelled',
    'Rejected',
    'Completed',
  ];

  String doctorName = "";
  String doctorSpecialization = "";
  String doctorProfilePic = "";
  DocumentSnapshot? dSnapshot;
  bool isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  fetchDoctorData() async {
    CollectionReference doctorData =
        FirebaseFirestore.instance.collection('doctors');
    DocumentSnapshot documentSnapshot = await doctorData.doc(user?.uid).get();
    setState(() {
      doctorName = documentSnapshot['doctor_name'];
      doctorSpecialization = documentSnapshot['doctor_specialization'];
      doctorProfilePic = documentSnapshot['doctor_profile_picture'];
      dSnapshot = documentSnapshot;
    });
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    var authBloc = Provider.of<AuthBloc>(context, listen: false);

    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
    fetchDoctorData();
    toggleDrawer();
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(70, 212, 153, 1),
        title: Text(doctorName.toString()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ChipsChoice<int>.single(
            value: tag,
            onChanged: (val) {
              if (val == 0) {
                setState(() {
                  orderProvider.status == null;
                });
              }
              setState(() {
                tag = val;
                orderProvider.status = options[val];
              });
            },
            choiceItems: C2Choice.listFrom<int, String>(
              source: options,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
            choiceStyle: const C2ChipStyle(backgroundColor: Colors.green)
          ),
          StreamBuilder<QuerySnapshot>(
            stream: service.appointments
                .where('doctor.doctorId', isEqualTo: user?.uid)
                .where('appointment_status',
                    isEqualTo: tag == 0 ? null : orderProvider.status)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something Went Wrong');
              }
              if (snapshot.data?.size == 0) {
                //TODO: No Appointments screen
                return Expanded(
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        tag > 0
                            ? "No ${options[tag]} Appointments"
                            : "No Appointments Currently",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: SizedBox(
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Color.fromRGBO(80, 212, 153, 1),
                    )),
                  ),
                );
              }

              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return AppointmentSummaryCard(documentSnapshot: document);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          children: [
            isLoading
                ? Container(
                    color: const Color.fromRGBO(80, 212, 153, 1),
                    height: 198,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(80, 212, 153, 1),
                    ),
                    accountName: Text(
                      doctorName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    accountEmail: Text(doctorSpecialization,
                        style: const TextStyle(color: Colors.white70)),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: ClipOval(
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromRGBO(80, 212, 153, 1),
                          radius: 32,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              doctorProfilePic,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorProfileScreen(
                      documentSnapshot: dSnapshot,
                    ),
                  ),
                ).then((value) => {
                      toggleDrawer(),
                    });
              },
              leading: const Icon(
                CupertinoIcons.profile_circled,
                size: 30,
                color: Color.fromRGBO(70, 212, 153, 1),
              ),
              title: const Text(
                "Doctor's Profile",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
