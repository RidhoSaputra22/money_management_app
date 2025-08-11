// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final String trailingText;
  final IconData leadingIcon;
  final Color leadingColor;
  final Color iconColor;
  final Color trailingColor;
  final Widget? action; // Tambahkan parameter action

  const ListCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.trailingText,
    this.leadingIcon = Icons.attach_money,
    this.leadingColor = const Color(0xFF4CAF50),
    this.iconColor = Colors.green,
    this.trailingColor = Colors.green,
    this.action, // Tambahkan ke konstruktor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: leadingColor.withOpacity(0.15),
          child: Icon(leadingIcon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B233A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: action != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trailingText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: trailingColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  action!,
                ],
              )
            : Text(
                trailingText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: trailingColor,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
