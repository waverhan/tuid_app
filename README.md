# TUİD - Ukrayna Haber Portalı

<p align="center">
  <img src="assets/images/logo.png" width="120" height="120" alt="TUİD Ukrayna Haber Portalı" />
</p>

<h3 align="center">Ukrayna'dan Güncel Haberler, Son Dakika Gelişmeleri ve Ekonomi Portalı</h3>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.29+-02569B?logo=flutter" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.7+-0175C2?logo=dart" alt="Dart"></a>
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-4DB2EC" alt="Platform"></a>
  <img src="https://img.shields.io/badge/Category-News%20%26%20Magazines-0284C7" alt="Category">
  <img src="https://img.shields.io/badge/License-Proprietary-red" alt="License">
</p>

---

## 📌 Proje ve Portal Hakkında

**TUİD Mobil**, Ukrayna ile ilgili en güncel haberleri, son dakika gelişmelerini, savaş ve diplomasi trafiğini, ekonomi verilerini ve Türk-Ukrayna iş dünyasını anlık olarak takip etmek isteyenler için geliştirilmiş **Ukrayna Türkçe Haber Portalı** resmi mobil uygulamasıdır.

Uygulama, [tuid.org.ua](https://tuid.org.ua) haber merkezinin yayın akışını modern mobil teknolojilerle birleştirerek okuyuculara en hızlı, güvenilir ve tarafsız Ukrayna haber akışını sunar.

---

## 🚀 Haber Portalı Özellikleri

- **📰 Ukrayna Son Dakika & Gündem:** Kiev, Lviv, Odesa, Harkiv ve cephe hattından anlık sıcak haberler ve flaş gelişmeler.
- **📈 Ekonomi, Piyasa ve Finans:** Ukrayna Grivnası (UAH), döviz kurları, tahıl koridoru, enerji sektörü, yatırım teşvikleri ve ekonomik analizler.
- **🤝 Türkiye - Ukrayna İş Dünyası:** İki ülke arasındaki ticaret hacmi, Serbest Ticaret Anlaşması (STA), Türk şirketlerinin yatırımları ve lojistik haberleri.
- **🌐 Dünya & Jeopolitika:** Ukrayna'yı ilgilendiren uluslararası zirveler, AB, NATO, BM kararları ve stratejik raporlar.
- **🧭 Hızlı Kategori Gezinimi (Native Bottom Bar):**
  - 🏠 **Manşet:** Günün en önemli manşet ve öne çıkan haberleri
  - 📰 **Gündem:** Siyaset, kamuoyu ve son dakika gelişmeleri
  - 📈 **Ekonomi:** Finans, yatırım ve piyasa haberleri
  - 🌐 **Dünya:** Küresel diplomasi ve dış politika
  - 💼 **TUİD:** İş insanları derneği, üyeler ve kurumsal haberler
- **⚡ Ultra Hızlı WebView Mimarisi (Pre-warming):** Uygulama açıldığı anda arka planda bağlantı kurularak haberlerin anında açılması sağlanır.
- **🎯 Tahmine Dayalı Önbellekleme (Predictive Prefetch Engine):** Habere dokunulduğu milisaniyede (`touchstart`) sayfa indirilmeye başlar; tıklandığında bekleme süresi ortadan kalkar.
- **🖼️ Anında Resim Çözücü (Instant Image Hydration):** WordPress Newspaper temasının tüm görsel kartları taranarak fotoğraflar anında yüklenir. Boş gri kutular engellenir.
- **✨ Seri Sayfa Geçiş Animasyonu:** Tıklanan haberlerin içeriği arka planda hazırlandığı anda (~400ms) pürüzsüzce ekrana gelir.
- **📱 iOS WebKit bfcache & Jest Desteği:** Sol kenardan kaydırılarak geri gidildiğinde önceki haber **0 milisaniyede** hafızadan anında gelir.
- **🔄 Aşağı Çekerek Yenileme (Pull-to-Refresh):** Son dakika haber akışını aşağı kaydırarak anında güncelleme imkanı.
- **📞 Entegre İletişim Protokolleri:** `tel:`, `mailto:`, `whatsapp:`, `tg:` ve `sms:` linkleri doğrudan cihazın yerel uygulamalarında açılır.

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
   - `android/key.properties` dosyası oluşturun ve imza bilgilerinizi ekleyin.
2. **App Bundle (AAB) Oluşturma:**
   ```bash
   flutter build appbundle --release
   ```
   Çıktı: `build/app/outputs/bundle/release/app-release.aab`

3. **APK Oluşturma:**
   ```bash
   flutter build apk --release
   ```
   Çıktı: `build/app/outputs/flutter-apk/app-release.apk`

---

### 🍏 iOS (Apple App Store)

1. **Xcode Projesini Açın:**
   ```bash
   open ios/Runner.xcworkspace
   ```
2. **Signing & Capabilities:**
   - Apple Developer hesabınızı seçin, Bundle Identifier (`ua.org.tuid.tuidApp`) kontrolünü yapın.
3. **Release IPA Oluşturma:**
   ```bash
   flutter build ipa --release
   ```
4. **App Store Connect'e Yükleme:**
   - `build/ios/ipa` dizinindeki arşivi Transporter uygulaması veya Xcode Organizer ile yükleyin.

---

## 📋 Mağaza Bilgileri & ASO Dokümantasyonu (Store Metadata)

### 🏷️ Temel Başlık ve Kategori Bilgileri
- **Apple App Store Başlığı (30 karakter):** `TUİD: Ukrayna Haberleri`
- **Apple App Store Alt Başlık (30 karakter):** `Ukrayna Güncel Haber Portalı`
- **Google Play Başlığı (50 karakter):** `TUİD - Ukrayna Haber Portalı & Güncel Haberler`
- **Paket Kimlikleri:**
  - **iOS Bundle Identifier:** `ua.org.tuid.tuidApp`
  - **Android Application ID:** `ua.org.tuid.tuid_app`
- **Birincil Kategori (Primary):** Haberler ve Dergiler (News & Magazines)
- **İkincil Kategori (Secondary):** İş Dünyası (Business)
- **Yaş Sınırı:** 4+ (Tüm Yaş Grupları)
- **Telif Hakkı:** © Türkiye Ukrayna İş İnsanları Derneği (TUİD)
- **İletişim / Destek:** info@tuid.org.ua
- **Web Sitesi:** [https://tuid.org.ua](https://tuid.org.ua)
- **Gizlilik Politikası:** [https://tuid.org.ua/gizlilik-politikasi](https://tuid.org.ua/gizlilik-politikasi)

---

### 📝 Mağaza Tanıtım Metinleri (Türkçe)

#### 🔹 Google Play Kısa Açıklama (Short Description - 80 karakter):
> Ukrayna'dan en güncel son dakika haberleri, ekonomi, iş dünyası ve analizler.

#### 🔹 Apple App Store Tanıtım Metni (Promotional Text - 170 karakter):
> Ukrayna gündemi cebinizde! Kiev'den son dakika gelişmeler, savaş ve diplomasi haberleri, piyasa analizleri ve Türk-Ukrayna iş dünyası TUİD Haber Portalı'nda.

#### 🔹 Detaylı Mağaza Açıklaması (Full Description):
```text
Ukrayna'nın Nabzı Bu Uygulamada: TUİD Ukrayna Haber Portalı

Ukrayna ile ilgili en güvenilir, tarafsız ve son dakika haberleri anında takip etmek artık çok kolay! TUİD Mobil Uygulaması, Ukrayna'dan güncel gelişmeleri, sıcak haber başlıklarını ve derinlemesine ekonomik analizleri tek bir çatı altında sunan resmi dijital haber portalıdır.

Kiev başta olmak üzere Ukrayna'nın tüm şehirlerinden gelişmeler, savaş ve diplomasi trafiği, yeniden imar süreçleri, ticaret fırsatları ve iki ülke arasındaki stratejik ilişkiler artık parmaklarınızın ucunda.

📰 Öne Çıkan Haber Kategorileri ve Özellikler:

• 🔴 Ukrayna Son Dakika & Flaş Gelişmeler: Sahadan en sıcak haberler, resmi açıklamalar, güvenlik durumları ve anlık bildirimler.
• 📊 Ekonomi & Finans Portalı: Ukrayna Grivnası (UAH), enflasyon, tarım, enerji, lojistik ve sektörel piyasa raporları.
• 🤝 Türk - Ukrayna İş Dünyası: İki ülke arasındaki yatırım fırsatları, Serbest Ticaret Anlaşması (STA) süreçleri, Türk iş insanlarının faaliyetleri ve başarı hikayeleri.
• 🌍 Dünya & Uluslararası Diplomasi: AB, NATO, BM ekseninde Ukrayna'yı ilgilendiren küresel jeopolitik kararlar ve müzakereler.
• 📑 Röportajlar & Özel Analizler: Alanında uzman isimlerle yapılmış özel röportajlar, makaleler ve köşe yazıları.
• 🧭 Hızlı Kategori Menüsü: Manşet, Gündem, Ekonomi, Dünya ve TUİD kategorilerine tek dokunuşla ulaşabilen modern alt gezinme çubuğu.
• ⚡ Hızlı ve Akıcı Haber Deneyimi: Resimleri anında yüklenen, veri tasarrufu sağlayan ve pil dostu modern arayüz.

Ukrayna'daki tüm gelişmeleri ilk elden, güvenilir kaynaklardan ve Türkçe olarak takip etmek için TUİD Ukrayna Haber Portalı uygulamasını hemen indirin!
```

#### 🔹 Anahtar Kelimeler (App Store Keywords - 100 karakter):
```text
ukrayna haberleri,ukrayna son dakika,kiev,ukrayna ekonomi,ukrayna savaşı,tuid,ukrayna türkiye,haber portalı
```

---

### 📝 Mağaza Tanıtım Metinleri (English / International Context)

#### 🔹 Subtitle (30 chars):
> Ukraine News Portal & Business

#### 🔹 Short Description (80 chars):
> Breaking news, business, and daily economic updates from Ukraine.

#### 🔹 Full Description:
```text
Stay Informed with the Premier Ukraine News Portal: TUİD Mobile

TUİD Mobile is your essential news and intelligence portal for Ukraine. Covering politics, daily business news, economic developments, bilateral trade relations, and key geopolitical events, this app brings Ukraine's heartbeat directly to your mobile device.

Key Features:
• Breaking News & Daily Briefings: Real-time updates from Kyiv, Odesa, Lviv, and across the country.
• Business & Economics: In-depth coverage of the Ukrainian market, agriculture, logistics, and Free Trade Agreement (FTA) updates.
• Bilateral Relations: Insights into Turkish-Ukrainian economic partnerships and investor opportunities.
• Intuitive Categories: Instant access to Top Stories, Economy, World Diplomacy, and Business community news via a sleek bottom navigation bar.
• High Performance: Fast-loading articles, optimized media, and a modern reading experience.

Download the TUİD Ukraine News Portal app today and stay ahead with reliable, first-hand news!
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

Haber portalının en yüksek hızda çalışması için sunucu tarafında şu yapılandırma önerilir:

1. **Önbellekleme:** **WP Super Cache** + **Cloudflare** birlikte kullanılmalıdır.
2. **Tema Uyumu:** *Newspaper Theme Panel > General Features > Image loading* ayarı `Normal` yapılmalıdır.
3. **Eklenti Çakışmaları:** Perfmatters Lazy Load özelliği TagDiv Newspaper temasının dinamik resim yapısıyla çakışabileceği için kapalı tutulmalıdır.
4. **Önbellek Temizleme:** Ayar değişikliklerinden sonra hem WP Super Cache hem de Cloudflare panelinden *Purge Everything* yapılmalıdır.

---

## 📄 Lisans
Bu proje Türkiye Ukrayna İş İnsanları Derneği'ne (TUİD) aittir. Tüm hakları saklıdır.
