<script setup lang="ts">

import { useNuxtApp, useRouter, useRuntimeConfig } from '#app';

// Define public links
const nav = [
  { label: 'Home', to: '/', icon: 'mdi:book-open-blank-variant-outline' },
  { label: 'About', to: '/about', icon: 'mdi:information-slab-circle-outline' },
];

const { $getActor } = useNuxtApp();
let { $authClient } = useNuxtApp() as any;
const { $maxTimeToLiveNs } = useNuxtApp();

const config = useRuntimeConfig();
const isLoggedIn = ref(false);

const router = useRouter();

let iicanisterId = config.public.network === 'local'
  ? `http://rdmx6-jaaaa-aaaaa-aaadq-cai.localhost:4943`
  : 'https://identity.internetcomputer.org';

onMounted(async () => {
  // Check if the user is already logged in
  await checkLoginStatus();
});

/**
 * Login function
 * Initializes the authClient to enable authenticated calls and handles the user login process.
 */
const login = async () => {
  try {
    await $authClient.login({
      // 7 days in nanoseconds, not sure if this is working ???
      maxTimeToLive: $maxTimeToLiveNs,
      identityProvider: iicanisterId,

      onSuccess: async () => {
        const actor = await $getActor({},true);

        //const identity = $authClient.getIdentity();
        //console.log('PI: ',identity.getPrincipal().toText());
        isLoggedIn.value = true;

        // check or create user profile // we  must not wait
        actor.createUserProfile();

        // Redirect to the profile page after login
        router.push({ path: '/profile' });
      },
    });
  } catch (error) {
    console.error("Login failed:", error);
  }
};

/**
 * Check login status
 */
const checkLoginStatus = async () => {
  isLoggedIn.value = await $authClient.isAuthenticated();
};

/**
 * Logout function
 * Logs the user out and resets the principalId and isLoggedIn values.
 * Also set the actor to null to get a new anonymous actor
 */ 

const logout = async () => {
  await $authClient.logout();

  isLoggedIn.value = false;
  await $getActor({},true);
  router.push('/');
};

</script>

<template>
  <nav class="navigation sticky-top">
    <ol>
      <div class="left-nav">
        <li v-for="(item, index) in nav" :key="index">
          <router-link :to="item.to" class="nav-link">
            <Icon :name="item.icon" class="icon" />
          </router-link>
        </li>
      </div>

      <div class="center-nav add-button" v-if="isLoggedIn">
        <li v-if="isLoggedIn" class="nav-link">
          <router-link to="/add" class="nav-link">
            <Icon name="mdi:plus-box" class="icon" />
          </router-link> 
        </li>
      </div>

      <div class="right-nav" >
        <li class="nav-link" v-if="isLoggedIn">
          <router-link to="/profile" class="nav-link">
            <Icon name="mdi:account" class="icon" />
          </router-link>
        </li>

        <li class="nav-link" v-if="isLoggedIn">
          <button @click="logout" class="nav-link">
            <Icon name="mdi:logout" class="icon" />
          </button>
        </li>
        <li v-else class="nav-link">
          <button @click="login" class="nav-link">
            <Icon name="mdi:login-variant" class="icon"/>
          </button>
        </li>  
      </div>

    </ol>
  </nav>
</template>

<style scoped>
  
  .icon {
    color: #52bd55;
    font-size: 2rem;
  }

  .navigation {
    background-color: #f8f9fa;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    z-index: 1000;
  }

  .sticky-top {
    position: sticky;
    top: 0;
  }

  ol {
    display: flex;
    justify-content: space-between;
    align-items: center;
    list-style-type: none;
    padding: 0;
    margin: 0;
    width: 100%;
  }

  .left-nav,
  .center-nav,
  .right-nav {
    display: flex;
    align-items: center;
  }

  .right-nav .nav-link {
    height: 48px;
    width: 48px;
  }

  .right-nav .nav-link button.nav-link {
    font-size: 32px;
    padding: 0px;
  }

  .left-nav {
    flex: 1;
    gap: 0.75rem;
  }

  .center-nav {
    flex: 1;
    justify-content: center;
  }

  .right-nav {
    flex: 1;
    justify-content: flex-end;
    gap: 0.25rem;
  }

  .nav-link {
    text-decoration: none;
    color: #007bff;
    padding: 0.5rem;
    border-radius: 4px;
    transition: background-color 0.3s, color 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
    background: none;
    border: none;
    cursor: pointer;
  }

  .nav-link:hover {
    background-color: #e2e6ea;
    color: #0056b3;
  }

  .add-button .nav-link {
    padding: 0rem; 
  }

  .add-button .icon {
    font-size: 5rem; 
  }

  /* Media query for smaller screens */
  @media (max-width: 600px) {
    ol {
      flex-direction: row;
      justify-content: center;
      gap: 1rem;
    }

    .nav-link {
      width: 100%;
      justify-content: center;
      padding: 3px;
    }
}

</style>