# TINIH
There Is No Invisible Hand.

A (very) minimalistic PoC controller for game dynamics.


## Comptroller
A stateless controller.
It just has one function, `getRate(target, price)`, which will output the spawn rate, aka the probability that, on the desired action,
an item will be generated. Thus, the rate R will always satisfy the following bounds 0 <= R <= 1.

To expand a bit on why we are using the Weibull's distribution CDF to compute the rate (which is similar to a sigmoid function with only positive inputs) ; ideally, we want the ratio price/target to always be around 1. If it ratio goes above 1, it means that there is not enough supply and therefore we should increase it by increasing the spawn rate of the item. On the opposite, if it's below 1, it means there are too many items and thus we need to constrict the supply by reducing the rate at which the items appear.

It is currently deployed here](https://goerli.voyager.online/contract/0x0178f4dd48c04b7e37d0fb5e3d5c0b0ba8dd3c85d0c5cf6f7d5fe57a78ad83f2).

## Concerto
A super super dumb contract to just show the behaviour of the Comptroller with on-chain price tracking.
It is currently deployed here](https://goerli.voyager.online/contract/0x056f7f4674b8d0cedd12ca3f6d511aeef0602a2fa6eef73ac032dfee417b0ed7).

## Acknowledgements
- [Influenceth](https://github.com/influenceth/cairo-math-64x61)