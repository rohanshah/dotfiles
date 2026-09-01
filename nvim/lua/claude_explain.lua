local M = {}

local scratch_buffer = nil
local scratch_window = nil

-- Everything from this line down in the scratch buffer is Claude's answer.
-- Lines above it are the prompt (your question + the fenced code).
local response_separator = "──────────────────────────── Claude ────────────────────────────"

local function get_visual_selection()
  local start_position = vim.fn.getpos("'<")
  local end_position = vim.fn.getpos("'>")

  local start_line = start_position[2]
  local start_column = start_position[3]
  local end_line = end_position[2]
  local end_column = end_position[3]

  if start_line == 0 or end_line == 0 then
    return ""
  end

  if start_line > end_line then
    start_line, end_line = end_line, start_line
    start_column, end_column = end_column, start_column
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  if #lines == 0 then
    return ""
  end

  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_column, end_column)
  else
    lines[1] = string.sub(lines[1], start_column)
    lines[#lines] = string.sub(lines[#lines], 1, end_column)
  end

  return table.concat(lines, "\n")
end

local function compact_empty_lines(lines)
  local compacted_lines = {}

  for _, line in ipairs(lines) do
    if line ~= "" then
      table.insert(compacted_lines, line)
    end
  end

  return compacted_lines
end

local function wrap_text(contents, width)
  local wrapped_lines = {}

  for _, line in ipairs(vim.split(contents or "", "\n", { plain = true })) do
    if line == "" then
      table.insert(wrapped_lines, "")
    else
      local current_line = ""

      for word in string.gmatch(line, "%S+") do
        if current_line == "" then
          current_line = word
        elseif #current_line + 1 + #word <= width then
          current_line = current_line .. " " .. word
        else
          table.insert(wrapped_lines, current_line)
          current_line = word
        end
      end

      if current_line ~= "" then
        table.insert(wrapped_lines, current_line)
      end
    end
  end

  return table.concat(wrapped_lines, "\n")
end

-- Returns the prompt region (everything above the response separator) as text.
local function get_prompt_text()
  if not scratch_buffer or not vim.api.nvim_buf_is_valid(scratch_buffer) then
    return ""
  end

  local lines = vim.api.nvim_buf_get_lines(scratch_buffer, 0, -1, false)
  local prompt_lines = {}

  for _, line in ipairs(lines) do
    if line == response_separator then
      break
    end
    table.insert(prompt_lines, line)
  end

  return table.concat(prompt_lines, "\n")
end

-- Replace the response region (from the separator down) with new content,
-- leaving the user's prompt above it untouched.
local function set_response(contents)
  if not scratch_buffer or not vim.api.nvim_buf_is_valid(scratch_buffer) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(scratch_buffer, 0, -1, false)
  local separator_index = nil

  for index, line in ipairs(lines) do
    if line == response_separator then
      separator_index = index
      break
    end
  end

  local prompt_lines = {}
  local prompt_count = separator_index and (separator_index - 1) or #lines

  for index = 1, prompt_count do
    table.insert(prompt_lines, lines[index])
  end

  -- Trim trailing blank lines from the prompt so spacing stays consistent.
  while #prompt_lines > 0 and prompt_lines[#prompt_lines] == "" do
    table.remove(prompt_lines)
  end

  local new_lines = {}
  vim.list_extend(new_lines, prompt_lines)
  vim.list_extend(new_lines, { "", response_separator, "" })
  vim.list_extend(new_lines, vim.split(contents or "", "\n", { plain = true }))

  vim.bo[scratch_buffer].modifiable = true
  vim.api.nvim_buf_set_lines(scratch_buffer, 0, -1, false, new_lines)
end

local function build_failure_message(exit_code, stdout_output, stderr_output)
  local combined_output = table.concat(compact_empty_lines({
    stdout_output,
    stderr_output,
  }), "\n")

  local diagnostic_lines = {
    "Claude failed.",
    "",
    "Exit code: " .. tostring(exit_code),
    "",
  }

  if string.find(combined_output, "Not logged in", 1, true)
    or string.find(combined_output, "Please run /login", 1, true)
    or string.find(combined_output, "auth", 1, true)
  then
    vim.list_extend(diagnostic_lines, {
      "Claude CLI appears to be unauthenticated in the environment Neovim is using.",
      "",
      "From the same shell that launches Neovim, run:",
      "",
      "  claude auth status",
      "  claude auth login",
      "",
    })
  end

  vim.list_extend(diagnostic_lines, {
    "Output:",
    "",
    combined_output ~= "" and combined_output or "<no output>",
  })

  return table.concat(diagnostic_lines, "\n")
end

-- Send the current prompt region to Claude and stream the answer back into
-- the response region of the scratch buffer.
local spinner_frames = { "|", "/", "-", "\\" }

-- Show an animated "Waiting" line in the response region until stopped.
local function start_spinner()
  local frame_index = 1
  set_response("Waiting " .. spinner_frames[frame_index])

  return vim.fn.timer_start(120, function()
    frame_index = (frame_index % #spinner_frames) + 1
    set_response("Waiting " .. spinner_frames[frame_index])
  end, { ["repeat"] = -1 })
end

local function send_prompt()
  local prompt = vim.trim(get_prompt_text())

  if prompt == "" then
    vim.notify("Nothing to ask Claude (prompt is empty)", vim.log.levels.WARN)
    return
  end

  vim.notify("Sent to Claude…", vim.log.levels.INFO)

  local spinner_timer = start_spinner()
  local stdout_chunks = {}
  local stderr_chunks = {}

  local job_identifier = vim.fn.jobstart({
    "claude",
    "-p",
    "--output-format",
    "text",
  }, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data)
      if data then
        vim.list_extend(stdout_chunks, data)
      end
    end,

    on_stderr = function(_, data)
      if data then
        vim.list_extend(stderr_chunks, data)
      end
    end,

    on_exit = function(_, exit_code)
      vim.schedule(function()
        vim.fn.timer_stop(spinner_timer)

        local stdout_output = table.concat(compact_empty_lines(stdout_chunks), "\n")
        local stderr_output = table.concat(compact_empty_lines(stderr_chunks), "\n")

        if exit_code ~= 0 then
          set_response(build_failure_message(exit_code, stdout_output, stderr_output))
          return
        end

        if stdout_output == "" then
          set_response("Command completed successfully, but stdout was empty.")
          return
        end

        set_response(wrap_text(stdout_output, 80))
      end)
    end,
  })

  if job_identifier <= 0 then
    vim.fn.timer_stop(spinner_timer)
    set_response('Failed to start Claude CLI. Check :echo executable("claude")')
    return
  end

  vim.fn.chansend(job_identifier, prompt)
  vim.fn.chanclose(job_identifier, "stdin")
