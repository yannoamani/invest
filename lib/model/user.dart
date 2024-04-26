class User {
  int id;
  String nom, prenom, phone, email, lieuHabitation, password, picture, identity, bankcard;
  int solde;

  User(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.email,
      required this.lieuHabitation,
      required this.picture,
      required this.identity,
      required this.bankcard,
      required this.password,
      required this.phone,
      required this.solde});
}
