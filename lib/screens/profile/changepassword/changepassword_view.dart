import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/screens/login/login_textfield.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'changepassword_viewmodel.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangePasswordViewModel>.reactive(
      builder: (context, viewModel, child) => SafeArea(
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Change Password',
              style: AppTextStyles.appBarTitleStyle,
            ),
            centerTitle: true,
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 8,
                )
              : BodyWidget(
                  changePasswordViewModel: viewModel,
                ),
        ),
      ),
      viewModelBuilder: () => ChangePasswordViewModel(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  final ChangePasswordViewModel changePasswordViewModel;

  const BodyWidget({Key key, @required this.changePasswordViewModel})
      : super(key: key);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final FocusNode passwordNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode reEnterPasswordNode = FocusNode();
  final TextEditingController reEnterpasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width - 50,
          child: Card(
            color: AppColors.primaryColorShade4,
            elevation: defaultElevation,
            shape: getCardShape(),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 32, left: 32, right: 32, bottom: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    passwordTextField(
                        viewModel: widget.changePasswordViewModel),
                    hSizedBox(20),
                    reEnterPasswordTextField(
                        viewModel: widget.changePasswordViewModel),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Hero(
                            tag: 'test',
                            transitionOnUserGestures: true,
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: ClickableWidget(
                                childColor: AppColors.primaryColorShade5,
                                elevation: defaultElevation,
                                borderRadius: BorderRadius.circular(40),
                                child: Icon(
                                  Icons.done,
                                  color: AppColors.white,
                                ),
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    widget.changePasswordViewModel
                                        .changePassword(
                                            userId: MyPreferences()
                                                .getCredentials(),
                                            password: passwordController.text);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget passwordTextField({ChangePasswordViewModel viewModel}) {
    return loginTextFormField(
      obscureText: viewModel.passwordVisible,
      controller: passwordController,
      focusNode: passwordNode,
      hintText: "Enter new password",
      keyboardType: TextInputType.visiblePassword,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, passwordNode, reEnterPasswordNode);
      },
      onPasswordTogglePressed: (obscureText) {
        viewModel.passwordVisible = !viewModel.passwordVisible;
      },
      validator: (value) {
        if (value.isEmpty) {
          return passwordRequired;
        } else {
          return null;
        }
      },
    );
  }

  Widget reEnterPasswordTextField({ChangePasswordViewModel viewModel}) {
    return Row(
      children: [
        Expanded(
          child: loginTextFormField(
              onPasswordTogglePressed: (obscureText) {
                viewModel.reEnterPasswordVisible =
                    !viewModel.reEnterPasswordVisible;
              },
              obscureText: viewModel.reEnterPasswordVisible,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              controller: reEnterpasswordController,
              focusNode: reEnterPasswordNode,
              hintText: "Re-Enter Password",
              keyboardType: TextInputType.visiblePassword,
              onFieldSubmitted: (_) {
                passwordNode.unfocus();
              },
              validator: (value) {
                if (value.isEmpty) {
                  return passwordRequired;
                } else if (value != passwordController.text) {
                  return "Passwords do not match";
                } else {
                  return null;
                }
              }),
        ),
      ],
    );
  }
}
