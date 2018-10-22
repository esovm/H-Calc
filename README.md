WORK IN PROGRESS !  Use at your own risk.

So, you want to write an interpreter for your own Domain Specific Language (DSL), in Haskell...  Then, clone H-Calc and start editing it.  H-Calc is a showcase of the best Haskell technologies to write such an interpreter :

- [megaparsec](http://hackage.haskell.org/package/megaparsec): parse source code in your DSL with ease, and build the corresponding Abstract Syntax Tree (AST)
- [Extensible Algebraic Datatype](http://hsyl20.fr/home/posts/2018-05-22-extensible-adt.html) (EADT): start with a simple DSL interpreter for the core features, then add extensions in a modular way (each new feature in its own Haskell module) ([tutorial](http://hsyl20.fr/home/posts/2018-05-22-extensible-adt.html))
- [Recursion-scheme](http://hackage.haskell.org/package/recursion-schemes-5.0.3): a short and efficient way to transform the AST, without boilerplate ([tutorial](https://blog.sumtypeofway.com/an-introduction-to-recursion-schemes/))
- [Relude](http://hackage.haskell.org/package/relude): GHC comes with a set of libraries ("[base](http://hackage.haskell.org/package/base)"), some of which are imported by default in your program ("[Prelude](http://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html)").  For historical reason, some choices that Prelude made are not optimal anymore.  Relude is an alternative Prelude that uses Text instead of String and avoids partial functions, among other benefits.
- [HSpec](http://hackage.haskell.org/package/hspec), with [hspec-discover](http://hackage.haskell.org/package/hspec-discover): to organize your test suite
- [Ghcid](https://github.com/ndmitchell/ghcid): Automatically run your test suite as soon as you save a program file, provided it has no error nor warning (using `ghcid "--command=stack ghci H-Calc" "--test=:main"`)

The evaluation pipeline has these steps:

* parse the text containing the formula into the AST
* annotate the AST with type information, and report any type error
* transform the AST in several "nanopass"
* finally evaluate the AST to get the desired result

# H-Calc

The first iteration of our DSL interpreter supports the addition of integers:

    2 + 3 = 5

It is a good starting point for your project: you can find it on the master branch on git.  

Our second iteration supports multiplication by repeated additions: it transforms n\*a into a+a+... (n times), after applying the distribution rule recursively: `a*(b+c) = a*b + a*c`.  n must be positive.  This new functionality is implemented in C_Mul.hs only, showing the modularity of the design. It is accessible in the Mul branch on git.

    2 * (3 + 4) -> ((3 + 3) + (4 + 4)) = 14

In a 3rd iteration, we support addition of float, and multiplication of a float by an integer (`Mul n a`).  This requires some type checking.  It is implemented in D_Float.hs and C_Mul.hs.

    2 * 3.0 -> (3.0 + 3.0) = 6.0