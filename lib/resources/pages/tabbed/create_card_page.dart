import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/app/networking/ar_card_api_service.dart';

import '../../../app/controllers/controller.dart';
import '../../../app/models/ar_card.dart';
import '../../../bootstrap/helpers.dart';
import '../../widgets/auth_form_field.dart';
import '../../widgets/card_image_input.dart';
import '../../widgets/profile_photo_input.dart';
import '../../widgets/rounded_button.dart';

class CreateCardPage extends NyStatefulWidget {
  final Controller controller = Controller();
  CreateCardPage({
    Key? key,
  }) : super(key: key);

  @override
  _CreateCardPageState createState() => _CreateCardPageState();
}

class _CreateCardPageState extends NyState<CreateCardPage> {
  HeadlessInAppWebView? headlessWebView;
  InAppWebViewController? webViewController;
  File? _cardImage;
  File? _logoImage;
  File? _backgroundImage;
  String? cardId;
  bool editMode = false;
  bool _isLoadingCard = true;
  String token = '';

  List cardLinks = [
    {"name": "instagram", "link": ""},
  ];

  bool? _isLoadingMarkers = false;
  bool _isLoading = false;

  List loadedMarkers = [];

  Map _cardData = {
    "name": "",
    "title": "",
    "about": "",
    "email": "",
    "shortName": "",
    "activeStatus": true,
    "links": [],
    "cardImage": '',
    "logoImage": '',
    "backgroundImage": '',
    "marker": {
      "uniqueId": '',
      "markerFile": '',
      "markerImage": '',
    },
  };

  final List<String> items = [
    'instagram',
    'facebook',
    'linkedin',
    'twitter',
    'website',
    'github',
  ];

  IconData iconSelector(String iconName) {
    if (iconName == 'instagram') {
      return FontAwesomeIcons.instagram;
    } else if (iconName == 'twitter') {
      return FontAwesomeIcons.twitter;
    } else if (iconName == 'facebook') {
      return FontAwesomeIcons.facebook;
    } else if (iconName == 'linkedin') {
      return FontAwesomeIcons.linkedin;
    } else if (iconName == 'website') {
      return FontAwesomeIcons.globe;
    } else if (iconName == 'github') {
      return FontAwesomeIcons.github;
    }
    return FontAwesomeIcons.a;
  }

  @override
  init() async {
    await loadMarkers();

    _cardData['links'] = cardLinks;
    await api<ArCardApiService>(
      (request) {
        cardId = request.returnCardId().toString();
      },
    );
    token = await NyStorage.read("user_id");

    if (cardId!.isNotEmpty) {
      editMode = true;
      print(cardId);
      loadCardToEdit(cardId!);
      return;
    }
    setState(() {
      _isLoadingCard = false;
    });
  }

  @override
  void dispose() {
    api<ArCardApiService>(
      (request) => request.setCardToEdit(''),
    );
    super.dispose();
  }

  Future<void> loadMarkers() async {
    final response = await api<ArCardApiService>(
      (request) => request.listMarkers(),
    );
    if (response != null) {
      setState(() {
        loadedMarkers = response;
      });
    }
  }

  void loadCardToEdit(String id) async {
    ArCard? response = await api<ArCardApiService>(
      (request) => request.find(id: id),
    );
    if (response != null) {
      setState(() {
        _isLoadingCard = true;
      });
      setState(() {
        _cardData = {
          "cardImage": response.cardImage,
          "name": response.name,
          "title": response.title,
          "about": response.about,
          "shortName": response.shortName,
          "links": response.links,
          "activeStatus": response.activeStatus,
          "logoImage": response.logoImage,
          'backgroundImage': response.backgroundImage,
          "marker": {
            "uniqueId": response.marker?['uniqueId'],
            "markerFile": response.marker?['markerFile'],
            "markerImage": response.marker?['markerImage'],
          }
        };
      });
      setState(() {
        _isLoadingCard = false;
      });
    }
  }

