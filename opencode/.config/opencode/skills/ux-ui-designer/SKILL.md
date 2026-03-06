---
name: ux-ui-designer
description: >
  UX/UI design process: gather client needs, define a coherent design system (tokens, palette,
  typography, spacing), and generate consistent design decisions before writing any code.
  Trigger: When the user wants to design an interface, define a design system, choose colors,
  typography or visual style, or says "diseñá", "diseño", "design system", "quiero una UI", "armá la UI".
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- User wants to start a new UI without an existing design system
- User says "diseñá la interfaz", "armá el diseño", "quiero una UI", "hacé el design system"
- User needs to define colors, typography, spacing or visual identity for a client
- Before implementing ANY component — design decisions must come first
- User has branding assets (logo, colors, fonts) and needs to translate them to code tokens

---

## Phase 0: ALWAYS Do This First — Client Discovery

**NEVER start designing without answers to these questions.**
If the user hasn't provided them, ASK before doing anything else.

### Required Questions

```
1. ¿Qué tipo de producto es? (landing, SaaS, e-commerce, app interna, portfolio)
2. ¿Quién es el usuario final? (edad, contexto, nivel técnico)
3. ¿El cliente tiene colores de marca? ¿Logo? ¿Tipografía preferida?
4. ¿Tiene referencias visuales? (webs que le gustan, estilo que busca)
5. ¿Dark mode, light mode o ambos?
6. ¿Dispositivos principales? (mobile-first, desktop-first, ambos)
7. ¿Qué emoción debe transmitir? (confianza, innovación, calidez, minimalismo, lujo)
```

### Minimum Viable Info to Proceed

At minimum you need: **product type + brand color (or emotional direction) + primary device**.
If none of these are known → block and ask. Do NOT invent design decisions.

---

## Phase 1: Design System Definition

After discovery, generate the design system. Output it as **Tailwind CSS 4 config tokens**.

### 1.1 Color Palette

Always define:
- `primary` — main brand color (actions, CTAs, links)
- `primary-foreground` — text on top of primary
- `secondary` — supporting brand color
- `secondary-foreground`
- `background` — page background
- `foreground` — default text color
- `muted` — subdued backgrounds (cards, inputs)
- `muted-foreground` — subdued text (placeholders, captions)
- `accent` — highlights, hover states
- `accent-foreground`
- `destructive` — errors, delete actions
- `destructive-foreground`
- `border` — dividers, input borders
- `ring` — focus rings

**Decision Tree — Color Origin:**
```
Client has brand hex?     → Use it as primary, derive scale with oklch()
Client has emotional ref? → Map emotion to hue range (see table below)
No info at all?           → STOP and ask. Never invent brand identity.
```

**Emotion → Hue Mapping:**
| Emotion        | Hue Range   | Example          |
|----------------|-------------|------------------|
| Confianza      | 210–240°    | Azul corporativo |
| Innovación     | 260–290°    | Violeta/púrpura  |
| Calidez        | 20–40°      | Naranja/ámbar    |
| Naturaleza     | 120–160°    | Verde            |
| Lujo / Premium | 40–50°      | Dorado           |
| Minimalismo    | 0° (neutral)| Gris/zinc        |
| Energía        | 0–15°       | Rojo/coral       |

### 1.2 Typography

Rules:
- Maximum **2 font families**: one for headings, one for body (or same for both)
- Body size base: `16px` (1rem) — NEVER go below `14px` for body text
- Scale: use a modular scale (1.25 or 1.333 ratio)
- Prefer Google Fonts (free) unless client has licensed fonts
- Fallback stacks MUST be defined

**Font Personality Guide:**
| Style     | Use for                        | Examples                    |
|-----------|--------------------------------|-----------------------------|
| Serif     | Lujo, editorial, confianza     | Playfair Display, Lora      |
| Sans-serif| Tech, moderno, corporativo     | Inter, Geist, DM Sans       |
| Geometric | Innovación, startups           | Plus Jakarta Sans, Outfit   |
| Monospace | Dev tools, código, técnico     | JetBrains Mono, Fira Code   |
| Display   | Impacto, landings, hero sections| Syne, Cabinet Grotesk       |

### 1.3 Spacing Scale

Always use an **8px base grid**. All spacing values must be multiples of 4 or 8.

```
xs:  4px   (0.25rem)
sm:  8px   (0.5rem)
md:  16px  (1rem)
lg:  24px  (1.5rem)
xl:  32px  (2rem)
2xl: 48px  (3rem)
3xl: 64px  (4rem)
4xl: 96px  (6rem)
```

### 1.4 Border Radius

Pick ONE radius personality:
| Style        | Values                  | Personality           |
|--------------|-------------------------|-----------------------|
| Sharp        | `0px`                   | Corporativo, serio    |
| Subtle       | `4px / 6px`             | Profesional, limpio   |
| Rounded      | `8px / 12px`            | Moderno, amigable     |
| Pill-heavy   | `9999px` en botones     | Playful, consumer app |
| Mixed        | small=4px, cards=12px   | Equilibrado (default) |

