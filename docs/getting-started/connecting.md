# Connecting a device

Every device uses the same client. You can run it in a web browser or as the tablet app.

=== "Web browser"

    Open the server's address in a browser, for example `http://192.168.1.20:8080`. The server sends you to `/ui`, where the client loads.

    The web client finds the server by itself, because it was loaded from it.

=== "iPad or iPhone"

    Install the TMS client from the [App Store](https://apps.apple.com/au/app/tms_client/id6447258831).

    The app does not know where your server is, so the first time you open it go to the **connection page** (the cog icon in the top right) and enter the server's IP address and port.

=== "Android"

    Use the web client in the tablet's browser, or install the Android build from the [releases page](https://github.com/CJBuchel/TMS/releases) if one is published for your version.

## The connection page

Select the cog icon in the top right corner at any time to open the connection page. It shows:

- the current **status** and the address the client is connected to,
- fields for the **Server IP Address** and **Server Port**, with a **Connect** button, and
- the client's version and build number.

### Sharing the address with a QR code

The connection page has a QR button in the bottom right corner. Select it to show a QR code for the web client of the server this device is connected to. Another device can scan it with its camera to open TMS without typing the address.

## The connection status indicator

While the client is not fully connected, the top bar shows three markers in square brackets:

```text
[OK|DC|DC]
```

| Position | What it is | Meaning when it says `DC` |
| --- | --- | --- |
| First | Server | The server cannot be reached at all |
| Second | Live updates | The live connection for match and timer events is down |
| Third | Event data | The live copy of the event data is down |

When all three are connected the indicator disappears. It is normal to see it for a second or two when the client starts or after a device wakes from sleep.

If it stays, see [Troubleshooting](../support/troubleshooting.md#the-device-will-not-connect).

## Logging in and out

- Select the login button in the top right corner and enter your username and password.
- When you are logged in, the same button shows a person icon. Select it to log out.

The home screen then shows the screens available to your role. The arrow on the left edge of most screens opens a side menu with the rest.

!!! tip "Light and dark mode"
    The sun icon in the top bar switches between light and dark themes. The choice is remembered on that device.
