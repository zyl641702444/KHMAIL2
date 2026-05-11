import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.theme,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final AppThemeData theme;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(.4)),
      ),
      child: child,
    );
  }
}

class FeaturePill extends StatelessWidget {
  const FeaturePill({
    super.key,
    required this.theme,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final AppThemeData theme;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.primary.withOpacity(.08)),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.primary),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.text, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class ApiOutputCard extends StatelessWidget {
  const ApiOutputCard({
    super.key,
    required this.theme,
    required this.output,
  });

  final AppThemeData theme;
  final String output;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      theme: theme,
      child: SelectableText(
        output,
        style: TextStyle(color: theme.muted, height: 1.45, fontSize: 12),
      ),
    );
  }
}
