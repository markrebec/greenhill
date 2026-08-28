import { join } from 'node:path'

import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import ViteRuby from 'vite-plugin-ruby'

const srcDir = join(import.meta.dirname, './src')

export default defineConfig({
  plugins: [ViteRuby(), react()],
  resolve: {
    alias: [{ find: '@', replacement: srcDir }],
  },
})
