import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text("Login"),
              ),
            ),
        viewModelBuilder: () => LoginViewModel());
  }
}
