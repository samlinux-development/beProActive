<script lang="ts" setup>
  import { type WorkoutsPerUserResponse } from '../declarations/backend/backend.did.js';
  import { replaceCount, formatDate, formatDuration } from '../utils/helper.js';

  const { $translate, $getActor } = useNuxtApp() as any;
  const workouts = ref<WorkoutsPerUserResponse[]>([]);
  const workoutsTotal = ref<number>(0);
  const isLoading = ref(true);
  const modalSideBarIsOpen = ref(false);
  const selectedWorkout = ref<WorkoutsPerUserResponse | null>(null);
  const emit = defineEmits(['reloadUserProfile']);

  onMounted(async () => {
    await loadWorkouts();

  });

  const loadWorkouts = async () => {
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
  };

  const removeWorkout = async (workout: WorkoutsPerUserResponse) => {
    //console.log('delete workout', workout.id);
    if(!workout.id) return;

    const actor = await $getActor({}, true);
    if (actor) {
      workouts.value = workouts.value.filter((w) => w.id !== workout.id);
      workoutsTotal.value = workouts.value.length;
      await actor.removeWorkout(workout.id);
    }
  };

  const openDeleteModal = (workout: WorkoutsPerUserResponse) => {
    selectedWorkout.value = workout;
    modalSideBarIsOpen.value = true;
  };

  const closeModalSidebar = () => {
    modalSideBarIsOpen.value = false;
  };

  const confirmRemoveWorkout = async () => {
    modalSideBarIsOpen.value = false;
    await removeWorkout(selectedWorkout.value as WorkoutsPerUserResponse);
    // reload profile data
    emit('reloadUserProfile');
  };

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

            <div class="workout-date flex flex-row items-center justify-between">
              <div class="flex flex-row items-center">
                <div>{{ $translate ('workout.at') }} {{ formatDate(workout.date) }}</div>
                  <div v-if="workout.duration > 0" class="flex flex-row items-center justify-between">  
                    <Icon name="i-lucide-timer" class="icon ml-1 mr-1" />
                    <div>{{ formatDuration(workout.duration) }}</div>
                  </div>
                </div>
                <div>
                  <UButton @click="openDeleteModal(workout)" icon="i-lucide-trash" color="error" size="sm"/>
                </div>
             </div>
            
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

  <UModal 
    v-model:open="modalSideBarIsOpen"
    :title="$translate('workout.delete-title')"
    :close="false"
    :description="$translate('workout.delete-text')"
    >
    <template #body>
      <div class="modal-actions">
        <UButton color="error" @click="confirmRemoveWorkout" class="text-lg">{{ $translate('workout.confirm-yes') }}</UButton>  
        <UButton @click="closeModalSidebar"  class="text-lg">
          {{ $translate('profile.friends-sidebar-remove-friend-modal-cancel-button') }}
        </UButton>
      </div>
    </template>
</UModal>

</template>
<style scoped>
.icon {
  font-size: 1.2rem;
}
.modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    margin-top: 1rem;
  }
</style>
