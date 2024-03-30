# https://github.com/iamcco/markdown-preview.nvim/issues/536#issuecomment-1954808248
local vscode = not vim.g.vscode
return {
    "iamcco/markdown-preview.nvim",
    cond = vscode,
    config = function()
        local cmd = "flatpak run com.google.Chrome"
        if vim.fn.executable("flatpak") ~= 1 then
            if vim.fn.executable("distrobox-host-exec") == 1 then
                cmd = "distrobox-host-exec " .. cmd
            else
                vim.notify("chrome not found")
                cmd = ""
            end
        end

        vim.api.nvim_exec2(
            string.gsub(
              [[
            function MkdpBrowserFn(url)
              execute '!#' a:url
            endfunction
            ]],
              "#",
              cmd
            ),
            {}
          )
        vim.g.mkdp_browserfunc = "MkdpBrowserFn"
    end
}

