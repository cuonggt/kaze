<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import { Head } from '@inertiajs/vue3'
import { dashboard_path } from '@/routes'
import { BreadcrumbItem } from '@/types'

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Dashboard',
    href: dashboard_path(),
  },
]
</script>

<template>
  <Head title="Dashboard" />

  <AuthenticatedLayout :breadcrumbs="breadcrumbs">
    <div class="flex h-full flex-1 flex-col gap-4 rounded-xl p-4">
      <div
        class="relative min-h-[60vh] flex-1 overflow-hidden rounded-xl border border-sidebar-border/70 p-6 dark:border-sidebar-border"
      >
        You're logged in!
      </div>
    </div>
  </AuthenticatedLayout>
</template>
