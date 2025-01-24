<script lang="ts" setup>
  import { exerciseOptions } from '../utils/exerciseOptions' 
  const { $translate } = useNuxtApp();
  
  // get all option ids for minutes from the exerciseOptions
  const minTypes = exerciseOptions.filter(option => option.add === 'minutes').map(option => Number(option.value));

  interface Exercise {
    typeOfExercise: number | null;
    set: number | null;
    repetition: number | null;
    kg: number | null;
    seconds: bigint | null;
  }
  const props = defineProps<{
    exercise: Exercise;
  }>();

  // compute the minutes
  const minutes = computed(() => {
    if (minTypes.includes(Number(props.exercise.typeOfExercise)) && Number(props.exercise.seconds) !== 0) {
      return Number(props.exercise.seconds) / 60;
    }
    return 0;
  });

</script>

<template>
  <div>
    
    {{ Number(exercise.set) }} x <span v-if="Number(exercise.repetition) > 0">{{ Number(exercise.repetition) }} </span>
  
    {{$translate(`workout.typeOfExercise${(Number(exercise.typeOfExercise))}`)}}
    <span v-if="Number(exercise.kg) !== 0">{{ Number(exercise.kg) }}  {{$translate('workout.kg')}}</span>
    
    <span v-if="minTypes.includes(Number(exercise.typeOfExercise)) && Number(exercise.seconds) !== 0">
      {{ minutes }} {{$translate('workout.minutes')}}
    </span>
    <span v-else-if="Number(exercise.seconds) !== 0">{{ Number(exercise.seconds) }}  {{$translate('workout.seconds')}}</span>
  
  </div>
</template>