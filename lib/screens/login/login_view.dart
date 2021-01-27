import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'login_textfield.dart';
import 'login_viewmodel.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.preferences.getUserLoggedIn().then((value) {
            if (value != null && value.isUserLoggedIn) {
              viewModel.takeToDashBoard();
            }
          });
        },
        builder: (context, viewModel, child) => Scaffold(
              backgroundColor: AppColors.primaryColorShade5,
              body: getBody(context: context, viewModel: viewModel),
            ),
        viewModelBuilder: () => LoginViewModel());
  }

  Widget getBody({BuildContext context, LoginViewModel viewModel}) {
    return ListView(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.only(top: 30, bottom: 60),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  bmlIcon,
                  height: 50,
                  width: 50,
                ),
                Text(
                  "BookMyLoading",
                  style: AppTextStyles.latoMediumItalics20,
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    loginIconIcon,
                    height: 143,
                  ),
                  hSizedBox(20),
                  userNameTextField(),
                  hSizedBox(20),
                  passwordTextField(viewModel: viewModel),
                  hSizedBox(20),
                  SizedBox(
                    height: buttonHeight,
                    child: AppButton(
                        borderRadius: curvedBorder,
                        borderColor: AppColors.primaryColorShade1,
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            viewModel.login(
                                userName: userNameController.text,
                                password: passwordController.text);
                          }
                        },
                        background: AppColors.primaryColorShade5,
                        buttonText: 'Log In'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: InkWell(
                      onTap: () {
                        viewModel.snackBarService.showSnackbar(
                            message: "Forgot Password Coming soon.");
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: AppTextStyles.underLinedText,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget userNameTextField() {
    return loginTextFormField(
        controller: userNameController,
        focusNode: userNameFocusNode,
        hintText: "UserName",
        keyboardType: TextInputType.text,
        onFieldSubmitted: (_) {
          fieldFocusChange(
            context,
            userNameFocusNode,
            passwordFocusNode,
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return textRequired;
          } else {
            return null;
          }
        });
  }

  Widget passwordTextField({LoginViewModel viewModel}) {
    return Stack(
      children: [
        loginTextFormField(
            obscureText: viewModel.hidePassword,
            // formatter: <TextInputFormatter>[
            //   LengthLimitingTextInputFormatter(4)
            // ],
            controller: passwordController,
            focusNode: passwordFocusNode,
            hintText: "Password",
            keyboardType: TextInputType.visiblePassword,
            onFieldSubmitted: (_) {
              passwordFocusNode.unfocus();
            },
            validator: (value) {
              if (value.isEmpty) {
                return textRequired;
              }
              /*else if (value.length < 8) {
                return 'Password too short.';
              }*/
              else {
                return null;
              }
            }),
        Positioned(
          right: 20,
          top: 3,
          bottom: 3,
          child: IconButton(
            icon: Icon(Icons.remove_red_eye_rounded),
            color: viewModel.hidePassword ? Colors.black : Colors.blueGrey,
            onPressed: () {
              viewModel.hidePassword = !viewModel.hidePassword;
            },
          ),
        )
      ],
    );
  }
}
