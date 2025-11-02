import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

/// URL Launcher Service
/// Handles opening external URLs, emails, phone calls, etc.
class UrlLauncherService {
  /// Open URL in browser
  static Future<bool> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error opening URL: $e');
      return false;
    }
  }

  /// Open URL in in-app browser
  static Future<bool> openUrlInApp(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
        );
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error opening URL in app: $e');
      return false;
    }
  }

  /// Open email client
  static Future<bool> openEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error opening email: $e');
      return false;
    }
  }

  /// Make phone call
  static Future<bool> makePhoneCall(String phoneNumber) async {
    try {
      final uri = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error making phone call: $e');
      return false;
    }
  }

  /// Send SMS
  static Future<bool> sendSms({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      final uri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {
          if (message != null) 'body': message,
        },
      );
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error sending SMS: $e');
      return false;
    }
  }

  /// Open maps location
  static Future<bool> openMaps({
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    try {
      Uri uri;
      if (latitude != null && longitude != null) {
        uri = Uri.parse('geo:$latitude,$longitude');
      } else if (address != null) {
        uri = Uri.parse('geo:0,0?q=${Uri.encodeComponent(address)}');
      } else {
        return false;
      }
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error opening maps: $e');
      return false;
    }
  }

  /// Open app store/play store for app
  static Future<bool> openStore({
    required String appId,
    bool isIOS = false,
  }) async {
    try {
      final url = isIOS
          ? 'https://apps.apple.com/app/id$appId'
          : 'https://play.google.com/store/apps/details?id=$appId';
      
      return await openUrl(url);
    } catch (e) {
      debugPrint('❌ Error opening store: $e');
      return false;
    }
  }

  /// Open WhatsApp chat
  static Future<bool> openWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      final url = 'https://wa.me/$phoneNumber${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}';
      return await openUrl(url);
    } catch (e) {
      debugPrint('❌ Error opening WhatsApp: $e');
      return false;
    }
  }

  /// Open social media profiles
  static Future<bool> openSocialMedia({
    required String platform,
    required String username,
  }) async {
    try {
      String url;
      switch (platform.toLowerCase()) {
        case 'facebook':
          url = 'https://facebook.com/$username';
          break;
        case 'instagram':
          url = 'https://instagram.com/$username';
          break;
        case 'twitter':
        case 'x':
          url = 'https://twitter.com/$username';
          break;
        case 'linkedin':
          url = 'https://linkedin.com/in/$username';
          break;
        case 'youtube':
          url = 'https://youtube.com/@$username';
          break;
        default:
          return false;
      }
      
      return await openUrl(url);
    } catch (e) {
      debugPrint('❌ Error opening social media: $e');
      return false;
    }
  }
}
