<script setup lang="ts">
import type { HTMLAttributes } from 'vue'
import { Check } from '@lucide/vue'
import { CheckboxIndicator, CheckboxRoot } from 'reka-ui'
import { cn } from '@/lib/utils'

// Upstream forwards reka-ui's CheckboxRootProps and CheckboxRootEmits. The SFC
// compiler cannot resolve types imported across packages in this build, so the
// props the scaffolded forms rely on are declared here instead.
interface Props {
  modelValue?: boolean | 'indeterminate'
  defaultValue?: boolean | 'indeterminate'
  disabled?: boolean
  name?: string
  required?: boolean
  value?: string
  id?: string
  class?: HTMLAttributes['class']
}

const props = defineProps<Props>()

const emits = defineEmits<{
  (e: 'update:modelValue', payload: boolean | 'indeterminate'): void
}>()
</script>

<template>
  <CheckboxRoot
    data-slot="checkbox"
    :model-value="props.modelValue"
    :default-value="props.defaultValue"
    :disabled="props.disabled"
    :name="props.name"
    :required="props.required"
    :value="props.value"
    :id="props.id"
    :class="
      cn(
        'peer border-input data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground data-[state=checked]:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50',
        props.class,
      )
    "
    @update:model-value="emits('update:modelValue', $event)"
  >
    <CheckboxIndicator data-slot="checkbox-indicator" class="grid place-content-center text-current transition-none">
      <slot>
        <Check class="size-3.5" />
      </slot>
    </CheckboxIndicator>
  </CheckboxRoot>
</template>
