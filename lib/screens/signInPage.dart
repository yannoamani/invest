import 'package:image_picker/image_picker.dart';
import 'package:invest_mobile/routes/route.dart';
import 'package:invest_mobile/util/method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/userProvider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _keyform = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController habitation = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  String nomF = "",
      prenomF = "",
      phoneF = "",
      bankF = "",
      habitationF = "",
      emailF = "",
      passwordF = "",
      confirmPassF = "";
  int _activeStepIndex = 0;
  var identity;

  @override
  void initState() {
    super.initState();
    nom.addListener(() {
      nomF = nom.text;
    });
    prenom.addListener(() {
      prenomF = prenom.text;
    });
    phone.addListener(() {
      phoneF = phone.text;
    });
    bank.addListener(() {
      bankF = bank.text;
    });
    habitation.addListener(() {
      habitationF = habitation.text;
    });
    email.addListener(() {
      emailF = email.text;
    });
    password.addListener(() {
      passwordF = password.text;
    });
    confirmPass.addListener(() {
      confirmPassF = confirmPass.text;
    });
  }

  @override
  void dispose() {
    nom.dispose();
    prenom.dispose();
    phone.dispose();
    habitation.dispose();
    email.dispose();
    password.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          title: Text("Inscription",
              style: customFonts(25, Colors.white, FontWeight.w100)),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.black)),
          child: Form(
            key: _keyform,
            child: Stepper(
              currentStep: _activeStepIndex,
              type: StepperType.horizontal,
              steps: [
                // STEP 1
                Step(
                    state: _activeStepIndex <= 0
                        ? StepState.editing
                        : StepState.complete,
                    isActive: _activeStepIndex >= 0,
                    title: Text(
                      "Etape 1",
                      style: _activeStepIndex >= 0
                          ? TextStyle(fontSize: 14)
                          : TextStyle(fontSize: 12),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          _form(h, "Nom*", TextInputType.name, "Doe", false,
                              (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Entrer votre nom";
                            }
                            return null;
                          }, nom),
                          // SizedBox(height: h * 0.03),
                          _form(h, "Prenom*", TextInputType.name, "John", false,
                              (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Entrer votre prenom";
                            }
                            return null;
                          }, prenom),
                          // SizedBox(height: h * 0.03),
                          _form(h, "Telephone", TextInputType.phone,
                              "0000000000", false, (String? value) {
                            return null;
                          }, phone),
                          _form(h, "N° de carte bancaire", TextInputType.number,
                              "XXXXXXXXXX", false, (String? value) {
                            return null;
                          }, bank),
                          SizedBox(height: h * 0.03),
                        ],
                      ),
                    )),
                // STEP 2
                Step(
                    state: _activeStepIndex <= 1
                        ? StepState.editing
                        : StepState.complete,
                    isActive: _activeStepIndex >= 1,
                    title: Text(
                      "Etape 2",
                      style: _activeStepIndex >= 1
                          ? TextStyle(fontSize: 14)
                          : TextStyle(fontSize: 12),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          _form(h, "Email*", TextInputType.emailAddress,
                              "johnDoe@yahoo.fr", false, (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains("@")) {
                              return "Svp entrer un mail valide";
                            }
                            return null;
                          }, email),
                          _form(h, "Lieu d'habitation*", TextInputType.text,
                              "New york ", false, (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return "Entrer votre lieu d'habitation";
                            }
                            return null;
                          }, habitation),
                          // _identityField(h),
                          SizedBox(height: h * 0.03),
                        ],
                      ),
                    )),
                // STEP 3
                Step(
                    state: _activeStepIndex <= 2
                        ? StepState.editing
                        : StepState.complete,
                    isActive: _activeStepIndex >= 2,
                    title: Text(
                      "Etape 3",
                      style: _activeStepIndex >= 2
                          ? TextStyle(fontSize: 14)
                          : TextStyle(fontSize: 12),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          _form(
                              h,
                              "Mot de passe*",
                              TextInputType.visiblePassword,
                              "***********",
                              true, (String? value) {
                            if (value == null || value.length < 5) {
                              return "Entrer un mot de passe valide";
                            }
                            return null;
                          }, password),
                          SizedBox(height: h * 0.01),
                          verifyField(h, "Une majuscule"),
                          SizedBox(height: h * 0.01),
                          verifyField(h, "Un chiffre"),
                          SizedBox(height: h * 0.01),
                          verifyField(h, "Un caractère spécial"),
                          SizedBox(height: h * 0.01),
                          _form(
                              h,
                              "Confirmez mot de passe*",
                              TextInputType.visiblePassword,
                              "***********",
                              true, (String? value) {
                            if (value == null || value != passwordF) {
                              return "Veillez entré le même mot de passe";
                            }
                            return null;
                          }, confirmPass),
                          SizedBox(height: h * 0.03),
                          Consumer<UserProvider>(
                            builder: (context, value, child) => ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(14)),
                                child: MaterialButton(
                                  onPressed: value.buttonClick
                                      ? () {}
                                      : () {
                                          if (_keyform.currentState!
                                              .validate()) {
                                            context
                                                .read<UserProvider>()
                                                .signInUser(
                                                    nomF,
                                                    prenomF,
                                                    phoneF,
                                                    bankF,
                                                    habitationF,
                                                    emailF,
                                                    passwordF,
                                                    identity)
                                                .then((value) {
                                              if (context
                                                  .read<UserProvider>()
                                                  .error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      context
                                                          .read<UserProvider>()
                                                          .errorMessage,
                                                      style: customFonts(
                                                          14,
                                                          Colors.white,
                                                          FontWeight.bold)),
                                                  backgroundColor: Colors.red,
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Inscription reussit",
                                                            style: customFonts(
                                                                14,
                                                                Colors.white,
                                                                FontWeight
                                                                    .bold)),
                                                        backgroundColor:
                                                            Colors.green,
                                                        duration:
                                                            const Duration(
                                                                seconds: 1)));
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        MyRoute.loginPage,
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                              }
                                            });
                                          }
                                        },
                                  child: value.buttonClick
                                      ? const SpinKitFadingCircle(
                                          color: Colors.white,
                                          size: 25,
                                        )
                                      : Text(
                                          "S'inscrire",
                                          style: customFonts(17, Colors.white,
                                              FontWeight.w200),
                                        ),
                                  color: Colors.black,
                                  minWidth: double.infinity,
                                  height: h * 0.1,
                                )),
                          ),
                          SizedBox(height: h * 0.05)
                        ],
                      ),
                    )),
              ],
              onStepContinue: () {
                if (_activeStepIndex < 2) {
                  _activeStepIndex += 1;
                }
                setState(() {});
              },
              onStepCancel: () {
                if (_activeStepIndex == 0) {
                  return;
                }
                _activeStepIndex -= 1;
                setState(() {});
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return
                    // BOUTTONS: RETOUR ET CONTINUER
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _activeStepIndex > 0
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: h * 0.06, vertical: h * 0.02),
                                backgroundColor: Colors.black),
                            onPressed: details.onStepCancel,
                            child: Text('Retour',
                                style: customFonts(
                                    15, Colors.white, FontWeight.bold)))
                        : Container(),
                    const SizedBox(width: 10),
                    _activeStepIndex < 2
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: h * 0.05, vertical: h * 0.02),
                                backgroundColor: Colors.black),
                            onPressed: details.onStepContinue,
                            child: Text('Continuer',
                                style: customFonts(
                                    15, Colors.white, FontWeight.bold)))
                        : Container(),
                  ],
                );
              },
            ),
          ),
        ));
  }

  Future<void> pickFile() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      identity = result;
    } else {
      // User canceled the picker
    }
  }

  Widget _identityField(h) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(h * 0.02)),
      child: Container(
        padding: EdgeInsets.all(h * 0.01),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pièce d'identité",
              style: customFonts(18, Colors.black, FontWeight.bold),
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  await pickFile();
                },
                child: Row(
                  children: [Icon(Icons.download), Text('Charger')],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Row verifyField(double h, String libelle) {
  return Row(children: [
    const Icon(Icons.near_me_rounded, color: Colors.grey, size: 16),
    SizedBox(width: h * 0.02),
    Text(libelle, style: customFonts(14, Colors.grey, FontWeight.bold))
  ]);
}

Widget _form(double h, String label, TextInputType type, String intText,
    bool useIcon, Function fonct, TextEditingController controller) {
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
                        onPressed: () {},
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
