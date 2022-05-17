import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/app_colors.dart';

class SliderWidget extends StatefulWidget {
  final List<dynamic> _imageList;
  final bool isFav;

  SliderWidget(this._imageList, this.isFav);
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final CarouselController _controller = CarouselController();
  bool isFav;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFav = widget.isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          CarouselSlider(
            items: widget._imageList
                .map(
                  (item) => Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: ClipRRect(
                      child: Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              viewportFraction: 1,
              enlargeCenterPage: false,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              height: double.infinity,
            ),
            carouselController: _controller,
          ),
         /* Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isFav = !isFav;
                  });
                },
                child: CircleAvatar(
                  backgroundColor: isFav ? Colors.grey : AppColors.primaryColor,
                  child: Icon(
                    Icons.favorite,
                    color: isFav ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          )*/
        ],
      ),
    );
  }
}
