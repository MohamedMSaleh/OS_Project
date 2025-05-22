kthreadtest: kthreadtest.c ulib.o
	$(CC) $(CFLAGS) -o kthreadtest kthreadtest.c ulib.o

# Add kthreadtest to be built as a user program
_kthreadtest: kthreadtest.o ulib.o usys.o printf.o umalloc.o
	$(LD) $(LDFLAGS) -T user/user.ld -o _kthreadtest kthreadtest.o ulib.o usys.o printf.o umalloc.o
	$(OBJDUMP) -S _kthreadtest > kthreadtest.asm

# Ensure kthreadtest.o is built
kthreadtest.o: kthreadtest.c
	$(CC) $(CFLAGS) -c -o kthreadtest.o kthreadtest.c

kthread_many: kthread_many.c ulib.o
	$(CC) $(CFLAGS) -o kthread_many kthread_many.c ulib.o

kthread_mutex: kthread_mutex.c ulib.o
	$(CC) $(CFLAGS) -o kthread_mutex kthread_mutex.c ulib.o

kthread_edge: kthread_edge.c ulib.o
	$(CC) $(CFLAGS) -o kthread_edge kthread_edge.c ulib.o

kthread_arg: kthread_arg.c ulib.o
	$(CC) $(CFLAGS) -o kthread_arg kthread_arg.c ulib.o

# Ensure all thread test programs are built as _kthreadtest, _kthread_many, etc.
_kthreadtest: kthreadtest.o ulib.o usys.o printf.o umalloc.o
	$(LD) $(LDFLAGS) -T user/user.ld -o _kthreadtest kthreadtest.o ulib.o usys.o printf.o umalloc.o
	$(OBJDUMP) -S _kthreadtest > kthreadtest.asm

_kthread_many: kthread_many.o ulib.o usys.o printf.o umalloc.o
	$(LD) $(LDFLAGS) -T user/user.ld -o _kthread_many kthread_many.o ulib.o usys.o printf.o umalloc.o
	$(OBJDUMP) -S _kthread_many > kthread_many.asm

_kthread_mutex: kthread_mutex.o ulib.o usys.o printf.o umalloc.o
	$(LD) $(LDFLAGS) -T user/user.ld -o _kthread_mutex kthread_mutex.o ulib.o usys.o printf.o umalloc.o
	$(OBJDUMP) -S _kthread_mutex > kthread_mutex.asm

_kthread_edge: kthread_edge.o ulib.o usys.o printf.o umalloc.o
	$(LD) $(LDFLAGS) -T user/user.ld -o _kthread_edge kthread_edge.o ulib.o usys.o printf.o umalloc.o
	$(OBJDUMP) -S _kthread_edge > kthread_edge.asm

_kthread_arg: kthread_arg.o ulib.o usys.o printf.o umalloc.o
	$(LD) $(LDFLAGS) -T user/user.ld -o _kthread_arg kthread_arg.o ulib.o usys.o printf.o umalloc.o
	$(OBJDUMP) -S _kthread_arg > kthread_arg.asm

threadtest: threadtest.c ulib.o
	$(CC) $(CFLAGS) -o threadtest threadtest.c ulib.o

_threadtest: threadtest.o ulib.o usys.o printf.o umalloc.o
	$(LD) $(LDFLAGS) -T user/user.ld -o _threadtest threadtest.o ulib.o usys.o printf.o umalloc.o
	$(OBJDUMP) -S _threadtest > threadtest.asm

threadtest.o: threadtest.c
	$(CC) $(CFLAGS) -c -o threadtest.o threadtest.c
