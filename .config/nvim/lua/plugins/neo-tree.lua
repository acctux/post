return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        bind_to_cwd = true,
        cwd_target = {
          sidebar = "tab",
          current = "window",
        },
        follow_current_file = {
          enabled = true,
        },
        window = {
          mappings = {
            ["N"] = "add_directory", -- separate key for directory
            ["n"] = "add", -- also allow 'n' to create a file
          },
        },
      },
    })
  end,
}
