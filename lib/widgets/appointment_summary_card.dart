import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firebase_services.dart';

class AppointmentSummaryCard extends StatefulWidget {
  const AppointmentSummaryCard({Key? key, required this.documentSnapshot})
      : super(key: key);
  final DocumentSnapshot documentSnapshot;

  @override
  State<AppointmentSummaryCard> createState() => _AppointmentSummaryCardState();
}

class _AppointmentSummaryCardState extends State<AppointmentSummaryCard> {
  FirebaseServices services = FirebaseServices();

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Patient Name : ${widget.documentSnapshot["customerName"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Patient Phone No. : ${widget.documentSnapshot["customerPhone"]}",
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(40),
                    //   child: Container(
                    //     color: Colors.white,
                    //     height: 50,
                    //     width: 50,
                    //     child: Image.network(
                    //       widget.documentSnapshot['doctor']
                    //           ['doctorProfilePicture'],
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.black26,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(widget.documentSnapshot['selectedDate'])
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.clock_fill,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(widget.documentSnapshot['selectedTime'])
                        ],
                      ),
                      Row(
                        children: [
                          widget.documentSnapshot['appointment_status'] ==
                                  "Completed"
                              ? const Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                )
                              : ClipOval(
                                  child: Container(
                                    color: widget.documentSnapshot[
                                                'appointment_status'] ==
                                            "Waiting Approval"
                                        ? Colors.amber
                                        : (widget.documentSnapshot[
                                                    'appointment_status'] ==
                                                "Rejected"
                                            ? Colors.red
                                            : (widget.documentSnapshot[
                                                        'appointment_status'] ==
                                                    "Cancelled"
                                                ? Colors.grey
                                                : Colors.green)),
                                    width: 8,
                                    height: 8,
                                  ),
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            // width: 80,
                            child: Text(
                              widget.documentSnapshot['appointment_status'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                widget.documentSnapshot['appointment_status'] == "Completed" ||
                        widget.documentSnapshot['appointment_status'] ==
                            "Cancelled" ||
                        widget.documentSnapshot['appointment_status'] ==
                            "Rejected"
                    ? Container()
                    : (widget.documentSnapshot['appointment_status'] ==
                            "Accepted"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: Colors.grey.shade300),
                                onPressed: () {
                                  _makePhoneCall(
                                      widget.documentSnapshot["customerPhone"]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Text(
                                          "Call Patient",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0),
                                        child: Icon(Icons.call,
                                            size: 25, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor:
                                      const Color.fromRGBO(70, 212, 153, 0.8),
                                ),
                                onPressed: () {
                                  showCustomDialog(
                                      context, "Complete", "Completed");
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      "Mark Completed",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  // width: MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    onPressed: () {
                                      showCustomDialog(
                                          context, "Cancel", "Cancelled");
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                        top: 9.2,
                                        left: 7,
                                        right: 7,
                                        bottom: 9.2,
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  // width: MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 0,
                                      backgroundColor: const Color.fromRGBO(
                                          70, 212, 153, 0.8),
                                    ),
                                    onPressed: () {
                                      showCustomDialog(
                                          context, "Accept", "Accepted");
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                        top: 13.0,
                                        left: 15,
                                        right: 15,
                                        bottom: 13,
                                      ),
                                      child: Text(
                                        "Accept",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  // width: MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 0,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    onPressed: () {
                                      showCustomDialog(
                                          context, "Reject", "Rejected");
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                        top: 9.2,
                                        left: 7,
                                        right: 7,
                                        bottom: 9.2,
                                      ),
                                      child: Text(
                                        "Reject",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  AwesomeDialog showCustomDialog(context, title, appointmentStatus) {
    return AwesomeDialog(
      btnCancelText: "No",
      btnOkText: "Yes",
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.scale,
      title: "$title Appointment",
      desc:
          'Do you really want to ${title.toString().toLowerCase()} the appointment ?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        services.updateOrderStatus(
            widget.documentSnapshot.id, appointmentStatus);
      },
    )..show();
  }
}
