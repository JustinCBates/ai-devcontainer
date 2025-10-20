# Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         Developer's Machine                      │
│                                                                  │
│  ┌────────────────┐         ┌─────────────────────────────┐    │
│  │  VS Code       │         │  Environment Variable       │    │
│  │  (Host)        │────────▶│  DEVCONTAINER_CONFIG_FILE   │    │
│  └────────────────┘         └─────────────────────────────┘    │
│         │                                                        │
│         │ "Reopen in Container"                                 │
│         ▼                                                        │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Docker Container (DevContainer)             │  │
│  │                                                          │  │
│  │  ┌───────────────────────────────────────────────────┐  │  │
│  │  │  1. Container Starts                              │  │  │
│  │  │     - Runs Dockerfile                             │  │  │
│  │  │     - Installs base packages                      │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  │                          │                               │  │
│  │                          ▼                               │  │
│  │  ┌───────────────────────────────────────────────────┐  │  │
│  │  │  2. Post-Create (post-create.sh)                  │  │  │
│  │  │     - Calls load-config.sh                        │  │  │
│  │  │     - Sets up git                                 │  │  │
│  │  │     - Creates aliases                             │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  │                          │                               │  │
│  │                          ▼                               │  │
│  │  ┌───────────────────────────────────────────────────┐  │  │
│  │  │  3. Load Config (load-config.sh)                  │  │  │
│  │  │                                                    │  │  │
│  │  │  ┌──────────────────────────────────────────┐    │  │  │
│  │  │  │ Read: base.config.json                   │    │  │  │
│  │  │  │   + python.config.json (or other)        │    │  │  │
│  │  │  └──────────────────────────────────────────┘    │  │  │
│  │  │                     │                             │  │  │
│  │  │                     ▼                             │  │  │
│  │  │  ┌──────────────────────────────────────────┐    │  │  │
│  │  │  │ Merge Configurations                     │    │  │  │
│  │  │  │  - Extensions (required + additional)    │    │  │  │
│  │  │  │  - Features (logging, linting, etc.)     │    │  │  │
│  │  │  │  - Environment variables                 │    │  │  │
│  │  │  │  - VS Code settings                      │    │  │  │
│  │  │  └──────────────────────────────────────────┘    │  │  │
│  │  │                     │                             │  │  │
│  │  │                     ▼                             │  │  │
│  │  │  ┌──────────────────────────────────────────┐    │  │  │
│  │  │  │ Install Extensions                       │    │  │  │
│  │  │  │  - continue.continue (required)          │    │  │  │
│  │  │  │  - ms-python.python                      │    │  │  │
│  │  │  │  - Other extensions from config          │    │  │  │
│  │  │  └──────────────────────────────────────────┘    │  │  │
│  │  │                     │                             │  │  │
│  │  │                     ▼                             │  │  │
│  │  │  ┌──────────────────────────────────────────┐    │  │  │
│  │  │  │ Configure Continue                       │    │  │  │
│  │  │  │  - Create ~/.continue/config.json        │    │  │  │
│  │  │  │  - Set API base: ai-backend:8000         │    │  │  │
│  │  │  │  - Add custom commands                   │    │  │  │
│  │  │  └──────────────────────────────────────────┘    │  │  │
│  │  │                     │                             │  │  │
│  │  │                     ▼                             │  │  │
│  │  │  ┌──────────────────────────────────────────┐    │  │  │
│  │  │  │ Set Environment Variables                │    │  │  │
│  │  │  │  - Export to ~/.devcontainer_env         │    │  │  │
│  │  │  │  - Source in shell profiles              │    │  │  │
│  │  │  └──────────────────────────────────────────┘    │  │  │
│  │  │                     │                             │  │  │
│  │  │                     ▼                             │  │  │
│  │  │  ┌──────────────────────────────────────────┐    │  │  │
│  │  │  │ Apply VS Code Settings                   │    │  │  │
│  │  │  │  - Merge with .vscode/settings.json      │    │  │  │
│  │  │  └──────────────────────────────────────────┘    │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  │                          │                               │  │
│  │                          ▼                               │  │
│  │  ┌───────────────────────────────────────────────────┐  │  │
│  │  │  4. Post-Start (post-start.sh)                    │  │  │
│  │  │     - Check AI backend health                     │  │  │
│  │  │     - Display welcome message                     │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  │                          │                               │  │
│  │                          ▼                               │  │
│  │  ┌───────────────────────────────────────────────────┐  │  │
│  │  │  ✅ Ready to Code!                                │  │  │
│  │  │     - VS Code connected to container              │  │  │
│  │  │     - All extensions installed                    │  │  │
│  │  │     - Continue AI configured                      │  │  │
│  │  │     - Logging enabled                             │  │  │
│  │  │     - Linting enabled                             │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│         │                                                      │
│         │ Network Connection                                  │
│         ▼                                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │         AI Backend Container (ai-backend)                │  │
│  │         - FastAPI server                                 │  │
│  │         - Port: 8000                                     │  │
│  │         - Models: HuggingFace transformers              │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Configuration Flow

