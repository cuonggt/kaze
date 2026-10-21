<script setup lang="ts">
import AppShell from '@/Components/AppShell.vue'
import AppSidebar from '@/Components/AppSidebar.vue'
import AppSidebarHeader from '@/Components/AppSidebarHeader.vue'
import { SidebarInset } from '@/Components/ui/sidebar'
import { BreadcrumbItem } from '@/types'

withDefaults(defineProps<{ breadcrumbs?: BreadcrumbItem[] }>(), {
  breadcrumbs: () => [],
})
</script>

<template>
  <AppShell>
    <AppSidebar />

    <SidebarInset class="min-w-0 overflow-x-clip">
      <AppSidebarHeader :breadcrumbs="breadcrumbs" />
      <slot />
    </SidebarInset>
  </AppShell>
</template>
