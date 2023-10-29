import 'package:cached_network_image/cached_network_image.dart';
import 'package:cp_news/models/article_model.dart';
import 'package:cp_news/models/slider_model.dart';
import 'package:cp_news/pages/article_view.dart';
import 'package:cp_news/services/news.dart';
import 'package:cp_news/services/slider_data.dart';
import 'package:flutter/material.dart';

class AllNews extends StatefulWidget {
  final String news;
  const AllNews({super.key, required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  final bool _loading = false;

  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  @override
  void initState() {
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {});
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.sliders;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.news} News",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.news == "Breaking"
                      ? sliders.length
                      : articles.length,
                  itemBuilder: (context, index) {
                    return AllNewsSection(
                        image: widget.news == "Breaking"
                            ? sliders[index].urlToImage!
                            : articles[index].urlToImage!,
                        desc: widget.news == "Breaking"
                            ? sliders[index].description!
                            : articles[index].description!,
                        title: widget.news == "Breaking"
                            ? sliders[index].title!
                            : articles[index].title!,
                        url: widget.news == "Breaking"
                            ? sliders[index].url!
                            : articles[index].url!);
                  }),
            ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  final String image;
  final String desc;
  final String title;
  final String url;
  const AllNewsSection(
      {super.key,
      required this.image,
      required this.desc,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: image,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            title,
            maxLines: 2,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            desc,
            maxLines: 3,
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
