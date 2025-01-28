<script setup lang="ts">
const { $translate } = useNuxtApp() as any;
</script>

<template>
  <div class="please-login">
    <Icon name="i-lucide-shield-alert" class="icon" />
    <h2>{{ $translate('auth.pleaseLoginTitle') }}</h2>
    <p>{{ $translate('auth.pleaseLoginMessage') }}</p>
  </div>
</template>

<style scoped>
  .please-login {
    text-align: center;
    padding: 2rem;
    background-color: #f8f9fa;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .please-login h2 {
    margin-bottom: 1rem;
    color: #ed3838;
  }

  .please-login p {
    color: #333;
  }

  .icon {
    color: #ed3838;
    font-size: 4rem;
  }
</style>