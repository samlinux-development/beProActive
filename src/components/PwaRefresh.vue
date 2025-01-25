<script setup>
const { $pwa,  $translate } = useNuxtApp();
</script>

<template>
  <div v-show="$pwa.needRefresh" class="text-red-500">
    <button @click="$pwa.updateServiceWorker()" icon="i-lucide-refresh-ccw" class="bg-red-500 text-white p-2 rounded mb-3">
      <span> {{ $translate('pwa.refresh-button') }} </span>
    </button>
  </div>
</template>