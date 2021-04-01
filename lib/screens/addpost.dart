import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:path/path.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File image;
  String imageUrl = "";
  String language = "English";
  String contenttype = "Science";
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: addPostBody(context));
  }

  Widget addPostBody(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();
    final String author = ModalRoute.of(context).settings.arguments;
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    final picker = ImagePicker();
    
    var languages = [
      "Nepali",
      "English",
      "Vietnamese",
      "Hindi",
      "French",
      "Deutsch",
      "Chinese",
    ];
    var contentTitles = [
      "Science",
      "Mathematics",
      "Fashion",
      "Arts",
      "Language",
      "Computer Science",
      "History"
    ];

    Future<void> getImage() async {
      final file = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        if (file != null) {
          image = File(file.path);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No Files picked")));
        }
      });
    }

    Future<void> uploadImage() async {
      try {
        var upload = await firebase_storage.FirebaseStorage.instance
            .ref('assets/'+ basename(image.path));
        firebase_storage.TaskSnapshot task = await upload.putFile(image);
        
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Successfully added post" + imageUrl)));
      } on firebase_core.FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cannot upload file to cloud")));
      }
    }

    Future<void> addPost() {
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      return posts.add({
        'title': title.text,
        'content': content.text,
        'author': author,
        'date': date,
        'language': language,
        'media': imageUrl,
        'contentType': contenttype,
        'reputation': 1
      });
    }

    return SafeArea(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image == null
              ? Text("No image selected")
              : Image.file(
                  image,
                  width: 100,
                  height: 100,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    getImage();
                  },
                  icon: Icon(Icons.select_all),
                  label: Text("Select media"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Select your language   "),
              DropdownButton<String>(
                value: language,
                items: languages.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    language = value;
                  });

                 
                },
              ),
            ],
          ),

           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Select your content type   "),
              DropdownButton<String>(
                value: contenttype,
                items: contentTitles.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    contenttype = value;
                  });

                 
                },
              ),
            ],
          ),

          TextField(
            controller: title,
            obscureText: false,
            decoration: InputDecoration(
              icon: Icon(Icons.title_rounded),
              hintText: "Title",
              helperText: "Post Title",
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: content,
            obscureText: false,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              icon: Icon(Icons.book),
              hintText: "Content",
              helperText: "Post Content",
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton.icon(
              onPressed: () {
                uploadImage();
                addPost();
               
                Navigator.pop(context);
              },
              icon: Icon(Icons.add),
              label: Text("Add Post"))
        ],
      ),
    ));
  }
}
