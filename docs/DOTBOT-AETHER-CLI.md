# `dotbot aether` CLI Subcommand

Spec for the `dotbot aether` CLI — manages the global Aether conduit infrastructure from the dotbot command line.

## Problem

Aether conduits are global infrastructure (IoT hardware attached to the machine, not to any project). Installing, updating, and managing conduits currently requires manual cloning, module importing, and manifest editing. A `dotbot aether` subcommand automates this and provides a single entry point for conduit lifecycle management.

## Global Install Path

All Aether state lives under `~/.dotbot/aether/`. This directory is **machine-scoped** — it is not tied to any dotbot outpost (project). Every outpost on the machine shares the same conduit infrastructure.

```
~/.dotbot/aether/
  aether.json                     # local install state (installed conduits, versions, bonds)
  conduits/
    ambient/                      # cloned from dotbot-aether-ambient
      conduit.json
      src/DotBot.Aether.Ambient/
      ...
    window/                       # cloned from dotbot-aether-window
      conduit.json
      src/DotBot.Aether.Window/
      ...
    sonic/
    console/
    counter/
  shared/
    AetherCore.psm1               # copied from dotbot-aether repo
    AetherTypes.ps1
  logs/
    aether.log                    # conduit lifecycle log
```

### `aether.json` — Local Install State

Tracks what is installed on this machine, independent of what the registry repo knows about:

```json
{
  "version": "1.0.0",
  "initialized": "2026-03-15T17:45:00Z",
  "registry": "https://github.com/andresharpe/dotbot-aether",
  "install_path": "~/.dotbot/aether",
  "conduits": {
    "ambient": {
      "installed": true,
      "version": "1.0.0",
      "repo": "https://github.com/andresharpe/dotbot-aether-ambient",
      "installed_at": "2026-03-15T18:00:00Z",
      "updated_at": "2026-03-15T18:00:00Z",
      "bond": {
        "bonded": true,
        "device": "Hue Bridge (192.168.1.50)",
        "bonded_at": "2026-03-15T18:05:00Z"
      }
    },
    "window": {
      "installed": true,
      "version": "1.0.0",
      "repo": "https://github.com/andresharpe/dotbot-aether-window",
      "installed_at": "2026-03-15T18:10:00Z",
      "updated_at": "2026-03-15T18:10:00Z",
      "bond": null
    }
  }
}
```

## CLI Commands

### `dotbot aether init`

Seeds the global `~/.dotbot/aether/` directory structure from the registry repo.

**Behavior:**
1. Create `~/.dotbot/aether/` if it doesn't exist
2. Clone or pull the `dotbot-aether` registry repo to a cache location (`~/.dotbot/aether/.registry/`)
3. Copy `shared/AetherCore.psm1` and `shared/AetherTypes.ps1` into `~/.dotbot/aether/shared/`
4. Create `conduits/` and `logs/` directories
5. Generate `aether.json` with empty conduit list
6. Print summary of available conduits from `conduit.manifest.json`

**Flags:**
- `--force` — re-initialize even if already initialized (resets `aether.json`, preserves bonds)

**Output:**
```
Aether initialized at ~/.dotbot/aether
Registry: https://github.com/andresharpe/dotbot-aether

Available conduits:
  ambient   Philips Hue          (HTTPS REST + DTLS)
  window    Pixoo-64             (HTTP REST, LAN)
  sonic     JBL PartyBox         (Bluetooth serial)
  console   Stream Deck          (HTTP sidecar + WebSocket)
  counter   ESC/POS Printer      (TCP/IP port 9100)

Run 'dotbot aether install <conduit>' to install a conduit.
```

### `dotbot aether install <conduit>`

Installs a conduit by cloning its upstream repo and registering it in the local state.

**Arguments:**
- `<conduit>` — conduit name (e.g. `ambient`, `window`, `sonic`, `console`, `counter`)
- `--all` — install all conduits from the registry

**Behavior:**
1. Validate that Aether is initialized (`aether.json` exists)
2. Look up the conduit in `.registry/conduit.manifest.json`
3. Resolve the upstream repo URL from `.registry/conduits/{type}/conduit.json`
4. Clone the upstream repo into `~/.dotbot/aether/conduits/{type}/`
5. Validate the conduit structure (must have `conduit.json`, module manifest `.psd1`)
6. Import-Module the conduit (dry run — validate it loads without errors)
7. Register in `aether.json`
8. Run `Initialize-Aether{Type}` to validate hardware reachability
9. Run `Find-Aether{Type}` to discover hardware
10. If hardware found, prompt: `Bond to {device}? [Y/n]`
11. If yes, run `Connect-Aether{Type}` and store bond info in `aether.json`

**Output (example: `dotbot aether install ambient`):**
```
Installing ambient conduit...
  Cloning https://github.com/andresharpe/dotbot-aether-ambient
  Validating module DotBot.Aether.Ambient... OK
  Importing module... OK
  Initializing... OK
  Scanning for hardware...
    Found: Hue Bridge @ 192.168.1.50 (model BSB002, API v1.55.0)
  Bond to Hue Bridge (192.168.1.50)? [Y/n] Y
  Bonding... OK

ambient conduit installed and bonded.
```

### `dotbot aether uninstall <conduit>`

Removes a conduit from the local installation.

**Arguments:**
- `<conduit>` — conduit name
- `--all` — uninstall all conduits

**Behavior:**
1. If conduit is bonded, run `Disconnect-Aether{Type}` first
2. Remove the conduit directory from `~/.dotbot/aether/conduits/{type}/`
3. Remove from `aether.json`

