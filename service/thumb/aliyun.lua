local _M = {}

function _M:thumb(image_url, width)
    local url =  image_url ..  "?x-oss-process=image/resize,m_mfit,w_" .. width
    local match,err = ngx.re.match(ngx.req.get_headers()["accept"],"webp")
    if match  then
        url  = url .. "/format,webp"
    end
    return url
end

return _M