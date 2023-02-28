import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/resources/widgets/analytics_card.dart';
import '../../../app/controllers/controller.dart';
import '../../../app/networking/ar_card_api_service.dart';
import '../../../bootstrap/helpers.dart';

class AnalyticsPage extends NyStatefulWidget {
  final Controller controller = Controller();
  AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends NyState<AnalyticsPage> {
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
    setState(() {});
    final response = await api<ArCardApiService>(
      (request) => request.fetchAll(),
    );
    if (response != null) {
      setState(() {
        loadedCards = response;
      });
    }
    setState(() {});
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
          left: 20,
          right: 20,
        ),
        child: PageView.builder(
          itemBuilder: (ctx, i) {
            return AnalyticsCard(
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
