all: prototype

%.o : %.F90
	gfortran -c -Wall -fcheck=all $< -o $@

prototype: fire_method_base.o fire_method1.o fire_method2.o fire.o driver.o
	gfortran -Wall -fcheck=all -fopenmp -o prototype $^

clean:
	rm -f *.mod *.o prototype

fire_method1.o: fire_method_base.o
fire_method2.o: fire_method_base.o
fire.o: fire_method_base.o fire_method1.o fire_method2.o
driver.o: fire.o
