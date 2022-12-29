--[[
  Todo ::
  - [ ] Lua auto formatting
  - [ ] Make command selectable
  - [ ] Able to show ?hidden window
  - [ ] Store commands on separate window
  - [ ] Keybinding for <F-5> ??
--]]


buffer_id = -1
command_name = "MyStuff";
command_to_run = {'node', 'main.js'}

function createBuffer()
    if not buffer_id or buffer_id < 0 then
      vim.cmd ':new +setl\\ buftype=nofile'
      buffer_id = vim.api.nvim_get_current_buf()
    end
end

vim.api.nvim_create_user_command(
  command_name,
  function(options)
    createBuffer()

    vim.fn.jobstart(command_to_run, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        vim.api.nvim_buf_set_lines(buffer_id, 0, -1, false, data)
      end
    })
  end,
  {}
)

vim.cmd "noremap ő :so<CR>"
vim.cmd ":MyStuff"
