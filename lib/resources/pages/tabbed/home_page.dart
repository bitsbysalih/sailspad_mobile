import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/app/networking/ar_card_api_service.dart';
import 'package:sailspad/app/networking/user_api_service.dart';
import 'package:sailspad/resources/widgets/rounded_button.dart';

import '../../../app/controllers/controller.dart';
import '../../../bootstrap/helpers.dart';
import '../../widgets/card_list_item.dart';

class HomePage extends NyStatefulWidget {
  final Controller controller = Controller();
  HomePage({
    Key? key,
    required this.switchToEdit,
  }) : super(key: key);
  final Function switchToEdit;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends NyState<HomePage> {
  bool _isLoading = false;
  List loadedCards = [];

  bool showModal = false;
  @override
  init() async {
    await checkSubscriptionStatus();
    await loadCards();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadCards() async {
    setState(() {
      _isLoading = true;
    });
    final response = await api<ArCardApiService>(
      (request) => request.fetchAll(),
    );
    if (response != null) {
      setState(() {
        loadedCards = response;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> deleteCard(String id) async {
    final response = await api<ArCardApiService>(
      (request) => request.delete(id: id),
      context: context,
    );

    if (response != null) {
      showToastNotification(
        context,
        title: 'Success',
        description: 'Card deleted Successfully',
      );
      await loadCards();
    }
  }

  Future<bool> checkSubscriptionStatus() async {
    final response =
        await api<UserApiService>((request) => request.getuserDetails());
    if (response['monthlySubscriptionStatus'] == "active" ||
        response['monthlySubscriptionStatus'] == 'trialing' ||
        response['monthlySubscriptionStatus'] == 'unpaid') {
      setState(() {
        showModal = false;
      });
      return true;
    }
    setState(() {
      showModal = true;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.2,
                  color: Color(0xFF455154),
                ),
              ),
            ),
            height: Platform.isIOS
                ? mediaQuery.size.height * 0.73
                : mediaQuery.size.height * 0.735,
            width: mediaQuery.size.width,
            child: _isLoading
                ? SizedBox(
                    child: SpinKitDualRing(
                      color: Colors.white,
                      size: 50.0,
                    ),
                    height: 20.0,
                    width: 20.0,
                  )
                : loadedCards.length <= 0
                    ? Center(
                        child: Text(
                          "You don't have any cards yet",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: Colors.grey,
                          child: ListView.builder(
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                ),
                                child: CardListItem(
                                  switchToEdit: widget.switchToEdit,
                                  deleteCard: deleteCard,
                                  id: loadedCards[i]!.id,
                                  name: loadedCards[i]!.name,
                                  title: loadedCards[i]!.title,
                                  uniqueId: loadedCards[i]!.uniqueId,
                                  cardImage: loadedCards[i]!.cardImage,
                                ),
                              );
                            },
                            itemCount: loadedCards.length,
                          ),
                        ),
                      ),
          ),
          if (showModal)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 1),
              child: Container(
                height: mediaQuery.size.height,
                width: mediaQuery.size.width,
                color: Colors.white.withOpacity(0.3),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Your subscription is currently inactive'),
                      SizedBox(
                        height: 30,
                      ),
                      RoundedButton(
                        onPressed: () {
                          routeTo('/settings-page/subscription');
                        },
                        child: Text('Go to billing'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
