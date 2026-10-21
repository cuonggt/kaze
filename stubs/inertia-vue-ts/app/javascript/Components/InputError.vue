<script setup lang="ts">
defineProps<{
  message?: string
}>()
</script>

<template>
  <div v-show="message">
    <p class="text-sm text-destructive">
      {{ message }}
    </p>
  </div>
</template>
