import { useState, PropsWithChildren, ReactNode } from 'react'
import ApplicationLogo from '@/Components/ApplicationLogo'
import NavLink from '@/Components/NavLink'
import { Button } from '@/Components/ui/button'
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from '@/Components/ui/dropdown-menu'
import { ChevronDownIcon } from 'lucide-react'
import ResponsiveNavLink from '@/Components/ResponsiveNavLink'
import { Link, usePage } from '@inertiajs/react'
import { dashboard_path, logout_path, profile_edit_path } from '@/routes'

export default function AuthenticatedLayout({ header, children }: PropsWithChildren<{ header?: ReactNode }>) {
  const user = usePage().props.auth.user

  const [showingNavigationDropdown, setShowingNavigationDropdown] = useState(false)

  const { pathname = '' } = typeof window !== 'undefined' ? window.location : {}

  return (
    <div className="min-h-screen bg-gray-100 dark:bg-gray-900">
      <nav className="bg-white dark:bg-gray-800 border-b border-gray-100 dark:border-gray-700">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex">
              <div className="shrink-0 flex items-center">
                <Link href="/">
                  <ApplicationLogo className="block h-9 w-auto fill-current text-red-800 dark:text-red-200" />
                </Link>
              </div>

              <div className="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
                <NavLink href={dashboard_path()} active={pathname.match(/dashboard/) != null}>
                  Dashboard
                </NavLink>
              </div>
            </div>

            <div className="hidden sm:flex sm:items-center sm:ms-6">
              <div className="ms-3 relative">
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" className="text-muted-foreground">
                      {user.name}
                      <ChevronDownIcon />
                    </Button>
                  </DropdownMenuTrigger>

                  <DropdownMenuContent align="end">
                    <DropdownMenuItem asChild>
                      <Link href={profile_edit_path()}>Profile</Link>
                    </DropdownMenuItem>

                    <DropdownMenuItem asChild>
                      <Link href={logout_path()} method="post" as="button" className="w-full">
                        Log Out
                      </Link>
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </div>
            </div>

            <div className="-me-2 flex items-center sm:hidden">
              <button
                onClick={() => setShowingNavigationDropdown((previousState) => !previousState)}
                className="inline-flex items-center justify-center p-2 rounded-md text-gray-400 dark:text-gray-500 hover:text-gray-500 dark:hover:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-900 focus:outline-hidden focus:bg-gray-100 dark:focus:bg-gray-900 focus:text-gray-500 dark:focus:text-gray-400 transition duration-150 ease-in-out"
              >
                <svg className="h-6 w-6" stroke="currentColor" fill="none" viewBox="0 0 24 24">
                  <path
                    className={!showingNavigationDropdown ? 'inline-flex' : 'hidden'}
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                  <path
                    className={showingNavigationDropdown ? 'inline-flex' : 'hidden'}
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>
          </div>
        </div>

        <div className={(showingNavigationDropdown ? 'block' : 'hidden') + ' sm:hidden'}>
          <div className="pt-2 pb-3 space-y-1">
            <ResponsiveNavLink href={dashboard_path()} active={pathname.match(/dashboard/) != null}>
              Dashboard
            </ResponsiveNavLink>
          </div>

          <div className="pt-4 pb-1 border-t border-gray-200 dark:border-gray-600">
            <div className="px-4">
              <div className="font-medium text-base text-gray-800 dark:text-gray-200">{user.name}</div>
              <div className="font-medium text-sm text-gray-500">{user.email}</div>
            </div>

            <div className="mt-3 space-y-1">
              <ResponsiveNavLink href={profile_edit_path()}>Profile</ResponsiveNavLink>
              <ResponsiveNavLink method="post" href={logout_path()} as="button">
                Log Out
              </ResponsiveNavLink>
            </div>
          </div>
        </div>
      </nav>

      {header && (
        <header className="bg-white dark:bg-gray-800 shadow-sm">
          <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">{header}</div>
        </header>
      )}

      <main>{children}</main>
    </div>
  )
}
