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
      duration.value = stopWatchRef.value?.time || 0;
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
    
      //console.log({ duration });
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
  }

  const startStopWatch = () => {
    stopWatchRef.value?.start();
  };

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
            variant="solid">
            {{$translate ('workout.addBtn')}}
          </UButton>

          <template #body>
            <div class="execution-details">
              <h3>{{ $translate('workout.executionDetails2') }}</h3>
              <div v-if="duration || 0 > 0" class="flex flex-row items-center">  
                <div class="pr-0.5 flex flex-row items-center">
                  <Icon name="i-lucide-timer" class="icon" /> </div>
                <div>{{ formatDuration(BigInt(duration)) }} </div>
              </div>
              <ul>
                <ExerciseConfirm v-for="(exercise, index) in executionListRef?.executions || []" :key="index" :exercise="exercise" />
              </ul>
            </div>
            <div class="modal-actions">
              <UButton @click="confirmAddExercise">{{ $translate('workout.confirm-yes') }}</UButton>  
              <UButton color="error" @click="closeModalSidebar">
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

  label {
    font-weight: bold;
  }
  .modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
  }
  .icon {
    font-size: 1.2rem;
  }
</style>