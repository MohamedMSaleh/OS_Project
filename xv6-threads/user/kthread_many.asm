
user/_kthread_many:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <thread_func>:
#define NTHREADS 4
#define STACK_SIZE 4096
#define TIMEOUT_TICKS 10000000

volatile int shared = 0;
void thread_func(void) {
  400000:	1141                	addi	sp,sp,-16
  400002:	e406                	sd	ra,8(sp)
  400004:	e022                	sd	s0,0(sp)
  400006:	0800                	addi	s0,sp,16
  400008:	3e800793          	li	a5,1000
  for (int i = 0; i < 1000; i++) {
    __sync_fetch_and_add(&shared, 1);
  40000c:	00001717          	auipc	a4,0x1
  400010:	ff470713          	addi	a4,a4,-12 # 401000 <shared>
  400014:	4685                	li	a3,1
  400016:	06d7202f          	amoadd.w.aqrl	zero,a3,(a4)
  for (int i = 0; i < 1000; i++) {
  40001a:	37fd                	addiw	a5,a5,-1
  40001c:	ffed                	bnez	a5,400016 <thread_func+0x16>
  }
  kthread_exit(0);
  40001e:	4501                	li	a0,0
  400020:	48e000ef          	jal	4004ae <kthread_exit>

0000000000400024 <main>:
}

int main() {
  400024:	7171                	addi	sp,sp,-176
  400026:	f506                	sd	ra,168(sp)
  400028:	f122                	sd	s0,160(sp)
  40002a:	ed26                	sd	s1,152(sp)
  40002c:	e94a                	sd	s2,144(sp)
  40002e:	e54e                	sd	s3,136(sp)
  400030:	e152                	sd	s4,128(sp)
  400032:	fcd6                	sd	s5,120(sp)
  400034:	f8da                	sd	s6,112(sp)
  400036:	f4de                	sd	s7,104(sp)
  400038:	f0e2                	sd	s8,96(sp)
  40003a:	ece6                	sd	s9,88(sp)
  40003c:	e8ea                	sd	s10,80(sp)
  40003e:	e4ee                	sd	s11,72(sp)
  400040:	1900                	addi	s0,sp,176
  printf("[main] Starting kthread_many\n");
  400042:	00001517          	auipc	a0,0x1
  400046:	98e50513          	addi	a0,a0,-1650 # 4009d0 <malloc+0xf4>
  40004a:	7d8000ef          	jal	400822 <printf>
  int tids[NTHREADS];
  void *stacks[NTHREADS];
  for (int i = 0; i < NTHREADS; i++) {
  40004e:	f6040c93          	addi	s9,s0,-160
  400052:	f8040913          	addi	s2,s0,-128
  printf("[main] Starting kthread_many\n");
  400056:	8aca                	mv	s5,s2
  400058:	8a66                	mv	s4,s9
  for (int i = 0; i < NTHREADS; i++) {
  40005a:	4981                	li	s3,0
    void *stack = malloc(STACK_SIZE);
  40005c:	6b05                	lui	s6,0x1
    stacks[i] = stack;
    tids[i] = kthread_create(thread_func, stack, STACK_SIZE);
  40005e:	00000d17          	auipc	s10,0x0
  400062:	fa2d0d13          	addi	s10,s10,-94 # 400000 <thread_func>
    printf("[main] kthread_create returned tid=%d for i=%d\n", tids[i], i);
  400066:	00001c17          	auipc	s8,0x1
  40006a:	98ac0c13          	addi	s8,s8,-1654 # 4009f0 <malloc+0x114>
    if (tids[i] < 0) printf("Failed to create thread %d\n", i);
  40006e:	00001d97          	auipc	s11,0x1
  400072:	9b2d8d93          	addi	s11,s11,-1614 # 400a20 <malloc+0x144>
  for (int i = 0; i < NTHREADS; i++) {
  400076:	4b91                	li	s7,4
  400078:	a031                	j	400084 <main+0x60>
  40007a:	2985                	addiw	s3,s3,1
  40007c:	0a21                	addi	s4,s4,8
  40007e:	0a91                	addi	s5,s5,4
  400080:	03798b63          	beq	s3,s7,4000b6 <main+0x92>
    void *stack = malloc(STACK_SIZE);
  400084:	855a                	mv	a0,s6
  400086:	057000ef          	jal	4008dc <malloc>
  40008a:	85aa                	mv	a1,a0
    stacks[i] = stack;
  40008c:	00aa3023          	sd	a0,0(s4)
    tids[i] = kthread_create(thread_func, stack, STACK_SIZE);
  400090:	865a                	mv	a2,s6
  400092:	856a                	mv	a0,s10
  400094:	412000ef          	jal	4004a6 <kthread_create>
  400098:	84aa                	mv	s1,a0
  40009a:	00aaa023          	sw	a0,0(s5)
    printf("[main] kthread_create returned tid=%d for i=%d\n", tids[i], i);
  40009e:	864e                	mv	a2,s3
  4000a0:	85aa                	mv	a1,a0
  4000a2:	8562                	mv	a0,s8
  4000a4:	77e000ef          	jal	400822 <printf>
    if (tids[i] < 0) printf("Failed to create thread %d\n", i);
  4000a8:	fc04d9e3          	bgez	s1,40007a <main+0x56>
  4000ac:	85ce                	mv	a1,s3
  4000ae:	856e                	mv	a0,s11
  4000b0:	772000ef          	jal	400822 <printf>
  4000b4:	b7d9                	j	40007a <main+0x56>
  }
  for (int i = 0; i < NTHREADS; i++) {
  4000b6:	4b81                	li	s7,0
    int status = 0;
    int ret = -1;
    int ticks = 0;
    while (ticks < TIMEOUT_TICKS) {
      ret = kthread_join(tids[i], &status);
  4000b8:	f5c40993          	addi	s3,s0,-164
      if (ret == 0) break;
      ticks++;
      if (ticks % 1000000 == 0) printf("[main] Waiting for thread %d to join...\n", i);
  4000bc:	431beb37          	lui	s6,0x431be
  4000c0:	e83b0b13          	addi	s6,s6,-381 # 431bde83 <base+0x42dbce73>
  4000c4:	000f4ab7          	lui	s5,0xf4
  4000c8:	240a8a9b          	addiw	s5,s5,576 # f4240 <thread_func-0x30bdc0>
    while (ticks < TIMEOUT_TICKS) {
  4000cc:	00989a37          	lui	s4,0x989
  4000d0:	680a0a13          	addi	s4,s4,1664 # 989680 <base+0x588670>
  4000d4:	a051                	j	400158 <main+0x134>
  4000d6:	07448063          	beq	s1,s4,400136 <main+0x112>
      ret = kthread_join(tids[i], &status);
  4000da:	85ce                	mv	a1,s3
  4000dc:	00092503          	lw	a0,0(s2)
  4000e0:	3d6000ef          	jal	4004b6 <kthread_join>
      if (ret == 0) break;
  4000e4:	c125                	beqz	a0,400144 <main+0x120>
      ticks++;
  4000e6:	0014871b          	addiw	a4,s1,1
  4000ea:	84ba                	mv	s1,a4
      if (ticks % 1000000 == 0) printf("[main] Waiting for thread %d to join...\n", i);
  4000ec:	036707b3          	mul	a5,a4,s6
  4000f0:	97c9                	srai	a5,a5,0x32
  4000f2:	41f7569b          	sraiw	a3,a4,0x1f
  4000f6:	9f95                	subw	a5,a5,a3
  4000f8:	02fa87bb          	mulw	a5,s5,a5
  4000fc:	9f1d                	subw	a4,a4,a5
  4000fe:	ff61                	bnez	a4,4000d6 <main+0xb2>
  400100:	85de                	mv	a1,s7
  400102:	8562                	mv	a0,s8
  400104:	71e000ef          	jal	400822 <printf>
  400108:	b7f9                	j	4000d6 <main+0xb2>
    }
    if (ret != 0) printf("[main] kthread_join failed or timed out for thread %d\n", i);
    free(stacks[i]);
  }
  printf("[main] All threads joined. shared=%d (should be %d)\n", shared, NTHREADS*1000);
  40010a:	6605                	lui	a2,0x1
  40010c:	fa060613          	addi	a2,a2,-96 # fa0 <thread_func-0x3ff060>
  400110:	00001597          	auipc	a1,0x1
  400114:	ef05a583          	lw	a1,-272(a1) # 401000 <shared>
  400118:	00001517          	auipc	a0,0x1
  40011c:	95850513          	addi	a0,a0,-1704 # 400a70 <malloc+0x194>
  400120:	702000ef          	jal	400822 <printf>
  printf("[main] Exiting kthread_many\n");
  400124:	00001517          	auipc	a0,0x1
  400128:	98450513          	addi	a0,a0,-1660 # 400aa8 <malloc+0x1cc>
  40012c:	6f6000ef          	jal	400822 <printf>
  exit(0);
  400130:	4501                	li	a0,0
  400132:	2d4000ef          	jal	400406 <exit>
    if (ret != 0) printf("[main] kthread_join failed or timed out for thread %d\n", i);
  400136:	85de                	mv	a1,s7
  400138:	00001517          	auipc	a0,0x1
  40013c:	99050513          	addi	a0,a0,-1648 # 400ac8 <malloc+0x1ec>
  400140:	6e2000ef          	jal	400822 <printf>
    free(stacks[i]);
  400144:	000cb503          	ld	a0,0(s9)
  400148:	70e000ef          	jal	400856 <free>
  for (int i = 0; i < NTHREADS; i++) {
  40014c:	2b85                	addiw	s7,s7,1
  40014e:	0ca1                	addi	s9,s9,8
  400150:	0911                	addi	s2,s2,4
  400152:	4791                	li	a5,4
  400154:	fafb8be3          	beq	s7,a5,40010a <main+0xe6>
    int status = 0;
  400158:	f4042e23          	sw	zero,-164(s0)
    int ticks = 0;
  40015c:	4481                	li	s1,0
      if (ticks % 1000000 == 0) printf("[main] Waiting for thread %d to join...\n", i);
  40015e:	00001c17          	auipc	s8,0x1
  400162:	8e2c0c13          	addi	s8,s8,-1822 # 400a40 <malloc+0x164>
  400166:	bf95                	j	4000da <main+0xb6>

0000000000400168 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  400168:	1141                	addi	sp,sp,-16
  40016a:	e406                	sd	ra,8(sp)
  40016c:	e022                	sd	s0,0(sp)
  40016e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  400170:	eb5ff0ef          	jal	400024 <main>
  exit(0);
  400174:	4501                	li	a0,0
  400176:	290000ef          	jal	400406 <exit>

000000000040017a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  40017a:	1141                	addi	sp,sp,-16
  40017c:	e406                	sd	ra,8(sp)
  40017e:	e022                	sd	s0,0(sp)
  400180:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400182:	87aa                	mv	a5,a0
  400184:	0585                	addi	a1,a1,1
  400186:	0785                	addi	a5,a5,1
  400188:	fff5c703          	lbu	a4,-1(a1)
  40018c:	fee78fa3          	sb	a4,-1(a5)
  400190:	fb75                	bnez	a4,400184 <strcpy+0xa>
    ;
  return os;
}
  400192:	60a2                	ld	ra,8(sp)
  400194:	6402                	ld	s0,0(sp)
  400196:	0141                	addi	sp,sp,16
  400198:	8082                	ret

000000000040019a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40019a:	1141                	addi	sp,sp,-16
  40019c:	e406                	sd	ra,8(sp)
  40019e:	e022                	sd	s0,0(sp)
  4001a0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4001a2:	00054783          	lbu	a5,0(a0)
  4001a6:	cb91                	beqz	a5,4001ba <strcmp+0x20>
  4001a8:	0005c703          	lbu	a4,0(a1)
  4001ac:	00f71763          	bne	a4,a5,4001ba <strcmp+0x20>
    p++, q++;
  4001b0:	0505                	addi	a0,a0,1
  4001b2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4001b4:	00054783          	lbu	a5,0(a0)
  4001b8:	fbe5                	bnez	a5,4001a8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4001ba:	0005c503          	lbu	a0,0(a1)
}
  4001be:	40a7853b          	subw	a0,a5,a0
  4001c2:	60a2                	ld	ra,8(sp)
  4001c4:	6402                	ld	s0,0(sp)
  4001c6:	0141                	addi	sp,sp,16
  4001c8:	8082                	ret

00000000004001ca <strlen>:

uint
strlen(const char *s)
{
  4001ca:	1141                	addi	sp,sp,-16
  4001cc:	e406                	sd	ra,8(sp)
  4001ce:	e022                	sd	s0,0(sp)
  4001d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4001d2:	00054783          	lbu	a5,0(a0)
  4001d6:	cf99                	beqz	a5,4001f4 <strlen+0x2a>
  4001d8:	0505                	addi	a0,a0,1
  4001da:	87aa                	mv	a5,a0
  4001dc:	86be                	mv	a3,a5
  4001de:	0785                	addi	a5,a5,1
  4001e0:	fff7c703          	lbu	a4,-1(a5)
  4001e4:	ff65                	bnez	a4,4001dc <strlen+0x12>
  4001e6:	40a6853b          	subw	a0,a3,a0
  4001ea:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4001ec:	60a2                	ld	ra,8(sp)
  4001ee:	6402                	ld	s0,0(sp)
  4001f0:	0141                	addi	sp,sp,16
  4001f2:	8082                	ret
  for(n = 0; s[n]; n++)
  4001f4:	4501                	li	a0,0
  4001f6:	bfdd                	j	4001ec <strlen+0x22>

00000000004001f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  4001f8:	1141                	addi	sp,sp,-16
  4001fa:	e406                	sd	ra,8(sp)
  4001fc:	e022                	sd	s0,0(sp)
  4001fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400200:	ca19                	beqz	a2,400216 <memset+0x1e>
  400202:	87aa                	mv	a5,a0
  400204:	1602                	slli	a2,a2,0x20
  400206:	9201                	srli	a2,a2,0x20
  400208:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  40020c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400210:	0785                	addi	a5,a5,1
  400212:	fee79de3          	bne	a5,a4,40020c <memset+0x14>
  }
  return dst;
}
  400216:	60a2                	ld	ra,8(sp)
  400218:	6402                	ld	s0,0(sp)
  40021a:	0141                	addi	sp,sp,16
  40021c:	8082                	ret

000000000040021e <strchr>:

char*
strchr(const char *s, char c)
{
  40021e:	1141                	addi	sp,sp,-16
  400220:	e406                	sd	ra,8(sp)
  400222:	e022                	sd	s0,0(sp)
  400224:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400226:	00054783          	lbu	a5,0(a0)
  40022a:	cf81                	beqz	a5,400242 <strchr+0x24>
    if(*s == c)
  40022c:	00f58763          	beq	a1,a5,40023a <strchr+0x1c>
  for(; *s; s++)
  400230:	0505                	addi	a0,a0,1
  400232:	00054783          	lbu	a5,0(a0)
  400236:	fbfd                	bnez	a5,40022c <strchr+0xe>
      return (char*)s;
  return 0;
  400238:	4501                	li	a0,0
}
  40023a:	60a2                	ld	ra,8(sp)
  40023c:	6402                	ld	s0,0(sp)
  40023e:	0141                	addi	sp,sp,16
  400240:	8082                	ret
  return 0;
  400242:	4501                	li	a0,0
  400244:	bfdd                	j	40023a <strchr+0x1c>

0000000000400246 <gets>:

char*
gets(char *buf, int max)
{
  400246:	7159                	addi	sp,sp,-112
  400248:	f486                	sd	ra,104(sp)
  40024a:	f0a2                	sd	s0,96(sp)
  40024c:	eca6                	sd	s1,88(sp)
  40024e:	e8ca                	sd	s2,80(sp)
  400250:	e4ce                	sd	s3,72(sp)
  400252:	e0d2                	sd	s4,64(sp)
  400254:	fc56                	sd	s5,56(sp)
  400256:	f85a                	sd	s6,48(sp)
  400258:	f45e                	sd	s7,40(sp)
  40025a:	f062                	sd	s8,32(sp)
  40025c:	ec66                	sd	s9,24(sp)
  40025e:	e86a                	sd	s10,16(sp)
  400260:	1880                	addi	s0,sp,112
  400262:	8caa                	mv	s9,a0
  400264:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400266:	892a                	mv	s2,a0
  400268:	4481                	li	s1,0
    cc = read(0, &c, 1);
  40026a:	f9f40b13          	addi	s6,s0,-97
  40026e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400270:	4ba9                	li	s7,10
  400272:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400274:	8d26                	mv	s10,s1
  400276:	0014899b          	addiw	s3,s1,1
  40027a:	84ce                	mv	s1,s3
  40027c:	0349d563          	bge	s3,s4,4002a6 <gets+0x60>
    cc = read(0, &c, 1);
  400280:	8656                	mv	a2,s5
  400282:	85da                	mv	a1,s6
  400284:	4501                	li	a0,0
  400286:	198000ef          	jal	40041e <read>
    if(cc < 1)
  40028a:	00a05e63          	blez	a0,4002a6 <gets+0x60>
    buf[i++] = c;
  40028e:	f9f44783          	lbu	a5,-97(s0)
  400292:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400296:	01778763          	beq	a5,s7,4002a4 <gets+0x5e>
  40029a:	0905                	addi	s2,s2,1
  40029c:	fd879ce3          	bne	a5,s8,400274 <gets+0x2e>
    buf[i++] = c;
  4002a0:	8d4e                	mv	s10,s3
  4002a2:	a011                	j	4002a6 <gets+0x60>
  4002a4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  4002a6:	9d66                	add	s10,s10,s9
  4002a8:	000d0023          	sb	zero,0(s10)
  return buf;
}
  4002ac:	8566                	mv	a0,s9
  4002ae:	70a6                	ld	ra,104(sp)
  4002b0:	7406                	ld	s0,96(sp)
  4002b2:	64e6                	ld	s1,88(sp)
  4002b4:	6946                	ld	s2,80(sp)
  4002b6:	69a6                	ld	s3,72(sp)
  4002b8:	6a06                	ld	s4,64(sp)
  4002ba:	7ae2                	ld	s5,56(sp)
  4002bc:	7b42                	ld	s6,48(sp)
  4002be:	7ba2                	ld	s7,40(sp)
  4002c0:	7c02                	ld	s8,32(sp)
  4002c2:	6ce2                	ld	s9,24(sp)
  4002c4:	6d42                	ld	s10,16(sp)
  4002c6:	6165                	addi	sp,sp,112
  4002c8:	8082                	ret

00000000004002ca <stat>:

int
stat(const char *n, struct stat *st)
{
  4002ca:	1101                	addi	sp,sp,-32
  4002cc:	ec06                	sd	ra,24(sp)
  4002ce:	e822                	sd	s0,16(sp)
  4002d0:	e04a                	sd	s2,0(sp)
  4002d2:	1000                	addi	s0,sp,32
  4002d4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4002d6:	4581                	li	a1,0
  4002d8:	16e000ef          	jal	400446 <open>
  if(fd < 0)
  4002dc:	02054263          	bltz	a0,400300 <stat+0x36>
  4002e0:	e426                	sd	s1,8(sp)
  4002e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4002e4:	85ca                	mv	a1,s2
  4002e6:	178000ef          	jal	40045e <fstat>
  4002ea:	892a                	mv	s2,a0
  close(fd);
  4002ec:	8526                	mv	a0,s1
  4002ee:	140000ef          	jal	40042e <close>
  return r;
  4002f2:	64a2                	ld	s1,8(sp)
}
  4002f4:	854a                	mv	a0,s2
  4002f6:	60e2                	ld	ra,24(sp)
  4002f8:	6442                	ld	s0,16(sp)
  4002fa:	6902                	ld	s2,0(sp)
  4002fc:	6105                	addi	sp,sp,32
  4002fe:	8082                	ret
    return -1;
  400300:	597d                	li	s2,-1
  400302:	bfcd                	j	4002f4 <stat+0x2a>

0000000000400304 <atoi>:

int
atoi(const char *s)
{
  400304:	1141                	addi	sp,sp,-16
  400306:	e406                	sd	ra,8(sp)
  400308:	e022                	sd	s0,0(sp)
  40030a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  40030c:	00054683          	lbu	a3,0(a0)
  400310:	fd06879b          	addiw	a5,a3,-48
  400314:	0ff7f793          	zext.b	a5,a5
  400318:	4625                	li	a2,9
  40031a:	02f66963          	bltu	a2,a5,40034c <atoi+0x48>
  40031e:	872a                	mv	a4,a0
  n = 0;
  400320:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400322:	0705                	addi	a4,a4,1
  400324:	0025179b          	slliw	a5,a0,0x2
  400328:	9fa9                	addw	a5,a5,a0
  40032a:	0017979b          	slliw	a5,a5,0x1
  40032e:	9fb5                	addw	a5,a5,a3
  400330:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400334:	00074683          	lbu	a3,0(a4)
  400338:	fd06879b          	addiw	a5,a3,-48
  40033c:	0ff7f793          	zext.b	a5,a5
  400340:	fef671e3          	bgeu	a2,a5,400322 <atoi+0x1e>
  return n;
}
  400344:	60a2                	ld	ra,8(sp)
  400346:	6402                	ld	s0,0(sp)
  400348:	0141                	addi	sp,sp,16
  40034a:	8082                	ret
  n = 0;
  40034c:	4501                	li	a0,0
  40034e:	bfdd                	j	400344 <atoi+0x40>

0000000000400350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400350:	1141                	addi	sp,sp,-16
  400352:	e406                	sd	ra,8(sp)
  400354:	e022                	sd	s0,0(sp)
  400356:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400358:	02b57563          	bgeu	a0,a1,400382 <memmove+0x32>
    while(n-- > 0)
  40035c:	00c05f63          	blez	a2,40037a <memmove+0x2a>
  400360:	1602                	slli	a2,a2,0x20
  400362:	9201                	srli	a2,a2,0x20
  400364:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400368:	872a                	mv	a4,a0
      *dst++ = *src++;
  40036a:	0585                	addi	a1,a1,1
  40036c:	0705                	addi	a4,a4,1
  40036e:	fff5c683          	lbu	a3,-1(a1)
  400372:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400376:	fee79ae3          	bne	a5,a4,40036a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  40037a:	60a2                	ld	ra,8(sp)
  40037c:	6402                	ld	s0,0(sp)
  40037e:	0141                	addi	sp,sp,16
  400380:	8082                	ret
    dst += n;
  400382:	00c50733          	add	a4,a0,a2
    src += n;
  400386:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400388:	fec059e3          	blez	a2,40037a <memmove+0x2a>
  40038c:	fff6079b          	addiw	a5,a2,-1
  400390:	1782                	slli	a5,a5,0x20
  400392:	9381                	srli	a5,a5,0x20
  400394:	fff7c793          	not	a5,a5
  400398:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  40039a:	15fd                	addi	a1,a1,-1
  40039c:	177d                	addi	a4,a4,-1
  40039e:	0005c683          	lbu	a3,0(a1)
  4003a2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  4003a6:	fef71ae3          	bne	a4,a5,40039a <memmove+0x4a>
  4003aa:	bfc1                	j	40037a <memmove+0x2a>

00000000004003ac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  4003ac:	1141                	addi	sp,sp,-16
  4003ae:	e406                	sd	ra,8(sp)
  4003b0:	e022                	sd	s0,0(sp)
  4003b2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4003b4:	ca0d                	beqz	a2,4003e6 <memcmp+0x3a>
  4003b6:	fff6069b          	addiw	a3,a2,-1
  4003ba:	1682                	slli	a3,a3,0x20
  4003bc:	9281                	srli	a3,a3,0x20
  4003be:	0685                	addi	a3,a3,1
  4003c0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4003c2:	00054783          	lbu	a5,0(a0)
  4003c6:	0005c703          	lbu	a4,0(a1)
  4003ca:	00e79863          	bne	a5,a4,4003da <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4003ce:	0505                	addi	a0,a0,1
    p2++;
  4003d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4003d2:	fed518e3          	bne	a0,a3,4003c2 <memcmp+0x16>
  }
  return 0;
  4003d6:	4501                	li	a0,0
  4003d8:	a019                	j	4003de <memcmp+0x32>
      return *p1 - *p2;
  4003da:	40e7853b          	subw	a0,a5,a4
}
  4003de:	60a2                	ld	ra,8(sp)
  4003e0:	6402                	ld	s0,0(sp)
  4003e2:	0141                	addi	sp,sp,16
  4003e4:	8082                	ret
  return 0;
  4003e6:	4501                	li	a0,0
  4003e8:	bfdd                	j	4003de <memcmp+0x32>

00000000004003ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4003ea:	1141                	addi	sp,sp,-16
  4003ec:	e406                	sd	ra,8(sp)
  4003ee:	e022                	sd	s0,0(sp)
  4003f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4003f2:	f5fff0ef          	jal	400350 <memmove>
}
  4003f6:	60a2                	ld	ra,8(sp)
  4003f8:	6402                	ld	s0,0(sp)
  4003fa:	0141                	addi	sp,sp,16
  4003fc:	8082                	ret

