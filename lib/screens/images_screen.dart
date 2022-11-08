import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/image_model.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final controller = ScrollController();
  List<ImageData> imagelist = [];
  bool hasMore = true;
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getImage();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        getImage();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future getImage() async {
    if (isLoading) return;
    isLoading = true;
    const limit = 25;
    final url = Uri.parse(
        "https://jsonplaceholder.typicode.com/photos?_limit=$limit&_page=$page");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List newItems = jsonDecode(response.body);

      setState(() {
        page++;
        isLoading = false;

        if (newItems.length < limit) {
          hasMore = false;
        }

        // imagelist.addAll(newItems.map<ImageData>((item) {
        //   final number = item['title'];

        //   return number;
        // }).toList());
        for (var imageindexin in newItems) {
          ImageData messagedetails = ImageData.fromJson(imageindexin);
          imagelist.add(messagedetails);
        }
      });
    } else {
      throw Exception("Could not connect!");
    }
    return imagelist;
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      page = 0;
      imagelist.clear();
    });

    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fetching Data from Internet"),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: controller,
          padding: const EdgeInsets.all(8),
          itemCount: imagelist.length + 1,
          itemBuilder: (context, index) {
            if (index < imagelist.length) {
              // final item = imagelist[index];
              return ListTile(
                leading:
                    Image(image: NetworkImage("${imagelist[index].myUrl}.png")),
                title: Text(imagelist[index].myTitle),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: hasMore
                      ? CircularProgressIndicator()
                      : Text("No more data to load"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
