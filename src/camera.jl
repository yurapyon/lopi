# some formulas taken from:
# http://www.songho.ca/opengl/gl_projectionmatrix.html

module Camera

function persp(t, b, r, l, n, f)
    [ 2n/(r-l)        0  (r+l)/(r-l)             0
             0 2n/(t-b)  (t+b)/(t-b)             0
             0        0 -(f+n)/(f-n) (-2f*n)/(f-n)
             0        0           -1             0
    ]
end

function sympersp(r, t, n, f)
    [ n/r   0            0             0
        0 n/t            0             0
        0   0 -(f+n)/(f-n) (-2f*n)/(f-n)
        0   0           -1             0
    ]
end

function syminfpersp(r, t, n)
    [ n/r   0  0   0
        0 n/t  0   0
        0   0 -1 -2n
        0   0 -1   0
    ]
end

function fovx(x, aspect, n, f)
    tangent = tan(deg2rad(x/2))
    r = n * tangent
    t = r / apsect
    sympersp(r, t, n, f)
end

function fovy(y, aspect, n, f)
    tangent = tan(deg2rad(y/2))
    t = n * apsect
    r = t * tangent
    sympersp(r, t, n, f)
end

function ortho(t, b, r, l, n, f)
    [ 2/(r-l)       0        0 -(r+l)/(r-l)
            0 2/(t-b)        0 -(t+b)/(t-b)
            0       0 -2/(f-n) -(f+n)/(f-n)
            0       0        0            1
    ]
end

function symortho(r, t, n, f)
    [ 1/r   0        0            0
        0 1/t        0            0
        0   0 -2/(f-n) -(f+n)/(f-n)
        0   0        0            1
    ]
end

end
