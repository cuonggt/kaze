<script setup lang="ts">
import { Avatar, AvatarFallback } from '@/Components/ui/avatar'
import { useInitials } from '@/composables/useInitials'
import { User } from '@/types'

withDefaults(defineProps<{ user: User; showEmail?: boolean }>(), {
  showEmail: false,
})

const { getInitials } = useInitials()
</script>

<template>
  <Avatar class="h-8 w-8 overflow-hidden rounded-full">
    <AvatarFallback class="rounded-lg bg-neutral-200 text-black dark:bg-neutral-700 dark:text-white">
      {{ getInitials(user.name) }}
    </AvatarFallback>
  </Avatar>

  <div class="grid flex-1 text-left text-sm leading-tight">
    <span class="truncate font-medium">{{ user.name }}</span>

    <span v-if="showEmail" class="truncate text-xs text-muted-foreground">{{ user.email }}</span>
  </div>
</template>
