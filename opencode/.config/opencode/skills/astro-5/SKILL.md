---
name: astro
description: >
  Use this skill for any task involving the Astro framework. Trigger whenever the user wants to:
  create a new Astro project, build landing pages with Astro, write .astro components, configure
  integrations, optimize performance, or deploy an Astro site. Also trigger when the user mentions
  "Astro", "astro.config", ".astro files", "Astro islands", or asks how to set up a fast static
  website. Use this skill even if the request seems simple — the step-by-step guidance ensures
  best practices are always followed.
---

# Astro Skill

Guía paso a paso para crear proyectos Astro, componentes, landing pages optimizadas y despliegues.

---

## 1. Crear un nuevo proyecto Astro

```bash
# Crear proyecto con el CLI oficial
npm create astro@latest my-landing-page

# Opciones recomendadas para landing pages:
# ✅ Template: "Empty" o "Blog" (según necesidad)
# ✅ TypeScript: Strict
# ✅ Install dependencies: Yes
# ✅ Git: Yes

cd my-landing-page
npm run dev
```

**Estructura recomendada para landing pages:**

```
src/
├── components/       # Componentes reutilizables
│   ├── Hero.astro
│   ├── Features.astro
│   ├── CTA.astro
│   └── Footer.astro
├── layouts/
│   └── BaseLayout.astro
├── pages/
│   └── index.astro   # Landing page principal
└── styles/
    └── global.css
```

---

## 2. Crear componentes `.astro`

### Anatomía de un componente Astro

```astro
---
// Frontmatter: código que corre en el servidor (build time)
interface Props {
  title: string;
  subtitle?: string;
  ctaText?: string;
  ctaHref?: string;
}

const {
  title,
  subtitle = "Descripción por defecto",
  ctaText = "Comenzar",
  ctaHref = "#"
} = Astro.props;
---

<!-- Template: HTML con expresiones de JavaScript -->
<section class="hero">
  <h1>{title}</h1>
  {subtitle && <p>{subtitle}</p>}
  <a href={ctaHref} class="cta-button">{ctaText}</a>
</section>

<style>
  /* Scoped por defecto — no afecta otros componentes */
  .hero {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 4rem 2rem;
  }

  .cta-button {
    background: var(--color-primary, #6366f1);
    color: white;
    padding: 0.75rem 2rem;
    border-radius: 0.5rem;
    text-decoration: none;
  }
</style>
```

### Layout base para landing pages

```astro
---
// src/layouts/BaseLayout.astro
interface Props {
  title: string;
  description?: string;
  ogImage?: string;
}

const {
  title,
  description = "Landing page description",
  ogImage = "/og-image.jpg"
} = Astro.props;
---

<!doctype html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content={description} />

    <!-- Open Graph -->
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    <meta property="og:image" content={ogImage} />

    <title>{title}</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
  </head>
  <body>
    <slot />
  </body>
</html>

<style is:global>
  *, *::before, *::after { box-sizing: border-box; }
  body { margin: 0; font-family: system-ui, sans-serif; }
</style>
```

### Página index (landing page)

```astro
---
// src/pages/index.astro
import BaseLayout from "../layouts/BaseLayout.astro";
import Hero from "../components/Hero.astro";
import Features from "../components/Features.astro";
import CTA from "../components/CTA.astro";
import Footer from "../components/Footer.astro";
---

<BaseLayout title="Mi Producto — La solución que necesitas" description="Descripción SEO aquí">
  <Hero
    title="El título que convierte"
    subtitle="Propuesta de valor clara y concisa en una línea."
    ctaText="Empieza gratis"
    ctaHref="#pricing"
  />
  <Features />
  <CTA />
  <Footer />
</BaseLayout>
```

---

## 3. Optimización y Performance

### Imágenes optimizadas (built-in)

```astro
---
import { Image } from "astro:assets";
import heroImg from "../assets/hero.png";
---

<!-- Astro genera automáticamente: WebP, lazy loading, tamaños correctos -->
<Image
  src={heroImg}
  alt="Hero image"
  width={1200}
  height={600}
  loading="eager"   <!-- eager solo para above-the-fold -->
  format="webp"
/>
```

### Astro Islands (interactividad parcial)

