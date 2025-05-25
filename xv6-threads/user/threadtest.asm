
user/_threadtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <thread_func>:
#include "kernel/types.h"
#include "user/user.h"

#define STACK_SIZE 4096

void thread_func() {
  400000:	1141                	addi	sp,sp,-16
  400002:	e406                	sd	ra,8(sp)
  400004:	e022                	sd	s0,0(sp)
  400006:	0800                	addi	s0,sp,16
  printf("Hello from thread! tid=%d\n", kthread_join(-1, 0));
  400008:	4581                	li	a1,0
  40000a:	557d                	li	a0,-1
  40000c:	3ee000ef          	jal	4003fa <kthread_join>
  400010:	85aa                	mv	a1,a0
  400012:	00001517          	auipc	a0,0x1
  400016:	90e50513          	addi	a0,a0,-1778 # 400920 <malloc+0x100>
  40001a:	74c000ef          	jal	400766 <printf>
  kthread_exit(42);
  40001e:	02a00513          	li	a0,42
  400022:	3d0000ef          	jal	4003f2 <kthread_exit>

0000000000400026 <main>:
}

int main() {
  400026:	7179                	addi	sp,sp,-48
  400028:	f406                	sd	ra,40(sp)
  40002a:	f022                	sd	s0,32(sp)
  40002c:	1800                	addi	s0,sp,48
  void *stack = malloc(STACK_SIZE);
  40002e:	6505                	lui	a0,0x1
  400030:	7f0000ef          	jal	400820 <malloc>
  if (!stack) {
  400034:	c131                	beqz	a0,400078 <main+0x52>
  400036:	ec26                	sd	s1,24(sp)
  400038:	84aa                	mv	s1,a0
    printf("Failed to allocate stack\n");
    exit(1);
  }
  int tid = kthread_create(thread_func, stack, STACK_SIZE);
  40003a:	6605                	lui	a2,0x1
  40003c:	85aa                	mv	a1,a0
  40003e:	00000517          	auipc	a0,0x0
  400042:	fc250513          	addi	a0,a0,-62 # 400000 <thread_func>
  400046:	3a4000ef          	jal	4003ea <kthread_create>
  if (tid < 0) {
  40004a:	04054163          	bltz	a0,40008c <main+0x66>
    printf("kthread_create failed\n");
    exit(1);
  }
  int status = 0;
  40004e:	fc042e23          	sw	zero,-36(s0)
  int ret = kthread_join(tid, &status);
  400052:	fdc40593          	addi	a1,s0,-36
  400056:	3a4000ef          	jal	4003fa <kthread_join>
  if (ret == 0) {
  40005a:	e131                	bnez	a0,40009e <main+0x78>
    printf("Thread joined, exit status=%d\n", status);
  40005c:	fdc42583          	lw	a1,-36(s0)
  400060:	00001517          	auipc	a0,0x1
  400064:	91850513          	addi	a0,a0,-1768 # 400978 <malloc+0x158>
  400068:	6fe000ef          	jal	400766 <printf>
  } else {
    printf("kthread_join failed\n");
  }
  free(stack);
  40006c:	8526                	mv	a0,s1
  40006e:	72c000ef          	jal	40079a <free>
  exit(0);
  400072:	4501                	li	a0,0
  400074:	2d6000ef          	jal	40034a <exit>
  400078:	ec26                	sd	s1,24(sp)
    printf("Failed to allocate stack\n");
  40007a:	00001517          	auipc	a0,0x1
  40007e:	8c650513          	addi	a0,a0,-1850 # 400940 <malloc+0x120>
  400082:	6e4000ef          	jal	400766 <printf>
    exit(1);
  400086:	4505                	li	a0,1
  400088:	2c2000ef          	jal	40034a <exit>
    printf("kthread_create failed\n");
  40008c:	00001517          	auipc	a0,0x1
  400090:	8d450513          	addi	a0,a0,-1836 # 400960 <malloc+0x140>
  400094:	6d2000ef          	jal	400766 <printf>
    exit(1);
  400098:	4505                	li	a0,1
  40009a:	2b0000ef          	jal	40034a <exit>
    printf("kthread_join failed\n");
  40009e:	00001517          	auipc	a0,0x1
  4000a2:	8fa50513          	addi	a0,a0,-1798 # 400998 <malloc+0x178>
  4000a6:	6c0000ef          	jal	400766 <printf>
  4000aa:	b7c9                	j	40006c <main+0x46>

00000000004000ac <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4000ac:	1141                	addi	sp,sp,-16
  4000ae:	e406                	sd	ra,8(sp)
  4000b0:	e022                	sd	s0,0(sp)
  4000b2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4000b4:	f73ff0ef          	jal	400026 <main>
  exit(0);
  4000b8:	4501                	li	a0,0
  4000ba:	290000ef          	jal	40034a <exit>

00000000004000be <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  4000be:	1141                	addi	sp,sp,-16
  4000c0:	e406                	sd	ra,8(sp)
  4000c2:	e022                	sd	s0,0(sp)
  4000c4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4000c6:	87aa                	mv	a5,a0
  4000c8:	0585                	addi	a1,a1,1
  4000ca:	0785                	addi	a5,a5,1
  4000cc:	fff5c703          	lbu	a4,-1(a1)
  4000d0:	fee78fa3          	sb	a4,-1(a5)
  4000d4:	fb75                	bnez	a4,4000c8 <strcpy+0xa>
    ;
  return os;
}
  4000d6:	60a2                	ld	ra,8(sp)
  4000d8:	6402                	ld	s0,0(sp)
  4000da:	0141                	addi	sp,sp,16
  4000dc:	8082                	ret

00000000004000de <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4000de:	1141                	addi	sp,sp,-16
  4000e0:	e406                	sd	ra,8(sp)
  4000e2:	e022                	sd	s0,0(sp)
  4000e4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4000e6:	00054783          	lbu	a5,0(a0)
  4000ea:	cb91                	beqz	a5,4000fe <strcmp+0x20>
  4000ec:	0005c703          	lbu	a4,0(a1)
  4000f0:	00f71763          	bne	a4,a5,4000fe <strcmp+0x20>
    p++, q++;
  4000f4:	0505                	addi	a0,a0,1
  4000f6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4000f8:	00054783          	lbu	a5,0(a0)
  4000fc:	fbe5                	bnez	a5,4000ec <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4000fe:	0005c503          	lbu	a0,0(a1)
}
  400102:	40a7853b          	subw	a0,a5,a0
  400106:	60a2                	ld	ra,8(sp)
  400108:	6402                	ld	s0,0(sp)
  40010a:	0141                	addi	sp,sp,16
  40010c:	8082                	ret

