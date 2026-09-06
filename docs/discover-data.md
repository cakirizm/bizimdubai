# Keşfet veri yönetimi

Keşfet, 6 Eylül 2026 tarihinde yayımlanmış işletme sitelerinden ve profesyonel profillerden kontrol edilen 18 kayıtla, 14 kategoriyi kapsar. Bu sayı Dubai'deki tüm işletmelerin sayısı değildir. Eski kaynaksız kişi, puan ve yorum sayıları aktarılmamıştır. Kayıtların kaynak bağlantıları, görsel açıklamaları ve kontrol tarihi detay ekranında görünür.

## Güncelleme akışı

Tek veri kaynağı `assets/data/discover.json` dosyasıdır. Uygulama açılışta bu dosyanın main dalındaki HTTPS kopyasını kontrol eder. Ön plana döndüğünde son denemeden 6 saat geçtiyse tekrar kontrol eder. Keşfet'teki yenile düğmesi ve aşağı çekme her zaman yeniden kontrol eder.

Varsayılan adres:
`https://raw.githubusercontent.com/cakirizm/bizimdubai/main/assets/data/discover.json`

İstenirse build sırasında `--dart-define=DISCOVER_CATALOG_URL=https://...` ile başka HTTPS sunucusuna taşınabilir. Google Places anahtarı gerekmez. Otomatik işletme taraması veya canlı Google puan servisi değildir: editör kaynakları kontrol eder, uygulama yayımlanan yeni sürümü otomatik alır.

1. İşletmenin resmî şube/iletişim sayfasını kontrol edin. Adres, telefon, menü, dil desteği ve varsa koordinat için `sources` ekleyin.
2. Kaydı JSON içinde değiştirin. `id` sabit kalmalı; kategoriler uygulamadaki 14 başlıktan seçilmeli. Bir kayıt birden fazla kategoride yer alabilir.
3. Gerçek resim URL'sini, kaynağını ve açıklamasını `photos` içine ekleyin. Yeni çevrimiçi kayıtlar için `asset` alanını atlayın; fotoğraf HTTPS üzerinden açılır. Build'e dahil edilecek dosyaları `assets/images/discover/` içine koyabilirsiniz. Marka geneli fotoğrafı belirli bir şubeye aitmiş gibi etiketlemeyin. Marka illüstrasyonu/tanıtım görseli fotoğraf olarak tanıtılmamalıdır.
4. `checkedAt` tarihini yenileyin; katalog `revision` sayısını artırın ve `updatedAt` alanını UTC olarak güncelleyin. Aynı revision içeriği değiştirilmemelidir.
5. `dart run scripts/generate_discover_seed.dart` çalıştırın. `flutter test` ve `flutter analyze --no-fatal-infos` sonrasında JSON, seed ve varsa yeni görselleri birlikte commit/push edin.

Yalnızca kayıt/görsel/telefon/menü değişikliklerinde yeni mobil build gerekmez. Yeni uygulama özelliği veya kategori tanımı için build gerekir. Kayıt kaldırmak için `active: false` kullanın veya katalogdan çıkarın. Açık detay ekranı kaldırılan kayda erişimi kapatır.

## Güvenilirlik ve çevrimdışı kullanım

- Şema, URL, telefon, koordinat aralığı, kategori, benzersiz ID ve 2 MB / 2.000 kayıt sınırı kontrol edilir. Bozuk veya daha eski katalog uygulanmaz.
- Geçerli yeni katalog önce cihazda saklanır, ardından tek seferde listeye uygulanır. Bağlantı veya kayıt hatasında son geçerli katalog korunur ve durum gösterilir.
- İlk kurulumda tüm başlangıç fotoğrafları ve katalog uygulama içindedir. Sonradan eklenen çevrimiçi fotoğraflar bağlantı gerektirir; görüntü hatası gerçek fotoğrafla karıştırılabilecek başka bir görselle örtülmez.
- Favoriler cihazda saklanır. Henüz hesaplar arasında eşitleme yoktur.
- Türkçe hizmet filtresi sadece kaynağı bu hizmeti açıkça belirten kayıtlara uygulanır. Türk markası olmak tek başına dil hizmeti varsayımı değildir.
- Adrese göre rota araması GPS yakınlık filtresi değildir. Sabit ofisi olmayan profesyoneller için hayalî adres/harita oluşturulmaz.

## Harita ve iletişim

Google Maps ve Waze düğmeleri ayrıdır. İşletmenin yayımladığı koordinat varsa kullanılır; yoksa tam adres aramaya gönderilir. KARGO DUBAI'nin yayımlanan ofisi İstanbul'dadır; Turkish Vet Jubail şubesi Sharjah'dadır. Adreslere otomatik “Dubai” eklenmez.

Menüler resmî web/PDF bağlantısında açılır; uygulama fiyat uydurmaz veya eski fiyat kopyası tutmaz. Doğrulanmış menüsü bulunmayan restoran bu durumu açıkça gösterir. WhatsApp sadece yayımlanmış WhatsApp numarası varsa sunulur. İşletmenin kendi sitesinde yayımladığı puan, canlı Google puanı olarak gösterilmez.

Harita bağlantı biçimleri: [Google Maps URLs](https://developers.google.com/maps/documentation/urls/get-started), [Waze Deep Links](https://developers.google.com/waze/deeplinks).

## Testler

`test/discover_test.dart`: veri/görsel bütünlüğü; tüm kategori kapsamı; kalıcı önbellek ve favoriler; bozuk/eski/offline güncelleme; Türkçe arama ve birleşik filtreler; resmî menü ve iki harita hedefi; 320/393/430 genişliklerinde büyük yazı; 18 detay sayfasında taşma ve eksik konum davranışı.

`test/home_navigation_test.dart`: ana sayfa yönlendirmeleri ve düzeni. Codemagic iki iOS workflow'unda seed eşitliğini, tüm testleri ve analizi build öncesi çalıştırır.
