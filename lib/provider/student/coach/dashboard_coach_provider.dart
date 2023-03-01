

import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/batch_model.dart';

class DashboardCoachProvider extends ChangeNotifier {
  bool pageLoading = false;
  List<Batch>? batchList;

  Future fetchLoggedInCoachBatches() async {
    pageLoading = true;
    batchList = await (batchRepository.fetchBatchList());
    pageLoading = false;
    notifyListeners();
  }
}