000000000040010e <strlen>:

uint
strlen(const char *s)
{
  40010e:	1141                	addi	sp,sp,-16
  400110:	e406                	sd	ra,8(sp)
  400112:	e022                	sd	s0,0(sp)
  400114:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  400116:	00054783          	lbu	a5,0(a0)
  40011a:	cf99                	beqz	a5,400138 <strlen+0x2a>
  40011c:	0505                	addi	a0,a0,1
  40011e:	87aa                	mv	a5,a0
  400120:	86be                	mv	a3,a5
  400122:	0785                	addi	a5,a5,1
  400124:	fff7c703          	lbu	a4,-1(a5)
  400128:	ff65                	bnez	a4,400120 <strlen+0x12>
  40012a:	40a6853b          	subw	a0,a3,a0
  40012e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  400130:	60a2                	ld	ra,8(sp)
  400132:	6402                	ld	s0,0(sp)
  400134:	0141                	addi	sp,sp,16
  400136:	8082                	ret
  for(n = 0; s[n]; n++)
  400138:	4501                	li	a0,0
  40013a:	bfdd                	j	400130 <strlen+0x22>

000000000040013c <memset>:

void*
memset(void *dst, int c, uint n)
{
  40013c:	1141                	addi	sp,sp,-16
  40013e:	e406                	sd	ra,8(sp)
  400140:	e022                	sd	s0,0(sp)
  400142:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400144:	ca19                	beqz	a2,40015a <memset+0x1e>
  400146:	87aa                	mv	a5,a0
  400148:	1602                	slli	a2,a2,0x20
  40014a:	9201                	srli	a2,a2,0x20
  40014c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400150:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400154:	0785                	addi	a5,a5,1
  400156:	fee79de3          	bne	a5,a4,400150 <memset+0x14>
  }
  return dst;
}
  40015a:	60a2                	ld	ra,8(sp)
  40015c:	6402                	ld	s0,0(sp)
  40015e:	0141                	addi	sp,sp,16
  400160:	8082                	ret

0000000000400162 <strchr>:

char*
strchr(const char *s, char c)
{
  400162:	1141                	addi	sp,sp,-16
  400164:	e406                	sd	ra,8(sp)
  400166:	e022                	sd	s0,0(sp)
  400168:	0800                	addi	s0,sp,16
  for(; *s; s++)
  40016a:	00054783          	lbu	a5,0(a0)
  40016e:	cf81                	beqz	a5,400186 <strchr+0x24>
    if(*s == c)
  400170:	00f58763          	beq	a1,a5,40017e <strchr+0x1c>
  for(; *s; s++)
  400174:	0505                	addi	a0,a0,1
  400176:	00054783          	lbu	a5,0(a0)
  40017a:	fbfd                	bnez	a5,400170 <strchr+0xe>
      return (char*)s;
  return 0;
  40017c:	4501                	li	a0,0
}
  40017e:	60a2                	ld	ra,8(sp)
  400180:	6402                	ld	s0,0(sp)
  400182:	0141                	addi	sp,sp,16
  400184:	8082                	ret
  return 0;
  400186:	4501                	li	a0,0
  400188:	bfdd                	j	40017e <strchr+0x1c>

000000000040018a <gets>:

char*
gets(char *buf, int max)
{
  40018a:	7159                	addi	sp,sp,-112
  40018c:	f486                	sd	ra,104(sp)
  40018e:	f0a2                	sd	s0,96(sp)
  400190:	eca6                	sd	s1,88(sp)
  400192:	e8ca                	sd	s2,80(sp)
  400194:	e4ce                	sd	s3,72(sp)
  400196:	e0d2                	sd	s4,64(sp)
  400198:	fc56                	sd	s5,56(sp)
  40019a:	f85a                	sd	s6,48(sp)
  40019c:	f45e                	sd	s7,40(sp)
  40019e:	f062                	sd	s8,32(sp)
  4001a0:	ec66                	sd	s9,24(sp)
  4001a2:	e86a                	sd	s10,16(sp)
  4001a4:	1880                	addi	s0,sp,112
  4001a6:	8caa                	mv	s9,a0
  4001a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  4001aa:	892a                	mv	s2,a0
  4001ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
  4001ae:	f9f40b13          	addi	s6,s0,-97
  4001b2:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  4001b4:	4ba9                	li	s7,10
  4001b6:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  4001b8:	8d26                	mv	s10,s1
  4001ba:	0014899b          	addiw	s3,s1,1
  4001be:	84ce                	mv	s1,s3
  4001c0:	0349d563          	bge	s3,s4,4001ea <gets+0x60>
    cc = read(0, &c, 1);
  4001c4:	8656                	mv	a2,s5
  4001c6:	85da                	mv	a1,s6
  4001c8:	4501                	li	a0,0
  4001ca:	198000ef          	jal	400362 <read>
    if(cc < 1)
  4001ce:	00a05e63          	blez	a0,4001ea <gets+0x60>
    buf[i++] = c;
  4001d2:	f9f44783          	lbu	a5,-97(s0)
  4001d6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  4001da:	01778763          	beq	a5,s7,4001e8 <gets+0x5e>
  4001de:	0905                	addi	s2,s2,1
  4001e0:	fd879ce3          	bne	a5,s8,4001b8 <gets+0x2e>
    buf[i++] = c;
  4001e4:	8d4e                	mv	s10,s3
  4001e6:	a011                	j	4001ea <gets+0x60>
  4001e8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  4001ea:	9d66                	add	s10,s10,s9
  4001ec:	000d0023          	sb	zero,0(s10)
  return buf;
}
  4001f0:	8566                	mv	a0,s9
  4001f2:	70a6                	ld	ra,104(sp)
  4001f4:	7406                	ld	s0,96(sp)
  4001f6:	64e6                	ld	s1,88(sp)
  4001f8:	6946                	ld	s2,80(sp)
  4001fa:	69a6                	ld	s3,72(sp)
  4001fc:	6a06                	ld	s4,64(sp)
  4001fe:	7ae2                	ld	s5,56(sp)
  400200:	7b42                	ld	s6,48(sp)
  400202:	7ba2                	ld	s7,40(sp)
  400204:	7c02                	ld	s8,32(sp)
  400206:	6ce2                	ld	s9,24(sp)
  400208:	6d42                	ld	s10,16(sp)
  40020a:	6165                	addi	sp,sp,112
  40020c:	8082                	ret

