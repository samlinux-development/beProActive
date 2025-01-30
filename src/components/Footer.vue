<script lang="ts" setup>
const { $translate } = useNuxtApp();

const config = useRuntimeConfig();
const frontendBuild = config.public.frontendBuild;
</script>

<template>
  <footer class="footer">
    <div class="container">
      <div class="footer-content">
        {{ $translate('about.frontendBuild') }}: {{ frontendBuild }} {{ $translate('about.copyright') }}  {{ new Date().getFullYear() }}
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  padding: 20px 0;
  background-color: #f8f8f8;
  text-align: center;
  border-top: 1px solid #e7e7e7;
  font-size: small;
}

.container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}


.footer-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-style: italic;
}

@media (max-width: 600px) {
  .footer {
    font-size: 1rem;
  }
}
</style>