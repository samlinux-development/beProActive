<script setup lang="ts">
import { ref } from 'vue'
import { useNuxtApp } from '#app'
import { replaceCount, formatDate } from '../utils/helper';

import { type LatestWorkouts } from '../src/declarations/backend/backend.did.d';
const { $translate, $getActor } = useNuxtApp();

const isLoading = ref(true);
const totalWorkouts = ref<number>(0);
const totalUsers = ref<number>(0);
const latestWorkouts = ref<Array<LatestWorkouts>>([]);

onMounted(async () => {
  try {
    const actor = await $getActor({},true);
    const result = await actor.getPublicReports();
    const result2 = await actor.getLatestWorkouts();

    // create a new latestWorkouts array
    latestWorkouts.value = result2.map((workout:any) => {
      return workout[1];
    });

    // sort the workouts by date
    latestWorkouts.value.sort((a:any, b:any) => Number(b.date) - Number(a.date));

    totalWorkouts.value = Number(result.totalWorkouts);
    totalUsers.value = Number(result.totalUsers);

    isLoading.value = false;

  } catch (error) {
    console.error("Error fetching workouts:", error);
    // Handle the error gracefully, e.g., display an error message to the user
  }
});
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
    <div>
      <h2>{{ $translate('workout.list-title') }}</h2>
      <div v-if="isLoading"> <Spinner /> </div>
      <ol>
        <li v-for="(workout, index) in latestWorkouts" :key="index" class="workout-item">
        
          <div class="workout-details">
            <span class="workout-date">{{ $translate ('workout.at') }} {{ formatDate(workout.date) }} {{ $translate ('workout.by') }} {{ workout.alias }} </span> 
            
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
</template>

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