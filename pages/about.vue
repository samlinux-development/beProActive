<script setup lang="ts">
const { $translate } = useNuxtApp();

</script>
<template>
  <h1>{{ $translate ('about.title') }}</h1>
  <img class="image" src="/beActive.webp" alt="Be ProActive"/>
  <div>{{ $translate ('about.info') }}</div>
  <div v-html="$translate ('about.stayTuned')"></div>
</template>

<style scoped>
  .image {
    width: 50%;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
</style>