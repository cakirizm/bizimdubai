part of '../main.dart';

const discoverCategories = <({String title, IconData icon})>[
  (title: 'Restoranlar', icon: Icons.restaurant_rounded),
  (title: 'Sağlık', icon: Icons.health_and_safety_outlined),
  (title: 'Market & Gıda', icon: Icons.local_grocery_store_outlined),
  (title: 'Güzellik & Bakım', icon: Icons.content_cut_rounded),
  (title: 'Ev & Emlak', icon: Icons.home_work_outlined),
  (title: 'Çocuk & Eğitim', icon: Icons.school_outlined),
  (title: 'Spor & Wellness', icon: Icons.fitness_center_rounded),
  (title: 'Mağazalar & Türk Markaları', icon: Icons.shopping_bag_outlined),
  (title: 'Otomotiv', icon: Icons.directions_car_outlined),
  (title: 'Kargo & Taşıma', icon: Icons.local_shipping_outlined),
  (title: 'Fotoğraf & Organizasyon', icon: Icons.photo_camera_outlined),
  (title: 'Profesyonel Destek', icon: Icons.business_center_outlined),
  (title: 'Pet', icon: Icons.pets_outlined),
  (title: 'Kültür & Türk Etkinlikleri', icon: Icons.theater_comedy_outlined),
];

String discoverSearchText(String value) => value
    .trim()
    .replaceAll('İ', 'i')
    .replaceAll('I', 'ı')
    .toLowerCase()
    .replaceAll('ı', 'i')
    .replaceAll('ş', 's')
    .replaceAll('ğ', 'g')
    .replaceAll('ü', 'u')
    .replaceAll('ö', 'o')
    .replaceAll('ç', 'c');

bool _https(String value) {
  final uri = Uri.tryParse(value);
  return uri != null &&
      uri.scheme == 'https' &&
      uri.host.contains('.') &&
      uri.userInfo.isEmpty;
}

class DiscoverPhoto {
  DiscoverPhoto(Map<String, dynamic> json)
      : url = json['url'] as String,
        source = json['source'] as String,
        caption = json['caption'] as String,
        asset = json['asset'] as String? {
    if (!_https(url) ||
        !_https(source) ||
        caption.isEmpty ||
        (asset != null &&
            !RegExp(r'^assets/images/discover/[a-z0-9_-]+\.(jpg|jpeg|png|webp)$')
                .hasMatch(asset!))) {
      throw const FormatException('Invalid photo');
    }
  }
  final String url, source, caption;
  final String? asset;
}

class DiscoverItem {
  DiscoverItem(Map<String, dynamic> j)
      : id = j['id'] as String,
        name = j['name'] as String,
        category = j['category'] as String,
        categories = List<String>.unmodifiable(j['categories'] as List),
        area = j['area'] as String,
        kind = j['kind'] as String,
        entityType = j['entityType'] as String,
        address = j['address'] as String?,
        phone = j['phone'] as String?,
        whatsapp = j['whatsapp'] as String?,
        website = j['website'] as String,
        subtitle = j['description'] as String,
        menuUrl = j['menuUrl'] as String?,
        turkishService = j['turkishService'] == true,
        checkedAt = DateTime.parse(j['checkedAt'] as String),
        photos = List.unmodifiable((j['photos'] as List)
            .map((p) => DiscoverPhoto(p as Map<String, dynamic>))),
        sources = List<String>.unmodifiable(j['sources'] as List),
        latitude = (j['latitude'] as num?)?.toDouble(),
        longitude = (j['longitude'] as num?)?.toDouble(),
        coordinateSource = j['coordinateSource'] as String?,
        rating = (j['rating'] as num?)?.toDouble(),
        ratingSource = j['ratingSource'] as String?,
        ratingLabel = j['ratingLabel'] as String? {
    final names = discoverCategories.map((c) => c.title).toSet();
    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(id) ||
        name.trim().isEmpty ||
        area.isEmpty ||
        !categories.contains(category) ||
        categories.any((c) => !names.contains(c)) ||
        !['business', 'professional'].contains(entityType) ||
        photos.isEmpty ||
        sources.isEmpty ||
        sources.any((s) => !_https(s)) ||
        !_https(website) ||
        (menuUrl != null && !_https(menuUrl!)) ||
        [phone, whatsapp]
            .any((p) => p != null && !RegExp(r'^\+[0-9]{8,15}$').hasMatch(p)) ||
        (latitude == null) != (longitude == null) ||
        (latitude != null &&
            (!latitude!.isFinite ||
                !longitude!.isFinite ||
                latitude!.abs() > 90 ||
                longitude!.abs() > 180 ||
                coordinateSource == null ||
                !_https(coordinateSource!))) ||
        (rating != null &&
            (!rating!.isFinite ||
                rating! < 0 ||
                rating! > 5 ||
                ratingSource == null ||
                !_https(ratingSource!) ||
                ratingLabel == null))) {
      throw const FormatException('Invalid listing');
    }
  }
  final String id, name, category, area, kind, entityType, website, subtitle;
  final List<String> categories, sources;
  final List<DiscoverPhoto> photos;
  final String? address,
      phone,
      whatsapp,
      menuUrl,
      coordinateSource,
      ratingSource,
      ratingLabel;
  final double? latitude, longitude, rating;
  final bool turkishService;
  final DateTime checkedAt;
  bool get hasLocation =>
      latitude != null || (address?.trim().isNotEmpty ?? false);
  Uri directions(String provider) {
    if (!hasLocation) throw StateError('No public location');
    final point = latitude == null ? address! : '$latitude,$longitude';
    if (provider == 'waze') {
      return Uri.https('waze.com', '/ul',
          {latitude == null ? 'q' : 'll': point, 'navigate': 'yes'});
    }
    return Uri.https('www.google.com', '/maps/dir/',
        {'api': '1', 'destination': point, 'travelmode': 'driving'});
  }
}

