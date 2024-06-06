import 'package:appointment_views/kaizenControls/Medcolors.dart';
import 'package:appointment_views/kaizenControls/MedicoControls.dart';
import 'package:appointment_views/models/PatientSchedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ScheduleCardWidget extends StatelessWidget {
  final PatientSchedule schedule;

  const ScheduleCardWidget({required this.schedule});

  @override
  Widget build(BuildContext context) {
    DateFormat timeFormat = DateFormat('h:mm a');
    String formattedStartTime = timeFormat.format(schedule.startTime);
    String formattedEndTime = timeFormat.format(schedule.endTime);

    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: getGradientColor(schedule.type).headerGradient,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: <Widget>[
            Card(
              color: getGradientColor(schedule.type).headerGradient.colors[1],
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3.2,
                    child: Row(
                      children: <Widget>[
                        MedicoControls.NormalTextCard('   ${schedule.type}')
                      ],
                    ),
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width / 1.6,
                    // color: getGradientColor(schedule.type)
                    //     .headerGradient
                    //     .colors[0],
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        MedicoControls.NormalTextCard(
                          formattedStartTime,
                        ),
                        MedicoControls.NormalTextCard(
                          "  To ",
                        ),
                        MedicoControls.NormalTextCard(
                          formattedEndTime,
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 15),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: getGradientColor(schedule.type).bottomGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // SizedBox(height: 10),
                  _buildScheduleDetails(schedule.type, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleDetails(String caseType, BuildContext context) {
    switch (caseType) {
      case 'Free':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(right: 20, left: 90, top: 20, bottom: 30),
                  child: MedicoControls.CardinsideText("AVAILABLE"),
                ),
              ],
            ),
          ],
        );
      case 'Appointment':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MedicoControls.NormalTextCard(
                  'MR No: ${schedule.patientMRNumber}',
                ),
                MedicoControls.NormalTextCard(
                  ' ',
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: MedicoControls.NormalNameTextCard(
                    'Name: ${schedule.patientName}',
                  ),
                ),
                // MedicoControls.NormalTextCard(
                //   ' ',
                // ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: MedicoControls.NormalTextCard(
                    '${schedule.consultedDoctorName.split('|')[0] == "" ? 'Therapist Name' : 'Doctor Name'}: ${schedule.consultedDoctorName.replaceAll('|', '') ?? 'N/A'}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                splitTextWithNewLine(schedule.treatmentName),
              ],
            ),
            SizedBox(height: 15),
          ],
        );
      case 'Block':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(right: 20, left: 90, top: 20, bottom: 30),
                  child: MedicoControls.CardinsideText(
                      schedule.blockReason.toString()),
                ),
              ],
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget splitTextWithNewLine(String text) {
    if (text == '') {
      return Text('No Treatments');
    } else {
      List<String> splitText = text.split('\$');
      return CardRow(items: splitText);
      // return Expanded(
      //   child: ListView.builder(
      //     itemCount: splitText.length,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         title: Text(splitText[index]),
      //       );
      //     },
      //   ),
      // );
      // Column c = Column();
      // for (int i = 0; i < splitText.length; i++) {
      //   c.children.add(Text(splitText[i].toString()));
      // }
      // return c;
    } //  text.replaceAll('\$', '\n');
  }
}

////
///
class CardRow extends StatelessWidget {
  final List<String> items;

  CardRow({required this.items});

  @override
  Widget build(BuildContext context) {
    // Ensure there are exactly 3 items, filling with empty strings if needed
    final List<String> displayItems = List.from(items);
    while (displayItems.length < items.length) {
      displayItems.add('');
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: displayItems.map((item) {
        return
            //  MedicoControls.NormalNameTextCard(
            //   item,
            // );
            Container(
          // Card(
          // shape: BorderRadius.all(Radius.circular(1)),
          color: Colors.lightBlue,
          margin: EdgeInsets.only(left: 4, bottom: 2),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: MedicoControls.NormalNameTextCard(
              item,
            ),
            // Text(
            //   item,
            //   style: TextStyle(fontSize: 16),
            //   textAlign: TextAlign.center,
            // ),
          ),
          // );
        );
      }).toList(),
    );
  }
}