00000000004003fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  4003fe:	4885                	li	a7,1
 ecall
  400400:	00000073          	ecall
 ret
  400404:	8082                	ret

0000000000400406 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400406:	4889                	li	a7,2
 ecall
  400408:	00000073          	ecall
 ret
  40040c:	8082                	ret

000000000040040e <wait>:
.global wait
wait:
 li a7, SYS_wait
  40040e:	488d                	li	a7,3
 ecall
  400410:	00000073          	ecall
 ret
  400414:	8082                	ret

0000000000400416 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400416:	4891                	li	a7,4
 ecall
  400418:	00000073          	ecall
 ret
  40041c:	8082                	ret

000000000040041e <read>:
.global read
read:
 li a7, SYS_read
  40041e:	4895                	li	a7,5
 ecall
  400420:	00000073          	ecall
 ret
  400424:	8082                	ret

0000000000400426 <write>:
.global write
write:
 li a7, SYS_write
  400426:	48c1                	li	a7,16
 ecall
  400428:	00000073          	ecall
 ret
  40042c:	8082                	ret

000000000040042e <close>:
.global close
close:
 li a7, SYS_close
  40042e:	48d5                	li	a7,21
 ecall
  400430:	00000073          	ecall
 ret
  400434:	8082                	ret

0000000000400436 <kill>:
.global kill
kill:
 li a7, SYS_kill
  400436:	4899                	li	a7,6
 ecall
  400438:	00000073          	ecall
 ret
  40043c:	8082                	ret

