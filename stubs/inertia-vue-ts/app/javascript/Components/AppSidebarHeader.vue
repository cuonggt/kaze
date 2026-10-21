<script setup lang="ts">
import Breadcrumbs from '@/Components/Breadcrumbs.vue'
import { SidebarTrigger } from '@/Components/ui/sidebar'
import { BreadcrumbItem } from '@/types'

withDefaults(defineProps<{ breadcrumbs?: BreadcrumbItem[] }>(), {
  breadcrumbs: () => [],
})
</script>

<template>
  <header
    class="flex h-16 shrink-0 items-center gap-2 border-b border-sidebar-border/50 px-6 transition-[width,height] ease-linear group-has-data-[collapsible=icon]/sidebar-wrapper:h-12 md:px-4"
  >
    <div class="flex items-center gap-2">
      <SidebarTrigger class="-ml-1" />
      <Breadcrumbs :breadcrumbs="breadcrumbs" />
    </div>
  </header>
</template>
