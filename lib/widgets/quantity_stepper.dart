import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Clean rounded quantity button supporting Add State and Stepper (- count +) states.
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAdd;
  final double height;
  final double width;
  final bool isCompact;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAdd,
    this.height = 36,
    this.width = 90,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return SizedBox(
        height: height,
        width: width,
        child: OutlinedButton(
          onPressed: onAdd,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.4),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.zero,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ADD',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.add_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onDecrement,
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(10)),
            child: Container(
              height: height,
              width: width * 0.33,
              alignment: Alignment.center,
              child: const Icon(
                Icons.remove_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            '$quantity',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          InkWell(
            onTap: onIncrement,
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(10)),
            child: Container(
              height: height,
              width: width * 0.33,
              alignment: Alignment.center,
              child: const Icon(
                Icons.add_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
