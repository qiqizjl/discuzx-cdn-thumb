local _M = {}
local mt = {__index = _M}
local config = require("config.cache")
local json = require("cjson")

function _M.getClient(self)
    ngx.log(ngx.INFO,self.config.cache_store)
    if self.config.cache_store == nil then
        error("name未定义")
    end
    local result = ngx.shared[self.config.cache_store]
    if result == nil then
        error("name不存在")
    end
    ngx.log(ngx.INFO, self.config.cache_store)
    return result
end

function _M.get(self, key)
    local client = self:getClient()
    local res = client:get(key)
    ngx.log(ngx.INFO, res)
    if res ~= nil then 
        local result = json.decode(res)
    end
    return result
end

function _M:set(key, data)
    ngx.log(ngx.INFO, key)
    local store_data = json.encode(data)
    ngx.log(ngx.INFO, store_data)
    local client = self:getClient()
    client:set(key, store_data, self.config.cache_time)
    return true
    -- body
end

function _M.new(self, conf)
    config = conf or config
    return setmetatable({config = config}, mt)
end

return _M
