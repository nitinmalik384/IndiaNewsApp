import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';

import 'article_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class  _HomeState extends State<Home> {
  List<CategoryModel> categories = List<CategoryModel>();
  List<ArticleModel> articles = List<ArticleModel>();
  static List<Widget> blogtiles = List<Widget>();
  bool _loading=true;
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getNews();


  }
  getNews() async{
    News newsObject=News();
    print("getting articles");
    await newsObject.getNews();
    articles= newsObject.news;
    setState(() {
      _loading=false;
    });
    for(int i =0;i<articles.length;i++)
      {
        print(i);
        blogtiles.add(BlogTile(imageUrl: articles[i].imageUrl,
            title: articles[i].title,
           description: articles[i].description,
            url: articles[i].url,
          index: i,
          ));

      }
  //  blogtiles.add(RefreshWidget());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("India",style: TextStyle(fontWeight: FontWeight.bold,),),
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        elevation: 0,
      ),
      body: _loading ? Container(
        child: Center(
          child: SpinKitWave(
            color: Colors.lightBlue,
            size: 50.0,
          ),
        ),
      ) :SingleChildScrollView(
        child: Container(

          child: Column(
            children: [
              Container(
                height: 70,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(


                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return CategoryTile(categoryName: categories[index].categoryName,
                      imageUrl: categories[index].imageUrl,
                      );
                    }),
              ),
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                  physics: ClampingScrollPhysics(),
                itemCount: articles.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder:(context,index){

                return BlogTile(imageUrl: articles[index].imageUrl,
                title: articles[index].title,
                description: articles[index].description,
                  url: articles[index].url,
                );
              } )
              // Container(
              //   alignment: Alignment.center,
              //   color: Colors.transparent,
              //   width: MediaQuery.of(context).size.width ,
              //   height: MediaQuery.of(context).size.height * 0.8,
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //
              //
              //   // Important to keep as a stack to have overlay of cards.
              //   child: Stack(
              //     children: blogtiles,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;

  const CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Fluttertoast.showToast(msg: categoryName,toastLength: Toast.LENGTH_SHORT,
          //  toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,


            textColor: Colors.deepPurple,
            fontSize: 16.0);

      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl:imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
                height: 60,
                child: Text(categoryName, style: TextStyle(color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
             decoration: BoxDecoration(
               color: Colors.black26,
               borderRadius: BorderRadius.circular(6),
             ),),
          ],
        ),
      ),
    );
  }
}
class BlogTile extends StatelessWidget {
  final String imageUrl,title,description,url;
  final int index;
  BlogTile({@required this.imageUrl,@required this.description,@required this.title,@required this.url,@required this.index});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
     builder: (context,constraints){
       if (constraints.maxWidth<768)
         {
           return GestureDetector(
             child: Container(
               margin: EdgeInsets.only(top: 10),

               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Colors.white54,

               ),


               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   ClipRRect(child: Image.network(imageUrl,fit: BoxFit.fill,)
                     ,borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),),
                   SizedBox(height: 16,),

                   ExpandablePanelItem(title: title,description: description,),


                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       MaterialButton(onPressed: (){
                         Navigator.push(context,MaterialPageRoute(builder: (context)=>ArticleView(url: url)));
                       },child: Text("Read more",style: TextStyle(color: Colors.blue[500],
                           decoration: TextDecoration.underline),),),
                     ],
                   ),
                   Divider(thickness: 0.5,)


                 ],
               ),
             ),
             onTap: (){



             },
           );
         }
       else{
         return GestureDetector(
           child: Container(
             margin: EdgeInsets.only(top: 10),

             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               color: Colors.white54,

             ),


             child: Row(
               //crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 Expanded(
                   flex: 1,
                   child: ClipRRect(child: Image.network(imageUrl,fit: BoxFit.cover,height: 200,)
                     ,borderRadius: BorderRadius.circular(10),),
                 ),
                 SizedBox(width: 16,),

                Expanded(
                  flex: 2,child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(title,
                      style: TextStyle(fontSize: 18,color: Colors.black87,fontWeight: FontWeight.w600 ,
                      ),

                    ),
                    SizedBox(height: 10,),
                    Text(description,style: TextStyle(color: Colors.black54),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MaterialButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ArticleView(url: url)));
                        },child: Text("Read more",style: TextStyle(color: Colors.blue[500],
                            decoration: TextDecoration.underline),),),
                      ],
                    ),
                  ],
                ),),



                 Divider(thickness: 0.5,)


               ],
             ),
           ),
           onTap: (){



           },
         );
       }
     },
    );
  }
}

  ExpandablePanelItem({String title,String description}){

    if (description.length>100) {
      return ExpandablePanel(
          header: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          collapsed: Text(
            description.substring(0, 100) + "...",
            style: TextStyle(color: Colors.black54),
          ),
          expanded: Text(
            description,
            style: TextStyle(color: Colors.black54),
          ));
    }
    else{
      return  Column(
        children: [Text(title,
          style: TextStyle(fontSize: 18,color: Colors.black87,fontWeight: FontWeight.w600 ,
          ),

        ),
          SizedBox(height: 10,),
          Text(description,style: TextStyle(color: Colors.black54),
          ),],
      );


    }

}

