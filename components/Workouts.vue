<script setup lang="ts">
import { ref } from 'vue'
import { useNuxtApp } from '#app'
import { type Workout } from '../src/declarations/backend/backend.did.js';
import { formatNumber, splitPrincipalID, formatDate, replaceCount } from '../utils/helper.ts';

const { $translate, $getActor } = useNuxtApp();

const workouts = ref<Workout[]>([]);
const totalUsers = ref<number>(0);

const isloading = ref(true);

onMounted(async () => {
  try {
    const actor = await $getActor();
    const result = await actor.getPublicWorkouts();
    //console.log(result.workouts);
    workouts.value = result.workouts;
    totalUsers.value = result.totalUsers;

    // sort the push-ups by date
    workouts.value.sort((a, b) => Number(b.date) - Number(a.date));

    isloading.value = false;
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
      {{ replaceCount($translate('index.hello'),'__count__', workouts.length) }}
    </div>
    <div class="hello">
      {{ replaceCount($translate('index.hello2'),'__totalUsers__', totalUsers) }}
    </div>

    <h1>{{ $translate('workout.list-title') }}</h1>
    
    <div v-if="isLoading"> <Spinner /> </div>
    <div v-else-if="workouts.length === 0">{{ $translate ('workout.list-empty') }}</div>
    <ol v-else class="workout-list">
      <li v-for="(workout, index) in workouts" :key="index" class="workout-item">
       
        <div class="workout-details">
          <span class="workout-user">{{ $translate ('workout.by') }} {{ splitPrincipalID(workout.user.toString()) }}</span>
          <span class="workout-date">{{ $translate ('workout.at') }} {{ formatDate(workout.date) }}</span>
          
          <div v-if="workout.exercises && workout.exercises.length > 0" class="execution-details">
            <h3>{{ $translate('workout.executionDetails') }}</h3>
            <ul>
              <Exercise 
                v-for="(exercise, index) in workout.exercises" 
                :key="index" 
                :exercise="exercise" 
                />
            </ul>
          </div>

        </div>
      </li>
    </ol>
  </div>
</template>

<style scoped>
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

