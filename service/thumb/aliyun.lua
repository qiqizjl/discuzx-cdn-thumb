local _M = {}

function _M:thumb(image_url, width)
    return image_url ..  "?x-oss-process=image/resize,m_mfit,w_" .. width
end

return _M