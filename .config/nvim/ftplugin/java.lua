local function is_java_string_format(lines)
  -- Check if the selection looks like Java string concatenation
  if #lines == 0 then
    return false
  end

  -- Single line case: should be "content\n"; or "content";
  if #lines == 1 then
    local trimmed = lines[1]:match '^%s*(.-)%s*$'
    return trimmed:match '^".*".*;?$' ~= nil
  end

  -- Multiple lines case
  -- First line should start with quote and end with quote
  local first_trimmed = lines[1]:match '^%s*(.-)%s*$'
  if not first_trimmed:match '^".*"$' then
    return false
  end

  -- Middle lines should have + pattern
  for i = 2, #lines - 1 do
    local trimmed = lines[i]:match '^%s*(.-)%s*$'
    if not trimmed:match '^%+%s*".*"$' then
      return false
    end
  end

  -- Last line should have + pattern and end with semicolon
  if #lines > 1 then
    local last_trimmed = lines[#lines]:match '^%s*(.-)%s*$'
    if not last_trimmed:match '^%+%s*".*".*;$' then
      return false
    end
  end

  return true
end

local function to_java_string(lines)
  -- Transform lines into Java string format
  local result = {}
  for i, line in ipairs(lines) do
    -- Escape double quotes and backslashes in the line content
    local escaped_line = line:gsub('\\', '\\\\'):gsub('"', '\\"')

    if i == 1 and #lines == 1 then
      -- Single line: quote + content + \n + semicolon
      table.insert(result, '"' .. escaped_line .. '\\n";')
    elseif i == 1 then
      -- First line of multiple: quote + content + \n
      table.insert(result, '"' .. escaped_line .. '\\n"')
    elseif i == #lines then
      -- Last line of multiple: + quote + content + semicolon (no \n)
      table.insert(result, '+ "' .. escaped_line .. '";')
    else
      -- Middle lines: + quote + content + \n
      table.insert(result, '+ "' .. escaped_line .. '\\n"')
    end
  end
  return result
end

local function from_java_string(lines)
  -- Transform Java string format back to regular text
  local result = {}
  for _, line in ipairs(lines) do
    -- Remove leading/trailing whitespace
    local trimmed = line:match '^%s*(.-)%s*$'

    -- Remove + prefix if present
    if trimmed:match '^%+' then
      trimmed = trimmed:match '^%+%s*(.*)$'
    end

    -- Remove quotes and semicolon
    if trimmed:match '^".*"$' then
      -- Extract content between quotes
      local content = trimmed:match '^"(.*)"$'
      -- Remove trailing semicolon if present
      content = content:gsub(';$', '')
      -- Remove \n suffix if present
      content = content:gsub('\\n$', '')
      -- Unescape quotes and backslashes
      content = content:gsub('\\"', '"'):gsub('\\\\', '\\')
      table.insert(result, content)
    else
      -- If it doesn't match expected format, keep as-is
      table.insert(result, line)
    end
  end
  return result
end

local function toggle_java_string()
  -- Get the visual selection range
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  local result
  if is_java_string_format(lines) then
    -- Convert from Java string format to regular text
    result = from_java_string(lines)
  else
    -- Convert to Java string format
    result = to_java_string(lines)
  end

  -- Replace the selected lines with the transformed content
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, result)
end

-- Create a command that can be used with ranges
vim.api.nvim_buf_create_user_command(0, 'JavaString', function(opts)
  -- Set the visual selection marks based on the command range
  if opts.range > 0 then
    vim.api.nvim_buf_set_mark(0, '<', opts.line1, 0, {})
    vim.api.nvim_buf_set_mark(0, '>', opts.line2, 0, {})
  end
  toggle_java_string()
end, {
  range = true,
  desc = 'Toggle Java string concatenation format',
})

-- Optional: Create a keymap for visual mode
vim.keymap.set('v', '<leader>js', function()
  toggle_java_string()
end, {
  buffer = true,
  desc = 'Toggle Java string concatenation format',
})
