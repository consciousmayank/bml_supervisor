import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/add_driver.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/screens/driver/add/add_driver_viewmodel.dart';
import 'package:bml_supervisor/screens/driver/view/drivers_list_viewmodel.dart';
import 'package:bml_supervisor/screens/pickimage/pick_image_view.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:bml_supervisor/widget/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DriversListView extends StatefulWidget {
  @override
  _DriversListViewState createState() => _DriversListViewState();
}

class _DriversListViewState extends State<DriversListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DriversListViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getDriversList(showLoading: true),
      builder: (context, viewModel, child) => SafeArea(
        left: false,
        right: false,
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: setAppBarTitle(title: 'Drivers List'),
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 20,
                )
              : AddDriverBodyWidget(
                  viewModel: viewModel,
                ),
        ),
      ),
      viewModelBuilder: () => DriversListViewModel(),
    );
  }
}

class AddDriverBodyWidget extends StatefulWidget {
  final DriversListViewModel viewModel;

  const AddDriverBodyWidget({Key key, @required this.viewModel})
      : super(key: key);

  @override
  _AddDriverBodyWidgetState createState() => _AddDriverBodyWidgetState();
}

class _AddDriverBodyWidgetState extends State<AddDriverBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: LazyLoadScrollView(
          scrollOffset: 300,
          onEndOfPage: () =>
              widget.viewModel.getDriversList(showLoading: false),
          child:  ListView.builder(
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addDriverView(
                      iconName: addIcon,
                      text: "Add New Driver",
                      onTap: () {
                        widget.viewModel.onAddDriverClicked();
                      },
                    ),
                    hSizedBox(5),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Drivers List',
                        style: AppTextStyles.latoBold14primaryColorShade6,
                      ),
                    ),
                    buildSearchDriverTextFormField(viewModel: widget.viewModel),
                    hSizedBox(5),
                  ],
                );
              }
              if (index == 1) {
                return Container(
                  color: AppColors.primaryColorShade5,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Expanded(
                      //   child: Text(
                      //     ('S.No'),
                      //     textAlign: TextAlign.start,
                      //     style: AppTextStyles.whiteRegular,
                      //   ),
                      // ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          ('VEHICLE NO.'),
                          textAlign: TextAlign.left,
                          style: AppTextStyles.whiteRegular,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            ('DRIVER NAME'),
                            textAlign: TextAlign.left,
                            style: AppTextStyles.whiteRegular,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'EXP(YRS)',
                          textAlign: TextAlign.right,
                          style: AppTextStyles.whiteRegular,
                        ),
                      ),
                    ],
                  ),
                );
              }
              index -= 2;
              return buildDriverCardWithPic(context, index);
            },
            itemCount: widget.viewModel.driversList.length + 2,
          )),
    );
  }

  Widget buildDriverCardWithPic(BuildContext context, int index) {
    String driverName =
        '${widget.viewModel.driversList[index].firstName.toUpperCase()} ${widget.viewModel.driversList[index].lastName.toUpperCase()}';

    if(driverName.length>15){
      driverName = driverName.characters.take(15).toString() + '...';
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.viewModel.openDriverDetailsBottomSheet(
              selectedDriverIndex: index,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(flex: 0.5, child: Text('${index}')),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${widget.viewModel.driversList[index].vehicleId.toUpperCase()}',
                    textAlign: TextAlign.left,
                    // style: AppTextStyles.latoMedium14Black.copyWith(color: AppColors.primaryColorShade5),

                    // style: AppTextStyles.underLinedText.copyWith(
                    //     color: AppColors.primaryColorShade5, fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    driverName,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      // alignment: Alignment.,
                      padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColorShade5,
                        borderRadius: getBorderRadius(),
                      ),
                      child: Text(
                        widget.viewModel.driversList[index].workExperienceYr
                            .toString(),
                        style: AppTextStyles.whiteRegular,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        DottedDivider()
      ],
    );
    // Card(
    //         shape: getCardShape(),
    //         margin: getSidePadding(context: context),
    //         child: InkWell(
    //           onTap: () {
    //             widget.viewModel.openDriverDetailsBottomSheet(
    //               selectedDriverIndex: index,
    //             );
    //           },
    //           child: Row(
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: ProfileImageWidget(
    //                   image: widget.viewModel.driversList[index].photo !=
    //                               null &&
    //                           widget.viewModel.driversList[index].photo
    //                                   .length ==
    //                               0
    //                       ? null
    //                       : getImageFromBase64String(
    //                           base64String:
    //                               widget.viewModel.driversList[index].photo,
    //                         ),
    //                   circularBorderRadius: defaultBorder,
    //                 ),
    //               ),
    //               wSizedBox(10),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   mainAxisSize: MainAxisSize.max,
    //                   children: [
    //                     Text(
    //                       '${widget.viewModel.driversList[index].salutation} ${widget.viewModel.driversList[index].firstName} ${widget.viewModel.driversList[index].lastName}',
    //                       style: AppTextStyles.lato20PrimaryShade5.copyWith(
    //                           fontSize: 16, fontWeight: FontWeight.bold),
    //                     ),
    //                     hSizedBox(5),
    //                     InkWell(
    //                       onTap: () {
    //                         launch(
    //                             "tel://+91-${widget.viewModel.driversList[index].mobile.trim()}");
    //                       },
    //                       child: Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Image.asset(
    //                             phoneNumber,
    //                             height: 10,
    //                             width: 10,
    //                             // color: AppColors.primaryColorShade5,
    //                           ),
    //                           wSizedBox(10),
    //                           Text(
    //                               '+91-${widget.viewModel.driversList[index].mobile.trim()}'),
    //                         ],
    //                       ),
    //                     ),
    //                     hSizedBox(10),
    //                     rightAlignedText(
    //                       text: getExperience(widget.viewModel
    //                           .driversList[index].workExperienceYr),
    //                     ),
    //                     hSizedBox(5),
    //                     rightAlignedText(
    //                       text: widget
    //                           .viewModel.driversList[index].vehicleId
    //                           .toUpperCase(),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
  }

  buildSearchDriverTextFormField({DriversListViewModel viewModel}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return viewModel
            .getDriverNameForAutoComplete(viewModel.driversList)
            .where((String option) {
          return option.contains(textEditingValue.text.toUpperCase());
        }).toList();
      },
      onSelected: (String selection) {
        /// Add the selected Item into the list

        // CitiesResponse temp;
        // viewModel.cityList.forEach((element) {
        //   if (element.city == selection) {
        //     temp = element;
        //   }
        // });
        // viewModel.selectedCity = temp;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return appTextFormField(
          // hintText: "Hubs",
          inputDecoration: InputDecoration(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.drawerIconsBackgroundColor,
                  borderRadius: getBorderRadius(),
                ),
                child: Center(
                  child: Image.asset(
                    searchBlueIcon,
                    height: 20,
                    width: 20,
                    // color: AppColors.primaryColorShade5,
                  ),
                ),
              ),
            ),
            hintText: 'Search for driver',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          validator: (String value) {
            if (!viewModel
                .getDriverNameForAutoComplete(viewModel.driversList)
                .contains(value)) {
              return 'Nothing selected.';
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: options
                    .map((String option) => GestureDetector(
                  onTap: () {
                    onSelected(option);
                  },
                  child: ListTile(
                    title: Text(option),
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget addDriverView({String text, String iconName, Function onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: ClickableWidget(
        childColor: AppColors.white,
        borderRadius: getBorderRadius(),
        onTap: () {
          onTap.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    iconName == null
                        ? Container()
                        : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: IconBlueBackground(
                        iconName: iconName,
                      ),
                    ),
                    iconName == null ? Container() : wSizedBox(20),
                    Expanded(
                      child: Text(
                        text,
                        style: AppTextStyles.latoMedium12Black.copyWith(
                            color: AppColors.primaryColorShade5, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  forwardArrowIcon,
                  height: 10,
                  width: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container rightAlignedText({@required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text,
        textAlign: TextAlign.end,
      ),
    );
  }

  String getExperience(int workExperienceYr) {
    if (workExperienceYr > 1) {
      return '$workExperienceYr Years Experience';
    } else {
      return '$workExperienceYr Year Experience';
    }
  }
}
