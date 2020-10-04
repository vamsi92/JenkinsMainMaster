import 'package:cx_commerce_jenkins/homePage.dart';
import 'package:cx_commerce_jenkins/resultsGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cx_commerce_jenkins/services/jenkinsDataFetcher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_indicator/loading_indicator.dart';

class BuildResultsListPage extends StatefulWidget {
  String appBarTitle;
  Future<List<JenkinsJobStatus>> output;

  BuildResultsListPage(this.appBarTitle, this.output);

  @override
  State<StatefulWidget> createState() {
    return _BuildResultsListPageState(this.appBarTitle, this.output);
  }
}

class _BuildResultsListPageState extends State<BuildResultsListPage> {
  int _pageIndex = 0;
  List<Widget> tabPages = [
    MyHomePage(title: 'Jenkins Job App'),
    MyResultsPage()
  ];
  String appBarTitle;
  Future<List<JenkinsJobStatus>> output;

  _BuildResultsListPageState(this.appBarTitle, this.output);

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = Theme.of(context).textTheme.bodyText1;
    TextStyle linkStyle = TextStyle(color: Colors.indigo);

    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Column(children: [
          Card(
            child: Container(
              color: Colors.white,
              height: 70,
              child: Padding(
                  padding: EdgeInsets.only(
                      top:  3, bottom:  3),
                  child:Center(
                  child: Row(children: [
                Expanded(
                    child: Column(children: [
                  CircleAvatar(backgroundColor: Colors.green),
                  Container(
                    height: 5,
                  ),
                  Text(
                    "SUCCESS",
                    textScaleFactor: 0.8,
                  )
                ])),
                Expanded(
                    child: Column(children: [
                  CircleAvatar(backgroundColor: Colors.red),
                  Container(
                    height: 5,
                  ),
                  Text(
                    "FAILED",
                    textScaleFactor: 0.8,
                  )
                ])),
              ]))),
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: this.output,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    color: Colors.white,
                    child: Column(children:[Expanded(child:Center(
                        child: LoadingIndicator(
                          color: Colors.blue,
                          indicatorType: Indicator.ballClipRotatePulse,
                        ))),
                      Expanded(child:Text("Loading...",style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blueGrey),))
                    ])
                );
              } else {
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, position) {
                        return Card(
                          color: Colors.white,
                          elevation: 2.0,
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getBuildStatus(
                                    snapshot.data[position].status.toString()),
                              ),
                              title: Text(
                                snapshot.data[position].displayName,
                                style: headingStyle,
                              ),
                              ),
                        );
                      }),
                );
              }
            },
          ))
        ]),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        backgroundColor: Hexcolor("#E6EDF6"),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blueGrey, size: 50),
            title: new Text('Trigger Jobs',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.layers, color: Colors.blueGrey, size: 50),
              title: new Text('Show Results',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )))
        ]),
        );
  }


  Color getBuildStatus(String status) {
    switch (status) {
      case "201":
        return Colors.green;
        break;
      default:
        return Colors.red;
        break;
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
      navigateToTabs(index);
    });
  }

  void navigateToTabs(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return tabPages[index];
    }));
  }

}
