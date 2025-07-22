# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is a Vim plugin that provides text objects and motions for Julia code, enabling efficient navigation and selection of Julia functions and macros.

## Architecture
- **Entry point**: `after/ftplugin/julia/textobj-julia.vim` - Loads the plugin and registers text objects with vim-textobj-user
- **Core logic**: `autoload/textobj/julia.vim` - Contains all text object selection and motion functions (autoloaded for performance)
- **Structure**: Follows Vim's autoload pattern for performance and lazy loading

## Key Components
- `textobj#julia#function_select_a()` - Select entire Julia function including `function`/`end`
- `textobj#julia#function_select_i()` - Select Julia function body (excluding `function`/`end`)
- `textobj#julia#macro_select_a()` - Select entire Julia macro including `macro`/`end`
- `textobj#julia#macro_select_i()` - Select Julia macro body (excluding `macro`/`end`)

## Dependencies
- Requires [vim-textobj-user](https://github.com/kana/vim-textobj-user) plugin

## Text Objects & Mappings
- **Functions**: `af` (entire), `if` (inner)
- **Macros**: `aM` (entire), `iM` (inner)
- **Motions**: `]m`/`[m` (next/previous function), `]M`/`[M` (next/previous macro)

## Testing
The plugin uses Vim's native functionality - test by:
1. Opening a Julia file (`.jl`)
2. Using text objects: `vaf`, `vif`, `vaM`, `viM`
3. Using motions: `]m`, `[m`, `]M`, `[M`

## Development Commands
- `:source %` - Reload current file in Vim
- `:call textobj#julia#function_select_a()` - Test function selection
- `:call textobj#julia#macro_select_a()` - Test macro selection