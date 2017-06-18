CC = gcc
AR = ar rcv
ifeq ($(windir),)
EXE =
RM = rm -f
else
EXE = .exe
RM = del
endif

CFLAGS = -ffunction-sections -O3 -Wno-discarded-qualifiers

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -Wl,-dead_strip
else
    LDFLAGS += -Wl,--gc-sections
endif

all:libmincrypt.a sprd-mkbootimg$(EXE) sprd-unpackbootimg$(EXE) sprd-dtbTool$(EXE)

static:
	make LDFLAGS="$(LDFLAGS) -static"

libmincrypt.a:
	make -C libmincrypt

sprd-mkbootimg$(EXE):mkbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ -L. -lmincrypt $(LDFLAGS) -s

mkbootimg.o:mkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -I. -Werror

sprd-unpackbootimg$(EXE):unpackbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

unpackbootimg.o:unpackbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

sprd-dtbTool$(EXE):dtbtool.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

dtbtool.o:dtbtool.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

clean:
	$(RM) mkbootimg.o sprd-mkbootimg sprd-mkbootimg.exe unpackbootimg.o sprd-unpackbootimg sprd-unpackbootimg.exe dtbtool.o sprd-dtbTool sprd-dtbTool.exe
	$(RM) libmincrypt.a Makefile.~
	make -C libmincrypt clean

