import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/providers/global_providers.dart';

/// Helper function to safely get a public URL from a Supabase storage path.
///
/// Returns the public URL string on success, or null on failure or if path is invalid.
String? getSupabasePublicUrl(
  WidgetRef ref, {
  required String bucketId,
  required String? filePath,
}) {
  final logger = ref.read(loggingServiceProvider);
  final supabaseService = ref.read(supabaseServiceProvider);

  if (filePath == null || filePath.isEmpty) {
    logger.debug(
        "getSupabasePublicUrl: No file path provided for bucket '$bucketId'.");
    return null;
  }

  try {
    final url = supabaseService.getPublicUrl(
      bucketId: bucketId,
      filePath: filePath,
    );
    return url;
  } catch (e, stackTrace) {
    logger.error(
        "getSupabasePublicUrl: Failed to get public URL for '$filePath' in bucket '$bucketId'",
        e,
        stackTrace);
    return null;
  }
}
