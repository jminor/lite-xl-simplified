-- this file is used by lite-xl to setup the Lua environment when starting
MOD_VERSION = "3"

SCALE = tonumber(os.getenv("LITE_SCALE") or os.getenv("GDK_SCALE") or os.getenv("QT_SCALE_FACTOR")) or SCALE
PATHSEP = package.config:sub(1, 1)

EXEDIR = EXEFILE:match("^(.+)[/\\][^/\\]+$")
if MACOS_RESOURCES then
  DATADIR = MACOS_RESOURCES
else
  local prefix = EXEDIR:match("^(.+)[/\\]bin$")
  DATADIR = prefix and (prefix .. '/share/lite-xl') or (EXEDIR .. '/data')
end
USERDIR = (system.get_file_info(EXEDIR .. '/user') and (EXEDIR .. '/user'))
       or ((os.getenv("XDG_CONFIG_HOME") and os.getenv("XDG_CONFIG_HOME") .. "/lite-xl"))
       or (HOME and (HOME .. '/.config/lite-xl'))

package.path = DATADIR .. '/?.lua;'
package.path = DATADIR .. '/?/init.lua;' .. package.path
package.path = USERDIR .. '/?.lua;' .. package.path
package.path = USERDIR .. '/?/init.lua;' .. package.path

local dynamic_suffix = PLATFORM == "Mac OS X" and 'lib' or (PLATFORM == "Windows" and 'dll' or 'so')
package.cpath = DATADIR .. '/?.' .. dynamic_suffix .. ";" .. USERDIR .. '/?.' .. dynamic_suffix
package.native_plugins = {}
local searchers = package.searchers and "searchers" or "loaders"
package[searchers] = { package[searchers][1], package[searchers][2], function(modname)
  local s, e = 1
  while e < #package.cpath do
    e = package.cpath:find(";", s) or #package.cpath
    local path = package.cpath:sub(s, e):gsub("?", modname)
    if system.get_file_info(path) then
      return system.load_native_plugin, path
    end
  end
  return nil
end }

table.pack = table.pack or pack or function(...) return {...} end
table.unpack = table.unpack or unpack

-- Because AppImages change the working directory before running the executable,
-- we need to change it back to the original one.
-- https://github.com/AppImage/AppImageKit/issues/172
-- https://github.com/AppImage/AppImageKit/pull/191
local appimage_owd = os.getenv("OWD")
if os.getenv("APPIMAGE") and appimage_owd then
  system.chdir(appimage_owd)
end

-- compatibility with lite-xl
string.ufind = string.find
