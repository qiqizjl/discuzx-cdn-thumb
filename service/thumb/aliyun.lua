local _M = {}

function _M:thumb(image_url, width)
    local url =  image_url ..  "?x-oss-process=image/resize,m_mfit,w_" .. width
    local accept = ngx.req.get_headers()["accept"]
    if accept == nil then
        accept = ""
    end
    local match,err = ngx.re.match(accept,"webp")
    if match  then
        url  = url .. "/format,webp"
    end
    return url
end

return _M