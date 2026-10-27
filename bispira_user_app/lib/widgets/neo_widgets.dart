import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

// ─────────────────────────────────────────────────────────
// SOFT NEO-BRUTALISM CARD (Interactive / Action Cards)
// 2.5px solid #111 border, 4px 4px hard shadow
// ─────────────────────────────────────────────────────────
class SoftNeoCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double shadowOffset;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const SoftNeoCard({
    Key? key,
    required this.child,
    this.backgroundColor = NeoColors.white,
    this.borderColor = NeoColors.black,
    this.borderWidth = 2.5,
    this.shadowOffset = 4.0,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadowOffset > 0
            ? [
                BoxShadow(
                  color: NeoColors.black,
                  offset: Offset(shadowOffset, shadowOffset),
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius - 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius - 2),
          onTap: onTap,
          splashColor: NeoColors.black.withOpacity(0.05),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// MINIMAL CARD (Payment / Tracking / High UX Usability Cards)
// Soft clean card for transaction details (no heavy shadow)
// ─────────────────────────────────────────────────────────
class MinimalCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const MinimalCard({
    Key? key,
    required this.child,
    this.backgroundColor = NeoColors.white,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 16.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: NeoColors.black.withOpacity(0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: NeoColors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SOFT NEO-BRUTALISM BUTTON (Primary Actions)
// ─────────────────────────────────────────────────────────
class SoftNeoButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final String? icon;

  const SoftNeoButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = NeoColors.black,
    this.textColor = NeoColors.white,
    this.borderColor = NeoColors.black,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SoftNeoCard(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: 2.5,
      shadowOffset: 3.5,
      borderRadius: 14.0,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Text(icon!, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SOFT NEO-BRUTALISM BADGE / CHIP
// ─────────────────────────────────────────────────────────
class SoftNeoBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const SoftNeoBadge({
    Key? key,
    required this.label,
    this.backgroundColor = NeoColors.lime,
    this.textColor = NeoColors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NeoColors.black, width: 2.0),
        boxShadow: const [
          BoxShadow(
            color: NeoColors.black,
            offset: Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w900,
          fontSize: 10,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SERVICE ICON TILE (Soft Neo-Brutalist Grid Card)
// Supports Material Icons & Emoji strings seamlessly
// ─────────────────────────────────────────────────────────
class SoftNeoServiceTile extends StatelessWidget {
  final String? emoji;
  final IconData? iconData;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const SoftNeoServiceTile({
    Key? key,
    this.emoji,
    this.iconData,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NeoColors.black, width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: NeoColors.black,
                  offset: Offset(3.5, 3.5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: iconData != null
                  ? Icon(iconData, size: 28, color: NeoColors.black)
                  : Text(emoji ?? '⭐', style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: NeoColors.black,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SOFT NEO-BRUTALISM BACK BUTTON (Ultra-stylish uniform back button)
// ─────────────────────────────────────────────────────────
class SoftNeoBackButton extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final Color iconColor;

  const SoftNeoBackButton({
    Key? key,
    this.onBackPressed,
    this.backgroundColor = NeoColors.brandSoft,
    this.iconColor = NeoColors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onBackPressed == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: onBackPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: NeoColors.black, width: 2.0),
          boxShadow: const [
            BoxShadow(
              color: NeoColors.black,
              offset: Offset(2.5, 2.5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(Icons.arrow_back_rounded, size: 18, color: iconColor),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Legacy Compatibility Wrappers
// ─────────────────────────────────────────────────────────
class CleanCard extends MinimalCard {
  const CleanCard({
    Key? key,
    required Widget child,
    Color backgroundColor = NeoColors.white,
    double borderRadius = 16,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    VoidCallback? onTap,
    List<BoxShadow>? shadow,
  }) : super(
          key: key,
          child: child,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          padding: padding,
          onTap: onTap,
        );
}

class NeoContainer extends SoftNeoCard {
  const NeoContainer({
    Key? key,
    required Widget child,
    Color backgroundColor = NeoColors.white,
    double borderRadius = 16,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    VoidCallback? onTap,
    Color borderColor = NeoColors.black,
    double borderWidth = 2.5,
    double shadowOffset = 4.0,
  }) : super(
          key: key,
          child: child,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          shadowOffset: shadowOffset,
          borderRadius: borderRadius,
          padding: padding,
          margin: margin,
          onTap: onTap,
        );
}

class PillButton extends SoftNeoButton {
  const PillButton({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    Color backgroundColor = NeoColors.black,
    Color textColor = NeoColors.white,
    double height = 48,
  }) : super(
          key: key,
          text: text,
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          textColor: textColor,
        );
}

class NeoButton extends SoftNeoButton {
  const NeoButton({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    Color backgroundColor = NeoColors.black,
    Color textColor = NeoColors.white,
    String? icon,
  }) : super(
          key: key,
          text: text,
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          textColor: textColor,
          icon: icon,
        );
}

class StatusChip extends SoftNeoBadge {
  const StatusChip({
    Key? key,
    required String label,
    Color backgroundColor = NeoColors.lime,
    Color textColor = NeoColors.black,
  }) : super(
          key: key,
          label: label,
          backgroundColor: backgroundColor,
          textColor: textColor,
        );
}

class NeoBadge extends SoftNeoBadge {
  const NeoBadge({
    Key? key,
    required String label,
    Color backgroundColor = NeoColors.lime,
    Color textColor = NeoColors.black,
  }) : super(
          key: key,
          label: label,
          backgroundColor: backgroundColor,
          textColor: textColor,
        );
}

class ServiceIconTile extends SoftNeoServiceTile {
  const ServiceIconTile({
    Key? key,
    String? emoji,
    IconData? iconData,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) : super(
          key: key,
          emoji: emoji,
          iconData: iconData,
          label: label,
          color: color,
          onTap: onTap,
        );
}

class NeoServiceTile extends SoftNeoServiceTile {
  const NeoServiceTile({
    Key? key,
    String? emoji,
    IconData? iconData,
    required String title,
    required Color badgeColor,
    Color textColor = NeoColors.black,
    required VoidCallback onTap,
  }) : super(
          key: key,
          emoji: emoji,
          iconData: iconData,
          label: title,
          color: badgeColor,
          onTap: onTap,
        );
}