### 1.5 Shadow System

```
shadow-sm:  0 1px 2px 0 rgb(0 0 0 / 0.05)
shadow:     0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)
shadow-md:  0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)
shadow-lg:  0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)
```

For dark mode: use `ring` instead of `shadow` for elevation — shadows don't read well on dark.

---

## Phase 2: Design System Output Format

Always output the design system as a **Tailwind CSS 4 CSS config block** + a **visual summary**.

### Tailwind CSS 4 Token Format

```css
/* design-system.css */
@import "tailwindcss";

@theme {
  /* Colors */
  --color-primary: oklch(55% 0.2 250);
  --color-primary-foreground: oklch(98% 0 0);
  --color-secondary: oklch(70% 0.1 250);
  --color-secondary-foreground: oklch(20% 0 0);
  --color-background: oklch(98% 0 0);
  --color-foreground: oklch(10% 0 0);
  --color-muted: oklch(95% 0 0);
  --color-muted-foreground: oklch(45% 0 0);
  --color-accent: oklch(65% 0.15 250);
  --color-accent-foreground: oklch(10% 0 0);
  --color-destructive: oklch(55% 0.22 25);
  --color-destructive-foreground: oklch(98% 0 0);
  --color-border: oklch(88% 0 0);
  --color-ring: oklch(55% 0.2 250);

  /* Typography */
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-display: 'Plus Jakarta Sans', sans-serif;
  --font-mono: 'JetBrains Mono', monospace;

  /* Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-full: 9999px;
}
```

### Visual Summary (always include after tokens)

```
DESIGN SYSTEM SUMMARY
─────────────────────
Product:    {product type}
Mood:       {emotional direction}
Mode:       {light / dark / both}

COLORS
  Primary:     {hex} — {usage}
  Secondary:   {hex} — {usage}
  Background:  {hex}
  Foreground:  {hex}

TYPOGRAPHY
  Display:  {font name} — headings, hero
  Body:     {font name} — paragraphs, UI
  Scale:    {base}px, ratio {ratio}

SPACING   8px grid
RADIUS    {personality description}
```

---

## Phase 3: Component Design Decisions

After the design system is defined, apply it consistently to components.

### Decision Tree — Component Variants

```
Is it a primary action?     → bg-primary text-primary-foreground
Is it secondary/outline?    → border-border text-foreground bg-transparent
Is it destructive?          → bg-destructive text-destructive-foreground
Is it ghost/subtle?         → hover:bg-muted text-foreground bg-transparent
Is it disabled?             → opacity-50 cursor-not-allowed pointer-events-none
```

### Hierarchy Rules

1. **ONE primary CTA per view** — never two `bg-primary` buttons competing
2. **Visual weight = importance** — larger, higher contrast = more important
3. **Whitespace is not empty** — it IS the design, don't fill every pixel
4. **Color carries meaning** — don't use `destructive` for non-destructive actions
5. **Consistency over creativity** — same component = same appearance everywhere

---

## Phase 4: Responsive Strategy

Decide BEFORE coding:

```
Mobile-first?   → Start with base classes, add md: lg: breakpoints
Desktop-first?  → Rare — only for internal dashboards with no mobile users
Both equal?     → Start mobile, mirror desktop — never the reverse
```

**Breakpoints (Tailwind defaults — use unless client specifies):**
```
sm:  640px   Phones landscape / small tablets
md:  768px   Tablets
lg:  1024px  Laptops
xl:  1280px  Desktops
2xl: 1536px  Large monitors
```

---

## Critical Rules

- **NEVER choose colors arbitrarily** — every color must have a documented reason
- **NEVER use raw hex in className** — always via design tokens (CSS custom properties)
- **NEVER mix radius styles** — pick one personality and stick to it
- **NEVER start implementing** without a defined design system
- **NEVER use more than 2 font families** in one project
- **ALWAYS define dark mode tokens** if dark mode is required — don't add it "later"
- **ALWAYS validate contrast** — minimum WCAG AA: 4.5:1 for body, 3:1 for large text

---

## Accessibility Checklist (Non-Negotiable)

- [ ] All interactive elements have `:focus-visible` ring using `--color-ring`
- [ ] Color is NEVER the only differentiator (add icons or text for status)
- [ ] Body text contrast ≥ 4.5:1 against background
- [ ] Touch targets ≥ 44×44px on mobile
- [ ] Motion respects `prefers-reduced-motion`

---

## Compatible Skills

This skill defines the design layer. Implementation uses:
- `tailwind-4` — for utility class patterns and cn() usage
- `react-19` — for React component implementation
- `angular-21` — for Angular component implementation
- `astro` — for Astro page/layout implementation

Load them AFTER the design system is defined.
