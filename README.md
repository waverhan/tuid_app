# TUİD Mobil Uygulaması

<p align="center">
  <img src="assets/images/logo.png" width="120" height="120" alt="TUİD Logo" />
</p>

<h3 align="center">Türkiye Ukrayna İş İnsanları Derneği Resmi Mobil Uygulaması</h3>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.29+-02569B?logo=flutter" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.7+-0175C2?logo=dart" alt="Dart"></a>
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-4DB2EC" alt="Platform"></a>
  <img src="https://img.shields.io/badge/License-Proprietary-red" alt="License">
</p>

---

## 📌 Proje Hakkında

**TUİD Mobil**, Türkiye Ukrayna İş İnsanları Derneği'nin ([tuid.org.ua](https://tuid.org.ua)) resmi mobil uygulamasıdır. İki ülke arasındaki ticari, ekonomik ve kültürel ilişkileri güçlendirmek; iş insanlarına güncel haberleri, duyuruları, etkinlikleri ve analizleri kesintisiz, hızlı ve modern bir mobil arayüzle sunmak amacıyla Flutter teknolojisiyle geliştirilmiştir.

---

## 🚀 Öne Çıkan Özellikler

- **⚡ Erken Başlatma (Pre-warming):** Uygulama başlatılır başlatılmaz (`main()`) WebView controller devreye girer ve ağ isteklerini arka planda başlatır.
- **🎯 Tahmine Dayalı Önbellekleme (Predictive Prefetch Engine):**
  - Kullanıcı bir habere dokunduğu anda (`touchstart`), `click` olayı beklenmeden sayfa HTTP önbelleğine çekilir (~200ms kazanç).
  - Boşta kalındığında ekranda görünen haber linkleri arka planda sessizce önbelleğe alınır.
- **🖼️ Anında Resim Çözücü (Instant Image Hydration):** 
  - WordPress Newspaper temasının `data-img-url` ve `data-src` kullanan haber kartları ekranda kaydırma beklemeden anında doldurulur. Boş gri kutular tamamen engellenir.
