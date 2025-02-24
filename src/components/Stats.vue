<script lang="ts" setup>
  import { formatDuration, getWeekNumberAndYear } from '../../src/utils/helper';
  import type { TableColumn } from '@nuxt/ui'

  const { $translate, $getActor } = useNuxtApp() as any;

  // WHO recommends at least 150 minutes of moderate-intensity or 75 minutes of vigorous-intensity physical activity per week
  const whoRecommendationForMovement = 150;

  type WeekStats = {
    week: string;
    totalWorkouts: bigint;
    totalDuration: string;
    whoGap: string;
  }

  const isLoading = ref(true);
  const data = ref<WeekStats[]>([]);
  const columns: TableColumn<WeekStats>[] = [
    {
      accessorKey: 'week',
      header: $translate('stats.week')
    },
    {
      accessorKey: 'totalDuration',
      header: $translate('stats.duration')
    },
    {
      accessorKey: 'whoGap',
      header: $translate('stats.whoGap'),
      cell: (info) => {
        const value = info.getValue();
        const isMet = value === 'Met';
        return h('span', { class: isMet ? 'text-green-500' : 'text-red-500' }, value as string);
      }
    },
    {
      accessorKey: 'totalWorkouts',
      header: $translate('stats.workouts')
    }
  ]
  
  onMounted(async () => {
    await getUserWeeklyStats();
    isLoading.value = false;
  });

  const getUserWeeklyStats = async () => {
    const actor = await $getActor({}, true);
    if (actor) {
      const result = await actor.getUserWeeklyStats();
      
      // sort result by week
      result.sort((a: [bigint, any], b: [bigint, any]) => {
        return Number(b[0] - a[0]);
      });
      
      // map data
      data.value = result.map((item:[bigint, { totalDuration: string, totalWorkouts: bigint }]) => {
        // Convert nanoseconds to minutes
        const totalDurationMinutes = Number(BigInt(item[1].totalDuration) / BigInt(60 * 1_000)); 

        //console.log('totalDurationMinutes: ', totalDurationMinutes, item[1].totalDuration);
       
        const whoGap = totalDurationMinutes >= whoRecommendationForMovement 
          ? 'Met' 
          : `${whoRecommendationForMovement - totalDurationMinutes} min`;

      return {
        week: getWeekNumberAndYear(Number(item[0])),
        totalWorkouts: item[1].totalWorkouts,
        totalDuration: formatDuration(BigInt(item[1].totalDuration)),
        whoGap: whoGap
      };
    });
    }
    
    //console.log('data: ',data.value);
  };

</script>

<template>
  <div>
    <h1>{{ $translate('stats.title') }}</h1>
    <div>{{ $translate('stats.desc') }}</div>
    <div v-if="isLoading"> <Spinner /> </div>
    <div v-else>
      <UTable class="table-container" :data="data" :columns="columns" /> 
    </div>
  </div>
</template>