000000000040020e <stat>:

int
stat(const char *n, struct stat *st)
{
  40020e:	1101                	addi	sp,sp,-32
  400210:	ec06                	sd	ra,24(sp)
  400212:	e822                	sd	s0,16(sp)
  400214:	e04a                	sd	s2,0(sp)
  400216:	1000                	addi	s0,sp,32
  400218:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  40021a:	4581                	li	a1,0
  40021c:	16e000ef          	jal	40038a <open>
  if(fd < 0)
  400220:	02054263          	bltz	a0,400244 <stat+0x36>
  400224:	e426                	sd	s1,8(sp)
  400226:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  400228:	85ca                	mv	a1,s2
  40022a:	178000ef          	jal	4003a2 <fstat>
  40022e:	892a                	mv	s2,a0
  close(fd);
  400230:	8526                	mv	a0,s1
  400232:	140000ef          	jal	400372 <close>
  return r;
  400236:	64a2                	ld	s1,8(sp)
}
  400238:	854a                	mv	a0,s2
  40023a:	60e2                	ld	ra,24(sp)
  40023c:	6442                	ld	s0,16(sp)
  40023e:	6902                	ld	s2,0(sp)
  400240:	6105                	addi	sp,sp,32
  400242:	8082                	ret
    return -1;
  400244:	597d                	li	s2,-1
  400246:	bfcd                	j	400238 <stat+0x2a>

0000000000400248 <atoi>:

int
atoi(const char *s)
{
  400248:	1141                	addi	sp,sp,-16
  40024a:	e406                	sd	ra,8(sp)
  40024c:	e022                	sd	s0,0(sp)
  40024e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400250:	00054683          	lbu	a3,0(a0)
  400254:	fd06879b          	addiw	a5,a3,-48
  400258:	0ff7f793          	zext.b	a5,a5
  40025c:	4625                	li	a2,9
  40025e:	02f66963          	bltu	a2,a5,400290 <atoi+0x48>
  400262:	872a                	mv	a4,a0
  n = 0;
  400264:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400266:	0705                	addi	a4,a4,1
  400268:	0025179b          	slliw	a5,a0,0x2
  40026c:	9fa9                	addw	a5,a5,a0
  40026e:	0017979b          	slliw	a5,a5,0x1
  400272:	9fb5                	addw	a5,a5,a3
  400274:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400278:	00074683          	lbu	a3,0(a4)
  40027c:	fd06879b          	addiw	a5,a3,-48
  400280:	0ff7f793          	zext.b	a5,a5
  400284:	fef671e3          	bgeu	a2,a5,400266 <atoi+0x1e>
  return n;
}
  400288:	60a2                	ld	ra,8(sp)
  40028a:	6402                	ld	s0,0(sp)
  40028c:	0141                	addi	sp,sp,16
  40028e:	8082                	ret
  n = 0;
  400290:	4501                	li	a0,0
  400292:	bfdd                	j	400288 <atoi+0x40>

0000000000400294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400294:	1141                	addi	sp,sp,-16
  400296:	e406                	sd	ra,8(sp)
  400298:	e022                	sd	s0,0(sp)
  40029a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  40029c:	02b57563          	bgeu	a0,a1,4002c6 <memmove+0x32>
    while(n-- > 0)
  4002a0:	00c05f63          	blez	a2,4002be <memmove+0x2a>
  4002a4:	1602                	slli	a2,a2,0x20
  4002a6:	9201                	srli	a2,a2,0x20
  4002a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  4002ac:	872a                	mv	a4,a0
      *dst++ = *src++;
  4002ae:	0585                	addi	a1,a1,1
  4002b0:	0705                	addi	a4,a4,1
  4002b2:	fff5c683          	lbu	a3,-1(a1)
  4002b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  4002ba:	fee79ae3          	bne	a5,a4,4002ae <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  4002be:	60a2                	ld	ra,8(sp)
  4002c0:	6402                	ld	s0,0(sp)
  4002c2:	0141                	addi	sp,sp,16
  4002c4:	8082                	ret
    dst += n;
  4002c6:	00c50733          	add	a4,a0,a2
    src += n;
  4002ca:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  4002cc:	fec059e3          	blez	a2,4002be <memmove+0x2a>
  4002d0:	fff6079b          	addiw	a5,a2,-1 # fff <thread_func-0x3ff001>
  4002d4:	1782                	slli	a5,a5,0x20
  4002d6:	9381                	srli	a5,a5,0x20
  4002d8:	fff7c793          	not	a5,a5
  4002dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  4002de:	15fd                	addi	a1,a1,-1
  4002e0:	177d                	addi	a4,a4,-1
  4002e2:	0005c683          	lbu	a3,0(a1)
  4002e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  4002ea:	fef71ae3          	bne	a4,a5,4002de <memmove+0x4a>
  4002ee:	bfc1                	j	4002be <memmove+0x2a>

00000000004002f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  4002f0:	1141                	addi	sp,sp,-16
  4002f2:	e406                	sd	ra,8(sp)
  4002f4:	e022                	sd	s0,0(sp)
  4002f6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4002f8:	ca0d                	beqz	a2,40032a <memcmp+0x3a>
  4002fa:	fff6069b          	addiw	a3,a2,-1
  4002fe:	1682                	slli	a3,a3,0x20
  400300:	9281                	srli	a3,a3,0x20
  400302:	0685                	addi	a3,a3,1
  400304:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  400306:	00054783          	lbu	a5,0(a0)
  40030a:	0005c703          	lbu	a4,0(a1)
  40030e:	00e79863          	bne	a5,a4,40031e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  400312:	0505                	addi	a0,a0,1
    p2++;
  400314:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  400316:	fed518e3          	bne	a0,a3,400306 <memcmp+0x16>
  }
  return 0;
  40031a:	4501                	li	a0,0
  40031c:	a019                	j	400322 <memcmp+0x32>
      return *p1 - *p2;
  40031e:	40e7853b          	subw	a0,a5,a4
}
  400322:	60a2                	ld	ra,8(sp)
  400324:	6402                	ld	s0,0(sp)
  400326:	0141                	addi	sp,sp,16
  400328:	8082                	ret
  return 0;
  40032a:	4501                	li	a0,0
  40032c:	bfdd                	j	400322 <memcmp+0x32>