- **✨ Şık Sayfa Geçiş Efekti (Fast Transition Loader):**
  - Sayfalar arası geçişlerde TUİD logolu, modern mavi halka göstergeli, kullanıcıyı asla bekletmeyen (maks. 1.2s limitli, DOM hazır olduğunda ~400ms'de açılan) akıcı geçiş animasyonu.
- **📱 iOS WebKit bfcache & Kenar Kaydırma:**
  - `setAllowsBackForwardNavigationGestures` ile sol kenardan kaydırılarak geri gidildiğinde önceki sayfa **0 milisaniyede** hafızadan gelir.
- **🔄 Aşağı Çekerek Yenileme (Pull-to-Refresh):** Standart mobil kullanıcı deneyimiyle sayfayı kolayca tazeleyebilme.
- **🌐 Akıllı Protokol Yönlendirme:** Telefon (`tel:`), e-posta (`mailto:`), SMS (`sms:`), WhatsApp (`whatsapp:`) ve Telegram (`tg:`) bağlantılarını doğrudan cihazın yerel uygulamalarında açar.
- **🛡️ Çevrimdışı / Hata Yönetimi:** İnternet kesintilerinde modern, kurumsal tasarımlı "Yeniden Dene" ekranı.

---

## 🛠️ Kurulum ve Geliştirme

### Gereksinimler
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.29.0 veya üzeri)
- [Dart SDK](https://dart.dev/get-dart) (v3.7.0 veya üzeri)
- **iOS için:** macOS, Xcode 15+, CocoaPods
- **Android için:** Android Studio, Android SDK (API 34+)

### Adım Adım Kurulum

1. **Depoyu Klonlayın:**
   ```bash
   git clone https://github.com/waverhan/tuid_app.git
   cd tuid_app
   ```

2. **Bağımlılıkları Yükleyin:**
   ```bash
   flutter pub get
   ```

3. **iOS Bağımlılıklarını Yükleyin (macOS):**
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Uygulamayı Çalıştırın:**
   ```bash
   # Bağlı cihazları listele
   flutter devices

   # Hata ayıklama (Debug) modunda başlat
   flutter run
   ```

5. **Testleri ve Kod Analizini Çalıştırın:**
   ```bash
   flutter analyze
   flutter test
   ```

---

## 📦 Dağıtım ve Yayınlama (Release Build)

### 🤖 Android (Google Play Store)

1. **İmzalama Anahtarı (Keystore) Hazırlığı:**
   - `android/key.properties` dosyası oluşturun ve anahtar bilgilerinizi tanımlayın.
2. **App Bundle (AAB) Oluşturma:**
   ```bash
   flutter build appbundle --release
   ```
   Çıktı dosyası: `build/app/outputs/bundle/release/app-release.aab`

3. **Alternatif APK Oluşturma:**
   ```bash
   flutter build apk --release
   ```
   Çıktı dosyası: `build/app/outputs/flutter-apk/app-release.apk`

---

### 🍏 iOS (Apple App Store)

1. **Xcode Projesini Açın:**
   ```bash
   open ios/Runner.xcworkspace
   ```
2. **Signing & Capabilities:**
   - Xcode üzerinden Apple Developer hesabınızla giriş yapın.
   - *Signing & Capabilities* sekmesinde Team ve Bundle Identifier (`ua.org.tuid.tuidApp`) ayarlarını doğrulayın.
3. **Release IPA Oluşturma:**
   ```bash
   flutter build ipa --release
   ```
4. **App Store Connect'e Yükleme:**
   - `build/ios/ipa` klasöründeki dosyayı Xcode Organizer veya Transporter uygulamasıyla App Store Connect'e yükleyin.

---

## 📋 Mağaza Bilgileri & Dokümantasyon (Store Metadata)

### 🏷️ Temel Bilgiler
- **Apple App Store Başlığı (30 karakter):** `TUİD: Ukrayna Haberleri`
- **Apple App Store Alt Başlık (30 karakter):** `Ukrayna Güncel Haber Portalı`
- **Google Play Başlığı (50 karakter):** `TUİD - Ukrayna Haber Portalı & Güncel Haberler`
- **Paket Kimlikleri:**
  - **iOS Bundle Identifier:** `ua.org.tuid.tuidApp`
  - **Android Application ID:** `ua.org.tuid.tuid_app`
- **Birincil Kategori (Primary Category):** Haberler (News)
- **İkincil Kategori (Secondary Category):** İş (Business) / Gazeteler & Dergiler
- **Yaş Sınırı:** 4+ (Tüm Yaş Grupları)
- **Telif Hakkı:** © Türkiye Ukrayna İş İnsanları Derneği (TUİD)
- **Destek / İletişim E-posta:** info@tuid.org.ua
- **Web Sitesi:** [https://tuid.org.ua](https://tuid.org.ua)
- **Gizlilik Politikası:** [https://tuid.org.ua/gizlilik-politikasi](https://tuid.org.ua/gizlilik-politikasi)

---

### 📝 Mağaza Metinleri (Türkçe)

#### Kısa Açıklama (Google Play Short Description - 80 karakter):
> Ukrayna'dan en son dakika haberleri, ekonomi, iş dünyası ve analizler.

#### Detaylı Açıklama (Full Description):
```text
Ukrayna'nın Nabzı Bu Uygulamada: TUİD Ukrayna Haber Portalı

TUİD Mobil Uygulaması; Ukrayna'dan en güvenilir, güncel ve tarafsız haberleri anlık olarak cebinize getiren dijital haber platformudur. 

Ukrayna gündemi, Kiev'den sıcak gelişmeler, savaş ve diplomasi trafiği, ekonomi, ticaret fırsatları ve iki ülke arasındaki stratejik ilişkiler artık parmaklarınızın ucunda!

📰 Öne Çıkan Haber Kategorileri ve Özellikler:
• Son Dakika & Gündem: Ukrayna'dan anlık gelişmeler, resmi açıklamalar, sahadan sıcak haberler ve analizler.
• Ekonomi & Finans: Ukrayna pazarı, para birimi (Grivna/Dolar), tarım, enerji ve sektörel piyasa raporları.
• Türkiye - Ukrayna İş Dünyası: Türk yatırımcılar, ihracat-ithalat fırsatları, lojistik ve Serbest Ticaret Anlaşması gelişmeleri.
• Dünya & Diplomasi: Ukrayna'yı ilgilendiren küresel jeopolitik kararlar, AB ve NATO süreçleri.
• Hızlı Kategori Gezinimi: Manşet, Gündem, Ekonomi, Dünya ve TUİD kategorilerine tek dokunuşla ulaşabilen modern alt gezinme menüsü.
• Akıcı Okuma Deneyimi: Optimize edilmiş, resimleri anında açılan ve pil dostu modern haber arayüzü.

Ukrayna'daki gelişmeleri ilk elden, güvenilir kaynaklardan ve Türkçe olarak takip etmek için TUİD Ukrayna Haber Portalı uygulamasını hemen indirin!
```

#### Anahtar Kelimeler (App Store Keywords - 100 karakter):
```text
ukrayna haberleri,ukrayna son dakika,kiev,ukrayna ekonomi,ukrayna savaşı,tuid,ukrayna türkiye,haber portalı
```

---

### 📝 Mağaza Metinleri (English / International Context)

#### Subtitle (30 chars):
> Ukraine News Portal & Business

#### Description:
```text
Stay Informed with the Premier Ukraine News Portal - TUİD Mobile.

Get instant access to breaking news, economic reports, and daily developments from Ukraine. Powered by the International Turkish Ukrainian Businessmen Association (TUİD), this app delivers comprehensive coverage of Ukraine's politics, business landscape, bilateral trade, and market insights directly to your device.
```

---

## 🎨 İkonlar ve Görsel Varlıklar (App Icons & Assets)

Proje kök dizinindeki `AppIcons/` klasöründe yer alan kurumsal ikon paketi tüm platformlara entegre edilmiştir:

- **iOS Asset Catalog (`ios/Runner/Assets.xcassets/AppIcon.appiconset/`):** iPhone ve iPad için 20px - 1024px arası tüm retina ve App Store ikonları eksiksiz yerleştirilmiştir.
- **Android Launcher Mipmaps (`android/app/src/main/res/mipmap-*/`):** `mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi` çözünürlüklerinde optimize `ic_launcher.png` ikonları tanımlanmıştır.
- **Uygulama İçi Görseller (`assets/images/logo.png`):** Açılış ekranı (splash screen) ve sayfa geçiş animasyonunda bu yüksek çözünürlüklü vektörel tabanlı kurumsal logo kullanılmaktadır.
- **Pazarlama Görselleri (`AppIcons/`):**
  - `AppIcons/appstore.png`: Apple App Store (1024x1024)
  - `AppIcons/playstore.png`: Google Play Store (512x512)

---

## ⚙️ WordPress & Sunucu Önerileri

Uygulamanın en yüksek hızda çalışması için sunucu tarafında şu yapılandırma önerilir:

1. **Önbellekleme:** **WP Super Cache** + **Cloudflare** birlikte kullanılmalıdır.
2. **Tema Uyumu:** *Newspaper Theme Panel > General Features > Image loading* ayarı `Normal` yapılmalıdır.
3. **Eklenti Çakışmaları:** Perfmatters Lazy Load özelliği TagDiv Newspaper temasının dinamik resim yapısıyla çakışabileceği için kapalı tutulmalıdır.
4. **Önbellek Temizleme:** Ayar değişikliklerinden sonra hem WP Super Cache hem de Cloudflare panelinden *Purge Everything* yapılmalıdır.

---

## 📄 Lisans
Bu proje Türkiye Ukrayna İş İnsanları Derneği'ne (TUİD) aittir. Tüm hakları saklıdır.
