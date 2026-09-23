import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// Pre-warming and configuration service for TUİD WebView
class WebViewService {
  static final WebViewService instance = WebViewService._internal();

  WebViewService._internal();

  WebViewController? _controller;
  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> hasErrorNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessageNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<bool> isInitialLoadDoneNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isPageLoadingNotifier = ValueNotifier<bool>(true);

  Timer? _safetyTimer;

  WebViewController get controller {
    if (_controller == null) {
      init();
    }
    return _controller!;
  }

  static const String initialUrl = 'https://tuid.org.ua';

  /// High-performance acceleration script:
  /// 1. Unblock delayed stylesheets (if any present)
  /// 2. Predictive touchstart & pointerover prefetching for instant page navigation
  /// 3. Viewport idle prefetching of visible article links into browser HTTP cache
  /// 4. Instant click feedback and bridge notification for page transitions
  static const String _accelerationScript = '''
(function() {
  // 1. Immediately activate any delayed stylesheets
  function unblockStyles() {
    var delayedStyles = document.querySelectorAll('link[data-pmdelayedstyle]');
    for (var i = 0; i < delayedStyles.length; i++) {
      var link = delayedStyles[i];
      var href = link.getAttribute('data-pmdelayedstyle');
      if (href && !link.getAttribute('href')) {
        link.setAttribute('href', href);
      }
    }
  }
  unblockStyles();
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', unblockStyles);
  }

  // 2. Instant Image Hydration: Immediately force all news photos to render without waiting for scroll or theme animations
  function hydrateImages() {
    // A. Newspaper theme thumbnail spans (data-img-url)
    var spans = document.querySelectorAll('span[data-img-url]');
    for (var i = 0; i < spans.length; i++) {
      var el = spans[i];
      var url = el.getAttribute('data-img-url');
      if (url && (!el.style.backgroundImage || el.style.backgroundImage === 'none')) {
        el.style.backgroundImage = 'url("' + url + '")';
      }
    }
    // B. Perfmatters data-bg spans
    var bgSpans = document.querySelectorAll('[data-bg]');
    for (var k = 0; k < bgSpans.length; k++) {
      var bgEl = bgSpans[k];
      var bgUrl = bgEl.getAttribute('data-bg');
      if (bgUrl && (!bgEl.style.backgroundImage || bgEl.style.backgroundImage === 'none')) {
        bgEl.style.backgroundImage = 'url("' + bgUrl + '")';
      }
    }
    // C. Lazy img elements (data-src)
    var imgs = document.querySelectorAll('img[data-src]');
    for (var j = 0; j < imgs.length; j++) {
      var img = imgs[j];
      var src = img.getAttribute('data-src');
      if (src && img.getAttribute('src') !== src) {
        img.setAttribute('src', src);
      }
    }
  }
  hydrateImages();
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', hydrateImages);
  }
  // Periodically ensure dynamically rendered blocks get their images hydrated immediately
  setTimeout(hydrateImages, 200);
  setTimeout(hydrateImages, 600);
  setTimeout(hydrateImages, 1200);

  // 3. Tap highlight styling
  if (!document.getElementById('tuid-tap-styles')) {
    var style = document.createElement('style');
    style.id = 'tuid-tap-styles';
    style.innerHTML = 'a, .td-module-thumb, .entry-title a { -webkit-tap-highlight-color: rgba(77, 178, 236, 0.2) !important; }';
    document.head.appendChild(style);
  }

  // 3. Predictive Prefetch Engine
  if (window.__tuidPrefetchEngine) return;
  window.__tuidPrefetchEngine = true;

  var prefetched = Object.create(null);
  var currentHost = window.location.hostname;

  function prefetch(url) {
    if (!url || prefetched[url]) return;
    try {
      var u = new URL(url, window.location.href);
      if (u.hostname !== currentHost) return;
      var path = u.pathname;
      if (path.indexOf('/wp-admin') !== -1 || path.indexOf('/wp-login') !== -1) return;
      if (/\\.(jpg|jpeg|png|gif|webp|svg|pdf|zip|mp4)\$/i.test(path)) return;
      if (u.href === window.location.href) return;

      prefetched[url] = true;

      // HTML link prefetch
      var link = document.createElement('link');
      link.rel = 'prefetch';
      link.href = u.href;
      link.as = 'document';
      document.head.appendChild(link);

      // Background cache-warming fetch
      if (window.fetch) {
        fetch(u.href, { priority: 'low', mode: 'no-cors', cache: 'force-cache' }).catch(function() {});
      }
    } catch(e) {}
  }

  // Prefetch immediately on touchstart / pointerdown
  document.addEventListener('touchstart', function(e) {
    var a = e.target.closest('a');
    if (a && a.href) prefetch(a.href);
  }, { passive: true });

  document.addEventListener('pointerover', function(e) {
    var a = e.target.closest('a');
    if (a && a.href) prefetch(a.href);
  }, { passive: true });

  // Instant click notification to Flutter bridge for page transitions
  document.addEventListener('click', function(e) {
    var a = e.target.closest('a');
    if (a && a.href && a.hostname === currentHost && (a.protocol === 'http:' || a.protocol === 'https:') && !a.getAttribute('download')) {
      var rawHref = a.getAttribute('href');
      // Only trigger for real page navigations (not in-page anchors # or javascript:)
      if (rawHref && rawHref.indexOf('#') !== 0 && rawHref.indexOf('javascript:') !== 0) {
        if (window.TuidBridge && window.TuidBridge.postMessage) {
          window.TuidBridge.postMessage('page_navigation_started');
        }
      }
    }
  }, { capture: true, passive: true });

  // Notify DOM ready to dismiss transition loader promptly
  function notifyDomReady() {
    if (window.TuidBridge && window.TuidBridge.postMessage) {
      window.TuidBridge.postMessage('page_dom_ready');
    }
  }
  if (document.readyState === 'interactive' || document.readyState === 'complete') {
    notifyDomReady();
  } else {
    document.addEventListener('DOMContentLoaded', notifyDomReady);
  }

  // Viewport idle prefetching for visible news links
  function observeVisible() {
    if (!('IntersectionObserver' in window)) return;
    var observer = new IntersectionObserver(function(entries, obs) {
      for (var i = 0; i < entries.length; i++) {
        var entry = entries[i];
        if (entry.isIntersecting) {
          if (entry.target.href) prefetch(entry.target.href);
          obs.unobserve(entry.target);
        }
      }
    }, { rootMargin: '120px' });

    var links = document.querySelectorAll('.td-module-thumb a, .entry-title a, .td-big-grid-post a, .td-post-category a');
    for (var j = 0; j < Math.min(links.length, 12); j++) {
      observer.observe(links[j]);
    }
  }

  if (window.requestIdleCallback) {
    window.requestIdleCallback(observeVisible);
  } else {
    setTimeout(observeVisible, 800);
  }
})();
''';

