ARCH = armv7-a
MCPU = cortex-a8

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./daeun.ld

ASM_SRCS = $(wildcard boot/*.S)
ASM=OBJS = $(patsubst boot/%.S, build/%.o, $(ARM_SRCS))

daeun = build/daeun.axf
daeun_bin = build/daeun.bin

.PHONY = all clean run debug gdb

all: $(daeun)

clean:
    @rm -fr build

run:
    qemu-system-arm -M realview-pb-a8 -kernel $(daeun)

debug: $(daeun)
    qemu-system-arm -M realview-pb-a8 -kernel $(daeun) -S -gdb tcp::1234,ipv4

gdb:
    arm-none-eabi-gdb

$(daeun): $(ASM_OBJS) $(LINKER_SCRIPT)
    $(LD) -n -T $(LINKER_SCRIPT) -o $(daeun) $(ASM_OBJS)
    $(OC) -O binary $(daeun) $(daeun_bin)

build/%.o: boot/%.S
    mkdir -p $(shell dirname $@)
    $(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<