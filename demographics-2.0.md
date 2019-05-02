# Planning for PLAY demographics 2.0

## Purpose

This document discusses design considerations for the next (2.0) version of the PLAY Project's site demographics data collection and plotting code.

## Goals

- Provide useful demographics data for recruiting on a site-by-site basis
- Provide a framework for investigators that can be extended to other relevant demographic variables beyond those used directly for recruiting and reporting.

## Specific Steps

1. Determine what demographic variables we want to pull from the Census and their Census variable identifiers, e.g.
    - Economic status
    - Educational status
    - Race and ethnicity
    - Languages spoken
2. For each data collection site:
    - Identify the county or counties from which data will be collected.
    - Have data collection site PIs give a set of weights ($w_i$, $\sum_{i=1}^{n} w_i = 1, n >= 1$) indicating what proportion of the total sample they expect to collect from each county.
3. Write code using the `tidycensus` or `acs` packages that provides these data programmatically.
    - Collect demographic data for each county $k$ reported with $w_i > 0$.
    - Create a 'site estimate' for county $k$ based on the weighted sum of each demographic variable $d_j$ times the county weights, $d_k = \sum_{i=1}^{n_k} w_i * d_{ij}$
    - Consider whether to package the code in a Shiny app.
    - Consider whether to visualize data graphically in map format.