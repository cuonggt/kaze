<script setup lang="ts">
import {
  SidebarGroup,
  SidebarGroupContent,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from '@/Components/ui/sidebar'
import { cn } from '@/lib/utils'
import { NavItem } from '@/types'

const props = defineProps<{ items: NavItem[]; class?: string }>()
</script>

<template>
  <SidebarGroup :class="cn('group-data-[collapsible=icon]:p-0', props.class)">
    <SidebarGroupContent>
      <SidebarMenu>
        <SidebarMenuItem v-for="item in items" :key="item.title">
          <SidebarMenuButton
            as-child
            class="text-neutral-600 hover:text-neutral-800 dark:text-neutral-300 dark:hover:text-neutral-100"
          >
            <a :href="item.href" target="_blank" rel="noopener noreferrer">
              <component :is="item.icon" v-if="item.icon" class="h-5 w-5" />
              <span>{{ item.title }}</span>
            </a>
          </SidebarMenuButton>
        </SidebarMenuItem>
      </SidebarMenu>
    </SidebarGroupContent>
  </SidebarGroup>
</template>
