import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:idream/custom_widgets/dashboard_test_widget.dart';
import 'package:idream/model/test_prep_model/test_prep_model.dart';
import 'package:idream/ui/test_prep/test_prep_provider/test_proivider.dart';
import 'package:provider/provider.dart';

class TestSeeAllPage extends StatelessWidget {
  final List<Others?>? testPrepData;
  const TestSeeAllPage({Key? key, this.testPrepData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final testPro = Provider.of<TestProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:
            testPro.isLoading == true ? Colors.black45 : Colors.white,
        elevation: 0,
        leading: testPro.isLoading == true
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
        title: const Text(
          "Test Preparations",
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final category = testPrepData![index];
                  return TestCategory(category: category!);
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: testPrepData?.length ?? 1,
              ),
            ),
          ),
          testPro.isLoading == true
              ? Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class TestCategory extends StatelessWidget {
  final Others category;
  final String? categoryName;
  const TestCategory({Key? key, required this.category, this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: category.subCategory!
              .toSet()
              .map(
                (subCategory) => TestWidget(
                  testPrepData: category,
                  subTitle: category.subCategory?.length ?? 2,
                  exams: subCategory!,
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
