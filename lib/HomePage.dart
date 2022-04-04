import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pattern_setstate/model/post.model.dart';

import 'servise/http_servise.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = false;
  List<Post> items = [];
  void apiPoastList ()async{
    setState(() {
      isLoading = true;
    });
    var responce = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    setState(() {
      if(responce != null ){
        items = Network.parsePostList(responce);

      }else{
        items = [];

      }
      isLoading = false;

    });

  }
  void apiPostDelete(Post post)async{
    setState(() {
      isLoading =true;
    });
    var response = await Network.DEL(Network.API_DELETE + post.id.toString(),Network.paramsEmpty());
    setState(() {
      if(response != null){
      apiPoastList();}
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiPoastList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PATTERN - SETSTATE"),
      ),
      body: Stack(
        children: [
          ListView.builder(itemCount: items.length,itemBuilder:( ctx, index){
          return itemOfPost(items[index]);
          }
          ),
      isLoading?Center(
        child: CircularProgressIndicator()):SizedBox.shrink(),
        ],
      ),
    );
  }
  Widget itemOfPost (Post post){
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: ScrollMotion(),
        children: [
          SlidableAction(onPressed: (BuildContext context){
            apiPostDelete(post);
          },
            flex: 3,
              backgroundColor:  Color(0xFFFE4A49),
            foregroundColor:  Colors.white,
            icon:  Icons.delete,
            label:  'Delete',

          )
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 20,top: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title!.toUpperCase(),style: TextStyle(color:  Colors.black, fontWeight: FontWeight.bold),

            ),
            SizedBox(height: 5,width: 0,),
           Text(post.body!)
          ],
        ),
      ),
    );
  }
}
