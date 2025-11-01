import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tribun_app/utils/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  CategoryChip({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      // jarak antar chip
      child: FilterChip(
        label: Text(label), 
        selected: isSelected,
        // kondisi chip nya di pilih atau tidak
        onSelected: (_) => onTap(),
        backgroundColor: Colors.grey[100],
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        // warna chip ketika di pilih
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          // kondisi teks ketika di pilih atau tidak warnanya sama tulisan nya (isSeleted)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1,
          ),
        ),
      ),
    );
  }
}