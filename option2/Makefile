all: prototype

%.o : %.F90
	gfortran -c -Wall -fcheck=all $< -o $@

prototype: fire_base.o fire_method1.o fire_method2.o fire_dispatcher.o driver.o
	gfortran -Wall -fcheck=all -fopenmp -o prototype $^

clean:
	rm -f *.mod *.o prototype

fire_method1.o: fire_base.o
fire_method2.o: fire_base.o
fire_dispatcher.o: fire_base.o fire_method1.o fire_method2.o
driver.o: fire_base.o fire_dispatcher.o
