import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  final scoreDetails;
  const ScoreScreen({super.key, required this.scoreDetails});
  List<TableRow> createRow(var scoredetail) {
    scoredetail.sort((a, b) => b.toString().compareTo(a.toString()));
    List<TableRow> row = [];
    row.add(const TableRow(children: [
      Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Center(
            child: Text(
          "Rank",
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        )),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Center(
            child: Text("Date",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1))),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Center(
            child: Text("Score",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1))),
      )
    ]));
    int noOfRows = scoredetail.length;
    for (int i = 0; i < noOfRows; i++) {
      if (i < 11) {
        var rank = scoredetail[i].toString().split(",");
        var date = rank[1].split(" ")[0].split("-");
        var scoreDate = formatDate(
            DateTime(
                int.parse(date[0]), int.parse(date[1]), int.parse(date[2])),
            [yy, "-", M, "-", d]);
        Widget rankitems = TableCell(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text("${i + 1}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300)),
        ));
        Widget dateitems = TableCell(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(scoreDate,
              style: const TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
              textAlign: TextAlign.center),
        ));
        Widget scoreitem = TableCell(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(rank[0],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300)),
        ));
        row.add(TableRow(children: [rankitems, dateitems, scoreitem]));
      }
    }
    return row;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: scoreDetails.length == 0
              ? Stack(
                  children: [
                    const Center(
                      child: Text("No Score Yet!",
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      child: IconButton(
                          tooltip: "Home",
                          iconSize: 30,
                          color: Colors.white,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                          )),
                    )
                  ],
                )
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      child: IconButton(
                          tooltip: "Home",
                          iconSize: 30,
                          color: Colors.white,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "High Scores",
                        style: TextStyle(
                            fontFamily: "AbrilFatface",
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          textBaseline: TextBaseline.alphabetic,
                          children: createRow(scoreDetails)),
                    ))
                  ],
                )),
    );
  }
}