000000000040043e <exec>:
.global exec
exec:
 li a7, SYS_exec
  40043e:	489d                	li	a7,7
 ecall
  400440:	00000073          	ecall
 ret
  400444:	8082                	ret

0000000000400446 <open>:
.global open
open:
 li a7, SYS_open
  400446:	48bd                	li	a7,15
 ecall
  400448:	00000073          	ecall
 ret
  40044c:	8082                	ret

000000000040044e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  40044e:	48c5                	li	a7,17
 ecall
  400450:	00000073          	ecall
 ret
  400454:	8082                	ret

0000000000400456 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400456:	48c9                	li	a7,18
 ecall
  400458:	00000073          	ecall
 ret
  40045c:	8082                	ret

000000000040045e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  40045e:	48a1                	li	a7,8
 ecall
  400460:	00000073          	ecall
 ret
  400464:	8082                	ret

0000000000400466 <link>:
.global link
link:
 li a7, SYS_link
  400466:	48cd                	li	a7,19
 ecall
  400468:	00000073          	ecall
 ret
  40046c:	8082                	ret

000000000040046e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  40046e:	48d1                	li	a7,20
 ecall
  400470:	00000073          	ecall
 ret
  400474:	8082                	ret

0000000000400476 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400476:	48a5                	li	a7,9
 ecall
  400478:	00000073          	ecall
 ret
  40047c:	8082                	ret

