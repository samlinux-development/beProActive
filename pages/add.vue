<script setup lang="ts">
  import { ref } from 'vue'
  import { isAuthenticated, formatDuration } from '../src/utils/helper';

interface Exercise {
  'kg' : number,
  'set' : number,
  'seconds' : bigint,
  'typeOfExercise' : number,
  'repetition' : number,
  'minutes'? : bigint | number | undefined
}

  const { $translate, $getActor } = useNuxtApp();
  const isLoading = ref<boolean>(false);
  const isAuth = ref(false);
  const isCheckingAuth = ref<boolean>(true);
  const duration = ref(0);
  const manualDuration = ref(0);

  interface ExecutionList {
    executions: Exercise[];
  }

  let executionListRef = ref<ExecutionList | null>(null);


  let stopWatchRef = ref<StopWatch | null>(null);
  interface StopWatch {
    time: number;
    stop: () => void;
    start: () => void;
  }

  const addExercise = async () => {
    try {
      isLoading.value = true;
      const executions = executionListRef.value?.executions || [];

      if(manualDuration.value > 0){
        duration.value = manualDuration.value;
      } else {
        duration.value = stopWatchRef.value?.time || 0;
      }
      
      const actor = await $getActor({}, true);
    
      // prepare an array with the count and repetition values
      const executionList = executions.map((execution) => {
        // check if values available
        let set = execution.set || 0;
        let repetition = parseInt(execution.repetition?.toString()) || 0;
        let typeOfExercise = parseInt(execution.typeOfExercise.toString()) || 0;
        let kg = parseInt(execution.kg?.toString()) || 0;
        let seconds = parseInt(execution.seconds?.toString()) || 0;
        // if minutes available overwrite seconds
        if (execution.minutes && execution.minutes > 0) {
          seconds = Number(execution.minutes) * 60;
        }
        //console.log({ set, repetition, typeOfExercise, kg, seconds })

        return { set, repetition, typeOfExercise, kg, seconds };
      });
    
      //console.log('duration for store',duration.value);
      await actor.addWorkout({duration:duration.value, exercises:executionList});
      
      // reset the execution list
      executionListRef = ref(null);

    } catch (error) {
      console.error("Error adding addExercise:", error);
    } finally {
      isLoading.value = false;
    }

  };

  const isFormValid = computed(() => {
    return executionListRef.value?.executions.every(execution => 
      execution.typeOfExercise !== null && execution.typeOfExercise > 0 &&
      execution.set !== null && execution.set > 0 &&
      execution.repetition !== null && execution.repetition > 0 || 
      (
        (execution.seconds !== null && execution.seconds > 0) ||
        (execution.minutes !== undefined && execution.minutes > 0)
      )
    );
  });

  const openModal = () => {
    stopWatchRef.value?.stop();
    duration.value = stopWatchRef.value?.time || 0;
    modalSideBarIsOpen.value = true;
  };

  const confirmAddExercise = () => {
    modalSideBarIsOpen.value = false;
    addExercise();
  };

  onMounted(async () => {
    try {
      isAuth.value = await isAuthenticated();
      if (!isAuth.value) {
        isLoading.value = false;
        return;
      }
    }
    catch (error) {
      console.error("Error checking auth:", error);
    }
    finally {
      isCheckingAuth.value = false;
    }
  });

  const modalSideBarIsOpen = ref(false);
  const closeModalSidebar = () => {
    modalSideBarIsOpen.value = false;
    // only if timer is > 0
    if ((stopWatchRef.value?.time ?? 0) > 0){
      startStopWatch();
    }
    ctrlManualDuration.value = false;
    duration.value = stopWatchRef.value?.time ?? 0;
    manualDuration.value = 0;
  }

  const startStopWatch = () => {
    stopWatchRef.value?.start();
  };

  // section manual duration
  const hours = ref<number | undefined>();
  const minutes = ref<number | undefined>();
  const seconds = ref<number | undefined>();

  const generateOptions = (limit: number) => {
    return Array.from({ length: limit + 1 }, (_, i) => {
      const value = i;
      //const label = String(i).padStart(2, '0');
      const label = i;
      return { value, label: label };
    });
  }
  const minuteOptions = generateOptions(59);
  const secondOptions = generateOptions(59);
  const hourOptions = generateOptions(23);
  const ctrlManualDuration = ref(false);

  // watch for changes in the manual duration and update the total duration
  watch([hours, minutes, seconds], ([newHours, newMinutes, newSeconds]) => {
    const newHoursInt = Number(newHours) || 0;
    const newMinutesInt = Number(newMinutes) || 0;
    const newSecondsInt = Number(newSeconds) || 0;

    const totalMilliseconds = ((newHoursInt * 3600) + (newMinutesInt * 60) + newSecondsInt) * 1000;

    if (duration.value !== totalMilliseconds && ctrlManualDuration.value) {
      duration.value = totalMilliseconds;
      manualDuration.value = totalMilliseconds;
    }
  });
  
  // clear the manual duration when the modal is opened
  watch(modalSideBarIsOpen, (newValue) => {
    if (newValue) {
      hours.value = undefined; minutes.value = undefined; seconds.value = undefined;
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
      <h1>{{ $translate ('workout.title') }}</h1>
      <form type="submit" v-if="!isLoading">
        <Stopwatch ref="stopWatchRef"/>
        <ExecutionList ref="executionListRef"/>
        <UModal 
          v-model:open="modalSideBarIsOpen"
          :title="$translate('workout.confirm-title')"
          :close="false"
          :description="$translate('workout.confirm-text')">
          <UButton 
            icon="i-lucide-git-graph" 
            :disabled="isLoading || !isFormValid" 
            @click="openModal" 
            size="md" 
            color="primary" 
            variant="solid" class="text-lg">
            {{$translate ('workout.addBtn')}}
          </UButton>

          <template #body>
            <div class="execution-details">
              <h2>{{ $translate('workout.executionDetails2') }}</h2>
              <div v-if="duration || 0 > 0" class="flex flex-row items-center">
              
                <div class="pr-0.5 flex flex-row items-center">
                  {{ $translate('workout.workoutDuration') }}:
                </div>
                  <div>{{ formatDuration(BigInt(duration)) }} </div>
              </div>
              <div class="flex flex-col">
                <div>{{ $translate('workout.manualDuration') }}</div>
                <div class="flex flex-row items-center gap-x-2 mb-1 mt-1">
                  <USelect id="hours" v-model="hours" :items="hourOptions" placeholder="h" class="w-[80px]" @change="  ctrlManualDuration = true"/>  
                  <USelect id="minutes" v-model="minutes" :items="minuteOptions" placeholder="m" class="w-[80px]" @change="  ctrlManualDuration = true"/>
                  <USelect id="seconds" v-model="seconds" :items="secondOptions" placeholder="s" class="w-[80px]" @change="  ctrlManualDuration = true"/>
                </div>
              </div>

              <ul>
                <ExerciseConfirm v-for="(exercise, index) in executionListRef?.executions || []" :key="index" :exercise="exercise" />
              </ul>
            </div>
            <div class="modal-actions">
              <UButton @click="confirmAddExercise" class="text-lg">{{ $translate('workout.confirm-yes') }}</UButton>  
              <UButton color="error" @click="closeModalSidebar"  class="text-lg">
                {{ $translate('profile.friends-sidebar-remove-friend-modal-cancel-button') }}
              </UButton>
            </div>
          </template>
        </UModal>
      </form>
      
      <div v-if="isLoading"> <Spinner /> </div>  
    </div>
  </div>
  <Footer/>
</template>

<style scoped>

  form {
    display: grid;
    gap: 1rem;
    margin: 0 auto;
    padding: 0.5rem;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  .select {
    width: 40px;
  }
  label {
    font-weight: bold;
  }
  .modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    margin-top: 1rem;
  }
  .icon {
    font-size: 1.2rem;
  }
  
</style>