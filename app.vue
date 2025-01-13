<script setup lang="ts">
  import 'assets/css/app.css';
</script>
<template>
  <NuxtPwaManifest />
  <UApp>
    <div class="app">
      <Navigation />
      <NuxtLoadingIndicator />
      <NuxtPage />
    </div>
  </UApp>
</template>
