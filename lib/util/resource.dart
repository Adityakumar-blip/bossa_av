import 'package:Bossa/util/status.dart';

class Resource<T> {
  late Status status;
  late T? data;
  String message = "";

  Resource(this.status, this.data, this.message);

  Resource.success(
    this.data,
    //  this.message
  ) {
    status = Status.SUCCESS;
  }

  Resource.error(
    this.data,
    // this.message
  ) {
    status = Status.ERROR;
  }

  Resource.loading(this.data, this.message) {
    status = Status.LOADING;
  }

  Resource.loadingEmpty() {
    status = Status.LOADING;
  }
}
