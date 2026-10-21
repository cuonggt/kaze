<script setup lang="ts">
import type { Component, HTMLAttributes } from 'vue'
import { reactiveOmit } from '@vueuse/core'
import { Label } from 'reka-ui'
import { cn } from '@/lib/utils'

// Upstream uses reka-ui's LabelProps; see the note in Button.vue for why the
// props are spelled out here instead.
interface Props {
  for?: string
  as?: string | Component
  asChild?: boolean
  class?: HTMLAttributes['class']
}

const props = defineProps<Props>()

const delegatedProps = reactiveOmit(props, 'class')
</script>

<template>
  <Label
    data-slot="label"
    v-bind="delegatedProps"
    :class="
      cn(
        'flex items-center gap-2 text-sm leading-none font-medium select-none group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50 peer-disabled:cursor-not-allowed peer-disabled:opacity-50',
        props.class,
      )
    "
  >
    <slot />
  </Label>
</template>
