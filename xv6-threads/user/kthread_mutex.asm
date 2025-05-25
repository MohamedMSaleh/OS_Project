
user/_kthread_mutex:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <umutex_init>:

typedef struct {
  volatile int locked;
} umutex_t;

void umutex_init(umutex_t *m) { m->locked = 0; }
  400000:	1141                	addi	sp,sp,-16
  400002:	e406                	sd	ra,8(sp)
  400004:	e022                	sd	s0,0(sp)
  400006:	0800                	addi	s0,sp,16
  400008:	00052023          	sw	zero,0(a0)
  40000c:	60a2                	ld	ra,8(sp)
  40000e:	6402                	ld	s0,0(sp)
  400010:	0141                	addi	sp,sp,16
  400012:	8082                	ret

0000000000400014 <umutex_lock>:

// Improved mutex lock with memory barrier
void umutex_lock(umutex_t *m) {
  400014:	1141                	addi	sp,sp,-16
  400016:	e406                	sd	ra,8(sp)
  400018:	e022                	sd	s0,0(sp)
  40001a:	0800                	addi	s0,sp,16
  // Try to acquire the lock with exponential backoff strategy
  int backoff = 1;
  40001c:	4705                	li	a4,1
  while (__sync_lock_test_and_set(&m->locked, 1) != 0) {
  40001e:	4685                	li	a3,1
      // CPU yield - compiler barrier
      __asm__ volatile("" ::: "memory");
    }
    
    // Double backoff time (capped at 1000 iterations)
    if (backoff < 1000)
  400020:	3e700613          	li	a2,999
  while (__sync_lock_test_and_set(&m->locked, 1) != 0) {
  400024:	a021                	j	40002c <umutex_lock+0x18>
      backoff *= 2;
  400026:	0017179b          	slliw	a5,a4,0x1
    for (int i = 0; i < backoff; i++) {
  40002a:	873e                	mv	a4,a5
  while (__sync_lock_test_and_set(&m->locked, 1) != 0) {
  40002c:	87b6                	mv	a5,a3
  40002e:	0cf527af          	amoswap.w.aq	a5,a5,(a0)
  400032:	2781                	sext.w	a5,a5
  400034:	cb91                	beqz	a5,400048 <umutex_lock+0x34>
    for (int i = 0; i < backoff; i++) {
  400036:	4781                	li	a5,0
  400038:	fee057e3          	blez	a4,400026 <umutex_lock+0x12>
  40003c:	2785                	addiw	a5,a5,1
  40003e:	fef71fe3          	bne	a4,a5,40003c <umutex_lock+0x28>
    if (backoff < 1000)
  400042:	fee644e3          	blt	a2,a4,40002a <umutex_lock+0x16>
  400046:	b7c5                	j	400026 <umutex_lock+0x12>
  }
  
  // Full memory barrier - ensure all operations after the lock are not reordered before it
  __sync_synchronize();
  400048:	0330000f          	fence	rw,rw
}
  40004c:	60a2                	ld	ra,8(sp)
  40004e:	6402                	ld	s0,0(sp)
  400050:	0141                	addi	sp,sp,16
  400052:	8082                	ret

0000000000400054 <umutex_unlock>:

// Improved mutex unlock with memory barrier
void umutex_unlock(umutex_t *m) {
  400054:	1141                	addi	sp,sp,-16
  400056:	e406                	sd	ra,8(sp)
  400058:	e022                	sd	s0,0(sp)
  40005a:	0800                	addi	s0,sp,16
  // Full memory barrier - ensure all operations before the unlock stay before it
  __sync_synchronize();
  40005c:	0330000f          	fence	rw,rw
  
  // Release the lock - important to use lock_release not direct assignment
  __sync_lock_release(&m->locked);
  400060:	0310000f          	fence	rw,w
  400064:	00052023          	sw	zero,0(a0)
}
  400068:	60a2                	ld	ra,8(sp)
  40006a:	6402                	ld	s0,0(sp)
  40006c:	0141                	addi	sp,sp,16
  40006e:	8082                	ret

0000000000400070 <thread_func>:
#define STACK_SIZE 4096
#define TIMEOUT_TICKS 10000000
volatile int shared = 0;
umutex_t mtx;

void thread_func(void) {
  400070:	7179                	addi	sp,sp,-48
  400072:	f406                	sd	ra,40(sp)
  400074:	f022                	sd	s0,32(sp)
  400076:	ec26                	sd	s1,24(sp)
  400078:	e84a                	sd	s2,16(sp)
  40007a:	e44e                	sd	s3,8(sp)
  40007c:	1800                	addi	s0,sp,48
  40007e:	3e800493          	li	s1,1000
  for (int i = 0; i < 1000; i++) {
    umutex_lock(&mtx);
  400082:	00002997          	auipc	s3,0x2
  400086:	f7e98993          	addi	s3,s3,-130 # 402000 <mtx>
    shared++;
  40008a:	00002917          	auipc	s2,0x2
  40008e:	f7a90913          	addi	s2,s2,-134 # 402004 <shared>
    umutex_lock(&mtx);
  400092:	854e                	mv	a0,s3
  400094:	f81ff0ef          	jal	400014 <umutex_lock>
    shared++;
  400098:	00092783          	lw	a5,0(s2)
  40009c:	2785                	addiw	a5,a5,1
  40009e:	00f92023          	sw	a5,0(s2)
    umutex_unlock(&mtx);
  4000a2:	854e                	mv	a0,s3
  4000a4:	fb1ff0ef          	jal	400054 <umutex_unlock>
  for (int i = 0; i < 1000; i++) {
  4000a8:	34fd                	addiw	s1,s1,-1
  4000aa:	f4e5                	bnez	s1,400092 <thread_func+0x22>
  }
  kthread_exit(0);
  4000ac:	4501                	li	a0,0
  4000ae:	496000ef          	jal	400544 <kthread_exit>

00000000004000b2 <main>:
}

int main() {
  4000b2:	7171                	addi	sp,sp,-176
  4000b4:	f506                	sd	ra,168(sp)
  4000b6:	f122                	sd	s0,160(sp)
  4000b8:	ed26                	sd	s1,152(sp)
  4000ba:	e94a                	sd	s2,144(sp)
  4000bc:	e54e                	sd	s3,136(sp)
  4000be:	e152                	sd	s4,128(sp)
  4000c0:	fcd6                	sd	s5,120(sp)
  4000c2:	f8da                	sd	s6,112(sp)
  4000c4:	f4de                	sd	s7,104(sp)
  4000c6:	f0e2                	sd	s8,96(sp)
  4000c8:	ece6                	sd	s9,88(sp)
  4000ca:	e8ea                	sd	s10,80(sp)
  4000cc:	e4ee                	sd	s11,72(sp)
  4000ce:	1900                	addi	s0,sp,176
  printf("[main] Starting kthread_mutex\n");
  4000d0:	00001517          	auipc	a0,0x1
  4000d4:	9a050513          	addi	a0,a0,-1632 # 400a70 <malloc+0xfe>
  4000d8:	7e0000ef          	jal	4008b8 <printf>
void umutex_init(umutex_t *m) { m->locked = 0; }
  4000dc:	00002797          	auipc	a5,0x2
  4000e0:	f207a223          	sw	zero,-220(a5) # 402000 <mtx>
  umutex_init(&mtx);
  int tids[NTHREADS];
  void *stacks[NTHREADS];
  for (int i = 0; i < NTHREADS; i++) {
  4000e4:	f6040c93          	addi	s9,s0,-160
  4000e8:	f8040913          	addi	s2,s0,-128
void umutex_init(umutex_t *m) { m->locked = 0; }
  4000ec:	8aca                	mv	s5,s2
  4000ee:	8a66                	mv	s4,s9
  for (int i = 0; i < NTHREADS; i++) {
  4000f0:	4981                	li	s3,0
    void *stack = malloc(STACK_SIZE);
  4000f2:	6b05                	lui	s6,0x1
    stacks[i] = stack;
    tids[i] = kthread_create(thread_func, stack, STACK_SIZE);
  4000f4:	00000d17          	auipc	s10,0x0
  4000f8:	f7cd0d13          	addi	s10,s10,-132 # 400070 <thread_func>
    printf("[main] kthread_create returned tid=%d for i=%d\n", tids[i], i);
  4000fc:	00001c17          	auipc	s8,0x1
  400100:	994c0c13          	addi	s8,s8,-1644 # 400a90 <malloc+0x11e>
    if (tids[i] < 0) printf("Failed to create thread %d\n", i);
  400104:	00001d97          	auipc	s11,0x1
  400108:	9bcd8d93          	addi	s11,s11,-1604 # 400ac0 <malloc+0x14e>
  for (int i = 0; i < NTHREADS; i++) {
  40010c:	4b91                	li	s7,4
  40010e:	a031                	j	40011a <main+0x68>
  400110:	2985                	addiw	s3,s3,1
  400112:	0a21                	addi	s4,s4,8
  400114:	0a91                	addi	s5,s5,4
  400116:	03798b63          	beq	s3,s7,40014c <main+0x9a>
    void *stack = malloc(STACK_SIZE);
  40011a:	855a                	mv	a0,s6
  40011c:	057000ef          	jal	400972 <malloc>
  400120:	85aa                	mv	a1,a0
    stacks[i] = stack;
  400122:	00aa3023          	sd	a0,0(s4)
    tids[i] = kthread_create(thread_func, stack, STACK_SIZE);
  400126:	865a                	mv	a2,s6
  400128:	856a                	mv	a0,s10
  40012a:	412000ef          	jal	40053c <kthread_create>
  40012e:	84aa                	mv	s1,a0
  400130:	00aaa023          	sw	a0,0(s5)
    printf("[main] kthread_create returned tid=%d for i=%d\n", tids[i], i);
  400134:	864e                	mv	a2,s3
  400136:	85aa                	mv	a1,a0
  400138:	8562                	mv	a0,s8
  40013a:	77e000ef          	jal	4008b8 <printf>
    if (tids[i] < 0) printf("Failed to create thread %d\n", i);
  40013e:	fc04d9e3          	bgez	s1,400110 <main+0x5e>
  400142:	85ce                	mv	a1,s3
  400144:	856e                	mv	a0,s11
  400146:	772000ef          	jal	4008b8 <printf>
  40014a:	b7d9                	j	400110 <main+0x5e>
  }
  for (int i = 0; i < NTHREADS; i++) {
  40014c:	4b81                	li	s7,0
    int status = 0;
    int ret = -1;
    int ticks = 0;
    while (ticks < TIMEOUT_TICKS) {
      ret = kthread_join(tids[i], &status);
  40014e:	f5c40993          	addi	s3,s0,-164
      if (ret == 0) break;
      ticks++;
      if (ticks % 1000000 == 0) printf("[main] Waiting for thread %d to join...\n", i);
  400152:	431beb37          	lui	s6,0x431be
  400156:	e83b0b13          	addi	s6,s6,-381 # 431bde83 <base+0x42dbbe73>
  40015a:	000f4ab7          	lui	s5,0xf4
  40015e:	240a8a9b          	addiw	s5,s5,576 # f4240 <umutex_init-0x30bdc0>
    while (ticks < TIMEOUT_TICKS) {
  400162:	00989a37          	lui	s4,0x989
  400166:	680a0a13          	addi	s4,s4,1664 # 989680 <base+0x587670>
  40016a:	a051                	j	4001ee <main+0x13c>
  40016c:	07448063          	beq	s1,s4,4001cc <main+0x11a>
      ret = kthread_join(tids[i], &status);
  400170:	85ce                	mv	a1,s3
  400172:	00092503          	lw	a0,0(s2)
  400176:	3d6000ef          	jal	40054c <kthread_join>
      if (ret == 0) break;
  40017a:	c125                	beqz	a0,4001da <main+0x128>
      ticks++;
  40017c:	0014871b          	addiw	a4,s1,1
  400180:	84ba                	mv	s1,a4
      if (ticks % 1000000 == 0) printf("[main] Waiting for thread %d to join...\n", i);
  400182:	036707b3          	mul	a5,a4,s6
  400186:	97c9                	srai	a5,a5,0x32
  400188:	41f7569b          	sraiw	a3,a4,0x1f
  40018c:	9f95                	subw	a5,a5,a3
  40018e:	02fa87bb          	mulw	a5,s5,a5
  400192:	9f1d                	subw	a4,a4,a5
  400194:	ff61                	bnez	a4,40016c <main+0xba>
  400196:	85de                	mv	a1,s7
  400198:	8562                	mv	a0,s8
  40019a:	71e000ef          	jal	4008b8 <printf>
  40019e:	b7f9                	j	40016c <main+0xba>
    }
    if (ret != 0) printf("[main] kthread_join failed or timed out for thread %d\n", i);
    free(stacks[i]);
  }
  printf("[main] All threads joined. shared=%d (should be %d)\n", shared, NTHREADS*1000);
  4001a0:	6605                	lui	a2,0x1
  4001a2:	fa060613          	addi	a2,a2,-96 # fa0 <umutex_init-0x3ff060>
  4001a6:	00002597          	auipc	a1,0x2
  4001aa:	e5e5a583          	lw	a1,-418(a1) # 402004 <shared>
  4001ae:	00001517          	auipc	a0,0x1
  4001b2:	96250513          	addi	a0,a0,-1694 # 400b10 <malloc+0x19e>
  4001b6:	702000ef          	jal	4008b8 <printf>
  printf("[main] Exiting kthread_mutex\n");
  4001ba:	00001517          	auipc	a0,0x1
  4001be:	98e50513          	addi	a0,a0,-1650 # 400b48 <malloc+0x1d6>
  4001c2:	6f6000ef          	jal	4008b8 <printf>
  exit(0);
  4001c6:	4501                	li	a0,0
  4001c8:	2d4000ef          	jal	40049c <exit>
    if (ret != 0) printf("[main] kthread_join failed or timed out for thread %d\n", i);
  4001cc:	85de                	mv	a1,s7
  4001ce:	00001517          	auipc	a0,0x1
  4001d2:	99a50513          	addi	a0,a0,-1638 # 400b68 <malloc+0x1f6>
  4001d6:	6e2000ef          	jal	4008b8 <printf>
    free(stacks[i]);
  4001da:	000cb503          	ld	a0,0(s9)
  4001de:	70e000ef          	jal	4008ec <free>
  for (int i = 0; i < NTHREADS; i++) {
  4001e2:	2b85                	addiw	s7,s7,1
  4001e4:	0ca1                	addi	s9,s9,8
  4001e6:	0911                	addi	s2,s2,4
  4001e8:	4791                	li	a5,4
  4001ea:	fafb8be3          	beq	s7,a5,4001a0 <main+0xee>
    int status = 0;
  4001ee:	f4042e23          	sw	zero,-164(s0)
    int ticks = 0;
  4001f2:	4481                	li	s1,0
      if (ticks % 1000000 == 0) printf("[main] Waiting for thread %d to join...\n", i);
  4001f4:	00001c17          	auipc	s8,0x1
  4001f8:	8ecc0c13          	addi	s8,s8,-1812 # 400ae0 <malloc+0x16e>
  4001fc:	bf95                	j	400170 <main+0xbe>

00000000004001fe <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4001fe:	1141                	addi	sp,sp,-16
  400200:	e406                	sd	ra,8(sp)
  400202:	e022                	sd	s0,0(sp)
  400204:	0800                	addi	s0,sp,16
  extern int main();
  main();
  400206:	eadff0ef          	jal	4000b2 <main>
  exit(0);
  40020a:	4501                	li	a0,0
  40020c:	290000ef          	jal	40049c <exit>

0000000000400210 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400210:	1141                	addi	sp,sp,-16
  400212:	e406                	sd	ra,8(sp)
  400214:	e022                	sd	s0,0(sp)
  400216:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400218:	87aa                	mv	a5,a0
  40021a:	0585                	addi	a1,a1,1
  40021c:	0785                	addi	a5,a5,1
  40021e:	fff5c703          	lbu	a4,-1(a1)
  400222:	fee78fa3          	sb	a4,-1(a5)
  400226:	fb75                	bnez	a4,40021a <strcpy+0xa>
    ;
  return os;
}
  400228:	60a2                	ld	ra,8(sp)
  40022a:	6402                	ld	s0,0(sp)
  40022c:	0141                	addi	sp,sp,16
  40022e:	8082                	ret

0000000000400230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400230:	1141                	addi	sp,sp,-16
  400232:	e406                	sd	ra,8(sp)
  400234:	e022                	sd	s0,0(sp)
  400236:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  400238:	00054783          	lbu	a5,0(a0)
  40023c:	cb91                	beqz	a5,400250 <strcmp+0x20>
  40023e:	0005c703          	lbu	a4,0(a1)
  400242:	00f71763          	bne	a4,a5,400250 <strcmp+0x20>
    p++, q++;
  400246:	0505                	addi	a0,a0,1
  400248:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  40024a:	00054783          	lbu	a5,0(a0)
  40024e:	fbe5                	bnez	a5,40023e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  400250:	0005c503          	lbu	a0,0(a1)
}
  400254:	40a7853b          	subw	a0,a5,a0
  400258:	60a2                	ld	ra,8(sp)
  40025a:	6402                	ld	s0,0(sp)
  40025c:	0141                	addi	sp,sp,16
  40025e:	8082                	ret

0000000000400260 <strlen>:

uint
strlen(const char *s)
{
  400260:	1141                	addi	sp,sp,-16
  400262:	e406                	sd	ra,8(sp)
  400264:	e022                	sd	s0,0(sp)
  400266:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  400268:	00054783          	lbu	a5,0(a0)
  40026c:	cf99                	beqz	a5,40028a <strlen+0x2a>
  40026e:	0505                	addi	a0,a0,1
  400270:	87aa                	mv	a5,a0
  400272:	86be                	mv	a3,a5
  400274:	0785                	addi	a5,a5,1
  400276:	fff7c703          	lbu	a4,-1(a5)
  40027a:	ff65                	bnez	a4,400272 <strlen+0x12>
  40027c:	40a6853b          	subw	a0,a3,a0
  400280:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  400282:	60a2                	ld	ra,8(sp)
  400284:	6402                	ld	s0,0(sp)
  400286:	0141                	addi	sp,sp,16
  400288:	8082                	ret
  for(n = 0; s[n]; n++)
  40028a:	4501                	li	a0,0
  40028c:	bfdd                	j	400282 <strlen+0x22>

000000000040028e <memset>:

void*
memset(void *dst, int c, uint n)
{
  40028e:	1141                	addi	sp,sp,-16
  400290:	e406                	sd	ra,8(sp)
  400292:	e022                	sd	s0,0(sp)
  400294:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400296:	ca19                	beqz	a2,4002ac <memset+0x1e>
  400298:	87aa                	mv	a5,a0
  40029a:	1602                	slli	a2,a2,0x20
  40029c:	9201                	srli	a2,a2,0x20
  40029e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  4002a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  4002a6:	0785                	addi	a5,a5,1
  4002a8:	fee79de3          	bne	a5,a4,4002a2 <memset+0x14>
  }
  return dst;
}
  4002ac:	60a2                	ld	ra,8(sp)
  4002ae:	6402                	ld	s0,0(sp)
  4002b0:	0141                	addi	sp,sp,16
  4002b2:	8082                	ret

00000000004002b4 <strchr>:

char*
strchr(const char *s, char c)
{
  4002b4:	1141                	addi	sp,sp,-16
  4002b6:	e406                	sd	ra,8(sp)
  4002b8:	e022                	sd	s0,0(sp)
  4002ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
  4002bc:	00054783          	lbu	a5,0(a0)
  4002c0:	cf81                	beqz	a5,4002d8 <strchr+0x24>
    if(*s == c)
  4002c2:	00f58763          	beq	a1,a5,4002d0 <strchr+0x1c>
  for(; *s; s++)
  4002c6:	0505                	addi	a0,a0,1
  4002c8:	00054783          	lbu	a5,0(a0)
  4002cc:	fbfd                	bnez	a5,4002c2 <strchr+0xe>
      return (char*)s;
  return 0;
  4002ce:	4501                	li	a0,0
}
  4002d0:	60a2                	ld	ra,8(sp)
  4002d2:	6402                	ld	s0,0(sp)
  4002d4:	0141                	addi	sp,sp,16
  4002d6:	8082                	ret
  return 0;
  4002d8:	4501                	li	a0,0
  4002da:	bfdd                	j	4002d0 <strchr+0x1c>

00000000004002dc <gets>:

char*
gets(char *buf, int max)
{
  4002dc:	7159                	addi	sp,sp,-112
  4002de:	f486                	sd	ra,104(sp)
  4002e0:	f0a2                	sd	s0,96(sp)
  4002e2:	eca6                	sd	s1,88(sp)
  4002e4:	e8ca                	sd	s2,80(sp)
  4002e6:	e4ce                	sd	s3,72(sp)
  4002e8:	e0d2                	sd	s4,64(sp)
  4002ea:	fc56                	sd	s5,56(sp)
  4002ec:	f85a                	sd	s6,48(sp)
  4002ee:	f45e                	sd	s7,40(sp)
  4002f0:	f062                	sd	s8,32(sp)
  4002f2:	ec66                	sd	s9,24(sp)
  4002f4:	e86a                	sd	s10,16(sp)
  4002f6:	1880                	addi	s0,sp,112
  4002f8:	8caa                	mv	s9,a0
  4002fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  4002fc:	892a                	mv	s2,a0
  4002fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400300:	f9f40b13          	addi	s6,s0,-97
  400304:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400306:	4ba9                	li	s7,10
  400308:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  40030a:	8d26                	mv	s10,s1
  40030c:	0014899b          	addiw	s3,s1,1
  400310:	84ce                	mv	s1,s3
  400312:	0349d563          	bge	s3,s4,40033c <gets+0x60>
    cc = read(0, &c, 1);
  400316:	8656                	mv	a2,s5
  400318:	85da                	mv	a1,s6
  40031a:	4501                	li	a0,0
  40031c:	198000ef          	jal	4004b4 <read>
    if(cc < 1)
  400320:	00a05e63          	blez	a0,40033c <gets+0x60>
    buf[i++] = c;
  400324:	f9f44783          	lbu	a5,-97(s0)
  400328:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  40032c:	01778763          	beq	a5,s7,40033a <gets+0x5e>
  400330:	0905                	addi	s2,s2,1
  400332:	fd879ce3          	bne	a5,s8,40030a <gets+0x2e>
    buf[i++] = c;
  400336:	8d4e                	mv	s10,s3
  400338:	a011                	j	40033c <gets+0x60>
  40033a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  40033c:	9d66                	add	s10,s10,s9
  40033e:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400342:	8566                	mv	a0,s9
  400344:	70a6                	ld	ra,104(sp)
  400346:	7406                	ld	s0,96(sp)
  400348:	64e6                	ld	s1,88(sp)
  40034a:	6946                	ld	s2,80(sp)
  40034c:	69a6                	ld	s3,72(sp)
  40034e:	6a06                	ld	s4,64(sp)
  400350:	7ae2                	ld	s5,56(sp)
  400352:	7b42                	ld	s6,48(sp)
  400354:	7ba2                	ld	s7,40(sp)
  400356:	7c02                	ld	s8,32(sp)
  400358:	6ce2                	ld	s9,24(sp)
  40035a:	6d42                	ld	s10,16(sp)
  40035c:	6165                	addi	sp,sp,112
  40035e:	8082                	ret

0000000000400360 <stat>:

int
stat(const char *n, struct stat *st)
{
  400360:	1101                	addi	sp,sp,-32
  400362:	ec06                	sd	ra,24(sp)
  400364:	e822                	sd	s0,16(sp)
  400366:	e04a                	sd	s2,0(sp)
  400368:	1000                	addi	s0,sp,32
  40036a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  40036c:	4581                	li	a1,0
  40036e:	16e000ef          	jal	4004dc <open>
  if(fd < 0)
  400372:	02054263          	bltz	a0,400396 <stat+0x36>
  400376:	e426                	sd	s1,8(sp)
  400378:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  40037a:	85ca                	mv	a1,s2
  40037c:	178000ef          	jal	4004f4 <fstat>
  400380:	892a                	mv	s2,a0
  close(fd);
  400382:	8526                	mv	a0,s1
  400384:	140000ef          	jal	4004c4 <close>
  return r;
  400388:	64a2                	ld	s1,8(sp)
}
  40038a:	854a                	mv	a0,s2
  40038c:	60e2                	ld	ra,24(sp)
  40038e:	6442                	ld	s0,16(sp)
  400390:	6902                	ld	s2,0(sp)
  400392:	6105                	addi	sp,sp,32
  400394:	8082                	ret
    return -1;
  400396:	597d                	li	s2,-1
  400398:	bfcd                	j	40038a <stat+0x2a>

000000000040039a <atoi>:

int
atoi(const char *s)
{
  40039a:	1141                	addi	sp,sp,-16
  40039c:	e406                	sd	ra,8(sp)
  40039e:	e022                	sd	s0,0(sp)
  4003a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  4003a2:	00054683          	lbu	a3,0(a0)
  4003a6:	fd06879b          	addiw	a5,a3,-48
  4003aa:	0ff7f793          	zext.b	a5,a5
  4003ae:	4625                	li	a2,9
  4003b0:	02f66963          	bltu	a2,a5,4003e2 <atoi+0x48>
  4003b4:	872a                	mv	a4,a0
  n = 0;
  4003b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  4003b8:	0705                	addi	a4,a4,1
  4003ba:	0025179b          	slliw	a5,a0,0x2
  4003be:	9fa9                	addw	a5,a5,a0
  4003c0:	0017979b          	slliw	a5,a5,0x1
  4003c4:	9fb5                	addw	a5,a5,a3
  4003c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  4003ca:	00074683          	lbu	a3,0(a4)
  4003ce:	fd06879b          	addiw	a5,a3,-48
  4003d2:	0ff7f793          	zext.b	a5,a5
  4003d6:	fef671e3          	bgeu	a2,a5,4003b8 <atoi+0x1e>
  return n;
}
  4003da:	60a2                	ld	ra,8(sp)
  4003dc:	6402                	ld	s0,0(sp)
  4003de:	0141                	addi	sp,sp,16
  4003e0:	8082                	ret
  n = 0;
  4003e2:	4501                	li	a0,0
  4003e4:	bfdd                	j	4003da <atoi+0x40>

00000000004003e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  4003e6:	1141                	addi	sp,sp,-16
  4003e8:	e406                	sd	ra,8(sp)
  4003ea:	e022                	sd	s0,0(sp)
  4003ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  4003ee:	02b57563          	bgeu	a0,a1,400418 <memmove+0x32>
    while(n-- > 0)
  4003f2:	00c05f63          	blez	a2,400410 <memmove+0x2a>
  4003f6:	1602                	slli	a2,a2,0x20
  4003f8:	9201                	srli	a2,a2,0x20
  4003fa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  4003fe:	872a                	mv	a4,a0
      *dst++ = *src++;
  400400:	0585                	addi	a1,a1,1
  400402:	0705                	addi	a4,a4,1
  400404:	fff5c683          	lbu	a3,-1(a1)
  400408:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  40040c:	fee79ae3          	bne	a5,a4,400400 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400410:	60a2                	ld	ra,8(sp)
  400412:	6402                	ld	s0,0(sp)
  400414:	0141                	addi	sp,sp,16
  400416:	8082                	ret
    dst += n;
  400418:	00c50733          	add	a4,a0,a2
    src += n;
  40041c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  40041e:	fec059e3          	blez	a2,400410 <memmove+0x2a>
  400422:	fff6079b          	addiw	a5,a2,-1
  400426:	1782                	slli	a5,a5,0x20
  400428:	9381                	srli	a5,a5,0x20
  40042a:	fff7c793          	not	a5,a5
  40042e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400430:	15fd                	addi	a1,a1,-1
  400432:	177d                	addi	a4,a4,-1
  400434:	0005c683          	lbu	a3,0(a1)
  400438:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  40043c:	fef71ae3          	bne	a4,a5,400430 <memmove+0x4a>
  400440:	bfc1                	j	400410 <memmove+0x2a>

0000000000400442 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400442:	1141                	addi	sp,sp,-16
  400444:	e406                	sd	ra,8(sp)
  400446:	e022                	sd	s0,0(sp)
  400448:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  40044a:	ca0d                	beqz	a2,40047c <memcmp+0x3a>
  40044c:	fff6069b          	addiw	a3,a2,-1
  400450:	1682                	slli	a3,a3,0x20
  400452:	9281                	srli	a3,a3,0x20
  400454:	0685                	addi	a3,a3,1
  400456:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  400458:	00054783          	lbu	a5,0(a0)
  40045c:	0005c703          	lbu	a4,0(a1)
  400460:	00e79863          	bne	a5,a4,400470 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  400464:	0505                	addi	a0,a0,1
    p2++;
  400466:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  400468:	fed518e3          	bne	a0,a3,400458 <memcmp+0x16>
  }
  return 0;
  40046c:	4501                	li	a0,0
  40046e:	a019                	j	400474 <memcmp+0x32>
      return *p1 - *p2;
  400470:	40e7853b          	subw	a0,a5,a4
}
  400474:	60a2                	ld	ra,8(sp)
  400476:	6402                	ld	s0,0(sp)
  400478:	0141                	addi	sp,sp,16
  40047a:	8082                	ret
  return 0;
  40047c:	4501                	li	a0,0
  40047e:	bfdd                	j	400474 <memcmp+0x32>

0000000000400480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  400480:	1141                	addi	sp,sp,-16
  400482:	e406                	sd	ra,8(sp)
  400484:	e022                	sd	s0,0(sp)
  400486:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400488:	f5fff0ef          	jal	4003e6 <memmove>
}
  40048c:	60a2                	ld	ra,8(sp)
  40048e:	6402                	ld	s0,0(sp)
  400490:	0141                	addi	sp,sp,16
  400492:	8082                	ret

0000000000400494 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  400494:	4885                	li	a7,1
 ecall
  400496:	00000073          	ecall
 ret
  40049a:	8082                	ret

000000000040049c <exit>:
.global exit
exit:
 li a7, SYS_exit
  40049c:	4889                	li	a7,2
 ecall
  40049e:	00000073          	ecall
 ret
  4004a2:	8082                	ret

00000000004004a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
  4004a4:	488d                	li	a7,3
 ecall
  4004a6:	00000073          	ecall
 ret
  4004aa:	8082                	ret

00000000004004ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  4004ac:	4891                	li	a7,4
 ecall
  4004ae:	00000073          	ecall
 ret
  4004b2:	8082                	ret

00000000004004b4 <read>:
.global read
read:
 li a7, SYS_read
  4004b4:	4895                	li	a7,5
 ecall
  4004b6:	00000073          	ecall
 ret
  4004ba:	8082                	ret

00000000004004bc <write>:
.global write
write:
 li a7, SYS_write
  4004bc:	48c1                	li	a7,16
 ecall
  4004be:	00000073          	ecall
 ret
  4004c2:	8082                	ret

00000000004004c4 <close>:
.global close
close:
 li a7, SYS_close
  4004c4:	48d5                	li	a7,21
 ecall
  4004c6:	00000073          	ecall
 ret
  4004ca:	8082                	ret

00000000004004cc <kill>:
.global kill
kill:
 li a7, SYS_kill
  4004cc:	4899                	li	a7,6
 ecall
  4004ce:	00000073          	ecall
 ret
  4004d2:	8082                	ret

00000000004004d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
  4004d4:	489d                	li	a7,7
 ecall
  4004d6:	00000073          	ecall
 ret
  4004da:	8082                	ret

00000000004004dc <open>:
.global open
open:
 li a7, SYS_open
  4004dc:	48bd                	li	a7,15
 ecall
  4004de:	00000073          	ecall
 ret
  4004e2:	8082                	ret

00000000004004e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  4004e4:	48c5                	li	a7,17
 ecall
  4004e6:	00000073          	ecall
 ret
  4004ea:	8082                	ret

00000000004004ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  4004ec:	48c9                	li	a7,18
 ecall
  4004ee:	00000073          	ecall
 ret
  4004f2:	8082                	ret

00000000004004f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  4004f4:	48a1                	li	a7,8
 ecall
  4004f6:	00000073          	ecall
 ret
  4004fa:	8082                	ret

00000000004004fc <link>:
.global link
link:
 li a7, SYS_link
  4004fc:	48cd                	li	a7,19
 ecall
  4004fe:	00000073          	ecall
 ret
  400502:	8082                	ret

0000000000400504 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400504:	48d1                	li	a7,20
 ecall
  400506:	00000073          	ecall
 ret
  40050a:	8082                	ret

000000000040050c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  40050c:	48a5                	li	a7,9
 ecall
  40050e:	00000073          	ecall
 ret
  400512:	8082                	ret

0000000000400514 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400514:	48a9                	li	a7,10
 ecall
  400516:	00000073          	ecall
 ret
  40051a:	8082                	ret

000000000040051c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  40051c:	48ad                	li	a7,11
 ecall
  40051e:	00000073          	ecall
 ret
  400522:	8082                	ret

0000000000400524 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  400524:	48b1                	li	a7,12
 ecall
  400526:	00000073          	ecall
 ret
  40052a:	8082                	ret

000000000040052c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  40052c:	48b5                	li	a7,13
 ecall
  40052e:	00000073          	ecall
 ret
  400532:	8082                	ret

0000000000400534 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  400534:	48b9                	li	a7,14
 ecall
  400536:	00000073          	ecall
 ret
  40053a:	8082                	ret

000000000040053c <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  40053c:	48d9                	li	a7,22
 ecall
  40053e:	00000073          	ecall
 ret
  400542:	8082                	ret

0000000000400544 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  400544:	48dd                	li	a7,23
 ecall
  400546:	00000073          	ecall
 ret
  40054a:	8082                	ret

000000000040054c <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  40054c:	48e1                	li	a7,24
 ecall
  40054e:	00000073          	ecall
 ret
  400552:	8082                	ret

0000000000400554 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  400554:	1101                	addi	sp,sp,-32
  400556:	ec06                	sd	ra,24(sp)
  400558:	e822                	sd	s0,16(sp)
  40055a:	1000                	addi	s0,sp,32
  40055c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  400560:	4605                	li	a2,1
  400562:	fef40593          	addi	a1,s0,-17
  400566:	f57ff0ef          	jal	4004bc <write>
}
  40056a:	60e2                	ld	ra,24(sp)
  40056c:	6442                	ld	s0,16(sp)
  40056e:	6105                	addi	sp,sp,32
  400570:	8082                	ret

0000000000400572 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  400572:	7139                	addi	sp,sp,-64
  400574:	fc06                	sd	ra,56(sp)
  400576:	f822                	sd	s0,48(sp)
  400578:	f426                	sd	s1,40(sp)
  40057a:	f04a                	sd	s2,32(sp)
  40057c:	ec4e                	sd	s3,24(sp)
  40057e:	0080                	addi	s0,sp,64
  400580:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  400582:	c299                	beqz	a3,400588 <printint+0x16>
  400584:	0605ce63          	bltz	a1,400600 <printint+0x8e>
  neg = 0;
  400588:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  40058a:	fc040313          	addi	t1,s0,-64
  neg = 0;
  40058e:	869a                	mv	a3,t1
  i = 0;
  400590:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  400592:	00000817          	auipc	a6,0x0
  400596:	61680813          	addi	a6,a6,1558 # 400ba8 <digits>
  40059a:	88be                	mv	a7,a5
  40059c:	0017851b          	addiw	a0,a5,1
  4005a0:	87aa                	mv	a5,a0
  4005a2:	02c5f73b          	remuw	a4,a1,a2
  4005a6:	1702                	slli	a4,a4,0x20
  4005a8:	9301                	srli	a4,a4,0x20
  4005aa:	9742                	add	a4,a4,a6
  4005ac:	00074703          	lbu	a4,0(a4)
  4005b0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  4005b4:	872e                	mv	a4,a1
  4005b6:	02c5d5bb          	divuw	a1,a1,a2
  4005ba:	0685                	addi	a3,a3,1
  4005bc:	fcc77fe3          	bgeu	a4,a2,40059a <printint+0x28>
  if(neg)
  4005c0:	000e0c63          	beqz	t3,4005d8 <printint+0x66>
    buf[i++] = '-';
  4005c4:	fd050793          	addi	a5,a0,-48
  4005c8:	00878533          	add	a0,a5,s0
  4005cc:	02d00793          	li	a5,45
  4005d0:	fef50823          	sb	a5,-16(a0)
  4005d4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  4005d8:	fff7899b          	addiw	s3,a5,-1
  4005dc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  4005e0:	fff4c583          	lbu	a1,-1(s1)
  4005e4:	854a                	mv	a0,s2
  4005e6:	f6fff0ef          	jal	400554 <putc>
  while(--i >= 0)
  4005ea:	39fd                	addiw	s3,s3,-1
  4005ec:	14fd                	addi	s1,s1,-1
  4005ee:	fe09d9e3          	bgez	s3,4005e0 <printint+0x6e>
}
  4005f2:	70e2                	ld	ra,56(sp)
  4005f4:	7442                	ld	s0,48(sp)
  4005f6:	74a2                	ld	s1,40(sp)
  4005f8:	7902                	ld	s2,32(sp)
  4005fa:	69e2                	ld	s3,24(sp)
  4005fc:	6121                	addi	sp,sp,64
  4005fe:	8082                	ret
    x = -xx;
  400600:	40b005bb          	negw	a1,a1
    neg = 1;
  400604:	4e05                	li	t3,1
    x = -xx;
  400606:	b751                	j	40058a <printint+0x18>

0000000000400608 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400608:	711d                	addi	sp,sp,-96
  40060a:	ec86                	sd	ra,88(sp)
  40060c:	e8a2                	sd	s0,80(sp)
  40060e:	e4a6                	sd	s1,72(sp)
  400610:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400612:	0005c483          	lbu	s1,0(a1)
  400616:	26048663          	beqz	s1,400882 <vprintf+0x27a>
  40061a:	e0ca                	sd	s2,64(sp)
  40061c:	fc4e                	sd	s3,56(sp)
  40061e:	f852                	sd	s4,48(sp)
  400620:	f456                	sd	s5,40(sp)
  400622:	f05a                	sd	s6,32(sp)
  400624:	ec5e                	sd	s7,24(sp)
  400626:	e862                	sd	s8,16(sp)
  400628:	e466                	sd	s9,8(sp)
  40062a:	8b2a                	mv	s6,a0
  40062c:	8a2e                	mv	s4,a1
  40062e:	8bb2                	mv	s7,a2
  state = 0;
  400630:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400632:	4901                	li	s2,0
  400634:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  400636:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  40063a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  40063e:	06c00c93          	li	s9,108
  400642:	a00d                	j	400664 <vprintf+0x5c>
        putc(fd, c0);
  400644:	85a6                	mv	a1,s1
  400646:	855a                	mv	a0,s6
  400648:	f0dff0ef          	jal	400554 <putc>
  40064c:	a019                	j	400652 <vprintf+0x4a>
    } else if(state == '%'){
  40064e:	03598363          	beq	s3,s5,400674 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  400652:	0019079b          	addiw	a5,s2,1
  400656:	893e                	mv	s2,a5
  400658:	873e                	mv	a4,a5
  40065a:	97d2                	add	a5,a5,s4
  40065c:	0007c483          	lbu	s1,0(a5)
  400660:	20048963          	beqz	s1,400872 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  400664:	0004879b          	sext.w	a5,s1
    if(state == 0){
  400668:	fe0993e3          	bnez	s3,40064e <vprintf+0x46>
      if(c0 == '%'){
  40066c:	fd579ce3          	bne	a5,s5,400644 <vprintf+0x3c>
        state = '%';
  400670:	89be                	mv	s3,a5
  400672:	b7c5                	j	400652 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  400674:	00ea06b3          	add	a3,s4,a4
  400678:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  40067c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  40067e:	c681                	beqz	a3,400686 <vprintf+0x7e>
  400680:	9752                	add	a4,a4,s4
  400682:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  400686:	03878e63          	beq	a5,s8,4006c2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  40068a:	05978863          	beq	a5,s9,4006da <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  40068e:	07500713          	li	a4,117
  400692:	0ee78263          	beq	a5,a4,400776 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400696:	07800713          	li	a4,120
  40069a:	12e78463          	beq	a5,a4,4007c2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  40069e:	07000713          	li	a4,112
  4006a2:	14e78963          	beq	a5,a4,4007f4 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  4006a6:	07300713          	li	a4,115
  4006aa:	18e78863          	beq	a5,a4,40083a <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  4006ae:	02500713          	li	a4,37
  4006b2:	04e79463          	bne	a5,a4,4006fa <vprintf+0xf2>
        putc(fd, '%');
  4006b6:	85ba                	mv	a1,a4
  4006b8:	855a                	mv	a0,s6
  4006ba:	e9bff0ef          	jal	400554 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  4006be:	4981                	li	s3,0
  4006c0:	bf49                	j	400652 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  4006c2:	008b8493          	addi	s1,s7,8
  4006c6:	4685                	li	a3,1
  4006c8:	4629                	li	a2,10
  4006ca:	000ba583          	lw	a1,0(s7)
  4006ce:	855a                	mv	a0,s6
  4006d0:	ea3ff0ef          	jal	400572 <printint>
  4006d4:	8ba6                	mv	s7,s1
      state = 0;
  4006d6:	4981                	li	s3,0
  4006d8:	bfad                	j	400652 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  4006da:	06400793          	li	a5,100
  4006de:	02f68963          	beq	a3,a5,400710 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4006e2:	06c00793          	li	a5,108
  4006e6:	04f68263          	beq	a3,a5,40072a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  4006ea:	07500793          	li	a5,117
  4006ee:	0af68063          	beq	a3,a5,40078e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  4006f2:	07800793          	li	a5,120
  4006f6:	0ef68263          	beq	a3,a5,4007da <vprintf+0x1d2>
        putc(fd, '%');
  4006fa:	02500593          	li	a1,37
  4006fe:	855a                	mv	a0,s6
  400700:	e55ff0ef          	jal	400554 <putc>
        putc(fd, c0);
  400704:	85a6                	mv	a1,s1
  400706:	855a                	mv	a0,s6
  400708:	e4dff0ef          	jal	400554 <putc>
      state = 0;
  40070c:	4981                	li	s3,0
  40070e:	b791                	j	400652 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400710:	008b8493          	addi	s1,s7,8
  400714:	4685                	li	a3,1
  400716:	4629                	li	a2,10
  400718:	000ba583          	lw	a1,0(s7)
  40071c:	855a                	mv	a0,s6
  40071e:	e55ff0ef          	jal	400572 <printint>
        i += 1;
  400722:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  400724:	8ba6                	mv	s7,s1
      state = 0;
  400726:	4981                	li	s3,0
        i += 1;
  400728:	b72d                	j	400652 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  40072a:	06400793          	li	a5,100
  40072e:	02f60763          	beq	a2,a5,40075c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400732:	07500793          	li	a5,117
  400736:	06f60963          	beq	a2,a5,4007a8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  40073a:	07800793          	li	a5,120
  40073e:	faf61ee3          	bne	a2,a5,4006fa <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400742:	008b8493          	addi	s1,s7,8
  400746:	4681                	li	a3,0
  400748:	4641                	li	a2,16
  40074a:	000ba583          	lw	a1,0(s7)
  40074e:	855a                	mv	a0,s6
  400750:	e23ff0ef          	jal	400572 <printint>
        i += 2;
  400754:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  400756:	8ba6                	mv	s7,s1
      state = 0;
  400758:	4981                	li	s3,0
        i += 2;
  40075a:	bde5                	j	400652 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  40075c:	008b8493          	addi	s1,s7,8
  400760:	4685                	li	a3,1
  400762:	4629                	li	a2,10
  400764:	000ba583          	lw	a1,0(s7)
  400768:	855a                	mv	a0,s6
  40076a:	e09ff0ef          	jal	400572 <printint>
        i += 2;
  40076e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  400770:	8ba6                	mv	s7,s1
      state = 0;
  400772:	4981                	li	s3,0
        i += 2;
  400774:	bdf9                	j	400652 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  400776:	008b8493          	addi	s1,s7,8
  40077a:	4681                	li	a3,0
  40077c:	4629                	li	a2,10
  40077e:	000ba583          	lw	a1,0(s7)
  400782:	855a                	mv	a0,s6
  400784:	defff0ef          	jal	400572 <printint>
  400788:	8ba6                	mv	s7,s1
      state = 0;
  40078a:	4981                	li	s3,0
  40078c:	b5d9                	j	400652 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  40078e:	008b8493          	addi	s1,s7,8
  400792:	4681                	li	a3,0
  400794:	4629                	li	a2,10
  400796:	000ba583          	lw	a1,0(s7)
  40079a:	855a                	mv	a0,s6
  40079c:	dd7ff0ef          	jal	400572 <printint>
        i += 1;
  4007a0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  4007a2:	8ba6                	mv	s7,s1
      state = 0;
  4007a4:	4981                	li	s3,0
        i += 1;
  4007a6:	b575                	j	400652 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4007a8:	008b8493          	addi	s1,s7,8
  4007ac:	4681                	li	a3,0
  4007ae:	4629                	li	a2,10
  4007b0:	000ba583          	lw	a1,0(s7)
  4007b4:	855a                	mv	a0,s6
  4007b6:	dbdff0ef          	jal	400572 <printint>
        i += 2;
  4007ba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  4007bc:	8ba6                	mv	s7,s1
      state = 0;
  4007be:	4981                	li	s3,0
        i += 2;
  4007c0:	bd49                	j	400652 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  4007c2:	008b8493          	addi	s1,s7,8
  4007c6:	4681                	li	a3,0
  4007c8:	4641                	li	a2,16
  4007ca:	000ba583          	lw	a1,0(s7)
  4007ce:	855a                	mv	a0,s6
  4007d0:	da3ff0ef          	jal	400572 <printint>
  4007d4:	8ba6                	mv	s7,s1
      state = 0;
  4007d6:	4981                	li	s3,0
  4007d8:	bdad                	j	400652 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4007da:	008b8493          	addi	s1,s7,8
  4007de:	4681                	li	a3,0
  4007e0:	4641                	li	a2,16
  4007e2:	000ba583          	lw	a1,0(s7)
  4007e6:	855a                	mv	a0,s6
  4007e8:	d8bff0ef          	jal	400572 <printint>
        i += 1;
  4007ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  4007ee:	8ba6                	mv	s7,s1
      state = 0;
  4007f0:	4981                	li	s3,0
        i += 1;
  4007f2:	b585                	j	400652 <vprintf+0x4a>
  4007f4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  4007f6:	008b8d13          	addi	s10,s7,8
  4007fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  4007fe:	03000593          	li	a1,48
  400802:	855a                	mv	a0,s6
  400804:	d51ff0ef          	jal	400554 <putc>
  putc(fd, 'x');
  400808:	07800593          	li	a1,120
  40080c:	855a                	mv	a0,s6
  40080e:	d47ff0ef          	jal	400554 <putc>
  400812:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400814:	00000b97          	auipc	s7,0x0
  400818:	394b8b93          	addi	s7,s7,916 # 400ba8 <digits>
  40081c:	03c9d793          	srli	a5,s3,0x3c
  400820:	97de                	add	a5,a5,s7
  400822:	0007c583          	lbu	a1,0(a5)
  400826:	855a                	mv	a0,s6
  400828:	d2dff0ef          	jal	400554 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  40082c:	0992                	slli	s3,s3,0x4
  40082e:	34fd                	addiw	s1,s1,-1
  400830:	f4f5                	bnez	s1,40081c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400832:	8bea                	mv	s7,s10
      state = 0;
  400834:	4981                	li	s3,0
  400836:	6d02                	ld	s10,0(sp)
  400838:	bd29                	j	400652 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  40083a:	008b8993          	addi	s3,s7,8
  40083e:	000bb483          	ld	s1,0(s7)
  400842:	cc91                	beqz	s1,40085e <vprintf+0x256>
        for(; *s; s++)
  400844:	0004c583          	lbu	a1,0(s1)
  400848:	c195                	beqz	a1,40086c <vprintf+0x264>
          putc(fd, *s);
  40084a:	855a                	mv	a0,s6
  40084c:	d09ff0ef          	jal	400554 <putc>
        for(; *s; s++)
  400850:	0485                	addi	s1,s1,1
  400852:	0004c583          	lbu	a1,0(s1)
  400856:	f9f5                	bnez	a1,40084a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400858:	8bce                	mv	s7,s3
      state = 0;
  40085a:	4981                	li	s3,0
  40085c:	bbdd                	j	400652 <vprintf+0x4a>
          s = "(null)";
  40085e:	00000497          	auipc	s1,0x0
  400862:	34248493          	addi	s1,s1,834 # 400ba0 <malloc+0x22e>
        for(; *s; s++)
  400866:	02800593          	li	a1,40
  40086a:	b7c5                	j	40084a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  40086c:	8bce                	mv	s7,s3
      state = 0;
  40086e:	4981                	li	s3,0
  400870:	b3cd                	j	400652 <vprintf+0x4a>
  400872:	6906                	ld	s2,64(sp)
  400874:	79e2                	ld	s3,56(sp)
  400876:	7a42                	ld	s4,48(sp)
  400878:	7aa2                	ld	s5,40(sp)
  40087a:	7b02                	ld	s6,32(sp)
  40087c:	6be2                	ld	s7,24(sp)
  40087e:	6c42                	ld	s8,16(sp)
  400880:	6ca2                	ld	s9,8(sp)
    }
  }
}
  400882:	60e6                	ld	ra,88(sp)
  400884:	6446                	ld	s0,80(sp)
  400886:	64a6                	ld	s1,72(sp)
  400888:	6125                	addi	sp,sp,96
  40088a:	8082                	ret

000000000040088c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  40088c:	715d                	addi	sp,sp,-80
  40088e:	ec06                	sd	ra,24(sp)
  400890:	e822                	sd	s0,16(sp)
  400892:	1000                	addi	s0,sp,32
  400894:	e010                	sd	a2,0(s0)
  400896:	e414                	sd	a3,8(s0)
  400898:	e818                	sd	a4,16(s0)
  40089a:	ec1c                	sd	a5,24(s0)
  40089c:	03043023          	sd	a6,32(s0)
  4008a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  4008a4:	8622                	mv	a2,s0
  4008a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  4008aa:	d5fff0ef          	jal	400608 <vprintf>
  return 0;
}
  4008ae:	4501                	li	a0,0
  4008b0:	60e2                	ld	ra,24(sp)
  4008b2:	6442                	ld	s0,16(sp)
  4008b4:	6161                	addi	sp,sp,80
  4008b6:	8082                	ret

00000000004008b8 <printf>:

int
printf(const char *fmt, ...)
{
  4008b8:	711d                	addi	sp,sp,-96
  4008ba:	ec06                	sd	ra,24(sp)
  4008bc:	e822                	sd	s0,16(sp)
  4008be:	1000                	addi	s0,sp,32
  4008c0:	e40c                	sd	a1,8(s0)
  4008c2:	e810                	sd	a2,16(s0)
  4008c4:	ec14                	sd	a3,24(s0)
  4008c6:	f018                	sd	a4,32(s0)
  4008c8:	f41c                	sd	a5,40(s0)
  4008ca:	03043823          	sd	a6,48(s0)
  4008ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  4008d2:	00840613          	addi	a2,s0,8
  4008d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  4008da:	85aa                	mv	a1,a0
  4008dc:	4505                	li	a0,1
  4008de:	d2bff0ef          	jal	400608 <vprintf>
  return 0;
}
  4008e2:	4501                	li	a0,0
  4008e4:	60e2                	ld	ra,24(sp)
  4008e6:	6442                	ld	s0,16(sp)
  4008e8:	6125                	addi	sp,sp,96
  4008ea:	8082                	ret

00000000004008ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  4008ec:	1141                	addi	sp,sp,-16
  4008ee:	e406                	sd	ra,8(sp)
  4008f0:	e022                	sd	s0,0(sp)
  4008f2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  4008f4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4008f8:	00001797          	auipc	a5,0x1
  4008fc:	7107b783          	ld	a5,1808(a5) # 402008 <freep>
  400900:	a02d                	j	40092a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400902:	4618                	lw	a4,8(a2)
  400904:	9f2d                	addw	a4,a4,a1
  400906:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  40090a:	6398                	ld	a4,0(a5)
  40090c:	6310                	ld	a2,0(a4)
  40090e:	a83d                	j	40094c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400910:	ff852703          	lw	a4,-8(a0)
  400914:	9f31                	addw	a4,a4,a2
  400916:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400918:	ff053683          	ld	a3,-16(a0)
  40091c:	a091                	j	400960 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40091e:	6398                	ld	a4,0(a5)
  400920:	00e7e463          	bltu	a5,a4,400928 <free+0x3c>
  400924:	00e6ea63          	bltu	a3,a4,400938 <free+0x4c>
{
  400928:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40092a:	fed7fae3          	bgeu	a5,a3,40091e <free+0x32>
  40092e:	6398                	ld	a4,0(a5)
  400930:	00e6e463          	bltu	a3,a4,400938 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400934:	fee7eae3          	bltu	a5,a4,400928 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  400938:	ff852583          	lw	a1,-8(a0)
  40093c:	6390                	ld	a2,0(a5)
  40093e:	02059813          	slli	a6,a1,0x20
  400942:	01c85713          	srli	a4,a6,0x1c
  400946:	9736                	add	a4,a4,a3
  400948:	fae60de3          	beq	a2,a4,400902 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  40094c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  400950:	4790                	lw	a2,8(a5)
  400952:	02061593          	slli	a1,a2,0x20
  400956:	01c5d713          	srli	a4,a1,0x1c
  40095a:	973e                	add	a4,a4,a5
  40095c:	fae68ae3          	beq	a3,a4,400910 <free+0x24>
    p->s.ptr = bp->s.ptr;
  400960:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  400962:	00001717          	auipc	a4,0x1
  400966:	6af73323          	sd	a5,1702(a4) # 402008 <freep>
}
  40096a:	60a2                	ld	ra,8(sp)
  40096c:	6402                	ld	s0,0(sp)
  40096e:	0141                	addi	sp,sp,16
  400970:	8082                	ret

0000000000400972 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  400972:	7139                	addi	sp,sp,-64
  400974:	fc06                	sd	ra,56(sp)
  400976:	f822                	sd	s0,48(sp)
  400978:	f04a                	sd	s2,32(sp)
  40097a:	ec4e                	sd	s3,24(sp)
  40097c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  40097e:	02051993          	slli	s3,a0,0x20
  400982:	0209d993          	srli	s3,s3,0x20
  400986:	09bd                	addi	s3,s3,15
  400988:	0049d993          	srli	s3,s3,0x4
  40098c:	2985                	addiw	s3,s3,1
  40098e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  400990:	00001517          	auipc	a0,0x1
  400994:	67853503          	ld	a0,1656(a0) # 402008 <freep>
  400998:	c905                	beqz	a0,4009c8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  40099a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40099c:	4798                	lw	a4,8(a5)
  40099e:	09377663          	bgeu	a4,s3,400a2a <malloc+0xb8>
  4009a2:	f426                	sd	s1,40(sp)
  4009a4:	e852                	sd	s4,16(sp)
  4009a6:	e456                	sd	s5,8(sp)
  4009a8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  4009aa:	8a4e                	mv	s4,s3
  4009ac:	6705                	lui	a4,0x1
  4009ae:	00e9f363          	bgeu	s3,a4,4009b4 <malloc+0x42>
  4009b2:	6a05                	lui	s4,0x1
  4009b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  4009b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  4009bc:	00001497          	auipc	s1,0x1
  4009c0:	64c48493          	addi	s1,s1,1612 # 402008 <freep>
  if(p == (char*)-1)
  4009c4:	5afd                	li	s5,-1
  4009c6:	a83d                	j	400a04 <malloc+0x92>
  4009c8:	f426                	sd	s1,40(sp)
  4009ca:	e852                	sd	s4,16(sp)
  4009cc:	e456                	sd	s5,8(sp)
  4009ce:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  4009d0:	00001797          	auipc	a5,0x1
  4009d4:	64078793          	addi	a5,a5,1600 # 402010 <base>
  4009d8:	00001717          	auipc	a4,0x1
  4009dc:	62f73823          	sd	a5,1584(a4) # 402008 <freep>
  4009e0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  4009e2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  4009e6:	b7d1                	j	4009aa <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  4009e8:	6398                	ld	a4,0(a5)
  4009ea:	e118                	sd	a4,0(a0)
  4009ec:	a899                	j	400a42 <malloc+0xd0>
  hp->s.size = nu;
  4009ee:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  4009f2:	0541                	addi	a0,a0,16
  4009f4:	ef9ff0ef          	jal	4008ec <free>
  return freep;
  4009f8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  4009fa:	c125                	beqz	a0,400a5a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4009fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4009fe:	4798                	lw	a4,8(a5)
  400a00:	03277163          	bgeu	a4,s2,400a22 <malloc+0xb0>
    if(p == freep)
  400a04:	6098                	ld	a4,0(s1)
  400a06:	853e                	mv	a0,a5
  400a08:	fef71ae3          	bne	a4,a5,4009fc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400a0c:	8552                	mv	a0,s4
  400a0e:	b17ff0ef          	jal	400524 <sbrk>
  if(p == (char*)-1)
  400a12:	fd551ee3          	bne	a0,s5,4009ee <malloc+0x7c>
        return 0;
  400a16:	4501                	li	a0,0
  400a18:	74a2                	ld	s1,40(sp)
  400a1a:	6a42                	ld	s4,16(sp)
  400a1c:	6aa2                	ld	s5,8(sp)
  400a1e:	6b02                	ld	s6,0(sp)
  400a20:	a03d                	j	400a4e <malloc+0xdc>
  400a22:	74a2                	ld	s1,40(sp)
  400a24:	6a42                	ld	s4,16(sp)
  400a26:	6aa2                	ld	s5,8(sp)
  400a28:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400a2a:	fae90fe3          	beq	s2,a4,4009e8 <malloc+0x76>
        p->s.size -= nunits;
  400a2e:	4137073b          	subw	a4,a4,s3
  400a32:	c798                	sw	a4,8(a5)
        p += p->s.size;
  400a34:	02071693          	slli	a3,a4,0x20
  400a38:	01c6d713          	srli	a4,a3,0x1c
  400a3c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  400a3e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400a42:	00001717          	auipc	a4,0x1
  400a46:	5ca73323          	sd	a0,1478(a4) # 402008 <freep>
      return (void*)(p + 1);
  400a4a:	01078513          	addi	a0,a5,16
  }
}
  400a4e:	70e2                	ld	ra,56(sp)
  400a50:	7442                	ld	s0,48(sp)
  400a52:	7902                	ld	s2,32(sp)
  400a54:	69e2                	ld	s3,24(sp)
  400a56:	6121                	addi	sp,sp,64
  400a58:	8082                	ret
  400a5a:	74a2                	ld	s1,40(sp)
  400a5c:	6a42                	ld	s4,16(sp)
  400a5e:	6aa2                	ld	s5,8(sp)
  400a60:	6b02                	ld	s6,0(sp)
  400a62:	b7f5                	j	400a4e <malloc+0xdc>
