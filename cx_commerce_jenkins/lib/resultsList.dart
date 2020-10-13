import 'package:cx_commerce_jenkins/homePage.dart';
import 'package:cx_commerce_jenkins/resultsGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cx_commerce_jenkins/services/jenkinsDataFetcher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyResultsListPage extends StatefulWidget {
  String appBarTitle;
  Future<List<JenkinsData>> output;

  MyResultsListPage(this.appBarTitle, this.output);

  @override
  State<StatefulWidget> createState() {
    return _MyResultsListPageState(this.appBarTitle, this.output);
  }
}

class _MyResultsListPageState extends State<MyResultsListPage> {
  int _pageIndex = 0;
  List<Widget> tabPages = [
    MyHomePage(title: 'Jenkins Job App'),
    MyResultsPage()
  ];

  JenkinsDataFetcher dataFetcher=new JenkinsDataFetcher();
  String appBarTitle;
  Future<List<JenkinsData>> output;
  var _formKey = GlobalKey<FormState>();
  TextEditingController usernameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  String username="";String password="";

  _MyResultsListPageState(this.appBarTitle, this.output);


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
                    "BUILD FAILED",
                    textScaleFactor: 0.8,
                  )
                ])),
                Expanded(
                    child: Column(children: [
                  CircleAvatar(backgroundColor: Colors.yellow),
                  Container(
                    height: 5,
                  ),
                  Text(
                    "FAILURES",
                    textScaleFactor: 0.8,
                  ),
                ])),
                Expanded(
                    child: Column(children: [
                  CircleAvatar(backgroundColor: Colors.blue),
                  Container(
                    height: 5,
                  ),
                  Text(
                    "INPROGRESS",
                    textScaleFactor: 0.8,
                  ),
                ])),
                Expanded(
                    child: Column(children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    "ABORTED",
                    textScaleFactor: 0.8,
                  ),
                ]))
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
                    child:Column(children:[Expanded(child:Center(
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
                                child: Text(snapshot.data[position].failCount,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              title: Text(
                                snapshot.data[position].jobName +
                                    " -- PipeLine: " +
                                    snapshot.data[position].pipeLineNumber,
                                style: headingStyle,
                              ),
                              subtitle: Text(
                                snapshot.data[position].jobUrl,
                                style: linkStyle,
                                textScaleFactor: 1,
                              ),
                              trailing: RaisedButton(
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  child: Text("Rebuild"),
                                  onPressed: () {
                                    _loginDialog(snapshot.data[position].jobUrl,snapshot.data[position].buildUrl,context);


                                  }) //Icon(Icons.keyboard_return,color: Colors.blueAccent,),
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
      case "SUCCESS":
        return Colors.green;
        break;
      case "FAILURE":
        return Colors.red;
        break;
      case "null":
        return Colors.blue;
        break;
      case "ABORTED":
        return Colors.grey;
        break;
      default:
        return Colors.yellow;
        break;
    }
  }
  showSuccessAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Build Status"),
      content: Text("Build triggered successfully"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },

    );
  }
  showFailureAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Build Status"),
      content: Text("Build trigger failed"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },

    );
  }
  showLoaderDialog(BuildContext context,String lastBuildUrl,String url, String username, String password) async{
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
    bool status=await retriggerJob(lastBuildUrl,url, username, password);
    if(status){
      Navigator.pop(context);
      showSuccessAlertDialog(context);
    }else{
      Navigator.pop(context);
      showFailureAlertDialog(context);
    }
  }

  Future<bool> retriggerJob(String lastBuildUrl,String jobUrl,String username,String password) async{
    String parameters=await dataFetcher.getJobParametersFromAnyBuild(lastBuildUrl);
    String status=await dataFetcher.triggerAJob(jobUrl, username, password, parameters);
    print(status);
    if(status=="201"){
      return true;
    }
    else{return false;}
  }

  _loginDialog(String lastBuildUrl,String url, BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content:Form(
            key: _formKey,
            child: Column(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: usernameController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'username', hintText: 'eg. vamyarla'),
              ),
            ),
            new Expanded(
              child: new TextField(
                controller: passwordController,
                obscureText: true,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'password', hintText: 'eg. ********'),
              ),
            )
          ],
        )),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OK'),
              onPressed: () {
    if (_formKey.currentState.validate()) {
       username=usernameController.text;
       password=passwordController.text;
       Navigator.pop(context);
       showLoaderDialog(context,lastBuildUrl,url,username,password);
    }

              })
        ],
      ),
    );

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



