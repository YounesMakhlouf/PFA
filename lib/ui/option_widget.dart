import 'package:flutter/material.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/services/supabase_service.dart';

class OptionWidget extends StatelessWidget {
  final Option option;
  final VoidCallback onTap;
  final Color? gameThemeColor;
  final bool isSelected; // for visual feedback in memory game
  final bool isDisabled;

  const OptionWidget({
    super.key,
    required this.option,
    required this.onTap,
    this.gameThemeColor,
    this.isSelected = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImagePath =
        option.pictureUrl != null && option.pictureUrl!.isNotEmpty;

    final supabaseService = SupabaseService();

    String? fullImageUrl;
    if (hasImagePath) {
      try {
        fullImageUrl = supabaseService.getPublicUrl(
          bucketId: 'game-assets',
          filePath: option.pictureUrl!,
        );
      } catch (e) {
        rethrow;
      }
    }
    Widget content;
    final Color defaultButtonColor =
        gameThemeColor ?? Theme.of(context).primaryColor;
    final BorderRadius borderRadius = BorderRadius.circular(12);

    if (fullImageUrl != null) {
      content = _buildImageOption(context, fullImageUrl, borderRadius);
    } else {
      content = _buildTextButtonOption(
          context, option.labelText ?? '', defaultButtonColor, borderRadius);
    }

    // Add selection/disabled visual cues
    BoxDecoration decoration = BoxDecoration(
      borderRadius: borderRadius,
      border: isSelected
          ? Border.all(color: Theme.of(context).primaryColorLight, width: 3)
          : null,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    );

    // Use Semantics for accessibility
    return Semantics(
      button: true,
      label: option.labelText ?? AppLocalizations.of(context).selectableOption,
      value: isSelected ? AppLocalizations.of(context).selected : null,
      enabled: !isDisabled,
      child: IgnorePointer(
        ignoring: isDisabled,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Container(
            decoration: decoration,
            child: Material(
              color: Colors.transparent,
              borderRadius: borderRadius,
              child: InkWell(
                onTap: isDisabled ? null : onTap,
                borderRadius: borderRadius,
                splashColor: defaultButtonColor.withOpacity(0.3),
                highlightColor: defaultButtonColor.withOpacity(0.1),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption(
      BuildContext context, String imageUrl, BorderRadius borderRadius) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: gameThemeColor ?? Theme.of(context).primaryColor,
                strokeWidth: 2.0, // Smaller indicator
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey[500],
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextButtonOption(BuildContext context, String text,
      Color backgroundColor, BorderRadius borderRadius) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: backgroundColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
