import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shikha/features/shop/screens/store/store_screen.dart';

import '../../../../../common/widgets/common_widget_image_text/vertical_image_text.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/image_strings.dart'; // Import the StoreScreen

class THomeCategories extends StatelessWidget {
  const THomeCategories({super.key});

  final List<Map<String, String>> _categories = const [
    {'image': TImages.sciencefiction, 'title': 'Science Fiction'},
    {'image': TImages.thriller, 'title': 'Thriller'},
    {'image': TImages.horror, 'title': 'Horror'},
    {'image': TImages.mystery, 'title': 'Mystery'},
    {'image': TImages.fantasy, 'title': 'Fantasy'},
    {'image': TImages.comedy, 'title': 'Comedy'},
  ];

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final category = _categories[index];
          return TVerticalImageText(
            image: category['image'] ?? TImages.horror,
            title: category['title'] ?? 'Category',
            onTap: () {
              // Update the initial search query in the navigation controller and change index to Store
              controller.setInitialSearchQuery(category['title'] ?? '');
              controller.selectedIndex.value = 1; // Index for StoreScreen
            },
          );
        },
      ),
    );
  }
}
