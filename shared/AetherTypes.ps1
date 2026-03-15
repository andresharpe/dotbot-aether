#Requires -Version 7.0

<#
.SYNOPSIS
    Aether Types — event type enums and conduit type constants.

.DESCRIPTION
    Defines the shared type system for the Aether conduit collection.
    Dot-source this file in conduit modules that need access to type constants.
#>

# Conduit types — named by nature, not hardware
enum AetherConduitType {
    Ambient   # emits light
    Window    # displays visual information
    Sonic     # emits light and sound
    Console   # accepts input, provides control surface
    Counter   # produces physical records/tallies
}

# Conduit lifecycle states
enum AetherConduitState {
    Registered    # conduit module loaded
    Initializing  # config accepted, validating hardware
    Discovered    # hardware found on network/bus
    Connected     # bonded and ready to receive events
    Disconnected  # clean shutdown
    Faulted       # error state — hardware unreachable or failed
}

# Standard event types emitted by the dotbot event bus
enum AetherEventType {
    TaskStarted        # task.started
    TaskCompleted      # task.completed
    TaskFailed         # task.failed
    ProcessStarted     # process.started
    ProcessStopped     # process.stopped
    WorkflowCompleted  # workflow.completed
    ReckoningDaily     # reckoning.daily
    ReckoningWeekly    # reckoning.weekly
    ButtonPressed      # button.pressed (console input)
}

# Discovery methods
enum AetherDiscovery {
    Lan        # network discovery (ARP, N-UPnP, SSDP, subnet scan)
    Bluetooth  # Bluetooth serial discovery
    Local      # local process / USB
}

# Protocol types
enum AetherProtocol {
    HttpRest         # HTTP REST (LAN)
    HttpsRest        # HTTPS REST (LAN)
    HttpsRestDtls    # HTTPS REST + DTLS UDP streaming
    BluetoothSerial  # Bluetooth serial port
    TcpEscPos        # TCP/IP ESC/POS
    HttpSidecar      # HTTP sidecar + WebSocket SDK
}
