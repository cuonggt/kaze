export type Appearance = 'light' | 'dark' | 'system'

const STORAGE_KEY = 'appearance'

export function getAppearance(): Appearance {
  const stored = localStorage.getItem(STORAGE_KEY)

  return stored === 'light' || stored === 'dark' ? stored : 'system'
}

export function applyAppearance(appearance: Appearance = getAppearance()): void {
  const dark =
    appearance === 'dark' || (appearance === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches)

  document.documentElement.classList.toggle('dark', dark)
}

export function setAppearance(appearance: Appearance): void {
  localStorage.setItem(STORAGE_KEY, appearance)

  applyAppearance(appearance)
}
