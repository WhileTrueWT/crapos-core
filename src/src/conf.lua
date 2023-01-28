-- /conf.lua and src/conf.lua should remain identical
-- ... well technically src/conf.lua does not absolutely need to exist i think
-- but this feels more complete okay

function love.conf(t)
    t.identity = "crapos"
    t.window.title = "CrapOS"
    t.window.icon = nil
    t.window.fullscreen = true
    t.window.width = 1280
    t.window.height = 720
    t.window.depth = 16
end
