
class TValidator{
  static String? validateEmptyText(String? fieldName,String? value){
    if(value == null || value.isEmpty){
      return '$fieldName is required.';
    }

  }







  static String? validateEmail(String? value){
    if (value == null || value.isEmpty){
      return 'email is required';
    }

    final emailRegExp=RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)){
      return 'invalid email address';
    }

    return null;

  }
  static String? validatePassword(String? value){
    if (value==null || value.isEmpty){
      return 'password is required';
    }

    if(value.length<6){
      return 'password must be alteast 6 character long';
    }

    if (!value.contains(RegExp(r'[A-Z]'))){
      return "password must conatin atleast one uppercase letter";
    }

    if (!value.contains(RegExp(r'[0-9]'))){
      return "password must conatin atleast one number";
    }

    if(!value.contains(RegExp(r'[!@#$%^&*(),.?"":{}<>]'))){
      return 'password should contain atleast one special character';
    }
    return null;

  }
  static String? validatePhoneNUmber(String? value){
    if (value == null || value.isEmpty){
      return 'phone number is required';
    }

    final phoneRegExp=RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)){
      return 'Invalid phone number format (10 digit required)';
    }
    return null;
  }
}