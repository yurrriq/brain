A(n abstract) **category** $C$ consists of:
- a [[class|collection]] of [[object|objects]] $X,Y,Z,...$
- a [[class|collection]] of [[morphism|morphisms]] $f,g,h,...$

such that:
- each [[object]] has an identity [[morphism]] $1_X:X \to X$.
- [[composition]] is [[associativity|associative]], e.g.:
$$f:X \to Y, \quad g:Y\to Z \qquad
\leadsto \qquad gf:X \to Z$$

satisfying the following axioms:
- **Identity**: For any $f : X \to Y$, the [[composition|composites]] $1_Xf$ and $f1_X$ are both equal to $f$.
- [[associativity|Associativity]]: For all $f,g,h$, the [[composition|composites]] $h(gf)$ and $(hg)f$ are equal and denoted $hgf$.
$$f: X \to Y, \quad g:Y \to Z, \quad h: Z \to W \qquad
\leadsto \qquad hgf: X \to W$$
