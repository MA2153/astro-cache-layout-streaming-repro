# Repro: `Astro.cache.set()` in layouts is ignored when streaming

astro@7.4.2, @astrojs/node, Node >= 22.23.4

## Run

    npm install
    ./repro.sh          # set NODE=/path/to/node if your default node is too old

## Setup

- `cache-provider.mjs`: a minimal CDN-style provider with no `onRequest`, so `Cache-Tag` reaches the response.
- `routeRules['/']`: `{ maxAge: 60, tags: ['from-route-rule'] }`
- `src/pages/index.astro`: `Astro.cache.set({ tags: ['from-page'] })`
- `src/layouts/Layout.astro`: `await` a timer, then `Astro.cache.set({ tags: ['from-layout'] })`

## Result

    === streaming ON (default) ===
    cache-tag: from-route-rule, from-page
    cdn-cache-control: max-age=60
    [layout] cache.set from-layout called

    === streaming OFF (experimentalDisableStreaming) ===
    cache-tag: from-route-rule, from-page, from-layout
    cdn-cache-control: max-age=60
    [layout] cache.set from-layout called

The layout's `cache.set()` always runs (see the log line). With streaming on, it runs after
`handleCache` (`astro/dist/core/cache/handler.js`) has already called `applyCacheHeaders` on the
response returned by `next()`, so `from-layout` is silently dropped. No warning is logged.
