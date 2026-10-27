<script setup lang="ts">
import GuestLayout from '@/Layouts/GuestLayout.vue'
import { Button } from '@/Components/ui/button'
import { Input } from '@/Components/ui/input'
import { Label } from '@/Components/ui/label'
import InputError from '@/Components/InputError.vue'
import { Head, useForm } from '@inertiajs/vue3'
import { two_factor_challenge_store_path } from '@/routes'

const form = useForm({
  code: '',
  recovery_code: '',
})
</script>

<template>
  <GuestLayout>
    <Head title="Two factor authentication" />

    <div class="mb-4 text-sm text-muted-foreground">
      Enter the code from your authenticator app to finish signing in.
    </div>

    <form @submit.prevent="form.post(two_factor_challenge_store_path())">
      <div>
        <Label for="code">Code</Label>

        <Input
          id="code"
          v-model="form.code"
          name="code"
          class="mt-1 block w-full"
          inputmode="numeric"
          autocomplete="one-time-code"
          autofocus
        />

        <InputError :message="form.errors.code" class="mt-2" />
      </div>

      <div class="mt-4">
        <Label for="recovery_code">Or a recovery code</Label>

        <Input
          id="recovery_code"
          v-model="form.recovery_code"
          name="recovery_code"
          class="mt-1 block w-full"
          autocomplete="one-time-code"
        />

        <InputError :message="form.errors.recovery_code" class="mt-2" />
      </div>

      <div class="flex items-center justify-end mt-4">
        <Button class="ms-4" :class="{ 'opacity-25': form.processing }" :disabled="form.processing"> Continue </Button>
      </div>
    </form>
  </GuestLayout>
</template>
