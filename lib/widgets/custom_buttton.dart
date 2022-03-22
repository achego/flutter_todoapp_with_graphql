import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double width;
  final Function() onTap;
  final bool enabled;

  const CustomButton({
    Key? key,
    this.title = '',
    this.width = double.infinity,
    required this.onTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : () {},
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: enabled
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(7)),
        padding: const EdgeInsets.all(11),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
