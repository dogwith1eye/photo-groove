{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "vue-groove"
, dependencies = [ "console", "dom-simple", "effect", "ffi-simple", "psci-support" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