  void _startPageLoading() {
    isPageLoadingNotifier.value = true;
    isLoadingNotifier.value = true;
    progressNotifier.value = 25;

    // Safety timeout: Maximum 1.2s so the user is never held waiting
    _safetyTimer?.cancel();
    _safetyTimer = Timer(const Duration(milliseconds: 1200), () {
      _finishPageLoading();
    });
  }

  void _finishPageLoading() {
    _safetyTimer?.cancel();
    // Dismiss transition overlay so page is immediately visible
    isPageLoadingNotifier.value = false;
    isInitialLoadDoneNotifier.value = true;
  }

  void init() {
    if (_controller != null) return;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    // iOS WebKit optimizations
    if (controller.platform is WebKitWebViewController) {
      final webKitController = controller.platform as WebKitWebViewController;
      webKitController.setAllowsBackForwardNavigationGestures(true);
    } else if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white);

    try {
      controller.addJavaScriptChannel(
        'TuidBridge',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'page_navigation_started' ||
              message.message == 'link_clicked') {
            _startPageLoading();
          } else if (message.message == 'page_dom_ready') {
            _finishPageLoading();
          }
        },
      );
    } catch (_) {}

    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          progressNotifier.value = progress;
          // As soon as 55% progress is reached, visible DOM is painted! Dismiss instantly!
          if (progress >= 55) {
            _finishPageLoading();
          }
          if (progress >= 100) {
            isLoadingNotifier.value = false;
          }
        },
        onPageStarted: (String url) {
          _startPageLoading();
          hasErrorNotifier.value = false;
          errorMessageNotifier.value = null;
          // Inject acceleration script as early as possible
          controller.runJavaScript(_accelerationScript).catchError((_) {});
        },
        onPageFinished: (String url) {
          _finishPageLoading();
          isLoadingNotifier.value = false;
          // Re-run acceleration script after DOM render
          controller.runJavaScript(_accelerationScript).catchError((_) {});
        },
        onWebResourceError: (WebResourceError error) {
          final isMainFrame = error.isForMainFrame ?? true;
          if (isMainFrame) {
            _safetyTimer?.cancel();
            isPageLoadingNotifier.value = false;
            hasErrorNotifier.value = true;
            isLoadingNotifier.value = false;
            errorMessageNotifier.value = error.description;
          }
        },
        onNavigationRequest: (NavigationRequest request) async {
          final uri = Uri.tryParse(request.url);
          if (uri == null) {
            return NavigationDecision.navigate;
          }

          final scheme = uri.scheme.toLowerCase();

          // Handle external communication protocols
          if (scheme == 'tel' ||
              scheme == 'mailto' ||
              scheme == 'sms' ||
              scheme == 'whatsapp' ||
              scheme == 'tg') {
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            } catch (_) {}
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    );

    // Pre-load the request right away!
    controller.loadRequest(Uri.parse(initialUrl));
    _controller = controller;
  }

  void startPageLoadingManual() {
    _startPageLoading();
  }

  Future<void> reload() async {
    _startPageLoading();
    hasErrorNotifier.value = false;
    await controller.reload();
  }

  Future<void> retryInitial() async {
    _startPageLoading();
    hasErrorNotifier.value = false;
    await controller.loadRequest(Uri.parse(initialUrl));
  }
}