class DiscoverCatalog {
  DiscoverCatalog._(this.revision, this.updatedAt, this.entries, this.raw);
  factory DiscoverCatalog.parse(String raw) {
    if (utf8.encode(raw).length > 2000000) {
      throw const FormatException('Catalog too large');
    }
    final j = jsonDecode(raw) as Map<String, dynamic>;
    if (j['schemaVersion'] != 1 ||
        j['revision'] is! int ||
        (j['revision'] as int) < 1 ||
        j['entries'] is! List ||
        (j['entries'] as List).length > 2000) {
      throw const FormatException('Unsupported catalog');
    }
    final all = (j['entries'] as List).map((e) {
      final item = DiscoverItem(e as Map<String, dynamic>);
      return (item: item, active: e['active'] != false);
    }).toList();
    if (all.map((e) => e.item.id).toSet().length != all.length) {
      throw const FormatException('Duplicate IDs');
    }
    return DiscoverCatalog._(
        j['revision'] as int,
        DateTime.parse(j['updatedAt'] as String),
        List.unmodifiable(all.where((e) => e.active).map((e) => e.item)),
        raw);
  }
  final int revision;
  final DateTime updatedAt;
  final List<DiscoverItem> entries;
  final String raw;
}

typedef CatalogRead = Future<String?> Function(String key);
typedef CatalogWrite = Future<void> Function(String key, String value);

class DiscoverRepository extends ChangeNotifier {
  DiscoverRepository(
      {Future<String> Function()? fetch,
      CatalogRead? read,
      CatalogWrite? write})
      : _fetch = fetch ?? _download,
        _read = read ?? _readPrefs,
        _write = write ?? _writePrefs;
  static const endpoint = String.fromEnvironment('DISCOVER_CATALOG_URL',
      defaultValue:
          'https://raw.githubusercontent.com/cakirizm/bizimdubai/main/assets/data/discover.json');
  static const cacheKey = 'discover.catalog.v1',
      favoritesKey = 'discover.favorites.v1';
  final Future<String> Function() _fetch;
  final CatalogRead _read;
  final CatalogWrite _write;
  DiscoverCatalog catalog = DiscoverCatalog.parse(discoverSeedJson);
  Set<String> favorites = {};
  bool refreshing = false;
  String? updateError;
  DateTime? lastAttempt;
  Future<void> _saveQueue = Future.value();
  static Future<String?> _readPrefs(String key) =>
      SharedPreferencesAsync().getString(key);
  static Future<void> _writePrefs(String key, String value) =>
      SharedPreferencesAsync().setString(key, value);
  static Future<String> _download() async {
    if (!_https(endpoint)) {
      throw const FormatException('Catalog requires HTTPS');
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 12);
    try {
      return await (() async {
        final request = await client.getUrl(Uri.parse(endpoint));
        request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
        final response = await request.close();
        if (response.statusCode != 200) {
          throw HttpException('HTTP ${response.statusCode}');
        }
        final bytes = <int>[];
        await for (final chunk in response) {
          bytes.addAll(chunk);
          if (bytes.length > 2000000) {
            throw const FormatException('Catalog too large');
          }
        }
        return utf8.decode(bytes);
      })()
          .timeout(const Duration(seconds: 17));
    } finally {
      client.close(force: true);
    }
  }

