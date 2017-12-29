# SentryToolbar

This is a pet project ongoing that aims to create a MacOS toolbar to follow errors on Sentry.

Edit the config file to add your Sentry token, Organizationi slug, Project slug...
    `~/Library/Containers/br.com.eof.SentryToolbar/Data/.SentryToolbar.plist`

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>organizations</key>
    <array>
        <dict>
            <key>projects</key>
            <array>
                <dict>
                    <key>query</key>
                    <string>is:unresolved</string>
                    <key>slug</key>
                    <string>your_project_slug</string>
                </dict>
            </array>
            <key>slug</key>
            <string>your_org_slug</string>
            <key>token</key>
            <string>YOUR TOKEN</string>
        </dict>
    </array>
</dict>
</plist>

```