000000000040047e <dup>:
.global dup
dup:
 li a7, SYS_dup
  40047e:	48a9                	li	a7,10
 ecall
  400480:	00000073          	ecall
 ret
  400484:	8082                	ret

0000000000400486 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400486:	48ad                	li	a7,11
 ecall
  400488:	00000073          	ecall
 ret
  40048c:	8082                	ret

000000000040048e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  40048e:	48b1                	li	a7,12
 ecall
  400490:	00000073          	ecall
 ret
  400494:	8082                	ret

0000000000400496 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400496:	48b5                	li	a7,13
 ecall
  400498:	00000073          	ecall
 ret
  40049c:	8082                	ret

000000000040049e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  40049e:	48b9                	li	a7,14
 ecall
  4004a0:	00000073          	ecall
 ret
  4004a4:	8082                	ret

00000000004004a6 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  4004a6:	48d9                	li	a7,22
 ecall
  4004a8:	00000073          	ecall
 ret
  4004ac:	8082                	ret

00000000004004ae <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  4004ae:	48dd                	li	a7,23
 ecall
  4004b0:	00000073          	ecall
 ret
  4004b4:	8082                	ret

00000000004004b6 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4004b6:	48e1                	li	a7,24
 ecall
  4004b8:	00000073          	ecall
 ret
  4004bc:	8082                	ret

