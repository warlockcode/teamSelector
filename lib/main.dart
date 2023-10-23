import 'package:flutter/material.dart';
import 'package:teamselector/homePage/home.dart';
import 'package:provider/provider.dart';
import 'model/datafetch.dart';
import 'Provider/detailsProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    fetchPerson();
    return ChangeNotifierProvider<DetailsProvider>(
      create: (context) => DetailsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: DataPagerWithListView(),
      ),
    );
  }
}