  void createCard() async {
    String? cardImagefileName = _cardImage?.path.split('/').last;
    String? logoImagefileName = _logoImage?.path.split('/').last;
    String? backgroundImagefileName = _backgroundImage?.path.split('/').last;

    FormData formData = new FormData.fromMap({
      "name": _cardData['name'],
      "title": _cardData['title'],
      'about': _cardData['about'],
      'email': _cardData['email'],
      'links': _cardData['links'],
      "shortName": _cardData['shortName'],
      "activeStatus": _cardData['activeStatus'].toString(),
      "marker": _cardData['marker'],
      "cardImage": cardImagefileName != null
          ? await MultipartFile.fromFile(
              _cardImage!.path,
              filename: cardImagefileName,
            )
          : '',
      "logoImage": logoImagefileName != null
          ? await MultipartFile.fromFile(
              _logoImage!.path,
              filename: logoImagefileName,
            )
          : '',
      "backgroundImage": backgroundImagefileName != null
          ? await MultipartFile.fromFile(
              _backgroundImage!.path,
              filename: backgroundImagefileName,
            )
          : '',
    });

    if (cardImagefileName == null) {
      showToastNotification(
        context,
        title: 'Error',
        description: 'Main image cannot be empty',
        style: ToastNotificationStyleType.DANGER,
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final response = await api<ArCardApiService>(
        (request) => request.create(data: formData),
        context: context);
    if (response != null) {
      routeTo('/tabs-page');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void updateCard() async {
    String? cardImagefileName = _cardImage?.path.split('/').last;
    String? logoImagefileName = _logoImage?.path.split('/').last;
    String? backgroundImagefileName = _backgroundImage?.path.split('/').last;

    FormData formData = new FormData.fromMap({
      "name": _cardData['name'],
      "title": _cardData['title'],
      'about': _cardData['about'],
      'email': _cardData['email'],
      'links': _cardData['links'],
      "shortName": _cardData['shortName'],
      "activeStatus": _cardData['activeStatus'].toString(),
      "marker": _cardData['marker'],
      "cardImage": cardImagefileName != null
          ? await MultipartFile.fromFile(
              _cardImage!.path,
              filename: cardImagefileName,
            )
          : '',
      "logoImage": logoImagefileName != null
          ? await MultipartFile.fromFile(
              _logoImage!.path,
              filename: logoImagefileName,
            )
          : '',
      "backgroundImage": backgroundImagefileName != null
          ? await MultipartFile.fromFile(
              _backgroundImage!.path,
              filename: backgroundImagefileName,
            )
          : '',
    });

    setState(() {
      _isLoading = true;
    });
    final response = await api<ArCardApiService>(
        (request) => request.update(id: cardId, data: formData),
        context: context);
    if (response != null) {
      routeTo('/tabs-page');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _selectCardImage(File pickedImage) async {
    _cardImage = pickedImage;
    setState(() {
      _cardData['cardImage'] = _cardImage;
    });
  }

  void _selectLogoImage(File pickedImage) async {
    _logoImage = pickedImage;
    setState(() {
      _cardData['logoImage'] = _logoImage;
    });
  }

  void _selectBackgroundImage(File pickedImage) async {
    _backgroundImage = pickedImage;
    setState(() {
      _cardData['backgroundImage'] = _backgroundImage;
    });
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowFileAccessFromFileURLs: true,
      transparentBackground: true,
    ),
    android: AndroidInAppWebViewOptions(
      // useHybridComposition: true,
      allowFileAccess: true,
      allowContentAccess: true,
      hardwareAcceleration: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );
  Future<dynamic> _loadBottomSheetWebView(
      BuildContext context, String token) async {
    print(token);
    return showMaterialModalBottomSheet(
      bounce: true,
      context: context,
      builder: (context) => SizedBox(
        height: mediaQuery.size.height * 0.9,
        child: InAppWebView(
          initialOptions: options,
          initialUrlRequest: URLRequest(
            iosAllowsCellularAccess: true,
            iosAllowsExpensiveNetworkAccess: true,
            url: Uri.parse(
              'https://sailspad-client-dev.vercel.app/mobile-marker-upload/$token',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.2,
                color: Color(0xFF455154),
              ),
            ),
          ),
          height: mediaQuery.size.height * 0.735,
          width: mediaQuery.size.width,
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: _isLoadingCard
              ? SizedBox(
                  child: SpinKitDualRing(
                    color: Colors.white,
                    size: 50.0,
                  ),
                  height: 20.0,
                  width: 20.0,
                )
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.4),
                          ),
                          margin: EdgeInsets.only(top: 30),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 1200,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProfilePhotoInput(
                                    onSelectImage: _selectCardImage,
                                    profilePhoto: editMode
                                        ? _cardData['cardImage'].toString()
                                        : '',
                                  ),
                                  Container(
                                    height: 150,
                                    width: 180,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AuthFormField(
                                          label: 'Name',
                                          initialValue: _cardData['name'],
                                          padding: 6,
                                          fontSize: 12,
                                          onChanged: (value) {
                                            _cardData['name'] = value;
                                          },
                                        ),
                                        AuthFormField(
                                          label: 'Title',
                                          initialValue: _cardData['title'],
                                          padding: 6,
                                          fontSize: 12,
                                          onChanged: (value) {
                                            _cardData['title'] = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height: 10,
                              ),
                              //About Section
                              TextFormField(
                                onChanged: (value) {
                                  _cardData['about'] = value;
                                },
                                style: TextStyle(fontSize: 12),
                                maxLines: 6,
                                initialValue: _cardData['about'],
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'About',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(top: 10, left: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFFE3E3E3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFFE3E3E3),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'https://cards.sailspad.com/',
                                      style: TextStyle(
                                        color: Color(0xFF414546),
                                      ),
                                    ),
                                    SizedBox(
                                      width: mediaQuery.size.width * 0.25,
                                      child: AuthFormField(
                                        label: 'link',
                                        initialValue: _cardData['shortName'],
                                        padding: 6,
                                        fontSize: 12,
                                        onChanged: (value) {
                                          _cardData['shortName'] = value;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      height: 160,
                                      decoration: BoxDecoration(
                                        border: Border.symmetric(
                                          horizontal: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: ListView(
                                        children: (_cardData['links'] as List)
                                            .map((e) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    isExpanded: true,
                                                    hint: Row(
                                                      children: const [
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            'Link...',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xFF414546),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    items: items
                                                        .map(
                                                          (item) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                            value: item,
                                                            child: Row(
                                                              children: [
                                                                FaIcon(
                                                                  iconSelector(
                                                                      item),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  item,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        0xFF414546),
                                                                    // color: Colors.white,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    value: e['name'],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        e['name'] =
                                                            value as String;
                                                      });
                                                    },
                                                    icon: const FaIcon(
                                                      FontAwesomeIcons
                                                          .chevronDown,
                                                      color: Color(0xFF414546),
                                                    ),
                                                    iconSize: 10,
                                                    buttonHeight: 35,
                                                    buttonWidth: 120,
                                                    buttonPadding:
                                                        const EdgeInsets.only(
                                                            left: 14,
                                                            right: 14),
                                                    buttonDecoration:
                                                        BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    itemHeight: 40,
                                                    itemPadding:
                                                        const EdgeInsets.only(
                                                            left: 14,
                                                            right: 14),
                                                    dropdownMaxHeight: 200,
                                                    dropdownWidth: 200,
                                                    dropdownPadding: null,
                                                    dropdownDecoration:
                                                        BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    dropdownElevation: 8,
                                                    scrollbarRadius:
                                                        const Radius.circular(
                                                            40),
                                                    scrollbarThickness: 6,
                                                    scrollbarAlwaysShow: true,
                                                    offset:
                                                        const Offset(-20, 0),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: mediaQuery.size.width *
                                                      0.4,
                                                  height: 55,
                                                  child: AuthFormField(
                                                    padding: 5,
                                                    textInputType:
                                                        TextInputType.url,
                                                    initialValue:
                                                        e['link'] as String,
                                                    label: 'Add your link here',
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please provide a link.';
                                                      }
                                                      return '';
                                                    },
                                                    onChanged: (value) {
                                                      e['link'] = value;
                                                    },
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _cardData['links'] as List
                                                        ..removeWhere((item) =>
                                                            item['name'] ==
                                                            e['name']);
                                                    });
                                                  },
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .circleXmark,
                                                    size: 16,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    RoundedButton(
                                      width: 65,
                                      height: 35,
                                      onPressed: () {
                                        setState(() {
                                          _cardData['links'].add({
                                            'name': 'instagram',
                                            'link': ''
                                          });
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.plus,
                                            size: 15,
                                            color: Color(0xFF414546),
                                          ),
                                          Text(
                                            'Add',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF414546),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container()
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Divider(),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CardImageInput(
                                      buttonLabel: 'Upload Logo',
                                      onSelectImage: _selectLogoImage,
                                      profilePhoto: _cardData['logoImage'] !=
                                              null
                                          ? _cardData['logoImage'].toString()
                                          : '',
                                    ),
                                    CardImageInput(
                                      buttonLabel: 'Card Background',
                                      onSelectImage: _selectBackgroundImage,
                                      profilePhoto:
                                          _cardData['backgroundImage'] != null
                                              ? _cardData['backgroundImage']
                                                  .toString()
                                              : '',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Divider(),
                              ),
                              //markers section
                              Container(
                                width: double.infinity,
                                height: mediaQuery.size.height * 0.3,
                                child: Column(
                                  children: [
                                    Container(
                                      height: mediaQuery.size.height * 0.18,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: double.infinity,
                                            width: mediaQuery.size.width * 0.6,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: _cardData['marker']
                                                            ['markerImage'] ==
                                                        null ||
                                                    _cardData['marker']
                                                            ['markerImage'] ==
                                                        ''
                                                ? Image.asset(
                                                    'public/assets/images/placeholder.png',
                                                  )
                                                : Image.network(
                                                    _cardData['marker']
                                                            ['markerImage']
                                                        .toString(),
                                                  ),
                                          ),
                                          Container(
                                            width: mediaQuery.size.width * 0.18,
                                            color: Color(0xFF414546),
                                            child: _isLoadingMarkers!
                                                ? SizedBox(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.blue,
                                                      strokeWidth: 2,
                                                    ),
                                                    height: 20.0,
                                                    width: 20.0,
                                                  )
                                                : loadedMarkers.length <= 0
                                                    ? Text('Null')
                                                    : ListView.builder(
                                                        itemBuilder: (ctx, i) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(
                                                                () {
                                                                  _cardData["marker"]
                                                                          [
                                                                          "uniqueId"] =
                                                                      loadedMarkers[
                                                                              i]
                                                                          [
                                                                          "uniqueId"];
                                                                  _cardData["marker"]
                                                                          [
                                                                          "markerFile"] =
                                                                      loadedMarkers[
                                                                              i]
                                                                          [
                                                                          "markerFile"];
                                                                  _cardData["marker"]
                                                                          [
                                                                          "markerImage"] =
                                                                      loadedMarkers[
                                                                              i]
                                                                          [
                                                                          "markerImage"];
                                                                },
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 40,
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                border:
                                                                    Border.all(
                                                                  width: 0.5,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    loadedMarkers[
                                                                            i][
                                                                        'markerImage'],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5),
                                                            ),
                                                          );
                                                        },
                                                        itemCount: loadedMarkers
                                                            .length,
                                                      ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: mediaQuery.size.width * 0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RoundedButton(
                                            height: 30,
                                            width: mediaQuery.size.width * 0.55,
                                            onPressed: () async {
                                              await _loadBottomSheetWebView(
                                                  context, token);
                                              await loadMarkers();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.plus,
                                                  size: 18,
                                                ),
                                                Text(
                                                  'Upload new Business Card',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF414546),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.only(top: 40),
                                          ),
                                          Column(
                                            children: [
                                              Switch(
                                                value:
                                                    _cardData['activeStatus'],
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      _cardData[
                                                              'activeStatus'] =
                                                          value;
                                                    },
                                                  );
                                                },
                                              ),
                                              // Text('Active')
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RoundedButton(
                          height: 30,
                          width: mediaQuery.size.width * 0.4,
                          onPressed: () {
                            if (editMode) {
                              updateCard();
                            } else {
                              createCard();
                            }
                          },
                          child: _isLoading
                              ? SizedBox(
                                  child: SpinKitDualRing(
                                    color: Colors.grey,
                                    size: 20.0,
                                  ),
                                  height: 20.0,
                                  width: 20.0,
                                )
                              : Text(
                                  editMode ? "Update Card" : 'Create Card',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF414546),
                                  ),
                                ),
                          margin: EdgeInsets.only(top: 40),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
