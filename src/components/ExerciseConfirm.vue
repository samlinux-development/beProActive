<script lang="ts" setup>
  import { exerciseOptions } from '../utils/exerciseOptions' 
  const { $translate } = useNuxtApp();
  
  // get all option ids for minutes from the exerciseOptions
  const minTypes = exerciseOptions.filter(option => option.add === 'minutes').map(option => Number(option.value));

  interface Exercise {
    'kg' : number,
    'set' : number,
    'seconds' : bigint,
    'typeOfExercise' : number,
    'repetition' : number,
    'minutes'? : bigint | number | undefined
  }
  const props = defineProps<{
    exercise: Exercise;
  }>();

</script>

<template>
  <div>
   
    {{ Number(exercise.set) }} x <span v-if="Number(exercise.repetition) > 0">{{ Number(exercise.repetition) }} </span>
  
    {{$translate(`workout.typeOfExercise${(Number(exercise.typeOfExercise))}`)}}
    <span v-if="Number(exercise.kg) !== 0">{{ Number(exercise.kg) }}  {{$translate('workout.kg')}}</span>
    
    <span v-if="minTypes.includes(Number(exercise.typeOfExercise)) && Number(exercise.minutes) !== 0">
      {{ exercise.minutes }} {{$translate('workout.minutes')}}
    </span>

  </div>
</template>