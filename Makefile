# Makefile for gsdk_template application

# Detect OS for platform-specific settings
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    # macOS specific settings
    SHARED_EXT = dylib
    RPATH_FLAGS = -Wl,-rpath,@loader_path/gsdk/build/lib
else
    # Linux/other specific settings
    SHARED_EXT = so
    RPATH_FLAGS = -Wl,-rpath,'$$ORIGIN/gsdk/build/lib'
endif

# Compiler and flags
CC = clang
CFLAGS = -Wall -Wextra -Igsdk/include -Igsdk/include/core -Igsdk/include/data -Igsdk/include/performance -Igsdk/include/reflection -std=c23 -g

# Directories
GSDK_LIB_DIR = gsdk/build/lib

# Target executable name
TARGET = gsdk_app

# Find all libraries in the gsdk/build/lib directory
LIBS = $(wildcard $(GSDK_LIB_DIR)/*.$(SHARED_EXT))
LIB_NAMES = $(patsubst $(GSDK_LIB_DIR)/%.$(SHARED_EXT),%,$(LIBS))
# Use the full paths to libraries instead of -l flags
LDFLAGS = $(LIBS) $(RPATH_FLAGS)

# Source files
SRC = main.c

# Default target
all: $(TARGET)

# Build the executable
$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Clean target
clean:
	rm -f $(TARGET)

# Show information
info:
	@echo "Libraries found: $(LIB_NAMES)"
	@echo "Library paths: $(LIBS)"

.PHONY: all clean info
