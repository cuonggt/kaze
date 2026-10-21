import fs from 'node:fs'
import { defineConfig } from 'vite'
import Rails from 'vite-plugin-rails'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  resolve: {
    dedupe: ['axios'],
  },
  plugins: [
    Rails(),
    vue({
      script: {
        // Components that type their props from another package -- the ui
        // primitives do this with reka-ui -- need the SFC compiler to read
        // files to resolve those types. It does not assume filesystem access,
        // so hand it one.
        fs: {
          // statSync, not existsSync: a barrel import like `from "."` probes the
          // directory itself, and claiming it exists makes the compiler try to
          // read a directory.
          fileExists: (file: string) => {
            try {
              return fs.statSync(file).isFile()
            } catch {
              return false
            }
          },
          readFile: (file: string) => fs.readFileSync(file, 'utf-8'),
        },
      },
    }),
  ],
})
