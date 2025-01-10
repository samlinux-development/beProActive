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

  modules: ['@nuxt/icon', '@nuxt/image','@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  image: {
    dir: 'static', 
    staticFilename: '/[name]-[hash][ext]'
  },
  app: {
    head: {
      title: 'Be ProActive - IcAcademy ',
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

      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  }
})