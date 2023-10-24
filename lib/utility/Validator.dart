class Validator {

  static String? validateNome({required String? nome}) {
    if (nome == null) {
      return null;
    }

    if (nome.isEmpty) {
      return 'Il campo "Nome" non può essere vuoto!';
    }
    return null;
  }

  static String? validateCognome({required String? cognome}) {
    if (cognome == null) {
      return null;
    }

    if (cognome.isEmpty) {
      return 'Il campo "Cognome" non può essere vuoto!';
    }
    return null;
  }

  static String? validateUsername({required String? username}) {
    if (username == null) {
      return null;
    }

    if (username.isEmpty) {
      return 'Il campo "Username" non può essere vuoto!';
    }
    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Il campo "Email" non può essere vuoto!';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Inserire una Email valida!';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Il campo "Password" non può essere vuoto!';
    } else if (password.length < 6) {
      return 'Inserire una password con una lunghezza di almeno 8 caratteri!';
    }

    return null;
  }

  static String? validateEqualPassword({required String? password, required String? chkPassword}){
    if (password == null || chkPassword == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Il campo "Password" non può essere vuoto!';
    } else if (password.length < 8) {
      return 'Inserire una password con una lunghezza di almeno 8 caratteri!';
    } else if (chkPassword.isEmpty){
      return 'Il campo "Conferma Password" non puà essere vuoto!';
    } else if (chkPassword != password){
      return 'Le password inserite non coincidono!';
    }

    return null;
  }

  static String? validateRequired({required String? value}){
    if (value == null) {
      return null;
    }

    if(value.isEmpty){
      return 'Questo campo non può essere vuoto';
    }

    return null;
  }
}