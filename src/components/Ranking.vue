<script lang="ts" setup>
  import type { TableColumn } from '@nuxt/ui';
  import type { GetRankingResponse } from '../declarations/backend/backend.did.js';

  const { $translate, $getActor } = useNuxtApp() as any;
  const sportsmanData = ref<GetRankingResponse[]>([]);
  const isLoading = ref(true);
  const UButton = resolveComponent('UButton')

  const rankingTableColumn: TableColumn<GetRankingResponse>[] = [
    {
      accessorKey: 'alias',
      header: () => $translate('profile.friends-sidebar-friend-list-header-alias'),
    },
    {
      accessorKey: 'totalWorkouts',
      header: ({column}) => {
        const isSorted = column.getIsSorted()
        return h(UButton, {
          color: 'neutral',
          variant: 'ghost',
          label: $translate('profile.friends-sidebar-friend-list-header-workouts'),
          icon: isSorted
            ? isSorted === 'asc'
              ? 'i-lucide-arrow-up-narrow-wide'
              : 'i-lucide-arrow-down-wide-narrow'
            : 'i-lucide-arrow-up-down',
          class: '-mx-2.5',
          onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
        })
      },
    },
    {
      accessorKey: 'points',
      header: ({column}) => {
        const isSorted = column.getIsSorted()
        
        return h(UButton, {
          color: 'neutral',
          variant: 'ghost',
          label: $translate('profile.friends-sidebar-friend-list-header-points'),
          icon: isSorted
            ? isSorted === 'asc'
              ? 'i-lucide-arrow-up-narrow-wide'
              : 'i-lucide-arrow-down-wide-narrow'
            : 'i-lucide-arrow-up-down',
          class: '-mx-2.5',
          onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
        })
      },
    }
  ];

  onMounted(async () => {
    try {
      
      const actor = await $getActor({}, true);
      const ranking = await actor.getRanking();

      sportsmanData.value = ranking;
      sportsmanData.value = ranking.map((item:GetRankingResponse) => ({
        alias: item.alias,
        totalWorkouts: item.totalWorkouts,
        points: item.points
      }));

      // sort by points
      sportsmanData.value.sort((a, b) => Number(b.points) - Number(a.points));
      console.log(sportsmanData.value)
      isLoading.value = false;
    } catch (error) {
      console.error("Error fetching workouts per principal:", error);
    }
  });
  
</script>
<template>
  <div>
    <h1>{{ $translate('ranking.title') }}</h1>
    <div>{{ $translate('ranking.desc') }}</div>
    <div v-if="isLoading"> <Spinner /> </div>
    <div v-else>
      <UTable class="table-container" :data="sportsmanData" :columns="rankingTableColumn" />
    </div>
  </div>
</template>
