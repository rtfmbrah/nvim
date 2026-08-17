local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
local de_spellfile = spell_dir .. "/de.utf-8.spl"

local de_spell_urls = {
  "https://ftp.nluug.nl/pub/vim/runtime/spell/de.utf-8.spl",
  "https://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.spl",
}

local function ensure_german_spell()
  if vim.fn.filereadable(de_spellfile) == 1 then
    return
  end

  local tool = vim.fn.executable("curl") == 1 and "curl" or vim.fn.executable("wget") == 1 and "wget" or nil

  if not tool then
    vim.notify("German spell file missing and curl/wget not found.", vim.log.levels.WARN)
    return
  end

  vim.fn.mkdir(spell_dir, "p")

  for _, url in ipairs(de_spell_urls) do
    if tool == "curl" then
      vim.fn.system({ "curl", "-fsSL", url, "-o", de_spellfile })
    else
      vim.fn.system({ "wget", "-qO", de_spellfile, url })
    end

    if vim.v.shell_error == 0 and vim.fn.filereadable(de_spellfile) == 1 then
      return
    end
  end

  vim.notify("Could not download German spell file.", vim.log.levels.WARN)
end

local function correct_word(word)
  local bad = vim.fn.spellbadword(word)

  if bad[2] ~= "bad" then
    return word
  end

  if vim.fn.match(word, "\\v[\\d_]") ~= -1 then
    return word
  end

  local suggestions = vim.fn.spellsuggest(word, 3)

  if #suggestions == 0 then
    return word
  end

  local fixed = suggestions[1]

  if word:sub(1, 1):match("%u") then
    fixed = fixed:sub(1, 1):upper() .. fixed:sub(2)
  end

  return fixed
end

-- used by `v:lua.SpellCorrect(...)` in the substitute below
_G.SpellCorrect = correct_word

local function correct_selection()
  if not vim.wo.spell then
    vim.notify("Spell checking is not enabled", vim.log.levels.WARN)
    return
  end

  vim.cmd("silent! '<,'>s/\\v[[:alpha:]][[:alpha:]']*/\\=v:lua.SpellCorrect(submatch(0))/g")
end

local function correct_word_under_cursor()
  if not vim.wo.spell then
    vim.notify("Spell checking is not enabled", vim.log.levels.WARN)
    return
  end

  local word = vim.fn.expand("<cword>")

  if word == "" then
    return
  end

  local fixed = correct_word(word)

  if fixed == word then
    vim.notify("No spelling correction found for: " .. word, vim.log.levels.INFO)
    return
  end

  local pattern = "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>"
  local replacement = vim.fn.escape(fixed, "\\~")

  vim.cmd("silent! substitute#" .. pattern .. "#" .. replacement .. "#")
end

ensure_german_spell()

vim.api.nvim_create_user_command("SpellCorrect", function(command)
  local range = command.range > 0 and command.line1 .. "," .. command.line2 .. "s" or "%s"
  vim.cmd("silent! " .. range .. "/\\v[[:alpha:]][[:alpha:]']*/\\=v:lua.SpellCorrect(submatch(0))/g")
end, {
  range = true,
  desc = "Correct spelling in range or whole buffer",
})

return {
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<leader>zc",
        correct_word_under_cursor,
        desc = "Correct Spelling",
      },
      {
        "<leader>zc",
        correct_selection,
        mode = "x",
        desc = "Correct Spelling in Selection",
      },
    },
  },
}
