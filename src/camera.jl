# some formulas taken from:
# http://www.songho.ca/opengl/gl_projectionmatrix.html

module Camera

"""
    persp(top, bottom, right, left, near, far)
generate a perspective matrix  
see also [`sympersp`](@ref), [`infsympersp`](@ref)
"""
function persp(t, b, r, l, n, f)
    [ 2n/(r-l)        0  (r+l)/(r-l)             0
             0 2n/(t-b)  (t+b)/(t-b)             0
             0        0 -(f+n)/(f-n) (-2f*n)/(f-n)
             0        0           -1             0
    ]
end

"""
    sympersp(top, right, near, far)
generate a symmetrical perspective matrix  
see also [`persp`](@ref), [`infsympersp`](@ref)
"""
function sympersp(t, r, n, f)
    [ n/r   0            0             0
        0 n/t            0             0
        0   0 -(f+n)/(f-n) (-2f*n)/(f-n)
        0   0           -1             0
    ]
end

"""
    infsympersp(top, right, near)
generate a infinite symmetrical perspective matrix  
see also [`persp`](@ref), [`sympersp`](@ref)
"""
function infsympersp(t, r, n)
    [ n/r   0  0   0
        0 n/t  0   0
        0   0 -1 -2n
        0   0 -1   0
    ]
end

"""
    fovx(fov_in_degrees, aspect_ratio, near, far)
generate a perspective matrix from horizontal field of view  
see also [`fovy`](@ref)
"""
function fovx(x, aspect, n, f)
    tangent = tan(deg2rad(x/2))
    r = n * tangent
    t = r / aspect
    sympersp(t, r, n, f)
end

"""
    fovy(fov_in_degrees, aspect_ratio, near, far)
generate a perspective matrix from vertical field of view  
see also [`fovx`](@ref)
"""
function fovy(y, aspect, n, f)
    tangent = tan(deg2rad(y/2))
    t = n * aspect
    r = t * tangent
    sympersp(r, t, n, f)
end

"""
    ortho(top, bottom, right, left, near, far)
generate an orthographic matrix  
see also [`symortho`](@ref)
"""
function ortho(t, b, r, l, n, f)
    [ 2/(r-l)       0        0 -(r+l)/(r-l)
            0 2/(t-b)        0 -(t+b)/(t-b)
            0       0 -2/(f-n) -(f+n)/(f-n)
            0       0        0            1
    ]
end

"""
    symortho(top, right, near, far)
generate a symmetrical orthographic matrix  
see also [`ortho`](@ref)
"""
function symortho(t, r, n, f)
    [ 1/r   0        0            0
        0 1/t        0            0
        0   0 -2/(f-n) -(f+n)/(f-n)
        0   0        0            1
    ]
end

end
