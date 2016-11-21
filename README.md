# htpasswd-auth-server

This is a small server for use with nginx's [auth_request module](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html).

This is really just an overkill way of launching nginx with an htpasswd
file. It's mostly used as a development stand-in for [ldap-auth-server](https://github.com/jprjr/ldap-auth-server).
It requires any version of nginx, Lua, and the following lua modules:

* luaposix
* etlua
* luafilesystem
* lbase64

## install + use

Just git clone this repository somewhere.

From there, you can install the needed lua modules however you regularly do.

If you install them into a folder named `lua_modules`, then the script
`bin/htpasswd-auth-server` will use (and *only* use) modules found under that
folder. For example, after cloning you could run:

```bash
luarocks install --tree lua_modules install luaposix
luarocks install --tree lua_modules install etlua
luarocks install --tree lua_modules install luafilesystem
luarocks install --tree lua_modules install lbase64
```

Make a copy of `etc/config.lua.example` to `etc/config.lua` and edit
as-needed, then run `bin/htpasswd-auth-server run` to launch the server.

By default, all temp files, compiled config files, etc are placed at
`$HOME/.htpasswd-auth-server` - this can be changed by setting the `work_dir`
variable in `etc/config.lua`

You can also use `bin/htpasswd-auth-server` to edit/update the htpasswd file.
Just run `bin/htpasswd-auth-server add` and you'll be prompted to enter a
username and password.


## License

Released under an MIT-style license. See the file `LICENSE` for details.

This contains a copy of md5.lua from https://github.com/kikito/md5.lua (as
`lib/md5.lua`) - this is also MIT-licensed. A copy of the license can
be found in `lib/md5.lua`
