using GLFW
using ModernGL

function initgraphics()
    # Create a window and its OpenGL context
    window = GLFW.CreateWindow(640, 480, "GLFW.jl")

    # Make the window's context current
    GLFW.MakeContextCurrent(window)

    # Loop until the user closes the window
    while !GLFW.WindowShouldClose(window)

      # Swap front and back buffers
      GLFW.SwapBuffers(window)
      GLFW.PollEvents()
    end

    GLFW.DestroyWindow(window)
end
