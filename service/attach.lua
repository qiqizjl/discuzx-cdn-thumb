local DB = require("libs.mysql")
local db = DB:new()
local CACHE = require("libs.cache")
local cache = CACHE:new()
local _M = {}
local json = require("cjson")

-- 读附件
function _M:get_attachment(aid)
    ngx.log(ngx.INFO, aid)
    local cache_key = "attach_" .. aid
    local result = cache:get(cache_key)
    if result == nil then
        local res, err = db:select("SELECT `tableid` from pre_forum_attachment where `aid` = ? ", {aid})
        ngx.log(ngx.INFO, json.encode(res))
        if res and not err and type(res) == "table" and #res >= 1 then
            res = res[1]
            local table = "pre_forum_attachment_" .. res["tableid"]
            if res["tableid"] == "127" then
                local table = "pre_forum_attachment_unused"
            end
            ngx.log(ngx.INFO, table)
            res, err = db:select("SELECT * from `" .. table .. "` where `aid` = ? ", {aid})
            ngx.log(ngx.INFO, json.encode(res))
        end
        ngx.log(ngx.INFO, json.encode(res))
        if res and type(res) == "table" and #res >= 1 then
            ngx.log(ngx.INFO, json.encode(res))
            result = res[1]
            cache:set(cache_key, result)
        end
    end
    return result
end

-- 获得缩略图地址
function _M:get_thumb_url(attach, w)
    ngx.log(ngx.INFO,json.encode(attach))
    local config = require("config.site")
    local attach_config = {}
    if attach["remote"] == 1 then
        attach_config = config.remote_attachment
    else
        attach_config = config.local_attachment
    end
    if attach_config.type == nil or attach_config.type == "" then
        return nil
    end
    local url = attach_config.url .. attach["attachment"]
    if attach_config.type == "aliyun" then
        url = url .. "?x-oss-process=image/resize,m_mfit,w_" .. w
    elseif attach_config.type == "qiniu" then
        url = url .. "?imageView2/3/w/" .. w
    end
    return url
end
return _M
