

import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/batch_model.dart';

class JoinedBatchesProvider extends ChangeNotifier {
  List<Batch>? joinedBatches;

  Future fetchJoinedBatches() async {
    joinedBatches =
        await (batchRepository.fetchBatchListJoinedByLoggedInStudents() );
    notifyListeners();
  }
}
