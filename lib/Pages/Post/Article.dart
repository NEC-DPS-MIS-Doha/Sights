import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avatars/avatars.dart';
// import 'package:flutter_summernote/flutter_summernote.dart';

class ArticlePostPage extends StatefulWidget {
  const ArticlePostPage({Key? key, required this.location, required this.user})
      : super(key: key);
  final Map location;
  final User? user;

  @override
  State<ArticlePostPage> createState() => _ArticlePostPageState();
}

class _ArticlePostPageState extends State<ArticlePostPage> {
  // GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? username =
        (widget.user?.displayName == '' || widget.user?.displayName == null)
            ? 'User'
            : widget.user?.displayName;
    debugPrint(widget.user.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Article'),
        actions: [
          Transform.scale(
            scale: .70,
            child: FittedBox(
              fit: BoxFit.cover,
              child: InkWell(
                  borderRadius: BorderRadius.circular(42),
                  onTap: () {},
                  child: Avatar(
                    name: username,
                  )),
            ),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                  flex: 1),
              SizedBox(
                height: 10,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  // Spacer(),

                  SizedBox(
                    width: 10,
                  ),
                Expanded(child:   ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: Text('Post'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50), // NEW
                    )))
                ],
              )
            ],
          )),
    );
  }
}
