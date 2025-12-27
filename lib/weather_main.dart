import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import "package:table_calendar/table_calendar.dart";


class WeatherMain extends StatefulWidget {
  const WeatherMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WeatherMain();
  }
}

class _WeatherMain extends State<WeatherMain> {
  String _title = "";
  String _message = "";
  final List _fcstList = List.empty(growable: true);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Api 통신"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                firstDay: DateTime.utc(2022, 11, 01),
                lastDay: DateTime.utc(2030, 312, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;

                      DateTime viewDay = _selectedDay!.add(const Duration(days: -1));
                      _callApi(DateFormat("yyyyMMdd").format(viewDay));
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Container(
                  height: 2,
                  color: Colors.lightBlueAccent,
                ),
              ),
              Text(_title),
              Text(_message),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _controller,
                  child: ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _fcstList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, position) {
                      String fcstDT = _fcstList[position]["fcstDT"];
                      Map info = _fcstList[position]["info"];
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(fcstDT))),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: info.keys.map((key) => Text("${_getName(key)} : " + info[key])).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _callApi(selectedDay) async {
    var url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
    url += "?serviceKey=d23VgHxWsvabmf9d8gyqueZvQmKmjufzual6Z3TL%2BVfpJP9n7ZxYY9aPXjjt3YLLnDsJtYC7b0JzbdKl2q5U3Q%3D%3D";
    url += "&pageNo=1";
    url += "&numOfRows=290";
    url += "&dataType=JSON";
    url += "&base_date=$selectedDay";
    url += "&base_time=2300";
    url += "&nx=55";
    url += "&ny=127";

    var response = await http.get(Uri.parse(url));
    Map map = json.decode(response.body);

    setState(() {
      _fcstList.clear();
      _title = DateFormat("yyyy-MM-dd").format(_selectedDay!);

      if (map["response"]["header"]["resultCode"] != "00") {
        _message = map["response"]["header"]["resultMsg"];
      } else {
        _message = "";
      }

      if (map["response"]["header"]["resultCode"] == "00") {
        List list = map["response"]["body"]["items"]["item"];
        for (var item in list) {
          Map fcstItem = _fcstList.firstWhere((element) => element["fcstDT"] == item["fcstDate"] + "T" + item["fcstTime"] + "00", orElse: () => {});

          if (fcstItem.isEmpty) {
            Map newItem = {};
            newItem["fcstDT"] = item["fcstDate"] + "T" + item["fcstTime"] + "00";
            newItem["info"] = {item["category"]: item["fcstValue"]};

            _fcstList.add(newItem);
          } else {
            Map info = fcstItem["info"];
            info[item["category"]] = item["fcstValue"];
          }
        }
      }
    });
  }

  String _getName(code) {
    String name;

    switch (code) {
      case "POP" :
        name = "강수확률";
        break;

      case "PTY" :
        name = "강수형태";
        break;

      case "PCP" :
        name = "1시간 강수량";
        break;

      case "REH" :
        name = "습도";
        break;

      case "SNO" :
        name = "1시간 신적설";
        break;

      case "SKY" :
        name = "하늘상태";
        break;

      case "TMP" :
        name = "1시간 기온";
        break;

      case "TMN" :
        name = "일 최저기온";
        break;

      case "TMX" :
        name = "일 최고기온";
        break;

      case "UUU" :
        name = "풍속(동서성분)";
        break;

      case "VVV" :
        name = "풍속(남북성분)";
        break;

      case "WAV" :
        name = "파고";
        break;

      case "VEC" :
        name = "풍향";
        break;

      case "WSD" :
        name = "풍속";
        break;

      default :
        name = code;
        break;
    }

    return name;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
