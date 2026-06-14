# Tarkhan CLI

The Tarkhan Enterprise Agentic AI Platform command-line client.

## Install (Windows / PowerShell)

```powershell
iwr https://raw.githubusercontent.com/tarkhan-io/tarkhan-cli/main/install.ps1 | iex
```

Requires Node.js >= 20. After install:

```powershell
tarkhan --version
tarkhan login --api https://your-tarkhan-server
```

## Update

```powershell
tarkhan update
```

The CLI checks for a newer version on startup (once per day, non-blocking).
Disable with `TARKHAN_NO_UPDATE_CHECK=1`.

> This repository contains only the built CLI artifacts. The platform
> source is closed.