**Flags:**
- `--force` — skip the disconnect step and confirmation prompt
- `--keep-bond` — remember the bond info in `aether.json` (for reinstall scenarios)

### `dotbot aether list`

Lists all conduits known to the registry and their local install state.

**Output:**
```
Conduit     Status      Device                     Version
-------     ------      ------                     -------
ambient     bonded      Hue Bridge (192.168.1.50)  1.0.0
window      installed   (not bonded)               1.0.0
sonic       available   -                          -
console     available   -                          -
counter     available   -                          -
```

**Statuses:**
- `available` — in registry, not installed locally
- `installed` — installed but not bonded to hardware
- `bonded` — installed and actively bonded to hardware
- `error` — installed but health check failing
- `outdated` — installed but upstream has newer version

### `dotbot aether status`

Shows detailed health and connection state for all installed conduits.

**Output:**
```
Aether Status
  Install path: ~/.dotbot/aether
  Registry:     https://github.com/andresharpe/dotbot-aether (up to date)
  Conduits:     2 installed, 1 bonded

ambient (bonded)
  Module:   DotBot.Aether.Ambient v1.0.0
  Device:   Hue Bridge @ 192.168.1.50
  Health:   OK (last check: 2s ago)
  Bond:     active since 2026-03-15
  Events:   task.started, task.completed, task.failed, process.started, process.stopped, workflow.completed

window (installed)
  Module:   DotBot.Aether.Window v1.0.0
  Device:   (not bonded)
  Health:   OK (module loads)
  Events:   task.started, task.completed, task.failed, workflow.completed
```

### `dotbot aether test [conduit]`

Runs health checks on installed conduits.

**Arguments:**
- `[conduit]` — optional; test a specific conduit, or all installed conduits if omitted

**Behavior:**
1. For each target conduit, call `Test-Aether{Type}`
2. Report pass/fail with diagnostics

**Output:**
```
Testing ambient... PASS (Hue Bridge responding, 12ms)
Testing window...  PASS (Pixoo-64 responding, 8ms)
Testing sonic...   FAIL (Bluetooth device not found)

2 passed, 1 failed
```

### `dotbot aether update [conduit]`

Pulls the latest from upstream repos for installed conduits.

**Arguments:**
- `[conduit]` — optional; update a specific conduit, or all installed conduits if omitted

**Behavior:**
1. For each target conduit, `git pull` in `~/.dotbot/aether/conduits/{type}/`
2. Re-import the module and re-run `Initialize-Aether{Type}`
3. Update `aether.json` version and `updated_at` timestamp
4. If bond exists, re-run `Test-Aether{Type}` to verify still healthy

### `dotbot aether bond <conduit>`

Manually trigger hardware discovery and bonding for an installed conduit.

**Behavior:**
1. Run `Find-Aether{Type}` to discover hardware
2. Present discovered devices
3. Prompt user to select device (if multiple)
4. Run `Connect-Aether{Type}` to bond
5. Store bond info in `aether.json`

### `dotbot aether unbond <conduit>`

Disconnect from bonded hardware without uninstalling.

**Behavior:**
1. Run `Disconnect-Aether{Type}`
2. Clear bond info from `aether.json`

## Integration with dotbot

### Module Loading at Startup

When dotbot starts, the Aether subsystem:

1. Check if `~/.dotbot/aether/aether.json` exists
2. Load `shared/AetherCore.psm1` and `shared/AetherTypes.ps1`
3. For each conduit where `installed == true`:
   - Import-Module from `conduits/{type}/src/DotBot.Aether.{Type}/`
   - If bonded, call `Initialize-Aether{Type}` with stored bond config
   - Register as event sink via `Register-DotBotEventSink`
4. Conduits that fail initialization are marked `error` in status but don't block others

### Settings Interaction

The `aether` section in `settings.default.json` provides **per-outpost overrides** on top of the global install:

```json
"aether": {
  "enabled": true,
  "conduits": {
    "ambient":  { "enabled": true },
    "counter":  { "enabled": true, "reckonings": ["task", "workflow", "daily"] }
  }
}
```

- Global install (`~/.dotbot/aether/`) determines what is **available**
- Outpost settings determine what is **active** for that project
- A conduit must be both installed globally AND enabled in outpost settings to receive events

## Implementation Notes

### PowerShell Module Structure

The `dotbot aether` subcommand is implemented as a PowerShell function registered in the dotbot CLI dispatcher. The implementation lives in the dotbot-v4 core (not in this repo). This repo provides:

- The registry (`conduit.manifest.json`) that `dotbot aether init` reads
- The shared modules that get copied to `~/.dotbot/aether/shared/`
- The conduit.json files that `dotbot aether install` uses to resolve upstream repos

### Error Handling

- **No internet**: `install` and `update` fail gracefully with offline message; `list` shows cached state
- **Hardware not found**: `install` completes but skips bonding; `bond` can be run later
- **Module load failure**: conduit is marked `error`; `status` shows diagnostic; other conduits unaffected
- **Permission errors**: clear message about `~/.dotbot/` directory permissions

### Future Extensions

- `dotbot aether logs [conduit]` — tail conduit lifecycle logs
- `dotbot aether config <conduit> <key> <value>` — set per-conduit config (e.g. brightness thresholds)
- `dotbot aether emit <event>` — manually emit a test event to all active conduits
- `dotbot aether inspect <conduit>` — show conduit capabilities, event mappings, hardware details
- Third-party conduit support via custom registry URLs
