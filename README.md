# bml_supervisor

A new Flutter application for BML Supervisor.

<!-- Run the dev flavour of the application.-->
flutter run --flavor dev -t lib/main/main_dev.dart
<!-- makes the dev flavour of the application with bookmyloading.in as server and com.mayank.bml_supervisor.dev as package-->
flutter build apk --flavor dev -t lib/main/main_dev.dart

<!-- Run the dev flavour of the application.-->
flutter run --flavor prod -t lib/main/main_prod.dart
<!-- makes the release flavour of the application with bookmyloading.com as server and com.mayank.bml_supervisor as package-->
flutter build apk --flavor prod -t lib/main/main_prod.dart

<!-- FOR VSCODE ONLY -->
<!-- inside vscode folder, make a launch.json, if not made, and then copy below code-->
{
    "version": "0.2.0", <!-- comment this line if you are not using dart sdk version 0.2.0 -->
    "configurations": [
        {
            "name": "bml manager dev",
            "program": "lib/main/main_dev.dart",
            "request": "launch",
            "type": "dart",
            "args": [
                "--flavor",
                "dev"
            ],
        }
        {
            "name": "bml manager prod",
            "program": "lib/main/main_prod.dart",
            "request": "launch",
            "type": "dart",
            "args": [
                "--flavor",
                "prod" 
            ],
        }
    ]
}
