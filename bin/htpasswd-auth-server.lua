#!/usr/bin/env luajit

local posix = require'posix'
local lfs = require'lfs'
local exit = os.exit
local getenv = os.getenv
local etlua = require'etlua'

local install_dir = posix.dirname(posix.dirname(posix.realpath(arg[0])))

posix.chdir(install_dir)

local commands = {
  ["run"] = 1,
}

print(arg[1])

if(not arg[1] or not commands[arg[1]]) then
  print("syntax: " .. arg[0] .. " <action>")
  print("Available actions")
  print("  run    -- run nginx")
  exit(1)
end

local ok, config = pcall(require,'etc.config')

if not ok then
    print("Error: could not load " .. install_dir .. "/etc/config.lua")
    exit(1)
end

if not config.nginx then
    print("Error: please provide path to nginx in config")
    exit(1)
end

if not config.log_level then
    config.log_level = "error";
end

if not config.work_dir then
    config.work_dir = getenv("HOME") .. "/.htpasswd-auth-server"
end

if not config.listen then
    config.listen = "127.0.0.1:8080"
end

if not config.worker_processes then
    config.worker_processes = 1
end

config.install_dir = install_dir

if (arg[1] == "run") then
  if not lfs.attributes(config.work_dir) then
      lfs.mkdir(config.work_dir)
  end

  if not lfs.attributes(config.work_dir .. "/logs") then
      lfs.mkdir(config.work_dir .. "/logs")
  end

  local nf = io.open(install_dir .. "/res/nginx.conf","rb")
  local nginx_config_template = nf:read("*all")
  nf:close()

  local template = etlua.compile(nginx_config_template)

  local nof = io.open(config.work_dir .. "/nginx.conf", "wb")
  nof:write(template(config))
  nof:close()

  posix.chdir(config.work_dir)
  posix.exec(config.nginx, { "-p", config.work_dir, "-c", "nginx.conf" })
end

