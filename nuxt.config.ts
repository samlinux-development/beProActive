// https://nuxt.com/docs/api/configuration/nuxt-config
let text0 = 'Be ProActive';
let text1 = 'Be ProActive is your go-to platform for staying active and healthy. Track your workouts and join a community of fitness enthusiasts.';
let image = 'https://guxxd-cyaaa-aaaai-aq34a-cai.icp0.io/beActive.png';
let keywords = 'Be ProActive, fitness, workout, push-ups, community, health, active, IcAcademy';
export default defineNuxtConfig({
  ssr: false,

  compatibilityDate: '2024-11-01',
  devtools: {
    enabled: true,

    timeline: {
      enabled: true
    }
  },

  plugins: [
    '~/plugins/ic/ic'
  ],

  runtimeConfig: {
    public: {
      backendCanisterId: process.env.NUXT_PUBLIC_CANISTER_ID_BACKEND,
      network: process.env.NUXT_PUBLIC_DFX_NETWORK
    }
  },

  modules: ['@nuxt/icon', '@nuxt/image', '@nuxt/ui', '@vite-pwa/nuxt'],
  css: ['~/assets/css/main.css'],
  colorMode: {
    preference: 'light'
  },
  image: {
    dir: 'static', 
    staticFilename: '/[name]-[hash][ext]'
  },
  pwa: {
    manifest: {
      name: "be ProActive",
      short_name: "be ProActive",
      description: "This dApp helps you to track your daily workouts and share them with the community. It is a decentralized application (dApp) built on the Internet Computer.",
      start_url: "/",
      display: "fullscreen",
      background_color: "#ffffff",
      theme_color: "#007bff",
      icons: [
        {
          "src": "/beActive.png",
          "sizes": "192x192",
          "type": "image/png"
        },
        {
          "src": "/beActive.png",
          "sizes": "512x512",
          "type": "image/png"
        }
      ]
    },
    workbox: {
      globDirectory: "/Users/rbole/Sites/workout/.output/public",
      globPatterns: ['**/*.{js,css,html,png,svg,ico}'],
      globIgnores: []
    }
  },
  app: {
    head: {
      title: 'Be ProActive',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' },
        { hid: 'keywords', name: 'keywords', content: keywords },
        { hid: 'description', name: 'description', content: text1 },
        { hid: "author", name: 'author', content: "IcAcademy" },

        { hid: 'og:title', property: 'og:title', content: text0 },
        { hid: 'og:description', property: 'og:description', content: text1 },
        { hid: 'og:image', property: 'og:image', content: image },

        { hid: 'twitter:card', property: 'twitter:card', content: 'summary_large_image' },
        { hid: 'twitter:title', property: 'twitter:title', content: text0 },
        { hid: 'twitter:description', property: 'twitter:description', content: text1 },
        { hid: 'twitter:image', property: 'twitter:image', content: image },
        { name: 'mobile-web-app-capable', content: 'yes' },
        { name: 'apple-mobile-web-app-status-bar-style', content: 'black-translucent' }


      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
        { rel: 'manifest', href:'/manifest.webmanifest' },
        { rel: 'apple-touch-icon', href: 'beActive.png' }
      ]
    }
  },
  vite: {
    build: {
      chunkSizeWarningLimit: 1000 // Set your desired limit in KB
    }
  }
})