  Future<void> initialize() async {
    try {
      final raw = await _read(cacheKey).timeout(const Duration(seconds: 2));
      if (raw != null) {
        final cached = DiscoverCatalog.parse(raw);
        if (cached.revision >= catalog.revision) catalog = cached;
      }
    } catch (_) {/* The bundled catalog remains available. */}
    try {
      final raw = await _read(favoritesKey).timeout(const Duration(seconds: 2));
      if (raw != null) favorites = Set<String>.from(jsonDecode(raw) as List);
    } catch (_) {/* Invalid preferences do not block launch. */}
    notifyListeners();
  }

  Future<void> refresh({bool force = false}) async {
    if (refreshing ||
        (!force &&
            lastAttempt != null &&
            DateTime.now().difference(lastAttempt!) <
                const Duration(hours: 6))) {
      return;
    }
    refreshing = true;
    lastAttempt = DateTime.now();
    updateError = null;
    notifyListeners();
    try {
      final next = DiscoverCatalog.parse(
          await _fetch().timeout(const Duration(seconds: 18)));
      if (next.revision < catalog.revision) {
        throw const FormatException('Older catalog');
      }
      if (next.revision > catalog.revision) {
        await _write(cacheKey, next.raw).timeout(const Duration(seconds: 3));
        catalog = next;
      }
    } catch (_) {
      updateError = 'Güncelleme alınamadı. Son kayıtlı liste gösteriliyor.';
    } finally {
      refreshing = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String id) async {
    favorites = {...favorites};
    if (!favorites.remove(id)) favorites.add(id);
    notifyListeners();
    final encoded = jsonEncode(favorites.toList());
    _saveQueue = _saveQueue
        .then((_) =>
            _write(favoritesKey, encoded).timeout(const Duration(seconds: 3)))
        .catchError((Object _) {
      updateError = 'Favoriler bu oturumda kaydedildi; cihaz kaydı yapılamadı.';
      notifyListeners();
    });
    await _saveQueue;
  }

  DiscoverItem? find(String id) {
    for (final item in catalog.entries) {
      if (item.id == id) return item;
    }
    return null;
  }
}

final discoverRepository = DiscoverRepository();
List<DiscoverItem> get discoverItems => discoverRepository.catalog.entries;

class DiscoverFilter {
  String query = '';
  String? category, area, entityType;
  bool menuOnly = false, turkishOnly = false, favoritesOnly = false;
  String sort = 'Önerilen sıra';
  int get count => [
        area != null,
        entityType != null,
        menuOnly,
        turkishOnly,
        favoritesOnly,
        sort != 'Önerilen sıra'
      ].where((b) => b).length;
  List<DiscoverItem> apply(DiscoverRepository repository) {
    final q = discoverSearchText(query);
    final result = repository.catalog.entries
        .where((e) =>
            (category == null || e.categories.contains(category)) &&
            (area == null || e.area == area) &&
            (entityType == null || e.entityType == entityType) &&
            (!menuOnly || e.menuUrl != null) &&
            (!turkishOnly || e.turkishService) &&
            (!favoritesOnly || repository.favorites.contains(e.id)) &&
            (q.isEmpty ||
                discoverSearchText(
                        '${e.name} ${e.categories.join(' ')} ${e.area} ${e.kind} ${e.subtitle}')
                    .contains(q)))
        .toList();
    if (sort == 'Ada göre A–Z') {
      result.sort((a, b) =>
          discoverSearchText(a.name).compareTo(discoverSearchText(b.name)));
    }
    if (sort == 'Son kontrol tarihi') {
      result.sort((a, b) => b.checkedAt.compareTo(a.checkedAt));
    }
    return result;
  }
}
