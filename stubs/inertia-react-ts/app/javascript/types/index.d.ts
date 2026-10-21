import { LucideIcon } from 'lucide-react'

export interface User {
  id: number
  name: string
  email: string
  email_verified_at?: string
}

export interface NavItem {
  title: string
  href: string
  icon?: LucideIcon
}

export interface BreadcrumbItem {
  title: string
  href: string
}

export type PageProps<T extends Record<string, unknown> = Record<string, unknown>> = T & {
  auth: {
    user: User
  }
  sidebar_open: boolean
}
