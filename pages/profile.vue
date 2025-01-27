<script lang="ts" setup>
  import { ref, useTemplateRef } from 'vue'
  import { useNuxtApp } from '#app'
  
  import { type Principal } from '@dfinity/principal';
  import { isAuthenticated } from '../src/utils/helper.js';
  import type { FormSubmitEvent, TableColumn } from '@nuxt/ui';

  import RemoveFriendModal from '~/src/components/RemoveFriendModal.vue';
  import OwnWorkouts from '~/src/components/OwnWorkouts.vue';

  interface User {
    alias: string, principal: any, totalWorkouts?: bigint
  }

  interface SelectFriendItem {
    label: string, value: any
  }

  const UButton = resolveComponent('UButton');
  const { $translate, $getActor, $authClient } = useNuxtApp() as any;
  const isLoading = ref(true);
  const isAuth = ref(false);
  const isCheckingAuth = ref<boolean>(true);
  const user = ref<string>('');
  const friends = ref<[]>([]);
  const totalWorkouts = ref<bigint>(0n);
  const points = ref<bigint>(0n);
  const isEditProfileFormDisabled = ref<boolean>(false);
  const isFriendsSidebarLoading = ref<boolean>(false);
  const friendsSidebarSelectFriendItems = ref<SelectFriendItem[]>([]);
  const allUsers = ref<[]>([]);

  const userDetailFormState = reactive({
    alias: '', size: 0
  });

  const userFriendsFormState = reactive({
    selectedUser: {label: '', value: ''}
  });

  const userFriendsTableData = ref<User[]>([]);

  onMounted(async () => {
    try {
      isAuth.value = await isAuthenticated();
      if (!isAuth.value) {
        isLoading.value = false;
        return;
      }
      
      const actor = await $getActor({}, true);
      const userProfile = await actor.getUserProfile();
      
      if(userProfile) {
        user.value = userProfile.alias;
        friends.value = userProfile.friends;
        totalWorkouts.value = userProfile.totalWorkouts;

        userDetailFormState.alias = user.value;
        userDetailFormState.size = userProfile.size;
        
        points.value = userProfile.points;
      }

      getUserFriends();

      isLoading.value = false;

    } catch (error) {
      console.error("Error fetching workouts per principal:", error);
    }
    finally {
      isCheckingAuth.value = false;
    }
  });

  async function onSubmitEditUser(event: FormSubmitEvent<{alias: string}>) {
    isEditProfileFormDisabled.value = true;
    const actor = await $getActor({}, true);
    
    if(isNaN(userDetailFormState.size)) {
      userDetailFormState.size = 0;
    }

    const profile = {
      alias: event.data.alias.trim(),
      size: userDetailFormState.size
    };
   
    const res = await actor.updateProfile(profile);    
    if (res) {
      const userProfile = await actor.getUserProfile();
      
      user.value = userProfile.alias;
      userDetailFormState.alias = user.value;
      userDetailFormState.size = userProfile.size;
    }
   
    isEditProfileFormDisabled.value = false;
  }

  // load select friend items
  async function loadUserFriendsSidebar() {
    isFriendsSidebarLoading.value = true;

    const actor = await $getActor({}, true);
    const identity = await $authClient.getIdentity();
    allUsers.value = await actor.getAllUsers();
    
    const userProfile = await actor.getUserProfile();
    friends.value = userProfile.friends;

    userFriendsFormState.selectedUser = {label: '', value: ''};

    const nonFriendUsers: SelectFriendItem[] = allUsers.value
      .filter((user: User) => user.principal.toText() !== identity.getPrincipal().toText())
      .filter((user: User) => !friends.value.some((friend: User) => friend.principal.toText() === user.principal.toText()))
      .map((user: User) => ({
        label: user.alias + ' (' + user.totalWorkouts + ' wo)',
        value: user.principal.toText()
      }));

    // sort the nonFriendUsers by alias
    nonFriendUsers.sort((a, b) => a.label.localeCompare(b.label));

    friendsSidebarSelectFriendItems.value = nonFriendUsers;    
    isFriendsSidebarLoading.value = false;
  }

  /**
   * gets the user friends data
   */
  async function getUserFriends() {
    const actor = await $getActor({}, true);
    const userProfile = await actor.getUserProfile();

    friends.value = userProfile.friends;
    
    let userFriends: User[] = [];

    friends.value.forEach(function (friendData: User) {
      const friend = {
        alias: friendData.alias,
        principal: friendData.principal,
        totalWorkouts: friendData.totalWorkouts
      }

      userFriends.push(friend);
    })

    userFriendsTableData.value = userFriends;
  }

  /**
   * adds a friend
   */
  async function addFriend() {
    if (userFriendsFormState.selectedUser) {
     
      isFriendsSidebarLoading.value = true;
      const actor = await $getActor({}, true);
      await actor.addFriend(userFriendsFormState.selectedUser);

      userFriendsFormState.selectedUser = {label: '', value: ''};

      loadUserFriendsSidebar();
      getUserFriends();

      isFriendsSidebarLoading.value = false;
    }
  }

  /**
   * removes a friend 
   */
  async function removeFriend(principal: Principal) {
    isFriendsSidebarLoading.value = true;

    const actor = await $getActor({}, true);
    await actor.removeFriend(principal.toText());
    
    loadUserFriendsSidebar();
    getUserFriends();
    isFriendsSidebarLoading.value = false;
  }

  const userFriendsTableColumn: TableColumn<User>[] = [
    {
      accessorKey: 'alias',
      header: () => $translate('profile.friends-sidebar-friend-list-header-alias'),
    },
    {
      accessorKey: 'totalWorkouts',
      header: () => $translate('profile.friends-sidebar-friend-list-header-workouts'),
    },
    {
      id: 'removeFriend',
      cell: ({ row }) => {
        return h(RemoveFriendModal, {
          friendPrincipal: row.original.principal,
          removeFriend: removeFriend,
          friendAlias: row.original.alias
        })
      }
    }
  ];

  const itemTabs = ref([
    {
      label: 'Feed',
      icon: 'i-lucide-rss',
      slot: 'feed'
    },
    {
      label: 'Workouts',
      icon: 'i-lucide-dumbbell',
      slot: 'ownWorkout'
    }
  ]);

