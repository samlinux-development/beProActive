<script lang="ts" setup>
  import { ref } from 'vue'
  import { useNuxtApp } from '#app'
  import { formatDate } from '../utils/helper';

  import { type LatestWorkouts } from '../declarations/backend/backend.did.js';
  const { $translate, $getActor } = useNuxtApp();

  const isLoading = ref(true);
  const latestWorkouts = ref<Array<LatestWorkouts>>([]);

  onMounted(async () => {
    try {
      const actor = await $getActor({},true);
      const result2 = await actor.getLatestWorkouts();
      //console.log(result2);
      // create a new latestWorkouts array
      latestWorkouts.value = result2.map((workout:any) => {
        return workout[1];
      });
      
      // sort the workouts by date
      latestWorkouts.value.sort((a:any, b:any) => Number(b.date) - Number(a.date));
      isLoading.value = false;

    } catch (error) {
      console.error("Error fetching workouts:", error);
      // Handle the error gracefully, e.g., display an error message to the user
    }
  });
</script>
<template>
  <div>
    <h2>{{ $translate('workout.list-title') }}</h2>
    <div class="mb-2">{{ $translate('workout.desc') }}</div>
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
</template>
