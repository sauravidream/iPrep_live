import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/app_details_model.dart';

class HowAppWorks extends StatelessWidget {
  const HowAppWorks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            leadingWidth: 36,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 11,
                ),
                child: Image.asset(
                  "assets/images/back_icon.png",
                  height: 25,
                  width: 25,
                ),
              ),
            ),
            title: Text(
              "How the App Works",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.values[5],
                color: const Color(0xFF212121),
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: FutureBuilder(
              future: howTheAppWorksRepository.fetchAppDetails(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  return Container();
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data == null) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text("No data available. Please try later."),
                  );
                } else if (snapshot.hasData) {
                  List<AppDetails>? _appDetailsList =
                      (snapshot.data as List<AppDetails>?);
                  if (_appDetailsList == null || _appDetailsList.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      child: const Text("No data available. Please try later."),
                    );
                  }
                  return ListView.builder(
                      itemCount: _appDetailsList.length,
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (snapshot.data == null) {
                          return Center(
                              child: Text(
                            "No content available",
                            style: TextStyle(
                              color: const Color(0xFF212121),
                              fontWeight: FontWeight.values[5],
                              fontSize: 15,
                            ),
                          ));
                        }
                        return ExpandableTile(
                            title: _appDetailsList[index].title ?? "",
                            childText: _appDetailsList[index].detail ?? "");
                      });
                } else {
                  return const Center(child: Loader());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableTile extends StatefulWidget {
  final String? title;
  final String? childText;
  const ExpandableTile({Key? key, this.title, this.childText})
      : super(key: key);

  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool _tileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.all(
        0,
      ),
      expandedAlignment: Alignment.centerLeft,
      tilePadding: const EdgeInsets.all(0),
      title: Text(
        widget.title!,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.values[5],
            color: const Color(0xFF212121)),
      ),
      trailing: Image.asset(
        "assets/images/${_tileExpanded ? "minus_icon" : "plus_icon"}.png",
        height: 12,
        width: 12,
      ),
      onExpansionChanged: (value) {
        setState(() {
          _tileExpanded = value;
        });
      },
      children: <Widget>[
        Text(
          widget.childText!,
          style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF212121),
              height: 1.6,
              letterSpacing: 0.1),
        ),
      ],
    );
  }
}
