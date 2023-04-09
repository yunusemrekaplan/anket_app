mixin UserValidationMixin {
  String? validateFirstOrLastName(String? value) {
    if(value!.length < 2) {
      return "Ad ve soyad en az iki karakter olmalıdır";
    }
    return null;
  }

}