vim.api.nvim_create_user_command("Header42", function(args)
  if args.bang then
    require("header42").insert()
  else
    require("header42").update()
  end
end, { desc = "Update (or insert) the 42 header", bang = true })
