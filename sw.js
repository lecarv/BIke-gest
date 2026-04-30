// BikeGest Service Worker
// Versão do cache — altere para forçar atualização
const CACHE_NAME = 'bikegest-v1.0.0';

// Arquivos a serem cacheados no install
const ASSETS_TO_CACHE = [
  './',
  './index.html',
  './manifest.json',
  './icons/icon-192.png',
  './icons/icon-512.png',
  // Fontes do Google (serão cacheadas dinamicamente)
];

// ── INSTALL: pré-cache dos arquivos principais ──
self.addEventListener('install', event => {
  console.log('[SW] Install');
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(ASSETS_TO_CACHE).catch(err => {
        console.warn('[SW] Falha ao cachear alguns assets:', err);
      });
    })
  );
  self.skipWaiting();
});

// ── ACTIVATE: remove caches antigos ──
self.addEventListener('activate', event => {
  console.log('[SW] Activate');
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys
          .filter(key => key !== CACHE_NAME)
          .map(key => {
            console.log('[SW] Deletando cache antigo:', key);
            return caches.delete(key);
          })
      );
    })
  );
  self.clients.claim();
});

// ── FETCH: estratégia Cache First com fallback para rede ──
self.addEventListener('fetch', event => {
  const { request } = event;
  const url = new URL(request.url);

  // Ignora extensões do Chrome e requisições não-GET
  if (request.method !== 'GET') return;
  if (url.protocol === 'chrome-extension:') return;

  // Para fontes do Google: Cache First
  if (url.hostname.includes('fonts.googleapis.com') ||
      url.hostname.includes('fonts.gstatic.com')) {
    event.respondWith(
      caches.open(CACHE_NAME).then(cache => {
        return cache.match(request).then(cached => {
          if (cached) return cached;
          return fetch(request).then(response => {
            if (response && response.status === 200) {
              cache.put(request, response.clone());
            }
            return response;
          }).catch(() => cached);
        });
      })
    );
    return;
  }

  // Para assets locais: Cache First, fallback para rede
  event.respondWith(
    caches.match(request).then(cached => {
      if (cached) return cached;

      return fetch(request).then(response => {
        // Cacheia respostas válidas de arquivos locais
        if (response && response.status === 200 && response.type !== 'opaque') {
          const responseClone = response.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(request, responseClone);
          });
        }
        return response;
      }).catch(() => {
        // Offline e não tem cache: retorna a página principal
        if (request.destination === 'document') {
          return caches.match('./index.html');
        }
      });
    })
  );
});

// ── SYNC em background (quando voltar online) ──
self.addEventListener('sync', event => {
  console.log('[SW] Background sync:', event.tag);
});

// ── PUSH notifications (estrutura para futuro) ──
self.addEventListener('push', event => {
  if (!event.data) return;
  const data = event.data.json();
  self.registration.showNotification(data.title || 'BikeGest', {
    body: data.body || '',
    icon: './icons/icon-192.png',
    badge: './icons/icon-96.png',
  });
});
