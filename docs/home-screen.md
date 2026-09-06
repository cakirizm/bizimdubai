# Home screen

The Home components live in `lib/home/home_screen.dart`, a part of `lib/main.dart`.
Other destinations and shared brand components retain their previous implementation.

- Header: supplied logo, location sheet and notification sheet.
- Carousel: four locally bundled photos, six-second paging, manual swipe and indicators. Automatic paging pauses during touch, while another route/tab is active, while the app is inactive, and when reduced motion is enabled.
- Categories: three columns, measured text height, existing filtered destinations.
- Recommendations: horizontal cards, working detail routes and session favourites shared with the full recommendation list.
- Navigation: original five destinations, red selected state.

Validation: `flutter test` checks category routing, event details, favourites, automatic/manual carousel paging and full-page overflow at 320, 393 and 430 logical pixels with 130% text size. A local Flutter render was also visually inspected.

## Photo sources

Bundled JPEGs in `assets/images/home/` avoid network dependencies during use.
The photos illustrate categories; they are not claimed to depict the named businesses.
Downloaded from Unsplash image endpoints using `auto=format&fit=crop&q=85` (700 px, or 1400 px for Dubai):

| Asset | Source |
| --- | --- |
| dubai | https://images.unsplash.com/photo-1512453979798-5ea266f8880c |
| restaurant | https://images.unsplash.com/photo-1552566626-52f8b828add9 |
| market | https://images.unsplash.com/photo-1542838132-92c53300491e |
| health | https://images.unsplash.com/photo-1576091160399-112ba8d25d1d |
| beauty | https://images.unsplash.com/photo-1562322140-8baeececf3df |
| homes | https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd |
| education | https://images.unsplash.com/photo-1509062522246-3755977927d7 |
| fitness | https://images.unsplash.com/photo-1534438327276-14e5300c3a48 |
| furniture | https://images.unsplash.com/photo-1555041469-a586c61ea9bc |
| community | https://images.unsplash.com/photo-1521737711867-e3b97375f902 |
