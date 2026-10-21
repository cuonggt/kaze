import { useCallback } from 'react'

export type CleanupFn = () => void

export function useMobileNavigation(): CleanupFn {
  return useCallback(() => {
    // The dropdown leaves pointer-events on the body when it closes during a
    // page change, which would make the new page unclickable.
    document.body.style.removeProperty('pointer-events')
  }, [])
}
