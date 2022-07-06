class Usuario {
  String login;
  String nome;
  String email;
  String token;
  List<String> roles;

  Usuario.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        nome = json['nome'],
        email = json['email'],
        token = json['token'],
        roles = json['roles'] != null
            ? json['roles'].map<String>((role) => role.toString()).toList()
            : null;

  @override
  String toString() {
    return 'Usuario{login: $login, nome: $nome, email: $email, token: $token, role: $roles}';
  }
}
