<script setup lang="ts">
import { Head } from '@inertiajs/vue3'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import SettingsLayout from '@/Layouts/SettingsLayout.vue'
import Heading from '@/Components/Heading.vue'
import DeleteUserForm from './Partials/DeleteUserForm.vue'
import UpdateProfileInformationForm from './Partials/UpdateProfileInformationForm.vue'
import { profile_edit_path } from '@/routes'
import { BreadcrumbItem } from '@/types'

defineProps<{
  mustVerifyEmail?: boolean
  status?: string
}>()

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Profile settings',
    href: profile_edit_path(),
  },
]
</script>

<template>
  <Head title="Profile settings" />

  <AuthenticatedLayout :breadcrumbs="breadcrumbs">
    <SettingsLayout>
      <div class="space-y-6">
        <Heading variant="small" title="Profile information" description="Update your name and email address" />
        <UpdateProfileInformationForm :must-verify-email="mustVerifyEmail" :status="status" />
      </div>

      <div class="space-y-6">
        <Heading variant="small" title="Delete account" description="Delete your account and all of its resources" />
        <DeleteUserForm />
      </div>
    </SettingsLayout>
  </AuthenticatedLayout>
</template>
