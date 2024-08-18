module Lopi

using ModernGL
using Revise
using GLFW

include("gfx/GFX.jl")
include("ui/UI.jl")

function main()
    ctx = GFX.init()

    print(typeof(ctx.window))

    while !GLFW.WindowShouldClose(ctx.window)
        Revise.revise()
        Base.invokelatest(UI.draw)

        GLFW.SwapBuffers(ctx.window)
        GLFW.PollEvents()
    end

    GFX.deinit(ctx)
end

end
