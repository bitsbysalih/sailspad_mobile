import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/app/networking/ar_card_api_service.dart';

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
  @override
  init() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
                ? Text(
                    "You don't have any cards yet",
                    textAlign: TextAlign.center,
                  )
                : ListView.builder(
                    itemBuilder: (ctx, i) {
                      return CardListItem(
                        switchToEdit: widget.switchToEdit,
                        deleteCard: deleteCard,
                        id: loadedCards[i]!.id,
                        name: loadedCards[i]!.name,
                        title: loadedCards[i]!.title,
                        uniqueId: loadedCards[i]!.uniqueId,
                        cardImage: loadedCards[i]!.cardImage,
                      );
                    },
                    itemCount: loadedCards.length,
                  ),
      ),
    );
  }
}
