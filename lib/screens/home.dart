import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  String currentUserID, currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Home"),
            Spacer(),
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                })
          ],
        ),
        centerTitle: true,
      ),
      drawer: drawerBar(context),
      body: homeBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addpost', arguments: currentUser);
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }

  Widget drawerBar(BuildContext context) {
    var contentTitles = [
      "Science",
      "Mathematics",
      "Fashion",
      "Arts",
      "Language",
      "Computer Science",
      "History"
    ];
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
            child: Row(
          children: [
            Icon(Icons.book),
            Text("Subjects"),
            Spacer(),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/requested');
                },
                icon: Icon(Icons.request_page),
                label: Text("Requested pages"))
          ],
        )),
        Container(
            child: SingleChildScrollView(
          child: Column(
            children: contentTitles
                .map((content) => ListTile(
                      title: Text(content),
                      onTap: () => Navigator.pushNamed(context, '/content',
                          arguments: content),
                    ))
                .toList(),
          ),
        ))
      ],
    ));
  }

  Widget homeBody(BuildContext context) {
    return myFuture(context);
  }

  Widget myFuture(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("users");

    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) currentUserID = auth.currentUser.uid;

    return FutureBuilder(
        future: users.doc(currentUserID).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong.");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            currentUser = data['name'];
            return Column(
                children: [Text("Welcome " + currentUser), ListPosts()]);
          }
          return CircularProgressIndicator();
        });
  }
}

class ListPosts extends StatefulWidget {
  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection("posts");

    return StreamBuilder<QuerySnapshot>(
      stream: posts.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Cannot load posts");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Expanded(
          child: ListView(
            padding: EdgeInsets.all(15),
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return buildCard(context, document);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildCard(BuildContext context, DocumentSnapshot document) {
    void addToRequested(String docID) {
      CollectionReference req =
          FirebaseFirestore.instance.collection("requested translation");

      var languages = [
        "Nepali",
        "English",
        "Vietnamese",
        "Hindi",
        "French",
        "Deutsch",
        "Chinese",
      ];

      String reqLang = "English";

      AlertDialog askLang = AlertDialog(
          title: Text("Select language"),
          content: Column(
            children: [
              DropdownButton<String>(
                value: reqLang,
                items: languages.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    reqLang = value;
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    req.add({
                      "document": docID,
                      "requested language": reqLang,
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          ));

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return askLang;
          });
    }

    return Center(
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(alignment: Alignment.bottomLeft, children: [
                      Ink.image(
                        height: 200,
                        image: NetworkImage(
                            "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/full_jpg_1.jpeg"),
                        fit: BoxFit.fitWidth,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            document.data()['contentType'],
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: Colors.redAccent,
                            ),
                          ))
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 10),
                      child: 
                      Column(
                        children: [
                          Text(document.data()['title'], style: TextStyle(color: Colors.blueAccent, fontSize: 32)),
                          
                          Text(document.data()['content']), 
                          Text("Author: " + document.data()['author'])
                        ]
                      )
                    ),
                    ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      alignment: MainAxisAlignment.start,
                      buttonHeight: 30,
                      buttonMinWidth: 5,
                      //buttonPadding: EdgeInsets.all(2),
                      //mainAxisSize: MainAxisSize.max,
                      //overflowDirection:VerticalDirection.down ,
                      //overflowButtonSpacing:10,

                      children: <Widget>[
                        ElevatedButton.icon(
                          icon: Icon(Icons.favorite),
                          onPressed: () {
                            //.push(
                            //context,
                            //MaterialPageRoute(
                            //builder :(context)=> Newpage("this is new")
                            // )
                            //);
                          },
                          label: Text(document.data()['reputation'].toString()),
                        ),
                        ElevatedButton.icon(
                            label: Text("Request"),
                            onPressed: () {
                              addToRequested(document.id);
                            },
                            icon: Icon(Icons.request_page)),
                        ElevatedButton.icon(
                            label: Text("Share"),
                            onPressed: () {},
                            icon: Icon(Icons.share)),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}

class PostImage extends StatelessWidget {
  String imURL;
  PostImage(this.imURL);

  @override
  Widget build(BuildContext context) {
    if (imURL == null)
      return Icon(Icons.create);
    else
      return Image.network(imURL);
  }
}
