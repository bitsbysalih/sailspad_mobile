import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../app/networking/ar_card_api_service.dart';
import '../../bootstrap/helpers.dart';
import 'daily_stats_chart.dart';
import 'yearly_stats_chart.dart';

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
  Map monthlyStats = {
    'months': [],
    'days': [],
    'totalVisits': 0,
    'totalDailyVisits': 0,
    'linksTotal': 0,
  };

  List linksData = [];

  final List<String> items = [
    'instagram',
    'facebook',
    'linkedin',
    'twitter',
    'website',
    'github',
  ];

  double interactionPercentage = 0;

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

  bool _isLoading = false;
  @override
  init() async {
    await loadData();
    await loadLinksData();
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
        interactionPercentage =
            (monthlyStats['linksTotal'] / monthlyStats['totalVisits']) * 100;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loadLinksData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await api<ArCardApiService>(
      (request) => request.getLinksAnalyticsData(id: widget.id),
    );
    if (response != null) {
      setState(() {
        linksData = response;
      });
    }
    setState(() {
      _isLoading = false;
    });
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
          decoration: BoxDecoration(
            color: Color(0xFFE4E9EA),
            borderRadius: BorderRadius.circular(15),
          ),
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
              if (linksData.length > 0)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    spacing: 50,

                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: linksData.map((e) {
                      return Container(
                        child: Column(
                          children: [
                            FaIcon(
                              iconSelector(e['linkName']),
                              size: 30,
                            ),
                            Text(e['count'].toString()),
                          ],
                        ),
                      );
                    }).toList(),
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
                    child: monthlyStats['days'].length > 0
                        ? DailyStatsChart(
                            dailyStats: monthlyStats['days'],
                            totalDailyVisits: monthlyStats['totalDailyVisits'],
                          )
                        : null,
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
                          '${interactionPercentage.toStringAsFixed(1)}% of visitors interact with your profile',
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
                                monthlyStats['totalVisits'].toString(),
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
                child: monthlyStats['months'].length > 0
                    ? YearlyStatsChart(
                        monthlyStats: monthlyStats['months'],
                        totalYearlyVisits: monthlyStats['totalVisits'],
                      )
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
