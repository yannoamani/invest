import 'package:invest_mobile/model/achat.dart';
import 'package:invest_mobile/model/vente.dart';

class Rapport {
  int id;
  int nbrProduitVendu;
  double cout;
  Achat achat;
  Vente vente;

  Rapport(
      {required this.id,
      required this.nbrProduitVendu,
      required this.cout,
      required this.achat,
      required this.vente});
}
