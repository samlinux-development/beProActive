<script setup lang="ts">
import data from '~/src/data/content.json';
const { $translate } = useNuxtApp();

interface Post {
  id: number;
  title: string;
  date: string;
  content: string;
  slug: string;

}
const allPosts = ref<Post[]>(data.map((post, index) => ({ ...post, id: index })));

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
          <h2 class="color" style="margin:0"><a class="blogTitle" :id="String(post.id)"> {{ post.title }} </a></h2>
          <div class="italic desc">{{ post.date }}</div>
        </div>
      </template>
     
      <div class="content">
          <div v-html="post.content"></div>
      </div>

    </UCard>
  </div>
  
</template>

<style>

.content h2 {
  color: rgb(83, 190, 85, 1);
  text-decoration: none;
  margin-bottom: 1rem;
}

.blogTitle {
  color: rgb(83, 190, 85, 1);
  text-decoration: none;
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
