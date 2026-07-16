-- Defines immutable technical defaults that may safely live in source control.
CNR_STATIC_CONFIG = {
    default_locale = 'de',
    readiness_poll_interval_ms = 500,
    readiness_timeout_ms = 15000,
    slow_query_threshold_ms = 250,
    ui = { default_view = 'shell', browser_mock = true },
}
