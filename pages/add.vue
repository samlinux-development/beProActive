<script setup lang="ts">
  import { ref } from 'vue'
  import {type Exercise} from '../src/declarations/backend/backend.did.d';
  import { isAuthenticated } from '../utils/helper';
  const { $translate, $getActor } = useNuxtApp();

  const isLoading = ref<boolean>(false);
  const isAuth = ref(false);
  const isCheckingAuth = ref<boolean>(true);

  interface ExecutionList {
    executions: Exercise[];
  }

  let executionListRef = ref<ExecutionList | null>(null);
  const showModal = ref<boolean>(false);

  const addExercise = async () => {

    try {
      isLoading.value = true;
      const executions = executionListRef.value?.executions || [];
      const actor = await $getActor({}, true);
    
      // prepare an array with the count and repetition values
      const executionList = executions.map((execution) => {
        // check if values available
        let set = execution.set || 0;
        let repetition = parseInt(execution.repetition.toString()) || 0;
        let typeOfExercise = parseInt(execution.typeOfExercise.toString()) || 0;
        let kg = execution.kg || 0;
        let seconds = execution.seconds || 0;
        return { set, repetition, typeOfExercise, kg, seconds };
      });
      
      await actor.addWorkout(executionList);
      
      // reset the execution list
      executionListRef = ref(null);

    } catch (error) {
      console.error("Error adding push-up:", error);
    } finally {
      isLoading.value = false;
    }

  };

  const isFormValid = computed(() => {
    return executionListRef.value?.executions.every(execution => 
      execution.typeOfExercise !== null && execution.typeOfExercise > 0 &&
      execution.set !== null && execution.set > 0 &&
      execution.repetition !== null && execution.repetition > 0 || (execution.seconds !== null && execution.seconds > 0)
    );
  });

  const openModal = () => {
    showModal.value = true;
  };

  const closeModal = () => {
    showModal.value = false;
  };

  const confirmAddExercise = () => {
    closeModal();
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
        <ExecutionList ref="executionListRef"/>

        <UModal 
          :title="$translate('workout.confirm-title')"
          :close="{
            color: 'error',
            variant: 'outline',
            class: 'rounded-full'
          }">
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
            {{$translate('workout.confirm-text')}}
            <div class="modal-actions">
              <UButton @click="confirmAddExercise">{{ $translate('workout.confirm-yes') }}</UButton>  
            </div>
          </template>
        </UModal>
      </form>
      
      <div v-if="isLoading"> <Spinner /> </div>  
    </div>
  </div>
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
</style>