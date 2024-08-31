@inline function glTexRGBA(width, height, ptr)
    glTexImage2D(
        GL_TEXTURE_2D,
        0,
        GL_RGBA,
        width,
        height,
        0,
        GL_RGBA,
        GL_UNSIGNED_BYTE,
        ptr,
    )
end

struct Texture
    id::GLuint

    function Texture()
        tex_ptr = GLuint[0]
        glGenTextures(1, tex_ptr)
        new(tex_ptr[])
    end

    function Texture(width, height)
        tex = Texture()

        glBindTexture(GL_TEXTURE_2D, tex.id)
        glTexRGBA(width, height, C_NULL)
        glBindTexture(GL_TEXTURE_2D, 0)

        tex
    end

    function Texture(image)
        width, height = size(image)

        tex = Texture()

        glBindTexture(GL_TEXTURE_2D, tex.id)
        glTexRGBA(width, height, image)
        glBindTexture(GL_TEXTURE_2D, 0)

        tex
    end
end

function setwrap!(tex, s, t)
    glBindTexture(GL_TEXTURE_2D, tex.id)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, s)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, t)
    glBindTexture(GL_TEXTURE_2D, 0)
end

function setfilter!(tex, min, max)
    glBindTexture(GL_TEXTURE_2D, tex.id)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, min)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, max)
    glBindTexture(GL_TEXTURE_2D, 0)
end

function setbordercolor!(tex, r, g, b, a)
    temp = GLfloat[r, g, b, a]
    glBindTexture(GL_TEXTURE_2D, tex.id)
    glTexParamterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, temp)
    glBindTexture(GL_TEXTURE_2D, 0)
end
