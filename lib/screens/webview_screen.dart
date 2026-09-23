import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/webview_service.dart';

class WebViewScreen extends StatefulWidget {
  final String initialUrl;

  const WebViewScreen({
    super.key,
    this.initialUrl = WebViewService.initialUrl,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen>
    with SingleTickerProviderStateMixin {
  late final WebViewService _service;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _service = WebViewService.instance;
    _service.init();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.94, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleBackNavigation(bool didPop, dynamic result) async {
    if (didPop) return;

    if (await _service.controller.canGoBack()) {
      _service.startPageLoadingManual();
      await _service.controller.goBack();
    } else {
      // Exit app if there is no previous page in WebView history
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handleBackNavigation,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Main WebView with Pull-to-Refresh
              ValueListenableBuilder<bool>(
                valueListenable: _service.hasErrorNotifier,
                builder: (context, hasError, child) {
                  if (hasError) {
                    return _buildErrorView();
                  }
                  return RefreshIndicator(
                    color: const Color(0xFF4DB2EC),
                    backgroundColor: Colors.white,
                    onRefresh: _service.reload,
                    child: WebViewWidget(controller: _service.controller),
                  );
                },
              ),

              // Subtle top hairline progress indicator for quick glances
              ValueListenableBuilder<bool>(
                valueListenable: _service.isLoadingNotifier,
                builder: (context, isLoading, child) {
                  if (!isLoading) return const SizedBox.shrink();
                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ValueListenableBuilder<int>(
                      valueListenable: _service.progressNotifier,
                      builder: (context, progress, _) {
                        return SizedBox(
                          height: 3,
                          child: LinearProgressIndicator(
                            value: progress > 0 && progress < 100
                                ? progress / 100
                                : null,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF4DB2EC),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // Full-Page Transition & Initial Loading Overlay
              ValueListenableBuilder<bool>(
                valueListenable: _service.isPageLoadingNotifier,
                builder: (context, isPageLoading, child) {
                  return AnimatedOpacity(
                    opacity: isPageLoading ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutQuad,
                    child: IgnorePointer(
                      ignoring: !isPageLoading,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _service.isInitialLoadDoneNotifier,
                        builder: (context, isInitialDone, _) {
                          // If initial load is still underway, show full splash;
                          // Otherwise show sleek page transition loading overlay
                          if (!isInitialDone) {
                            return _buildInitialSplashScreen();
                          } else {
                            return _buildPageTransitionLoader();
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Initial app launch splash screen
  Widget _buildInitialSplashScreen() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF313B45).withValues(alpha: 0.10),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.newspaper_rounded,
                      size: 56,
                      color: Color(0xFF313B45),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'TUİD',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: Color(0xFF313B45),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'TÜRKİYE UKRAYNA İŞ İNSANLARI DERNEĞİ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ValueListenableBuilder<int>(
                valueListenable: _service.progressNotifier,
                builder: (context, progress, _) {
                  return LinearProgressIndicator(
                    value: progress > 5 ? progress / 100.0 : null,
                    minHeight: 3.5,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4DB2EC),
                    ),
                  );
                },
              ),
            ),
          ),
          const Spacer(flex: 4),
          const Text(
            'tuid.org.ua',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Elegant loading effect shown when clicking on articles or navigating
  Widget _buildPageTransitionLoader() {
    return Container(
      color: Colors.white.withValues(alpha: 0.94),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF313B45).withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Circular loader around logo
                  const SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4DB2EC),
                      ),
                    ),
                  ),
                  // Centered TUİD logo badge
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.newspaper_rounded,
                              size: 26,
                              color: Color(0xFF313B45),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Sayfa Yükleniyor...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: Color(0xFF313B45),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 110,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _service.progressNotifier,
                    builder: (context, progress, _) {
                      return LinearProgressIndicator(
                        value: progress > 5 ? progress / 100.0 : null,
                        minHeight: 3,
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4DB2EC),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF313B45).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 64,
                color: Color(0xFF313B45),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bağlantı Kurulamadı',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF313B45),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<String?>(
              valueListenable: _service.errorMessageNotifier,
              builder: (context, errorMsg, _) {
                return Text(
                  errorMsg != null && errorMsg.isNotEmpty
                      ? 'Sayfa yüklenirken bir sorun oluştu. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.'
                      : 'İnternet bağlantınızı kontrol edip tekrar deneyin.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _service.retryInitial,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text(
                'Yeniden Dene',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF313B45),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
