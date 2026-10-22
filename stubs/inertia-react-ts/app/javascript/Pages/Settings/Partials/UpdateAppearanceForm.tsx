import { useState } from 'react'
import { Appearance, getAppearance, setAppearance } from '@/lib/appearance'

const options: { value: Appearance; label: string }[] = [
  { value: 'light', label: 'Light' },
  { value: 'dark', label: 'Dark' },
  { value: 'system', label: 'System' },
]

export default function UpdateAppearanceForm({ className = '' }: { className?: string }) {
  const [appearance, setCurrentAppearance] = useState<Appearance>(getAppearance)

  const select = (value: Appearance) => {
    setCurrentAppearance(value)
    setAppearance(value)
  }

  return (
    <section className={className}>
      <div className="inline-flex rounded-lg bg-gray-100 p-1 dark:bg-gray-900">
        {options.map((option) => (
          <button
            key={option.value}
            type="button"
            onClick={() => select(option.value)}
            aria-pressed={appearance === option.value}
            className={`rounded-md px-4 py-1.5 text-sm font-medium transition focus:outline-hidden focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 dark:focus:ring-offset-gray-800 ${
              appearance === option.value
                ? 'bg-white text-gray-900 shadow-xs dark:bg-gray-700 dark:text-gray-100'
                : 'text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-100'
            }`}
          >
            {option.label}
          </button>
        ))}
      </div>
    </section>
  )
}
