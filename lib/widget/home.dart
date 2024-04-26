import 'package:invest_mobile/providers/loginInfo.dart';
import 'package:invest_mobile/providers/packProvider.dart';
import 'package:invest_mobile/routes/route.dart';
import 'package:invest_mobile/util/method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invest_mobile/widget/notifCard.dart';
import 'package:provider/provider.dart';

import '../providers/detailsPack.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    context.read<PackProvider>().loadPack();
    return Consumer<PackProvider>(
      builder: (context, value, child) => Consumer<LoginInfo>(
        builder: (context, values, child) => Scaffold(
          backgroundColor: const Color(0xFFF6F6F6),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: Text(
              "Nos packages",
              style: customFonts(24, Colors.white, FontWeight.bold),
            ),
            actions: [
              !values.isOnline
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(MyRoute.loginPage);
                        },
                        child: Text(
                          "Login",
                          style: customFonts(20, Colors.white, FontWeight.bold),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NotifCard(),
                        SizedBox(height: h * 0.01),
                        // RECHERCHE
                        ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(h * 0.02)),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: w * 0.04),
                            padding: EdgeInsets.all(h * 0.01),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: customFonts(
                                  17,
                                  const Color.fromARGB(255, 83, 83, 83),
                                  FontWeight.bold),
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 253, 253, 253),
                                hintText: "rechercher...",
                                hintStyle: customFonts(
                                    17, Colors.grey, FontWeight.bold),
                                suffixIcon: const Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                              cursorColor: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        // PACKAGES
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                            child: Text("Packages",
                                style: customFonts(
                                    20, Colors.black, FontWeight.w300))),
                        SizedBox(height: h * 0.02)
                      ]),
                ),
              ),
              value.isLoad
                  ? const SliverToBoxAdapter(
                      child: SpinKitFadingCircle(
                      color: Colors.black,
                      size: 45,
                    ))
                  : value.pack.length == 0
                      ? SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(
                                height: h * 0.08,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: h * 0.02),
                                child: Text(
                                    "Aucun package pour l'instant, actualisez plutard!!!",
                                    textAlign: TextAlign.center,
                                    style: customFonts(
                                        16, Colors.black, FontWeight.bold)),
                              ),
                              SizedBox(height: h * 0.05),
                              SvgPicture.asset("images/svg/error.svg",
                                  height: 128, width: 128),
                              SizedBox(height: h * 0.06),
                              IconButton(
                                  onPressed: () {
                                    context.read<PackProvider>().isLoad = true;
                                    context.read<PackProvider>().loadPack();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 35,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        )
                      : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: h * 0.014,
                                  childAspectRatio: 0.7),
                          delegate: SliverChildBuilderDelegate(
                              (context, index) => GestureDetector(
                                  onTap: () {
                                    context.read<DetailsPackProv>().statut =
                                        value.pack[index]["sell"];
                                    context.read<DetailsPackProv>().id =
                                        value.pack[index]["id"];
                                    context.read<DetailsPackProv>().libelle =
                                        value.pack[index]["libelle"];
                                    context.read<DetailsPackProv>().cout =
                                        value.pack[index]["cout_acquisition"];
                                    // value.pack[index]["nb_products"]
                                    context.read<DetailsPackProv>().gain =
                                        value.pack[index]["cout_vente"];
                                    // value.pack[index]["nb_products"]
                                    context.read<DetailsPackProv>().nbrProd =
                                        value.pack[index]["nb_products"];
                                    context
                                            .read<DetailsPackProv>()
                                            .prodRestant =
                                        value.pack[index]["pieces_restantes"];
                                    context.read<DetailsPackProv>().period =
                                        value.pack[index]["nb_jours"]
                                            .toString();
                                    context.read<DetailsPackProv>().img = value
                                        .pack[index]["type"]["photo"]
                                        .toString();
                                    context.read<DetailsPackProv>().qteRestant =
                                        value.pack[index]["pieces_restantes"]
                                            .toString();
                                    context.read<DetailsPackProv>().tranche =
                                        value.pack[index]["tranche"];
                                    Navigator.of(context)
                                        .pushNamed(MyRoute.detailPack);
                                  },
                                  child: customCard(
                                      h,
                                      value.pack[index]["libelle"],
                                      value.pack[index]["cout_acquisition"],
                                      value.pack[index]["cout_vente"],
                                      value.pack[index]["type"]["photo"],
                                      value.pack[index]["pieces_restantes"])),
                              childCount: value.pack.length))
            ],
          ),
        ),
      ),
    );
  }
}

Widget customCard(
    double h, String libelle, int cout, int vente, String img, int piece) {
  return SizedBox(
    height: h,
    child: Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(h * 0.02)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(h * 0.02)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(2),
              constraints: BoxConstraints(
                minHeight: h * 0.18,
                minWidth: h * 0.2,
              ),
              // child: Image.network(""),

              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://backend.invest-ci.com/public/' + img),
                      // AssetImage("images/image/img1.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(h * 0.02),
                      topRight: Radius.circular(h * 0.02))),
            ),
            Padding(
              padding: EdgeInsets.only(left: h * 0.01, top: h * 0.001),
              child: Text(libelle,
                  style: customFonts(16, Colors.black, FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(left: h * 0.01, top: h * 0.001),
              child: Text("Coût : $cout cfa",
                  style: customFonts(16, Colors.black, FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(left: h * 0.01, top: h * 0.001),
              child: Text("Gain : $vente cfa",
                  style: customFonts(16, Colors.black, FontWeight.bold)),
            ),
            piece == 0
                ? Container(
                    // padding: EdgeInsets.only(top: h * 0.01),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text('Pièce epuisé',
                        style: customFonts(17, Colors.white, FontWeight.bold)),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: h * 0.01, top: h * 0.001),
                    child: Text("Pièces en stock: $piece",
                        style: customFonts(16, Colors.black, FontWeight.bold)),
                  ),
            Padding(
              padding: EdgeInsets.only(left: h * 0.01, top: h * 0.01),
            ),
          ],
        ),
      ),
    ),
  );
}
