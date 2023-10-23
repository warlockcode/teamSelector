import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamselector/Provider/detailsProvider.dart';
import 'package:teamselector/model/Person.dart';
import 'package:teamselector/model/datafetch.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:teamselector/teamView/teamView.dart';

class DataPagerWithListView extends StatefulWidget {
  @override
  _DataPagerWithListView createState() => _DataPagerWithListView();
}

List<Person> _paginatedPersonData = [];
List<Person> _person = [];
List<Person> _temp = [];
String selectedGender = 'All';
String selectedAvailability ='All';
String selectedDomain ='All';
List<String> filters = ['All','All','All'];
List<String> genderFilterOptions = ['All','Male','Female'];
List<String> availableFilterOptions = ['All','Available','Not Available'];
List<String> domainFilterOptions = [
  'All','Business Development',
  'Marketing',
  'IT',
  'Finance',
  'UI Designing',
  'Sales',
  'Management'];
int rowsPerPage = 10;
class Debouncer {
  late final int milliseconds;

  late VoidCallback action;
  late Timer _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
class _DataPagerWithListView extends State<DataPagerWithListView> {
  late final Debouncer _debouncer ;
  static const double dataPagerHeight = 70.0;
  bool showLoadingIndicator = false;
  double pageCount = 0;

  getData() async{
    _person = await fetchPerson() ;
    _temp = _person;
    setState(() {
      pageCount = (_person.length / rowsPerPage).ceilToDouble();
      _paginatedPersonData =
          _person.getRange(0, 10).toList(growable: false);
    });
  }
  @override
  void initState()  {
    super.initState();
    getData();
    _debouncer = Debouncer(milliseconds : 100);

  }

  void rebuildList() {
    setState(() {});
  }

  updateDataToFilter() {

    if(filters[0].compareTo('All')== 0 &&filters[1].compareTo('All') == 0 &&filters[2].compareTo('All') == 0)
      {
        setState(() {
          _person = _temp;
        });
      }
    else
      {
        setState(() {
          _person =_temp.where((element) => ((filters[0].compareTo('All')== 0 ) ? true : (element.gender.toLowerCase().compareTo(filters[0].toLowerCase())==0 )) &&
              ((filters[2].compareTo('All')== 0 ) ? true :element.available == (filters[2].compareTo('Available')== 0))&&((filters[1].compareTo('All')== 0 ) ? true :element.domain.toLowerCase().compareTo(filters[1].toLowerCase())== 0)).toList();
        });
      }

    setState(() {
      if(_person.length < 10)
      {
        pageCount = 1;
        _paginatedPersonData =
            _person.getRange(0, _person.length).toList(growable: false);
      }
      else {
        pageCount = (_person.length / rowsPerPage).ceilToDouble();
        _paginatedPersonData =
            _person.getRange(0, rowsPerPage).toList(growable: false);
      }
    });

  }
Widget searchByNameOrEmail() {
    return  TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0),),
        )
         ,filled: true,
        fillColor: Colors.blueGrey,
        contentPadding: EdgeInsets.all(15.0),
        hintText: 'Search by First Name,Last name or Email',
        hintStyle: TextStyle(fontSize: 18,color: Colors.white)
      ),
        onChanged:(String value) {
              if(value.isEmpty)
                {
                  setState(() {
                    _person = _temp;
                  });
                }
                print('here');
            _debouncer.run(() {
              setState(() {
                _person = Person.filterList(_temp, value);
                print(_person.length);
                if(_person.length < 10)
                  {
                    pageCount = 1;
                    _paginatedPersonData =
                        _person.getRange(0, _person.length).toList(growable: false);
                  }
                else {
                  pageCount = (_person.length / rowsPerPage).ceilToDouble();
                  _paginatedPersonData =
                      _person.getRange(0, rowsPerPage).toList(growable: false);
                }
              });

            });
        },
    );

}

