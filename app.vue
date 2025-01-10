<script setup lang="ts">
  import 'assets/css/app.css';

  // Define the public links
  const nav = [
    { label: 'Home', to: '/', icon: 'mdi:book-open-blank-variant-outline' },
    { label: 'About', to: '/about', icon: 'mdi:information-slab-circle-outline' },
  ];

</script>
<template>
  <UApp>
    <div class="app">
      <Navigation :nav="nav" />
      <NuxtLoadingIndicator />
      <NuxtPage />
    </div>
  </UApp>
</template>
