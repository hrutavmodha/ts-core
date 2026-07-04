# Native TypeScript Browser

This project outlines and implements the direct modification of the V8 JavaScript engine and the Blink rendering engine to natively parse, compile, and execute TypeScript inside the browser.

---

## 1. Project Architecture & Workspace Layout

The workspace is configured as a single Git repository containing the main configuration, setup scripts, and the complete Chromium source tree.

```
ts-browser/ (Workspace Root - Git Repository)
├── .gclient                       # Google gclient configuration
├── depot_tools/                   # Symlink to Google build toolchain
├── scripts/
│   └── setup.sh                   # Initialization and environment setup script
└── src/                           # Chromium codebase (Nested .git repos removed)
    ├── third_party/blink/         # Blink Rendering Engine
    └── v8/                        # V8 JavaScript Engine
```

> [!IMPORTANT]
> The nested `.git` repositories inside the `src/` directory tree have been removed to enable a unified, flat repository workflow. You can track your changes to any of the Chromium/V8 files directly in the root repository. Do not run `git add src/` wholesale, as staging 30GB of files will freeze Git. Only add the specific files you modify.

---

## 2. Setup and Prerequisites

### System Requirements

* Ubuntu/Linux environment
* Python 3 and Git installed
* Disk space: At least 100GB of free space

### Getting Started

1. Add `depot_tools` to your path:
   ```bash
   export PATH="/home/hrutav-modha/depot_tools:$PATH"
   ```
2. Run the initialization script [setup.sh](file:///home/hrutav-modha/Documents/ts-browser/scripts/setup.sh):
   ```bash
   ./scripts/setup.sh
   ```
3. Fetch the Chromium source tree (without Git history to save space):
   ```bash
   fetch --no-history chromium
   ```

---

## 3. Core Targets for Modification

To enable native TypeScript support, modifications are divided into two main areas:

### A. V8 engine (Parser and Bytecode Generator)

* **Tokens**: Register TypeScript keywords in [token.h](file:///home/hrutav-modha/Documents/ts-browser/src/v8/src/parsing/token.h).
* **Scanner**: Extend [scanner.h](file:///home/hrutav-modha/Documents/ts-browser/src/v8/src/parsing/scanner.h) and [scanner.cc](file:///home/hrutav-modha/Documents/ts-browser/src/v8/src/parsing/scanner.cc) to parse type declarations, generics, and skip type annotations.
* **Parser**: Modify [parser-base.h](file:///home/hrutav-modha/Documents/ts-browser/src/v8/src/parsing/parser-base.h), [parser.h](file:///home/hrutav-modha/Documents/ts-browser/src/v8/src/parsing/parser.h), and [parser.cc](file:///home/hrutav-modha/Documents/ts-browser/src/v8/src/parsing/parser.cc) to perform type erasure (discarding type annotations) and generate AST nodes for TS constructs like `enum` or `namespace`.
* **Bytecode**: Optional type checking code generation in [bytecode-generator.cc](file:///home/hrutav-modha/Documents/ts-browser/src/v8/src/interpreter/bytecode-generator.cc).

### B. Blink Engine (Script Loading and MIME Types)

* **MIME Types**: Allow TypeScript scripts in [mime_type_registry.cc](file:///home/hrutav-modha/Documents/ts-browser/src/third_party/blink/renderer/platform/network/mime/mime_type_registry.cc).
* **Script Loader**: Enable the loader to process `application/typescript` script tags and `.ts` files inside:
  * [script_loader.cc](file:///home/hrutav-modha/Documents/ts-browser/src/third_party/blink/renderer/core/script/script_loader.cc)
  * [classic_pending_script.cc](file:///home/hrutav-modha/Documents/ts-browser/src/third_party/blink/renderer/core/script/classic_pending_script.cc)
  * [module_pending_script.cc](file:///home/hrutav-modha/Documents/ts-browser/src/third_party/blink/renderer/core/script/module_pending_script.cc)

---

## 4. Compilation Workflow

Compile the browser binary from the `src/` directory:

```bash
# Navigate to the source root
cd src

# 1. Generate build configurations
gn gen out/Default

# 2. Build the executable
autoninja -C out/Default chrome
```

The build system will automatically compile your changes and link them into the final browser binary.

---

## 5. Credits & Acknowledgments

This project is built directly upon the open-source **Chromium Project**. We express our gratitude to the Chromium authors and contributors for their extensive work on the browser platform. The Chromium codebase is licensed under the BSD 3-Clause License, and all original copyright headers and license files inside the `src/` directory are strictly preserved.



