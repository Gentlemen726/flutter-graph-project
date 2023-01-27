import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuRow extends StatelessWidget {
  final String text;
  final String svgPath;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuRow({
    Key? key,
    required this.text,
    required this.svgPath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  bool get _showSelectedState => isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppDimens.menuRowHeight,
          child: Row(
            children: [
              const SizedBox(
                width: 36,
              ),
              SvgPicture.asset(
                svgPath,
                width: AppDimens.menuIconSize,
                height: AppDimens.menuIconSize,
                color: AppColors.primary,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                text,
                style: TextStyle(
                  color: _showSelectedState ? AppColors.primary : Colors.white,
                  fontSize: AppDimens.menuTextSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
