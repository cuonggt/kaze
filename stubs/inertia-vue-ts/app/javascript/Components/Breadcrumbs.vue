<script setup lang="ts">
import { Link } from '@inertiajs/vue3'
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from '@/Components/ui/breadcrumb'
import { BreadcrumbItem as BreadcrumbItemType } from '@/types'

defineProps<{ breadcrumbs: BreadcrumbItemType[] }>()
</script>

<template>
  <Breadcrumb v-if="breadcrumbs.length > 0">
    <BreadcrumbList>
      <template v-for="(item, index) in breadcrumbs" :key="item.href">
        <BreadcrumbItem>
          <BreadcrumbPage v-if="index === breadcrumbs.length - 1">{{ item.title }}</BreadcrumbPage>

          <BreadcrumbLink v-else as-child>
            <Link :href="item.href">{{ item.title }}</Link>
          </BreadcrumbLink>
        </BreadcrumbItem>

        <BreadcrumbSeparator v-if="index !== breadcrumbs.length - 1" />
      </template>
    </BreadcrumbList>
  </Breadcrumb>
</template>
