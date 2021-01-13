CC = g++
CFLAGS = -Wall
OBJFILES = Assembler.o main.o
TARGET = Assembler
all: $(TARGET)
$(TARGET): $(OBJFILES)
	@echo "Compiling...."
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJFILES) #Compiling and linking files

clean:
	rm -rf $(OBJFILES) *.o outputs Assembler