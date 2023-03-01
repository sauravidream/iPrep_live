import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idream/ui/iprep_store/widget/category_chip_widget.dart';
import 'package:idream/ui/iprep_store/widget/category_widget.dart';

import '../../common/references.dart';
import '../../custom_widgets/loading_widget.dart';

class IPrepStorePage extends StatefulWidget {
  const IPrepStorePage({Key? key}) : super(key: key);

  @override
  State<IPrepStorePage> createState() => _IPrepStorePageState();
}

class _IPrepStorePageState extends State<IPrepStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: storeRepository.read(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Widget categoryWidget;

                  if (snapshot.data != null) {
                    categoryWidget = CategoriesWidget(
                      category: snapshot.data,
                    );
                  } else {
                    categoryWidget = const LoadingWidget(
                      height: 100,
                    );
                  }

                  return categoryWidget;
                }),
            const SizedBox(height: 24),
            const Divider(height: 4, color: Color(0xFFDEDEDE)),
            const SizedBox(height: 17),
            FutureBuilder(
                future: storeRepository.getAllCategory(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Widget categoryWidget;

                  if (snapshot.data != null) {
                    categoryWidget = CategoryWidgetLis(
                      categoryDtlModel: snapshot.data,
                    );
                  } else {
                    categoryWidget = const LoadingWidget(
                      height: 100,
                    );
                  }

                  return categoryWidget;
                }),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      scrolledUnderElevation: 1,
      elevation: 0,
      backgroundColor: const Color(0xFFFFFFFF),
      centerTitle: false,
      title: Row(
        children: [
          SvgPicture.asset(
            "assets/image/store.svg",
            height: 22,
            width: 22,
          ),
          const SizedBox(
            width: 9,
          ),
          const Text(
            "iPrep Store",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
