import { PropsWithChildren } from 'react'
import { Link, usePage } from '@inertiajs/react'
import Heading from '@/Components/Heading'
import { Button } from '@/Components/ui/button'
import { Separator } from '@/Components/ui/separator'
import { cn } from '@/lib/utils'
import { appearance_edit_path, password_edit_path, profile_edit_path } from '@/routes'
import { NavItem } from '@/types'

const sidebarNavItems: NavItem[] = [
  {
    title: 'Profile',
    href: profile_edit_path(),
  },
  {
    title: 'Password',
    href: password_edit_path(),
  },
  {
    title: 'Appearance',
    href: appearance_edit_path(),
  },
]

export default function SettingsLayout({ children }: PropsWithChildren) {
  const { url } = usePage()

  return (
    <div className="px-4 py-6">
      <Heading title="Settings" description="Manage your profile and account settings" />

      <div className="flex flex-col lg:flex-row lg:space-x-12">
        <aside className="w-full max-w-xl lg:w-48">
          <nav className="flex flex-col space-y-1 space-x-0" aria-label="Settings">
            {sidebarNavItems.map((item) => (
              <Button
                key={item.href}
                size="sm"
                variant="ghost"
                asChild
                className={cn('w-full justify-start', { 'bg-muted': url.startsWith(item.href) })}
              >
                <Link href={item.href}>{item.title}</Link>
              </Button>
            ))}
          </nav>
        </aside>

        <Separator className="my-6 lg:hidden" />

        <div className="flex-1 md:max-w-2xl">
          <section className="max-w-xl space-y-12">{children}</section>
        </div>
      </div>
    </div>
  )
}
