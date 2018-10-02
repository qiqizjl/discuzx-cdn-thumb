local _M = {}

function _M:thumb(image_url, width)
    return image_url .. "?imageView2/3/w/" .. width
end

return _M