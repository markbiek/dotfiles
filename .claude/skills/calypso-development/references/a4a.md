# Automattic for Agencies (client/a8c-for-agencies/)

Use these rules on top of core Calypso standards.

## Forms

Use form components from:
- `calypso/a8c-for-agencies/components/form`
- `calypso/components/forms/`

## Style Conventions

Reference: `client/a8c-for-agencies/style.scss`

- Write full class names (no `&--` or `&__` selectors)
- Use `--color*` variables, NOT `--studio*`:

```scss
// ✅ Correct
color: var(--color-neutral-50);

// ❌ Wrong
color: var(--studio-gray-50);
```
