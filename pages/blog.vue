<script setup lang="ts">
const allPosts = await queryCollection('blog').order('date', 'DESC').all();
//console.log(allPosts);
const { $translate } = useNuxtApp();

useSeoMeta({
  title: $translate('blog.title'),
  description: $translate('blog.description'),
})
</script>

<template>
  <div class="blog">
    <h1>{{ $translate('blog.title') }}</h1>
    <p>{{ $translate('blog.description') }}</p>
  </div>
  <div v-for="post in allPosts" :key="post.id">
    <UCard class="bg-gray-100">
      <template #header>
        <div class="flex flex-col">
          <h2 class="color" style="margin:0">{{ post.title }}</h2>
          <div class="italic desc">{{ post.date }}</div>
        </div>
      </template>
    
      <ContentRenderer :value="post" :prose="false" class="content"/>
    </UCard>
  </div>
  
</template>

<style>

.content h2 {
  color: rgb(83, 190, 85, 1);
  text-decoration: none;
  margin-bottom: 1rem;
}

.color {
  color: rgb(52, 139, 54, 1);
}

.desc {
  color: rgb(52, 139, 54, 1);
}
.content ul {
  list-style-type: disc;
  padding-left: 1rem;
  margin-bottom: 1rem;
}

.content p {
  margin-top:1rem;
}

</style>
