import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/batch_model.dart';

Future showBroadcastMessageBottomSheet({
  required BuildContext context,
  List<Batch>? batchListInfo,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    // isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (builder) {
      return BroadcastMessageBottomSheetPage(
        batchListInfo: batchListInfo,
      );
    },
  );
}

class BroadcastMessageBottomSheetPage extends StatelessWidget {
  final List<Batch>? batchListInfo;
  BroadcastMessageBottomSheetPage({this.batchListInfo});
  final TextEditingController _newBroadcastMessageController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 705 / 812 * MediaQuery.of(context).size.height,
        maxHeight: 705 / 812 * MediaQuery.of(context).size.height,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
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
                      "New Broadcast",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Send message to",
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 20),
                    padding: const EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    constraints: const BoxConstraints(
                      minWidth: double.maxFinite,
                      maxHeight: 56,
                      minHeight: 56,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      border: Border.all(
                        color: const Color(0xFFDEDEDE),
                      ),
                    ),
                    child: const Text(
                      "All Batches",
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Text(
                    "Message",
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _newBroadcastMessageController,
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    OnBoardingBottomButton(
                      buttonText: "Send Message",
                      buttonTextFontWeight: 4,
                      topPadding: 32,
                      onPressed: () async {
                        if (_newBroadcastMessageController.text.isNotEmpty) {
                          //Call a method here to send message in all the batches
                          bool _response = await (messagingRepository
                              .sendBroadcastMessageToAllBatches(
                            batchList: batchListInfo!,
                            messageText: _newBroadcastMessageController.text,
                          ));
                          if (_response) {
                            Navigator.pop(context);
                            SnackbarMessages.showSuccessSnackbar(context,
                                message: Constants.broadcastMessagingSuccess);
                          } else {
                            SnackbarMessages.showErrorSnackbar(context,
                                error: Constants.broadcastMessagingError);
                          }
                        } else {
                          SnackbarMessages.showErrorSnackbar(context,
                              error: Constants.broadcastMessagingEmptyAlert);
                        }
                      },
                    ),
                    if (MediaQuery.of(context).viewInsets.bottom == 0)
                      const Text(
                        "This message will be sent to each batch individually.",
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
