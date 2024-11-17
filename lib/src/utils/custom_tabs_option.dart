import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

/// Option class for customizing appearance of Custom Tabs.
/// **This option applies only on Android platform.**
/// See also:
/// * [CustomTabsIntent.Builder](https://developer.android.com/reference/android/support/customtabs/CustomTabsIntent.Builder.html)

@immutable
class CustomTabsOption {
  const CustomTabsOption({
    this.toolbarColor,
    this.enableUrlBarHiding,
    this.enableDefaultShare,
    this.showPageTitle,
    this.enableInstantApps,
    this.closeButtonPosition,
    this.animation,
    this.extraCustomTabs,
    this.headers,
  });

  /// Custom tab toolbar color.
  final Color? toolbarColor;

  /// If enabled, hides the toolbar when the user scrolls down the page.
  final bool? enableUrlBarHiding;

  /// If enabled, default sharing menu is added.
  final bool? enableDefaultShare;

  /// Show web page title in tool bar.
  final bool? showPageTitle;

  /// If enabled, allow custom tab to use [Instant Apps](https://developer.android.com/topic/instant-apps/index.html).
  final bool? enableInstantApps;

  /// The position of the close button of Custom Tabs.
  final CustomTabsCloseButtonPosition? closeButtonPosition;

  /// Enter and exit animation.
  final CustomTabsAnimation? animation;

  /// Package list of non-Chrome browsers supporting Custom Tabs. The top of the list is used with the highest priority.
  final List<String>? extraCustomTabs;

  /// Request Headers
  final Map<String, String>? headers;

  Map<String, dynamic> toMap() {
    final dest = <String, dynamic>{};
    if (toolbarColor != null) {
      dest['toolbarColor'] = '#${toolbarColor!.value.toRadixString(16)}';
    }
    if (enableUrlBarHiding != null) {
      dest['enableUrlBarHiding'] = enableUrlBarHiding;
    }
    if (enableDefaultShare != null) {
      dest['enableDefaultShare'] = enableDefaultShare;
    }
    if (showPageTitle != null) {
      dest['showPageTitle'] = showPageTitle;
    }
    if (enableInstantApps != null) {
      dest['enableInstantApps'] = enableInstantApps;
    }
    if (animation != null) {
      dest['animations'] = animation!.toMap();
    }
    if (extraCustomTabs != null) {
      dest['extraCustomTabs'] = extraCustomTabs;
    }
    if (closeButtonPosition != null) {
      dest['closeButtonPosition'] = closeButtonPosition!.rawValue;
    }
    if (headers != null) {
      dest['headers'] = headers;
    }
    return dest;
  }
}

/// Enter and exit animation for Custom Tabs.
/// **This animation applies only on Android platform.**
/// An animation specification is as follows:
/// * For application animation resources, only resource file name.
///   * e.g. `slide_up`
/// * Otherwise a resource identifier and type `anim` fixed.
///   * e.g. `android:anim/fade_in`

@immutable
class CustomTabsAnimation {
  const CustomTabsAnimation({
    this.startEnter,
    this.startExit,
    this.endEnter,
    this.endExit,
  });

  /// Enter animation for the custom tab.
  final String? startEnter;

  /// Exit animation for the application.
  final String? startExit;

  /// Enter animation for the application.
  final String? endEnter;

  /// Exit animation for the custom tab.
  final String? endExit;

  Map<String, String> toMap() {
    final dest = <String, String>{};
    if (startEnter != null && startExit != null) {
      dest['startEnter'] = startEnter!;
      dest['startExit'] = startExit!;
    }
    if (endEnter != null && endExit != null) {
      dest['endEnter'] = endEnter!;
      dest['endExit'] = endExit!;
    }
    return dest;
  }

  /// Factory method to create a built-in slide-in animation.
  factory CustomTabsAnimation.slideIn() {
    return const CustomTabsAnimation(
      startEnter: 'android:anim/slide_in_right',
      startExit: 'android:anim/slide_out_left',
      endEnter: 'android:anim/slide_in_left',
      endExit: 'android:anim/slide_out_right',
    );
  }

  /// Factory method to create a built-in fade animation.
  factory CustomTabsAnimation.fade() {
    return const CustomTabsAnimation(
      startEnter: 'android:anim/fade_in',
      startExit: 'android:anim/fade_out',
      endEnter: 'android:anim/fade_in',
      endExit: 'android:anim/fade_out',
    );
  }
}

/// The position of the close button in Custom Tabs.
/// Use this for customizing the close button's location.
@immutable
class CustomTabsCloseButtonPosition {
  const CustomTabsCloseButtonPosition._(this.rawValue);

  final String rawValue;

  static const CustomTabsCloseButtonPosition left = CustomTabsCloseButtonPosition._('left');
  static const CustomTabsCloseButtonPosition right = CustomTabsCloseButtonPosition._('right');
}
