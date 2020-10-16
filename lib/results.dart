import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int page = 1;
  List<String> items = ['item 1', 'item 2', ];
  bool isLoading = false;

  Future _loadData() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(seconds: 2));

    print("load more");
    // update data and loading status
    setState(() {
      items.addAll( ['item 1']);
      print('items: '+ items.toString());
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body:

      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/TEMPLATE.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
              children: <Widget>[
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading && scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    _loadData();
                    // start loading data
                    setState(() {
                      isLoading = true;
                    });
                  }
                },
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${items[index]}'),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: isLoading ? 50.0 : 0,
              color: Colors.transparent,
              child: Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}