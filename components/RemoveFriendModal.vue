<script lang="ts" setup>
  const { $translate } = useNuxtApp();
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
  <UModal aria-describedby="undefined" v-model:open="isModalOpen" title="Remove friend" :close="{class: 'cursor-pointer'}">
    <UButton icon="i-material-symbols:person-remove" class="cursor-pointer" />

    <template #body>
      <div class="flex gap-2">
        <UButton @click="() => {propFunct(principal)}" class="cursor-pointer">
          {{ $translate('profile.friends-sidebar-remove-friend-modal-button') }}
        </UButton>

        <UButton @click="closeModal" class="cursor-pointer">
           {{ $translate('profile.friends-sidebar-remove-friend-modal-close-button') }}
        </UButton>
      </div>
    </template>
  </UModal>
</template>

<style>

</style>