000000000040032e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  40032e:	1141                	addi	sp,sp,-16
  400330:	e406                	sd	ra,8(sp)
  400332:	e022                	sd	s0,0(sp)
  400334:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400336:	f5fff0ef          	jal	400294 <memmove>
}
  40033a:	60a2                	ld	ra,8(sp)
  40033c:	6402                	ld	s0,0(sp)
  40033e:	0141                	addi	sp,sp,16
  400340:	8082                	ret

0000000000400342 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  400342:	4885                	li	a7,1
 ecall
  400344:	00000073          	ecall
 ret
  400348:	8082                	ret

000000000040034a <exit>:
.global exit
exit:
 li a7, SYS_exit
  40034a:	4889                	li	a7,2
 ecall
  40034c:	00000073          	ecall
 ret
  400350:	8082                	ret

0000000000400352 <wait>:
.global wait
wait:
 li a7, SYS_wait
  400352:	488d                	li	a7,3
 ecall
  400354:	00000073          	ecall
 ret
  400358:	8082                	ret

000000000040035a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  40035a:	4891                	li	a7,4
 ecall
  40035c:	00000073          	ecall
 ret
  400360:	8082                	ret

0000000000400362 <read>:
.global read
read:
 li a7, SYS_read
  400362:	4895                	li	a7,5
 ecall
  400364:	00000073          	ecall
 ret
  400368:	8082                	ret

000000000040036a <write>:
.global write
write:
 li a7, SYS_write
  40036a:	48c1                	li	a7,16
 ecall
  40036c:	00000073          	ecall
 ret
  400370:	8082                	ret

0000000000400372 <close>:
.global close
close:
 li a7, SYS_close
  400372:	48d5                	li	a7,21
 ecall
  400374:	00000073          	ecall
 ret
  400378:	8082                	ret

000000000040037a <kill>:
.global kill
kill:
 li a7, SYS_kill
  40037a:	4899                	li	a7,6
 ecall
  40037c:	00000073          	ecall
 ret
  400380:	8082                	ret

0000000000400382 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400382:	489d                	li	a7,7
 ecall
  400384:	00000073          	ecall
 ret
  400388:	8082                	ret

000000000040038a <open>:
.global open
open:
 li a7, SYS_open
  40038a:	48bd                	li	a7,15
 ecall
  40038c:	00000073          	ecall
 ret
  400390:	8082                	ret

0000000000400392 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400392:	48c5                	li	a7,17
 ecall
  400394:	00000073          	ecall
 ret
  400398:	8082                	ret

000000000040039a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  40039a:	48c9                	li	a7,18
 ecall
  40039c:	00000073          	ecall
 ret
  4003a0:	8082                	ret

00000000004003a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  4003a2:	48a1                	li	a7,8
 ecall
  4003a4:	00000073          	ecall
 ret
  4003a8:	8082                	ret

00000000004003aa <link>:
.global link
link:
 li a7, SYS_link
  4003aa:	48cd                	li	a7,19
 ecall
  4003ac:	00000073          	ecall
 ret
  4003b0:	8082                	ret

00000000004003b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  4003b2:	48d1                	li	a7,20
 ecall
  4003b4:	00000073          	ecall
 ret
  4003b8:	8082                	ret

00000000004003ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  4003ba:	48a5                	li	a7,9
 ecall
  4003bc:	00000073          	ecall
 ret
  4003c0:	8082                	ret

00000000004003c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
  4003c2:	48a9                	li	a7,10
 ecall
  4003c4:	00000073          	ecall
 ret
  4003c8:	8082                	ret

00000000004003ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  4003ca:	48ad                	li	a7,11
 ecall
  4003cc:	00000073          	ecall
 ret
  4003d0:	8082                	ret

00000000004003d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  4003d2:	48b1                	li	a7,12
 ecall
  4003d4:	00000073          	ecall
 ret
  4003d8:	8082                	ret

00000000004003da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  4003da:	48b5                	li	a7,13
 ecall
  4003dc:	00000073          	ecall
 ret
  4003e0:	8082                	ret

00000000004003e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  4003e2:	48b9                	li	a7,14
 ecall
  4003e4:	00000073          	ecall
 ret
  4003e8:	8082                	ret

00000000004003ea <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  4003ea:	48d9                	li	a7,22
 ecall
  4003ec:	00000073          	ecall
 ret
  4003f0:	8082                	ret

00000000004003f2 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  4003f2:	48dd                	li	a7,23
 ecall
  4003f4:	00000073          	ecall
 ret
  4003f8:	8082                	ret

00000000004003fa <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4003fa:	48e1                	li	a7,24
 ecall
  4003fc:	00000073          	ecall
 ret
  400400:	8082                	ret

0000000000400402 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  400402:	1101                	addi	sp,sp,-32
  400404:	ec06                	sd	ra,24(sp)
  400406:	e822                	sd	s0,16(sp)
  400408:	1000                	addi	s0,sp,32
  40040a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  40040e:	4605                	li	a2,1
  400410:	fef40593          	addi	a1,s0,-17
  400414:	f57ff0ef          	jal	40036a <write>
}
  400418:	60e2                	ld	ra,24(sp)
  40041a:	6442                	ld	s0,16(sp)
  40041c:	6105                	addi	sp,sp,32
  40041e:	8082                	ret

