# WordPress PHP Coding Standards

Source: https://github.com/WordPress/wpcs-docs/blob/master/wordpress-coding-standards/php.md

## General

- Full PHP tags (`<?php ?>`, never shorthand)
- Single quotes for strings without variables
- No parentheses for `require`/`include`; use `require_once` for dependencies
- Files end without closing PHP tag

## Naming

| Type | Convention | Example |
|------|------------|---------|
| Variables, functions, hooks | lowercase_underscores | `some_function_name` |
| Classes, traits, interfaces | Capitalized_Words | `WP_Error`, `Walker_Category` |
| Constants | UPPERCASE_UNDERSCORES | `DOING_AJAX` |
| File names | lowercase-hyphens | `my-plugin-name.php` |
| Class files | prefix class- | `class-wp-error.php` |

## Whitespace

- Tabs for indentation, spaces for mid-line alignment
- Space after commas, around operators
- Space inside parentheses
- No space between function name and opening paren
- No trailing whitespace

## Formatting

- Always use braces for control structures
- Arrays: long syntax `array()` (not `[]`)
- Trailing comma in multi-line arrays
- One class/interface/trait per file

## OOP

- Always declare visibility (`public`, `protected`, `private`)
- Always use parentheses for `new Object()`

## Control Structures

- Use `elseif` (not `else if`)
- Yoda conditions: `if ( true === $var )`
- Braces even for single statements

## Operators

- Ternary: test for true, not false
- Avoid `@` error control operator
- Prefer pre-increment (`++$i`)

## Database

- Avoid direct queries when possible
- Capitalize SQL keywords
- Use `$wpdb->prepare()` with placeholders (`%d`, `%f`, `%s`, `%i`) without quotes

## Best Practices

- Strict comparisons (`===`, `!==`)
- No assignments in conditionals
- Avoid `extract()`, `eval()`, `create_function()`, backticks
- Use PCRE over POSIX regex
