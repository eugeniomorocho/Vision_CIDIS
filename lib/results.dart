import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class ResultsPage extends StatefulWidget {
  ResultsPage({ this.request_number, this.file});
  final String request_number;
  final String file;

  @override
  _ResultsPageState createState() {
    return _ResultsPageState();
  }
}

class _ResultsPageState extends State<ResultsPage> {
  int page = 1;
  List<String> items = ['item 1', 'item 2', ];
  bool isLoading = false;

  final percentage = 00.00;

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
        title: Column(
          children: [
            Text("Results"),
          ],
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body:

      Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/TEMPLATE.jpg"),
          //   fit: BoxFit.fill,
          // ),
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
                    return Card(
                      child: ListTile(
                        leading: Image(image: AssetImage("assets/tuto.jpg")),
                        title: Text('${items[index]}'),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good grains: $percentage%'),
                            Text('Bad grains: $percentage%'),
                            Text('Rubbish: $percentage%'),
                          ],
                        ),
                        //
                        // isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.share_outlined,
                                size: 20.0,
                                //color: Colors.brown[900],
                              ),
                              onPressed: () {
                                print('Share');
                              },
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 20.0,
                                  //color: Colors.pink,
                                ),
                                onPressed: () {
                                  print('Deleted');
                                },
                            ),
                          ],
                        ),
                        //dense: true,
                        //enabled: false,
                        onTap: () {

                        },
                      ),
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