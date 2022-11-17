import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../app/networking/ar_card_api_service.dart';
import '../../bootstrap/helpers.dart';
import 'analytics_bar_chart.dart';

class AnalyticsCard extends StatefulWidget {
  const AnalyticsCard({
    super.key,
    required this.id,
    required this.name,
    required this.title,
    required this.uniqueId,
    required this.cardImage,
  });

  final String id;
  final String name;
  final String title;
  final String uniqueId;
  final String cardImage;

  @override
  State<AnalyticsCard> createState() => _AnalyticsCardState();
}

class _AnalyticsCardState extends NyState<AnalyticsCard> {
  List monthlyStats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  bool _isLoading = false;
  @override
  init() async {
    await loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await api<ArCardApiService>(
      (request) => request.getAnalyticsData(data: {
        "id": widget.id,
      }),
    );
    if (response != null) {
      setState(() {
        monthlyStats = response;
      });
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 5,
          ),
          decoration: BoxDecoration(color: Color(0xFFE4E9EA)),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.cardImage,
                          ),
                        ),
                      ),
                      width: 64,
                      height: 64,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name.length > 8
                                ? widget.name.replaceAll(' ', '\n')
                                : widget.name,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        widget.uniqueId,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFFBFBFB),
                    ),
                    width: 150,
                    height: 300,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 300,
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 10,
                          ),
                          child: Text(
                            'Visitors interactions',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '86.5% of visitors interact with your profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        CircularPercentIndicator(
                          radius: 55.0,
                          lineWidth: 13.0,
                          animation: true,
                          percent: 0.7,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                monthlyStats[10].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                              Text(
                                'Interactions',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          // progressColor: Colors.lightBlueAccent,
                          linearGradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 142, 183, 200),
                              Colors.lightBlueAccent,
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Divider(),
                // height: ,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFBFBFB),
                ),
                width: double.infinity,
                height: 300,
                child: AnalyticsBarChart(monthlyStats: monthlyStats),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