```astro
---
// Solo hidrata el componente cuando sea visible
import Counter from "../components/Counter.tsx"; // React, Vue, Svelte, etc.
---

<!-- client:load   → hidrata al cargar la página -->
<!-- client:idle   → hidrata cuando el navegador esté libre -->
<!-- client:visible → hidrata cuando entra al viewport (recomendado) -->
<!-- client:only   → solo en el cliente, sin SSR -->

<Counter client:visible />
```

### Configuración de rendimiento en `astro.config.mjs`

```js
// astro.config.mjs
import { defineConfig } from "astro/config";

export default defineConfig({
  // Compresión de HTML
  compressHTML: true,

  // Prefetch de links
  prefetch: {
    prefetchAll: true,
    defaultStrategy: "hover",
  },

  // Construcción optimizada
  build: {
    inlineStylesheets: "auto", // inline CSS pequeño, externo si es grande
  },

  vite: {
    build: {
      cssMinify: true,
    },
  },
});
```

### Checklist de performance para landing pages

- [ ] Usar `<Image>` de `astro:assets` para todas las imágenes
- [ ] `loading="eager"` solo en la imagen hero (above the fold)
- [ ] `client:visible` en componentes interactivos no críticos
- [ ] Fuentes con `font-display: swap` o usar fuentes del sistema
- [ ] CSS crítico inline, resto diferido
- [ ] Habilitar `prefetch` para navegación instantánea
- [ ] Verificar con Lighthouse: apuntar a 95+ en Performance

---

## 4. Integraciones útiles para landing pages

### Tailwind CSS

```bash
npx astro add tailwind
```

```js
// astro.config.mjs
import tailwind from "@astrojs/tailwind";

export default defineConfig({
  integrations: [tailwind()],
});
```

### Sitemap (SEO)

```bash
npx astro add sitemap
```

```js
import sitemap from "@astrojs/sitemap";

export default defineConfig({
  site: "https://tudominio.com",
  integrations: [sitemap()],
});
```

### React (para componentes interactivos)

```bash
npx astro add react
```

---

## 5. Deploy

### Vercel (recomendado para landing pages)

```bash
# Opción 1: CLI de Vercel
npm i -g vercel
vercel

# Opción 2: Con adaptador oficial
npx astro add vercel
```

```js
// astro.config.mjs
import vercel from "@astrojs/vercel/static";

export default defineConfig({
  output: "static", // o "hybrid" si necesitas SSR parcial
  adapter: vercel(),
});
```

### Netlify

```bash
npx astro add netlify
```

```toml
# netlify.toml
[build]
  command = "npm run build"
  publish = "dist"
```

### GitHub Pages (gratis, estático)

```bash
npx astro add github
```

```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci && npm run build
      - uses: actions/deploy-pages@v4
```

### Cloudflare Pages (máximo rendimiento global)

```bash
npx astro add cloudflare
```

En Cloudflare dashboard:

- Build command: `npm run build`
- Build output directory: `dist`

---

## 6. Variables de entorno

```bash
# .env
PUBLIC_SITE_URL=https://tudominio.com     # Accesible en cliente y servidor
SECRET_API_KEY=xxx                         # Solo en servidor (frontmatter)
```

```astro
---
// Acceder en frontmatter (.astro)
const siteUrl = import.meta.env.PUBLIC_SITE_URL;
const apiKey = import.meta.env.SECRET_API_KEY; // solo server-side
---
```

---

## Comandos de referencia rápida

| Comando                       | Acción                                     |
| ----------------------------- | ------------------------------------------ |
| `npm run dev`                 | Servidor de desarrollo en `localhost:4321` |
| `npm run build`               | Build de producción en `./dist/`           |
| `npm run preview`             | Preview del build local                    |
| `npx astro check`             | Verificar errores TypeScript en `.astro`   |
| `npx astro add <integration>` | Agregar integración oficial                |

---

## Tips para landing pages de alta conversión

1. **Above the fold**: Hero con título claro + CTA visible sin scroll
2. **Core Web Vitals**: LCP < 2.5s, CLS < 0.1, FID < 100ms
3. **Mobile first**: Diseñar para móvil primero, escalar a desktop
4. **Un solo CTA principal**: No confundir al usuario con múltiples acciones
5. **Social proof**: Testimonios, logos de clientes, métricas reales
6. **Astro genera 0 JS por defecto**: Aprovecha esto — agrega JS solo donde sea necesario con islands