00000000004004be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4004be:	1101                	addi	sp,sp,-32
  4004c0:	ec06                	sd	ra,24(sp)
  4004c2:	e822                	sd	s0,16(sp)
  4004c4:	1000                	addi	s0,sp,32
  4004c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4004ca:	4605                	li	a2,1
  4004cc:	fef40593          	addi	a1,s0,-17
  4004d0:	f57ff0ef          	jal	400426 <write>
}
  4004d4:	60e2                	ld	ra,24(sp)
  4004d6:	6442                	ld	s0,16(sp)
  4004d8:	6105                	addi	sp,sp,32
  4004da:	8082                	ret

00000000004004dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4004dc:	7139                	addi	sp,sp,-64
  4004de:	fc06                	sd	ra,56(sp)
  4004e0:	f822                	sd	s0,48(sp)
  4004e2:	f426                	sd	s1,40(sp)
  4004e4:	f04a                	sd	s2,32(sp)
  4004e6:	ec4e                	sd	s3,24(sp)
  4004e8:	0080                	addi	s0,sp,64
  4004ea:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4004ec:	c299                	beqz	a3,4004f2 <printint+0x16>
  4004ee:	0605ce63          	bltz	a1,40056a <printint+0x8e>
  neg = 0;
  4004f2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4004f4:	fc040313          	addi	t1,s0,-64
  neg = 0;
  4004f8:	869a                	mv	a3,t1
  i = 0;
  4004fa:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  4004fc:	00000817          	auipc	a6,0x0
  400500:	60c80813          	addi	a6,a6,1548 # 400b08 <digits>
  400504:	88be                	mv	a7,a5
  400506:	0017851b          	addiw	a0,a5,1
  40050a:	87aa                	mv	a5,a0
  40050c:	02c5f73b          	remuw	a4,a1,a2
  400510:	1702                	slli	a4,a4,0x20
  400512:	9301                	srli	a4,a4,0x20
  400514:	9742                	add	a4,a4,a6
  400516:	00074703          	lbu	a4,0(a4)
  40051a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  40051e:	872e                	mv	a4,a1
  400520:	02c5d5bb          	divuw	a1,a1,a2
  400524:	0685                	addi	a3,a3,1
  400526:	fcc77fe3          	bgeu	a4,a2,400504 <printint+0x28>
  if(neg)
  40052a:	000e0c63          	beqz	t3,400542 <printint+0x66>
    buf[i++] = '-';
  40052e:	fd050793          	addi	a5,a0,-48
  400532:	00878533          	add	a0,a5,s0
  400536:	02d00793          	li	a5,45
  40053a:	fef50823          	sb	a5,-16(a0)
  40053e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400542:	fff7899b          	addiw	s3,a5,-1
  400546:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  40054a:	fff4c583          	lbu	a1,-1(s1)
  40054e:	854a                	mv	a0,s2
  400550:	f6fff0ef          	jal	4004be <putc>
  while(--i >= 0)
  400554:	39fd                	addiw	s3,s3,-1
  400556:	14fd                	addi	s1,s1,-1
  400558:	fe09d9e3          	bgez	s3,40054a <printint+0x6e>
}
  40055c:	70e2                	ld	ra,56(sp)
  40055e:	7442                	ld	s0,48(sp)
  400560:	74a2                	ld	s1,40(sp)
  400562:	7902                	ld	s2,32(sp)
  400564:	69e2                	ld	s3,24(sp)
  400566:	6121                	addi	sp,sp,64
  400568:	8082                	ret
    x = -xx;
  40056a:	40b005bb          	negw	a1,a1
    neg = 1;
  40056e:	4e05                	li	t3,1
    x = -xx;
  400570:	b751                	j	4004f4 <printint+0x18>

