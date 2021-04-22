import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/update_user_request.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/profile/userprofile/userprofile_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:bml_supervisor/widget/user_profile_image.dart';
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
                // backgroundColor: AppColors.white,
                appBar: AppBar(
                  title: Text(
                    'Profile',
                    style: AppTextStyles.appBarTitleStyle,
                  ),
                  centerTitle: true,
                ),
                body: Center(
                  child: BodyWidget(
                    userProfileViewModel: viewModel,
                  ),
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
    return widget.userProfileViewModel.isBusy
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ShimmerContainer(
              itemCount: 15,
            ),
          )
        : Column(
            children: [
              hSizedBox(20),
              Hero(
                tag: 'test',
                child: ProfileImageWidget(
                    image: widget.userProfileViewModel.image),
              ),
              hSizedBox(20),
              Text(
                MyPreferences().getUserLoggedIn().userName,
                style: AppTextStyles.latoBold18PrimaryShade5
                    .copyWith(color: AppColors.primaryColorShade5),
              ),
              hSizedBox(8),
              Text(
                '( ${MyPreferences().getUserLoggedIn().role} )',
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
                    widget.userProfileViewModel.userProfile.emailId ?? 'NA',
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
                          width: MediaQuery.of(context).size.width * 0.8,
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
                          ElevatedButton(
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
                                  // print(value);
                                  if (widget
                                      .userProfileViewModel.isEmailUpdate) {
                                    widget.userProfileViewModel
                                        .getUserProfile();
                                    emailController.clear();
                                    widget
                                        .userProfileViewModel.navigationService
                                        .back();
                                    widget
                                        .userProfileViewModel.navigationService
                                        .back();
                                  }
                                });
                              } else {
                                widget.userProfileViewModel.snackBarService
                                    .showSnackbar(message: 'Please fill email');
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: ElevatedButton(
                              child: new Text("Exit"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              DottedDivider(),
              buildListTile(
                title: 'Mobile',
                subTitle: widget.userProfileViewModel.userProfile.mobile,
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
                          width: MediaQuery.of(context).size.width * 0.8,
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
                          ElevatedButton(
                            child: new Text("Update"),
                            onPressed: () {
                              if (mobileNumberController.text.length > 0) {
                                widget.userProfileViewModel
                                    .updateMobileNumber(
                                  request: UpdateUserRequest(
                                    mobile: mobileNumberController.text.trim(),
                                  ),
                                )
                                    .then((value) {
                                  if (widget
                                      .userProfileViewModel.isMobileUpdated) {
                                    widget
                                        .userProfileViewModel.navigationService
                                        .back();
                                    widget
                                        .userProfileViewModel.navigationService
                                        .back();
                                    widget.userProfileViewModel
                                        .getUserProfile();
                                    mobileNumberController.clear();
                                  }
                                });
                              } else {
                                widget.userProfileViewModel.snackBarService
                                    .showSnackbar(
                                        message: 'Please fill mobile number');
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: ElevatedButton(
                              child: new Text("Exit"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              DottedDivider(),
              buildListTile(
                title: 'WhatsApp Number',
                subTitle: widget.userProfileViewModel.userProfile.whatsApp,
                // trailingText: 'Update',
                iconName: whatsAppIcon,
              ),
              DottedDivider(),
              buildListTile(
                  title: 'Change Password',
                  iconName: profile,
                  onTap: () {
                    widget.userProfileViewModel.navigationService
                        .navigateTo(changePasswordRoute);
                  }),
              DottedDivider(),
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
            ],
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
      trailing: trailingText.length == 0
          ? null
          : TextButton(
              onPressed: () {
                onTap.call();
              },
              child: Text(
                trailingText,
                style: AppTextStyles.latoBold14Black.copyWith(
                  color: AppColors.primaryColorShade5,
                ),
              ),
            ),
    );
  }
}
