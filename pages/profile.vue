<script lang="ts" setup>
  import { ref } from 'vue'
  import { useNuxtApp } from '#app'
  import { type Workout } from '../src/declarations/backend/backend.did.js';
  import { splitPrincipalID, isAuthenticated, getIdentity} from '../utils/helper';

  const { $translate, $getActor } = useNuxtApp();
  const workouts = ref<Workout[]>([]);
  const workoutsTotal = ref<number>(0);
  const isLoading = ref(true);
  const isAuth = ref(false);
  const isCheckingAuth = ref<boolean>(true);
  const user = ref<string>('');

  onMounted(async () => {
    try {
      isAuth.value = await isAuthenticated();
      if (!isAuth.value) {
        isLoading.value = false;
        return;
      }
        
      const actor = await $getActor({}, true);
      const result = await actor.getWorkoutsPerPrincipal();
      if(result.length === 0) {
        isLoading.value = false;
        return;
      }

      const identity = await getIdentity();
      workouts.value = result;
      workoutsTotal.value = result.length; 
      // sort the push-ups by date
      workouts.value.sort((a, b) => Number(b.date) - Number(a.date));

      user.value = splitPrincipalID(identity?.getPrincipal().toString() || '');
      isLoading.value = false;
    } catch (error) {
      console.error("Error fetching workouts per principal:", error);
    }
    finally {
      isCheckingAuth.value = false;
    }
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
        <div v-else-if="workouts.length === 0">
          <h1>{{ $translate('workout.list-title2') }}</h1>
          <div>{{ $translate ('workout.list-empty') }}</div>
        </div>
        <div v-else class="workout-list">
          <h1>{{ $translate('workout.list-title2') }}, {{ user }}</h1>
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