import 'package:flutter/material.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../models/saved_service.dart';
import '../../utils/enums.dart';

class SavedScreen extends StatefulWidget {
  static String routeName = "/details";
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://ihaofykdrzgouxpitrvi.supabase.co/storage/v1/object/public/postimages/yanfaa/images/yanfaa_1.png?t=2024-06-19T15%3A53%3A52.560Z'), // Use a real URL or asset
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'You saved 48 Services 👍',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Organizations'),
              Tab(text: 'People'),
            ],
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SavedServiceList(filter: 'All'),
                SavedServiceList(filter: 'Organizations'),
                SavedServiceList(filter: 'People'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.bookmark),
    );
  }
}

class SavedServiceList extends StatelessWidget {
  final String filter;

  SavedServiceList({required this.filter});

  final List<SavedService> savedServices = [
    SavedService(
      name: 'Yanfaa',
      category: 'Learning',
      location: 'Cairo, Egypt',
      status: 'Closed',
      imageUrl:
          'https://ihaofykdrzgouxpitrvi.supabase.co/storage/v1/object/public/postimages/yanfaa/images/yanfaa_4.png?t=2024-06-19T15%3A53%3A02.796Z', // Use a real URL or asset
    ),
    SavedService(
      name: 'Ahmed Ali',
      category: 'Learning',
      location: 'Cairo, Egypt',
      status: 'Open',
      imageUrl:
          'https://ihaofykdrzgouxpitrvi.supabase.co/storage/v1/object/public/postimages/yanfaa/images/yanfaa_4.png?t=2024-06-19T15%3A53%3A02.796Z', // Use a real URL or asset
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<SavedService> filteredServices = savedServices.where((service) {
      if (filter == 'All') return true;
      return service.category == filter;
    }).toList();

    return ListView.builder(
      itemCount: filteredServices.length,
      itemBuilder: (context, index) {
        return SavedServiceCard(service: filteredServices[index]);
      },
    );
  }
}

class SavedServiceCard extends StatelessWidget {
  final SavedService service;

  SavedServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFEBF1FF),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Image.network(
              service.imageUrl,
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(service.category),
                  Text(service.location),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: service.status == 'Open' ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                service.status,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
