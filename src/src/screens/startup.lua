local screen = {}

function screen.load()
	messageBox("Message Box", "This is a message box")
end

function screen.draw()
	text("Hello, world!", 10, 10, {1, 1, 1, 1})
end

return screen