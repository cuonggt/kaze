<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import DeleteUserForm from './Partials/DeleteUserForm.vue'
import UpdateAppearanceForm from './Partials/UpdateAppearanceForm.vue'
import UpdatePasswordForm from './Partials/UpdatePasswordForm.vue'
import UpdateProfileInformationForm from './Partials/UpdateProfileInformationForm.vue'
import { Head } from '@inertiajs/vue3'
import { profile_edit_path } from '@/routes'
import { BreadcrumbItem } from '@/types'

defineProps<{
  mustVerifyEmail?: boolean
  status?: string
}>()

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Profile',
    href: profile_edit_path(),
  },
]
</script>

<template>
  <Head title="Profile" />

  <AuthenticatedLayout :breadcrumbs="breadcrumbs">
    <div class="flex h-full flex-1 flex-col gap-6 p-4">
      <div class="rounded-xl border border-sidebar-border/70 p-4 sm:p-8 dark:border-sidebar-border">
        <UpdateAppearanceForm class="max-w-xl" />
      </div>

      <div class="rounded-xl border border-sidebar-border/70 p-4 sm:p-8 dark:border-sidebar-border">
        <UpdateProfileInformationForm :must-verify-email="mustVerifyEmail" :status="status" class="max-w-xl" />
      </div>

      <div class="rounded-xl border border-sidebar-border/70 p-4 sm:p-8 dark:border-sidebar-border">
        <UpdatePasswordForm class="max-w-xl" />
      </div>

      <div class="rounded-xl border border-sidebar-border/70 p-4 sm:p-8 dark:border-sidebar-border">
        <DeleteUserForm class="max-w-xl" />
      </div>
    </div>
  </AuthenticatedLayout>
</template>
