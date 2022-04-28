# Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le
from utils.Math64x61 import Math64x61_exp, Math64x61_fromFelt, Math64x61_div, Math64x61_pow, Math64x61_sub, Math64x61_FRACT_PART

#############################################
##                CONSTANTS                ##
#############################################

const ONE_64X = Math64x61_FRACT_PART
const FOUR_64X = 4 * Math64x61_FRACT_PART

#############################################
##                VIEWS                    ##
#############################################

# Get the spawn rate of an item.
# The rate is in bps.
# The rate is the probability that the item drops on the enemy killed.
# https://www.wolframalpha.com/input?i2d=true&i=y+%3D+1+-+Power%5Be%2C+-Power%5B%5C%2840%29x%5C%2841%29%2C+4%5D%5D%3B+x+%3E%3D+0
@view
func getRate{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*, 
    range_check_ptr
}(target : felt, price : felt) -> (newRate : felt):
    let (target_x64,) = Math64x61_fromFelt(target)
    let (price_x64,) = Math64x61_fromFelt(price)
    let (ratio,) = Math64x61_div(price_x64, target_x64)
    let (power,) = Math64x61_pow(ratio, FOUR_64X)
    let (exp,) = Math64x61_exp(-power)
    let (result,) = Math64x61_sub(ONE_64X, exp)
    
    return (result)
    
end