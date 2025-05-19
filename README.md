# goerrfold.nvim

goerrfold.nvim is a Neovim plugin to fold error handling blocks like `if err := nil {...}` of Go.

## Installation

### lazy.nvim

```lua
{
  "candy12t/goerrfold.nvim",
  config = function()
    require("goerrfold").setup()
  end,
},
```

## Configuration

goerrfold.nvim comes with the following defaults:

```lua
{
  -- Whether to automatically fold error handling blocks when the file is opened
  auto_fold = true,
  -- Whether to fold error handling blocks when the file is saved
  fold_on_save = true,
}
```

## Usage

goerrfold.nvim provides `:GoErrFold` Command.

- `:GoErrFold fold`: fold the following error handling blocks.
  - `if err := nil {...}`
  - `if err := doSomething(); err != nil {...}`
- `:GoErrFold unfold`: unfold the folded error handling blocks.
- `:GoErrFold toggle`: toggle between `fold` and `unfold`.

## License

MIT License

## Author

candy12t
