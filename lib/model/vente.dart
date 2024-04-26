import 'package:invest_mobile/model/typePackage.dart';

class Vente {
  int id;
  int nbrVente;
  double coutTotal;
  TypePackage typePack;

  Vente(
      {required this.id,
      required this.nbrVente,
      required this.coutTotal,
      required this.typePack});
}
