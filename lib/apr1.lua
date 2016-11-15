local md5 = require'md5'
local math = require'math'
local base64 = require'base64'

local b64_alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
local apr_alpha = "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

local tr = {}
for i=1,string.len(b64_alpha),1 do
    tr[string.sub(b64_alpha,i,i)] = string.sub(apr_alpha,i,i)
end
tr['='] = ''

local M = {}

function M.encode(password)
  local salt = ""
  local m = md5.new()
  local max = string.len(password)
  math.randomseed( os.time() )
  while string.len(salt) < 8 do
      local r = math.random(1,64)
      salt = salt .. string.sub(apr_alpha,r,r)
  end

  m:update(password)
  m:update("$apr1$")
  m:update(salt)

  local binary = md5.sum(password .. salt .. password)

  for i=max,1,-16 do
      local j = i;
      if i > 16 then
          j = 16
      end
      m:update(string.sub(binary,1, j))
  end

  local i = max
  while i > 0 do
      if(i % 2 == 0) then
          m:update(string.sub(password,1,1))
      else
          m:update(string.char(0))
      end
      i = math.floor(i / 2)
  end

  binary = m:finish()

  for i=0,999,1 do
      local t
      if(i % 2 == 0) then
          t = binary
      else
          t = password
      end

      if(i % 3 > 0) then
          t = t .. salt
      end

      if(i % 7 > 0) then
          t = t .. password
      end

      if(i % 2 == 0) then
          t = t .. password
      else
          t = t .. binary
      end

      binary = md5.sum(t)
  end

  local hash = ''

  for i=1,5,1 do
      local k = i + 6
      local j = i + 12
      if(j == 17) then
          j = 6
      end
      hash = string.sub(binary,i,i) ..
             string.sub(binary,k,k) ..
             string.sub(binary,j,j) ..
             hash
  end

  hash = string.char(0) .. string.char(0) ..
         string.sub(binary,12,12) .. hash

  local b = string.sub(base64.encode(hash),3)
  local h = ''

  for i=string.len(b),1,-1 do
      h = h .. tr[string.sub(b,i,i)]
  end

  return '$apr1$'.. salt .. '$' .. h

end

return M
