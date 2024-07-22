-- count occurrences of a pattern within a string
local count_matches = function(str, pattern)
    count = 0
    start = 1
    while true do
        s, e = string.find(str, pattern, start)
        if s then
            count = count + 1
            start = e + 1
        else
            break
        end
    end
    return count
end
-- split a line based on a delimiter
local breakline = function(opts)
    delim = opts.args
    pattern = " *" .. delim .. " *"

    current_line_num = vim.fn.line(".")
    current_line_str = vim.fn.getline(current_line_num)
    number_of_matches = count_matches(current_line_str, pattern)
    if number_of_matches == 0 then
        return nil
    end

    vim.cmd("s/" .. pattern .. "/" .. delim .. "\\r/g")
    vim.cmd("normal " .. number_of_matches .. "=k")
    vim.cmd("noh")
end
vim.api.nvim_create_user_command("Breakline",
breakline,
{
    nargs = 1,
    desc = "split a line on a delimiter."
})
