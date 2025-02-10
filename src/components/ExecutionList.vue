<script setup lang="ts">
import { ref } from 'vue';
type Exercise = {
  set: any;
  repetition: any;
  kg: any;
  typeOfExercise: any;
  seconds: any;
  minutes: any;
};
import {exerciseOptions} from '../utils/exerciseOptions' 

const { $translate } = useNuxtApp();

// Hint: add in Exercise.vue the types with minutes
/*
const exerciseOptions = [
  { value: "1", info:'pushUps', label:'', add:'kg'},
  { value: "2", info:'sqaut', label:'', add:'kg'},
  { value: "3", info:'bicep_curl', label:'', add:'kg'},
  { value: "4", info:'hammer_curl', label:'', add:'kg'},
  { value: "5", info:'plank', label:'', add:'minutes'},
  { value: "6", info:'superman', label:'', add:'minutes'},
  { value: "7", info:'overhead_press', label:'', add:'kg'},
  { value: "8", info:'flate_knee_raise', label:'', add:'kg'},
  { value: "9", info:'russian_twist', label:'', add:'kg'},
  { value: "10", info:'yoga', label:'', add:'minutes'},
  
  { value: "11", info:'crunch', label:'', add:'kg'},
  { value: "13", info:'bicycle_crunch', label:'', add:'kg'},
  { value: "12", info:'leg_raise', label:'', add:'kg'},
  
  { value: "14", info:'bench_dip', label:'', add:'kg'},
  { value: "15", info:'chest_dip', label:'', add:'kg'},
  { value: "16", info:'ring_dip', label:'', add:'kg'},
  { value: "17", info:'triceps_dip', label:'', add:'kg'},

  { value: "18", info:'leg_extension_maschine', label:'', add:'kg'},
  { value: "19", info:'leg_press_maschine', label:'', add:'kg'},

  { value: "20", info:'bench_press_barbbell', label:'', add:'kg'},
  { value: "21", info:'bench_press_dumbbell', label:'', add:'kg'},
  
  { value: "22", info:'bicep_curl_barbell', label:'', add:'kg'},
  { value: "23", info:'reverse_curl_dumbbell', label:'', add:'kg'},
  { value: "24", info:'stretching', label:'', add:'minutes'},
  { value: "25", info:'swimmer', label:'', add:'minutes'},


  // Add more options as needed
];
*/

const translateExerciseOptions = () => {
  return exerciseOptions.map(option => ({
    ...option,
    label: $translate(`workout.typeOfExercise${option.value}`)
  }));
};

const translatedExerciseOptions = translateExerciseOptions();
translatedExerciseOptions.sort((a, b) => a.label.localeCompare(b.label));


const executions = ref<Exercise[]>([
  { typeOfExercise: null, set: 1, repetition: null, kg: null, seconds: null, minutes: null }
]);

const addExecution = async () => {

  const lastExecution = executions.value[executions.value.length - 1];
  if (lastExecution.set !== null && lastExecution.typeOfExercise !== null) { 
    executions.value.push({ set: 1, repetition: null, kg: null, typeOfExercise: null, seconds: null, minutes: null });
  }
};

const removeExecution = (index: number) => {
  executions.value.splice(index, 1);
};

watch(executions, (newExecutions) => {
  const lastExecution = newExecutions[newExecutions.length - 1];
  if (lastExecution && lastExecution.set !== null && (lastExecution.repetition !== null || lastExecution.seconds !== null || lastExecution.minutes !== null)) {
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
          
          <USelect 
            placeholder="Select exercise"  
            v-model="execution.typeOfExercise" 
            :items="translatedExerciseOptions" 
            class="w-[300px] font-semibold"/>

          <UButton v-if="index > 0" @click="removeExecution(index)" color="error">
            <Icon name="i-lucide-trash" class="icon" />
          </UButton>
        </div>

        <div class="execution-item" v-if="execution.typeOfExercise !== null">
          <div class="flex flex-row items-center gap-x-2">
            <UInput 
              type="number"  
              v-model="execution.set" 
              inputmode="numeric" pattern="[0-9]*"
              placeholder="set" 
              :min="1"
              :default-value="1"
              class="w-[60px] sm:w-[80px] font-semibold"/>

            <UInput  
              v-if="translatedExerciseOptions.find(option => option.value === execution.typeOfExercise)?.add === 'kg'"
              type="number" 
              v-model="execution.repetition"
              inputmode="numeric" pattern="[0-9]*"
              placeholder="reps" 
              class="w-[60px] font-semibold sm:w-[80px]"/>

            <UInput 
              v-if="translatedExerciseOptions.find(option => option.value === execution.typeOfExercise)?.add === 'kg'"
              type="number" 
              inputmode="numeric" pattern="[0-9]*"
              v-model="execution.kg" 
              @keyup.enter="addExecution"
              placeholder="kg"
              class="w-[60px] font-semibold sm:w-[80px]"
            />

            <UInput 
              v-if="translatedExerciseOptions.find(option => option.value === execution.typeOfExercise)?.add === 'seconds'"
              type="number" 
              inputmode="numeric" pattern="[0-9]*"
              v-model="execution.seconds" 
              @keyup.enter="addExecution"
              placeholder="sec"
              class="w-[60px] font-semibold sm:w-[80px]"
            />

            <UInput 
              v-if="translatedExerciseOptions.find(option => option.value === execution.typeOfExercise)?.add === 'minutes'"
              type="number" 
              inputmode="numeric" pattern="[0-9]*"
              v-model="execution.minutes" 
              @keyup.enter="addExecution"
              placeholder="min"
              class="w-[60px] font-semibold sm:w-[80px]"
            />
            <UButton v-if="index === executions.length - 1 && execution.set !== null " @click="addExecution">
              <Icon name="i-lucide-plus" class="icon" />
            </UButton>
          </div>

        </div>

      </div>
    </div>
  </div>
</template>

<style scoped>
  .icon {
    color: white;
    margin-top: 2px;
    font-size: 1.3rem;
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

  label {
    font-weight: bold;
  }

/* Media query for smaller screens   */
@media (max-width: 600px) {
  .execution-item {
    grid-template-columns: 1fr;
  }
  
  .execution-form {
    gap: 0.25rem;
  }

}

</style>