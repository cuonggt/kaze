<script setup lang="ts">
import { Link, usePage } from '@inertiajs/vue3'
import {
  SidebarGroup,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from '@/Components/ui/sidebar'
import { NavItem } from '@/types'

defineProps<{ items: NavItem[] }>()

const page = usePage()
</script>

<template>
  <SidebarGroup class="px-2 py-0">
    <SidebarGroupLabel>Platform</SidebarGroupLabel>

    <SidebarMenu>
      <SidebarMenuItem v-for="item in items" :key="item.title">
        <SidebarMenuButton as-child :is-active="page.url.startsWith(item.href)" :tooltip="item.title">
          <Link :href="item.href">
            <component :is="item.icon" v-if="item.icon" />
            <span>{{ item.title }}</span>
          </Link>
        </SidebarMenuButton>
      </SidebarMenuItem>
    </SidebarMenu>
  </SidebarGroup>
</template>
