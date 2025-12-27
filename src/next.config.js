/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**',
      },
    ],
  },
  allowedDevOrigins: [
    'https://*.replit.dev',
    'https://*.repl.co',
    'https://*.replit.app',
  ],
}

module.exports = nextConfig
