ARCH = armv7-a

MCPU = cortex-a8

 

CC = arm-none-eabi-gcc

AS = arm-none-eabi-as

LD = arm-none-eabi-ld

OC = arm-none-eabi-objcopy

 

LINKER_SCRIPT = ./navilos.ld

MAP_FILE = build/navilos.map

 

ASM_SRCS = $(wildcard boot/*.S)

ASM_OBJS = $(patsubst boot/%.S, build/%.os, $(ASM_SRCS))

 

C_SRCS = $(wildcard boot/*.c)

C_OBJS = $(patsubst boot/%.c, build/%.o, $(C_SRCS))

 

INC_DIRS =-I include

 

navilos = build/navilos.axf

navilos_bin = build/navilos.bin

 

.PHONY: all clean run debug gdb

 

all: $(navilos)

 

clean:

# 책에는 rm -fr 로 되어있는데 오타인거 같아 rm -rf로 수정함 #

@rm -rf build




run: $(navilos)

qemu-system-arm -M realview-pb-a8 -kernel $(navilos)

 

debug: $(navilos)

qemu-system-arm -M realview-pb-a8 -kernel $(navilos) -S -gdb tcp::1234,ipv4

 

gdb:

gdb-multiarch

 

$(navilos): $(ASM_OBJS) $(C_OBJS) $(LINKER_SCRIPT)

$(LD) -n -T $(LINKER_SCRIPT) -o $(navilos) $(ASM_OBJS) $(C_OBJS) -Map=$(MAP_FILE)

$(OC) -O binary $(navilos) $(navilos_bin)

 

build/%.os: $(ASM_SRCS)

mkdir -p $(shell dirname $@) #mkdir -p build 실행 됨 #

$(CC) -march=$(ARCH) -mcpu=$(MCPU) $(INC_DIRS) -c -g -o $@ $<

#$(AS) 에서 $(CC)로 수정 include "~~.h" 는 c언어 문법이므로#

 

build/%.o: $(C_SRCS)

mkdir -p $(shell dirname $@)

$(CC) -march=$(ARCH) -mcpu=$(MCPU) $(INC_DIRS) -c -g -o $@ $<
