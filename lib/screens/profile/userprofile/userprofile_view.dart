import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/update_user_request.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/profile/userprofile/userprofile_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProfileViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getUserProfile();
        },
        builder: (context, viewModel, child) => SafeArea(
              bottom: true,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Profile',
                    style: AppTextStyles.appBarTitleStyle,
                  ),
                  centerTitle: true,
                ),
                body: BodyWidget(
                  userProfileViewModel: viewModel,
                ),
              ),
            ),
        viewModelBuilder: () => UserProfileViewModel());
  }
}

class BodyWidget extends StatefulWidget {
  final UserProfileViewModel userProfileViewModel;

  const BodyWidget({Key key, @required this.userProfileViewModel})
      : super(key: key);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  TextEditingController mobileNumberController = TextEditingController();
  FocusNode updateUserMobileFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: widget.userProfileViewModel.isBusy
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ShimmerContainer(
                itemCount: 15,
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: AppColors.white,
                elevation: defaultElevation,
                shape: getCardShape(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Hero(
                        tag: 'test',
                        child: Transform.translate(
                          offset: Offset(0, -40),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: AppColors.white,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.primaryColorShade5,
                                    width: 3),
                                borderRadius: BorderRadius.circular(40),
                                color: AppColors.appScaffoldColor,
                              ),
                              child: Image.memory(
                                widget.userProfileViewModel.image,
                                // fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        MyPreferences().getUserLoggedIn().userName,
                        style: AppTextStyles.latoBold18PrimaryShade5
                            .copyWith(color: AppColors.primaryColorShade5),
                      ),
                      hSizedBox(8),
                      Text(
                        MyPreferences().getUserLoggedIn().role,
                        style: AppTextStyles.latoBold18PrimaryShade5
                            .copyWith(fontSize: 10),
                      ),
                      hSizedBox(32),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.primaryColorShade5,
                      ),
                      buildListTile(
                        title: 'Email',
                        subTitle:
                            widget.userProfileViewModel.userProfile.emailId,
                        trailingText: 'Update',
                        iconName: email,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("Enter New Email ID"),
                                content: SizedBox(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    children: [
                                      getUserEmailTextField(
                                        context: context,
                                        viewModel: widget.userProfileViewModel,
                                        // node: node,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  RaisedButton(
                                    child: new Text("Update"),
                                    onPressed: () {
                                      if (emailController.text.length > 0) {
                                        widget.userProfileViewModel
                                            .updateEmail(
                                          request: UpdateUserRequest(
                                            email: emailController.text.trim(),
                                          ),
                                        )
                                            .then((value) {
                                          print(value);
                                          if (widget.userProfileViewModel
                                              .isEmailUpdate) {
                                            widget.userProfileViewModel
                                                .getUserProfile();
                                            emailController.clear();
                                            //todo: Dialog box is not closing
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      } else {
                                        widget.userProfileViewModel
                                            .snackBarService
                                            .showSnackbar(
                                                message: 'Please fill email');
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      _BuildDivider(),

                      buildListTile(
                        title: 'Mobile',
                        subTitle:
                            widget.userProfileViewModel.userProfile.mobile,
                        trailingText: 'Update',
                        iconName: phoneNumber,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("Enter New Mobile Number"),
                                content: SizedBox(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    children: [
                                      getMobileNumberTextField(
                                        context: context,
                                        viewModel: widget.userProfileViewModel,
                                        // node: node,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  RaisedButton(
                                    child: new Text("Update"),
                                    onPressed: () {
                                      if (mobileNumberController.text.length >
                                          0) {
                                        widget.userProfileViewModel
                                            .updateMobileNumber(
                                          request: UpdateUserRequest(
                                            mobile: mobileNumberController.text
                                                .trim(),
                                          ),
                                        )
                                            .then((value) {
                                          if (widget.userProfileViewModel
                                              .isMobileUpdated) {
                                            //todo: Dialog box is not closing
                                            Navigator.pop(context);
                                            widget.userProfileViewModel
                                                .getUserProfile();
                                            mobileNumberController.clear();
                                          }
                                        });
                                      } else {
                                        widget.userProfileViewModel
                                            .snackBarService
                                            .showSnackbar(
                                                message:
                                                    'Please fill mobile number');
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      _BuildDivider(),

                      buildListTile(
                          title: 'Change Password',
                          iconName: profile,
                          onTap: () {
                            widget.userProfileViewModel.navigationService
                                .navigateTo(changePasswordRoute);
                          }),
                      _BuildDivider(),

                      buildListTile(
                          title: 'Log Out',
                          iconName: logout,
                          onTap: () {
                            MyPreferences().setLoggedInUser(null);
                            MyPreferences().saveCredentials(null);
                            MyPreferences().saveSelectedClient(null);
                            widget.userProfileViewModel.navigationService
                                .clearStackAndShow(logInPageRoute);
                          }),
                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.max,
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       _ProfileTile(
                      //           title: "Change Password",
                      //           onTap: () {
                      //             widget.userProfileViewModel.navigationService
                      //                 .navigateTo(changePasswordRoute);
                      //           }),
                      //       // _ProfileTile(
                      //       //     title: "Change Client",
                      //       //     onTap: () {
                      //       //       MyPreferences().saveSelectedClient(null);
                      //       //       widget.userProfileViewModel.navigationService
                      //       //           .clearStackAndShow(clientSelectPageRoute);
                      //       //     }),
                      //       _ProfileTile(
                      //           title: "Logout",
                      //           onTap: () {
                      //             MyPreferences().setLoggedInUser(null);
                      //             MyPreferences().saveCredentials(null);
                      //             MyPreferences().saveSelectedClient(null);
                      //             widget.userProfileViewModel.navigationService
                      //                 .clearStackAndShow(logInPageRoute);
                      //           }),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )),
    );
  }

  getMobileNumberTextField({
    BuildContext context,
    UserProfileViewModel viewModel,
    dynamic node,
  }) {
    return appTextFormField(
      // onEditingComplete: () => node.nextFoucus(),
      maxLines: 1,
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(10),
      ],
      controller: mobileNumberController,
      focusNode: updateUserMobileFocusNode,
      onFieldSubmitted: (_) {
        updateUserMobileFocusNode.unfocus();
      },
      hintText: 'Mobile Number',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  getUserEmailTextField({
    BuildContext context,
    UserProfileViewModel viewModel,
    dynamic node,
  }) {
    return appTextFormField(
      maxLines: 1,
      enabled: true,
      controller: emailController,
      focusNode: emailFocusNode,
      onFieldSubmitted: (_) {
        emailFocusNode.unfocus();
      },
      hintText: 'Email ID',
      //S.of(context).description,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  ListTile buildListTile(
      {@required String iconName,
      @required String title,
      String subTitle,
      String trailingText = '',
      Function onTap}) {
    return ListTile(
        onTap: onTap != null ? onTap : null,
        isThreeLine: false,
        dense: true,
        leading: IconBlueBackground(
          iconName: iconName,
        ),
        title: title != null
            ? Text(
                title,
                style: subTitle == null
                    ? AppTextStyles.latoBold14Black.copyWith(
                        color: AppColors.primaryColorShade5,
                      )
                    : AppTextStyles.latoMedium12Black.copyWith(
                        color: AppColors.primaryColorShade5,
                      ),
              )
            : Container(),
        subtitle: subTitle != null
            ? Text(
                subTitle,
                style: AppTextStyles.latoBold14Black.copyWith(
                  color: AppColors.primaryColorShade5,
                ),
              )
            : Container(),
        trailing: InkWell(
          onTap: onTap,
          child: Text(
            trailingText,
            style: AppTextStyles.latoBold14Black.copyWith(
              color: AppColors.primaryColorShade5,
            ),
          ),
        ));
  }
}

class _BuildDivider extends StatelessWidget {
  const _BuildDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.primaryColorShade5,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String title;
  final Function onTap;

  const _ProfileTile({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: ClickableWidget(
          elevation: defaultElevation,
          borderRadius: getBorderRadius(),
          onTap: () {
            onTap.call();
          },
          child: Center(child: Text(title)),
        ),
      ),
    );
  }
}
