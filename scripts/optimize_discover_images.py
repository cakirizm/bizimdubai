from pathlib import Path

path = Path('lib/discover/discover_screen.dart')
text = path.read_text(encoding='utf-8')
original = text

old_ctor = """  const DiscoverImage(\n      {super.key, required this.photo, this.fit = BoxFit.cover});\n  final DiscoverPhoto photo;\n  final BoxFit fit;"""
new_ctor = """  const DiscoverImage(\n      {super.key,\n      required this.photo,\n      this.fit = BoxFit.cover,\n      this.fallbackAsset,\n      this.maxDecodeWidth = 1200});\n  final DiscoverPhoto photo;\n  final BoxFit fit;\n  final String? fallbackAsset;\n  final int maxDecodeWidth;"""

# apply_restaurant_grouping.py may already have added fallbackAsset.
old_grouped_ctor = """  const DiscoverImage(\n      {super.key, required this.photo, this.fit = BoxFit.cover, this.fallbackAsset});\n  final DiscoverPhoto photo;\n  final BoxFit fit;\n  final String? fallbackAsset;"""

if old_ctor in text:
    text = text.replace(old_ctor, new_ctor, 1)
elif old_grouped_ctor in text:
    text = text.replace(old_grouped_ctor, new_ctor, 1)

old_fallback = """    Widget fallback() => Container(\n        color: const Color(0xFFF3F0F1),\n        alignment: Alignment.center,\n        child: const Column(mainAxisSize: MainAxisSize.min, children: [\n          Icon(Icons.image_not_supported_outlined, color: Colors.grey),\n          SizedBox(height: 6),\n          Text('Fotoğraf yüklenemedi',\n              style: TextStyle(color: Colors.grey, fontSize: 12))\n        ]));"""
new_fallback = """    Widget fallback() => fallbackAsset != null\n        ? Image.asset(\n            fallbackAsset!,\n            fit: fit,\n            width: double.infinity,\n            height: double.infinity,\n            cacheWidth: 900,\n            filterQuality: FilterQuality.medium)\n        : Container(\n            color: const Color(0xFFF3F0F1),\n            alignment: Alignment.center,\n            child: const Column(mainAxisSize: MainAxisSize.min, children: [\n              Icon(Icons.image_not_supported_outlined, color: Colors.grey),\n              SizedBox(height: 6),\n              Text('Fotoğraf yüklenemedi',\n                  style: TextStyle(color: Colors.grey, fontSize: 12))\n            ]));"""
if old_fallback in text:
    text = text.replace(old_fallback, new_fallback, 1)

# If the grouping patch already installed a fallbackAsset implementation, upgrade it.
old_grouped_fallback = """    Widget fallback() => fallbackAsset != null\n        ? Image.asset(fallbackAsset!, fit: fit, width: double.infinity, height: double.infinity)\n        : Container(\n            color: const Color(0xFFF3F0F1),\n            alignment: Alignment.center,\n            child: const Column(mainAxisSize: MainAxisSize.min, children: [\n              Icon(Icons.image_not_supported_outlined, color: Colors.grey),\n              SizedBox(height: 6),\n              Text('Fotoğraf yüklenemedi',\n                  style: TextStyle(color: Colors.grey, fontSize: 12))\n            ]));"""
if old_grouped_fallback in text:
    text = text.replace(old_grouped_fallback, new_fallback, 1)

old_asset = """      return Image.asset(photo.asset!,\n          fit: fit,\n          width: double.infinity,\n          height: double.infinity,\n          semanticLabel: photo.caption,\n          errorBuilder: (_, __, ___) => fallback());"""
new_asset = """      return LayoutBuilder(builder: (context, constraints) {\n        final dpr = MediaQuery.devicePixelRatioOf(context);\n        final logicalWidth = constraints.hasBoundedWidth\n            ? constraints.maxWidth\n            : MediaQuery.sizeOf(context).width;\n        final decodeWidth =\n            (logicalWidth * dpr).round().clamp(320, maxDecodeWidth).toInt();\n        return Image.asset(photo.asset!,\n            fit: fit,\n            width: double.infinity,\n            height: double.infinity,\n            cacheWidth: decodeWidth,\n            filterQuality: FilterQuality.medium,\n            semanticLabel: photo.caption,\n            errorBuilder: (_, __, ___) => fallback());\n      });"""
if old_asset in text:
    text = text.replace(old_asset, new_asset, 1)

old_network = """    return Image.network(photo.url,\n        fit: fit,\n        width: double.infinity,\n        height: double.infinity,\n        semanticLabel: photo.caption,\n        errorBuilder: (_, __, ___) => fallback(),\n        loadingBuilder: (_, child, loading) => loading == null\n            ? child\n            : Container(\n                color: const Color(0xFFF3F0F1),\n                alignment: Alignment.center,\n                child: const CircularProgressIndicator(strokeWidth: 2)));"""
new_network = """    return LayoutBuilder(builder: (context, constraints) {\n      final dpr = MediaQuery.devicePixelRatioOf(context);\n      final logicalWidth = constraints.hasBoundedWidth\n          ? constraints.maxWidth\n          : MediaQuery.sizeOf(context).width;\n      final decodeWidth =\n          (logicalWidth * dpr).round().clamp(320, maxDecodeWidth).toInt();\n      return Image.network(photo.url,\n          fit: fit,\n          width: double.infinity,\n          height: double.infinity,\n          cacheWidth: decodeWidth,\n          filterQuality: FilterQuality.medium,\n          gaplessPlayback: true,\n          semanticLabel: photo.caption,\n          errorBuilder: (_, __, ___) => fallback(),\n          loadingBuilder: (_, child, loading) => loading == null\n              ? child\n              : const ColoredBox(color: Color(0xFFF3F0F1)));\n    });"""
if old_network in text:
    text = text.replace(old_network, new_network, 1)

if text == original:
    print('No image optimization changes needed')
else:
    path.write_text(text, encoding='utf-8')
    print('Discover image decode/network rendering optimized')
