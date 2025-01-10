import { AuthClient } from "@dfinity/auth-client"
export default defineNuxtPlugin(async (nuxtApp) => {
  //console.log('Nuxt app is ready')

  // should be 1 day in nanoseconds
  const maxTimeToLiveMs = 1 * 24 * 60 * 60 * 1000;
  const maxTimeToLiveNs: bigint = BigInt(1 * 24 * 60 * 60 * 1000 * 1000 * 1000);

  let authClient = await AuthClient.create({
    idleOptions: {
        idleTimeout: maxTimeToLiveMs
      }
  });
  // Inject $authClient() in Vue, context, and store.
  nuxtApp.provide('authClient', authClient);
  nuxtApp.provide('maxTimeToLiveNs',maxTimeToLiveNs);
})