0000000000400420 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  400420:	7139                	addi	sp,sp,-64
  400422:	fc06                	sd	ra,56(sp)
  400424:	f822                	sd	s0,48(sp)
  400426:	f426                	sd	s1,40(sp)
  400428:	f04a                	sd	s2,32(sp)
  40042a:	ec4e                	sd	s3,24(sp)
  40042c:	0080                	addi	s0,sp,64
  40042e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  400430:	c299                	beqz	a3,400436 <printint+0x16>
  400432:	0605ce63          	bltz	a1,4004ae <printint+0x8e>
  neg = 0;
  400436:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400438:	fc040313          	addi	t1,s0,-64
  neg = 0;
  40043c:	869a                	mv	a3,t1
  i = 0;
  40043e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  400440:	00000817          	auipc	a6,0x0
  400444:	57880813          	addi	a6,a6,1400 # 4009b8 <digits>
  400448:	88be                	mv	a7,a5
  40044a:	0017851b          	addiw	a0,a5,1
  40044e:	87aa                	mv	a5,a0
  400450:	02c5f73b          	remuw	a4,a1,a2
  400454:	1702                	slli	a4,a4,0x20
  400456:	9301                	srli	a4,a4,0x20
  400458:	9742                	add	a4,a4,a6
  40045a:	00074703          	lbu	a4,0(a4)
  40045e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400462:	872e                	mv	a4,a1
  400464:	02c5d5bb          	divuw	a1,a1,a2
  400468:	0685                	addi	a3,a3,1
  40046a:	fcc77fe3          	bgeu	a4,a2,400448 <printint+0x28>
  if(neg)
  40046e:	000e0c63          	beqz	t3,400486 <printint+0x66>
    buf[i++] = '-';
  400472:	fd050793          	addi	a5,a0,-48
  400476:	00878533          	add	a0,a5,s0
  40047a:	02d00793          	li	a5,45
  40047e:	fef50823          	sb	a5,-16(a0)
  400482:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400486:	fff7899b          	addiw	s3,a5,-1
  40048a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  40048e:	fff4c583          	lbu	a1,-1(s1)
  400492:	854a                	mv	a0,s2
  400494:	f6fff0ef          	jal	400402 <putc>
  while(--i >= 0)
  400498:	39fd                	addiw	s3,s3,-1
  40049a:	14fd                	addi	s1,s1,-1
  40049c:	fe09d9e3          	bgez	s3,40048e <printint+0x6e>
}
  4004a0:	70e2                	ld	ra,56(sp)
  4004a2:	7442                	ld	s0,48(sp)
  4004a4:	74a2                	ld	s1,40(sp)
  4004a6:	7902                	ld	s2,32(sp)
  4004a8:	69e2                	ld	s3,24(sp)
  4004aa:	6121                	addi	sp,sp,64
  4004ac:	8082                	ret
    x = -xx;
  4004ae:	40b005bb          	negw	a1,a1
    neg = 1;
  4004b2:	4e05                	li	t3,1
    x = -xx;
  4004b4:	b751                	j	400438 <printint+0x18>

