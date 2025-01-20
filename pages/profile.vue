<script lang="ts" setup>
  import { ref } from 'vue'
  import { useNuxtApp } from '#app'
  import { type Workout } from '../src/declarations/backend/backend.did.js';
  import { isAuthenticated } from '../utils/helper';
  import type { FormSubmitEvent, TableColumn } from '@nuxt/ui';
  import RemoveFriendModal from '~/components/RemoveFriendModal.vue';

  const UButton = resolveComponent('UButton');

  const { $translate, $getActor } = useNuxtApp();
  const workouts = ref<Workout[]>([]);
  const workoutsTotal = ref<number>(0);
  const isLoading = ref(true);
  const isAuth = ref(false);
  const isCheckingAuth = ref<boolean>(true);
  const user = ref<string>('');
  const friends = ref<[]>([]);
  const totalWorkouts = ref<bigint>(0n);
  const isEditProfileFormDisabled = ref<boolean>(false);
  const isFriendsSidebarLoading = ref<boolean>(false);

  const friendsSidebarSelectFriendItems = ref<{label: string, data: any}[]>([]);

  const allUsers = ref<[]>([]);

  const userDetailFormState = reactive({
    alias: '',
  });

  const userFriendsFormState = reactive({
    selectedUser: {label: '', data: {}}
  });

  type UserFriend = {
   alias: string,
   principal: any,
   totalWorkouts: bigint
  }

  const userFriendsTableData = ref<{alias: string, principal: any, totalWorkouts: bigint}[]>([]);

  onMounted(async () => {
    try {
      isAuth.value = await isAuthenticated();
      if (!isAuth.value) {
        isLoading.value = false;
        return;
      }
      
      const actor = await $getActor({}, true);
      const result = await actor.getWorkoutsPerPrincipal();
      const result2 = await actor.getUserProfile();

      user.value = result2.alias;
      friends.value = result2.friends;
      totalWorkouts.value = result2.totalWorkouts;

      userDetailFormState.alias = user.value;

      getUserFriends();

      if(result.length === 0) {
        isLoading.value = false;
        return;
      }

      workouts.value = result;
      workoutsTotal.value = result.length;
      // sort the push-ups by date
      workouts.value.sort((a, b) => Number(b.date) - Number(a.date)); 

      isLoading.value = false;
    } catch (error) {
      console.error("Error fetching workouts per principal:", error);
    }
    finally {
      isCheckingAuth.value = false;
    }
  });

  async function loadUserFriendsSidebar() {
    isFriendsSidebarLoading.value = true;
    const actor = await $getActor({}, true);
    allUsers.value = await actor.getAllUsers();

    const userProfile = await actor.getUserProfile();

    friends.value = userProfile.friends;

    userFriendsFormState.selectedUser = {label: '', data: {}};

    let testAllUsers: any = [];

    allUsers.value.forEach(function(user: UserFriend) {
      // dont check with alias
      if (userProfile.alias == user.alias) {
        return false;
      }

      const isAFriend = friends.value.find(function(friend: UserFriend) {
        // dont check with alias
        if (user.alias == friend.alias) {
          return true;
        }
      })

      if (isAFriend) {
        return true;
      }

      const testUser = {
        label: user.alias,
        data: user.principal
      }

      testAllUsers.push(testUser);
    })

    friendsSidebarSelectFriendItems.value = testAllUsers;
    isFriendsSidebarLoading.value = false;
  }

  async function getUserFriends() {
    const actor = await $getActor({}, true);
    const userProfile = await actor.getUserProfile();

    friends.value = userProfile.friends;
    
    let userFriends: any[] = [];

    friends.value.forEach(function (friendData: {alias: string, principal: any, totalWorkouts: bigint}) {
      const friend = {
        alias: friendData.alias,
        principal: friendData.principal,
        totalWorkouts: friendData.totalWorkouts
      }

      userFriends.push(friend);
    })

    userFriendsTableData.value = userFriends;
  }

  async function onSubmitEditUser(event: FormSubmitEvent<{alias: string}>) {
    isEditProfileFormDisabled.value = true;
    const actor = await $getActor({}, true);
    const res = await actor.updateProfile(event.data.alias.trim());

    if (res) {
      const userProfile = await actor.getUserProfile();
      user.value = userProfile.alias;
      userDetailFormState.alias = user.value;
    }

    isEditProfileFormDisabled.value = false;
  }

  async function addFriend() {
    if (userFriendsFormState.selectedUser.label) {
      isFriendsSidebarLoading.value = true;
      const actor = await $getActor({}, true);
      
      await actor.addFriend(userFriendsFormState.selectedUser.data);

      userFriendsFormState.selectedUser = {label: '', data: {}};

      loadUserFriendsSidebar();
      getUserFriends();
      isFriendsSidebarLoading.value = false;
    }
  }

  async function removeFriend(principalId: any) {
    isFriendsSidebarLoading.value = true;

    const actor = await $getActor({}, true);
    await actor.removeFriend(principalId);
    
    loadUserFriendsSidebar();
    getUserFriends();
    isFriendsSidebarLoading.value = false;
  }

  const userFriendsTableColumn: TableColumn<UserFriend>[] = [
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
                </div>
              </div>
            </div>

            <div class="mt-4">
              <div class="flex justify-between items-center">
                <USlideover 
                  :title="$translate('profile.friends-sidebar-title')"
                  :close="{
                    class: 'text-[25px]'
                  }"
                >
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
                            <USelectMenu
                              v-model="userFriendsFormState.selectedUser" 
                              :items="friendsSidebarSelectFriendItems"
                              :search-input="{icon: 'i-lucide-search'}"
                              class="w-48"
                            />
                          </UFormField>

                          <UButton type="submit" class="cursor-pointer h-[32px]">
                            {{ $translate('profile.friends-sidebar-add-friend-button') }}
                          </UButton>
                        </UForm>                      
                      </div>

                      <div>
                        <div>
                          <UTable class="friends-table-container" :data="userFriendsTableData" :columns="userFriendsTableColumn" />
                        </div>
                      </div>
                    </div>
                  </template>
                </USlideover>

                <USlideover 
                  :title="$translate('profile.edit-profile-sidebar-title')" 
                  :close="{
                    class: 'cursor-pointer text-[25px]'
                  }"
                >
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
                          <UInput autofocus v-model="userDetailFormState.alias"></UInput>
                        </UFormField>

                        <UButton :disabled="isEditProfileFormDisabled" type="submit" class=" hover:cursor-pointer">
                          {{ $translate('profile.edit-profile-sidebar-submit-button') }}
                        </UButton>
                      </UForm>
                    </div>
                  </template>
                </USlideover>
              </div>
            </div>
          </div>  

        <div v-if="workouts.length === 0">
          <h1>{{ $translate('workout.list-title2') }}</h1>
          <div>{{ $translate ('workout.list-empty') }}</div>
        </div>
        <div v-else class="workout-list">
          <h1>{{ $translate('workout.list-title2') }}</h1>
          <div class="hello">{{ replaceCount($translate('workout.hello'),'__workoutsTotal__', workoutsTotal) }}</div>
            <ol>
              <li v-for="(workout, index) in workouts" :key="index" class="workout-item">
              
                <div class="workout-details">
                  
                  <span class="workout-date">{{ $translate ('workout.at') }} {{ formatDate(workout.date) }}</span>
                  
                  <div v-if="workout.exercises && workout.exercises.length > 0" class="execution-details">
                    <h3>{{ $translate('workout.executionDetails') }}</h3>
                    <ul>
                      <Exercise v-for="(exercise, index) in workout.exercises" :key="index" :exercise="exercise" />
                    </ul>
                  </div>

                </div>
              </li>
            </ol>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
  .friends-table-container table th, .friends-table-container table td {
    text-align: center;
  }
</style>

<style scoped>


  ol {
    padding-left: 0px;
  }
  
  .workout-list {
    list-style-type: none;
    padding: 0;
    margin: 0;
  }

  .workout-item {
    display: flex;
    flex-direction: column;
    padding: 0.5rem;
    margin-bottom: 0.5rem;
    border: 1px solid #ccc;
    border-radius: 8px;
    background-color: #f9f9f9;
  }

  .workout-details {
    display: flex;
    flex-direction: column;
  }

  .workout-user,
  .workout-date {
    font-size: 0.9rem;
    color: #666;
  }
  .execution-details {
    margin-top: 0.5rem;
  }

  .execution-details h3 {
    margin: 0;
    font-size: 1rem;
    font-weight: bold;
  }

  .execution-details ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
    margin-top: 0.25rem;
  }

  .execution-details li {
    font-size: 0.9rem;
    color: #333;
    margin-left: 0.5rem;
  }

</style>