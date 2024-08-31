struct Buffer
    id::GLuint

    function Buffer()
        buf_ptr = GLuint[0]
        glGenBuffers(1, buf_ptr)
        new(buf_ptr[])
    end
end

function subdata!(buffer)
    glBindBuffer()
end
