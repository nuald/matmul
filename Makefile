CXXFLAGS := -Wall -O2 -DNDEBUG -Wextra -pedantic \
	-Wcast-align -O3 -march=native -flto=auto \
	-Wa,-mbranches-within-32B-boundaries -std=c++20

PROG := \
	target/matmul \
	target/matmul-boost \
	target/matmul-eigen

.PHONY:all
all:$(PROG)

# OpenBLAS releases
# https://github.com/xianyi/OpenBLAS/releases
OPENBLAS_VERSION := OpenBLAS-0.3.20
openblas = target/$(OPENBLAS_VERSION)
$(openblas): | target
	cd target && \
	curl -L \
		https://github.com/xianyi/OpenBLAS/releases/download/v0.3.20/$(OPENBLAS_VERSION).tar.gz \
	| tar -xz

openblas_lib := $(openblas)/lib/libopenblas.a
$(openblas_lib): $(openblas)
	cd $^ && \
	make -j && \
	make PREFIX=. install

target/matmul:matmul.cpp | $(openblas)
	$(CXX) $(CXXFLAGS) -o $@ $^ -DHAVE_CBLAS $(openblas_lib) \
		-I$(openblas)/include

# Boost releases:
# https://www.boost.org/users/download/
BOOST_VERSION := boost_1_79_0
boost = target/$(BOOST_VERSION)
$(boost): | target
	cd target && \
	curl -L \
		https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/$(BOOST_VERSION).tar.bz2 \
	| tar -xj

target/matmul-boost:matmul-boost.cpp | $(boost)
	$(CXX) $(CXXFLAGS) -o $@ $^ -I$(boost) -DBOOST_UBLAS_NDEBUG

# Eigen releases:
# https://gitlab.com/libeigen/eigen/-/releases
EIGEN_VERSION := eigen-3.4.0
eigen = target/$(EIGEN_VERSION)
$(eigen): | target
	cd target && \
	curl -L \
		https://gitlab.com/libeigen/eigen/-/archive/3.4.0/$(EIGEN_VERSION).tar.bz2 \
	| tar -xj

target/matmul-eigen:matmul-eigen.cpp | $(eigen)
	$(CXX) $(CXXFLAGS) -o $@ $^ -I$(eigen)

.PHONY: clean
clean:
	-rm -rf target

target:
	mkdir -p target
