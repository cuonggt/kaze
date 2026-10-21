import { Link, router } from '@inertiajs/react'
import { LogOut, Settings } from 'lucide-react'
import {
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
} from '@/Components/ui/dropdown-menu'
import UserInfo from '@/Components/UserInfo'
import { useMobileNavigation } from '@/hooks/use-mobile-navigation'
import { logout_path, profile_edit_path } from '@/routes'
import { User } from '@/types'

export default function UserMenuContent({ user }: { user: User }) {
  const cleanup = useMobileNavigation()

  const handleLogout = () => {
    cleanup()
    router.flushAll()
  }

  return (
    <>
      <DropdownMenuLabel className="p-0 font-normal">
        <div className="flex items-center gap-2 px-1 py-1.5 text-left text-sm">
          <UserInfo user={user} showEmail />
        </div>
      </DropdownMenuLabel>

      <DropdownMenuSeparator />

      <DropdownMenuGroup>
        <DropdownMenuItem asChild>
          <Link className="block w-full cursor-pointer" href={profile_edit_path()} prefetch onClick={cleanup}>
            <Settings className="mr-2" />
            Settings
          </Link>
        </DropdownMenuItem>
      </DropdownMenuGroup>

      <DropdownMenuSeparator />

      <DropdownMenuItem asChild>
        <Link
          className="block w-full cursor-pointer"
          href={logout_path()}
          method="post"
          as="button"
          onClick={handleLogout}
        >
          <LogOut className="mr-2" />
          Log out
        </Link>
      </DropdownMenuItem>
    </>
  )
}
