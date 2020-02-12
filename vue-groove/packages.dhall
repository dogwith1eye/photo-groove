let mkPackage =
      https://raw.githubusercontent.com/purescript/package-sets/ea2423043df6c90f0de754977923b6c5dfdddcfc/src/mkPackage.dhall sha256:0b197efa1d397ace6eb46b243ff2d73a3da5638d8d0ac8473e8e4a8fc528cf57

let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.6-20200127/packages.dhall sha256:06a623f48c49ea1c7675fdf47f81ddb02ae274558e29f511efae1df99ea92fb8

let overrides = {=}

let additions =
      { dom-simple =
          mkPackage
          [ "console"
          , "effect"
          , "functions"
          , "nullable"
          , "prelude"
          , "spec"
          , "spec-mocha"
          , "unsafe-coerce"
          ]
          "https://github.com/irresponsible/purescript-dom-simple"
          "v0.2.5"
      , ffi-simple =
          mkPackage
          [ "prelude"
          , "effect"
          , "maybe"
          , "functions"
          , "nullable"
          , "unsafe-coerce"
          ]
          "https://github.com/irresponsible/purescript-ffi-simple"
          "v0.2.8"
      , spec-mocha =
          mkPackage
          [ "console", "foldable-traversable", "exceptions", "spec" ]
          "https://github.com/purescript-spec/purescript-spec-mocha"
          "v4.0.0"
      }

in  upstream // overrides // additions