Widget loadListView(BoxConstraints constraints) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];

      if (_person.isNotEmpty) {
        stackChildren.add(ListView.custom(
            childrenDelegate: CustomSliverChildBuilderDelegate(indexBuilder)));
      }

      if (showLoadingIndicator) {
        stackChildren.add(Container(
          color: Colors.black12,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ));
      }
      return stackChildren;
    }

    return Stack(
      children: _getChildren(),
    );
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Center(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               const Padding(
                 padding: EdgeInsets.only(left: 80),
                 child:Text('Select Filters',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
          ),
               ),
                ElevatedButton(onPressed:() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TeamView()),);

                }, child: const Text('Show Team',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),))
              ],
            ),
          ),
            backgroundColor: Colors.black45,),
            backgroundColor: Colors.black,
          body: LayoutBuilder(builder: (context, constraint) {
            return  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   customDropButton(optionList: genderFilterOptions, value: selectedGender, type: 'Gender'),

                    customDropButton(optionList: domainFilterOptions, value: selectedDomain, type: 'Domain'),

                    customDropButton(optionList: availableFilterOptions, value: selectedAvailability, type: 'Availability'),
                  ],
                ),
                searchByNameOrEmail(),
                SizedBox(
                  height: constraint.maxHeight -210,
                  child: loadListView(constraint),
                ),
                pageCount>0 ? SizedBox(
                  height: dataPagerHeight,
                  child: SfDataPagerTheme(
                      data: SfDataPagerThemeData(
                        itemTextStyle: const TextStyle(fontSize: 18,color: Colors.white),
                        selectedItemTextStyle: const TextStyle(fontSize: 22,color: Colors.white),
                        disabledItemTextStyle: const TextStyle(fontSize: 20,color: Colors.white),
                        backgroundColor: Colors.blueGrey,
                        selectedItemColor: Colors.black,
                        itemBorderRadius: BorderRadius.circular(5),
                      ),
                      child: SfDataPager(
                          pageCount: pageCount,
                          onPageNavigationStart: (pageIndex) {
                            setState(() {
                              showLoadingIndicator = true;
                            });
                          },
                          onPageNavigationEnd: (pageIndex) {
                            setState(() {
                              showLoadingIndicator = false;
                            });
                          },
                          delegate:
                          CustomSliverChildBuilderDelegate(indexBuilder)
                            ..addListener(rebuildList))),
                ):Container(),

              ],
            );
          }),
        );
  }
  Widget customDropButton({required List<String> optionList,required String value,required String type}){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type,style: const TextStyle(color: Colors.white,fontSize: 20),),
        const SizedBox(height: 5,),
        DropdownButton<String>(
          dropdownColor: Colors.blueGrey,
          style:const TextStyle(color: Colors.white,fontSize:17),
          value: value,
          items: optionList.map((String filter) {
            return DropdownMenuItem<String>(
              value: filter,
              child: Text(filter),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              if(type.compareTo('Gender') == 0)
                {
                  selectedGender= newValue!;
                  filters[0] = newValue!;
                  updateDataToFilter();
                }
              else if(type.compareTo('Domain') == 0)
                {
                  selectedDomain = newValue!;
                  filters[1] = newValue!;
                  updateDataToFilter();
                }
              else
                {
                  selectedAvailability = newValue!;
                  filters[2] = newValue!;
                  updateDataToFilter();
                }

            });
          },
        ),
      ],
    );
  }
  Widget indexBuilder(BuildContext context, int index) {
    final Person items = _paginatedPersonData[index];
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
            padding: const EdgeInsets.all(5),
              child : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        getImage(items.avatar),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(items.firstName,
                              style: const TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Text(items.lastName,
                              style: const TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(left:15),
                              child: Container(
                                height:30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100)
                                  //more than 50% of width makes circle
                                ),
                                child: (items.available)?const Icon(Icons.event_available,color:  Colors.green,size: 30,):const Icon(Icons.event_available,color:  Colors.red,size: 30,),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),


                    const SizedBox(height: 10),
                    Text("Email : ${items.email}",style: const TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),),const SizedBox(height: 10),

                    Text("Gender: ${items.gender}" ,style: const TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),),
                    const SizedBox(height: 10),
                    Text("Domain : ${items.domain}",style: const TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),),
                   const SizedBox(height: 10,),
                    ElevatedButton(onPressed: () async{
                     Provider.of<DetailsProvider>(context,listen: false).addPerson(items);

                    }, child:const Text('Add to team',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                    const SizedBox(height: 10),
                    Container(color: Colors.grey,width: MediaQuery.of(context).size.width,height:2),

                  ],),

          );
        },
      ),
    );
  }

}
Widget getImage(String urlLink) {
  try{
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(right: 12,bottom: 20),
      child: Container(
        height:80,
        width: 80,
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(100)
          //more than 50% of width makes circle
        ),
        child: Image.network(urlLink,fit: BoxFit.contain,errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 250,
            color: Colors.amber,
            alignment: Alignment.center,
            child: const Text(
              'Whoops! sorry for inconvenience',
              style: TextStyle(fontSize: 30),
            ),
          );
        },),
      ),
    );
  }
  on Exception
  {
    return Container(
      height: 250,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Text(
        'Whoops! sorry for inconvenience',
        style: TextStyle(color:Colors.white,fontSize: 30),
      ),
    );
  }
}

class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate
    with DataPagerDelegate, ChangeNotifier {
  CustomSliverChildBuilderDelegate(builder) : super(builder);

  @override
  int get childCount => _paginatedPersonData.length;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startRowIndex = newPageIndex * rowsPerPage;
    int endRowIndex = startRowIndex + rowsPerPage;

    if (endRowIndex > _person.length) {
      endRowIndex = _person.length - 1;
    }

    await Future.delayed(const Duration(milliseconds: 10));
    _paginatedPersonData =
        _person.getRange(startRowIndex, endRowIndex).toList(growable: false);
    notifyListeners();
    return true;
  }

  @override
  bool shouldRebuild(covariant CustomSliverChildBuilderDelegate oldDelegate) {
    return true;
  }
}