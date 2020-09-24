import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idb_shim/idb.dart';
import 'package:neosoftassignment/database/dbtask.dart';
import 'package:neosoftassignment/models/brewery_models.dart';
import 'dart:js' as js;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<String> breweryTypeList = new List();
  List<BreweryModel> breweryList;
  List<BreweryModel> breweryListFinal = new List();
  String selectedSearchType = "All";
  String searchData ="";
  int pageCount =1;
  int pageCounter = 1;
  bool isAscendingOrder = true;
  @override
  void initState() {
    super.initState();
    breweryTypeList.add("All");
    breweryTypeList.add("Name");
    breweryTypeList.add("City");
    breweryTypeList.add("State");
    breweryTypeList.add("Country");
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        'assets/images/beer_img.jpg')),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "The Beer Company",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Text(
                        "We specialize in Beers!",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 80.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(5.0)),
                              width: 100.0,
                              child: breweryTypeDropDown(),
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Container(
                            width: 400.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: TextField(
                              cursorColor: Colors.blueAccent,
                              style: TextStyle(color: Colors.black, fontSize: 10.0),
                              readOnly: this.selectedSearchType == "All" ? true : false,
                              decoration: InputDecoration(
                                icon: Icon(Icons.search),
                                hintText: this.selectedSearchType == "All" ? 'Please select Type First' : 'Search by $selectedSearchType here',
                              ),
                              onChanged: (text) {
                                //print("First text field: $text");
                                setState(() {
                                  this.searchData = text;
                                  filterListByType(this.selectedSearchType);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.blueAccent,
                    onTap: () {
                      setState(() {
                        if(this.pageCounter > 1) {
                          this.pageCounter--;
                          getContentByPage();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: (this.pageCounter >1) ?Colors.blueAccent : Colors.black),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.skip_previous_sharp,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.0),
                              child: Text(
                                "Previous",
                                style: TextStyle(color: Colors.black, fontSize: 10.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    child: Text(
                      "$pageCounter",
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        if(this.pageCounter < this.pageCount) {
                          this.pageCounter++;
                          getContentByPage();
                        }
                      });

                    },
                    splashColor: Colors.blueAccent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: (this.pageCounter <this.pageCount) ? Colors.blueAccent : Colors.black),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Next",
                              style: TextStyle(color: Colors.black, fontSize: 10.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.0),
                              child: Icon(
                                Icons.skip_next_sharp,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30.0,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            if(this.isAscendingOrder) {
                              this.isAscendingOrder = false;
                            } else {
                              this.isAscendingOrder = true;
                            }
                            sortListByAlphabetically();
                          });
                          print("isAscendingOrder - $isAscendingOrder");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              this.isAscendingOrder ? "A-Z" : "Z-A",
                              style: TextStyle(color: Colors.black, fontSize: 10.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.0),
                              child: Icon(
                                this.isAscendingOrder ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],

                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: (this.breweryList != null && this.breweryList.length>0) ?
              Container(
                decoration: BoxDecoration(
                   // color: Colors.grey[300],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0)),
                child:
                GridView.count(
                  crossAxisCount:(MediaQuery.of(context).size.width < 300) ? 1 : (MediaQuery.of(context).size.width > 300 && MediaQuery.of(context).size.width < 700) ?2 : 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  shrinkWrap: true,
                  children: List.generate(breweryList.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
//                        width: 100.0,
//                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  'assets/images/beer_img_2.jpg')),
                          boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),],
                          //border: Border.all(color: Colors.blueAccent),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0),),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: (MediaQuery.of(context).size.width > 600) ? MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              Text(
                                "${breweryList[index].name}",
                                softWrap: true,
                                style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Text(
                                  "${breweryList[index].breweryType}",
                                  softWrap: true,
                                  style: TextStyle(color: Colors.white, fontSize: 15.0,fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Container(
                                  //height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Website",
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:3.0),
                                        child: InkWell(
                                          onTap: (){
                                            js.context.callMethod("open", [breweryList[index].websiteUrl]);
                                          },
                                          child: Text(
                                            breweryList[index].websiteUrl,
                                            softWrap: true,
                                            style: TextStyle(color: Colors.blue, fontSize: 10.0,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Container(
                                  //height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Contact Info",
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:3.0),
                                        child: Text(
                                          breweryList[index].phone,
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Container(
                                  //height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "City",
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:3.0),
                                        child: Text(
                                          breweryList[index].city,
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Container(
                                  //height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "State",
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:3.0),
                                        child: Text(
                                          breweryList[index].state,
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Container(
                                  //height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Country",
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:3.0),
                                        child: Text(
                                          breweryList[index].country,
                                          softWrap: true,
                                          style: TextStyle(color: Colors.white, fontSize: 10.0,fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },),
                ) ,
              ) :
              Container(
              child: Center(
              child: Text(
              "No Record Found",
              style: TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold),
            ),
    ),
    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget breweryTypeDropDown() {
    return DropdownButton(
      hint: Text(
        this.selectedSearchType
      ),
      items: getBreweryTypeOption(),
      onChanged: (data){
        setState(() {
          this.selectedSearchType = data;
          filterListByType(data);
        });
      },
      //isExpanded: true,
    );
  }
  void filterListByType(String type) {
    if(searchData.isNotEmpty) {
      switch (type) {
        case 'All':
          {
            this.breweryList = this.breweryListFinal;
            break;
          }
        case 'Name':
          {
            print("filterListByType - $type");
            this.breweryList = this.breweryList.where((element) => element.name.contains(this.searchData)).toList();
            break;
          }
        case 'City':
          {
            this.breweryList = this.breweryList.where((element) => element.city.contains(this.searchData)).toList();
            break;
          }
        case 'State':
          {
            this.breweryList = this.breweryList.where((element) => element.state.contains(this.searchData)).toList();
            break;
          }
        case 'Country':
          {
            this.breweryList = this.breweryList.where((element) => element.country.contains(this.searchData)).toList();
            break;
          }
      }
    } else {
      print("breweryListFinal length - ${breweryListFinal.length}");
      this.breweryList = this.breweryListFinal;
    }
    getPageCount();
  }

  List<DropdownMenuItem> getBreweryTypeOption() {
    List<DropdownMenuItem> tempList = new List();
    for (var data in breweryTypeList) {
      tempList.add(new DropdownMenuItem(
        child: Text(
          data,
        ),
        value: data,
      ));
    }
    return tempList;
  }

  getData() async {
    var res = await http.get("https://api.openbrewerydb.org/breweries");
    //print(res.body);
    List<dynamic> breweryArray = jsonDecode(res.body);
    DbTask dbTask = DbTask();
    Database db = await dbTask.open();

    this.breweryList = await dbTask.getData(db);
    print("breweryList count - ${breweryList.length}");
    if(this.breweryList == null || this.breweryList.length ==0) {
      for(var element in breweryArray) {
        BreweryModel model = BreweryModel.fromJson(element);
        var index = await dbTask.insertData(model, db);

        this.breweryList = await dbTask.getData(db);
      }
    }
  if(this.breweryList != null && this.breweryList.length >0 ) {
    this.breweryListFinal = this.breweryList;
    getContentByPage();
    sortListByAlphabetically();
  }
    print("breweryList length - ${breweryList.length}");
    setState(() {
      getPageCount();
    });
  }

  void getContentByPage() {
    if(this.breweryList.length > 20) {
      int startPoint =0;
      int endPoint = this.breweryList.length;
      if(this.pageCounter == 1) {
        startPoint = 0;
        endPoint = 19;
      }else {
        startPoint = (20 * this.pageCounter) -20;
        endPoint = (20 * this.pageCounter) -1;
      }
      this.breweryList = this.breweryList.sublist(startPoint,endPoint);
    }
    }

  void getPageCount() {
    if(this.breweryList != null && this.breweryList.length >0) {
      int count = this.breweryList.length;
      print("count - $count");
      if (count > 20) {
        double pageCount = (count / 20);
        print("pageCountString - ${count % 20}");
        String pageCountString = pageCount.toString();

        //List<String> pageCountList = pageCountString.split(".");
        int remainder = count % 20;
        if (remainder > 0) {
          this.pageCount = count + 1;
        } else {
          this.pageCount = count;
        }
      }
      getContentByPage();
    }
  }

  void sortListByAlphabetically() {
    if(this.isAscendingOrder) {
      this.breweryList.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else {
      this.breweryList = this.breweryList.reversed.toList();
    }
  }
}
