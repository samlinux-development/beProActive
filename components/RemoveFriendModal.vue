<script lang="ts" setup>
  // import { ref } from 'vue';

  const isModalOpen = ref(false); 

  const props = defineProps<{
    principal: any;
    propFunct: any;
  }>();

  function closeModal() {
    isModalOpen.value = false;
  }
</script>

<template>
  <UModal v-model:open="isModalOpen" title="Test!">
    <UButton icon="i-material-symbols:person-remove" class="cursor-pointer" />

    <template #body>
      <div class="flex gap-2">
        <UButton @click="() => {propFunct(principal)}">
          Remove friend
        </UButton>

        <UButton @click="closeModal">
          Close
        </UButton>
      </div>
    </template>
  </UModal>
</template>

<style>

</style>