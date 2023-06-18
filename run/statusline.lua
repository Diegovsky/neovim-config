local colors = {
  bg = "#1c222c",
  fg = "#abb2bf",
  yellow = "#e5c07b",
  cyan = "#8abeb7",
  darkblue = "#528bff",
  green = "#98c379",
  orange = "#d19a66",
  violet = "#b294bb",
  magenta = "#ff80ff",
  blue = "#61afef",
  red = "#e88388",
}

local lsp = require "feline.providers.lsp"
local vi_mode_utils = require "feline.providers.vi_mode"

local vi_mode_colors = {
  NORMAL = colors.green,
  INSERT = colors.red,
  VISUAL = colors.magenta,
  OP = colors.green,
  BLOCK = colors.blue,
  REPLACE = colors.violet,
  ["V-REPLACE"] = colors.violet,
  ENTER = colors.cyan,
  MORE = colors.cyan,
  SELECT = colors.orange,
  COMMAND = colors.green,
  SHELL = colors.green,
  TERM = colors.green,
  NONE = colors.yellow,
}

local icons = {
  linux = " ",
  macos = " ",
  windows = " ",

  errs = " ",
  warns = " ",
  infos = " ",
  hints = " ",

  lsp = " ",
  git = "",
}

local function file_osinfo()
  local os = vim.bo.fileformat:upper()
  local icon
  if os == "UNIX" then
    icon = icons.linux
  elseif os == "MAC" then
    icon = icons.macos
  else
    icon = icons.windows
  end
  return icon .. os
end

local function lsp_diagnostics_info(s)
  local tr = {
    errs = vim.diagnostic.severity.ERROR,
    warns = vim.diagnostic.severity.WARN,
    infos = vim.diagnostic.severity.INFO,
    hints = vim.diagnostic.severity.HINT,
  }
  return lsp.get_diagnostics_count(tr[s])
end

local function diag_enable(f, s)
  return function()
    local diag = f(s)
    return diag and diag ~= 0
  end
end

local function diag_of(f, s)
  local icon = icons[s]
  return function()
    local diag = f(s)
    return icon .. diag
  end
end

local function vimode_hl()
  return {
    name = vi_mode_utils.get_mode_highlight_name(),
    fg = colors.bg,
    bg = vi_mode_utils.get_mode_color(),
    -- fg = vi_mode_utils.get_mode_color(),
  }
end

local vi_mode_text = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  [""] = "V-BLOCK",
  V = "V-LINE",
  c = "COMMAND",
  no = "UNKNOWN",
  s = "UNKNOWN",
  S = "UNKNOWN",
  ic = "UNKNOWN",
  R = "REPLACE",
  Rv = "UNKNOWN",
  cv = "UNKWON",
  ce = "UNKNOWN",
  r = "REPLACE",
  rm = "UNKNOWN",
  t = "INSERT",
}

-- LuaFormatter off

local comps = {
  vi_mode = {
    provider = function()
      return " " .. vi_mode_text[vim.fn.mode()] .. " "
    end,
    right_sep = " ",
    hl = vimode_hl,
  },
  file = {
    info = {
      provider = {
        name = "file_info",
        opts = {
          type = "relative",
        },
      },
      hl = {
        fg = colors.blue,
        style = "bold",
      },
    },
    encoding = {
      provider = "file_encoding",
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold",
      },
    },
    type = {
      provider = { name = "file_type", opts = {
        filetype_icon = true,
      } },
    },
    os = {
      provider = file_osinfo,
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold",
      },
    },
  },
  line_percentage = {
    provider = "line_percentage",
    left_sep = " ",
    hl = {
      style = "bold",
    },
  },
  scroll_bar = {
    provider = "scroll_bar",
    left_sep = " ",
    hl = {
      fg = colors.blue,
      style = "bold",
    },
  },
  diagnos = {
    err = {
      provider = diag_of(lsp_diagnostics_info, "errs"),
      left_sep = " ",
      enabled = diag_enable(lsp_diagnostics_info, "errs"),
      hl = {
        fg = colors.red,
      },
    },
    warn = {
      provider = diag_of(lsp_diagnostics_info, "warns"),
      left_sep = " ",
      enabled = diag_enable(lsp_diagnostics_info, "warns"),
      hl = {
        fg = colors.yellow,
      },
    },
    info = {
      provider = diag_of(lsp_diagnostics_info, "infos"),
      left_sep = " ",
      enabled = diag_enable(lsp_diagnostics_info, "infos"),
      hl = {
        fg = colors.blue,
      },
    },
    hint = {
      provider = diag_of(lsp_diagnostics_info, "hints"),
      left_sep = " ",
      enabled = diag_enable(lsp_diagnostics_info, "hints"),
      hl = {
        fg = colors.cyan,
      },
    },
  },
  lsp = {
    name = {
      provider = "lsp_client_names",
      left_sep = " ",
      icon = icons.lsp,
      hl = {
        fg = colors.yellow,
      },
    },
  },
  git = {
    branch = {
      provider = "git_branch",
      icon = icons.git,
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold",
      },
    },
    add = {
      provider = "git_diff_added",
      hl = {
        fg = colors.green,
      },
    },
    change = {
      provider = "git_diff_changed",
      hl = {
        fg = colors.orange,
      },
    },
    remove = {
      provider = "git_diff_removed",
      hl = {
        fg = colors.red,
      },
    },
  },
}

local properties = {
  force_inactive = {
    filetypes = {
      "CHADTree",
      "dbui",
      "dirbuf",
      "packer",
      "startify",
      "fugitive",
      "fugitiveblame",
    },
    buftypes = { "terminal" },
    bufnames = {},
  },
}

local statusline_components = {
  active = {
    {
      comps.vi_mode,
    },
    {},
    {
      comps.git.add,
      comps.git.change,
      comps.git.remove,
      comps.file.os,
      comps.git.branch,
      comps.lsp.profile,
    },
  },
  inactive = {
    {
      comps.vi_mode,
      comps.file.info,
    },
    {},
    {
      comps.file.os,
    },
  },
}

local winbar_component = {
  active = {
    {
      comps.file.info,
      comps.diagnos.err,
    },
    {},
    {
    },
  },
  inactive = {
    {
      comps.file.info,
      comps.diagnos.err,
    },
    {},
    {
    },
  }
}

-- LuaFormatter on

package.loaded["feline"] = nil

require("feline").setup {
  default_bg = colors.bg,
  -- default_fg = colors.fg,
  components = statusline_components,
  properties = properties,
  vi_mode_colors = vi_mode_colors,
}

require("feline").winbar.setup {
  components = winbar_component,
}
