A(n abstract) **category** $C$ consists of:
- a [[class|collection]] of [[object|objects]] $X,Y,Z,...$
- a [[class|collection]] of [[morphism|morphisms]] $f,g,h,...$

such that:
- each [[object]] has an identity [[morphism]] $\aut{1_X}{X}$.
- [[composition]] is [[associativity|associative]], e.g.:
$$\mor{f}{X}{Y}, \quad \mor{g}{Y}{Z} \qquad \leadsto \qquad \mor{gf}{X}{Z}$$

satisfying the following axioms:
- **Identity**: For any $\mor{f}{X}{Y}$, the [[composition|composites]] $1_Xf$ and $f1_X$ are both equal to $f$.
- [[associativity|Associativity]]: For all $f,g,h$, the [[composition|composites]] $h(gf)$ and $(hg)f$ are equal and denoted $hgf$.
$$\mor{f}{X}{Y}, \quad \mor{g}{Y}{Z}, \quad \mor{h}{Z}{W} \qquad \leadsto \qquad \mor{hgf}{X}{W}$$
