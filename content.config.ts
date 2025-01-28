import { Title } from '#build/components'
import { defineCollection, defineContentConfig, z } from '@nuxt/content'

export default defineContentConfig({
  collections: {
    blog: defineCollection({
      type: 'page',
      source: '**/*.md',
      schema: z.object({
        date: z.string(),
        titel: z.string()
      })
    })
  }
})