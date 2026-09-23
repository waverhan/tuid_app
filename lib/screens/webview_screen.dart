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
  int _selectedCategoryIndex = 0;

  static const List<String> _categoryUrls = [
    'https://tuid.org.ua',
    'https://tuid.org.ua/category/gundem',
    'https://tuid.org.ua/category/ekonomi-2',
    'https://tuid.org.ua/category/dunya-2',
    'https://tuid.org.ua/category/c20-news-from-tuid',
  ];

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

    _service.currentUrlNotifier.addListener(_onUrlChanged);
  }

  void _onUrlChanged() {
    final url = _service.currentUrlNotifier.value.toLowerCase();
    int newIndex = _selectedCategoryIndex;
    if (url.contains('/category/gundem')) {
      newIndex = 1;
    } else if (url.contains('/category/ekonomi')) {
      newIndex = 2;
    } else if (url.contains('/category/dunya')) {
      newIndex = 3;
    } else if (url.contains('/category/c20-news-from-tuid')) {
      newIndex = 4;
    } else if (url == 'https://tuid.org.ua' || url == 'https://tuid.org.ua/') {
      newIndex = 0;
    }

    if (newIndex != _selectedCategoryIndex && mounted) {
      setState(() {
        _selectedCategoryIndex = newIndex;
      });
    }
  }

  @override
  void dispose() {
    _service.currentUrlNotifier.removeListener(_onUrlChanged);
    _pulseController.dispose();
    super.dispose();
  }

  void _onCategoryTapped(int index) {
    if (index < 0 || index >= _categoryUrls.length) return;
    setState(() {
      _selectedCategoryIndex = index;
    });
    _service.startPageLoadingManual();
    _service.controller.loadRequest(Uri.parse(_categoryUrls[index]));
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
              // Main News WebView with Pull-to-Refresh
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
        // Native Bottom News Category Bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedCategoryIndex,
            onTap: _onCategoryTapped,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF0284C7),
            unselectedItemColor: const Color(0xFF6B7280),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Manşet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_outlined),
                activeIcon: Icon(Icons.newspaper_rounded),
                label: 'Gündem',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up_outlined),
                activeIcon: Icon(Icons.trending_up_rounded),
                label: 'Ekonomi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public_outlined),
                activeIcon: Icon(Icons.public_rounded),
                label: 'Dünya',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business_center_outlined),
                activeIcon: Icon(Icons.business_center_rounded),
                label: 'TUİD',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Initial app launch splash screen highlighting Ukraine News Portal identity
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
          const SizedBox(height: 24),
          const Text(
            'TUİD',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: Color(0xFF313B45),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4DB2EC).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF4DB2EC).withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: const Text(
              'UKRAYNA HABER PORTALI',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Ukrayna\'dan Güncel Haberler, Ekonomi ve İş Dünyası',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Color(0xFF4B5563),
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
            'tuid.org.ua • Ukrayna Haber Merkezi',
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

  /// Elegant loading effect shown when clicking on articles or categories
  Widget _buildPageTransitionLoader() {
    return Container(
      color: Colors.white.withValues(alpha: 0.94),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
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
                  const SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4DB2EC),
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 52,
                      height: 52,
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
              const SizedBox(height: 18),
              const Text(
                'Haber Yükleniyor...',
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
                      ? 'Haberler yüklenirken bir sorun oluştu. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.'
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
