class Validator {
  static String nameValidator(String name) {
    if (name.trim().length < 3) {
      return "Name can not be less than 3 characters.";
    }
    return null;
  }
}
