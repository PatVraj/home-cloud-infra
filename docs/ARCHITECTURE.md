# Home Cloud Infrastructure Architecture

## Node Overview

| Node Name | Hardware | OS | Primary Role | IP Address (Local/Tailscale) |
| :--- | :--- | :--- | :--- | :--- |
| **Pi-Gateway** | Raspberry Pi | Debian | Tailscale Subnet Router | `192.168.86.202` / `100.X.X.X` |
| **Laptop-HP** | HP Laptop | Ubuntu | DB, Internal Docker Host | `192.168.86.201` |
| **Mac-Hub** | M1 Mac (8GB) | macOS | iMessage Bridge, OpenWebUI | `192.168.86.203` |
| **Oracle-Edge** | OCI A1 (24GB) | Ubuntu | Ollama Inferencing, Exit Node | TBD |

## Network Flow
- Subnet Routing is handled by **Pi-Gateway**.
- `Oracle-Edge` joins Tailnet directly and accesses local nodes via Pi-Gateway routing.
- No direct Tailscale installation on `Laptop-HP` or `Mac-Hub` to prevent routing conflicts.
