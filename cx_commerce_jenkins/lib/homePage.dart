import 'package:cx_commerce_jenkins/triggerResultsList.dart';
import 'package:cx_commerce_jenkins/constants/dataUrls.dart';
import 'package:cx_commerce_jenkins/resultsGenerator.dart';
import 'package:cx_commerce_jenkins/services/jenkinsDataFetcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController usernameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final _minimumPadding = 5.0;
  var _formKey = GlobalKey<FormState>();
  int _pageIndex = 0;
  List<Widget> tabPages = [
    MyHomePage(title: 'Jenkins Job App'),
    MyResultsPage()
  ];
  JenkinsDataFetcher dataFetcher = new JenkinsDataFetcher();
  
  void _triggerAllAgentMasterJobs() async {
    String params = await DefaultAssetBundle.of(context).loadString("assets/agentMasterParameters.json");

    setState(() {
      if (_formKey.currentState.validate()) {
        String username=usernameController.text;
        String password=passwordController.text;
        Future<List<JenkinsJobStatus>> jobStatusData=dataFetcher.triggerAllJobs(Constants.AGENT_MASTER_JOB_LINK,username,password,params);
        generateResult("Agent Master Job", jobStatusData);
      }
    });
  }

  void _triggerAllAgentMainJobs() async{
    String params = await DefaultAssetBundle.of(context).loadString("assets/agentMainParameters.json");

    setState(() {
      if (_formKey.currentState.validate()) {
        String username=usernameController.text;
        String password=passwordController.text;
        Future<List<JenkinsJobStatus>> jobStatusData=dataFetcher.triggerAllJobs(Constants.AGENT_MAIN_JOB_LINK,username,password,params);
        generateResult("Agent Main Job", jobStatusData);
      }
    });
  }

  void _triggerAllStoreMasterJobs() {
    setState(() {
      if (_formKey.currentState.validate()) {
        String username=usernameController.text;
        String password=passwordController.text;

        Future<List<JenkinsJobStatus>> jobStatusData=dataFetcher.triggerAllJobsFromPreviousParams(Constants.STORE_MASTER_JOB_LINK,username,password);
        generateResult("Store Master Job", jobStatusData);
      }
    });
  }

  void _triggerAllStoreMainJobs() {
    setState(() {
      if (_formKey.currentState.validate()) {
        String username=usernameController.text;
        String password=passwordController.text;

        Future<List<JenkinsJobStatus>> jobStatusData=dataFetcher.triggerAllJobsFromPreviousParams(Constants.STORE_MAIN_JOB_LINK,username,password);
        generateResult("Store Main Job", jobStatusData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.blueGrey); //Theme.of(context).textTheme.headline4;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding * 2),
          child: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 2, bottom: _minimumPadding * 2),
                  child: Text(
                    "Trigger Jenkins Jobs here",
                    style: headingStyle,
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Enter Username';
                      }
                    },
                    controller: usernameController,
                    decoration: InputDecoration(
                        labelText: 'Jenkins Username',
                        hintText: 'username',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Enter Password';
                      }
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Jenkins Password',
                        hintText: 'password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 3, bottom: _minimumPadding * 3),
                  child: ButtonTheme(
                    height: 60.0,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Run Agent Master Jobs",
                          textScaleFactor: 2,
                        ),
                        onPressed: _triggerAllAgentMasterJobs,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        )),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 3, bottom: _minimumPadding * 3),
                  child: ButtonTheme(
                    height: 60.0,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Run Agent Main Jobs",
                          textScaleFactor: 2,
                        ),
                        onPressed: _triggerAllAgentMainJobs,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        )),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 3, bottom: _minimumPadding * 3),
                  child: ButtonTheme(
                    height: 60.0,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Run Store Master Jobs",
                          textScaleFactor: 2,
                        ),
                        onPressed: _triggerAllStoreMasterJobs,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        )),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 3, bottom: _minimumPadding * 3),
                  child: ButtonTheme(
                    height: 60.0,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Run Store Main Jobs",
                          textScaleFactor: 2,
                        ),
                        onPressed: _triggerAllStoreMainJobs,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        )),
                  )),
            ],
          ),
        ),
      ),
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

  void generateResult(String title, Future<List<JenkinsJobStatus>> al) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BuildResultsListPage(title, al);
    }));
  }

}
