import 'package:flutter/material.dart';

/// 底部可拖动的带固定header抽屉效果

const double headerHeight = 56;

class MyDraggableScrollableSheet extends StatefulWidget {
  const MyDraggableScrollableSheet({Key? key}) : super(key: key);

  @override
  State<MyDraggableScrollableSheet> createState() =>
      _MyDraggableScrollableSheetState();
}

class _MyDraggableScrollableSheetState
    extends State<MyDraggableScrollableSheet> {
  late DraggableScrollableController _controller;
  double _currStale = 0.25;
  bool _animation = false;
  final _duration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();

    _controller.addListener(() {
      if (_currStale != _controller.size) {
        _currStale = _controller.size;
      }
      debugPrint('[listener] size: ${_controller.size}'
          ', pixels : ${_controller.pixels}');
    });
  }

  void _scrollAnimation() async {
    _animation = true;
    if (_currStale >= (0.8 + 0.25) * 0.5) {
      await _controller.animateTo(
        0.8,
        duration: _duration,
        curve: Curves.ease,
      );
    } else {
      await _controller.animateTo(
        0.25,
        duration: _duration,
        curve: Curves.ease,
      );
    }
    _animation = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (_animation) {
              return false;
            }
            if (notification is ScrollStartNotification) {
              debugPrint('start scroll');
            } else if (notification is ScrollEndNotification) {
              debugPrint('stop scroll');
              _scrollAnimation();
            }
            return false;
          },
          child: DraggableScrollableSheet(
            maxChildSize: 0.8,
            minChildSize: 0.25,
            // 都是占父组件的比例
            initialChildSize: 0.25,
            expand: true,
            controller: _controller,
            builder: (BuildContext context, ScrollController controller) {
              return Stack(
                children: [
                  Container(
                    color: Colors.blue,
                    child: Body(
                      controller: controller,
                      paddingTop: headerHeight,
                    ),
                  ),
                  const IgnorePointer(
                    child: Header(
                      height: headerHeight,
                    ),
                  ),
                  Container(
                    height: headerHeight,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.drag_handle),
                      onPressed: () {
                        debugPrint('click icon');
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final ScrollController controller;
  final double paddingTop;

  const Body({
    Key? key,
    required this.controller,
    required this.paddingTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const divider = Divider(color: Colors.white, height: 0.5);
    const physics = ClampingScrollPhysics();
    return ListView.separated(
      padding: EdgeInsets.only(top: paddingTop),
      // 给定一个高度，防止压盖
      itemCount: 30,
      controller: controller,
      physics: physics,
      // 去掉默认回弹，优化iOS效果
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Center(
            child: Text('item:$index'),
          ),
          onTap: () {
            debugPrint('click item $index');
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return divider;
      },
    );
  }
}

class Header extends StatelessWidget {
  final double height;

  const Header({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.red,
      child: const Center(
        child: Text(
          '这是 Header',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
