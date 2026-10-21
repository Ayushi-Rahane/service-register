import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opening the dialer, maps, WhatsApp. Every method returns an error message
/// for the user, or null on success, and never throws.
abstract final class ExternalActions {
  static String? _digits(String? phone) {
    if (phone == null) return null;
    final d = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return d.replaceAll('+', '').length >= 6 ? d : null;
  }

  static Future<String?> call(String? phone) async {
    final d = _digits(phone);
    if (d == null) return 'No phone number saved';
    return _launch(Uri(scheme: 'tel', path: d), 'Could not open the phone app');
  }

  static Future<String?> openMap(String? address) async {
    if (address == null || address.trim().isEmpty) return 'No address saved';
    final q = Uri.encodeComponent(address.trim());
    final geo = Uri.parse('geo:0,0?q=$q');
    try {
      if (await launchUrl(geo, mode: LaunchMode.externalApplication)) {
        return null;
      }
    } catch (_) {}
    return _launch(
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$q'),
      'Could not open a map application',
    );
  }

  /// Opens WhatsApp with [text] for [phone] (Indian numbers get +91), or the
  /// share sheet when no phone number / WhatsApp is available.
  static Future<String?> whatsapp(String text, {String? phone}) async {
    var d = _digits(phone)?.replaceAll('+', '');
    if (d != null) {
      if (d.length == 10) d = '91$d';
      if (d.length == 11 && d.startsWith('0')) d = '91${d.substring(1)}';
      final uri = Uri.parse(
        'https://wa.me/$d?text=${Uri.encodeComponent(text)}',
      );
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          return null;
        }
      } catch (_) {}
    }
    return shareText(text);
  }

  static Future<String?> sms(String text, {String? phone}) async {
    if (kIsWeb) return 'SMS works from the phone app. Use WhatsApp here.';
    final d = _digits(phone);
    if (d == null) return 'No phone number saved';
    return _launch(
      Uri(scheme: 'sms', path: d, queryParameters: {'body': text}),
      'Could not open messages',
    );
  }

  static Future<String?> shareText(String text) async {
    if (kIsWeb) {
      // Desktop browsers rarely have a share menu: open WhatsApp (Web) with
      // the text, where the user picks the chat.
      return _launch(
        Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'),
        'Could not open WhatsApp',
      );
    }
    try {
      await SharePlus.instance.share(ShareParams(text: text));
      return null;
    } catch (e) {
      return 'Could not open the share menu';
    }
  }

  static Future<String?> _launch(Uri uri, String failure) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      return ok ? null : failure;
    } catch (_) {
      return failure;
    }
  }
}