```
Choose Config → Load Config → Merge → Apply → Ready
     │              │           │       │        │
     │              │           │       │        └─ Extensions installed
     │              │           │       │           Continue configured
     │              │           │       │           Environment set
     │              │           │       │           Settings applied
     │              │           │       │
     │              │           │       └─────────── Install extensions
     │              │           │                    Configure Continue
     │              │           │                    Set env vars
     │              │           │                    Apply settings
     │              │           │
     │              │           └─────────────────── base.config.json
     │              │                                + app.config.json
     │              │                                = merged config
     │              │
     │              └───────────────────────────── Read config files
     │                                              Parse JSON
     │                                              Merge if extends
     │
     └──────────────────────────────────────────── ENV var or
                                                    devcontainer.json
```

## Config Inheritance

```
base.config.json
    │
    ├─ extensions: {required: ["continue.continue"]}
    ├─ continueConfig: {enabled: true}
    ├─ features: {logging: {...}, linting: {...}}
    │
    ▼
python.config.json (extends base)
    │
    ├─ extends: "base.config.json"
    ├─ extensions: {additional: ["ms-toolsai.jupyter"]}
    ├─ features: {logging: {library: "loguru"}}
    │
    ▼
Merged Configuration
    │
    ├─ extensions: {required: ["continue.continue"],
    │               additional: ["ms-toolsai.jupyter"]}
    ├─ continueConfig: {enabled: true}
    ├─ features: {logging: {library: "loguru", ...}}
```

## Developer Workflow

```
┌──────────────┐
│ Developer    │
│ Sets Config  │
└──────┬───────┘
       │
       ▼
┌─────────────────┐
│ Opens VS Code   │
│ Repo Folder     │
└──────┬──────────┘
       │
       ▼
┌──────────────────────┐
│ Clicks "Reopen in    │
│ Container"           │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐    ┌────────────────┐
│ Container Builds     │───▶│ AI Backend     │
│ & Starts             │    │ Starts         │
└──────┬───────────────┘    └────────────────┘
       │
       ▼
┌──────────────────────┐
│ Config Loads         │
│ - Extensions install │
│ - Continue setup     │
│ - Env vars set       │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│ Ready to Code!       │
│ - Press Ctrl+I       │
│ - Use AI assistance  │
│ - All tools ready    │
└──────────────────────┘
```

## Key Components

1. **Configuration Files**: Define what to install and configure
2. **Loader Script**: Reads configs and applies settings
3. **DevContainer**: Runs the container with proper setup
4. **Continue Extension**: AI assistance always configured
5. **AI Backend**: Self-hosted model service

## Benefits

✅ **Portable**: Works on any machine with Docker + VS Code
✅ **Flexible**: Switch configs without rebuilding
✅ **Consistent**: Same setup for all team members
✅ **Extensible**: Easy to add new languages/tools
✅ **AI-Powered**: Continue integrated in every config