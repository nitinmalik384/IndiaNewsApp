import 'dart:convert';

import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as Http;

class News{
  List<ArticleModel> news=List<ArticleModel>();

  
  Future<void> getNews() async{
    String url="https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=8797f70669b843738048d10827c7d266";
    var response=await Http.get(Uri.parse(url));
    var jsonData=jsonDecode(response.body);
    if(jsonData['status']=="ok")
      {
       var articles= jsonData["articles"];
       print("Articles");
       print(articles);
       jsonData["articles"].forEach((element)
         {
           if(element['urlToImage'] != null && element['description'] != null) {
             ArticleModel articleModel=ArticleModel(
               imageUrl: element["urlToImage"],
               author: element["author"],
               title:element["title"],
               description:element["description"],
               content: element["content"],
               url: element["url"],
             );
             news.add(articleModel);
             print("Author");
           }
         });

       print("Some Data");
       print(jsonData["articles"]);
      }
  }
  
}