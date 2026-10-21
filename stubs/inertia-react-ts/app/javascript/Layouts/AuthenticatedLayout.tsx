import { PropsWithChildren } from 'react'
import AppShell from '@/Components/AppShell'
import AppSidebar from '@/Components/AppSidebar'
import AppSidebarHeader from '@/Components/AppSidebarHeader'
import { SidebarInset } from '@/Components/ui/sidebar'
import { BreadcrumbItem } from '@/types'

export default function AuthenticatedLayout({
  breadcrumbs = [],
  children,
}: PropsWithChildren<{ breadcrumbs?: BreadcrumbItem[] }>) {
  return (
    <AppShell>
      <AppSidebar />

      <SidebarInset className="min-w-0 overflow-x-clip">
        <AppSidebarHeader breadcrumbs={breadcrumbs} />
        {children}
      </SidebarInset>
    </AppShell>
  )
}
