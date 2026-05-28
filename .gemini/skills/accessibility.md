# Accessibility Review Skill

Use this skill whenever work touches user interface, frontend code, content structure, forms, navigation, keyboard interaction, visual design, media, documents, charts, or generated assets.

## Baseline Standard

- Target WCAG 2.2 AA unless the user states a stricter standard.
- Prefer native semantic HTML and platform controls before ARIA.
- Use WAI-ARIA only when native semantics cannot express the interaction, and verify the exact pattern against current W3C/WAI documentation.
- Treat automated accessibility tools as partial coverage. Combine them with semantic review, keyboard review, focus review, and screen-reader-oriented reasoning.

## Required Checks

- Semantics: landmarks, headings, labels, names, roles, values, list/table structure, language, and status messages are correct.
- Keyboard: every interactive control is reachable, operable, and ordered logically without a mouse.
- Focus: focus indicators are visible, focus is not trapped unexpectedly, dialogs manage initial and return focus, and route/view changes do not strand users.
- Forms: every input has a programmatic label, errors are associated with fields, required state is exposed, and help text is discoverable.
- Visual: text contrast, non-text contrast, target size, spacing, zoom/reflow, reduced motion, orientation, and color-independent meaning are considered.
- Motion: any non-essential animation, parallax, smooth scrolling, auto-advancing content, or transition must respect `prefers-reduced-motion: reduce` by disabling or substantially reducing motion.
- Dynamic UI: loading, validation, async results, notifications, and errors are announced with appropriate live regions or equivalent platform behavior.
- Media: images have useful alt text or are marked decorative, captions/transcripts are provided where applicable, and autoplay/motion is controlled.
- Content: link and button names are specific, headings describe sections, instructions do not depend only on shape/color/position, and plain language is preferred.

## Implementation Rules

- Do not add ARIA that duplicates or contradicts native semantics.
- Do not use `div` or `span` as controls when `button`, `a`, `input`, `select`, `textarea`, `details`, or other native elements fit.
- Do not remove outlines unless replacing them with an equally visible focus style.
- Do not rely on placeholder text as the only label.
- Do not create icon-only controls without an accessible name.
- Do not hide focusable content with `aria-hidden`, `display: none`, `visibility: hidden`, or offscreen CSS unless it is intentionally unavailable.
- Do not trap keyboard users in modals, menus, popovers, carousels, canvas controls, or custom widgets.

## Verification Expectations

- For frontend changes, run available automated checks such as axe, Playwright accessibility assertions, lint rules, or framework-specific tests when feasible.
- Manually verify keyboard paths for primary workflows.
- Inspect rendered output at common desktop and mobile widths when layout changed.
- Report any accessibility risks that remain unverified, especially screen reader behavior, custom widgets, canvas/WebGL interactions, or third-party components.
