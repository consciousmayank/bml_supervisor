import 'package:bml_supervisor/screens/pickimage/pick_image_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:bml/bml.dart';

class PickImageView extends StatefulWidget {
  final Function onImageSelected;

  const PickImageView({Key key, @required this.onImageSelected})
      : super(key: key);

  @override
  _PickImageViewState createState() => _PickImageViewState();
}

class _PickImageViewState extends State<PickImageView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PickImageViewModel>.reactive(
        onModelReady: (viewModel) =>
            viewModel.setFunction(widget.onImageSelected),
        builder: (context, viewModel, child) => Scaffold(
              body: Container(
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
                child: viewModel.imagePath.length > 0
                    ? Column(
                        children: [
                          viewModel.imagePath.length > 0
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    viewModel.selectedImageFile,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Container(),
                          TextButton(
                              onPressed: () {
                                viewModel.clearImage();
                              },
                              child: Text('Clear Image'))
                        ],
                      )
                    : TextButton.icon(
                        icon: Icon(
                          Icons.camera_enhance_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          ImagePickers.openCamera(
                            cropConfig: CropConfig(
                                enableCrop: true, width: 1, height: 1),
                            compressSize: 900,
                          ).then((Media media) {
                            viewModel.imagePath = media.path;
                          });
                          // List<Media> _listImagePaths = await ImagePickers.pickerPaths(
                          //   galleryMode: GalleryMode.image,
                          //   selectCount: 1,
                          //   showGif: false,
                          //   showCamera: true,
                          //   compressSize: 500,
                          //   uiConfig:
                          //       UIConfig(uiThemeColor: AppColors.primaryColorShade5),
                          //   cropConfig:
                          //       CropConfig(enableCrop: true, width: 1, height: 1),
                          // );
                        },
                        label: Text('Add Image'),
                      ),
              ),
            ),
        viewModelBuilder: () => PickImageViewModel());
  }
}
