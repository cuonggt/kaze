import './bootstrap'
import '../../assets/builds/tailwind.css'

import { createRoot } from 'react-dom/client'
import { createInertiaApp, type ResolvedComponent } from '@inertiajs/react'
import { TooltipProvider } from '@/Components/ui/tooltip'

const pages = import.meta.glob<{ default: ResolvedComponent }>('../Pages/**/*.tsx')

async function resolvePageComponent(name: string): Promise<ResolvedComponent> {
  const page = pages[`../Pages/${name}.tsx`]

  if (typeof page === 'undefined') {
    throw new Error(`Page not found: ${name}`)
  }

  return (await page()).default
}

const appName = import.meta.env.VITE_APP_NAME || 'Rails'

createInertiaApp({
  title: (title) => `${title} - ${appName}`,
  resolve: resolvePageComponent,
  setup({ el, App, props }) {
    const root = createRoot(el)

    root.render(
      <TooltipProvider delayDuration={0}>
        <App {...props} />
      </TooltipProvider>,
    )
  },
  progress: {
    color: '#4B5563',
  },
})
