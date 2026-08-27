import { join } from 'node:path'

import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

const srcDir = join(import.meta.dirname, './src')
const publicDir = join(import.meta.dirname, './public')

export default defineConfig(({ command }) => {
  const devMode = command === 'serve'

  return {
    root: srcDir,
    publicDir: false,
    plugins: [react()],
    build: {
      emptyOutDir: false,
      outDir: publicDir,
      rolldownOptions: {
        input: { main: join(srcDir, './index.html') },
        output: {
          entryFileNames: 'assets/[name]-[hash].js',
          chunkFileNames: 'assets/[name]-[hash].js',
          assetFileNames: 'assets/[name]-[hash].[ext]',
        },
      },
    },
    resolve: {
      alias: [{ find: '@', replacement: srcDir }],
    },
    server: devMode
      ? {
          hmr: true,
          port: 3001,
          host: '0.0.0.0',
          proxy: {
            '/api': {
              target: 'http://localhost:3000',
              changeOrigin: true,
              rewrite: (path: string) => path.replace(/^\/api/, ''),
            },
          },
        }
      : undefined,
  }
})
