import { useState } from 'react'
import { LucideIcon, Monitor, Moon, Sun } from 'lucide-react'
import { Appearance, getAppearance, setAppearance } from '@/lib/appearance'
import { cn } from '@/lib/utils'

const options: { value: Appearance; icon: LucideIcon; label: string }[] = [
  { value: 'light', icon: Sun, label: 'Light' },
  { value: 'dark', icon: Moon, label: 'Dark' },
  { value: 'system', icon: Monitor, label: 'System' },
]

export default function UpdateAppearanceForm({ className = '' }: { className?: string }) {
  const [appearance, setCurrentAppearance] = useState<Appearance>(getAppearance)

  const select = (value: Appearance) => {
    setCurrentAppearance(value)
    setAppearance(value)
  }

  return (
    <div className={cn('inline-flex gap-1 rounded-lg bg-neutral-100 p-1 dark:bg-neutral-800', className)}>
      {options.map(({ value, icon: Icon, label }) => (
        <button
          key={value}
          type="button"
          onClick={() => select(value)}
          aria-pressed={appearance === value}
          className={cn(
            'flex items-center rounded-md px-3.5 py-1.5 transition-colors outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50',
            appearance === value
              ? 'bg-white shadow-xs dark:bg-neutral-700 dark:text-neutral-100'
              : 'text-neutral-500 hover:bg-neutral-200/60 hover:text-black dark:text-neutral-400 dark:hover:bg-neutral-700/60',
          )}
        >
          <Icon className="-ml-1 h-4 w-4" />
          <span className="ml-1.5 text-sm">{label}</span>
        </button>
      ))}
    </div>
  )
}
