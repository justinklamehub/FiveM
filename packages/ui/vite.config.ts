import { fileURLToPath, URL } from 'node:url';
import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';

const uiRoot = fileURLToPath(new URL('.', import.meta.url));

export default defineConfig({
  root: uiRoot,
  base: './',
  plugins: [react()],
  build: {
    outDir: fileURLToPath(new URL('../../resources/[cnr]/cnr_ui/web/dist', import.meta.url)),
    emptyOutDir: true,
    sourcemap: false,
    rollupOptions: {
      input: {
        main: fileURLToPath(new URL('./index.html', import.meta.url)),
        loadscreen: fileURLToPath(new URL('./loadscreen.html', import.meta.url)),
      },
    },
  },
});
