import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/resources/widgets/sailspad_icons.dart';

import '../../app/networking/ar_card_api_service.dart';
import '../../bootstrap/helpers.dart';
import 'custom_icon_button.dart';

class CardListItem extends StatefulWidget {
  const CardListItem({
    Key? key,
    required this.id,
    required this.name,
    required this.title,
    required this.uniqueId,
    required this.cardImage,
    required this.switchToEdit,
    required this.deleteCard,
  }) : super(key: key);
  final String? id;
  final String? name;
  final String? title;
  final String? uniqueId;
  final String? cardImage;
  final Function switchToEdit;
  final Function deleteCard;

  @override
  State<CardListItem> createState() => _CardListItemState();
}

class _CardListItemState extends NyState<CardListItem> {
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  String get webClientUrl => getEnv('WEB_CLIENT_URL');

  @override
  init() async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    return super.init();
  }

  HeadlessInAppWebView? headlessWebView;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        allowFileAccessFromFileURLs: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        allowFileAccess: true,
        allowContentAccess: true,
        hardwareAcceleration: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  Future<dynamic> _showARBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          height: mediaQuery.size.height * 0.92,
          child: InAppWebView(
            initialOptions: options,
            initialUrlRequest: URLRequest(
              url: Uri.parse(
                '$webClientUrl/${widget.id}/view-mobile',
              ),
            ),
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
          ),
        ),
      ),
      isDismissible: true,
      barrierColor: Colors.grey,
    );
  }

  Future<dynamic> _showQRBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          height: mediaQuery.size.height * 0.92,
          child: InAppWebView(
            initialOptions: options,
            initialUrlRequest: URLRequest(
              url: Uri.parse(
                '$webClientUrl/${widget.id}/qr',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.size.height * 0.22,
      decoration: BoxDecoration(
        color: Color(0xFFE4E9EA).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: Color(0xFFE4E9EA),
        ),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Card Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      width: 2,
                      color: Color(0xFFE3E3E3),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.cardImage!,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: mediaQuery.size.width * 0.35,
                      height: mediaQuery.size.height * 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name!,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            widget.title!,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Text(
                  widget.uniqueId!.toUpperCase(),
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            //Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  label: 'Edit',
                  onTap: () {
                    api<ArCardApiService>(
                      (request) => request.setCardToEdit(widget.id as String),
                    );
                    widget.switchToEdit(widget.id);
                  },
                  icon: FontAwesomeIcons.pen,
                ),
                CustomIconButton(
                  label: 'View AR',
                  onTap: () {
                    _showARBottomSheet(context);
                  },
                  icon: FontAwesomeIcons.solidEye,
                ),
                CustomIconButton(
                  label: 'Share',
                  onTap: () {
                    _showQRBottomSheet(context);
                  },
                  icon: SailspadIcons.sailspad_share,
                ),
                CustomIconButton(
                  label: 'Delete',
                  onTap: () {
                    widget.deleteCard(widget.id);
                  },
                  icon: FontAwesomeIcons.solidTrashCan,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
