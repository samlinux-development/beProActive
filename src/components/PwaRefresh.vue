<script setup>
const { $pwa,  $translate } = useNuxtApp();
</script>

<template>
  <div v-show="$pwa.needRefresh" class="text-red-500 mt-2">
    <button @click="$pwa.updateServiceWorker()" icon="i-lucide-refresh-ccw" class="bg-red-500 text-white p-2 rounded mb-3 hover:bg-red-600">
      <div class="flex flex-row items-center gap-2">
      <Icon name="i-lucide-refresh-ccw" class="icon spinning" />
      <span> {{ $translate('pwa.refresh-button') }} </span>
      </div>
    </button>
  </div>
</template>

<style scoped>

  .spinning {
    animation: spin 2s linear infinite;
  }

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }
</style>
