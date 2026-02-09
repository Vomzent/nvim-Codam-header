# header42.nvim

Unofficial lua port of **[42header](https://github.com/42paris/42header)** made for neovim.

### Description

This is a neovim plugin for the 42 standard header.

### Installation

<details open>
  <summary>Using lazy.nvim</summary>

```lua
{
  "https://codeberg.org/42nerds/header42.nvim",
  version = "*",
  lazy = true,
  cmd = { "Header42" },
  ft = { "c", "cpp", "python" },
  opts = {
    -- your configuration
  },
}
```

</details>

#### Textwidth

This plugin uses `vim.bo.textwidth` for formatting the header.
You can configure the textwidth for each filetype in `after/ftplugin/`.

> after/ftplugin/c.lua

```lua
vim.opt_local.textwidth = 80
```

> after/ftplugin/python.lua

```lua
vim.opt_local.textwidth = 79
```

### Configuration

<details open>
  <summary>Default configuration</summary>

```lua
{
  username = function()
    return require("header42.git").username() or os.getenv("USER") or "unknown"
  end,
  domain = "student.42.fr",
  email = function(username, domain)
    return require("header42.git").email() or os.getenv("MAIL") or username .. "@" .. domain
  end,
  autocmd = {
    create = true,
    pattern = { "*.c", "*.h", "*.cc", "*.hh", "*.cpp", "*.hpp", "*.py" },
  },
  asciiart = {
    "        :::      ::::::::",
    "      :+:      :+:    :+:",
    "    +:+ +:+         +:+  ",
    "  +#+  +:+       +#+     ",
    "+#+#+#+#+#+   +#+        ",
    "     #+#    #+#          ",
    "    ###   ########.fr    ",
  },
  commentstrings = {
    c = { "/*", "*", "*/" },
    h = { "/*", "*", "*/" },
    cc = { "/*", "*", "*/" },
    hh = { "/*", "*", "*/" },
    cpp = { "/*", "*", "*/" },
    hpp = { "/*", "*", "*/" },
    python = { "#", "#", "#" },
    lua = { "--", "-", "--" },
    fallback = { "#", "*", "#" },
  },
}
```

</details>

#### Username and email address

You can define the username and email address statically:

```lua
{
  username = "myusername",
  email = "myusername@student.42.fr",
}
```

Or dynamically, in which case the value will be evaluated lazily:

```lua
{
  username = function()
    return require("header42.git").username() or os.getenv("USER") or "myusername"
  end,
  email = function(username, domain)
    return require("header42.git").email() or os.getenv("MAIL") or username .. "@" .. domain
  end,
}
```

### Usage

You can run the `:Header42` command to update the header (if it exists). To insert a new header at the beginning of the file, add a bang to the command: `:Header42!`.

If `autocmd.create = true`, the header will be updated automatically when the `BufWritePre` event is triggered.

### Credits

This project is based on the official **[42header](https://github.com/42paris/42header)** vim plugin.

### License

This work is published under the terms of **[42 Unlicense](https://github.com/gcamerli/42unlicense)**.
