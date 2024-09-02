module Lopi

export main

using Revise
using GLFW

using FileIO
using ImageIO

include("utils/utils.jl")
include("geometry.jl")

include("gfx/gfx.jl")
include("ui/ui.jl")
include("animation/animation.jl")

using .GFX

function main()
    ctx = GFX.init()

    try
        img = load("common/oatchi.png")

        tex = Texture(img)
        print(tex)

        # print(typeof(ctx.window))
        # t1 = GFX.GL.Texture(10, 10)
        # t2 = GFX.GL.Texture(10, 10)
        # print(t1, t2)

        while !GLFW.WindowShouldClose(ctx.window)
            Revise.revise()
            Base.invokelatest(UI.draw)

            GLFW.SwapBuffers(ctx.window)
            GLFW.PollEvents()
        end
    finally
        GFX.deinit(ctx)
    end
end

end
