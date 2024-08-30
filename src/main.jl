module Lopi

export main

using Revise

using GLFW
using ModernGL

include("utils.jl")
include("geometry.jl")

include("gfx/gfx.jl")
include("ui/ui.jl")

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
