<script setup lang="ts">
import { ref } from 'vue'
import { getAppearance, setAppearance, type Appearance } from '@/lib/appearance'

const options: { value: Appearance; label: string }[] = [
  { value: 'light', label: 'Light' },
  { value: 'dark', label: 'Dark' },
  { value: 'system', label: 'System' },
]

const appearance = ref<Appearance>(getAppearance())

const select = (value: Appearance) => {
  appearance.value = value
  setAppearance(value)
}
</script>

<template>
  <section>
    <header>
      <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">Appearance</h2>

      <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
        Choose how the application looks to you. System follows your device setting.
      </p>
    </header>

    <div class="mt-6 inline-flex rounded-lg bg-gray-100 p-1 dark:bg-gray-900">
      <button
        v-for="option in options"
        :key="option.value"
        type="button"
        :aria-pressed="appearance === option.value"
        class="rounded-md px-4 py-1.5 text-sm font-medium transition focus:outline-hidden focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 dark:focus:ring-offset-gray-800"
        :class="
          appearance === option.value
            ? 'bg-white text-gray-900 shadow-xs dark:bg-gray-700 dark:text-gray-100'
            : 'text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-100'
        "
        @click="select(option.value)"
      >
        {{ option.label }}
      </button>
    </div>
  </section>
</template>
