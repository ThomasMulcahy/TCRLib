TARGET=tcrlib
CC=clang
CFLAGS=-std=c99 -dynamiclib
OBJC_FLAGS=-lobjc -framework Cocoa

BUILD_DIR=build
SRC_DIR=src
SRC_PLATFORM_DIR=$(SRC_DIR)/platform
SRC_FONT_DIR=$(SRC_DIR)/font

SOURCES=$(wildcard $(SRC_DIR)/*.c)
OBJC_SOURCES=$(wildcard $(SRC_DIR)/*.m)
HEADERS=$(wildcard $(SRC_DIR)/*.h)

all: $(TARGET)

$(TARGET): ${SOURCES}
	$(CC) $(CFLAGS) $(OBJC_FLAGS) -O2 $(SOURCES) $(OBJC_SOURCES) -o $(BUILD_DIR)/$@.dylib