const fiendsSideBarIsOpen = ref(false);
const activeTab = ref('0');
const closeFriendsSidebar = () => {
  fiendsSideBarIsOpen.value = false;
  if(activeTab.value === '0') {
    // rerender tab 0
    //console.log('rerender Feed');
  } else {
    //show feed tab
    setTimeout(() => {
      activeTab.value = '0';
    }, 100);
  }
}

const profileSideBarIsOpen = ref(false);
const closeProfileSidebar = () => {
  profileSideBarIsOpen.value = false;
}

// remove focus from input field
const firstInput = useTemplateRef('firstInput')
watch(profileSideBarIsOpen, () => {
  setTimeout(() => {
    firstInput.value?.inputRef?.blur();
  }, 100);
});

</script>

<template>
  <div v-if="isCheckingAuth">
    <Spinner />
  </div>
  <div v-else>
      <div v-if="!isAuth">
        <PleaseLogin />
      </div>

      <div v-else-if="isAuth">
        <div v-if="isLoading"> <Spinner /> </div>

        <div v-else-if="!isLoading">
          <div class="mb-5">
            <div class="flex items-center gap-2">
              <UAvatar 
                :alt="user.toUpperCase()[0]"
                size="3xl"
              />
              
              <div class="flex flex-col text-sm">
                <div>
                  {{ user }}
                </div>

                <div>
                  <span v-if="totalWorkouts != 1n">
                    {{ totalWorkouts }} {{ $translate('profile.total-workouts') }}
                  </span>

                  <span v-else>
                    {{ totalWorkouts }} {{ $translate('profile.total-workout') }}
                  </span>
                  <span>, {{ points }} {{ $translate('profile.total-points') }}</span>
                </div>
              </div>
            </div>

            <div class="mt-4">
              <div class="flex justify-between items-center">
                <!-- add/remove friends-->
                <USlideover 
                  :title="$translate('profile.friends-sidebar-title')"
                  :close="false"
                  v-model:open="fiendsSideBarIsOpen"
                  :description="$translate('profile.friends-sidebar-description')">
                  <UButton variant="outline" class="cursor-pointer font-bold" @click="loadUserFriendsSidebar">
                    {{ $translate('profile.your-friends') }} {{ friends.length }}
                  </UButton>

                  <template #body>
                    <div v-if="isFriendsSidebarLoading">
                      <Spinner />
                    </div>

                    <div v-else-if="!isFriendsSidebarLoading">
                      <div class="mb-2">
                        <UForm class="flex gap-2 items-end flex-wrap" :state="userFriendsFormState" @submit="addFriend">
                          <UFormField :label="$translate('profile.friends-sidebar-add-friend')">
                            <USelect
                              :placeholder="friendsSidebarSelectFriendItems.length === 0 ?  $translate('profile.friends-select-noFriendsToAdd') : $translate('profile.friends-select-selectAFriend') "
                              v-model="userFriendsFormState.selectedUser"
                              :items="friendsSidebarSelectFriendItems"
                              class="w-48"
                            />
                          </UFormField>
                          
                          <UButton type="submit" class="cursor-pointer h-[32px]" :disabled="userFriendsFormState.selectedUser.value==''">
                            {{ $translate('profile.friends-sidebar-add-friend-button') }}
                          </UButton>
                          <UButton color="neutral" :label="$translate('button-close')" @click="closeFriendsSidebar"/>
                        </UForm>                      
                      </div>

                      <div>
                        <div>
                          <UTable class="table-container" :data="userFriendsTableData" :columns="userFriendsTableColumn" />
                        </div>
                      </div>
                    </div>
                  </template>
                </USlideover>

                <!-- edit user profile -->
                <USlideover 
                  :title="$translate('profile.edit-profile-sidebar-title')" 
                  :close="false"
                  v-model:open="profileSideBarIsOpen"
                  :description="$translate('profile.edit-profile-sidebar-description')">
                  <UButton class="hover: cursor-pointer">
                    {{ $translate('profile.edit-profile-button') }}
                  </UButton>

                  <template #body>
                    <div v-if="isEditProfileFormDisabled">
                      <Spinner />
                    </div>

                    <div v-else-if="!isEditProfileFormDisabled">
                      <UForm :disabled="isEditProfileFormDisabled" :state="userDetailFormState" @submit="onSubmitEditUser">

                        <UFormField size="lg" :label="$translate('profile.edit-profile-sidebar-alias-input-label')" :help="$translate('profile.edit-profile-sidebar-alias-input-help')" >
                          <UInput v-model="userDetailFormState.alias" maxlength="20" ref="firstInput"/>
                        </UFormField>

                        <UFormField size="lg" :label="$translate('profile.edit-profile-sidebar-size-input-label')" :help="$translate('profile.edit-profile-sidebar-size-input-help')">
                          <UInputNumber :min="0" v-model="userDetailFormState.size" class="w-[170px]" />
                        </UFormField>

                        <UButton :disabled="isEditProfileFormDisabled" type="submit" class="cursor-pointer h-[32px] mr-[5px]">
                          {{ $translate('profile.edit-profile-sidebar-submit-button') }}
                        </UButton>
                        <UButton color="neutral" :label="$translate('button-close')" @click="closeProfileSidebar"/>
                      </UForm>
                    </div>
                  </template>
                </USlideover>

              </div>
            </div>
          </div>  
          <!-- tabs feed and ownworkouts -->
          <UTabs v-model="activeTab" class="w-full" :items="itemTabs">
            <template #feed>
              <Feed />
            </template>

            <template #ownWorkout>
              <OwnWorkouts />
            </template>
          </UTabs>

      </div>
    </div>
  </div>
  <Footer/>
</template>