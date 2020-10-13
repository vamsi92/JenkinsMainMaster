import 'package:cx_commerce_jenkins/homePage.dart';
import 'package:cx_commerce_jenkins/resultsList.dart';
import 'package:cx_commerce_jenkins/services/jenkinsDataFetcher.dart';
import 'package:cx_commerce_jenkins/constants/dataUrls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyResultsPage extends StatefulWidget {
  @override
  _MyResultsPageState createState() => _MyResultsPageState();
}

class _MyResultsPageState extends State<MyResultsPage> {
  int _pageIndex = 0;
  final _minimumPadding = 5.0;
  JenkinsDataFetcher dataFetcher = new JenkinsDataFetcher();
  List<Widget> tabPages = [
    MyHomePage(title: 'Jenkins Job App'),
    MyResultsPage()
  ];

  void _getAllAgentMasterJobs() async {
    Future<List<JenkinsJobLinks>> data = dataFetcher.getDataFromJenkins(
        Constants.AGENT_MASTER_JOB_LINK + Constants.API_EXTENSION);
    List<JenkinsJobLinks> ls = await data;
    List<String> urls = new List<String>();
    ls.forEach((element) {
      urls.add(element.url);
    });
    Future<List<JenkinsData>> buildData = dataFetcher.getListOfJobData(urls);

    setState(() {
      generateResult("Agent Master Job Results", buildData);
    });
  }

  void _getAllAgentMainJobs() async {
    Future<List<JenkinsJobLinks>> data = dataFetcher.getDataFromJenkins(
        Constants.AGENT_MAIN_JOB_LINK + Constants.API_EXTENSION);
    List<JenkinsJobLinks> ls = await data;
    List<String> urls = new List<String>();
    ls.forEach((element) {
      urls.add(element.url);
    });
    Future<List<JenkinsData>> buildData = dataFetcher.getListOfJobData(urls);

    setState(() {
      generateResult("Agent Main Job Results", buildData);
    });
  }

  void _getAllStoreMasterJobs() async {
    Future<List<JenkinsJobLinks>> data = dataFetcher.getDataFromJenkins(
        Constants.STORE_MASTER_JOB_LINK + Constants.API_EXTENSION);
    List<JenkinsJobLinks> ls = await data;
    List<String> urls = new List<String>();
    ls.forEach((element) {
      urls.add(element.url);
    });
    Future<List<JenkinsData>> buildData = dataFetcher.getListOfJobData(urls);

    setState(() {
      generateResult("Store Master Job Results", buildData);
    });
  }

  void _getAllStoreMainJobs() async {
    Future<List<JenkinsJobLinks>> data = dataFetcher.getDataFromJenkins(
        Constants.STORE_MAIN_JOB_LINK + Constants.API_EXTENSION);
    List<JenkinsJobLinks> ls = await data;
    List<String> urls = new List<String>();
    ls.forEach((element) {
      if (!element.url.contains("Forward")) {
        urls.add(element.url);
      }
    });
    Future<List<JenkinsData>> buildData = dataFetcher.getListOfJobData(urls);

    setState(() {
      generateResult("Store Main Job Results", buildData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Master Results"),
      ),
      body: ListView(children: [
        Container(
          color: Hexcolor("#FBFBFB"),
          margin: EdgeInsets.all(_minimumPadding * 4),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: SizedBox(
                            width: 200.0,
                            height: 200.0,
                            child: Card(
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Center(
                                    child: Text(
                                  "Agent Master",
                                  textScaleFactor: 1,
                                )),
                                onPressed: _getAllAgentMasterJobs,
                              ),
                            ),
                          ))),
                  Container(
                    width: 30,
                  ),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: SizedBox(
                            width: 200.0,
                            height: 200.0,
                            child: Card(
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Center(
                                    child: Text(
                                  "Agent Main",
                                  textScaleFactor: 1,
                                )),
                                onPressed: _getAllAgentMainJobs,
                              ),
                            ),
                          ))),
                ],
              ),
              Container(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: SizedBox(
                            width: 200.0,
                            height: 200.0,
                            child: Card(
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Center(
                                    child: Text(
                                  "Store Master",
                                  textScaleFactor: 1,
                                )),
                                onPressed: _getAllStoreMasterJobs,
                              ),
                            ),
                          ))),
                  Container(
                    width: 30,
                  ),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: SizedBox(
                            width: 200.0,
                            height: 200.0,
                            child: Card(
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Center(
                                    child: Text(
                                  "Store Main",
                                  textScaleFactor: 1,
                                )),
                                onPressed: _getAllStoreMainJobs,
                              ),
                            ),
                          ))),
                ],
              ),
              Container(
                height: 30,
              ),
            ],
          ),
        )
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

  void generateResult(String title, Future<List<JenkinsData>> al) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyResultsListPage(title, al);
    }));
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
