<script setup lang="ts">
import { ref, type Component } from 'vue'
import { Monitor, Moon, Sun } from '@lucide/vue'
import { getAppearance, setAppearance, type Appearance } from '@/lib/appearance'
import { cn } from '@/lib/utils'

const options: { value: Appearance; icon: Component; label: string }[] = [
  { value: 'light', icon: Sun, label: 'Light' },
  { value: 'dark', icon: Moon, label: 'Dark' },
  { value: 'system', icon: Monitor, label: 'System' },
]

const appearance = ref<Appearance>(getAppearance())

const select = (value: Appearance) => {
  appearance.value = value
  setAppearance(value)
}
</script>

<template>
  <div class="inline-flex gap-1 rounded-lg bg-neutral-100 p-1 dark:bg-neutral-800">
    <button
      v-for="option in options"
      :key="option.value"
      type="button"
      :aria-pressed="appearance === option.value"
      :class="
        cn(
          'flex items-center rounded-md px-3.5 py-1.5 transition-colors outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50',
          appearance === option.value
            ? 'bg-white shadow-xs dark:bg-neutral-700 dark:text-neutral-100'
            : 'text-neutral-500 hover:bg-neutral-200/60 hover:text-black dark:text-neutral-400 dark:hover:bg-neutral-700/60',
        )
      "
      @click="select(option.value)"
    >
      <component :is="option.icon" class="-ml-1 h-4 w-4" />
      <span class="ml-1.5 text-sm">{{ option.label }}</span>
    </button>
  </div>
</template>
