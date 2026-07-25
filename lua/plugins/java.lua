return {
  {
    "mfussenegger/nvim-jdtls",

    opts = function(_, opts)
      opts.settings = opts.settings or {}
      opts.settings.java = opts.settings.java or {}
      opts.settings.java.project = opts.settings.java.project or {}

      opts.settings.java.project.sourcePaths = {
        "src",
      }

      opts.settings.java.project.outputPath = "bin"

      opts.settings.java.project.referencedLibraries = {
        "lib/**/*.jar",
      }
    end,
  },
}
