<template>
  <div class="flex flex-row items-center ">
    <div class="text-xl font-semibold mr-2"> {{ formattedTime }} </div>
    <div class="flex space-x-2">
      <!-- Start Button -->
      <UButton
        size="sm"
        color="primary"
        @click="start"
        :disabled="isRunning"
      >
        <Icon name="i-lucide-play" class="icon" />
      </UButton>

      <!-- Stop Button -->
      <UButton
        size="sm"
        color="warning"
        @click="stop"
        :disabled="!isRunning"
      >
        <Icon name="i-lucide-pause" class="icon" />
      </UButton>

      <!-- Reset Button -->
      <UButton
        size="sm"
        color="error"
        @click="reset"
        :disabled="!time"
      >
        <Icon name="i-lucide-timer-reset" class="icon" />
      </UButton>
    </div>
  </div>
</template>

<script setup>
  import { ref } from 'vue';

  const time = ref(0); // Time in milliseconds
  const timer = ref(null); // Timer ID
  const isRunning = ref(false);

  // Computed property to format the time into HH:MM:SS
  const formattedTime = computed(() => {
    const hours = Math.floor(time.value / 3600000);
    const minutes = Math.floor((time.value % 3600000) / 60000);
    const seconds = Math.floor((time.value % 60000) / 1000);
    return [
      hours.toString().padStart(2, '0'),
      minutes.toString().padStart(2, '0'),
      seconds.toString().padStart(2, '0'),
    ].join(':');
  });

  // Start the stopwatch
  const start = () => {
    if (isRunning.value) return;
    isRunning.value = true;
    timer.value = setInterval(() => {
      time.value += 1000;
    }, 1000);
  };

  // Stop the stopwatch
  const stop = () => {
    if (!isRunning.value) return;
    isRunning.value = false;
    clearInterval(timer.value);
  };

  // Reset the stopwatch
  const reset = () => {
    stop();
    time.value = 0;
  };

  // Expose methods to parent component
  defineExpose({
    start,
    stop,
    reset,
    time
  });

</script>

<style scoped>
 .icon {
    font-size: 1rem;
    color: white;
  }
</style>