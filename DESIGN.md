---
name: Quiet Luxury
colors:
  surface: '#fcf9f5'
  surface-dim: '#dcdad6'
  surface-bright: '#fcf9f5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3ef'
  surface-container: '#f0ede9'
  surface-container-high: '#eae8e4'
  surface-container-highest: '#e5e2de'
  on-surface: '#1c1c1a'
  on-surface-variant: '#444748'
  inverse-surface: '#31302e'
  inverse-on-surface: '#f3f0ec'
  outline: '#747878'
  outline-variant: '#c4c7c7'
  surface-tint: '#5f5e5e'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1c1b1b'
  on-primary-container: '#858383'
  inverse-primary: '#c8c6c5'
  secondary: '#775a19'
  on-secondary: '#ffffff'
  secondary-container: '#fed488'
  on-secondary-container: '#785a1a'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1b1c1a'
  on-tertiary-container: '#848481'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c8c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474746'
  secondary-fixed: '#ffdea5'
  secondary-fixed-dim: '#e9c176'
  on-secondary-fixed: '#261900'
  on-secondary-fixed-variant: '#5d4201'
  tertiary-fixed: '#e4e2de'
  tertiary-fixed-dim: '#c8c6c3'
  on-tertiary-fixed: '#1b1c1a'
  on-tertiary-fixed-variant: '#474744'
  background: '#fcf9f5'
  on-background: '#1c1c1a'
  surface-variant: '#e5e2de'
typography:
  headline-lg:
    fontFamily: Playfair Display
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Playfair Display
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Playfair Display
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  number-xl:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '300'
    lineHeight: 56px
    letterSpacing: -0.04em
  number-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 24px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 8px
  container-padding-desktop: 64px
  container-padding-mobile: 24px
  gutter: 24px
  section-gap: 48px
---

## Brand & Style

The design system is rooted in the concept of "Quiet Luxury"—an aesthetic that prioritizes high-quality materials, intentionality, and restraint over loud ornamentation. It targets a sophisticated audience accustomed to fine dining environments where the experience is seamless and the atmosphere is serene.

The style is a blend of **Minimalism** and **Editorial Design**. It leverages expansive whitespace to evoke the feel of a freshly pressed linen tablecloth. Every element is placed with purpose, ensuring that the utility of splitting a bill never interrupts the elegance of the evening. The interface should feel like a premium concierge service: helpful, unobtrusive, and impeccably polished.

## Colors

This color palette is designed to reflect the interior of a Michelin-starred establishment.

- **Primary (Deep Charcoal):** Used for primary typography and high-emphasis actions. It provides a grounded, authoritative contrast against the lighter backgrounds.
- **Secondary (Champagne Gold):** An accent reserved for moments of celebration or confirmation. Use it sparingly for interactive highlights, active states, or premium features.
- **Tertiary (Soft Cream):** The foundational canvas. It replaces pure white to reduce eye strain and provide a warmer, more inviting "paper" feel.
- **Neutral (Warm Grey):** Used for secondary text, borders, and disabled states, maintaining a soft hierarchy without introducing harsh blacks or cool blues.

## Typography

The typography strategy balances editorial elegance with technical precision.

**Playfair Display** is utilized for headlines and summary statements, providing a classical serif rhythm that feels like a curated menu.

**Inter** is the workhorse for all functional data. Specifically, for currency and bill calculations, use Inter with "tabular lining" figures to ensure that decimals align perfectly in vertical lists. Labels use an uppercase treatment with increased letter spacing to create a sense of architectural structure within the layout.

## Layout & Spacing

The layout follows a **Fixed Grid** philosophy on desktop to preserve the intentionality of the whitespace, while transitioning to a highly structured fluid system on mobile.

- **Desktop:** A centered 12-column grid with a maximum width of 1140px. Large 64px margins ensure the content "breathes" and feels premium.
- **Mobile:** A 4-column grid with 24px side margins.
- **Rhythm:** Spacing follows an 8px base unit. For fine dining contexts, prefer larger increments (32px, 48px, 64px) between major sections to prevent the UI from feeling cluttered or "app-like."

## Elevation & Depth

To maintain the "Quiet Luxury" aesthetic, this design system avoids heavy shadows or complex gradients.

**Low-contrast outlines** are the primary method of separation. Surfaces are defined by subtle shifts in tone—for example, a Soft Cream card sitting on a slightly darker "Linen" background (#F2EFE9).

When depth is necessary (such as for a floating action button or a modal), use **Ambient Shadows**: ultra-diffused, 4% opacity shadows with a slight warm tint (#2D2D2D). The goal is to make elements appear as though they are resting gently on a surface, rather than hovering high above it.

## Shapes

The shape language is conservative and tailored. A **Soft (Level 1)** roundedness is applied across all components.

The 4px (0.25rem) radius for standard components and 8px (0.5rem) for cards provides just enough softness to feel modern without losing the formal, structured feel of a traditional printed receipt or menu. Interactive elements like "Close" buttons may use a circular/pill shape for clear affordance, but primary containers should remain rectangular with soft corners.

## Components

### Buttons

- **Primary:** Solid Deep Charcoal background with Soft Cream text. High-contrast, no shadow.
- **Secondary:** Transparent background with a 1px Deep Charcoal border.
- **Tertiary/Ghost:** Text-only, using the Gold accent for active states.

### Input Fields

Inputs should mimic high-end stationery. Use a 1px bottom-border only (#D1CFC9) in the default state, shifting to Deep Charcoal when focused. The label should float above in the uppercase `label-md` style.

### Cards

Cards are used to group diners or bill items. They feature a Soft Cream background (#FDFBF7) and a very thin, low-contrast border (#E5E2DA). Shadows are avoided unless the card is being interacted with (e.g., dragged to split an item).

### Chips & Tags

Used for individual diners. These should be minimalist, featuring the diner's initials in a circle with a Soft Cream background and a subtle Gold border.

### Progress Indicators

For the "splitting" process, use a thin, elegant horizontal line. The filled portion should be Champagne Gold, moving with a slow, eased transition to maintain the calm atmosphere of the app.
