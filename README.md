# htpasswd-auth-server

This is a small server for use with nginx's [auth_request module](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html).

This is really just an overkill way of launching nginx with an htpasswd
file. It's mostly used as a development stand-in for [ldap-auth-server](https://github.com/jprjr/ldap-auth-server).
It requires nginx with the Lua module, Lua, and the following lua modules:

* luaposix
* etlua
* luafilesystem

## install + use

Just git clone this repository somewhere.

From there, you can install the needed lua modules however you regularly do.

If you install them into a folder named `lua_modules`, then the script
`bin/htpasswd-auth-server` will use (and *only* use) modules found under that
folder. For example, after cloning you could run:

```
luarocks install --tree lua_modules luaposix
luarocks install --tree lua_modules etlua
luarocks install --tree lua_modules luafilesystem
```

Make a copy of `etc/config.lua.example` to `etc/config.lua` and edit
as-needed, then run `bin/htpasswd-auth-server`.

By default, all temp files, compiled config files, etc are placed at
`$HOME/.htpasswd-auth-server` - this can be changed by setting the `work_dir`
variable in `etc/config.lua`

Additionally, you'll need to create an htpasswd file at `etc/htpasswd`.

I'm working on adding htpasswd-making functionality to `bin/htpasswd-auth-server`
