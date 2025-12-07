import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#FF7400',
          50: '#FFE8D6',
          100: '#FFD9BE',
          200: '#FFBB8E',
          300: '#FF9D5E',
          400: '#FF7F2E',
          500: '#FF7400',
          600: '#C75A00',
          700: '#8F4100',
          800: '#572700',
          900: '#1F0E00',
        },
      },
    },
  },
  plugins: [],
}
export default config
