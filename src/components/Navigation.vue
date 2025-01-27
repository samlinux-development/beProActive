<script setup lang="ts">

import { useNuxtApp, useRouter, useRuntimeConfig } from '#app';

const nav = [
  { label: 'Home', to: '/', icon: 'mdi:book-open-blank-variant-outline' },
  { label: 'About', to: '/about', icon: 'mdi:information-slab-circle-outline' },
  {
      label: 'GitHub',
      icon: 'i-simple-icons-github',
      to: 'https://github.com/samlinux-development/beProActive',
      target: '_blank'
    }
  ];

const { $getActor } = useNuxtApp();
let { $authClient } = useNuxtApp() as any;
const { $maxTimeToLiveNs, $translate } = useNuxtApp();
const isLoading = ref(false);

const config = useRuntimeConfig();
const isLoggedIn = ref(false);
const modalSideBarIsOpen = ref(false);

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
    isLoading.value = true;
    await $authClient.login({
      // 7 days in nanoseconds, not sure if this is working ???
      maxTimeToLive: $maxTimeToLiveNs,
      identityProvider: iicanisterId,

      onSuccess: async () => {
        const actor = await $getActor({},true);
        isLoggedIn.value = true;

        // check or create user profile
        await actor.createUserProfile();
        isLoading.value = false;
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
    <div v-if="isLoading"> <Spinner /> </div>
    <div v-else>
      <nav class="navigation sticky-top">
        <ol>
          <div class="left-nav">
            <li>
              <router-link to="/" class="nav-link" @click="modalSideBarIsOpen = true">
                <Icon name="i-lucide-menu" class="icon" />
              </router-link>
            </li>
            <USlideover 
              :title="$translate('navigation.title')"
              :close="{
                color: 'primary',
                variant: 'outline',
                class: 'rounded-full'
              }"
              v-model:open="modalSideBarIsOpen"
              :description="$translate('navigation.desc')" >
            
              <template #body >
                <div class="sidebar-nav" >
                  <div v-for="(item, index) in nav" :key="index">

                    <router-link  v-if="!item.target" :to="item.to" @click="modalSideBarIsOpen = false" class="nav-link">
                      <div class="ml-6 flex flex-row items-center gap-2">
                        <div>
                          <Icon :name="item.icon" class="icon" />
                        </div>
                        <div>
                          {{ item.label }}
                        </div>
                      </div>
                    </router-link>

                    <a v-else target="_blank" :href="item.to" @click="modalSideBarIsOpen = false" class="nav-link">
                      <div class="ml-6 flex flex-row items-center gap-2">
                        <div>
                          <Icon :name="item.icon" class="icon" />
                        </div>
                        <div>
                          {{ item.label }}
                        </div>
                      </div>
                    </a>
                  </div>
                </div>
              </template>

            </USlideover>
          </div>

          <div class="center-nav add-button" v-if="isLoggedIn">
            <li v-if="isLoggedIn" class="nav-link">
              <router-link to="/add" class="nav-link">
                <Icon name="i-lucide-square-plus" class="icon" />
              </router-link> 
            </li>
          </div>

          <div class="right-nav" >
            <li class="nav-link" v-if="isLoggedIn">
              <router-link to="/profile" class="nav-link">
                <Icon name="i-lucide-user" class="icon" />
              </router-link>
            </li>

            <li class="nav-link" v-if="isLoggedIn">
              <button @click="logout" class="nav-link">
                <Icon name="i-lucide-log-out" class="icon" />
              </button>
            </li>
            <li v-else class="nav-link">
              <button @click="login" class="nav-link">
                <Icon name="i-lucide-log-in" class="icon"/>
              </button>
            </li>  
          </div>

        </ol>
      </nav>
      <div class="text-center">
        <PwaRefresh />
      </div>
    </div>
</template>

<style scoped>
  .icon {
    color: #52bd55;
    font-size: 2rem;
  }

  .navigation {
    background-color: #f8f9fa;
    padding-left: 0.5rem;
    padding-right: 0.5rem;
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

  .sidebar-nav {
    display: flex;
    flex-direction: column;  
    gap: 0.75rem;
    
  }
  .left-nav {
    display: flex;
    justify-content: left;
  }
  .center-nav,
  .right-nav {
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .right-nav .nav-link {
    height: 38px;
    width: 38px;
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
    gap: 0.75rem;
  }

  .nav-link {
    text-decoration: none;
    color: gray;
    padding: 0.2rem;
    border-radius: 4px;
    transition: background-color 0.3s, color 0.3s;
    display: flex;
    align-items: center;
    background: none;
    border: none;
    cursor: pointer;
  }

  .nav-link:hover {
    background-color: #e2e6ea;
    color: gray;
  }

  .add-button .icon {
    font-size: 4rem; 
  }

  /* Media query for smaller screens */
  @media (max-width: 600px) {
    ol {
      flex-direction: row;
      justify-content: center;
      gap: 1rem;
    }

    .nav-right {
      width: 100%;
      justify-content: center;
      padding: 3px;
    }
}

</style>