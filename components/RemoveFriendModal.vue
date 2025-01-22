<script lang="ts" setup>
  const { $translate } = useNuxtApp();

  defineProps<{
    friendPrincipal: any;
    removeFriend: any;
    friendAlias: string;
  }>();
</script>

<template>
  <UModal :title="$translate('profile.friends-sidebar-remove-friend-modal-title')" :close="{class: 'text-[20px]'}">
    <UButton class="remove-friend-button" icon="i-material-symbols:person-remove" />

    <template #body>
      <div class="mb-5 -mt-5">
        {{ $translate('profile.friends-sidebar-remove-friend-modal-description').replace('<FRIEND_ALIAS>', friendAlias) }}
      </div>

      <div class="flex gap-2">
        <UButton @click="() => {removeFriend(friendPrincipal)}">
          {{ $translate('profile.friends-sidebar-remove-friend-modal-confirm-button') }}
        </UButton>
      </div>
    </template>
  </UModal>
</template>

<style>

</style>