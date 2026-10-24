// Minimal CDN-style provider (no onRequest), so Cache-Tag reaches the client.
export default function provider() {
  return {
    name: 'repro-cdn',
    async invalidate() {},
  };
}
