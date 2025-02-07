<script setup lang="ts">
import { ref } from 'vue'
import { useNuxtApp } from '#app'
import { replaceCount } from '../utils/helper';
const { $translate, $getActor } = useNuxtApp();

const isLoading = ref(true);
const totalUsers = ref<number>(0);
const route = useRoute();

onMounted(async () => {
  try {
    const actor = await $getActor({},true);
    const result = await actor.getPublicReports();
    totalUsers.value = Number(result.totalUsers);
    isLoading.value = false;
  } catch (error) {
    console.error("Error fetching workouts:", error);
    // Handle the error gracefully, e.g., display an error message to the user
  }
});

// Tabs
const itemTabs = ref([
  {
    label: 'Latest Workouts',
    icon: 'i-lucide-party-popper',
    slot: 'latestWorkouts'
  },
  {
    label: 'Ranking',
    icon: 'i-lucide-chart-no-axes-combined',
    slot: 'ranking'
  }
])

const activeTab = ref(route.query.t === 'lb' ? '1' : '0');

watch(
  () => route.query.t,
  (newT, oldT) => {
    //console.log('Query parameter t changed from', oldT, 'to', newT);
    if (newT === 'lb') {
      activeTab.value = '1';
    } else {
      activeTab.value = '0';
    }
  }
);

</script>

<template>
  <div>
    <h1>{{$translate('index.title')}}</h1>
    <div class="hello">
      {{ $translate('index.hello')}}
    </div>
    <div class="hello">
      {{ replaceCount($translate('index.hello2'),'__totalUsers__', totalUsers) }}
    </div>
    <div class="flex items-center justify-center mb-4">
      <UButton @click="navigateTo('/getting-started')" color="info">{{ $translate('btn-getStarted')}}</UButton>
    </div>
    <UTabs v-model="activeTab" class="w-full" :items="itemTabs">
      <template #latestWorkouts>
        <LatestWorkouts /> 
      </template>

      <template #ranking>
        <Ranking />
      </template>
    </UTabs>
  </div>
</template>

<style scoped> 
</style>