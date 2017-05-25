# Credentialed Feature Based Method Comparison

## Background

```r
head(methodstats_a)
```

```
##      signal_total signal_allpeak signal_cf
## [1,]    9.457e+09      2.228e+09 130586871
```

```r
head(methodstats_b)
```

```
##      signal_total signal_allpeak signal_cf
## [1,]    9.418e+09      2.621e+09 186945040
```

## Credentialed Features

```r
nrow(cfs_a)
```

```
## [1] 675
```

```r
nrow(cfs_b)
```

```
## [1] 670
```

## Signal to Noise
<img src="figure/unnamed-chunk-31.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" /><img src="figure/unnamed-chunk-32.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" /><img src="figure/unnamed-chunk-33.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

## Sensitivity
<img src="figure/unnamed-chunk-41.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" /><img src="figure/unnamed-chunk-42.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" /><img src="figure/unnamed-chunk-43.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" /><img src="figure/unnamed-chunk-44.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />

## Number of Eluting Compounds

```r
  ggplot(cred_peakstats, aes(x=rt, fill=method)) +     
    geom_density(alpha=.3, adjust = .08)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 


## Tailing
<img src="figure/unnamed-chunk-61.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" /><img src="figure/unnamed-chunk-62.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" /><img src="figure/unnamed-chunk-63.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" />

## Compiled Data

```r
head(cred_peakstats)
```

```
##   peakfwhm      sn    noise tailing method row    mz mzmin mzmax     rt
## 1       15   7.873  4006.67 0.11111      A   1 71.01 71.01 71.01  804.3
## 2        8     Inf     0.00 1.66667      A   2 85.07 85.07 85.07 1679.9
## 3        5  41.406    96.47 0.06897      A   3 85.03 85.03 85.03 1694.4
## 4        5  41.406    96.47 0.06897      A   4 85.03 85.03 85.03 1694.4
## 5        7 217.115    73.32 0.83333      A   5 88.04 88.04 88.04 1014.9
## 6       17   7.302 13598.20 1.00000      A   6 89.03 89.03 89.03  804.3
##    rtmin  rtmax    into    intb  maxo sn.1  egauss   mu sigma     h     f
## 1  786.3  822.3  570398  553716 31545   66 0.06509  805 8.282 27854 31494
## 2 1669.5 1687.4   11705   11689  1479 1478 0.19369 1681 4.631  1058 46750
## 3 1674.5 1716.4   35782   34040  3994   24 0.14193 1697 3.398  2787 47115
## 4 1674.5 1716.4   35782   34040  3994   24 0.14193 1697 3.398  2787 47115
## 5 1005.9 1030.8  135597  135148 15919  216 0.06080 1016 3.688 14110 32889
## 6  786.3  822.3 1961993 1950976 99288  332 0.04982  805 8.392 94988 32890
##   dppm scale scpos scmin scmax lmin lmax sample
## 1    2     8   805   797   813  787  823      1
## 2    5    -1    -1    -1    -1  208  226      1
## 3    6    12  1697  1685  1709  197  239      1
## 4    6    12  1697  1685  1709  197  239      1
## 5    3     8  1016  1008  1024  210  235      1
## 6    2     8   805   797   813  787  823      1
```
