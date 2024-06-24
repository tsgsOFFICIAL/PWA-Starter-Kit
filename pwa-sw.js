const version = '1.0.0';
const cacheName = 'cache-name';
const assets = [
    // Add your assets here
];

// Cache all the files to make a PWA
self.addEventListener('install', installEvent => {
    installEvent.waitUntil(
        caches.open(cacheName).then(cache => {
            return Promise.all(
                assets.map(async url => {
                    try {
                        const response = await fetch(url);

                        if (!response.ok) {
                            throw new Error(`Failed to fetch "${url}", status: ${response.status}`);
                        }

                        return await cache.put(url, response);
                    } catch (error) {
                        return console.error(`Failed to cache "${url}": ${error.message}`);
                    }
                })
            );
        }).catch(error => console.error('Cache open failed:', error))
    );
});

// Implement network-first strategy
self.addEventListener("fetch", fetchEvent => {
    fetchEvent.respondWith(
        fetch(fetchEvent.request).then(networkResponse => {
            // If we got a response from the network, update the cache
            if (networkResponse && networkResponse.status === 200) {
                const responseClone = networkResponse.clone();
                caches.open(cacheName).then(cache => {
                    try {
                        cache.put(fetchEvent.request, responseClone);
                    } catch (error) { }
                });
            }
            return networkResponse;
        }).catch(async () => {
            // If the network is unavailable, use the cache
            const cacheResponse = await caches.match(fetchEvent.request);
            return cacheResponse || caches.match('/error/404');
        })
    );
});