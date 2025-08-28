import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_app_bar.dart';
import 'package:tourism_app/core/component/custom_cardItem.dart';
import 'package:tourism_app/core/component/custom_text.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/app_images.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/core/utils/responsive_text.dart';
import 'package:tourism_app/features/Profile/Payment/presentation/payment_body.dart';
import 'package:tourism_app/features/Profile/data/models/list_item_model.dart';
import 'package:tourism_app/features/Profile/data/models/profile_model.dart';
import 'package:tourism_app/features/Profile/notifications/presentation/notifications_body.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final profileData = ProfileModel(
      name: 'Ahmed Osama',
      email: 'Example@gmail.com',
      profileImage: AppImages.editImageProfile,
    );

    final listItems = [
      ListItemModel(
        icon: Icons.edit,
        title: 'Edit Profile',
        // onTap: () {
        // },
      ),
      ListItemModel(
        icon: Icons.book_online,
        title: 'My Bookings',
        // onTap: () {

        // },
      ),
      ListItemModel(
        icon: Icons.notifications,
        title: 'My Notification',
        onTap: () {
          context.navigateToPage(NotificationsBody());
        },
      ),
      ListItemModel(
        icon: Icons.chat,
        title: 'Chats',
        // onTap: () {

        // },
      ),
      ListItemModel(
        icon: Icons.language,
        title: 'Language',
        // onTap: () {

        // },
      ),
      ListItemModel(
        icon: Icons.location_on,
        title: 'Location',
        // onTap: () {

        // },
      ),
      ListItemModel(
        icon: Icons.payment,
        title: 'Payment Method',
        onTap: () {
          context.navigateToPage(PaymentBody());
        },
      ),
      ListItemModel(
        icon: Icons.help_outline,
        title: 'Help Center',
        // onTap: () {

        // },
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'My Profile',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.15,
                      backgroundImage: AssetImage(profileData.profileImage),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.10,
                      left: MediaQuery.of(context).size.width * 0.22,
                      child: GestureDetector(
                        // onTap: (){},
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.04,
                          backgroundColor: AppColors.babyblue,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomText(
                  text: profileData.name,
                  fontSize: getResponsiveFontSize(context, fontSize: 23),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                CustomText(
                  text: profileData.email,
                  fontSize: getResponsiveFontSize(context, fontSize: 14),
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: listItems.map((item) {
                  return CardItem(
                    icon: item.icon,
                    title: item.title,
                    onTap: item.onTap,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
