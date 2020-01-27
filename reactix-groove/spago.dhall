{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "reactix-groove"
, dependencies = [ "console", "effect", "psci-support", "reactix", "random" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
