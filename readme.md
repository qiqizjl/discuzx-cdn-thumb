Name
====

DiscuzX-CDN-Thumb - 将DiscuzX缩略图由CDN接管

项目描述
===========

使用Lua,将DiscuzX处理缩略图部分由CDN接管。且对业务无改动

项目背景
===========
由于DiscuzX缩略图逻辑比较老旧。页面中铺入一个php地址,在这个地址对应的业务中去查询库获得地址并处理缩略图存到本地服务器并301跳转。首先耗费两次DB不说，且没有缓存，而且PHP处理缩略图会存在性能/存储上(服务器中会存储该缩略图)的问题。

此项目将在Nginx/openresty层拦截该请求，将请求301至CDN，由CDN去处理缩略图

项目运行环境
===========
nginx+ngx_lua+cjson/openresty

项目状态
===========
已在线上稳定运行

项目部署
===========
1.将项目Clone到本地

2.将**config**目录**thumb.lua.demo**重名成**thumb.lua**

3.修改**config/thumb.lua**中的配置文件(DB信息/附件URL/缩略图信息)

4.修改nginx配置文件

4.1. http block
~~~ nginx
# attachment_thumb需要修改成cofnig/thumb.lua中的cache.cache_store
lua_shared_dict attachment_thumb 128m;
~~~

4.2. server block
~~~ nginx
set $PROJECT_PATH "项目部署目录";
~~~

4.3. php block
~~~ nginx
access_by_lua_file 项目部署目录/access.lua;
~~~

