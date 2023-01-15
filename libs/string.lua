local strings = {}

  --// Ansi Colors Building
    --// Main components
    Ansi     = "\27" 
    AnsiEnd  = " "..Ansi.."[0m"
    -- Backgrounds
    Magen  = "[45;"
    White  = "[47;"
    Red    = "[41;"
    --// Font Colors
    BlackT = "30m "
    --// Macro Builds
    Head      = "\n"..Ansi..Magen..BlackT.."LuvJS"..AnsiEnd
    Body      = Ansi..White..BlackT
    ErrBlock  = Ansi..Red..BlackT
  -- error builder
  Errors = {
    ['missingarg'] = function(f, e)
      return error(Head..Body.."Missing (required) argument(s) at method "..f..AnsiEnd..ErrBlock..e..AnsiEnd.."\n")
    end,
    ['invalarg'] = function(f, e, t0, t1)
      if not t1 or t1 == nil or t1 == "" or (string.gsub(t1, " ", "")) == "" then t1 = "null" end
      return error(Head..Body.."Expected "..t0..", got "..t1.." at method "..f..AnsiEnd..ErrBlock..e..AnsiEnd.."\n")
    end,
    ['unfinarg'] = function(f, e)
      return error(Head..Body.."Unfinished String at method "..f..AnsiEnd..ErrBlock..e..AnsiEnd.."\n")
    end,
    ['outofrange'] = function(f, e, m)
      return error(Head..Body.."Out of range, max: "..m[1].."; got: "..m[2]..f..AnsiEnd..ErrBlock..e..AnsiEnd.."\n")
    end,
    ['inverserange'] = function(f, e)
      return error(Head..Body.."Invalid range rule. Can not inverse a negative range. "..f..AnsiEnd..ErrBlock..e..AnsiEnd.."\n")
    end,
    ['rangearg'] = function(f, t0)
      return error(Head..Body.."Expected "..t0['expect']..", got "..t0['type'].." at "..f..AnsiEnd..ErrBlock..t0['err']..AnsiEnd.."\n")
    end,
  }

  function strings:split(str, delim)
    local ret = {}
    local errName = "string:split(<#1>, <#2>)"

    if not str or not delim then
      local missing = {}
      if not str then table.insert(missing, "|:split::arg #1|") end
      if not delim then table.insert(missing, "|:split::arg #2]|") end

      return Errors.missingarg(errName, table.concat(missing, " && "))

    else
      local ret1 = {}
      if type(str) ~= "string" then
        table.insert(ret1, {
          ['type'] = "arg #1"..type(str),
          ['err'] = "|:split::arg #1|",
        })

      elseif type(delim) ~= "string" then
        table.insert(ret1, {
          ['type'] = "arg #2:"..type(delim),
          ['err'] = "|:split::arg #2|",
        })
      end

      local ret2 = ''
      for i, v in pairs (ret1) do
        if i>1 then
          v['err'] = " && "..v['err']
        end

        ret2 = ret2..v['err']
      end

      local ret3 = ''
      for i, v in pairs (ret1) do
        if i>1 then
          v['type'] = " && "..v['type']
        end

        ret3 = ret3..v['type']
      end

      if ret2 ~= '' and ret3 ~= '' then
        Errors.invalarg(errName, ret2, "string", ret3)
      end
    end

    if not delim or delim == '' then
      for c in string.gmatch(str, '.') do
        table.insert(ret, c)
      end

      return ret
    end

    local n = 1
    while true do
      local i, j = string.find(str, delim, n)

      if not i then break end

      table.insert(ret, string.sub(str, n, i - 1))
      n = j + 1
    end

    table.insert(ret, string.sub(str, n))

    return ret{}
  end

  function strings:startsWith(str, delim)
    local ret

    local errName = "string:startsWith(<#1>, <#2>)"

    if not str or not delim then
      local missing = {}
      if not str then table.insert(missing, "|:startsWith::arg #1|") end
      if not delim then table.insert(missing, "|:startsWith::arg #2]|") end

      return Errors.missingarg(errName, table.concat(missing, " && "))

    else
      local ret1 = {}
      local ret2 = {}
      if type(str) ~= 'string' then
        table.insert(ret1, {
          ['type'] = "arg #1:"..type(str),
          ['err'] = "|:startsWith::arg #1|",
        })

      else
        local t0 = string.gsub(str, ' ', '')
        if t0 == nil or t0 == '' then
          table.insert(ret2, "|:startsWith::arg #1|")
        end
      end

      if type(delim) ~= 'string' then
        table.insert(ret1, {
          ['type'] = "arg #2:"..type(str),
          ['err'] = "|:startsWith::arg #2|",
        })

      else
        local t0 = string.gsub(delim, ' ', '')
        if t0 == nil or t0 == '' then
          table.insert(ret2, "|:startsWith::arg #2|")
        end
      end

      if ret1[1] then
        local ret3 = ''
        for i, v in pairs (ret1) do
          if i>1 then
            v['err'] = " && "..v['err']
          end
    
          ret3 = ret3..v['err']
        end
    
        local ret4 = ''
        for i, v in pairs (ret1) do
          if i>1 then
            v['type'] = " && "..v['type']
          end
    
          ret4 = ret4..v['type']
        end
    
        return Errors.invalarg(errName, ret3, "string", ret4)

      elseif ret2[1] then
        local ret3 = ''
        for i, v in pairs(ret2) do
          if i>1 then
            v = " && "..v
          end
    
          ret3 = ret3..v
        end
    
        return Errors.missingarg(errName, ret3)
      end
    end

    local t0 = strings:split(str, '')
    local t1 = strings:split(delim, '')

    local index = 1
    local matches = ''

    for i, v in pairs(t0) do
      if v == t1[index] then
        matches = matches .. v
        index = index + 1
      end
    end

    if matches == delim then
      ret = true

    else
      ret = false
    end

    return ret
  end

  function strings:endsWith(str, delim)
    local ret

    local errName = "string:endsWith(<#1>, <#2>)"

    if not str or not delim then
      local missing = {}
      if not str then table.insert(missing, "|:endsWith::arg #1|") end
      if not delim then table.insert(missing, "|:endsWith::arg #2]|") end

      return Errors.missingarg(errName, table.concat(missing, " && "))

    else
      local ret1 = {}
      local ret2 = {}
      if type(str) ~= 'string' then
        table.insert(ret1, {
          ['type'] = "arg #1:"..type(str),
          ['err'] = "|:endsWith::arg #1|",
        })

      else
        local t0 = string.gsub(str, ' ', '')
        if t0 == nil or t0 == '' then
          table.insert(ret2, "|:endsWith::arg #1|")
        end
      end

      if type(delim) ~= 'string' then
        table.insert(ret1, {
          ['type'] = "arg #2:"..type(str),
          ['err'] = "|:endsWith::arg #2|",
        })

      else
        local t0 = string.gsub(delim, ' ', '')
        if t0 == nil or t0 == '' then
          table.insert(ret2, "|:endsWith::arg #2|")
        end
      end

      if ret1[1] then
        local ret3 = ''
        for i, v in pairs (ret1) do
          if i>1 then
            v['err'] = " && "..v['err']
          end
    
          ret3 = ret3..v['err']
        end
    
        local ret4 = ''
        for i, v in pairs (ret1) do
          if i>1 then
            v['type'] = " && "..v['type']
          end
    
          ret4 = ret4..v['type']
        end
    
        return Errors.invalarg(errName, ret3, "string", ret4)

      elseif ret2[1] then
        local ret3 = ''
        for i, v in pairs(ret2) do
          if i>1 then
            v = " && "..v
          end
    
          ret3 = ret3..v
        end
    
        return Errors.missingarg(errName, ret3)
      end
    end

    local t0 = strings:split(str, '')
    local t1 = strings:split(delim, '')

    local index = #t1
    local matches = ''

    for i = #t0, 1, -1 do
      if t0[i] == t1[index] then
        matches = t0[i] .. matches
        index = index - 1
      end
    end

    if matches == delim then
      ret = true

    else
      ret = false
    end

    return ret
  end

  function strings:slice(str, pattern1, pattern2)
    local ret = ''
    local errName = "string:slice(<#1>, <#2>, <#3>)"

    if not str then
      local missing = {}
      if not str then table.insert(missing, "|:slice::arg #1|") end
      if not pattern1 then  table.insert(missing, "|:slice::arg #2]|") end

      return Errors.missingarg(errName, table.concat(missing, " && "))
    else
      if type(str) ~= 'string' then
        Errors.rangearg(errName, {
            ['type'] = "arg #1:"..type(str),
            ['err'] = "|:endsWith::arg #1|",
            ['expect'] = 'string'
          })
      end

      if pattern1 and type(tonumber(pattern1)) ~= 'number' then
        return Errors.rangearg(errName, {
          ['type'] = "arg #2:"..type(pattern1),
          ['err'] = "|:endsWith::arg #2|",
          ['expect'] = 'integer'
        })
      end

      if pattern2 and type(tonumber(pattern2)) ~= 'number' then
        return Errors.rangearg(errName, {
          ['type'] = "arg #3:"..type(pattern2),
          ['err'] = "|:endsWith::arg #3|",
          ['expect'] = 'integer'
        })
      end
    end

    local ranges = { }

    pattern1 = pattern1 + 1
    pattern2 = pattern2 + 1
    if pattern2 and pattern2 == 0 then pattern2 = 1 end
    if not pattern2 then
      if pattern1 < 0 and tonumber(string.gsub(tostring(pattern1), '-', '')) <= #strings:split(str, '') then
        local t0 = strings:split(str, '')
        local i = 0
  
        while i < pattern1 do
          table.remove(t0, #t0)
          i = i + 1
        end
  
        return table.concat(t0)
      elseif pattern1 < 0 and tonumber(string.gsub(tostring(pattern1), '-', '')) > #strings:split(str, '') then
        return Errors.outofrange(errName, "|:slice::args #2|", {#strings:split(str, ''), pattern1})
      end

      if pattern1 > #strings:split(str, '') then return str end
      local t0 = strings:split(str, '')
      local i = 0

      while i < pattern1 do
        table.remove(t0, 1)
        i = i + 1
      end

      return table.concat(t0)
    else
      if tonumber(pattern1) < 0 and tonumber(pattern1) <= #strings:split(str, '') then
        if tonumber(pattern2) < 0 and tonumber(pattern1) <= #strings:split(str, '') then
          if tonumber(pattern1) > tonumber(pattern2) then
            return Errors.inverserange(errName, '|:slice::args #2| && |:slice::args #3|')
          else
            local t0 = strings:split(str, '')
            local i = 0

            while i < tonumber(pattern2) do
              table.remove(t0, #t0-tonumber(pattern2))
              i = i + 1
            end

            return table.concat(t0)
          end
        elseif tonumber(pattern2) < 0 and tonumber(pattern2) > #strings:split(str, '') then
          return Errors.outofrange(errName, "|:slice::args #3|", {#strings:split(str, ''), pattern2})
        end
      elseif tonumber(pattern1) < 0 and tonumber(pattern1) > #strings:split(str, '') then
        return Errors.outofrange(errName, "|:slice::args #3|", {#strings:split(str, ''), pattern1})
      else
        if tonumber(pattern2) < 0 and tonumber(pattern1) <= #strings:split(str, '') then
          if tonumber(pattern1) > tonumber(pattern2) then
            return Errors.inverserange(errName, '|:slice::args #2| && |:slice::args #3|')
          else
            local t0 = strings:split(str, '')
            local i = 0

            while i < tonumber(pattern2) do
              table.remove(t0, i+tonumber(pattern2))
              i = i + 1
            end

            return table.concat(t0)
          end
        elseif tonumber(pattern2) < 0 and tonumber(pattern2) > #strings:split(str, '') then
          return Errors.outofrange(errName, "|:slice::args #3|", {#strings:split(str, ''), pattern2})
        else
          local t0 = strings:split(str, '')
          local i = 0

          while i < tonumber(pattern2) do
            print(i+tonumber(pattern1) .. " " .. table.concat(t0) .. " " .. #t0)
            table.remove(t0, pattern1)
            i = i + 1
          end

          return table.concat(t0).."421"
        end
      end
    end

    return ret
  end

return strings