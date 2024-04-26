import 'package:invest_mobile/util/method.dart';
import 'package:invest_mobile/widget/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({Key? key}) : super(key: key);

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  TextEditingController controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String text = "";

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      text = controller.text;
      print(text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.06),
          height: h,
          width: w,
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.05,
                ),
                SvgPicture.asset(
                  "images/svg/password.svg",
                  height: 128,
                  width: 128,
                ),
                SizedBox(
                  height: h * 0.08,
                ),
                Text("Mot de passe oublié!!!",
                    style: customFonts(25, Colors.black, FontWeight.bold)),
                SizedBox(height: h * 0.01),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text:
                          "Veillez renseigner votre mail, pour recevoir un lien afin de modifier votre mot de passe",
                      style: customFonts(20, Colors.grey, FontWeight.w200))
                ])),
                SizedBox(height: h * 0.06),
                TextFormField(
                  controller: controller,
                  validator: ((value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains("@")) {
                      return "Entrer un mail valide!!!";
                    }
                    return null;
                  }),
                  keyboardType: TextInputType.text,
                  style: customFonts(17, const Color.fromARGB(255, 83, 83, 83),
                      FontWeight.bold),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 253, 253, 253),
                    hintText: "JohnDoe@yahoo.fr",
                    hintStyle: customFonts(17, Colors.grey, FontWeight.bold),
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  cursorColor: Colors.grey,
                ),
                SizedBox(height: h * 0.06),
                CustomButton(
                    h: h,
                    label: "Envoyer",
                    touch: () {
                      if (_formkey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Info!!",
                                style: customFonts(
                                    18, Colors.black, FontWeight.bold)),
                            content: Text(
                                "Le lien pour pouvoir modifier votre mot de passe à été envoyé à :\n$text",
                                style: customFonts(
                                    16, Colors.black, FontWeight.bold)),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Ok",
                                      style: customFonts(
                                          16, Colors.black, FontWeight.bold)))
                            ],
                          ),
                        );
                      }
                    },
                    colorBtn: Colors.black,
                    textColor: Colors.white)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
