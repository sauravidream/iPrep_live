

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/batch_model.dart';

Future showNewMessageBottomSheet({
  required BuildContext context,
  List<Batch>? batchListInfo,
  List<JoinedStudents>? studentsListInfo,
  List<int>? selectedBatchesOrStudentsIndexes,
}) async {
  final TextEditingController _newMessageController = TextEditingController();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
    ),
    // isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (builder) {
      return NewMessageBottomSheetPage(
        batchListInfo: batchListInfo,
        studentsListInfo: studentsListInfo,
        selectedBatchesOrStudentsIndexes: selectedBatchesOrStudentsIndexes,
        messageController: _newMessageController,
      );
    },
  );
}

class NewMessageBottomSheetPage extends StatelessWidget {
  final List<Batch>? batchListInfo;
  final List<JoinedStudents>? studentsListInfo;
  final List<int>? selectedBatchesOrStudentsIndexes;
  final TextEditingController? messageController;
  NewMessageBottomSheetPage(
      {this.batchListInfo,
      this.studentsListInfo,
      this.selectedBatchesOrStudentsIndexes,
      this.messageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 500 / 812 * MediaQuery.of(context).size.height,
        maxHeight: 500 / 812 * MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/images/line.png",
                        width: 40,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Message",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: messageController,
                    autofocus: true,
                    cursorColor: Colors.black87,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                    ),
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20.0),
                      hintText: "Enter your message…",
                      hintStyle: const TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 14,
                      ),
                      border: Constants.newBroadcastInputTextOutline,
                    ),
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                verticalDirection: VerticalDirection.up,
                children: [
                  OnBoardingBottomButton(
                    buttonText: "Send Message",
                    buttonTextFontWeight: 4,
                    topPadding: 32,
                    onPressed: () async {
                      if (messageController!.text.isNotEmpty) {
                        //Call a method here to send message in all the batches
                        bool _response = await (messagingRepository
                            .sendNewMessageToSelectedBatchesOrStudents(
                          batchList: batchListInfo,
                          studentsList: studentsListInfo,
                          selectedBatchesOrStudentsIndexes:
                              selectedBatchesOrStudentsIndexes,
                          messageText: messageController!.text,
                        ) );
                        if (_response) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          SnackbarMessages.showSuccessSnackbar(context,
                              message: Constants.dashboardNewMessageSuccess);
                        } else {
                          SnackbarMessages.showErrorSnackbar(context,
                              error: Constants.dashboardNewMessageSendingError);
                        }
                      } else {
                        SnackbarMessages.showErrorSnackbar(context,
                            error: Constants.dashboardNewMessageNoMessageAlert);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
