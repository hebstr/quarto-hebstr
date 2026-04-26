local function ensureHtmlDeps()
  quarto.doc.add_html_dependency({
    name = "add-code-files",
    version = "1.0.0",
    scripts = {
      { path = "add-code-files.js", afterBody = true }
    }
  })
end

local function dedent(line, n)
  return line:sub(1, n):gsub(" ", "") .. line:sub(n + 1)
end

local function source_include(filepath, startLine, endLine, dedentLine, lang,
                              filename, line_number, code_filename)
  return {
    CodeBlock = function(cb)
      local fh = io.open(filepath)
      if not fh then
        io.stderr:write("Cannot open file " .. filepath .. " | Skipping includes\n")
        return cb
      end

      local start = 1
      if startLine then
        cb.attributes.startFrom = startLine
        start = tonumber(startLine)
      end
      local stop = endLine and tonumber(endLine) or nil

      local content = ""
      local number = 1
      for line in fh:lines("L") do
        if dedentLine then
          line = dedent(line, dedentLine)
        end
        if number >= start and (not stop or number <= stop) then
          content = content .. line
        end
        number = number + 1
      end
      fh:close()

      if lang then
        cb.classes = { lang, "cell-code" }
      else
        cb.classes:insert("cell-code")
      end
      if filename and not code_filename then
        cb.attributes.filename = filename
      end
      if line_number then
        cb.classes:insert("number-lines")
      end

      return pandoc.CodeBlock(content, cb.attr)
    end
  }
end

function Div(el)
  if not el.attributes['add-from'] then
    return
  end

  local filepath      = el.attributes['add-from']
  local startLine     = el.attributes['start-line']
  local endLine       = el.attributes['end-line']
  local dedent_line   = el.attributes.dedent
  local lang          = el.attributes['source-lang']
  local filename      = el.attributes['filename']
  local line_number   = el.attributes['code-line-numbers']
  local code_filename = el.attributes['code-filename']

  if code_filename then
    ensureHtmlDeps()
  end

  return el:walk(source_include(filepath, startLine, endLine, dedent_line,
                                lang, filename, line_number, code_filename))
end
