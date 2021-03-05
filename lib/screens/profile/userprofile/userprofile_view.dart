import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/profile/userprofile/userprofile_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProfileViewModel>.reactive(
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
              padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
              child: Column(
                children: [
                  Hero(
                    tag: 'test',
                    child: Transform.translate(
                      offset: Offset(0, -20),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColors.primaryColorShade5),
                        child: Image.asset(
                          bmlIcon,
                          height: bmlIconDrawerIconHeight,
                          width: bmlIconDrawerIconWidth,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    MyPreferences().getUserLoggedIn().userName,
                    style: AppTextStyles.latoBold18PrimaryShade5
                        .copyWith(color: AppColors.white),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        drawerList(
                          text: "Change Password",
                          onTap: () {
                            widget.userProfileViewModel.navigationService
                                .navigateTo(changePasswordRoute);
                          },
                        ),
                        drawerList(
                          text: "Logout",
                          onTap: () {
                            MyPreferences().setLoggedInUser(null);
                            MyPreferences().saveCredentials(null);
                            widget.userProfileViewModel.navigationService
                                .replaceWith(logInPageRoute);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
