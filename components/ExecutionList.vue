<script setup lang="ts">
import { ref } from 'vue';
import {type Exercise} from '../src/declarations/backend/backend.did.d.ts';

const { $translate } = useNuxtApp();

const exerciseOptions = [
  { value: 1, info:'pushUps', text:'', add:'kg'},
  { value: 2, info:'sqaut', text:'', add:'kg'},
  { value: 3, info:'bicep_curl', text:'', add:'kg'},
  { value: 4, info:'hammer_curl', text:'', add:'kg'},
  { value: 5, info:'plank', text:'', add:'seconds'},
  { value: 6, info:'superman', text:'', add:'seconds'},
  { value: 7, info:'overhead_press', text:'', add:'seconds'},
  { value: 8, info:'flate_knee_raise', text:'', add:'kg'},
  { value: 9, info:'russian_twist', text:'', add:'kg'},
  { value: 10, info:'yoga', text:'', add:'seconds'},

  // Add more options as needed
];

const translateExerciseOptions = () => {
  return exerciseOptions.map(option => ({
    ...option,
    text: $translate(`workout.typeOfExercise${option.value}`)
  }));
};

const translatedExerciseOptions = translateExerciseOptions();
translatedExerciseOptions.sort((a, b) => a.text.localeCompare(b.text));

const executions = ref<Exercise[]>([
  { typeOfExercise: null, set: null, repetition: null, kg: null }
]);

const addExecution = async () => {

  const lastExecution = executions.value[executions.value.length - 1];
  if (lastExecution.set !== null && lastExecution.repetition !== null && lastExecution.typeOfExercise !== null || lastExecution.seconds !== null) { 
    executions.value.push({ set: 1, repetition: null, kg: null, typeOfExercise: null, seconds: null });
  }
};

const removeExecution = (index: number) => {
  executions.value.splice(index, 1);
};

watch(executions, (newExecutions) => {
  const lastExecution = newExecutions[newExecutions.length - 1];
  if (lastExecution && lastExecution.set !== null && (lastExecution.repetition !== null || lastExecution.seconds !== null)) {
    addExecution();
  }
});

defineExpose({ executions });


</script>

<template>
  <div>
   
    <div class="execution-form">
   
      <div class="execution-labels">
        <label for="typeOfExercise">{{$translate ('workout.typeOfExercise')}}</label>
      </div>
 
      <div v-for="(execution, index) in executions" :key="index" >
        <div class="execution-item">
          <select v-model="execution.typeOfExercise">
            <option v-for="option in translatedExerciseOptions" :key="option.value" :value="option.value">
              {{ option.text }}
            </option>
          </select>
        </div>

        <div class="execution-item" v-if="execution.typeOfExercise !== null">
          <input 
            type="number" 
            v-model="execution.set"
            placeholder="set"
            />

          <input 
            v-if="translatedExerciseOptions.find(option => option.value === execution.typeOfExercise)?.add === 'kg'"
            type="number" 
            v-model="execution.repetition" 
            placeholder="reps"
            />

            <input 
              v-if="translatedExerciseOptions.find(option => option.value === execution.typeOfExercise)?.add === 'kg'"
              type="number" 
              v-model="execution.kg" 
              @keyup.enter="addExecution"
              placeholder="kg"
            />

            <input 
              v-if="translatedExerciseOptions.find(option => option.value === execution.typeOfExercise)?.add === 'seconds'"
              type="number" 
              v-model="execution.seconds" 
              @keyup.enter="addExecution"
              placeholder="sec"
            />
            
            <button type="button" v-if="index === executions.length - 1 && execution.set !== null && execution.repetition !== null || execution.seconds !== null" @click="addExecution">
              <Icon name="fa6-regular:square-plus" class="icon" />
            </button>

            <button type="button" v-if="index > 0" @click="removeExecution(index)">
              <Icon name="fa6-regular:trash-can" class="icon" />
            </button>
          </div>

      </div>
    </div>
  </div>
</template>

<style scoped>
  .icon {
    color: white;
    margin-top: 2px;
  }

  .execution-form {
    display: grid;
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .execution-labels {
    display: grid;
    grid-template-columns:  170px 60px 60px auto;
    gap: 1rem;
  }

  .execution-item {
    display: flex;
    flex-direction: row;
    gap: 1rem;
    margin-bottom: 0.5rem;
  }

  .execution-item select{
    width: 100%;
    padding: 0.25rem;
    border-radius: 0.25rem;
    border: 1px solid #ccc;
    font-size: 1rem;
  }

  label {
    font-weight: bold;
  }

  input,
  button {
    width: 60px;
    padding: 0.25rem;
    border-radius: 0.25rem;
    border: 1px solid #ccc;
    font-size: 1rem;
  }

  button {
    width: 25px;
    background-color: #007bff;
    color: white;
    cursor: pointer;
    border: none;
    border-radius: 4px;
    padding: 0.25rem;
  }

  button:hover {
    background-color: #c82333;
  }

/* Media query for smaller screens   */
@media (max-width: 600px) {
  .execution-item {
    grid-template-columns: 1fr;
  }
  .execution-item select {
    width: 90%;
  }

  .execution-form {
    gap: 0.25rem;
  }
  input {
    width: 50px;
  }
  button {
    width: 30px;
  }
}

</style>