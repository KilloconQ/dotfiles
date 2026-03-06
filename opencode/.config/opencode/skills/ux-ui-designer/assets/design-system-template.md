# Design System Template

Copiá este archivo como `design-system.css` en la raíz del proyecto (o en `src/styles/`).
Completá los valores según las decisiones tomadas con el cliente.

---

## design-system.css

```css
@import "tailwindcss";

@theme {
  /* ─── BRAND COLORS ──────────────────────────────────────── */
  /* Primary: main brand color — CTAs, links, active states   */
  --color-primary: oklch(/* L% C H */);
  --color-primary-foreground: oklch(98% 0 0);

  /* Secondary: supporting color — badges, secondary buttons  */
  --color-secondary: oklch(/* L% C H */);
  --color-secondary-foreground: oklch(10% 0 0);

  /* Accent: hover highlights, subtle indicators              */
  --color-accent: oklch(/* L% C H */);
  --color-accent-foreground: oklch(10% 0 0);

  /* ─── SURFACE COLORS ───────────────────────────────────── */
  --color-background: oklch(98% 0 0);          /* Page background  */
  --color-foreground: oklch(10% 0 0);          /* Default text     */
  --color-muted: oklch(95% 0 0);               /* Cards, inputs    */
  --color-muted-foreground: oklch(45% 0 0);    /* Placeholders     */

  /* ─── SEMANTIC COLORS ──────────────────────────────────── */
  --color-destructive: oklch(55% 0.22 25);     /* Errors, delete   */
  --color-destructive-foreground: oklch(98% 0 0);

  --color-success: oklch(55% 0.18 145);        /* Confirmations    */
  --color-success-foreground: oklch(98% 0 0);

  --color-warning: oklch(70% 0.18 70);         /* Alerts           */
  --color-warning-foreground: oklch(10% 0 0);

  /* ─── BORDER & RING ────────────────────────────────────── */
  --color-border: oklch(88% 0 0);
  --color-ring: var(--color-primary);          /* Focus rings      */

  /* ─── DARK MODE OVERRIDES ──────────────────────────────── */
  /* Uncomment and fill if dark mode is required              */
  /*
  @variant dark {
    --color-background: oklch(10% 0 0);
    --color-foreground: oklch(95% 0 0);
    --color-muted: oklch(18% 0 0);
    --color-muted-foreground: oklch(60% 0 0);
    --color-border: oklch(25% 0 0);
  }
  */

  /* ─── TYPOGRAPHY ────────────────────────────────────────── */
  --font-sans: 'Inter', system-ui, -apple-system, sans-serif;
  --font-display: 'Inter', system-ui, sans-serif;  /* Replace if using separate heading font */
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;

  /* ─── TYPE SCALE ────────────────────────────────────────── */
  /* Based on 1.25 (Major Third) modular scale from 16px base */
  --text-xs:   0.64rem;    /*  ~10px */
  --text-sm:   0.8rem;     /*  ~13px */
  --text-base: 1rem;       /*   16px */
  --text-lg:   1.25rem;    /*   20px */
  --text-xl:   1.563rem;   /*   25px */
  --text-2xl:  1.953rem;   /*   31px */
  --text-3xl:  2.441rem;   /*   39px */
  --text-4xl:  3.052rem;   /*   49px */

  /* ─── SPACING (8px grid) ───────────────────────────────── */
  --spacing-xs:  0.25rem;  /*  4px  */
  --spacing-sm:  0.5rem;   /*  8px  */
  --spacing-md:  1rem;     /* 16px  */
  --spacing-lg:  1.5rem;   /* 24px  */
  --spacing-xl:  2rem;     /* 32px  */
  --spacing-2xl: 3rem;     /* 48px  */
  --spacing-3xl: 4rem;     /* 64px  */
  --spacing-4xl: 6rem;     /* 96px  */

  /* ─── BORDER RADIUS ────────────────────────────────────── */
  /* Pick ONE personality — comment out what you don't use   */
  --radius-sm:   4px;
  --radius-md:   8px;
  --radius-lg:   12px;
  --radius-xl:   16px;
  --radius-full: 9999px;
}
```

---

## Design System Summary

Fill this after each client session:

```
DESIGN SYSTEM — {Project Name}
Generated: {date}
─────────────────────────────────────────────────

CLIENT
  Name:       {client name}
  Product:    {landing / SaaS / e-commerce / dashboard / portfolio}
  Audience:   {description of target users}

VISUAL IDENTITY
  Mood:       {emotional direction — e.g. "confianza + modernidad"}
  Style:      {minimal / bold / editorial / playful / corporate}
  References: {any visual references provided}

COLORS
  Primary:        {oklch value} → {hex for reference} — {usage}
  Secondary:      {oklch value} → {hex for reference} — {usage}
  Background:     {oklch value}
  Foreground:     {oklch value}
  Mode:           light / dark / both

TYPOGRAPHY
  Display font:   {name} — {source: Google Fonts / system / licensed}
  Body font:      {name} — {source}
  Base size:      16px
  Scale ratio:    1.25 (Major Third)

SPACING    8px grid — all values multiples of 4 or 8
RADIUS     {sharp / subtle / rounded / pill / mixed}
SHADOWS    {standard / elevated / flat (no shadows)}

RESPONSIVE
  Primary device: {mobile-first / desktop-first / both}
  Breakpoints:    Tailwind defaults (640 / 768 / 1024 / 1280 / 1536)

ACCESSIBILITY
  Target standard: WCAG AA
  Contrast body:   {ratio value}
  Focus style:     ring using --color-ring

NOTES
  {Any specific client requirements, constraints, or decisions}
```

---

## Google Fonts Import Snippet

```html
<!-- Add to <head> — replace font names as needed -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
```

Or as CSS:
```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
```