00000000004004b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  4004b6:	711d                	addi	sp,sp,-96
  4004b8:	ec86                	sd	ra,88(sp)
  4004ba:	e8a2                	sd	s0,80(sp)
  4004bc:	e4a6                	sd	s1,72(sp)
  4004be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  4004c0:	0005c483          	lbu	s1,0(a1)
  4004c4:	26048663          	beqz	s1,400730 <vprintf+0x27a>
  4004c8:	e0ca                	sd	s2,64(sp)
  4004ca:	fc4e                	sd	s3,56(sp)
  4004cc:	f852                	sd	s4,48(sp)
  4004ce:	f456                	sd	s5,40(sp)
  4004d0:	f05a                	sd	s6,32(sp)
  4004d2:	ec5e                	sd	s7,24(sp)
  4004d4:	e862                	sd	s8,16(sp)
  4004d6:	e466                	sd	s9,8(sp)
  4004d8:	8b2a                	mv	s6,a0
  4004da:	8a2e                	mv	s4,a1
  4004dc:	8bb2                	mv	s7,a2
  state = 0;
  4004de:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  4004e0:	4901                	li	s2,0
  4004e2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  4004e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  4004e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  4004ec:	06c00c93          	li	s9,108
  4004f0:	a00d                	j	400512 <vprintf+0x5c>
        putc(fd, c0);
  4004f2:	85a6                	mv	a1,s1
  4004f4:	855a                	mv	a0,s6
  4004f6:	f0dff0ef          	jal	400402 <putc>
  4004fa:	a019                	j	400500 <vprintf+0x4a>
    } else if(state == '%'){
  4004fc:	03598363          	beq	s3,s5,400522 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  400500:	0019079b          	addiw	a5,s2,1
  400504:	893e                	mv	s2,a5
  400506:	873e                	mv	a4,a5
  400508:	97d2                	add	a5,a5,s4
  40050a:	0007c483          	lbu	s1,0(a5)
  40050e:	20048963          	beqz	s1,400720 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  400512:	0004879b          	sext.w	a5,s1
    if(state == 0){
  400516:	fe0993e3          	bnez	s3,4004fc <vprintf+0x46>
      if(c0 == '%'){
  40051a:	fd579ce3          	bne	a5,s5,4004f2 <vprintf+0x3c>
        state = '%';
  40051e:	89be                	mv	s3,a5
  400520:	b7c5                	j	400500 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  400522:	00ea06b3          	add	a3,s4,a4
  400526:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  40052a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  40052c:	c681                	beqz	a3,400534 <vprintf+0x7e>
  40052e:	9752                	add	a4,a4,s4
  400530:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  400534:	03878e63          	beq	a5,s8,400570 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400538:	05978863          	beq	a5,s9,400588 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  40053c:	07500713          	li	a4,117
  400540:	0ee78263          	beq	a5,a4,400624 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400544:	07800713          	li	a4,120
  400548:	12e78463          	beq	a5,a4,400670 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  40054c:	07000713          	li	a4,112
  400550:	14e78963          	beq	a5,a4,4006a2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400554:	07300713          	li	a4,115
  400558:	18e78863          	beq	a5,a4,4006e8 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  40055c:	02500713          	li	a4,37
  400560:	04e79463          	bne	a5,a4,4005a8 <vprintf+0xf2>
        putc(fd, '%');
  400564:	85ba                	mv	a1,a4
  400566:	855a                	mv	a0,s6
  400568:	e9bff0ef          	jal	400402 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  40056c:	4981                	li	s3,0
  40056e:	bf49                	j	400500 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400570:	008b8493          	addi	s1,s7,8
  400574:	4685                	li	a3,1
  400576:	4629                	li	a2,10
  400578:	000ba583          	lw	a1,0(s7)
  40057c:	855a                	mv	a0,s6
  40057e:	ea3ff0ef          	jal	400420 <printint>
  400582:	8ba6                	mv	s7,s1
      state = 0;
  400584:	4981                	li	s3,0
  400586:	bfad                	j	400500 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400588:	06400793          	li	a5,100
  40058c:	02f68963          	beq	a3,a5,4005be <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400590:	06c00793          	li	a5,108
  400594:	04f68263          	beq	a3,a5,4005d8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400598:	07500793          	li	a5,117
  40059c:	0af68063          	beq	a3,a5,40063c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  4005a0:	07800793          	li	a5,120
  4005a4:	0ef68263          	beq	a3,a5,400688 <vprintf+0x1d2>
        putc(fd, '%');
  4005a8:	02500593          	li	a1,37
  4005ac:	855a                	mv	a0,s6
  4005ae:	e55ff0ef          	jal	400402 <putc>
        putc(fd, c0);
  4005b2:	85a6                	mv	a1,s1
  4005b4:	855a                	mv	a0,s6
  4005b6:	e4dff0ef          	jal	400402 <putc>
      state = 0;
  4005ba:	4981                	li	s3,0
  4005bc:	b791                	j	400500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005be:	008b8493          	addi	s1,s7,8
  4005c2:	4685                	li	a3,1
  4005c4:	4629                	li	a2,10
  4005c6:	000ba583          	lw	a1,0(s7)
  4005ca:	855a                	mv	a0,s6
  4005cc:	e55ff0ef          	jal	400420 <printint>
        i += 1;
  4005d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005d2:	8ba6                	mv	s7,s1
      state = 0;
  4005d4:	4981                	li	s3,0
        i += 1;
  4005d6:	b72d                	j	400500 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4005d8:	06400793          	li	a5,100
  4005dc:	02f60763          	beq	a2,a5,40060a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  4005e0:	07500793          	li	a5,117
  4005e4:	06f60963          	beq	a2,a5,400656 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  4005e8:	07800793          	li	a5,120
  4005ec:	faf61ee3          	bne	a2,a5,4005a8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005f0:	008b8493          	addi	s1,s7,8
  4005f4:	4681                	li	a3,0
  4005f6:	4641                	li	a2,16
  4005f8:	000ba583          	lw	a1,0(s7)
  4005fc:	855a                	mv	a0,s6
  4005fe:	e23ff0ef          	jal	400420 <printint>
        i += 2;
  400602:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  400604:	8ba6                	mv	s7,s1
      state = 0;
  400606:	4981                	li	s3,0
        i += 2;
  400608:	bde5                	j	400500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  40060a:	008b8493          	addi	s1,s7,8
  40060e:	4685                	li	a3,1
  400610:	4629                	li	a2,10
  400612:	000ba583          	lw	a1,0(s7)
  400616:	855a                	mv	a0,s6
  400618:	e09ff0ef          	jal	400420 <printint>
        i += 2;
  40061c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  40061e:	8ba6                	mv	s7,s1
      state = 0;
  400620:	4981                	li	s3,0
        i += 2;
  400622:	bdf9                	j	400500 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  400624:	008b8493          	addi	s1,s7,8
  400628:	4681                	li	a3,0
  40062a:	4629                	li	a2,10
  40062c:	000ba583          	lw	a1,0(s7)
  400630:	855a                	mv	a0,s6
  400632:	defff0ef          	jal	400420 <printint>
  400636:	8ba6                	mv	s7,s1
      state = 0;
  400638:	4981                	li	s3,0
  40063a:	b5d9                	j	400500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  40063c:	008b8493          	addi	s1,s7,8
  400640:	4681                	li	a3,0
  400642:	4629                	li	a2,10
  400644:	000ba583          	lw	a1,0(s7)
  400648:	855a                	mv	a0,s6
  40064a:	dd7ff0ef          	jal	400420 <printint>
        i += 1;
  40064e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400650:	8ba6                	mv	s7,s1
      state = 0;
  400652:	4981                	li	s3,0
        i += 1;
  400654:	b575                	j	400500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400656:	008b8493          	addi	s1,s7,8
  40065a:	4681                	li	a3,0
  40065c:	4629                	li	a2,10
  40065e:	000ba583          	lw	a1,0(s7)
  400662:	855a                	mv	a0,s6
  400664:	dbdff0ef          	jal	400420 <printint>
        i += 2;
  400668:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  40066a:	8ba6                	mv	s7,s1
      state = 0;
  40066c:	4981                	li	s3,0
        i += 2;
  40066e:	bd49                	j	400500 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400670:	008b8493          	addi	s1,s7,8
  400674:	4681                	li	a3,0
  400676:	4641                	li	a2,16
  400678:	000ba583          	lw	a1,0(s7)
  40067c:	855a                	mv	a0,s6
  40067e:	da3ff0ef          	jal	400420 <printint>
  400682:	8ba6                	mv	s7,s1
      state = 0;
  400684:	4981                	li	s3,0
  400686:	bdad                	j	400500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400688:	008b8493          	addi	s1,s7,8
  40068c:	4681                	li	a3,0
  40068e:	4641                	li	a2,16
  400690:	000ba583          	lw	a1,0(s7)
  400694:	855a                	mv	a0,s6
  400696:	d8bff0ef          	jal	400420 <printint>
        i += 1;
  40069a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  40069c:	8ba6                	mv	s7,s1
      state = 0;
  40069e:	4981                	li	s3,0
        i += 1;
  4006a0:	b585                	j	400500 <vprintf+0x4a>
  4006a2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  4006a4:	008b8d13          	addi	s10,s7,8
  4006a8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  4006ac:	03000593          	li	a1,48
  4006b0:	855a                	mv	a0,s6
  4006b2:	d51ff0ef          	jal	400402 <putc>
  putc(fd, 'x');
  4006b6:	07800593          	li	a1,120
  4006ba:	855a                	mv	a0,s6
  4006bc:	d47ff0ef          	jal	400402 <putc>
  4006c0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  4006c2:	00000b97          	auipc	s7,0x0
  4006c6:	2f6b8b93          	addi	s7,s7,758 # 4009b8 <digits>
  4006ca:	03c9d793          	srli	a5,s3,0x3c
  4006ce:	97de                	add	a5,a5,s7
  4006d0:	0007c583          	lbu	a1,0(a5)
  4006d4:	855a                	mv	a0,s6
  4006d6:	d2dff0ef          	jal	400402 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  4006da:	0992                	slli	s3,s3,0x4
  4006dc:	34fd                	addiw	s1,s1,-1
  4006de:	f4f5                	bnez	s1,4006ca <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  4006e0:	8bea                	mv	s7,s10
      state = 0;
  4006e2:	4981                	li	s3,0
  4006e4:	6d02                	ld	s10,0(sp)
  4006e6:	bd29                	j	400500 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  4006e8:	008b8993          	addi	s3,s7,8
  4006ec:	000bb483          	ld	s1,0(s7)
  4006f0:	cc91                	beqz	s1,40070c <vprintf+0x256>
        for(; *s; s++)
  4006f2:	0004c583          	lbu	a1,0(s1)
  4006f6:	c195                	beqz	a1,40071a <vprintf+0x264>
          putc(fd, *s);
  4006f8:	855a                	mv	a0,s6
  4006fa:	d09ff0ef          	jal	400402 <putc>
        for(; *s; s++)
  4006fe:	0485                	addi	s1,s1,1
  400700:	0004c583          	lbu	a1,0(s1)
  400704:	f9f5                	bnez	a1,4006f8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400706:	8bce                	mv	s7,s3
      state = 0;
  400708:	4981                	li	s3,0
  40070a:	bbdd                	j	400500 <vprintf+0x4a>
          s = "(null)";
  40070c:	00000497          	auipc	s1,0x0
  400710:	2a448493          	addi	s1,s1,676 # 4009b0 <malloc+0x190>
        for(; *s; s++)
  400714:	02800593          	li	a1,40
  400718:	b7c5                	j	4006f8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  40071a:	8bce                	mv	s7,s3
      state = 0;
  40071c:	4981                	li	s3,0
  40071e:	b3cd                	j	400500 <vprintf+0x4a>
  400720:	6906                	ld	s2,64(sp)
  400722:	79e2                	ld	s3,56(sp)
  400724:	7a42                	ld	s4,48(sp)
  400726:	7aa2                	ld	s5,40(sp)
  400728:	7b02                	ld	s6,32(sp)
  40072a:	6be2                	ld	s7,24(sp)
  40072c:	6c42                	ld	s8,16(sp)
  40072e:	6ca2                	ld	s9,8(sp)
    }
  }
}
  400730:	60e6                	ld	ra,88(sp)
  400732:	6446                	ld	s0,80(sp)
  400734:	64a6                	ld	s1,72(sp)
  400736:	6125                	addi	sp,sp,96
  400738:	8082                	ret

