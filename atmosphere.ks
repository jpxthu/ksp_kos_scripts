function KerbinDensity {
    parameter altitude.
    return 3.407 * Constant:E ^ (- ((altitude + 18250) / 17990) ^ 2).
}
