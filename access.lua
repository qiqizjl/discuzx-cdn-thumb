-- 不让赋值多次
if  not string.match(package.path,ngx.var.PROJECT_PATH) then
    package.path = package.path .. ";"..ngx.var.PROJECT_PATH.."?.lua"
end


local isThumb = false

if ngx.var.arg_mag_mod == "forum" and ngx.var.arg_mag_fuc == "imageThumb" then
    isThumb = true
end

if ngx.var.uri == "/forum.php" and ngx.var.arg_mod == "image" then
    isThumb = true
end
-- 查询是否有地址
if isThumb == true and ngx.var.arg_aid ~= nil then
    local attach = require("service.attach")
    local json = require("cjson") 
    local utils = require("utils.utils")
    local att = attach:get_attachment(ngx.var.arg_aid)
    -- ngx.log(ngx.INFO,json.encode(att))
    if att ~= nil then
        -- 解析URL get_thumb_url
        local size = utils.split_str(ngx.var.arg_size, "x")
        w = size[1]
        if tonumber(w) >= 1000 then
            w = 1000
        end
        local url = attach:get_thumb_url(att, w)
        if url ~= nil then
            ngx.redirect(url, ngx.HTTP_MOVED_PERMANENTLY)
            return ngx.exit(ngx.HTTP_MOVED_PERMANENTLY)
        end
    end
end
