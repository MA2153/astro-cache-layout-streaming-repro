import { defineConfig } from 'astro/config';
import node from '@astrojs/node';

export default defineConfig({
  output: 'server',
  adapter: node({
    mode: 'standalone',
    // Build with NO_STREAM=1 for the control case (buffered rendering).
    experimentalDisableStreaming: !!process.env.NO_STREAM,
  }),
  cache: {
    provider: { entrypoint: new URL('./cache-provider.mjs', import.meta.url) },
  },
  routeRules: {
    '/': { maxAge: 60, tags: ['from-route-rule'] },
  },
});
