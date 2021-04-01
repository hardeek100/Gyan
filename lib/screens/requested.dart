import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Requested extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection("posts");
    CollectionReference requested = FirebaseFirestore.instance.collection("requested translation");
    

    return StreamBuilder<QuerySnapshot>(
      stream: requested.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Text("Cannot load posts");
        }
            if(snapshot.connectionState == ConnectionState.waiting){
          
          return Center( child: CircularProgressIndicator());
        }

       return Expanded(
        
         child: ListView(
           padding: EdgeInsets.all(15),
           children: snapshot.data.docs.map((DocumentSnapshot document){
              return Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(34),
                  onTap:(){

                  },
                  child: ListTile(
                    leading: Image.network('https://picsum.photos/250?image=9'),
                    title: Text(document.data()['document'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),),
                    subtitle: Column(children: [
                      Container(
                        child: Text(document.data()['requested language'].toString()),
                      ),
                      Row(children: [
                        IconButton(icon: Icon(Icons.favorite), onPressed: (){
                           // document.data().update('reputation', (value) => value = value+1);
                        },
                        ),
                       
                        Text("Share"),
                        IconButton(icon: Icon(Icons.share), onPressed: (){

                        }),
                        
                        Text("Request"),
                        IconButton(icon: Icon(Icons.request_page), onPressed: (){
                           
                        })

                      ],)
                    ],),
                  )
                ),
              );
              
            }).toList(),
         ),
       );

      },
      );
  }
}