# BizimDubai

Dubai'deki Türk topluluğu için mobil yaşam platformu.

## İlk sürüm
- **Keşfet:** Türk işletmeleri ve doğrulanmış Türkçe hizmet veren profesyoneller. Gerçek seed data; restoran, sağlık, market, güzellik, emlak, eğitim, spor, otomotiv, kargo, fotoğraf, profesyonel destek, pet ve Türk etkinlikleri.
- **Topluluk:** Gruplar, kullanıcıların oluşturduğu etkinlikler, halı saha/padel/maç izleme/kahve gibi buluşmalar ve katılım akışları.
- **Rehber:** Dubai'ye yeni gelenler, ev, araç, sağlık, aile, iş, resmî işlemler, çıkış ve acil durum akışları.
- **İlanlar:** İkinci el ürünler, Leaving Dubai paketleri, satılık/kiralık/ücretsiz/ürün takası. P2P döviz takası yoktur.
- **Profil:** Favoriler, ilanlar, etkinlikler, gruplar ve işletme profil sahiplenme.

## Tasarım
Kırmızı-beyaz BizimDubai kimliği, büyük görsel kartlar, sade navigasyon ve 2-3 dokunuşta sonuca ulaşma hedefi.

## Build
Codemagic `codemagic.yaml` içinde iki workflow içerir:
- `android-release` → APK
- `ios-testflight` → IPA / TestFlight hazırlığı

### iOS Codemagic environment group
`appstore_credentials` grubunda şu değişkenler bulunmalı:
- `APP_STORE_CONNECT_PRIVATE_KEY`
- `APP_STORE_CONNECT_KEY_IDENTIFIER`
- `APP_STORE_CONNECT_ISSUER_ID`

Bundle ID: `com.cakirizm.bizimdubai`
