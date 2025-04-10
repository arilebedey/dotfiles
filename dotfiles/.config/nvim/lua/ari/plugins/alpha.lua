return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⠀⢀⠀⡀⢀⢀⠀⠄⢀⠄⢀⠄⡠⢀⢄⠠⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠐⢀⠁⠌⢐⠀⡂⢐⠀⡡⠐⢄⠡⡀⠕⡈⢄⠢⡑⠔⡄⡁⢆⢁⠐⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠈⠀⠂⠐⡀⠂⠌⡠⢈⠔⠠⡁⠔⡁⢢⠡⡘⢔⠨⢂⠂⢎⢌⠌⡂⠢⠀⠌⠐⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠂⢀⠈⢀⠁⠂⠄⠡⣈⠔⠠⡂⠱⡀⢊⠐⢄⢃⠌⡢⡑⡤⢋⢄⠢⡈⢄⠈⡐⠀⡈⠀]],
      [[⠀⠀⠀⠀⠀⠀⠈⠀⠄⢀⠀⠂⡈⢀⠊⡠⢀⢊⢔⡑⢕⢌⢌⢎⠔⠕⡌⡺⡑⢜⠄⡃⠢⠈⠄⠐⠀⠠⠀⠠]],
      [[⠀⠀⠀⠄⠀⠁⠀⠂⠠⠀⠄⢁⠀⠂⠔⢠⠃⡔⡡⢸⡑⠣⡘⣄⢣⡱⢌⢎⠌⡢⢊⢈⠐⡁⢈⠀⡁⠀⠂⠀]],
      [[⠀⠀⢀⠀⠠⠀⠁⠀⠂⠐⡀⠂⡈⢈⠔⡡⠓⠴⡌⢤⣉⢪⣎⢖⡕⢕⠱⡐⠡⢂⠂⡐⠄⠐⠀⠄⠀⠐⠀⠐]],
      [[⠀⡀⠀⠀⠠⠀⡈⢀⠑⡀⢂⠈⠠⠂⡐⢌⡙⡐⣕⢱⣿⡳⣝⢕⢍⠪⣂⠑⡡⠂⡈⠄⠠⠈⡀⠄⠈⠀⠠⠀]],
      [[⠀⠀⠀⡈⠀⠠⠀⠄⠂⠌⠠⠈⠐⡈⠐⢤⡩⡣⡪⡫⢪⠣⡪⠢⡑⢅⠄⡑⠄⡈⡀⠐⠀⠂⡀⠀⠐⠀⢀⠀]],
      [[⠀⠁⠀⡀⠐⠀⠌⡐⡁⢊⠠⠈⠂⢥⡓⡄⢕⠜⡌⢪⠂⡣⢊⠢⠑⡠⠂⠔⠠⠠⢀⠁⢈⠀⢀⠀⠂⠀⠀⠀]],
      [[⠈⠀⠄⠠⠈⢂⠐⡐⠠⠀⢄⠪⡈⠢⡑⡈⠢⢊⠔⠡⢊⠄⢅⢈⠢⢀⠊⢀⠂⠐⠀⡀⠁⠀⠀⠀⢀⠀⠐⠀]],
      [[⢀⠁⡐⢀⠂⠠⠐⠀⡂⢌⠠⠂⢌⠐⡀⢊⠐⠡⢈⠊⠠⠂⠢⢀⠂⡐⠀⡁⠀⠡⠀⡀⠐⠀⠈⠀⠀⠀⠀⠀]],
      [[⡀⠂⠨⡀⠂⡐⢌⠐⠡⠠⠁⠊⢀⠂⠈⠄⢈⠂⠄⠡⠈⢄⠁⡐⢀⠐⠠⠀⡈⢀⠀⢀⠀⢀⠀⢀⠀⠀⠀⠀]],
      [[⠠⠈⠀⠠⠀⡐⠀⠡⠈⡀⢁⠈⡀⠠⠁⠐⢀⠐⢀⠁⠂⠄⠐⠀⠄⠐⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("s", "󰱼  > Find Frequent", "<cmd>Telescope frecency workspace=CWD theme=ivy<CR>"),
      dashboard.button("t", "󰱼  > Find Recent", "<cmd>Telescope oldfiles theme=ivy<CR>"),
      dashboard.button("p", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("g", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      -- dashboard.button("r", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
