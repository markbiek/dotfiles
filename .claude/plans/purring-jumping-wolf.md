# Plan: Add Debug Logging Setting

## Goal
Add an "Enable debug logging" checkbox to the plugin settings that writes troubleshooting info to WordPress's `debug.log`.

## Files to Modify

1. **`src/AlfBskySettings.php`** - Add the new setting
2. **`alf-bsky-poster.php`** - Add logging calls at key operation points
3. **`src/Api/AlfBskyClient.php`** - Add logging for API interactions

## Implementation Steps

### 1. Add Setting to `src/AlfBskySettings.php`

**Add constant** (after line 25):
```php
public const OPTION_DEBUG_LOGGING = 'alf_bsky_debug_logging';
```

**Register setting** in `register_settings()` (after line 91):
```php
register_setting(
    self::OPTION_GROUP,
    self::OPTION_DEBUG_LOGGING,
    array(
        'type'              => 'boolean',
        'sanitize_callback' => 'rest_sanitize_boolean',
        'default'           => false,
    )
);
```

**Add field** (after line 122):
```php
add_settings_field(
    'alf_bsky_debug_logging',
    __( 'Debug Logging', 'antelope-bluesky-poster' ),
    array( $this, 'render_debug_logging_field' ),
    'alf-bsky-poster',
    self::SETTINGS_SECTION
);
```

**Add render method** and **static log helper**:
```php
public function render_debug_logging_field(): void {
    $checked = get_option( self::OPTION_DEBUG_LOGGING ) ? 'checked' : '';
    printf(
        '<label><input type="checkbox" name="%s" value="1" %s> %s</label>',
        esc_attr( self::OPTION_DEBUG_LOGGING ),
        esc_attr( $checked ),
        esc_html__( 'Enable debug logging', 'antelope-bluesky-poster' )
    );
    echo '<p class="description">' .
        esc_html__( 'Writes debug info to the WordPress debug.log file.', 'antelope-bluesky-poster' ) .
        '</p>';

    // Show warning if debug logging enabled but WP_DEBUG_LOG is not
    if ( get_option( self::OPTION_DEBUG_LOGGING ) && ! self::is_wp_debug_log_enabled() ) {
        echo '<p class="notice notice-warning" style="padding: 10px; margin-top: 10px;">' .
            esc_html__( 'Warning: WP_DEBUG_LOG is not enabled in wp-config.php. Logs will not be written.', 'antelope-bluesky-poster' ) .
            '</p>';
    }
}

/**
 * Check if WordPress debug logging is enabled.
 */
public static function is_wp_debug_log_enabled(): bool {
    return defined( 'WP_DEBUG_LOG' ) && WP_DEBUG_LOG;
}

public static function log( string $message ): void {
    if ( get_option( self::OPTION_DEBUG_LOGGING ) && self::is_wp_debug_log_enabled() ) {
        error_log( '[ALF Bluesky Poster] ' . $message );
    }
}
```

### 2. Add Logging Calls

**In `alf-bsky-poster.php`:**
- Log when post publish hook fires with post ID
- Log category match result
- Log Bluesky content being sent (truncated)
- Log success or caught exception

**In `src/Api/AlfBskyClient.php`:**
- Log authentication attempt (identifier only, no password)
- Log authentication success/failure
- Log post creation request
- Log API response code and any errors

### 3. What Gets Logged (Example Output)

```
[ALF Bluesky Poster] Post 123 transitioning to publish
[ALF Bluesky Poster] Post 123 matches category filter, proceeding
[ALF Bluesky Poster] Authenticating as user.bsky.social
[ALF Bluesky Poster] Authentication successful
[ALF Bluesky Poster] Creating post: "My Post Title - https://example.com/..."
[ALF Bluesky Poster] Post created successfully
```

## Notes

- Logs write to `wp-content/debug.log` (requires `WP_DEBUG_LOG` in wp-config.php)
- All entries prefixed with `[ALF Bluesky Poster]` for easy filtering
- No sensitive data logged (passwords, tokens, full content)
