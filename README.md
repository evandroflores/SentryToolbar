# SentryToolbar



Edit the config file to add your Sentry token, Organizationi slug, Project slug...
    `~/Library/Containers/br.com.eof.SentryToolbar/Data/.SentryToolbar.plist`

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>organizationSlug</key>
    <string>myorganization</string>
    <key>projectSlug</key>
    <string>myprojectslug</string>
    <key>query</key>
    <string>is:unresolved</string>
    <key>sentryApiBase</key>
    <string>https://sentry.io/api/0/projects/</string>
    <key>sentryIssuesEndpoint</key>
    <string>/issues/</string>
    <key>sentryToken</key>
    <string>x0xx00000xx000000000xx0x00x000xxx0xxxxxx00xx00x00xx00xx000x0xxx0</string>
</dict>
</plist>
```
