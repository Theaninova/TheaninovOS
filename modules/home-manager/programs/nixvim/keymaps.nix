[
  {
    key = "<leader>u";
    mode = "n";
    action = "<cmd>:UndotreeToggle<CR>";
  }
  # Find/Navigate
  {
    key = "<leader>ft";
    action = "<cmd>:Neotree toggle<CR>";
  }
  {
    key = "J";
    mode = "v";
    action = ":m '>+1<CR>gv=gv";
  }
  {
    key = "K";
    mode = "v";
    action = ":m '<-2<CR>gv=gv";
  }

  {
    key = "<C-d>";
    mode = "n";
    action = "<C-d>zz";
  }
  {
    key = "<C-u>";
    mode = "n";
    action = "<C-u>zz";
  }
  {
    key = "<leader>p";
    mode = "x";
    action = ''"_dP'';
  }
  {
    key = "<leader>p";
    mode = "n";
    action = ''"_dP'';
  }
  {
    key = "<leader>p";
    mode = "v";
    action = ''"_dP'';
  }
  {
    key = "<leader>n";
    mode = "n";
    options.silent = true;
    action = "vim.lsp.buf.hover";
    lua = true;
  }
  {
    key = "hh";
    mode = "n";
    action = ":Telescope harpoon marks<CR>";
  }
  # LSP Actions
  {
    key = "<leader>sa";
    mode = "n";
    options.silent = true;
    lua = true;
    action = "require('actions-preview').code_actions";
  }
  {
    key = "<leader>sf";
    mode = "n";
    options.silent = true;
    action = "<cmd>:ConformToggle<CR>";
  }
  # Trouble
  {
    key = "<leader>xx";
    mode = "n";
    lua = true;
    action = "require('trouble').toggle";
  }
  {
    key = "<leader>xw";
    mode = "n";
    lua = true;
    action =
      "function() require('trouble').toggle('workspace_diagnostics') end";
  }
  {
    key = "<leader>xd";
    mode = "n";
    lua = true;
    action = "function() require('trouble').toggle('document_diagnostics') end";
  }
  {
    key = "<leader>xq";
    mode = "n";
    lua = true;
    action = "function() require('trouble').toggle('quickfix') end";
  }
  {
    key = "<leader>xl";
    mode = "n";
    lua = true;
    action = "function() require('trouble').toggle('loclist') end";
  }
]
