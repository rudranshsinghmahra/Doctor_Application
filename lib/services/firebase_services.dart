import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  CollectionReference appointments =
      FirebaseFirestore.instance.collection("appointments");

  CollectionReference doctors =
      FirebaseFirestore.instance.collection('doctors');

  Future updateOrderStatus(customerId, appointmentStatus) async {
    await appointments.doc(customerId).update(
      {"appointment_status": appointmentStatus},
    );
  }

  Future updateDoctorProfile({
    doctorId,
    doctorName,
    doctorSpecialization,
    doctorAbout,
    doctorProfilePic,
    mondayTiming,
    tuesdayTiming,
    wednesdayTiming,
    thursdayTiming,
    fridayTiming,
    saturdayTiming,
    sundayTiming,
  }) async {
    await doctors.doc(doctorId).update({
      "doctor_name": doctorName,
      "doctor_specialization": doctorSpecialization,
      "doctor_about": doctorAbout,
      "doctor_profile_picture": doctorProfilePic,
      "consultation_timings": {
        "monday": mondayTiming,
        "tuesday": tuesdayTiming,
        "wednesday": wednesdayTiming,
        "thursday": thursdayTiming,
        "friday": fridayTiming,
        "saturday": saturdayTiming,
        "sunday": sundayTiming,
      }
    });
  }
}
