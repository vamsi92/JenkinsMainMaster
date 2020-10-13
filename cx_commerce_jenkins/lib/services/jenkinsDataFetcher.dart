import 'dart:async';
import 'dart:convert';
import 'package:cx_commerce_jenkins/constants/dataUrls.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class JenkinsDataFetcher {
  static JenkinsDataFetcher dataFetcher;

  JenkinsDataFetcher.createInstance();

  factory JenkinsDataFetcher() {
    if (dataFetcher == null) {
      dataFetcher = JenkinsDataFetcher.createInstance();
    }
    return dataFetcher;
  }

  Future<List<JenkinsData>> getListOfJobData(List<String> jenkinsUrls) async{
    List<JenkinsData> buildData=[];
    for(String link in jenkinsUrls){
      Future<JenkinsData> jData=dataFetcher.getDataFromJenkinsJobLinks(link);
      buildData.add(await jData);
    }
    return buildData;
  }

  Future<JenkinsData> getDataFromJenkinsJobLinks(String jenkinsUrl) async {
    String failCount;
    String pipelineNumber;
    var response = await http.get(jenkinsUrl+Constants.API_EXTENSION);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
          if(data["lastBuild"]!=null) {
            var lastBuildUrl = data["lastBuild"]["url"];
            var lastBuildResponse = await http.get(
                lastBuildUrl + Constants.API_EXTENSION);
            var lastBuildData = json.decode(lastBuildResponse.body);

            var actions = lastBuildData["actions"];
            failCount = getFailCount(actions);
            pipelineNumber = getPipelineNumber(actions);

            JenkinsData jData = JenkinsData(
                data["displayName"], lastBuildData["url"],
                lastBuildData["result"],
                failCount, pipelineNumber,jenkinsUrl);
            print(jData);
            return jData;

          }else{

          }
        }
    else {
      throw Exception("Failed to load");
    }
  }

  Future<List<JenkinsJobLinks>> getDataFromJenkins(String jenkinsUrl) async {
    var response = await http.get(jenkinsUrl);
    if (response.statusCode == 200) {
      var data= json.decode(response.body);
      List<JenkinsJobLinks> jenkinsJobList=[];
        var jobsList=data["jobs"];
        for(var url in jobsList){
          JenkinsJobLinks jLinks=JenkinsJobLinks(url["url"]);
          jenkinsJobList.add(jLinks);
        }

        return jenkinsJobList;

    } else {
      throw Exception("Failed to load");
    }
  }

  String getPipelineNumber(var actions) {
    String pipeline="";
    for(var dat in actions){
    if(dat.toString().contains("BuildCloudCommerce")) {
      pipeline = dat["text"].toString();
      break;
    }
    }

    RegExp exp=new RegExp("(Pipeline-)(\\d+)(-BuildCloudCommerce)");
    Iterable<RegExpMatch> matches = exp.allMatches(pipeline);
    matches.forEach((element) {pipeline=element.group(2);});
    return pipeline;

  }

  String getFailCount(var actions) {
    String failCount;
    for(var dat in actions){
      if(dat.toString().contains("failCount")){
        failCount=dat["failCount"].toString();
        break;
      }
      else {
        failCount="NA";
      }
    }
    return failCount;
  }

  /***
   **** triggering jobs
   * */

  Future<List<JenkinsJobStatus>> triggerAllJobs(String jenkinUrl,String username,String password,String parameters) async{
    var jsonResult = json.decode(parameters);
    List<dynamic> params=jsonResult as List;

    List<JenkinsJobStatus> jobStatus=[];

    Future<List<JenkinsJobLinks>> data = getDataFromJenkins(
        jenkinUrl + Constants.API_EXTENSION);
    List<JenkinsJobLinks> ls = await data;

    List<String> urls = new List<String>();
    ls.forEach((element) {
      urls.add(element.url);
    });

    for(int i=0;i<params.length;i++) {
      String responseCode=await triggerAJob(urls[i],username, password, params[i].toString());
      var response = await http.get(urls[i]+Constants.API_EXTENSION);
        var data = json.decode(response.body);
        String displayName=data["displayName"];
        JenkinsJobStatus js=JenkinsJobStatus(displayName, responseCode);
        jobStatus.add(js);
    }

    return jobStatus;
  }

  Future<List<JenkinsJobStatus>> triggerAllJobsFromPreviousParams(String jenkinUrl,String username,String password) async{

    List<JenkinsJobStatus> jobStatus=[];

    Future<List<JenkinsJobLinks>> data = getDataFromJenkins(
        jenkinUrl + Constants.API_EXTENSION);
    List<JenkinsJobLinks> ls = await data;

    List<String> urls = new List<String>();
    ls.forEach((element) {
      if (!element.url.contains("Forward")) {
      urls.add(element.url);
      }
    });

    for(int i=0;i<urls.length;i++) {
      String jobParams = await getJobParametersFromPreviousBuild(urls[i]+ Constants.API_EXTENSION);
      String responseCode=await triggerAJob(urls[i],username, password, jobParams);
      var response = await http.get(urls[i]+Constants.API_EXTENSION);
      var data = json.decode(response.body);
      String displayName=data["displayName"];
      JenkinsJobStatus js=JenkinsJobStatus(displayName, responseCode);
      jobStatus.add(js);
    }

    return jobStatus;
  }

  Future<String> triggerAJob(String url,String username,String password,String parameters) async{
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    Response response = await post(url+"buildWithParameters",
        headers: {"Content-Type": "application/json",'authorization': basicAuth},body: json.encode(parameters));
    return response.statusCode.toString();
  }

    Future<String> getJobParametersFromPreviousBuild(String previousBuildUrl) async{

    var response = await http.get(previousBuildUrl);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if(data["lastBuild"]!=null) {
        var lastBuildUrl = data["lastBuild"]["url"];
        var lastBuildResponse = await http.get(
            lastBuildUrl + Constants.API_EXTENSION);
        var lastBuildData = json.decode(lastBuildResponse.body);

        var actions = lastBuildData["actions"];
        var paramsArray=[];
        for(var dat in actions) {
          if (dat.toString().contains("parameters")) {
            paramsArray = dat["parameters"];
            break;
          }
        }
        for(int j=0;j<paramsArray.length;j++){
          paramsArray[j].remove("_class");
        }
       return paramsArray.toString();
      }else{

      }
    }
    else {
      throw Exception("Failed to load");
    }

  }


  Future<String> getJobParametersFromAnyBuild(String buildUrl) async{

    var response = await http.get(buildUrl+Constants.API_EXTENSION);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
        var actions = data["actions"];
        var paramsArray=[];
        for(var dat in actions) {
          if (dat.toString().contains("parameters")) {
            paramsArray = dat["parameters"];
            break;
          }
        }
        for(int j=0;j<paramsArray.length;j++){
          paramsArray[j].remove("_class");
        }
        return paramsArray.toString();
    }
    else {
      throw Exception("Failed to load");
    }

  }



}



class JenkinsData {
  final String jobName;
  final String jobUrl;
  final String status;
  final String failCount;
  final String pipeLineNumber;
  final String buildUrl;

  JenkinsData(this.jobName, this.jobUrl, this.status,this.failCount,this.pipeLineNumber,this.buildUrl);

}

class JenkinsJobLinks{
  final String url;

  JenkinsJobLinks(this.url);
}

class JenkinsJobStatus{
  final String displayName;
  final String status;

  JenkinsJobStatus(this.displayName,this.status);
}
