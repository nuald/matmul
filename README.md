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
to see the available options. Here is the result on my server:

|Implementation |-a |Linux,-n2000|Linux,-n4000|
|:--------------|:-:|-----------:|-----------:|
|[Eigen][eigen] |   |0.13 sec    |   0.99 sec |
|OpenBLAS sgemm | 6 |0.14 sec    |   1.07 sec |
|SSE+tiling sdot| 7 |1.10 sec    |   7.42 sec |
|OpenBLAS sdot  | 5 |1.41 sec    |  11.86 sec |
|sdot with hints| 3 |1.53 sec    |  12.13 sec |
|SSE sdot       | 2 |1.62 sec    |  12.52 sec |
|Transposed     | 1 |7.27 sec    |  57.43 sec |
|sdot w/o hints | 4 |7.31 sec    |  57.16 sec |
|[uBLAS][ublas] |   |12.52 sec   | 197.81 sec |
|Naive          | 0 |15.04 sec   | 226.36 sec |

The machine configurations are as follows:

|Machine|CPU                        |OS         |Compiler  |
|:------|:--------------------------|:----------|:---------|
|Linux  |[3.10 GHz Xeon E-2324G][linuxcpu]       |Ubuntu 22.04   |gcc-11.2.0 |

[oblas]: https://www.openblas.net/
[sdot]: https://www.netlib.org/lapack/lug/node145.html
[linuxcpu]: https://ark.intel.com/content/www/us/en/ark/products/212255/intel-xeon-e2324g-processor-8m-cache-3-10-ghz.html
[looptile]: https://en.wikipedia.org/wiki/Loop_nest_optimization
[ublas]: https://www.boost.org/doc/libs/1_79_0/libs/numeric/ublas/doc/index.html
[eigen]: https://eigen.tuxfamily.org/index.php?title=Main_Page
