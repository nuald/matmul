This repo evaluates different matrix multiplication implementations given two
large square matrices (2000-by-2000 in the following example):

|Implementation |Long description|
|:--------------|:---------------|
|Naive          |Most obvious implementation|
|Transposed     |Transposing the second matrix for cache efficiency|
|sdot w/o hints |Replacing the inner loop with [BLAS sdot()][sdot]|
|sdot with hints|sdot() with a bit unrolled loop|
|SSE sdot       |vectorized sdot() with explicit SSE instructions|
|SSE+tiling sdot|SSE sdot() with [loop tiling][looptile]|
|OpenBLAS sdot  |sdot() provided by OpenBLAS|
|OpenBLAS sgemm |sgemm() provided by OpenBLAS|

To compile the evaluation program:
```sh
make
```
After compilation, use
```sh
./matmul -h
```
to see the available options. Here is the result on my machines:

|Implementation |-a |Linux,-n2000|Linux,-n4000|
|:--------------|:-:|-----------:|-----------:|
|Naive          | 0 |7.53 sec    | 188.85 sec |
|Transposed     | 1 |6.66 sec    |  55.48 sec |
|sdot w/o hints | 4 |6.66 sec    |  55.04 sec |
|sdot with hints| 3 |2.41 sec    |  29.47 sec |
|SSE sdot       | 2 |1.36 sec    |  21.79 sec |
|SSE+tiling sdot| 7 |1.11 sec    |  10.84 sec |
|OpenBLAS sdot  | 5 |2.69 sec    |  28.87 sec |
|OpenBLAS sgemm | 6 |0.63 sec    |   4.91 sec |
|[uBLAS][ublas] |   |7.43 sec    | 165.74 sec |
|[Eigen][eigen] |   |0.61 sec    |   4.76 sec |

The machine configurations are as follows:

|Machine|CPU                        |OS         |Compiler  |
|:------|:--------------------------|:----------|:---------|
|Linux  |[2.6 GHz Xeon E5-2697][linuxcpu]       |CentOS 6   |gcc-4.4.7/icc-15.0.3 |

[oblas]: http://www.openblas.net/
[sdot]: http://www.netlib.org/lapack/lug/node145.html
[linuxcpu]: http://ark.intel.com/products/81059
[looptile]: https://en.wikipedia.org/wiki/Loop_tiling
[ublas]: https://www.boost.org/doc/libs/1_79_0/libs/numeric/ublas/doc/index.html
[eigen]: http://eigen.tuxfamily.org/index.php?title=Main_Page