0000000000400572 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400572:	711d                	addi	sp,sp,-96
  400574:	ec86                	sd	ra,88(sp)
  400576:	e8a2                	sd	s0,80(sp)
  400578:	e4a6                	sd	s1,72(sp)
  40057a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  40057c:	0005c483          	lbu	s1,0(a1)
  400580:	26048663          	beqz	s1,4007ec <vprintf+0x27a>
  400584:	e0ca                	sd	s2,64(sp)
  400586:	fc4e                	sd	s3,56(sp)
  400588:	f852                	sd	s4,48(sp)
  40058a:	f456                	sd	s5,40(sp)
  40058c:	f05a                	sd	s6,32(sp)
  40058e:	ec5e                	sd	s7,24(sp)
  400590:	e862                	sd	s8,16(sp)
  400592:	e466                	sd	s9,8(sp)
  400594:	8b2a                	mv	s6,a0
  400596:	8a2e                	mv	s4,a1
  400598:	8bb2                	mv	s7,a2
  state = 0;
  40059a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  40059c:	4901                	li	s2,0
  40059e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  4005a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  4005a4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  4005a8:	06c00c93          	li	s9,108
  4005ac:	a00d                	j	4005ce <vprintf+0x5c>
        putc(fd, c0);
  4005ae:	85a6                	mv	a1,s1
  4005b0:	855a                	mv	a0,s6
  4005b2:	f0dff0ef          	jal	4004be <putc>
  4005b6:	a019                	j	4005bc <vprintf+0x4a>
    } else if(state == '%'){
  4005b8:	03598363          	beq	s3,s5,4005de <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4005bc:	0019079b          	addiw	a5,s2,1
  4005c0:	893e                	mv	s2,a5
  4005c2:	873e                	mv	a4,a5
  4005c4:	97d2                	add	a5,a5,s4
  4005c6:	0007c483          	lbu	s1,0(a5)
  4005ca:	20048963          	beqz	s1,4007dc <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4005ce:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4005d2:	fe0993e3          	bnez	s3,4005b8 <vprintf+0x46>
      if(c0 == '%'){
  4005d6:	fd579ce3          	bne	a5,s5,4005ae <vprintf+0x3c>
        state = '%';
  4005da:	89be                	mv	s3,a5
  4005dc:	b7c5                	j	4005bc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4005de:	00ea06b3          	add	a3,s4,a4
  4005e2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4005e6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4005e8:	c681                	beqz	a3,4005f0 <vprintf+0x7e>
  4005ea:	9752                	add	a4,a4,s4
  4005ec:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4005f0:	03878e63          	beq	a5,s8,40062c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4005f4:	05978863          	beq	a5,s9,400644 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  4005f8:	07500713          	li	a4,117
  4005fc:	0ee78263          	beq	a5,a4,4006e0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400600:	07800713          	li	a4,120
  400604:	12e78463          	beq	a5,a4,40072c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400608:	07000713          	li	a4,112
  40060c:	14e78963          	beq	a5,a4,40075e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400610:	07300713          	li	a4,115
  400614:	18e78863          	beq	a5,a4,4007a4 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400618:	02500713          	li	a4,37
  40061c:	04e79463          	bne	a5,a4,400664 <vprintf+0xf2>
        putc(fd, '%');
  400620:	85ba                	mv	a1,a4
  400622:	855a                	mv	a0,s6
  400624:	e9bff0ef          	jal	4004be <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400628:	4981                	li	s3,0
  40062a:	bf49                	j	4005bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  40062c:	008b8493          	addi	s1,s7,8
  400630:	4685                	li	a3,1
  400632:	4629                	li	a2,10
  400634:	000ba583          	lw	a1,0(s7)
  400638:	855a                	mv	a0,s6
  40063a:	ea3ff0ef          	jal	4004dc <printint>
  40063e:	8ba6                	mv	s7,s1
      state = 0;
  400640:	4981                	li	s3,0
  400642:	bfad                	j	4005bc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400644:	06400793          	li	a5,100
  400648:	02f68963          	beq	a3,a5,40067a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  40064c:	06c00793          	li	a5,108
  400650:	04f68263          	beq	a3,a5,400694 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400654:	07500793          	li	a5,117
  400658:	0af68063          	beq	a3,a5,4006f8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  40065c:	07800793          	li	a5,120
  400660:	0ef68263          	beq	a3,a5,400744 <vprintf+0x1d2>
        putc(fd, '%');
  400664:	02500593          	li	a1,37
  400668:	855a                	mv	a0,s6
  40066a:	e55ff0ef          	jal	4004be <putc>
        putc(fd, c0);
  40066e:	85a6                	mv	a1,s1
  400670:	855a                	mv	a0,s6
  400672:	e4dff0ef          	jal	4004be <putc>
      state = 0;
  400676:	4981                	li	s3,0
  400678:	b791                	j	4005bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  40067a:	008b8493          	addi	s1,s7,8
  40067e:	4685                	li	a3,1
  400680:	4629                	li	a2,10
  400682:	000ba583          	lw	a1,0(s7)
  400686:	855a                	mv	a0,s6
  400688:	e55ff0ef          	jal	4004dc <printint>
        i += 1;
  40068c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  40068e:	8ba6                	mv	s7,s1
      state = 0;
  400690:	4981                	li	s3,0
        i += 1;
  400692:	b72d                	j	4005bc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400694:	06400793          	li	a5,100
  400698:	02f60763          	beq	a2,a5,4006c6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  40069c:	07500793          	li	a5,117
  4006a0:	06f60963          	beq	a2,a5,400712 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  4006a4:	07800793          	li	a5,120
  4006a8:	faf61ee3          	bne	a2,a5,400664 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006ac:	008b8493          	addi	s1,s7,8
  4006b0:	4681                	li	a3,0
  4006b2:	4641                	li	a2,16
  4006b4:	000ba583          	lw	a1,0(s7)
  4006b8:	855a                	mv	a0,s6
  4006ba:	e23ff0ef          	jal	4004dc <printint>
        i += 2;
  4006be:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006c0:	8ba6                	mv	s7,s1
      state = 0;
  4006c2:	4981                	li	s3,0
        i += 2;
  4006c4:	bde5                	j	4005bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4006c6:	008b8493          	addi	s1,s7,8
  4006ca:	4685                	li	a3,1
  4006cc:	4629                	li	a2,10
  4006ce:	000ba583          	lw	a1,0(s7)
  4006d2:	855a                	mv	a0,s6
  4006d4:	e09ff0ef          	jal	4004dc <printint>
        i += 2;
  4006d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4006da:	8ba6                	mv	s7,s1
      state = 0;
  4006dc:	4981                	li	s3,0
        i += 2;
  4006de:	bdf9                	j	4005bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4006e0:	008b8493          	addi	s1,s7,8
  4006e4:	4681                	li	a3,0
  4006e6:	4629                	li	a2,10
  4006e8:	000ba583          	lw	a1,0(s7)
  4006ec:	855a                	mv	a0,s6
  4006ee:	defff0ef          	jal	4004dc <printint>
  4006f2:	8ba6                	mv	s7,s1
      state = 0;
  4006f4:	4981                	li	s3,0
  4006f6:	b5d9                	j	4005bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006f8:	008b8493          	addi	s1,s7,8
  4006fc:	4681                	li	a3,0
  4006fe:	4629                	li	a2,10
  400700:	000ba583          	lw	a1,0(s7)
  400704:	855a                	mv	a0,s6
  400706:	dd7ff0ef          	jal	4004dc <printint>
        i += 1;
  40070a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  40070c:	8ba6                	mv	s7,s1
      state = 0;
  40070e:	4981                	li	s3,0
        i += 1;
  400710:	b575                	j	4005bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400712:	008b8493          	addi	s1,s7,8
  400716:	4681                	li	a3,0
  400718:	4629                	li	a2,10
  40071a:	000ba583          	lw	a1,0(s7)
  40071e:	855a                	mv	a0,s6
  400720:	dbdff0ef          	jal	4004dc <printint>
        i += 2;
  400724:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400726:	8ba6                	mv	s7,s1
      state = 0;
  400728:	4981                	li	s3,0
        i += 2;
  40072a:	bd49                	j	4005bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  40072c:	008b8493          	addi	s1,s7,8
  400730:	4681                	li	a3,0
  400732:	4641                	li	a2,16
  400734:	000ba583          	lw	a1,0(s7)
  400738:	855a                	mv	a0,s6
  40073a:	da3ff0ef          	jal	4004dc <printint>
  40073e:	8ba6                	mv	s7,s1
      state = 0;
  400740:	4981                	li	s3,0
  400742:	bdad                	j	4005bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400744:	008b8493          	addi	s1,s7,8
  400748:	4681                	li	a3,0
  40074a:	4641                	li	a2,16
  40074c:	000ba583          	lw	a1,0(s7)
  400750:	855a                	mv	a0,s6
  400752:	d8bff0ef          	jal	4004dc <printint>
        i += 1;
  400756:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400758:	8ba6                	mv	s7,s1
      state = 0;
  40075a:	4981                	li	s3,0
        i += 1;
  40075c:	b585                	j	4005bc <vprintf+0x4a>
  40075e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  400760:	008b8d13          	addi	s10,s7,8
  400764:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400768:	03000593          	li	a1,48
  40076c:	855a                	mv	a0,s6
  40076e:	d51ff0ef          	jal	4004be <putc>
  putc(fd, 'x');
  400772:	07800593          	li	a1,120
  400776:	855a                	mv	a0,s6
  400778:	d47ff0ef          	jal	4004be <putc>
  40077c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  40077e:	00000b97          	auipc	s7,0x0
  400782:	38ab8b93          	addi	s7,s7,906 # 400b08 <digits>
  400786:	03c9d793          	srli	a5,s3,0x3c
  40078a:	97de                	add	a5,a5,s7
  40078c:	0007c583          	lbu	a1,0(a5)
  400790:	855a                	mv	a0,s6
  400792:	d2dff0ef          	jal	4004be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400796:	0992                	slli	s3,s3,0x4
  400798:	34fd                	addiw	s1,s1,-1
  40079a:	f4f5                	bnez	s1,400786 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  40079c:	8bea                	mv	s7,s10
      state = 0;
  40079e:	4981                	li	s3,0
  4007a0:	6d02                	ld	s10,0(sp)
  4007a2:	bd29                	j	4005bc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  4007a4:	008b8993          	addi	s3,s7,8
  4007a8:	000bb483          	ld	s1,0(s7)
  4007ac:	cc91                	beqz	s1,4007c8 <vprintf+0x256>
        for(; *s; s++)
  4007ae:	0004c583          	lbu	a1,0(s1)
  4007b2:	c195                	beqz	a1,4007d6 <vprintf+0x264>
          putc(fd, *s);
  4007b4:	855a                	mv	a0,s6
  4007b6:	d09ff0ef          	jal	4004be <putc>
        for(; *s; s++)
  4007ba:	0485                	addi	s1,s1,1
  4007bc:	0004c583          	lbu	a1,0(s1)
  4007c0:	f9f5                	bnez	a1,4007b4 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4007c2:	8bce                	mv	s7,s3
      state = 0;
  4007c4:	4981                	li	s3,0
  4007c6:	bbdd                	j	4005bc <vprintf+0x4a>
          s = "(null)";
  4007c8:	00000497          	auipc	s1,0x0
  4007cc:	33848493          	addi	s1,s1,824 # 400b00 <malloc+0x224>
        for(; *s; s++)
  4007d0:	02800593          	li	a1,40
  4007d4:	b7c5                	j	4007b4 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4007d6:	8bce                	mv	s7,s3
      state = 0;
  4007d8:	4981                	li	s3,0
  4007da:	b3cd                	j	4005bc <vprintf+0x4a>
  4007dc:	6906                	ld	s2,64(sp)
  4007de:	79e2                	ld	s3,56(sp)
  4007e0:	7a42                	ld	s4,48(sp)
  4007e2:	7aa2                	ld	s5,40(sp)
  4007e4:	7b02                	ld	s6,32(sp)
  4007e6:	6be2                	ld	s7,24(sp)
  4007e8:	6c42                	ld	s8,16(sp)
  4007ea:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4007ec:	60e6                	ld	ra,88(sp)
  4007ee:	6446                	ld	s0,80(sp)
  4007f0:	64a6                	ld	s1,72(sp)
  4007f2:	6125                	addi	sp,sp,96
  4007f4:	8082                	ret

00000000004007f6 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4007f6:	715d                	addi	sp,sp,-80
  4007f8:	ec06                	sd	ra,24(sp)
  4007fa:	e822                	sd	s0,16(sp)
  4007fc:	1000                	addi	s0,sp,32
  4007fe:	e010                	sd	a2,0(s0)
  400800:	e414                	sd	a3,8(s0)
  400802:	e818                	sd	a4,16(s0)
  400804:	ec1c                	sd	a5,24(s0)
  400806:	03043023          	sd	a6,32(s0)
  40080a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  40080e:	8622                	mv	a2,s0
  400810:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400814:	d5fff0ef          	jal	400572 <vprintf>
  return 0;
}
  400818:	4501                	li	a0,0
  40081a:	60e2                	ld	ra,24(sp)
  40081c:	6442                	ld	s0,16(sp)
  40081e:	6161                	addi	sp,sp,80
  400820:	8082                	ret

0000000000400822 <printf>:

int
printf(const char *fmt, ...)
{
  400822:	711d                	addi	sp,sp,-96
  400824:	ec06                	sd	ra,24(sp)
  400826:	e822                	sd	s0,16(sp)
  400828:	1000                	addi	s0,sp,32
  40082a:	e40c                	sd	a1,8(s0)
  40082c:	e810                	sd	a2,16(s0)
  40082e:	ec14                	sd	a3,24(s0)
  400830:	f018                	sd	a4,32(s0)
  400832:	f41c                	sd	a5,40(s0)
  400834:	03043823          	sd	a6,48(s0)
  400838:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  40083c:	00840613          	addi	a2,s0,8
  400840:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400844:	85aa                	mv	a1,a0
  400846:	4505                	li	a0,1
  400848:	d2bff0ef          	jal	400572 <vprintf>
  return 0;
}
  40084c:	4501                	li	a0,0
  40084e:	60e2                	ld	ra,24(sp)
  400850:	6442                	ld	s0,16(sp)
  400852:	6125                	addi	sp,sp,96
  400854:	8082                	ret

0000000000400856 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  400856:	1141                	addi	sp,sp,-16
  400858:	e406                	sd	ra,8(sp)
  40085a:	e022                	sd	s0,0(sp)
  40085c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  40085e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400862:	00000797          	auipc	a5,0x0
  400866:	7a67b783          	ld	a5,1958(a5) # 401008 <freep>
  40086a:	a02d                	j	400894 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  40086c:	4618                	lw	a4,8(a2)
  40086e:	9f2d                	addw	a4,a4,a1
  400870:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400874:	6398                	ld	a4,0(a5)
  400876:	6310                	ld	a2,0(a4)
  400878:	a83d                	j	4008b6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  40087a:	ff852703          	lw	a4,-8(a0)
  40087e:	9f31                	addw	a4,a4,a2
  400880:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400882:	ff053683          	ld	a3,-16(a0)
  400886:	a091                	j	4008ca <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400888:	6398                	ld	a4,0(a5)
  40088a:	00e7e463          	bltu	a5,a4,400892 <free+0x3c>
  40088e:	00e6ea63          	bltu	a3,a4,4008a2 <free+0x4c>
{
  400892:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400894:	fed7fae3          	bgeu	a5,a3,400888 <free+0x32>
  400898:	6398                	ld	a4,0(a5)
  40089a:	00e6e463          	bltu	a3,a4,4008a2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40089e:	fee7eae3          	bltu	a5,a4,400892 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4008a2:	ff852583          	lw	a1,-8(a0)
  4008a6:	6390                	ld	a2,0(a5)
  4008a8:	02059813          	slli	a6,a1,0x20
  4008ac:	01c85713          	srli	a4,a6,0x1c
  4008b0:	9736                	add	a4,a4,a3
  4008b2:	fae60de3          	beq	a2,a4,40086c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4008b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4008ba:	4790                	lw	a2,8(a5)
  4008bc:	02061593          	slli	a1,a2,0x20
  4008c0:	01c5d713          	srli	a4,a1,0x1c
  4008c4:	973e                	add	a4,a4,a5
  4008c6:	fae68ae3          	beq	a3,a4,40087a <free+0x24>
    p->s.ptr = bp->s.ptr;
  4008ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4008cc:	00000717          	auipc	a4,0x0
  4008d0:	72f73e23          	sd	a5,1852(a4) # 401008 <freep>
}
  4008d4:	60a2                	ld	ra,8(sp)
  4008d6:	6402                	ld	s0,0(sp)
  4008d8:	0141                	addi	sp,sp,16
  4008da:	8082                	ret

00000000004008dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4008dc:	7139                	addi	sp,sp,-64
  4008de:	fc06                	sd	ra,56(sp)
  4008e0:	f822                	sd	s0,48(sp)
  4008e2:	f04a                	sd	s2,32(sp)
  4008e4:	ec4e                	sd	s3,24(sp)
  4008e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4008e8:	02051993          	slli	s3,a0,0x20
  4008ec:	0209d993          	srli	s3,s3,0x20
  4008f0:	09bd                	addi	s3,s3,15
  4008f2:	0049d993          	srli	s3,s3,0x4
  4008f6:	2985                	addiw	s3,s3,1
  4008f8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4008fa:	00000517          	auipc	a0,0x0
  4008fe:	70e53503          	ld	a0,1806(a0) # 401008 <freep>
  400902:	c905                	beqz	a0,400932 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400904:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400906:	4798                	lw	a4,8(a5)
  400908:	09377663          	bgeu	a4,s3,400994 <malloc+0xb8>
  40090c:	f426                	sd	s1,40(sp)
  40090e:	e852                	sd	s4,16(sp)
  400910:	e456                	sd	s5,8(sp)
  400912:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400914:	8a4e                	mv	s4,s3
  400916:	6705                	lui	a4,0x1
  400918:	00e9f363          	bgeu	s3,a4,40091e <malloc+0x42>
  40091c:	6a05                	lui	s4,0x1
  40091e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400922:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  400926:	00000497          	auipc	s1,0x0
  40092a:	6e248493          	addi	s1,s1,1762 # 401008 <freep>
  if(p == (char*)-1)
  40092e:	5afd                	li	s5,-1
  400930:	a83d                	j	40096e <malloc+0x92>
  400932:	f426                	sd	s1,40(sp)
  400934:	e852                	sd	s4,16(sp)
  400936:	e456                	sd	s5,8(sp)
  400938:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  40093a:	00000797          	auipc	a5,0x0
  40093e:	6d678793          	addi	a5,a5,1750 # 401010 <base>
  400942:	00000717          	auipc	a4,0x0
  400946:	6cf73323          	sd	a5,1734(a4) # 401008 <freep>
  40094a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  40094c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  400950:	b7d1                	j	400914 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400952:	6398                	ld	a4,0(a5)
  400954:	e118                	sd	a4,0(a0)
  400956:	a899                	j	4009ac <malloc+0xd0>
  hp->s.size = nu;
  400958:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  40095c:	0541                	addi	a0,a0,16
  40095e:	ef9ff0ef          	jal	400856 <free>
  return freep;
  400962:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  400964:	c125                	beqz	a0,4009c4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400966:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400968:	4798                	lw	a4,8(a5)
  40096a:	03277163          	bgeu	a4,s2,40098c <malloc+0xb0>
    if(p == freep)
  40096e:	6098                	ld	a4,0(s1)
  400970:	853e                	mv	a0,a5
  400972:	fef71ae3          	bne	a4,a5,400966 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400976:	8552                	mv	a0,s4
  400978:	b17ff0ef          	jal	40048e <sbrk>
  if(p == (char*)-1)
  40097c:	fd551ee3          	bne	a0,s5,400958 <malloc+0x7c>
        return 0;
  400980:	4501                	li	a0,0
  400982:	74a2                	ld	s1,40(sp)
  400984:	6a42                	ld	s4,16(sp)
  400986:	6aa2                	ld	s5,8(sp)
  400988:	6b02                	ld	s6,0(sp)
  40098a:	a03d                	j	4009b8 <malloc+0xdc>
  40098c:	74a2                	ld	s1,40(sp)
  40098e:	6a42                	ld	s4,16(sp)
  400990:	6aa2                	ld	s5,8(sp)
  400992:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400994:	fae90fe3          	beq	s2,a4,400952 <malloc+0x76>
        p->s.size -= nunits;
  400998:	4137073b          	subw	a4,a4,s3
  40099c:	c798                	sw	a4,8(a5)
        p += p->s.size;
  40099e:	02071693          	slli	a3,a4,0x20
  4009a2:	01c6d713          	srli	a4,a3,0x1c
  4009a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4009a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4009ac:	00000717          	auipc	a4,0x0
  4009b0:	64a73e23          	sd	a0,1628(a4) # 401008 <freep>
      return (void*)(p + 1);
  4009b4:	01078513          	addi	a0,a5,16
  }
}
  4009b8:	70e2                	ld	ra,56(sp)
  4009ba:	7442                	ld	s0,48(sp)
  4009bc:	7902                	ld	s2,32(sp)
  4009be:	69e2                	ld	s3,24(sp)
  4009c0:	6121                	addi	sp,sp,64
  4009c2:	8082                	ret
  4009c4:	74a2                	ld	s1,40(sp)
  4009c6:	6a42                	ld	s4,16(sp)
  4009c8:	6aa2                	ld	s5,8(sp)
  4009ca:	6b02                	ld	s6,0(sp)
  4009cc:	b7f5                	j	4009b8 <malloc+0xdc>
