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
- **Uygulama Adı (App Name):** TUİD
- **Tam Başlık:** TUİD - Türkiye Ukrayna İş İnsanları Derneği
- **Paket Kimlikleri:**
  - **iOS Bundle Identifier:** `ua.org.tuid.tuidApp`
  - **Android Application ID:** `ua.org.tuid.tuid_app`
- **Birincil Kategori:** İş (Business)
- **İkincil Kategori:** Haberler (News)
- **Yaş Sınırı:** 4+ (Tüm Yaş Grupları)
- **Telif Hakkı:** © Türkiye Ukrayna İş İnsanları Derneği (TUİD)
- **Destek / İletişim E-posta:** info@tuid.org.ua
- **Web Sitesi:** [https://tuid.org.ua](https://tuid.org.ua)
- **Gizlilik Politikası:** [https://tuid.org.ua/gizlilik-politikasi](https://tuid.org.ua/gizlilik-politikasi)

---

### 📝 Mağaza Metinleri (Türkçe)

#### Kısa Açıklama (Short Description - 80 karakter):
> Türkiye ve Ukrayna arasındaki ticaret, iş dünyası ve güncel haberler.

#### Detaylı Açıklama (Full Description):
```text
Türkiye Ukrayna İş İnsanları Derneği (TUİD) Resmi Mobil Uygulaması

TUİD mobil uygulaması; Türkiye ile Ukrayna arasındaki ekonomik, ticari ve stratejik iş birliğini takip etmek isteyen iş insanları, yatırımcılar ve takipçiler için en güncel haberleri ve duyuruları tek bir çatı altında sunar.

Öne Çıkan Özellikler:
• Son Dakika Haberleri: Ukrayna ve Türkiye gündemine dair en taze gelişmeler, analizler ve röportajlar.
• İş Dünyası ve Ekonomi: İki ülke arasındaki yatırım fırsatları, ticaret hacmi ve sektörel raporlar.
• Etkinlikler ve Duyurular: TUİD üyelerine özel etkinlikler, zirveler ve dernek faaliyetleri.
• Akıcı Mobil Deneyim: Hızlı, kullanıcı dostu ve optimize edilmiş modern arayüz.
• Doğrudan İletişim: Dernek merkezine tek dokunuşla e-posta ve telefon üzerinden ulaşabilme.

İki ülke arasındaki köprü olan TUİD'in resmi uygulaması ile iş dünyasının nabzını anlık olarak tutun!
```

#### Anahtar Kelimeler (Keywords - 100 karakter):
```text
tuid,ukrayna,türkiye,iş insanları,ticaret,kiev,ekonomi,yatırım,haberler,dernek,iş dünyası
```

---

### 📝 Mağaza Metinleri (English / Ukrainian Context)

#### Subtitle (30 chars):
> Business & News in Ukraine

#### Description:
```text
Official Mobile Application of the International Turkish Ukrainian Businessmen Association (TUİD).

Stay up to date with the latest business, economic, and bilateral trade news between Turkey and Ukraine. Access in-depth market analysis, member announcements, economic summits, and investment opportunities directly on your mobile device.
```

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
