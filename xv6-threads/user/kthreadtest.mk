# Build rule for _kthreadtest
_kthreadtest: kthreadtest.o ulib.o usys.o printf.o umalloc.o
	$(LD) $(LDFLAGS) -T user/user.ld -o _kthreadtest kthreadtest.o ulib.o usys.o printf.o umalloc.o
	$(OBJDUMP) -S _kthreadtest > kthreadtest.asm
