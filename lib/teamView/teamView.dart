import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamselector/Provider/detailsProvider.dart';
import 'package:teamselector/homePage/home.dart';
import 'package:teamselector/model/Person.dart';

class TeamView extends StatefulWidget {
  const TeamView({super.key});

  @override
  State<TeamView> createState() => _TeamViewState();
}
List<Person> items =[];
class _TeamViewState extends State<TeamView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    items = Provider.of<DetailsProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
        title: const Center(child: Text('My Team',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),)),
      ),
      backgroundColor: Colors.black,
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount:items.length ,
             shrinkWrap: true,

        itemBuilder: (BuildContext context, int index) {
                  return Container(

                    padding: const EdgeInsets.all(5),
                    child : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            getImage(items[index].avatar),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(items[index].firstName,
                                  style: const TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,

                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Text(items[index].lastName,
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
                                    child: (items[index].available)?const Icon(Icons.event_available,color:  Colors.green,size: 30,):const Icon(Icons.event_available,color:  Colors.red,size: 30,),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),


                        const SizedBox(height: 10),
                        Text("Email : ${items[index].email}",style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,

                        ),),
                        const SizedBox(height: 10),

                        Text("Gender: ${items[index].gender}" ,style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,

                        ),),
                        const SizedBox(height: 10),
                        Text("Domain : ${items[index].domain}",style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,

                        ),),
                        const SizedBox(height: 10,),
                        ElevatedButton(onPressed: () async{
                        Provider.of<DetailsProvider>(context,listen: false).removePerson(items[index]);

                        }, child:const Text('Remove from team',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                        const SizedBox(height: 10),
                        Container(color: Colors.grey,width: MediaQuery.of(context).size.width,height:2),

                      ],),

                  );
                },

        ),
    ),
    );
  }
}
