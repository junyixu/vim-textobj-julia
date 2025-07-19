# vim-textobj-julia

A Vim plugin providing text objects and motions for Julia code.

## Features

- **Function text objects**: Select entire Julia functions with `af`/`if`
- **Macro text objects**: Select Julia macros with `aM`/`iM`
- **Smart block matching**: Uses `searchpair()` for accurate nested structure detection
- **Robust parsing**: Handles complex Julia constructs including functions, if/else, for loops, while loops, try/catch, and begin/end blocks
- **Motion support**: Navigate between functions and macros with `]m`/`[m` and `]M`/`[M`

## Installation

### Using [vim-plug](https://github.com/junegunn/vim-plug)

Add to your `.vimrc`:
```vim
Plug 'your-username/vim-textobj-julia'
```

### Using [Vundle](https://github.com/VundleVim/Vundle.vim)

Add to your `.vimrc`:
```vim
Plugin 'your-username/vim-textobj-julia'
```

### Manual Installation

Clone this repository into your Vim plugin directory:
```bash
git clone https://github.com/your-username/vim-textobj-julia.git ~/.vim/pack/plugins/start/vim-textobj-julia
```

## Dependencies

- [vim-textobj-user](https://github.com/kana/vim-textobj-user) - Required for text object functionality

## Usage

### Text Objects

| Object | Description |
|--------|-------------|
| `af` | Select entire function (including `function` and `end`) |
| `if` | Select function body (excluding `function` and `end` lines) |
| `aM` | Select entire macro (including `macro` and `end`) |
| `iM` | Select macro body (excluding `macro` and `end` lines) |

### Motions

| Motion | Description |
|--------|-------------|
| `]m` | Jump to next function |
| `[m` | Jump to previous function |
| `]M` | Jump to next macro |
| `[M` | Jump to previous macro |

### Examples

```julia
# With cursor inside the function
function calculate_area(radius::Float64)
    return π * radius^2  # Cursor here
end

# 'af' selects the entire function
# 'if' selects only the body (return π * radius^2)

macro my_macro(x)
    println("Processing: ", x)
    return :($(esc(x)) + 1)
end

# 'aM' selects the entire macro
# 'iM' selects only the macro body
```

## Configuration

No additional configuration is required. The plugin automatically loads for Julia files (`.jl`).

## How It Works

This plugin uses Vim's `searchpair()` function to accurately find matching `end` statements for Julia constructs. This provides robust handling of:

- Nested structures
- Multi-line function signatures
- Block constructs (if/else, for, while, try/catch, begin/end)
- One-liner functions/macros

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Credits

Developed for the Julia programming language community, inspired by existing text object plugins.