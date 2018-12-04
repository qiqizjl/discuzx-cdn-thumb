Name
====

DiscuzX-CDN-Thumb - 将DiscuzX缩略图由CDN接管

项目描述
===========

使用Lua,将DiscuzX处理缩略图部分由CDN接管。且对业务无改动。本包也修复magapp引擎包中CDN处理缩略图的BUG(直接跳转原图)

项目背景
===========
由于DiscuzX缩略图逻辑比较老旧。页面中铺入一个php地址,在这个地址对应的业务中去查询库获得地址并处理缩略图存到本地服务器并301跳转。首先耗费两次DB不说，且没有缓存，而且PHP处理缩略图会存在性能/存储上(服务器中会存储该缩略图)的问题。

此项目将在Nginx/openresty层拦截该请求，将请求301至CDN，由CDN去处理缩略图

项目效果
===========
将缩略图请求从0.0x级别降低到0.00x。因修复magapp的bug,CDN流量/带宽降低50%

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

3.1 site配置

* local_attachment 本地附件
    * url 附件请求地址
    * type CDN类型 目前支持qiniu/aliyun 可在service/thumb中自由扩展
* remote_attachment 远程附件
    * url 附件请求地址
    * type CDN类型 目前支持qiniu/aliyun 可在service/thumb中自由扩展

3.2 cache配置

* cache_store 缓存存储模块 要和4.1配置一致
* cache_time  缓存时间 单位秒


3.3 db配置

* connect_config DZX数据库链接信息
    * host 数据库地址
    * port 数据库端口
    * database 数据库名称
    * user 链接DB用户名
    * password 数据库密码
    * max_packet_size MySQL返回最大数据包 默认即可

* pool_config 数据库连接池
    * max_idle_timeout 链接最长释放时间
    * pool_size 连接池长度

* table_prefix DZX表前缀

* timeout 数据库超时时间

4.修改nginx配置文件

4.1. http block
~~~ nginx
# attachment_thumb需要修改成cofnig/thumb.lua中的cache.cache_store
lua_shared_dict attachment_thumb 128m;
~~~

4.2. server block
~~~ nginx
#项目目录需要时完整目录，末尾必须带上/
set $PROJECT_PATH "项目部署目录";
~~~

4.3. php block
~~~ nginx
access_by_lua_file 项目部署目录/access.lua;
~~~

