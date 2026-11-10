/**
 * CBDVentures service worker.
 * The current app shell is always fetched from the network first, then saved for
 * offline use. Public API GETs may use a saved response when offline; requests
 * carrying a user's bearer token are never put in the shared cache.
 */
const SHELL_CACHE = 'cbdventures-shell-v7';
const DATA_CACHE = 'cbdventures-data-v7';
const APP_VERSION = '20261110-3';

const SHELL_ASSETS = [
  '/',
  '/index.html',
  `/css/app.css?v=${APP_VERSION}`,
  `/js/theme-preload.js?v=${APP_VERSION}`,
  `/js/app.js?v=${APP_VERSION}`,
  `/js/api.js?v=${APP_VERSION}`,
  `/js/ui.js?v=${APP_VERSION}`,
  `/js/map-widget.js?v=${APP_VERSION}`,
  `/js/state.js?v=${APP_VERSION}`,
  `/js/views/discover.js?v=${APP_VERSION}`,
  `/js/views/explore.js?v=${APP_VERSION}`,
  `/js/views/business.js?v=${APP_VERSION}`,
  `/js/views/map.js?v=${APP_VERSION}`,
  `/js/views/assistant.js?v=${APP_VERSION}`,
  `/js/views/events.js?v=${APP_VERSION}`,
  `/js/views/profile.js?v=${APP_VERSION}`,
  `/js/views/owner.js?v=${APP_VERSION}`,
  `/js/views/admin.js?v=${APP_VERSION}`,
  `/js/views/reports.js?v=${APP_VERSION}`,
  `/js/views/backup.js?v=${APP_VERSION}`,
  `/js/views/auth.js?v=${APP_VERSION}`,
  `/js/views/welcome.js?v=${APP_VERSION}`,
  '/images/logo-dark.svg',
  '/images/hero.svg',
  `/images/hero-welcome.svg?v=${APP_VERSION}`,
  '/images/pretoria-cbd-welcome.jpg?v=20261110-3',
  '/images/favicon.svg',
  '/images/icons/app-icon.svg',
  '/manifest.webmanifest'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(SHELL_CACHE)
      .then((cache) => cache.addAll(SHELL_ASSETS))
      .then(() => self.skipWaiting())
      .catch(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys
        .filter((key) => key.startsWith('cbdventures-') && key !== SHELL_CACHE && key !== DATA_CACHE)
        .map((key) => caches.delete(key))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET') return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;

  // Connection probes must always reach the network, never the cache.
  if (url.searchParams.has('__probe')) return;

  if (url.pathname.startsWith('/api/')) {
    if (request.headers.has('Authorization')) {
      event.respondWith(fetch(request, { cache: 'no-store' }));
      return;
    }

    event.respondWith(
      fetch(request, { cache: 'reload' })
        .then((response) => {
          if (response.ok) {
            const clone = response.clone();
            caches.open(DATA_CACHE).then((cache) => cache.put(request, clone));
          }
          return response;
        })
        .catch(() => caches.match(request).then((cached) => cached
          || new Response(JSON.stringify({
            message: 'You are offline and this listing has not been saved yet.'
          }), { status: 503, headers: { 'Content-Type': 'application/json' } })))
    );
    return;
  }

  const isAppShell = url.pathname === '/' || url.pathname === '/index.html'
    || url.pathname.startsWith('/css/')
    || url.pathname.startsWith('/js/')
    || url.pathname.startsWith('/images/')
    || url.pathname.startsWith('/icons/')
    || url.pathname === '/manifest.webmanifest'
    || url.pathname === '/favicon.ico';
  if (!isAppShell) return;

  event.respondWith(
    fetch(request, { cache: 'reload' })
      .then((response) => {
        if (response.ok) {
          const clone = response.clone();
          caches.open(SHELL_CACHE).then((cache) => cache.put(request, clone));
        }
        return response;
      })
      .catch(async () => {
        const cached = await caches.match(request);
        if (cached) return cached;
        if (request.mode === 'navigate') {
          return await caches.match('/index.html') || new Response('CBDVentures is offline.', { status: 503 });
        }
        return new Response('This resource is unavailable offline.', { status: 503 });
      })
  );
});
