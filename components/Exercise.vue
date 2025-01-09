<script lang="ts" setup>
  const { $translate } = useNuxtApp();

  defineProps<{
    exercise: {
      typeOfExercise: number;
      set: number;
      repetition: number;
      kg: number;
    };
  }>();

</script>

<template>
  <div>
    {{ Number(exercise.set) }} x <span v-if="Number(exercise.kg) !== 0">{{ Number(exercise.repetition) }} </span>
  
    {{$translate(`workout.typeOfExercise${(Number(exercise.typeOfExercise))}`)}}
    <span v-if="Number(exercise.kg) !== 0">{{ Number(exercise.kg) }}  {{$translate('workout.kg')}}</span>
    <span v-if="Number(exercise.seconds) !== 0">{{ Number(exercise.seconds) }} {{$translate('workout.seconds')}} </span>
  </div>
</template>

<style scoped>

</style>