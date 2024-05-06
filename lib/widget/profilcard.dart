import 'package:dio/dio.dart';
import 'package:invest_mobile/providers/login_info.dart';
import 'package:flutter/material.dart';
import 'package:invest_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../util/method.dart';
import 'package:badges/badges.dart' as badges;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

class ProfilCard extends StatefulWidget {
  const ProfilCard({super.key});

  @override
  State<ProfilCard> createState() => _ProfilCardState();
}

class _ProfilCardState extends State<ProfilCard> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Consumer<UserProvider>(builder: (context, value, _) {
      return Card(
        child: SizedBox(
          height: h * 0.25,
          width: w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                height: h * 0.25,
                // width: w * 0.5,
                color: Colors.transparent,
                child: Center(
                    child: badges.Badge(
                  badgeContent: GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: _imagePicker()),
                  position: badges.BadgePosition.bottomStart(),
                  badgeStyle:
                      const badges.BadgeStyle(badgeColor: Colors.transparent),
                  child: value.investisseur.picture.isNotEmpty
                      ? Image.network(
                          "https://backend.invest-ci.com/public/${value.investisseur.picture}",
                          fit: BoxFit.fill,
                        )
                      : null,
                )),
              )),
              Container(
                // color: Colors.grey[300],
                width: w * 0.6,
                height: h * 0.25,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _customText(value.investisseur.nom, 16),
                              _customText(value.investisseur.prenom, 16)
                            ]),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            "images/image/log.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.05,
                    ),
                    _customText(value.investisseur.email, 15),
                    _customText(value.investisseur.phone, 15),
                    _customText(value.investisseur.lieuHabitation, 12)
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Text _customText(String data, double size) {
    return Text(data, style: customFonts(size, Colors.black, FontWeight.w600));
  }

  Widget _imagePicker() {
    return Container(
        width: 35,
        height: 35,
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: const Icon(
          Icons.camera_alt,
          size: 20,
          color: Colors.white,
        ));
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final croppedImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          uiSettings: [IOSUiSettings(), AndroidUiSettings()]);
      await pictureChange(croppedImage);
    }
  }

  Future<void> pictureChange(pictureImage) async {
    var token =
        Provider.of<LoginInfo>(context, listen: false).userToken.toString();
    var user = Provider.of<UserProvider>(context, listen: false).investisseur;
    String url = "https://backend.invest-ci.com/api/update";
    try {
      var body = <String, dynamic>{};
      body['id'] = user.id;
      body['picture'] = await MultipartFile.fromFile(
          pictureImage!.path.toString(),
          filename:
              "profile_pics_user${Random().nextInt(100).toString()}${Random().nextInt(100).toString()}");
      FormData formData = FormData.fromMap(body);
      final dio = Dio();

      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: <String, dynamic>{
            'Authorization': "Bearer $token",
          },
        ),
      );
      if (response.data['status']) {
        // ignore: use_build_context_synchronously
        context.read<UserProvider>().investisseur.picture =
            response.data['data']['picture'];
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Modifié avec succès",
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1)));
        setState(() {});
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.data['message'],
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erreur",
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
      });
    }
  }
}
