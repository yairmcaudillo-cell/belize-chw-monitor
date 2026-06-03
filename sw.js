const CACHE_NAME = 'belize-chw-monitor-v1';
const ASSETS = ['/', '/index.html', '/manifest.webmanifest'];
self.addEventListener('install', (event) => {
  event.waitUntil(caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS)));
});
self.addEventListener('fetch', (event) => {
  event.respondWith(fetch(event.request).catch(() => caches.match(event.request).then((r) => r || caches.match('/'))));
});