end

local function open_scratch_window(initial_lines)
  if scratch_window and vim.api.nvim_win_is_valid(scratch_window) then
    vim.api.nvim_set_current_win(scratch_window)
    if scratch_buffer and vim.api.nvim_buf_is_valid(scratch_buffer) then
      vim.bo[scratch_buffer].modifiable = true
      vim.api.nvim_buf_set_lines(scratch_buffer, 0, -1, false, initial_lines)
    end
    return
  end

  vim.cmd("botright split")

  local current_window = vim.api.nvim_get_current_win()
  local current_buffer = vim.api.nvim_create_buf(false, true)

  scratch_window = current_window
  scratch_buffer = current_buffer

  vim.api.nvim_win_set_buf(current_window, current_buffer)
  vim.api.nvim_win_set_height(current_window, math.max(12, math.floor(vim.o.lines * 0.4)))

  vim.bo[current_buffer].filetype = "markdown"
  vim.bo[current_buffer].buftype = "nofile"
  vim.bo[current_buffer].bufhidden = "wipe"
  vim.bo[current_buffer].swapfile = false
  vim.bo[current_buffer].modifiable = true
  vim.bo[current_buffer].textwidth = 80

  vim.wo[current_window].wrap = true
  vim.wo[current_window].linebreak = true

  vim.api.nvim_buf_set_name(current_buffer, "Ask Claude")

  vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, initial_lines)

  vim.keymap.set("n", "q", "<cmd>close<CR>", {
    buffer = current_buffer,
    silent = true,
    desc = "Close Claude window",
  })

  -- <CR> in normal mode sends. Insert-mode Enter still makes newlines so you
  -- can write a multi-line question.
  vim.keymap.set("n", "<CR>", send_prompt, {
    buffer = current_buffer,
    silent = true,
    desc = "Send prompt to Claude",
  })
end

function M.ask_about_selection()
  local selected_code = get_visual_selection()

  if selected_code == "" then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  local filetype = vim.bo.filetype

  local initial_lines = {}
  -- Question area: cursor starts here so you can type immediately.
  table.insert(initial_lines, "")
  table.insert(initial_lines, "")
  table.insert(initial_lines, "```" .. filetype)
  vim.list_extend(initial_lines, vim.split(selected_code, "\n", { plain = true }))
  table.insert(initial_lines, "```")

  open_scratch_window(initial_lines)

  -- Put the cursor on the first (empty) line and drop into insert mode.
  vim.api.nvim_win_set_cursor(scratch_window, { 1, 0 })
  vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("ClaudeAsk", function()
  M.ask_about_selection()
end, { range = true })

vim.keymap.set("v", "<leader>ce", function()
  vim.cmd("normal! gv")
  M.ask_about_selection()
end, {
  silent = true,
  desc = "Ask Claude about selected code",
})

return M
