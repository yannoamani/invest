import 'package:invest_mobile/routes/route.dart';
import 'package:invest_mobile/util/method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/login_info.dart';
import '../providers/user_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _keyform = GlobalKey<FormState>();
  final controlleText1 = TextEditingController();
  final controlleText2 = TextEditingController();
  String mail = "", pass = "";

  @override
  void initState() {
    super.initState();
    controlleText1.addListener(() {
      mail = controlleText1.text;
    });
    controlleText2.addListener(() {
      pass = controlleText2.text;
    });
  }

  @override
  void dispose() {
    controlleText1.dispose();
    controlleText2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: h,
          width: w,
          decoration: const BoxDecoration(color: Colors.black),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.black,
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    padding:
                        EdgeInsets.fromLTRB(w * 0.05, h * 0.02, w * 0.05, 0),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 246, 246, 246),
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(90))),
                    child: Column(
                      children: [
                        Text("Se connecter",
                            style:
                                customFonts(35, Colors.black, FontWeight.bold)),
                        SizedBox(height: h * 0.02),
                        Form(
                            key: _keyform,
                            child: Column(children: [
                              _form(h, "Email", TextInputType.emailAddress,
                                  "JohnDoe@yahoo.fr", false, (String? value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains("@")) {
                                  return "Svp entrer un mail valide";
                                }
                                return null;
                              }, controlleText1),
                              SizedBox(height: h * 0.01),
                              _form(
                                  h,
                                  "Mot de passe",
                                  TextInputType.visiblePassword,
                                  "**********",
                                  true, (String? value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6) {
                                  return "Entrer un mot de passe valide";
                                }
                                return null;
                              }, controlleText2),
                              SizedBox(height: h * 0.02),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              MyRoute.forgetPassword);
                                        },
                                        child: Text(
                                          "Mot de passe oublier?",
                                          style: customFonts(
                                              14, Colors.grey, FontWeight.bold),
                                        ))
                                  ]),
                              SizedBox(height: h * 0.02),
                              Consumer<UserProvider>(
                                builder: (context, value, child) => ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(14)),
                                    child: MaterialButton(
                                      onPressed: value.buttonClick
                                          ? () {}
                                          : () {
                                              if (_keyform.currentState!
                                                  .validate()) {
                                                context
                                                    .read<UserProvider>()
                                                    .logInUser(mail, pass)
                                                    .whenComplete(() {
                                                  if (context
                                                      .read<UserProvider>()
                                                      .error) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Erreur de connection...",
                                                                style: customFonts(
                                                                    14,
                                                                    Colors
                                                                        .white,
                                                                    FontWeight
                                                                        .bold)),
                                                            backgroundColor:
                                                                Colors.red,
                                                            duration:
                                                                const Duration(
                                                                    seconds:
                                                                        1)));
                                                  } else {
                                                    ScaffoldMessenger
                                                            .of(context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Bienvenue !",
                                                                style: customFonts(
                                                                    14,
                                                                    Colors
                                                                        .white,
                                                                    FontWeight
                                                                        .bold)),
                                                            backgroundColor:
                                                                Colors.green,
                                                            duration:
                                                                const Duration(
                                                                    seconds:
                                                                        1)));
                                                    context
                                                        .read<LoginInfo>()
                                                        .login(
                                                            true,
                                                            value.token,
                                                            value.investisseur
                                                                .id)
                                                        .then((val) {
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              MyRoute.homePage,
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                      color: Colors.black,
                                      minWidth: double.infinity,
                                      height: h * 0.1,
                                      child: value.buttonClick
                                          ? const SpinKitFadingCircle(
                                              color: Colors.white,
                                              size: 25,
                                            )
                                          : Text(
                                              "Login",
                                              style: customFonts(
                                                  17,
                                                  Colors.white,
                                                  FontWeight.w200),
                                            ),
                                    )),
                              )
                            ])),
                        SizedBox(height: h * 0.02),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Vous n'avez pas de compte?",
                              style:
                                  customFonts(15, Colors.grey, FontWeight.w100),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(MyRoute.signIn);
                                },
                                child: Text("S'inscrire",
                                    style: customFonts(
                                        17, Colors.black, FontWeight.bold)))
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(double h, String label, TextInputType type, String intText,
      bool useIcon, Function fonct, TextEditingController controller) {
    var show = true;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(h * 0.02)),
      child: Container(
        padding: EdgeInsets.all(h * 0.01),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: customFonts(20, Colors.black, FontWeight.bold)),
            SizedBox(height: h * 0.003),
            TextFormField(
              obscureText: useIcon,
              controller: controller,
              keyboardType: type,
              style: customFonts(
                  17, const Color.fromARGB(255, 83, 83, 83), FontWeight.bold),
              validator: (value) => fonct(value),
              decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 232, 232, 232),
                  hintText: intText,
                  hintStyle: customFonts(17, Colors.grey, FontWeight.bold),
                  suffixIcon: useIcon
                      ? IconButton(
                          onPressed: () {
                            show = !show;
                          },
                          icon: const Icon(
                            Icons.visibility,
                            size: 24,
                            color: Colors.grey,
                          ),
                        )
                      : null),
              cursorColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
