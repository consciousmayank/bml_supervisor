import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/drawerlistitem/drawer_list_item_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../IconBlueBackground.dart';
import '../clickable_widget.dart';

class DrawerListItem extends StatefulWidget {
  final String text;
  final String imageName;
  final Function onTap;
  final bool isSubMenu;
  final List<DrawerListItem> children;

  // final Widget trailingWidget;

  const DrawerListItem({
    Key key,
    this.text,
    this.imageName,
    this.onTap,
    this.isSubMenu = false,
    this.children,
  }) : super(key: key);

  @override
  _DrawerListItemState createState() => _DrawerListItemState();
}

class _DrawerListItemState extends State<DrawerListItem> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerListItemViewModel>.reactive(
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Column(
          children: [
            ClickableWidget(
              childColor: AppColors.white,
              borderRadius: getBorderRadius(),
              onTap: widget.children == null
                  ? () {
                      widget.onTap.call();
                    }
                  : () {
                      Future.delayed(Duration(milliseconds: 500), () {
                        viewModel.showItems = !viewModel.showItems;
                      });
                    },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        widget.imageName == null
                            ? Container()
                            : IconBlueBackground(
                                iconName: widget.imageName,
                                isSubMenu: widget.isSubMenu,
                              ),
                        widget.imageName == null ? Container() : wSizedBox(20),
                        Expanded(
                          child: Text(
                            widget.text,
                            style: AppTextStyles.latoMedium12Black.copyWith(
                                color: AppColors.primaryColorShade5,
                                fontSize: 14),
                          ),
                        ),
                        widget.children != null
                            ? Icon(!viewModel.showItems
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up)
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            widget.children == null
                ? Container()
                : Column(
                    children: List.generate(
                        viewModel.showItems ? widget.children.length : 0,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 4,
                        ),
                        child: DrawerListItem(
                          imageName: widget.children[index].imageName,
                          text: widget.children[index].text,
                          onTap: () {
                            widget.children[index].onTap.call();
                          },
                        ),
                      );
                    }).toList(),
                  )
          ],
        ),
      ),
      viewModelBuilder: () => DrawerListItemViewModel(),
    );
  }
}
