# Tarkhan CLI

The Tarkhan Enterprise Agentic AI Platform command-line client.

## Install

Requires Node.js >= 20.

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/tarkhan-io/tarkhan-cli/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
iwr https://raw.githubusercontent.com/tarkhan-io/tarkhan-cli/main/install.ps1 | iex
```

After install:

```bash
tarkhan --version
tarkhan login --api https://your-tarkhan-server
```

## Update

```bash
tarkhan update
```

The CLI checks for a newer version on startup (once per day, non-blocking).
Disable with `TARKHAN_NO_UPDATE_CHECK=1`.

> This repository contains only the built CLI artifacts. The platform
> source is closed.
