import 'package:flutter/material.dart';

/// BISPIRA Adaptive Theme System (Light & Dark Mode Support with Large Legible Typography)
class NeoBrutalTheme {
  // Brand Colors matching BISPIRA Logo
  static const Color bispiraBlue = Color(0xFF0066FF);       // Electric BISPIRA Blue
  static const Color bispiraBlueDark = Color(0xFF0040A8);   // Deep BISPIRA Blue
  static const Color bispiraBlueLight = Color(0xFFEFF6FF);  // Soft Blue Tint Fill
  static const Color bispiraBlueGlow = Color(0x330066FF);   // Blue Soft Glow

  // Dynamic Theme Colors
  static Color getBgDark(bool isDark) => isDark ? const Color(0xFF090D16) : const Color(0xFFF1F5F9);
  static Color getBgSurface(bool isDark) => isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
  static Color getBgCard(bool isDark) => isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  static Color getBgInput(bool isDark) => isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC);

  // Dynamic Text Colors (Large & High Contrast)
  static Color getTextPrimary(bool isDark) => isDark ? Colors.white : const Color(0xFF0F172A);
  static Color getTextSecondary(bool isDark) => isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
  static Color getTextMuted(bool isDark) => isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  // Dynamic Borders & Dividers
  static Color getBorderSubtle(bool isDark) => isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  // Functional Accents
  static const Color neoCyan = Color(0xFF0284C7);          // Sky Blue Accent
  static const Color neoGreen = Color(0xFF10B981);         // Emerald Mint Accent
  static const Color neoYellow = Color(0xFFD97706);        // Amber Accent
  static const Color neoPink = Color(0xFFDB2777);          // Magenta Accent
  static const Color neoPurple = Color(0xFF7C3AED);        // Purple Accent
  static const Color neoOrange = Color(0xFFEA580C);        // Coral Accent
  static const Color neoRed = Color(0xFFEF4444);           // Crimson Accent

  // Static Fallbacks for backwards compatibility
  static const Color bgDark = Color(0xFFF1F5F9);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgCardHover = Color(0xFFF8FAFC);
  static const Color bgInput = Color(0xFFF8FAFC);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF0066FF);

  // Minimalist Card Decoration
  static BoxDecoration glassCardDecoration({
    required bool isDark,
    Color? bgColor,
    Color? borderColor,
    double borderRadius = 16.0,
    double borderWidth = 1.0,
    Offset shadowOffset = const Offset(0, 4),
    Color? shadowColor,
    List<Color>? gradientColors,
  }) {
    final effectiveBgColor = bgColor ?? getBgCard(isDark);
    final effectiveBorderColor = borderColor ?? getBorderSubtle(isDark);
    final effectiveShadowColor = shadowColor ?? (isDark ? const Color(0x40000000) : const Color(0x0A000000));

    return BoxDecoration(
      color: effectiveBgColor,
      gradient: gradientColors != null
          ? LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: effectiveBorderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: effectiveShadowColor,
          offset: shadowOffset,
          blurRadius: 14,
          spreadRadius: 0,
        ),
      ],
    );
  }
}

/// Adaptive Executive Card Widget
class NeoBrutalCard extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double borderWidth;
  final Offset shadowOffset;
  final Color? shadowColor;
  final List<Color>? gradientColors;
  final bool isDark;

  const NeoBrutalCard({
    Key? key,
    required this.child,
    this.bgColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(20.0),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16.0,
    this.borderWidth = 1.0,
    this.shadowOffset = const Offset(0, 4),
    this.shadowColor,
    this.gradientColors,
    this.isDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: NeoBrutalTheme.glassCardDecoration(
        isDark: isDark,
        bgColor: bgColor,
        borderColor: borderColor,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        shadowOffset: shadowOffset,
        shadowColor: shadowColor,
        gradientColors: gradientColors,
      ),
      child: child,
    );
  }
}

