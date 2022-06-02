c: C.cpp
	g++ -O0 C.cpp -o C.exe -mavx -mavx2
g1: G1.cu
	nvcc -O0 G1.cu -o G1.exe
g2: G2.cu
	nvcc -O0 G2.cu -o G2.exe
cl:
	del *.exe
	del *.exp
	del *.lib