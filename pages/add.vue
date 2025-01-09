<script setup lang="ts">
  import { ref } from 'vue'
  import {type Exercise} from '../src/declarations/backend/backend.did.d.ts';
  import { isAuthenticated } from '../utils/helper.ts';
  const { $translate, $getActor } = useNuxtApp();

  const isLoading = ref<boolean>(false);
  const isAuth = ref(false);

  interface ExecutionList {
    executions: Exercise[];
  }

  let executionListRef = ref<ExecutionList | null>(null);
  const showModal = ref<boolean>(false);

  const addExercise = async () => {

    try {
      isLoading.value = true;
      const executions = executionListRef.value?.executions || [];
      const actor = await $getActor();
    
      // prepare an array with the count and repetition values
      const executionList = executions.map((execution) => {
        // check if values available
        let set = execution.set || 0;
        let repetition = execution.repetition || 0;
        let typeOfExercise = execution.typeOfExercise || 0;
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
  });

</script>

<template>

  <div v-if="!isAuth">
    <PleaseLogin />
  </div>
  <div v-else-if="isAuth">
    <h1>{{ $translate ('workout.title') }}</h1>
    <form type="submit" v-if="!isLoading">
      <ExecutionList ref="executionListRef"/>
      <button type="button" :disabled="isLoading || !isFormValid" @click="openModal">{{$translate ('workout.addBtn')}}</button>
    </form>
    
    <div v-if="isLoading"> <Spinner /> </div>

    <Modal v-if="showModal" 
      :title="$translate('workout.confirm-title')"
      :message="$translate('workout.confirm-text')" 
      :confirmText="$translate('workout.confirm-yes')" 
      :cancelText="$translate('workout.confirm-no')"
      @confirm="confirmAddExercise" 
      @close="closeModal" />
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

  input,
  button {
    width: 50%;
    padding: 0.5rem;
    border-radius: 0.25rem;
    border: 1px solid #ccc;
  }

  button {
    background-color: #007bff;
    color: white;
    cursor: pointer;
  }

  button:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
  }

  button:hover:enabled {
    background-color: #0056b3;
  }

  input[type="text"] {
    width: calc(50% - 16px);
  }

  form {
    width: calc(100% - 32px);
  }

  /* Media query for smaller screens   */
  @media (max-width: 600px) {

    button {
      width: calc(100% - 16px);
    }
  }
</style>