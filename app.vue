<script setup lang="ts">
  import 'assets/css/app.css';

</script>
<template>
  <NuxtPwaManifest />
  <UApp>
    <div class="app">
      <Navigation class="sticky-navigation"/>
      <NuxtLoadingIndicator />
      <NuxtPage />
    </div>
  </UApp>
</template>

<style>
.sticky-navigation {
  position: sticky;
  top: 0;
  z-index: 2000; 
  background-color: white;
}
</style>
