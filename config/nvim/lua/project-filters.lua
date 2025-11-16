local M = {}

-- Define exclusion patterns for different projects
M.projects = {
    godot = {
        detect = function()
            return vim.fn.findfile('project.godot', '.;') ~= ''
        end,
        fd_excludes = '--exclude "*.tscn" --exclude "*.uid" --exclude "*.import" --exclude "*.tres"',
        rg_excludes = '-g "!*.tscn" -g "!*.uid" -g "!*.import" -g "!*.tres"'
    },
}

-- Get exclusions for current project
function M.get_exclusions()
    for name, project in pairs(M.projects) do
        if project.detect() then
            return {
                fd = project.fd_excludes,
                rg = project.rg_excludes,
                type = name
            }
        end
    end
    return { fd = '', rg = '', type = 'none' }
end

-- Get specific project type exclusions
function M.get_fd_excludes()
    return M.get_exclusions().fd
end

function M.get_rg_excludes()
    return M.get_exclusions().rg
end

return M
