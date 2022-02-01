// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zonedriver/app/constants.dart';
import 'package:zonedriver/cubit/update_pass_cubit/update_pass_cubit.dart';
import 'package:zonedriver/cubit/update_pass_cubit/update_pass_state.dart';
import 'package:zonedriver/helpers/lang/language_constants.dart';
import 'package:zonedriver/helpers/utils/myApplication.dart';
import 'package:zonedriver/models/update_pass_model.dart';
import 'package:zonedriver/widgets/btn_widget.dart';
import 'package:zonedriver/widgets/global_appbar_widget.dart';
import 'package:zonedriver/widgets/txtfield_widget.dart';

class CreateNewPassScreen extends StatefulWidget {
  final String token;
  const CreateNewPassScreen({required this.token});
  @override
  _CreateNewPassScreenState createState() => _CreateNewPassScreenState();
}

class _CreateNewPassScreenState extends State<CreateNewPassScreen>
    with TickerProviderStateMixin {
  final TextEditingController passTextEditingController =
      TextEditingController();
  final TextEditingController confirmPassTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscure = true;
  Widget _child = Container();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: GlobalAppBar(
        enableBackButton: false,
        height: size.height * 0.3,
        child: SvgPicture.asset("assets/images/logo.svg",
            height: size.height * 0.21),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            start: 30,
            end: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: size.height * .05, bottom: size.height * .05),
                  child: const Center(
                    child: Text("Create New Password",
                        style: TextStyle(color: Constants.HINT, fontSize: 28)),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("New Password",
                      style: TextStyle(color: Constants.HINT, fontSize: 15)),
                ),
                TxtFieldWidget(
                  labelTxt: "*************",
                  textEditingController: passTextEditingController,
                  isHasNextFocus: true,
                  textInputType: TextInputType.visiblePassword,
                  type: "signup",
                ),
                const SizedBox(height: 5),
                /*Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 3.5,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Constants.primaryAppColor,
                              borderRadius: BorderRadius.circular(5.0)),
                        )
                      ],
                    )
                  ],
                ),*/
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirm Password",
                      style: TextStyle(color: Constants.HINT, fontSize: 15)),
                ),
                TxtFieldWidget(
                  labelTxt: "***************",
                  textEditingController: confirmPassTextEditingController,
                  isHasNextFocus: false,
                  textInputType: TextInputType.visiblePassword,
                  pass: passTextEditingController.text.toString(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/match.svg",
                        fit: BoxFit.fill,
                        color: const Color(0xFF80AF50),
                      ),
                      const Text("Matching Password",
                          style:
                              TextStyle(color: Constants.HINT, fontSize: 10)),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                BlocBuilder<UpdatePassCubit, UpdatePassState>(
                    builder: (context, state) {
                  if (state is UpdatePassLoading) {
                    return Column(
                      children: [
                        SizedBox(height: size.height * 0.06),
                        SpinKitThreeBounce(
                          color: Constants.primaryAppColor,
                          size: size.width * .08,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: size.height * 0.06),
                        BtnWidget(
                          txt: "Change Password",
                          color: Constants.primaryAppColor,
                          onClicked: () async {
                            final FormState form = _formKey.currentState!;
                            if (form.validate()) {
                              if (!await MyApplication.checkConnection()) {
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, 'noInternet')!,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                return;
                              }
                              UpdatePassCubit.context = context;
                              UpdatePassCubit.newPassword =
                                  passTextEditingController.text;
                              UpdatePassCubit.passwordConfirmation =
                                  confirmPassTextEditingController.text;
                              UpdatePassCubit.token = widget.token;
                              BlocProvider.of<UpdatePassCubit>(context)
                                  .UpdatePass();
                            }
                          },
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*void onLoaded(UpdatePassResponse updatePassResponse) {

    if (updatePassResponse.status == true &&
            updatePassResponse.message == "done") {
          // ignore: avoid_print
          print("updatePassResponse====>  success");

        } else {
          // ignore: avoid_print
          print(" failed");
          // ignore: avoid_print
          print("status====> ${updatePassResponse.status.toString()}");
          // ignore: avoid_print
          print("message====> ${updatePassResponse.message.toString()}");
        }
  }*/
}
