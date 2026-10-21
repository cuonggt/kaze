<script setup lang="ts">
import { usePage } from '@inertiajs/vue3'
import { SidebarProvider } from '@/Components/ui/sidebar'

const sidebarOpen = usePage().props.sidebar_open
</script>

<template>
  <SidebarProvider :default-open="sidebarOpen">
    <slot />
  </SidebarProvider>
</template>
