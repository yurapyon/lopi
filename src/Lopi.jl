module Lopi

using GLFW
using ModernGL
using Revise

include("other_file.jl")

function initgraphics()
    GLFW.WindowHint(GLFW.FLOATING, true)
    window = GLFW.CreateWindow(640, 480, "GLFW.jl")

    GLFW.MakeContextCurrent(window)

    while !GLFW.WindowShouldClose(window)
        Revise.revise()
        Base.invokelatest(testing)

        GLFW.SwapBuffers(window)
        GLFW.PollEvents()
    end

    GLFW.DestroyWindow(window)
    GLFW.PollEvents()
end

end
