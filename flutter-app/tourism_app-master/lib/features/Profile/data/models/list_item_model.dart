import 'package:flutter/material.dart';

class ListItemModel {
  final IconData icon;
  final String title;

  final VoidCallback? onTap;

  ListItemModel({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
            child: ListTile(
          leading: Icon(icon),
          title: Text(title),
        )));
  }
}
