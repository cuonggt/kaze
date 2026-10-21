import { PropsWithChildren } from 'react'
import { usePage } from '@inertiajs/react'
import { SidebarProvider } from '@/Components/ui/sidebar'

export default function AppShell({ children }: PropsWithChildren) {
  const sidebarOpen = usePage().props.sidebar_open

  return <SidebarProvider defaultOpen={sidebarOpen}>{children}</SidebarProvider>
}
