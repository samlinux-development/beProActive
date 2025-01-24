<script lang="ts" setup>
  import { type GetUserFeedResponse } from '../declarations/backend/backend.did.js';
  import { formatDate } from '../utils/helper.js';

  const { $translate, $getActor } = useNuxtApp() as any;
  const workouts = ref<GetUserFeedResponse[]>([]);
  const workoutsTotal = ref<number>(0);
  const isLoading = ref(true);
  
  onMounted(async () => {
    const actor = await $getActor({}, true);
    if (actor) {
      const result = await actor.getUserFeed();
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
    <h1>{{ $translate('workout.list-title3') }}</h1>
    <div>{{ $translate ('workout.list-empty') }}</div>
  </div>
  <div v-else class="workout-list">
    <h1>{{ $translate('workout.list-title3') }}</h1>
    <div class="hello">{{ $translate ('workout.list-rolling')}}</div>
      <ol>
        <li v-for="(workout, index) in workouts" :key="index" class="workout-item">
          <div class="workout-details">
            <span class="workout-date">{{ $translate ('workout.at') }} {{ formatDate(workout.date) }} by {{ workout.alias }}</span>
            
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
