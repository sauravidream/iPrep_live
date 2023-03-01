import '../../../model/iprep_store_model/categories_model.dart';

abstract class IStoreRepository {
  Future<Category>? read();
  Future watchUncompleted();
  Future create();
  Future update();
  Future delete();
}
