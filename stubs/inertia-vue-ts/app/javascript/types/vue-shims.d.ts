// Lets plain `tsc` resolve single-file components imported from .ts modules,
// such as the `index.ts` barrels the ui components use. vue-tsc would give
// richer types, but it does not currently run against TypeScript 7.
declare module '*.vue' {
  import type { DefineComponent } from 'vue'

  const component: DefineComponent<Record<string, unknown>, Record<string, unknown>, unknown>

  export default component
}
