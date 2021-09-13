local AUTOJUMP_DIR = debug.getinfo(1, "S").source:match[[^@?(.*[\/])[^\/]-$]] .. "..\\AutoJump"
local AUTOJUMP_BIN_DIR = AUTOJUMP_DIR .. "\\bin"
local AUTOJUMP_BIN = (AUTOJUMP_BIN_DIR or clink.get_env("LOCALAPPDATA") .. "\\autojump\\bin") .. "\\autojump"

function autojump_add_to_database()
  os.execute("python " .. "\"" .. AUTOJUMP_BIN .. "\"" .. " --add " .. "\"" .. clink.get_cwd() .. "\"" .. " 2> " .. clink.get_env("TEMP") .. "\\autojump_error.txt")
end

clink.prompt.register_filter(autojump_add_to_database, 99)

function autojump_completion(word)
  for line in io.popen("python " .. "\"" .. AUTOJUMP_BIN .. "\"" ..  " --complete " .. word):lines() do
    clink.add_match(line)
  end
  return {}
end

local autojump_parser = clink.arg.new_parser()
autojump_parser:set_arguments({ autojump_completion })

clink.arg.register_parser("j", autojump_parser)
