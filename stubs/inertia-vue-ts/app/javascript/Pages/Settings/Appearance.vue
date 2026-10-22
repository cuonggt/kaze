<script setup lang="ts">
import { Head } from '@inertiajs/vue3'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import SettingsLayout from '@/Layouts/SettingsLayout.vue'
import Heading from '@/Components/Heading.vue'
import UpdateAppearanceForm from './Partials/UpdateAppearanceForm.vue'
import { appearance_edit_path } from '@/routes'
import { BreadcrumbItem } from '@/types'

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Appearance settings',
    href: appearance_edit_path(),
  },
]
</script>

<template>
  <Head title="Appearance settings" />

  <AuthenticatedLayout :breadcrumbs="breadcrumbs">
    <SettingsLayout>
      <div class="space-y-6">
        <Heading
          variant="small"
          title="Appearance settings"
          description="Update the appearance settings for your account"
        />
        <UpdateAppearanceForm />
      </div>
    </SettingsLayout>
  </AuthenticatedLayout>
</template>
