<script setup lang="ts">
import { ref } from 'vue'
import { useNuxtApp } from '#app'
import { replaceCount } from '../utils/helper';

const { $translate, $getActor } = useNuxtApp();

const isLoading = ref(true);
const totalUsers = ref<number>(0);

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
    icon: 'i-lucide-rss',
    slot: 'latestWorkouts'
  },
  {
    label: 'Ranking',
    icon: 'i-lucide-chart-no-axes-combined',
    slot: 'ranking'
  }
])
const activeTab = ref('0');
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