import { defineConfig } from 'astro/config';

export default defineConfig({
    vite: {
        define: {
            'import.meta.env.PUBLIC_DIRECTUS_URL': JSON.stringify(
                process.env.PUBLIC_DIRECTUS_URL || 'http://localhost:8055'
            ),
        },
    },
});
