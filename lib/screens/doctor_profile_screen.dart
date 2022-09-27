import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_app/screens/edit_doctor_profile.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key? key, this.documentSnapshot})
      : super(key: key);
  final DocumentSnapshot? documentSnapshot;

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  DocumentSnapshot? dSnapshot;

  @override
  void initState() {
    setState(() {
      dSnapshot = widget.documentSnapshot;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(70, 212, 153, 1),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditDoctorProfileScreen(documentSnapshot: dSnapshot!),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                children: const [
                  Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Edit Details")
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: ClipOval(
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 66.5,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      widget.documentSnapshot?[
                                          'doctor_profile_picture'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Dr. ${widget.documentSnapshot?['doctor_name']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green.shade300,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 12,
                                  top: 4,
                                  bottom: 4,
                                ),
                                child: Icon(
                                  Icons.thumb_up_alt_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 12,
                                  top: 4,
                                  bottom: 4,
                                ),
                                child: Text(
                                  "92% patients recommend you",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Specialization: ${widget.documentSnapshot?['doctor_specialization']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          "My Consultation Timings",
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
                      doctorTimeTable("Monday",
                          "${widget.documentSnapshot?['consultation_timings']['monday']}"),
                      doctorTimeTable("Tuesday",
                          "${widget.documentSnapshot?['consultation_timings']['tuesday']}"),
                      doctorTimeTable("Wednesday",
                          "${widget.documentSnapshot?['consultation_timings']['wednesday']}"),
                      doctorTimeTable("Thursday",
                          "${widget.documentSnapshot?['consultation_timings']['thursday']}"),
                      doctorTimeTable("Friday",
                          "${widget.documentSnapshot?['consultation_timings']['friday']}"),
                      doctorTimeTable("Saturday",
                          "${widget.documentSnapshot?['consultation_timings']['saturday']}"),
                      doctorTimeTable("Sunday",
                          "${widget.documentSnapshot?['consultation_timings']['sunday']}"),
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
                          "About Me",
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
                        child: Text(
                          widget.documentSnapshot?['doctor_about'],
                          style: const TextStyle(fontSize: 15),
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
    );
  }

  Widget doctorTimeTable(dayName, timings) {
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
          Text(
            timings,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
