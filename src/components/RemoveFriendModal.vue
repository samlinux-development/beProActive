<script lang="ts" setup>
  const { $translate } = useNuxtApp();

  defineProps<{
    friendPrincipal: any;
    removeFriend: any;
    friendAlias: string;
  }>();

  const modalSideBarIsOpen = ref(false);
  const closeModalSidebar = () => {
    modalSideBarIsOpen.value = false;
  }

</script>

<template>
  <UModal 
    v-model:open="modalSideBarIsOpen" 
    :title="$translate('profile.friends-sidebar-remove-friend-modal-title')" 
    :close="false"
    :description="$translate('profile.friends-sidebar-remove-friend-modal-description').replace('<FRIEND_ALIAS>', friendAlias)"
    >
    <UButton class="remove-friend-button" icon="i-lucide:user-x" />

    <template #body>
      <div class="flex gap-2">
        <UButton @click="() => {removeFriend(friendPrincipal)}">
          {{ $translate('profile.friends-sidebar-remove-friend-modal-confirm-button') }}
        </UButton>

        <UButton color="neutral" @click="closeModalSidebar">
          {{ $translate('profile.friends-sidebar-remove-friend-modal-cancel-button') }}
        </UButton>
      </div>
    </template>
  </UModal>
</template>

<style>
</style>