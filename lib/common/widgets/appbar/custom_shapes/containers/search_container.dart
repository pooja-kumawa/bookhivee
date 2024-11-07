import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    required this.controller,
    required this.onSearch,
    this.hintText = 'Search...',
  });

  final IconData? icon;
  final bool showBackground, showBorder;
  final TextEditingController controller;
  final VoidCallback onSearch;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()), // Remove focus on tap
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          padding: EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                ? TColors.dark
                : TColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: TColors.grey) : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: TColors.darkerGrey,
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onSearch(), // Trigger search on Enter key
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.darkerGrey,
                    ),
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              IconButton(
                icon: Icon(Icons.search, color: TColors.darkerGrey),
                onPressed: onSearch, // Trigger search on button press
              ),
            ],
          ),
        ),
      ),
    );
  }
}