000000000040073a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  40073a:	715d                	addi	sp,sp,-80
  40073c:	ec06                	sd	ra,24(sp)
  40073e:	e822                	sd	s0,16(sp)
  400740:	1000                	addi	s0,sp,32
  400742:	e010                	sd	a2,0(s0)
  400744:	e414                	sd	a3,8(s0)
  400746:	e818                	sd	a4,16(s0)
  400748:	ec1c                	sd	a5,24(s0)
  40074a:	03043023          	sd	a6,32(s0)
  40074e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  400752:	8622                	mv	a2,s0
  400754:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400758:	d5fff0ef          	jal	4004b6 <vprintf>
  return 0;
}
  40075c:	4501                	li	a0,0
  40075e:	60e2                	ld	ra,24(sp)
  400760:	6442                	ld	s0,16(sp)
  400762:	6161                	addi	sp,sp,80
  400764:	8082                	ret

0000000000400766 <printf>:

int
printf(const char *fmt, ...)
{
  400766:	711d                	addi	sp,sp,-96
  400768:	ec06                	sd	ra,24(sp)
  40076a:	e822                	sd	s0,16(sp)
  40076c:	1000                	addi	s0,sp,32
  40076e:	e40c                	sd	a1,8(s0)
  400770:	e810                	sd	a2,16(s0)
  400772:	ec14                	sd	a3,24(s0)
  400774:	f018                	sd	a4,32(s0)
  400776:	f41c                	sd	a5,40(s0)
  400778:	03043823          	sd	a6,48(s0)
  40077c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400780:	00840613          	addi	a2,s0,8
  400784:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400788:	85aa                	mv	a1,a0
  40078a:	4505                	li	a0,1
  40078c:	d2bff0ef          	jal	4004b6 <vprintf>
  return 0;
}
  400790:	4501                	li	a0,0
  400792:	60e2                	ld	ra,24(sp)
  400794:	6442                	ld	s0,16(sp)
  400796:	6125                	addi	sp,sp,96
  400798:	8082                	ret

000000000040079a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  40079a:	1141                	addi	sp,sp,-16
  40079c:	e406                	sd	ra,8(sp)
  40079e:	e022                	sd	s0,0(sp)
  4007a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  4007a2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4007a6:	00001797          	auipc	a5,0x1
  4007aa:	85a7b783          	ld	a5,-1958(a5) # 401000 <freep>
  4007ae:	a02d                	j	4007d8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  4007b0:	4618                	lw	a4,8(a2)
  4007b2:	9f2d                	addw	a4,a4,a1
  4007b4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  4007b8:	6398                	ld	a4,0(a5)
  4007ba:	6310                	ld	a2,0(a4)
  4007bc:	a83d                	j	4007fa <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  4007be:	ff852703          	lw	a4,-8(a0)
  4007c2:	9f31                	addw	a4,a4,a2
  4007c4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  4007c6:	ff053683          	ld	a3,-16(a0)
  4007ca:	a091                	j	40080e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4007cc:	6398                	ld	a4,0(a5)
  4007ce:	00e7e463          	bltu	a5,a4,4007d6 <free+0x3c>
  4007d2:	00e6ea63          	bltu	a3,a4,4007e6 <free+0x4c>
{
  4007d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4007d8:	fed7fae3          	bgeu	a5,a3,4007cc <free+0x32>
  4007dc:	6398                	ld	a4,0(a5)
  4007de:	00e6e463          	bltu	a3,a4,4007e6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4007e2:	fee7eae3          	bltu	a5,a4,4007d6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4007e6:	ff852583          	lw	a1,-8(a0)
  4007ea:	6390                	ld	a2,0(a5)
  4007ec:	02059813          	slli	a6,a1,0x20
  4007f0:	01c85713          	srli	a4,a6,0x1c
  4007f4:	9736                	add	a4,a4,a3
  4007f6:	fae60de3          	beq	a2,a4,4007b0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4007fa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4007fe:	4790                	lw	a2,8(a5)
  400800:	02061593          	slli	a1,a2,0x20
  400804:	01c5d713          	srli	a4,a1,0x1c
  400808:	973e                	add	a4,a4,a5
  40080a:	fae68ae3          	beq	a3,a4,4007be <free+0x24>
    p->s.ptr = bp->s.ptr;
  40080e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  400810:	00000717          	auipc	a4,0x0
  400814:	7ef73823          	sd	a5,2032(a4) # 401000 <freep>
}
  400818:	60a2                	ld	ra,8(sp)
  40081a:	6402                	ld	s0,0(sp)
  40081c:	0141                	addi	sp,sp,16
  40081e:	8082                	ret