/// Ultra-Smooth 60fps Entrance Animation (Single-pass, zero lag CPU overhead)
class SmoothEntrance extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;
  final Curve curve;

  const SmoothEntrance({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 320),
    this.beginOffset = const Offset(0, 16),
    this.curve = Curves.easeOutCubic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              beginOffset.dx * (1.0 - value),
              beginOffset.dy * (1.0 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Interactive Micro-Hover Card with Smooth 60fps Elevation and Glow Shift
class SmoothHoverCard extends StatefulWidget {
  final Widget child;
  final bool isDark;
  final Color? bgColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const SmoothHoverCard({
    Key? key,
    required this.child,
    required this.isDark,
    this.bgColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(20.0),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16.0,
    this.onTap,
  }) : super(key: key);

  @override
  State<SmoothHoverCard> createState() => _SmoothHoverCardState();
}

class _SmoothHoverCardState extends State<SmoothHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = widget.bgColor ?? NeoBrutalTheme.getBgCard(widget.isDark);
    final effectiveBorder = widget.borderColor ?? (widget.isDark ? Colors.white.withValues(alpha: 0.08) : NeoBrutalTheme.getBorderSubtle(widget.isDark));
    final hoverBorder = widget.isDark ? NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.6) : NeoBrutalTheme.bispiraBlue;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          margin: widget.margin,
          padding: widget.padding,
          transform: _isHovered ? Matrix4.translationValues(0.0, -4.0, 0.0) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered ? hoverBorder : effectiveBorder,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? (widget.isDark ? const Color(0x660066FF) : const Color(0x220066FF))
                    : (widget.isDark ? const Color(0x40000000) : const Color(0x0A000000)),
                blurRadius: _isHovered ? 20 : 14,
                offset: _isHovered ? const Offset(0, 8) : const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Adaptive Large Button Widget
class NeoBrutalButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color borderColor;

  const NeoBrutalButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.bgColor = NeoBrutalTheme.bispiraBlue,
    this.textColor = Colors.white,
    this.icon,
    this.fontSize = 13.5, // Larger font size
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor == Colors.transparent
                ? (bgColor == NeoBrutalTheme.bispiraBlue ? const Color(0xFF0066FF) : borderColor)
                : borderColor,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: bgColor == NeoBrutalTheme.bispiraBlue ? const Color(0x330066FF) : const Color(0x0A000000),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: fontSize + 4),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Adaptive Status Badge Widget with Larger Font
class NeoBrutalBadge extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;

  const NeoBrutalBadge({
    Key? key,
    required this.text,
    this.bgColor = NeoBrutalTheme.bispiraBlue,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBlue = bgColor == NeoBrutalTheme.bispiraBlue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isBlue ? const Color(0xFFEFF6FF) : bgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isBlue ? const Color(0xFFBFDBFE) : bgColor.withValues(alpha: 0.4), width: 1.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isBlue ? NeoBrutalTheme.bispiraBlue : bgColor,
          fontWeight: FontWeight.w700,
          fontSize: 12.0, // Larger legible badge text
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Ultra-Premium Styled Form Input Field Widget
class BispiraFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDark;
  final IconData? icon;
  final String? prefix;
  final String? suffix;
  final String? hint;
  final bool isNumber;

  const BispiraFormField({
    Key? key,
    required this.label,
    required this.controller,
    required this.isDark,
    this.icon,
    this.prefix,
    this.suffix,
    this.hint,
    this.isNumber = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderSubtle = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final fillBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: textSecondary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          decoration: BoxDecoration(
            color: fillBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderSubtle, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Icon(icon, size: 18, color: NeoBrutalTheme.bispiraBlue),
                ),
                Container(width: 1, height: 24, color: borderSubtle),
                const SizedBox(width: 10),
              ],
              if (prefix != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(11), bottomLeft: Radius.circular(11)),
                  ),
                  child: Text(prefix!, style: const TextStyle(fontWeight: FontWeight.w800, color: NeoBrutalTheme.bispiraBlue, fontSize: 13)),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                  style: TextStyle(color: textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: hint ?? 'Masukkan $label...',
                    hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.6), fontSize: 13, fontWeight: FontWeight.w400),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (suffix != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  decoration: BoxDecoration(
                    color: NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
                  ),
                  child: Text(suffix!, style: const TextStyle(fontWeight: FontWeight.w800, color: NeoBrutalTheme.bispiraBlue, fontSize: 12.5)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Ultra-Premium Modal Dialog Shell
class BispiraModalDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget content;
  final List<Widget> actions;
  final bool isDark;

  const BispiraModalDialog({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon = Icons.edit_note_rounded,
    required this.content,
    required this.actions,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgSurface = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderSubtle = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return AlertDialog(
      backgroundColor: bgSurface,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderSubtle, width: 1.2),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(19), topRight: Radius.circular(19)),
          border: Border(bottom: BorderSide(color: borderSubtle, width: 1.0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: NeoBrutalTheme.bispiraBlue, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: textPrimary, letterSpacing: -0.2),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, size: 20, color: textSecondary),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      content: content,
      actions: actions,
    );
  }
}

