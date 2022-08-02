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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DraggableScrollableSheet(
          maxChildSize: 0.9,
          minChildSize: 0.25,
          initialChildSize: 0.25,
          expand: true,
          builder: (BuildContext context, ScrollController controller) {
            return Stack(
              children: [
                Body(
                  controller: controller,
                  paddingTop: headerHeight,
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
    const divider = Divider(color: Colors.blue, height: 0.5);
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
