--[[
  Todo ::
  - [X] Lua auto formatting
  - [X] Make command selectable
  - [ ] Able to show ?hidden window
  - [ ] Store commands on separate window
    - [ ] Add command
    - [ ] Remove command
  - [ ] Keybinding for <F-5> ??
--]]

local pickers = require'telescope.pickers'
local finders = require'telescope.finders'
local actions = require'telescope.actions'
local action_state = require'telescope.actions.state'
local conf = require('telescope.config').values

-- local buffer_id = buffer_id
local buffer_id = -1
local command_name = 'MyStuff'
local available_commands = { {
	'Run main.js ',
	command = { 'node', 'main.js' },
}, {
	'Run main.js with TsNode',
	command = { 'ts-node', 'main.js' },
} }

local function createBuffer()
	if not buffer_id or buffer_id < 0 then
		vim.cmd':new +setl\\ buftype=nofile'
		buffer_id = vim.api.nvim_get_current_buf()
	end
end

local function execute_command(command)
	vim.fn.jobstart(command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			vim.api.nvim_buf_set_lines(buffer_id, 0, -1, false, data)
		end,
	})
end

local colors = function(opts)
	opts = opts or require('telescope.themes').get_dropdown{}
	pickers.new(opts, {
		finder = finders.new_table{
			results = available_commands, -- { { 'red', '#ff0000' }, { 'green', '#00ff00' }, { 'blue', '#0000ff' } },
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry[1], -- To display
					ordinal = entry[1], -- For sorting
				}
			end,
		},
		prompt_title = 'colors',
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				createBuffer()
				execute_command(selection.value.command)
			end)
			return true
		end,
	}):find()
end

vim.api.nvim_create_user_command(
	command_name,
	function(_)
		colors()
	end,
	{}
)

vim.cmd'noremap ő :so<CR>'
-- vim.cmd':MyStuff'

-- to execute the function
-- colors()
-- colors(require('telescope.themes').get_dropdown{})
