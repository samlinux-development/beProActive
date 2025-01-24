<script lang="ts" setup>
  import { type Workout } from '../declarations/backend/backend.did.js';
  import { replaceCount, formatDate } from '../utils/helper.js';
  
  const { $translate, $getActor } = useNuxtApp() as any;
  const workouts = ref<Workout[]>([]);
  const workoutsTotal = ref<number>(0);
  const isLoading = ref(true);

  onMounted(async () => {
    const actor = await $getActor({}, true);
    if (actor) {
      const result = await actor.getWorkoutsPerPrincipal();
      //console.log(result)
      workouts.value = result;
      workoutsTotal.value = result.length;
      // sort by date
      workouts.value.sort((a, b) => Number(b.date) - Number(a.date)); 
      isLoading.value = false;
    }
  });
</script>
<template>
  <div v-if="isLoading"> <Spinner /> </div>
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
</template>