0000000000400820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  400820:	7139                	addi	sp,sp,-64
  400822:	fc06                	sd	ra,56(sp)
  400824:	f822                	sd	s0,48(sp)
  400826:	f04a                	sd	s2,32(sp)
  400828:	ec4e                	sd	s3,24(sp)
  40082a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  40082c:	02051993          	slli	s3,a0,0x20
  400830:	0209d993          	srli	s3,s3,0x20
  400834:	09bd                	addi	s3,s3,15
  400836:	0049d993          	srli	s3,s3,0x4
  40083a:	2985                	addiw	s3,s3,1
  40083c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  40083e:	00000517          	auipc	a0,0x0
  400842:	7c253503          	ld	a0,1986(a0) # 401000 <freep>
  400846:	c905                	beqz	a0,400876 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400848:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40084a:	4798                	lw	a4,8(a5)
  40084c:	09377663          	bgeu	a4,s3,4008d8 <malloc+0xb8>
  400850:	f426                	sd	s1,40(sp)
  400852:	e852                	sd	s4,16(sp)
  400854:	e456                	sd	s5,8(sp)
  400856:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400858:	8a4e                	mv	s4,s3
  40085a:	6705                	lui	a4,0x1
  40085c:	00e9f363          	bgeu	s3,a4,400862 <malloc+0x42>
  400860:	6a05                	lui	s4,0x1
  400862:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400866:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  40086a:	00000497          	auipc	s1,0x0
  40086e:	79648493          	addi	s1,s1,1942 # 401000 <freep>
  if(p == (char*)-1)
  400872:	5afd                	li	s5,-1
  400874:	a83d                	j	4008b2 <malloc+0x92>
  400876:	f426                	sd	s1,40(sp)
  400878:	e852                	sd	s4,16(sp)
  40087a:	e456                	sd	s5,8(sp)
  40087c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  40087e:	00000797          	auipc	a5,0x0
  400882:	79278793          	addi	a5,a5,1938 # 401010 <base>
  400886:	00000717          	auipc	a4,0x0
  40088a:	76f73d23          	sd	a5,1914(a4) # 401000 <freep>
  40088e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400890:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  400894:	b7d1                	j	400858 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400896:	6398                	ld	a4,0(a5)
  400898:	e118                	sd	a4,0(a0)
  40089a:	a899                	j	4008f0 <malloc+0xd0>
  hp->s.size = nu;
  40089c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  4008a0:	0541                	addi	a0,a0,16
  4008a2:	ef9ff0ef          	jal	40079a <free>
  return freep;
  4008a6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  4008a8:	c125                	beqz	a0,400908 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4008aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4008ac:	4798                	lw	a4,8(a5)
  4008ae:	03277163          	bgeu	a4,s2,4008d0 <malloc+0xb0>
    if(p == freep)
  4008b2:	6098                	ld	a4,0(s1)
  4008b4:	853e                	mv	a0,a5
  4008b6:	fef71ae3          	bne	a4,a5,4008aa <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  4008ba:	8552                	mv	a0,s4
  4008bc:	b17ff0ef          	jal	4003d2 <sbrk>
  if(p == (char*)-1)
  4008c0:	fd551ee3          	bne	a0,s5,40089c <malloc+0x7c>
        return 0;
  4008c4:	4501                	li	a0,0
  4008c6:	74a2                	ld	s1,40(sp)
  4008c8:	6a42                	ld	s4,16(sp)
  4008ca:	6aa2                	ld	s5,8(sp)
  4008cc:	6b02                	ld	s6,0(sp)
  4008ce:	a03d                	j	4008fc <malloc+0xdc>
  4008d0:	74a2                	ld	s1,40(sp)
  4008d2:	6a42                	ld	s4,16(sp)
  4008d4:	6aa2                	ld	s5,8(sp)
  4008d6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  4008d8:	fae90fe3          	beq	s2,a4,400896 <malloc+0x76>
        p->s.size -= nunits;
  4008dc:	4137073b          	subw	a4,a4,s3
  4008e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
  4008e2:	02071693          	slli	a3,a4,0x20
  4008e6:	01c6d713          	srli	a4,a3,0x1c
  4008ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4008ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4008f0:	00000717          	auipc	a4,0x0
  4008f4:	70a73823          	sd	a0,1808(a4) # 401000 <freep>
      return (void*)(p + 1);
  4008f8:	01078513          	addi	a0,a5,16
  }
}
  4008fc:	70e2                	ld	ra,56(sp)
  4008fe:	7442                	ld	s0,48(sp)
  400900:	7902                	ld	s2,32(sp)
  400902:	69e2                	ld	s3,24(sp)
  400904:	6121                	addi	sp,sp,64
  400906:	8082                	ret
  400908:	74a2                	ld	s1,40(sp)
  40090a:	6a42                	ld	s4,16(sp)
  40090c:	6aa2                	ld	s5,8(sp)
  40090e:	6b02                	ld	s6,0(sp)
  400910:	b7f5                	j	4008fc <malloc+0xdc>
