# dotbot-aether

Aether Conduit Plugin Collection for [dotbot-v4](https://github.com/andresharpe/dotbot-v3) — an IoT/console hardware abstraction layer that unifies diverse physical devices under a single event-driven interface.

## What is Aether?

Aether is dotbot's connection to the physical world. Each **conduit** bridges the gap between dotbot's event bus and a piece of real hardware, translating software events into light, sound, display, input, or printed output.

Conduits are named by their *nature*, not their hardware:

| Conduit | Type | Hardware | Protocol |
|---------|------|----------|----------|
| **Ambient** | Light emitter | Philips Hue | HTTPS REST + DTLS |
| **Window** | Visual display | Pixoo-64 | HTTP REST (LAN) |
| **Sonic** | Sound + light | JBL PartyBox | Bluetooth serial |
| **Console** | Control surface | Stream Deck | HTTP sidecar + WebSocket |
| **Counter** | Physical record | ESC/POS Printer | TCP/IP port 9100 |

## Repository Structure

```
dotbot-aether/
  conduit.manifest.json          # registry of available conduits
  conduits/
    ambient/                     # Philips Hue
    window/                      # Pixoo-64
    sonic/                       # JBL PartyBox
    console/                     # Stream Deck
    counter/                     # ESC/POS Printer
  shared/
    AetherCore.psm1              # shared conduit base
    AetherTypes.ps1              # event type enums, constants
  docs/
```

Each conduit directory contains:
- `conduit.json` — type, capabilities, discovery method, protocol, subscribed events
- `src/Aether{Type}/` — PowerShell module with Public/Private function split
- `tests/` — Pester tests

## Conduit Interface Contract

Every conduit module exports these standard functions:

- `Initialize-Aether{Type}` — accept config, validate hardware reachability
- `Find-Aether{Type}` — discover hardware on network/bus
- `Connect-Aether{Type}` — bond to discovered hardware
- `Disconnect-Aether{Type}` — clean shutdown
- `Test-Aether{Type}` — health check
- `Invoke-Aether{Type}Event` — handle an event bus event (the sink entry point)

## Integration

Requires **dotbot-v4 Phase 4 (Event Bus)** and **Phase 1 (Logging)**.

Set `aether.conduit_path` in dotbot settings to point to your local clone of this repo. Enable individual conduits in settings:

```json
"aether": {
  "enabled": true,
  "conduit_path": "C:/path/to/dotbot-aether",
  "conduits": {
    "ambient":  { "enabled": true },
    "window":   { "enabled": true },
    "sonic":    { "enabled": false },
    "console":  { "enabled": true },
    "counter":  { "enabled": true, "reckonings": ["task", "workflow", "daily"] }
  }
}
```

## Documentation

See [docs/PHASE-15-AETHER-CONDUIT-PLUGINS.md](docs/PHASE-15-AETHER-CONDUIT-PLUGINS.md) for the full design specification.

## License

MIT
