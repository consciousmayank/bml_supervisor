import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/pickimage/pick_image_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:stacked/stacked.dart';

class PickImageView extends StatefulWidget {
  @override
  _PickImageViewState createState() => _PickImageViewState();
}

class _PickImageViewState extends State<PickImageView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PickImageViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              body: InkWell(
                onTap: () async {
                  List<Media> _listImagePaths = await ImagePickers.pickerPaths(
                    galleryMode: GalleryMode.image,
                    selectCount: 1,
                    showGif: false,
                    showCamera: true,
                    compressSize: 500,
                    uiConfig:
                        UIConfig(uiThemeColor: AppColors.primaryColorShade5),
                    cropConfig:
                        CropConfig(enableCrop: true, width: 1, height: 1),
                  );

                  viewModel.imagePath = _listImagePaths.first.path;
                },
                child: Stack(
                  children: [
                    viewModel.imagePath.length > 0
                        ? Image.file(
                            viewModel.selectedImageFile,
                            fit: BoxFit.fill,
                          )
                        : Container(),
                    viewModel.base64ImageString.length > 0
                        ? Text(viewModel.base64ImageString)
                        : Container(),
                    Container(
                      padding: EdgeInsets.all(20),
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: viewModel.imagePath.length > 0
                            ? Colors.transparent
                            : AppColors.appScaffoldColor,
                        border: Border.all(
                          color: AppColors.primaryColorShade5,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(
                              0.15,
                            ),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => PickImageViewModel());
  }
}
