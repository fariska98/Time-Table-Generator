
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_table_generation_app/constants/color_class.dart';
import 'package:time_table_generation_app/constants/text_style_class.dart';


class AppUtils {
 

  static Widget buttonsSubmit({
    required nextOnTap,
  }) {
    return GestureDetector(
      onTap: nextOnTap,
      child: Container(
        width: 350,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ColorClass.primaryColor,
        ),
        child: Center(
          child: Text(
            'Submit',
            style: TextStyleClass.manrope700TextStyle(14, ColorClass.white),
          ),
        ),
      ),
    );
  }

  

  /// Navigate to a new screen/widget
  static navigateTo(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  static showInSnackBarNormal(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        closeIconColor: ColorClass.white,
        backgroundColor: ColorClass.primaryColor,
        showCloseIcon: true,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        content: Text(
          message,
          maxLines: 2,
          style: TextStyleClass.manrope500TextStyle(16, ColorClass.white),
        )));
  }

  // static String formatDate(String inputDateString) {
  //   // Parse the input string to DateTime
  //   try {
  //     DateTime dateTime = DateTime.parse(inputDateString);
  //     // Format the DateTime to "dd MMMM yyyy" using intl package
  //     String formattedDate = DateFormat("dd MMM yyyy").format(dateTime);
  //     return formattedDate;
  //   } catch (e) {
  //     return '';
  //   }
  // }

  

  static noDataWidget(String label, double height) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
          Icons.error,
            size: height,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            label,
            style: TextStyleClass.manrope400TextStyle(16, ColorClass.black),
          ),
        ],
      ),
    );
  }

  static loadingWidget(BuildContext context, double? size) {
    return SizedBox(
        height: size,
        child: const Center(
            child: CupertinoActivityIndicator(
          radius: 10.0,
        )));
  }

  static loadingWidgetWhite(BuildContext context, double? size) {
    return SizedBox(
        height: size,
        child: const Center(
            child: CupertinoActivityIndicator(
          radius: 10.0,
          color: Colors.white,
        )));
  }

  // static cachedNetworkImageWidget(String imageUrl, double width) {
  //   return CachedNetworkImage(
  //     imageUrl: ApiUrls.imageAppend + imageUrl,
  //     fit: BoxFit.cover,
  //     placeholder: (context, url) => const CupertinoActivityIndicator(),
  //     errorWidget: (context, url, error) => SizedBox(
  //         child: Image.asset(
  //       ImageClass.place_holder,
  //       fit: BoxFit.cover,
  //       width: width,
  //     )),
  //   );
  // }

  



  

  
}
