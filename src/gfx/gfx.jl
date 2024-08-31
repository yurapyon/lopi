module GFX

export init, deinit

export Texture, setwrap!, setfilter!, setbordercolor!

using ModernGL

include("texture.jl")

using GLFW

struct GfxContext
    window::GLFW.Window
end

function init()
    GLFW.WindowHint(GLFW.FLOATING, true)
    window = GLFW.CreateWindow(640, 480, "GLFW.jl")

    GLFW.MakeContextCurrent(window)

    GfxContext(window)
end

function deinit(context)
    GLFW.DestroyWindow(context.window)
    GLFW.PollEvents()
end

end
