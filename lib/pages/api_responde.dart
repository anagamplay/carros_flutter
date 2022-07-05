
class ApiResponse<T> {
  bool ok = false;
  String msg = 'a';
  T result;

  ApiResponse.ok(this.result) {
    ok = true;
  }

  ApiResponse.error(this.result) {
    ok = false;
  }
}