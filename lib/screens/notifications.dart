// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/widgets.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int selectedIndex = 0;
  Widget _buildTabButton(String text, int index) {
    final bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: textBold(
            text,
            14,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: textBold("Notifications", 24),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildTabButton("All", 0),
                _buildTabButton("Read", 1),
                _buildTabButton("Unread", 2),
              ],
            ),
          ),
          notificationCard(
            "New Recipe Added",
            "Check out the latest recipe in your collection.",
            "2 hours ago",
          ),
        ],
      ),
    );
  }
}

Widget notificationCard(String title, String description, String time) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: grey2,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBold(title, 16),
              const SizedBox(height: 4),
              textRegular(description, 14, color: Colors.grey[600]!),
              const SizedBox(height: 8),
              textRegular(time, 12, color: Colors.grey[500]!),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/icons/notification.png',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
