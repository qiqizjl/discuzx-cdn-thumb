local DB = require("libs.mysql")
local db = DB:new()
local CACHE = require("libs.cache")
local cache = CACHE:new()
local _M = {}
local json = require("cjson")
local config = require("config.thumb")

-- 读附件
function _M:get_attachment(aid)
    ngx.log(ngx.INFO, aid)
    local cache_key = "attach_" .. aid
    local result = cache:get(cache_key)
    if result == nil then
        -- 表前缀
        local all_table = string.format("%sforum_attachment", config.db.table_prefix)
        local res, err = db:select("SELECT `tableid` from " .. all_table .. " where `aid` = ? ", {aid})
        ngx.log(ngx.INFO, json.encode(res))
        if res and not err and type(res) == "table" and #res >= 1 then
            res = res[1]
            local table = "forum_attachment_" .. res["tableid"]
            if res["tableid"] == "127" then
                local table = "forum_attachment_unused"
            end
            -- 表前缀
            table = string.format("%s%s", config.db.table_prefix, table)
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
    ngx.log(ngx.INFO, json.encode(attach))
    local config = require("config.thumb").site
    local attach_config = {}
    if attach["remote"] == 1 then
        attach_config = config.remote_attachment
    else
        attach_config = config.local_attachment
    end
    if attach_config.type == nil or attach_config.type == "" then
        return nil
    end
    ngx.log(ngx.INFO,attach_config.type)
    local url = attach_config.url .. attach["attachment"]
    local thumb_module = require("service.thumb." .. attach_config.type)
    url = thumb_module:thumb(url,w)
    return url
end
return _M
