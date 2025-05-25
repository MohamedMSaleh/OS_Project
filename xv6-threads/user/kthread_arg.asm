
user/_kthread_arg:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <thread_func>:

struct arg {
  int value;
};

void thread_func(void *arg) {
  400000:	1101                	addi	sp,sp,-32
  400002:	ec06                	sd	ra,24(sp)
  400004:	e822                	sd	s0,16(sp)
  400006:	e426                	sd	s1,8(sp)
  400008:	1000                	addi	s0,sp,32
  40000a:	84aa                	mv	s1,a0
  struct arg *a = (struct arg*)arg;
  printf("Thread got arg: %d\n", a->value);
  40000c:	410c                	lw	a1,0(a0)
  40000e:	00001517          	auipc	a0,0x1
  400012:	8d250513          	addi	a0,a0,-1838 # 4008e0 <malloc+0xfa>
  400016:	716000ef          	jal	40072c <printf>
  kthread_exit(a->value + 1);
  40001a:	4088                	lw	a0,0(s1)
  40001c:	2505                	addiw	a0,a0,1
  40001e:	39a000ef          	jal	4003b8 <kthread_exit>

0000000000400022 <main>:
}

int main() {
  400022:	7179                	addi	sp,sp,-48
  400024:	f406                	sd	ra,40(sp)
  400026:	f022                	sd	s0,32(sp)
  400028:	ec26                	sd	s1,24(sp)
  40002a:	1800                	addi	s0,sp,48
  void *stack = malloc(STACK_SIZE);
  40002c:	6505                	lui	a0,0x1
  40002e:	7b8000ef          	jal	4007e6 <malloc>
  400032:	84aa                	mv	s1,a0
  struct arg a = { .value = 99 };
  // Cast function and pass pointer as stack base (demo only)
  int tid = kthread_create((void(*)())thread_func, stack, STACK_SIZE);
  400034:	6605                	lui	a2,0x1
  400036:	85aa                	mv	a1,a0
  400038:	00000517          	auipc	a0,0x0
  40003c:	fc850513          	addi	a0,a0,-56 # 400000 <thread_func>
  400040:	370000ef          	jal	4003b0 <kthread_create>
  // Place arg at bottom of stack
  *(struct arg*)stack = a;
  400044:	06300793          	li	a5,99
  400048:	c09c                	sw	a5,0(s1)
  int status = 0;
  40004a:	fc042e23          	sw	zero,-36(s0)
  kthread_join(tid, &status);
  40004e:	fdc40593          	addi	a1,s0,-36
  400052:	36e000ef          	jal	4003c0 <kthread_join>
  printf("Thread returned: %d\n", status);
  400056:	fdc42583          	lw	a1,-36(s0)
  40005a:	00001517          	auipc	a0,0x1
  40005e:	89e50513          	addi	a0,a0,-1890 # 4008f8 <malloc+0x112>
  400062:	6ca000ef          	jal	40072c <printf>
  free(stack);
  400066:	8526                	mv	a0,s1
  400068:	6f8000ef          	jal	400760 <free>
  exit(0);
  40006c:	4501                	li	a0,0
  40006e:	2a2000ef          	jal	400310 <exit>

0000000000400072 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  400072:	1141                	addi	sp,sp,-16
  400074:	e406                	sd	ra,8(sp)
  400076:	e022                	sd	s0,0(sp)
  400078:	0800                	addi	s0,sp,16
  extern int main();
  main();
  40007a:	fa9ff0ef          	jal	400022 <main>
  exit(0);
  40007e:	4501                	li	a0,0
  400080:	290000ef          	jal	400310 <exit>

0000000000400084 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400084:	1141                	addi	sp,sp,-16
  400086:	e406                	sd	ra,8(sp)
  400088:	e022                	sd	s0,0(sp)
  40008a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40008c:	87aa                	mv	a5,a0
  40008e:	0585                	addi	a1,a1,1
  400090:	0785                	addi	a5,a5,1
  400092:	fff5c703          	lbu	a4,-1(a1)
  400096:	fee78fa3          	sb	a4,-1(a5)
  40009a:	fb75                	bnez	a4,40008e <strcpy+0xa>
    ;
  return os;
}
  40009c:	60a2                	ld	ra,8(sp)
  40009e:	6402                	ld	s0,0(sp)
  4000a0:	0141                	addi	sp,sp,16
  4000a2:	8082                	ret

00000000004000a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4000a4:	1141                	addi	sp,sp,-16
  4000a6:	e406                	sd	ra,8(sp)
  4000a8:	e022                	sd	s0,0(sp)
  4000aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4000ac:	00054783          	lbu	a5,0(a0)
  4000b0:	cb91                	beqz	a5,4000c4 <strcmp+0x20>
  4000b2:	0005c703          	lbu	a4,0(a1)
  4000b6:	00f71763          	bne	a4,a5,4000c4 <strcmp+0x20>
    p++, q++;
  4000ba:	0505                	addi	a0,a0,1
  4000bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4000be:	00054783          	lbu	a5,0(a0)
  4000c2:	fbe5                	bnez	a5,4000b2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4000c4:	0005c503          	lbu	a0,0(a1)
}
  4000c8:	40a7853b          	subw	a0,a5,a0
  4000cc:	60a2                	ld	ra,8(sp)
  4000ce:	6402                	ld	s0,0(sp)
  4000d0:	0141                	addi	sp,sp,16
  4000d2:	8082                	ret

00000000004000d4 <strlen>:

uint
strlen(const char *s)
{
  4000d4:	1141                	addi	sp,sp,-16
  4000d6:	e406                	sd	ra,8(sp)
  4000d8:	e022                	sd	s0,0(sp)
  4000da:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4000dc:	00054783          	lbu	a5,0(a0)
  4000e0:	cf99                	beqz	a5,4000fe <strlen+0x2a>
  4000e2:	0505                	addi	a0,a0,1
  4000e4:	87aa                	mv	a5,a0
  4000e6:	86be                	mv	a3,a5
  4000e8:	0785                	addi	a5,a5,1
  4000ea:	fff7c703          	lbu	a4,-1(a5)
  4000ee:	ff65                	bnez	a4,4000e6 <strlen+0x12>
  4000f0:	40a6853b          	subw	a0,a3,a0
  4000f4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4000f6:	60a2                	ld	ra,8(sp)
  4000f8:	6402                	ld	s0,0(sp)
  4000fa:	0141                	addi	sp,sp,16
  4000fc:	8082                	ret
  for(n = 0; s[n]; n++)
  4000fe:	4501                	li	a0,0
  400100:	bfdd                	j	4000f6 <strlen+0x22>

0000000000400102 <memset>:

void*
memset(void *dst, int c, uint n)
{
  400102:	1141                	addi	sp,sp,-16
  400104:	e406                	sd	ra,8(sp)
  400106:	e022                	sd	s0,0(sp)
  400108:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  40010a:	ca19                	beqz	a2,400120 <memset+0x1e>
  40010c:	87aa                	mv	a5,a0
  40010e:	1602                	slli	a2,a2,0x20
  400110:	9201                	srli	a2,a2,0x20
  400112:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400116:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  40011a:	0785                	addi	a5,a5,1
  40011c:	fee79de3          	bne	a5,a4,400116 <memset+0x14>
  }
  return dst;
}
  400120:	60a2                	ld	ra,8(sp)
  400122:	6402                	ld	s0,0(sp)
  400124:	0141                	addi	sp,sp,16
  400126:	8082                	ret

0000000000400128 <strchr>:

char*
strchr(const char *s, char c)
{
  400128:	1141                	addi	sp,sp,-16
  40012a:	e406                	sd	ra,8(sp)
  40012c:	e022                	sd	s0,0(sp)
  40012e:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400130:	00054783          	lbu	a5,0(a0)
  400134:	cf81                	beqz	a5,40014c <strchr+0x24>
    if(*s == c)
  400136:	00f58763          	beq	a1,a5,400144 <strchr+0x1c>
  for(; *s; s++)
  40013a:	0505                	addi	a0,a0,1
  40013c:	00054783          	lbu	a5,0(a0)
  400140:	fbfd                	bnez	a5,400136 <strchr+0xe>
      return (char*)s;
  return 0;
  400142:	4501                	li	a0,0
}
  400144:	60a2                	ld	ra,8(sp)
  400146:	6402                	ld	s0,0(sp)
  400148:	0141                	addi	sp,sp,16
  40014a:	8082                	ret
  return 0;
  40014c:	4501                	li	a0,0
  40014e:	bfdd                	j	400144 <strchr+0x1c>

0000000000400150 <gets>:

char*
gets(char *buf, int max)
{
  400150:	7159                	addi	sp,sp,-112
  400152:	f486                	sd	ra,104(sp)
  400154:	f0a2                	sd	s0,96(sp)
  400156:	eca6                	sd	s1,88(sp)
  400158:	e8ca                	sd	s2,80(sp)
  40015a:	e4ce                	sd	s3,72(sp)
  40015c:	e0d2                	sd	s4,64(sp)
  40015e:	fc56                	sd	s5,56(sp)
  400160:	f85a                	sd	s6,48(sp)
  400162:	f45e                	sd	s7,40(sp)
  400164:	f062                	sd	s8,32(sp)
  400166:	ec66                	sd	s9,24(sp)
  400168:	e86a                	sd	s10,16(sp)
  40016a:	1880                	addi	s0,sp,112
  40016c:	8caa                	mv	s9,a0
  40016e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400170:	892a                	mv	s2,a0
  400172:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400174:	f9f40b13          	addi	s6,s0,-97
  400178:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  40017a:	4ba9                	li	s7,10
  40017c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  40017e:	8d26                	mv	s10,s1
  400180:	0014899b          	addiw	s3,s1,1
  400184:	84ce                	mv	s1,s3
  400186:	0349d563          	bge	s3,s4,4001b0 <gets+0x60>
    cc = read(0, &c, 1);
  40018a:	8656                	mv	a2,s5
  40018c:	85da                	mv	a1,s6
  40018e:	4501                	li	a0,0
  400190:	198000ef          	jal	400328 <read>
    if(cc < 1)
  400194:	00a05e63          	blez	a0,4001b0 <gets+0x60>
    buf[i++] = c;
  400198:	f9f44783          	lbu	a5,-97(s0)
  40019c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  4001a0:	01778763          	beq	a5,s7,4001ae <gets+0x5e>
  4001a4:	0905                	addi	s2,s2,1
  4001a6:	fd879ce3          	bne	a5,s8,40017e <gets+0x2e>
    buf[i++] = c;
  4001aa:	8d4e                	mv	s10,s3
  4001ac:	a011                	j	4001b0 <gets+0x60>
  4001ae:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  4001b0:	9d66                	add	s10,s10,s9
  4001b2:	000d0023          	sb	zero,0(s10)
  return buf;
}
  4001b6:	8566                	mv	a0,s9
  4001b8:	70a6                	ld	ra,104(sp)
  4001ba:	7406                	ld	s0,96(sp)
  4001bc:	64e6                	ld	s1,88(sp)
  4001be:	6946                	ld	s2,80(sp)
  4001c0:	69a6                	ld	s3,72(sp)
  4001c2:	6a06                	ld	s4,64(sp)
  4001c4:	7ae2                	ld	s5,56(sp)
  4001c6:	7b42                	ld	s6,48(sp)
  4001c8:	7ba2                	ld	s7,40(sp)
  4001ca:	7c02                	ld	s8,32(sp)
  4001cc:	6ce2                	ld	s9,24(sp)
  4001ce:	6d42                	ld	s10,16(sp)
  4001d0:	6165                	addi	sp,sp,112
  4001d2:	8082                	ret

00000000004001d4 <stat>:

int
stat(const char *n, struct stat *st)
{
  4001d4:	1101                	addi	sp,sp,-32
  4001d6:	ec06                	sd	ra,24(sp)
  4001d8:	e822                	sd	s0,16(sp)
  4001da:	e04a                	sd	s2,0(sp)
  4001dc:	1000                	addi	s0,sp,32
  4001de:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4001e0:	4581                	li	a1,0
  4001e2:	16e000ef          	jal	400350 <open>
  if(fd < 0)
  4001e6:	02054263          	bltz	a0,40020a <stat+0x36>
  4001ea:	e426                	sd	s1,8(sp)
  4001ec:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4001ee:	85ca                	mv	a1,s2
  4001f0:	178000ef          	jal	400368 <fstat>
  4001f4:	892a                	mv	s2,a0
  close(fd);
  4001f6:	8526                	mv	a0,s1
  4001f8:	140000ef          	jal	400338 <close>
  return r;
  4001fc:	64a2                	ld	s1,8(sp)
}
  4001fe:	854a                	mv	a0,s2
  400200:	60e2                	ld	ra,24(sp)
  400202:	6442                	ld	s0,16(sp)
  400204:	6902                	ld	s2,0(sp)
  400206:	6105                	addi	sp,sp,32
  400208:	8082                	ret
    return -1;
  40020a:	597d                	li	s2,-1
  40020c:	bfcd                	j	4001fe <stat+0x2a>

000000000040020e <atoi>:

int
atoi(const char *s)
{
  40020e:	1141                	addi	sp,sp,-16
  400210:	e406                	sd	ra,8(sp)
  400212:	e022                	sd	s0,0(sp)
  400214:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400216:	00054683          	lbu	a3,0(a0)
  40021a:	fd06879b          	addiw	a5,a3,-48
  40021e:	0ff7f793          	zext.b	a5,a5
  400222:	4625                	li	a2,9
  400224:	02f66963          	bltu	a2,a5,400256 <atoi+0x48>
  400228:	872a                	mv	a4,a0
  n = 0;
  40022a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  40022c:	0705                	addi	a4,a4,1
  40022e:	0025179b          	slliw	a5,a0,0x2
  400232:	9fa9                	addw	a5,a5,a0
  400234:	0017979b          	slliw	a5,a5,0x1
  400238:	9fb5                	addw	a5,a5,a3
  40023a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  40023e:	00074683          	lbu	a3,0(a4)
  400242:	fd06879b          	addiw	a5,a3,-48
  400246:	0ff7f793          	zext.b	a5,a5
  40024a:	fef671e3          	bgeu	a2,a5,40022c <atoi+0x1e>
  return n;
}
  40024e:	60a2                	ld	ra,8(sp)
  400250:	6402                	ld	s0,0(sp)
  400252:	0141                	addi	sp,sp,16
  400254:	8082                	ret
  n = 0;
  400256:	4501                	li	a0,0
  400258:	bfdd                	j	40024e <atoi+0x40>

000000000040025a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  40025a:	1141                	addi	sp,sp,-16
  40025c:	e406                	sd	ra,8(sp)
  40025e:	e022                	sd	s0,0(sp)
  400260:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400262:	02b57563          	bgeu	a0,a1,40028c <memmove+0x32>
    while(n-- > 0)
  400266:	00c05f63          	blez	a2,400284 <memmove+0x2a>
  40026a:	1602                	slli	a2,a2,0x20
  40026c:	9201                	srli	a2,a2,0x20
  40026e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400272:	872a                	mv	a4,a0
      *dst++ = *src++;
  400274:	0585                	addi	a1,a1,1
  400276:	0705                	addi	a4,a4,1
  400278:	fff5c683          	lbu	a3,-1(a1)
  40027c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400280:	fee79ae3          	bne	a5,a4,400274 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400284:	60a2                	ld	ra,8(sp)
  400286:	6402                	ld	s0,0(sp)
  400288:	0141                	addi	sp,sp,16
  40028a:	8082                	ret
    dst += n;
  40028c:	00c50733          	add	a4,a0,a2
    src += n;
  400290:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400292:	fec059e3          	blez	a2,400284 <memmove+0x2a>
  400296:	fff6079b          	addiw	a5,a2,-1 # fff <thread_func-0x3ff001>
  40029a:	1782                	slli	a5,a5,0x20
  40029c:	9381                	srli	a5,a5,0x20
  40029e:	fff7c793          	not	a5,a5
  4002a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  4002a4:	15fd                	addi	a1,a1,-1
  4002a6:	177d                	addi	a4,a4,-1
  4002a8:	0005c683          	lbu	a3,0(a1)
  4002ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  4002b0:	fef71ae3          	bne	a4,a5,4002a4 <memmove+0x4a>
  4002b4:	bfc1                	j	400284 <memmove+0x2a>

00000000004002b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  4002b6:	1141                	addi	sp,sp,-16
  4002b8:	e406                	sd	ra,8(sp)
  4002ba:	e022                	sd	s0,0(sp)
  4002bc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4002be:	ca0d                	beqz	a2,4002f0 <memcmp+0x3a>
  4002c0:	fff6069b          	addiw	a3,a2,-1
  4002c4:	1682                	slli	a3,a3,0x20
  4002c6:	9281                	srli	a3,a3,0x20
  4002c8:	0685                	addi	a3,a3,1
  4002ca:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4002cc:	00054783          	lbu	a5,0(a0)
  4002d0:	0005c703          	lbu	a4,0(a1)
  4002d4:	00e79863          	bne	a5,a4,4002e4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4002d8:	0505                	addi	a0,a0,1
    p2++;
  4002da:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4002dc:	fed518e3          	bne	a0,a3,4002cc <memcmp+0x16>
  }
  return 0;
  4002e0:	4501                	li	a0,0
  4002e2:	a019                	j	4002e8 <memcmp+0x32>
      return *p1 - *p2;
  4002e4:	40e7853b          	subw	a0,a5,a4
}
  4002e8:	60a2                	ld	ra,8(sp)
  4002ea:	6402                	ld	s0,0(sp)
  4002ec:	0141                	addi	sp,sp,16
  4002ee:	8082                	ret
  return 0;
  4002f0:	4501                	li	a0,0
  4002f2:	bfdd                	j	4002e8 <memcmp+0x32>

00000000004002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4002f4:	1141                	addi	sp,sp,-16
  4002f6:	e406                	sd	ra,8(sp)
  4002f8:	e022                	sd	s0,0(sp)
  4002fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4002fc:	f5fff0ef          	jal	40025a <memmove>
}
  400300:	60a2                	ld	ra,8(sp)
  400302:	6402                	ld	s0,0(sp)
  400304:	0141                	addi	sp,sp,16
  400306:	8082                	ret

0000000000400308 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  400308:	4885                	li	a7,1
 ecall
  40030a:	00000073          	ecall
 ret
  40030e:	8082                	ret

0000000000400310 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400310:	4889                	li	a7,2
 ecall
  400312:	00000073          	ecall
 ret
  400316:	8082                	ret

0000000000400318 <wait>:
.global wait
wait:
 li a7, SYS_wait
  400318:	488d                	li	a7,3
 ecall
  40031a:	00000073          	ecall
 ret
  40031e:	8082                	ret

0000000000400320 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400320:	4891                	li	a7,4
 ecall
  400322:	00000073          	ecall
 ret
  400326:	8082                	ret

0000000000400328 <read>:
.global read
read:
 li a7, SYS_read
  400328:	4895                	li	a7,5
 ecall
  40032a:	00000073          	ecall
 ret
  40032e:	8082                	ret

0000000000400330 <write>:
.global write
write:
 li a7, SYS_write
  400330:	48c1                	li	a7,16
 ecall
  400332:	00000073          	ecall
 ret
  400336:	8082                	ret

0000000000400338 <close>:
.global close
close:
 li a7, SYS_close
  400338:	48d5                	li	a7,21
 ecall
  40033a:	00000073          	ecall
 ret
  40033e:	8082                	ret

0000000000400340 <kill>:
.global kill
kill:
 li a7, SYS_kill
  400340:	4899                	li	a7,6
 ecall
  400342:	00000073          	ecall
 ret
  400346:	8082                	ret

0000000000400348 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400348:	489d                	li	a7,7
 ecall
  40034a:	00000073          	ecall
 ret
  40034e:	8082                	ret

0000000000400350 <open>:
.global open
open:
 li a7, SYS_open
  400350:	48bd                	li	a7,15
 ecall
  400352:	00000073          	ecall
 ret
  400356:	8082                	ret

0000000000400358 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400358:	48c5                	li	a7,17
 ecall
  40035a:	00000073          	ecall
 ret
  40035e:	8082                	ret

0000000000400360 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400360:	48c9                	li	a7,18
 ecall
  400362:	00000073          	ecall
 ret
  400366:	8082                	ret

0000000000400368 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  400368:	48a1                	li	a7,8
 ecall
  40036a:	00000073          	ecall
 ret
  40036e:	8082                	ret

0000000000400370 <link>:
.global link
link:
 li a7, SYS_link
  400370:	48cd                	li	a7,19
 ecall
  400372:	00000073          	ecall
 ret
  400376:	8082                	ret

0000000000400378 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400378:	48d1                	li	a7,20
 ecall
  40037a:	00000073          	ecall
 ret
  40037e:	8082                	ret

0000000000400380 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400380:	48a5                	li	a7,9
 ecall
  400382:	00000073          	ecall
 ret
  400386:	8082                	ret

0000000000400388 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400388:	48a9                	li	a7,10
 ecall
  40038a:	00000073          	ecall
 ret
  40038e:	8082                	ret

0000000000400390 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400390:	48ad                	li	a7,11
 ecall
  400392:	00000073          	ecall
 ret
  400396:	8082                	ret

0000000000400398 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  400398:	48b1                	li	a7,12
 ecall
  40039a:	00000073          	ecall
 ret
  40039e:	8082                	ret

00000000004003a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  4003a0:	48b5                	li	a7,13
 ecall
  4003a2:	00000073          	ecall
 ret
  4003a6:	8082                	ret

00000000004003a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  4003a8:	48b9                	li	a7,14
 ecall
  4003aa:	00000073          	ecall
 ret
  4003ae:	8082                	ret

00000000004003b0 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  4003b0:	48d9                	li	a7,22
 ecall
  4003b2:	00000073          	ecall
 ret
  4003b6:	8082                	ret

00000000004003b8 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  4003b8:	48dd                	li	a7,23
 ecall
  4003ba:	00000073          	ecall
 ret
  4003be:	8082                	ret

00000000004003c0 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4003c0:	48e1                	li	a7,24
 ecall
  4003c2:	00000073          	ecall
 ret
  4003c6:	8082                	ret

00000000004003c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4003c8:	1101                	addi	sp,sp,-32
  4003ca:	ec06                	sd	ra,24(sp)
  4003cc:	e822                	sd	s0,16(sp)
  4003ce:	1000                	addi	s0,sp,32
  4003d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4003d4:	4605                	li	a2,1
  4003d6:	fef40593          	addi	a1,s0,-17
  4003da:	f57ff0ef          	jal	400330 <write>
}
  4003de:	60e2                	ld	ra,24(sp)
  4003e0:	6442                	ld	s0,16(sp)
  4003e2:	6105                	addi	sp,sp,32
  4003e4:	8082                	ret

00000000004003e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4003e6:	7139                	addi	sp,sp,-64
  4003e8:	fc06                	sd	ra,56(sp)
  4003ea:	f822                	sd	s0,48(sp)
  4003ec:	f426                	sd	s1,40(sp)
  4003ee:	f04a                	sd	s2,32(sp)
  4003f0:	ec4e                	sd	s3,24(sp)
  4003f2:	0080                	addi	s0,sp,64
  4003f4:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4003f6:	c299                	beqz	a3,4003fc <printint+0x16>
  4003f8:	0605ce63          	bltz	a1,400474 <printint+0x8e>
  neg = 0;
  4003fc:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4003fe:	fc040313          	addi	t1,s0,-64
  neg = 0;
  400402:	869a                	mv	a3,t1
  i = 0;
  400404:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  400406:	00000817          	auipc	a6,0x0
  40040a:	51280813          	addi	a6,a6,1298 # 400918 <digits>
  40040e:	88be                	mv	a7,a5
  400410:	0017851b          	addiw	a0,a5,1
  400414:	87aa                	mv	a5,a0
  400416:	02c5f73b          	remuw	a4,a1,a2
  40041a:	1702                	slli	a4,a4,0x20
  40041c:	9301                	srli	a4,a4,0x20
  40041e:	9742                	add	a4,a4,a6
  400420:	00074703          	lbu	a4,0(a4)
  400424:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400428:	872e                	mv	a4,a1
  40042a:	02c5d5bb          	divuw	a1,a1,a2
  40042e:	0685                	addi	a3,a3,1
  400430:	fcc77fe3          	bgeu	a4,a2,40040e <printint+0x28>
  if(neg)
  400434:	000e0c63          	beqz	t3,40044c <printint+0x66>
    buf[i++] = '-';
  400438:	fd050793          	addi	a5,a0,-48
  40043c:	00878533          	add	a0,a5,s0
  400440:	02d00793          	li	a5,45
  400444:	fef50823          	sb	a5,-16(a0)
  400448:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  40044c:	fff7899b          	addiw	s3,a5,-1
  400450:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400454:	fff4c583          	lbu	a1,-1(s1)
  400458:	854a                	mv	a0,s2
  40045a:	f6fff0ef          	jal	4003c8 <putc>
  while(--i >= 0)
  40045e:	39fd                	addiw	s3,s3,-1
  400460:	14fd                	addi	s1,s1,-1
  400462:	fe09d9e3          	bgez	s3,400454 <printint+0x6e>
}
  400466:	70e2                	ld	ra,56(sp)
  400468:	7442                	ld	s0,48(sp)
  40046a:	74a2                	ld	s1,40(sp)
  40046c:	7902                	ld	s2,32(sp)
  40046e:	69e2                	ld	s3,24(sp)
  400470:	6121                	addi	sp,sp,64
  400472:	8082                	ret
    x = -xx;
  400474:	40b005bb          	negw	a1,a1
    neg = 1;
  400478:	4e05                	li	t3,1
    x = -xx;
  40047a:	b751                	j	4003fe <printint+0x18>

000000000040047c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  40047c:	711d                	addi	sp,sp,-96
  40047e:	ec86                	sd	ra,88(sp)
  400480:	e8a2                	sd	s0,80(sp)
  400482:	e4a6                	sd	s1,72(sp)
  400484:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400486:	0005c483          	lbu	s1,0(a1)
  40048a:	26048663          	beqz	s1,4006f6 <vprintf+0x27a>
  40048e:	e0ca                	sd	s2,64(sp)
  400490:	fc4e                	sd	s3,56(sp)
  400492:	f852                	sd	s4,48(sp)
  400494:	f456                	sd	s5,40(sp)
  400496:	f05a                	sd	s6,32(sp)
  400498:	ec5e                	sd	s7,24(sp)
  40049a:	e862                	sd	s8,16(sp)
  40049c:	e466                	sd	s9,8(sp)
  40049e:	8b2a                	mv	s6,a0
  4004a0:	8a2e                	mv	s4,a1
  4004a2:	8bb2                	mv	s7,a2
  state = 0;
  4004a4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  4004a6:	4901                	li	s2,0
  4004a8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  4004aa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  4004ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  4004b2:	06c00c93          	li	s9,108
  4004b6:	a00d                	j	4004d8 <vprintf+0x5c>
        putc(fd, c0);
  4004b8:	85a6                	mv	a1,s1
  4004ba:	855a                	mv	a0,s6
  4004bc:	f0dff0ef          	jal	4003c8 <putc>
  4004c0:	a019                	j	4004c6 <vprintf+0x4a>
    } else if(state == '%'){
  4004c2:	03598363          	beq	s3,s5,4004e8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4004c6:	0019079b          	addiw	a5,s2,1
  4004ca:	893e                	mv	s2,a5
  4004cc:	873e                	mv	a4,a5
  4004ce:	97d2                	add	a5,a5,s4
  4004d0:	0007c483          	lbu	s1,0(a5)
  4004d4:	20048963          	beqz	s1,4006e6 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4004d8:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4004dc:	fe0993e3          	bnez	s3,4004c2 <vprintf+0x46>
      if(c0 == '%'){
  4004e0:	fd579ce3          	bne	a5,s5,4004b8 <vprintf+0x3c>
        state = '%';
  4004e4:	89be                	mv	s3,a5
  4004e6:	b7c5                	j	4004c6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4004e8:	00ea06b3          	add	a3,s4,a4
  4004ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4004f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4004f2:	c681                	beqz	a3,4004fa <vprintf+0x7e>
  4004f4:	9752                	add	a4,a4,s4
  4004f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4004fa:	03878e63          	beq	a5,s8,400536 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4004fe:	05978863          	beq	a5,s9,40054e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  400502:	07500713          	li	a4,117
  400506:	0ee78263          	beq	a5,a4,4005ea <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  40050a:	07800713          	li	a4,120
  40050e:	12e78463          	beq	a5,a4,400636 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400512:	07000713          	li	a4,112
  400516:	14e78963          	beq	a5,a4,400668 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  40051a:	07300713          	li	a4,115
  40051e:	18e78863          	beq	a5,a4,4006ae <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400522:	02500713          	li	a4,37
  400526:	04e79463          	bne	a5,a4,40056e <vprintf+0xf2>
        putc(fd, '%');
  40052a:	85ba                	mv	a1,a4
  40052c:	855a                	mv	a0,s6
  40052e:	e9bff0ef          	jal	4003c8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400532:	4981                	li	s3,0
  400534:	bf49                	j	4004c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400536:	008b8493          	addi	s1,s7,8
  40053a:	4685                	li	a3,1
  40053c:	4629                	li	a2,10
  40053e:	000ba583          	lw	a1,0(s7)
  400542:	855a                	mv	a0,s6
  400544:	ea3ff0ef          	jal	4003e6 <printint>
  400548:	8ba6                	mv	s7,s1
      state = 0;
  40054a:	4981                	li	s3,0
  40054c:	bfad                	j	4004c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  40054e:	06400793          	li	a5,100
  400552:	02f68963          	beq	a3,a5,400584 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400556:	06c00793          	li	a5,108
  40055a:	04f68263          	beq	a3,a5,40059e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  40055e:	07500793          	li	a5,117
  400562:	0af68063          	beq	a3,a5,400602 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400566:	07800793          	li	a5,120
  40056a:	0ef68263          	beq	a3,a5,40064e <vprintf+0x1d2>
        putc(fd, '%');
  40056e:	02500593          	li	a1,37
  400572:	855a                	mv	a0,s6
  400574:	e55ff0ef          	jal	4003c8 <putc>
        putc(fd, c0);
  400578:	85a6                	mv	a1,s1
  40057a:	855a                	mv	a0,s6
  40057c:	e4dff0ef          	jal	4003c8 <putc>
      state = 0;
  400580:	4981                	li	s3,0
  400582:	b791                	j	4004c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400584:	008b8493          	addi	s1,s7,8
  400588:	4685                	li	a3,1
  40058a:	4629                	li	a2,10
  40058c:	000ba583          	lw	a1,0(s7)
  400590:	855a                	mv	a0,s6
  400592:	e55ff0ef          	jal	4003e6 <printint>
        i += 1;
  400596:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  400598:	8ba6                	mv	s7,s1
      state = 0;
  40059a:	4981                	li	s3,0
        i += 1;
  40059c:	b72d                	j	4004c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  40059e:	06400793          	li	a5,100
  4005a2:	02f60763          	beq	a2,a5,4005d0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  4005a6:	07500793          	li	a5,117
  4005aa:	06f60963          	beq	a2,a5,40061c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  4005ae:	07800793          	li	a5,120
  4005b2:	faf61ee3          	bne	a2,a5,40056e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005b6:	008b8493          	addi	s1,s7,8
  4005ba:	4681                	li	a3,0
  4005bc:	4641                	li	a2,16
  4005be:	000ba583          	lw	a1,0(s7)
  4005c2:	855a                	mv	a0,s6
  4005c4:	e23ff0ef          	jal	4003e6 <printint>
        i += 2;
  4005c8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005ca:	8ba6                	mv	s7,s1
      state = 0;
  4005cc:	4981                	li	s3,0
        i += 2;
  4005ce:	bde5                	j	4004c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005d0:	008b8493          	addi	s1,s7,8
  4005d4:	4685                	li	a3,1
  4005d6:	4629                	li	a2,10
  4005d8:	000ba583          	lw	a1,0(s7)
  4005dc:	855a                	mv	a0,s6
  4005de:	e09ff0ef          	jal	4003e6 <printint>
        i += 2;
  4005e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005e4:	8ba6                	mv	s7,s1
      state = 0;
  4005e6:	4981                	li	s3,0
        i += 2;
  4005e8:	bdf9                	j	4004c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4005ea:	008b8493          	addi	s1,s7,8
  4005ee:	4681                	li	a3,0
  4005f0:	4629                	li	a2,10
  4005f2:	000ba583          	lw	a1,0(s7)
  4005f6:	855a                	mv	a0,s6
  4005f8:	defff0ef          	jal	4003e6 <printint>
  4005fc:	8ba6                	mv	s7,s1
      state = 0;
  4005fe:	4981                	li	s3,0
  400600:	b5d9                	j	4004c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400602:	008b8493          	addi	s1,s7,8
  400606:	4681                	li	a3,0
  400608:	4629                	li	a2,10
  40060a:	000ba583          	lw	a1,0(s7)
  40060e:	855a                	mv	a0,s6
  400610:	dd7ff0ef          	jal	4003e6 <printint>
        i += 1;
  400614:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400616:	8ba6                	mv	s7,s1
      state = 0;
  400618:	4981                	li	s3,0
        i += 1;
  40061a:	b575                	j	4004c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  40061c:	008b8493          	addi	s1,s7,8
  400620:	4681                	li	a3,0
  400622:	4629                	li	a2,10
  400624:	000ba583          	lw	a1,0(s7)
  400628:	855a                	mv	a0,s6
  40062a:	dbdff0ef          	jal	4003e6 <printint>
        i += 2;
  40062e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400630:	8ba6                	mv	s7,s1
      state = 0;
  400632:	4981                	li	s3,0
        i += 2;
  400634:	bd49                	j	4004c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400636:	008b8493          	addi	s1,s7,8
  40063a:	4681                	li	a3,0
  40063c:	4641                	li	a2,16
  40063e:	000ba583          	lw	a1,0(s7)
  400642:	855a                	mv	a0,s6
  400644:	da3ff0ef          	jal	4003e6 <printint>
  400648:	8ba6                	mv	s7,s1
      state = 0;
  40064a:	4981                	li	s3,0
  40064c:	bdad                	j	4004c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  40064e:	008b8493          	addi	s1,s7,8
  400652:	4681                	li	a3,0
  400654:	4641                	li	a2,16
  400656:	000ba583          	lw	a1,0(s7)
  40065a:	855a                	mv	a0,s6
  40065c:	d8bff0ef          	jal	4003e6 <printint>
        i += 1;
  400660:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400662:	8ba6                	mv	s7,s1
      state = 0;
  400664:	4981                	li	s3,0
        i += 1;
  400666:	b585                	j	4004c6 <vprintf+0x4a>
  400668:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  40066a:	008b8d13          	addi	s10,s7,8
  40066e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400672:	03000593          	li	a1,48
  400676:	855a                	mv	a0,s6
  400678:	d51ff0ef          	jal	4003c8 <putc>
  putc(fd, 'x');
  40067c:	07800593          	li	a1,120
  400680:	855a                	mv	a0,s6
  400682:	d47ff0ef          	jal	4003c8 <putc>
  400686:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400688:	00000b97          	auipc	s7,0x0
  40068c:	290b8b93          	addi	s7,s7,656 # 400918 <digits>
  400690:	03c9d793          	srli	a5,s3,0x3c
  400694:	97de                	add	a5,a5,s7
  400696:	0007c583          	lbu	a1,0(a5)
  40069a:	855a                	mv	a0,s6
  40069c:	d2dff0ef          	jal	4003c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  4006a0:	0992                	slli	s3,s3,0x4
  4006a2:	34fd                	addiw	s1,s1,-1
  4006a4:	f4f5                	bnez	s1,400690 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  4006a6:	8bea                	mv	s7,s10
      state = 0;
  4006a8:	4981                	li	s3,0
  4006aa:	6d02                	ld	s10,0(sp)
  4006ac:	bd29                	j	4004c6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  4006ae:	008b8993          	addi	s3,s7,8
  4006b2:	000bb483          	ld	s1,0(s7)
  4006b6:	cc91                	beqz	s1,4006d2 <vprintf+0x256>
        for(; *s; s++)
  4006b8:	0004c583          	lbu	a1,0(s1)
  4006bc:	c195                	beqz	a1,4006e0 <vprintf+0x264>
          putc(fd, *s);
  4006be:	855a                	mv	a0,s6
  4006c0:	d09ff0ef          	jal	4003c8 <putc>
        for(; *s; s++)
  4006c4:	0485                	addi	s1,s1,1
  4006c6:	0004c583          	lbu	a1,0(s1)
  4006ca:	f9f5                	bnez	a1,4006be <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006cc:	8bce                	mv	s7,s3
      state = 0;
  4006ce:	4981                	li	s3,0
  4006d0:	bbdd                	j	4004c6 <vprintf+0x4a>
          s = "(null)";
  4006d2:	00000497          	auipc	s1,0x0
  4006d6:	23e48493          	addi	s1,s1,574 # 400910 <malloc+0x12a>
        for(; *s; s++)
  4006da:	02800593          	li	a1,40
  4006de:	b7c5                	j	4006be <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006e0:	8bce                	mv	s7,s3
      state = 0;
  4006e2:	4981                	li	s3,0
  4006e4:	b3cd                	j	4004c6 <vprintf+0x4a>
  4006e6:	6906                	ld	s2,64(sp)
  4006e8:	79e2                	ld	s3,56(sp)
  4006ea:	7a42                	ld	s4,48(sp)
  4006ec:	7aa2                	ld	s5,40(sp)
  4006ee:	7b02                	ld	s6,32(sp)
  4006f0:	6be2                	ld	s7,24(sp)
  4006f2:	6c42                	ld	s8,16(sp)
  4006f4:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4006f6:	60e6                	ld	ra,88(sp)
  4006f8:	6446                	ld	s0,80(sp)
  4006fa:	64a6                	ld	s1,72(sp)
  4006fc:	6125                	addi	sp,sp,96
  4006fe:	8082                	ret

0000000000400700 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  400700:	715d                	addi	sp,sp,-80
  400702:	ec06                	sd	ra,24(sp)
  400704:	e822                	sd	s0,16(sp)
  400706:	1000                	addi	s0,sp,32
  400708:	e010                	sd	a2,0(s0)
  40070a:	e414                	sd	a3,8(s0)
  40070c:	e818                	sd	a4,16(s0)
  40070e:	ec1c                	sd	a5,24(s0)
  400710:	03043023          	sd	a6,32(s0)
  400714:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  400718:	8622                	mv	a2,s0
  40071a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  40071e:	d5fff0ef          	jal	40047c <vprintf>
  return 0;
}
  400722:	4501                	li	a0,0
  400724:	60e2                	ld	ra,24(sp)
  400726:	6442                	ld	s0,16(sp)
  400728:	6161                	addi	sp,sp,80
  40072a:	8082                	ret

000000000040072c <printf>:

int
printf(const char *fmt, ...)
{
  40072c:	711d                	addi	sp,sp,-96
  40072e:	ec06                	sd	ra,24(sp)
  400730:	e822                	sd	s0,16(sp)
  400732:	1000                	addi	s0,sp,32
  400734:	e40c                	sd	a1,8(s0)
  400736:	e810                	sd	a2,16(s0)
  400738:	ec14                	sd	a3,24(s0)
  40073a:	f018                	sd	a4,32(s0)
  40073c:	f41c                	sd	a5,40(s0)
  40073e:	03043823          	sd	a6,48(s0)
  400742:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400746:	00840613          	addi	a2,s0,8
  40074a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  40074e:	85aa                	mv	a1,a0
  400750:	4505                	li	a0,1
  400752:	d2bff0ef          	jal	40047c <vprintf>
  return 0;
}
  400756:	4501                	li	a0,0
  400758:	60e2                	ld	ra,24(sp)
  40075a:	6442                	ld	s0,16(sp)
  40075c:	6125                	addi	sp,sp,96
  40075e:	8082                	ret

0000000000400760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  400760:	1141                	addi	sp,sp,-16
  400762:	e406                	sd	ra,8(sp)
  400764:	e022                	sd	s0,0(sp)
  400766:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  400768:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40076c:	00001797          	auipc	a5,0x1
  400770:	8947b783          	ld	a5,-1900(a5) # 401000 <freep>
  400774:	a02d                	j	40079e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400776:	4618                	lw	a4,8(a2)
  400778:	9f2d                	addw	a4,a4,a1
  40077a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  40077e:	6398                	ld	a4,0(a5)
  400780:	6310                	ld	a2,0(a4)
  400782:	a83d                	j	4007c0 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400784:	ff852703          	lw	a4,-8(a0)
  400788:	9f31                	addw	a4,a4,a2
  40078a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  40078c:	ff053683          	ld	a3,-16(a0)
  400790:	a091                	j	4007d4 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400792:	6398                	ld	a4,0(a5)
  400794:	00e7e463          	bltu	a5,a4,40079c <free+0x3c>
  400798:	00e6ea63          	bltu	a3,a4,4007ac <free+0x4c>
{
  40079c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40079e:	fed7fae3          	bgeu	a5,a3,400792 <free+0x32>
  4007a2:	6398                	ld	a4,0(a5)
  4007a4:	00e6e463          	bltu	a3,a4,4007ac <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4007a8:	fee7eae3          	bltu	a5,a4,40079c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4007ac:	ff852583          	lw	a1,-8(a0)
  4007b0:	6390                	ld	a2,0(a5)
  4007b2:	02059813          	slli	a6,a1,0x20
  4007b6:	01c85713          	srli	a4,a6,0x1c
  4007ba:	9736                	add	a4,a4,a3
  4007bc:	fae60de3          	beq	a2,a4,400776 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4007c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4007c4:	4790                	lw	a2,8(a5)
  4007c6:	02061593          	slli	a1,a2,0x20
  4007ca:	01c5d713          	srli	a4,a1,0x1c
  4007ce:	973e                	add	a4,a4,a5
  4007d0:	fae68ae3          	beq	a3,a4,400784 <free+0x24>
    p->s.ptr = bp->s.ptr;
  4007d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4007d6:	00001717          	auipc	a4,0x1
  4007da:	82f73523          	sd	a5,-2006(a4) # 401000 <freep>
}
  4007de:	60a2                	ld	ra,8(sp)
  4007e0:	6402                	ld	s0,0(sp)
  4007e2:	0141                	addi	sp,sp,16
  4007e4:	8082                	ret

00000000004007e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4007e6:	7139                	addi	sp,sp,-64
  4007e8:	fc06                	sd	ra,56(sp)
  4007ea:	f822                	sd	s0,48(sp)
  4007ec:	f04a                	sd	s2,32(sp)
  4007ee:	ec4e                	sd	s3,24(sp)
  4007f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4007f2:	02051993          	slli	s3,a0,0x20
  4007f6:	0209d993          	srli	s3,s3,0x20
  4007fa:	09bd                	addi	s3,s3,15
  4007fc:	0049d993          	srli	s3,s3,0x4
  400800:	2985                	addiw	s3,s3,1
  400802:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  400804:	00000517          	auipc	a0,0x0
  400808:	7fc53503          	ld	a0,2044(a0) # 401000 <freep>
  40080c:	c905                	beqz	a0,40083c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  40080e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400810:	4798                	lw	a4,8(a5)
  400812:	09377663          	bgeu	a4,s3,40089e <malloc+0xb8>
  400816:	f426                	sd	s1,40(sp)
  400818:	e852                	sd	s4,16(sp)
  40081a:	e456                	sd	s5,8(sp)
  40081c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  40081e:	8a4e                	mv	s4,s3
  400820:	6705                	lui	a4,0x1
  400822:	00e9f363          	bgeu	s3,a4,400828 <malloc+0x42>
  400826:	6a05                	lui	s4,0x1
  400828:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  40082c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  400830:	00000497          	auipc	s1,0x0
  400834:	7d048493          	addi	s1,s1,2000 # 401000 <freep>
  if(p == (char*)-1)
  400838:	5afd                	li	s5,-1
  40083a:	a83d                	j	400878 <malloc+0x92>
  40083c:	f426                	sd	s1,40(sp)
  40083e:	e852                	sd	s4,16(sp)
  400840:	e456                	sd	s5,8(sp)
  400842:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  400844:	00000797          	auipc	a5,0x0
  400848:	7cc78793          	addi	a5,a5,1996 # 401010 <base>
  40084c:	00000717          	auipc	a4,0x0
  400850:	7af73a23          	sd	a5,1972(a4) # 401000 <freep>
  400854:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400856:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  40085a:	b7d1                	j	40081e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  40085c:	6398                	ld	a4,0(a5)
  40085e:	e118                	sd	a4,0(a0)
  400860:	a899                	j	4008b6 <malloc+0xd0>
  hp->s.size = nu;
  400862:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400866:	0541                	addi	a0,a0,16
  400868:	ef9ff0ef          	jal	400760 <free>
  return freep;
  40086c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  40086e:	c125                	beqz	a0,4008ce <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400870:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400872:	4798                	lw	a4,8(a5)
  400874:	03277163          	bgeu	a4,s2,400896 <malloc+0xb0>
    if(p == freep)
  400878:	6098                	ld	a4,0(s1)
  40087a:	853e                	mv	a0,a5
  40087c:	fef71ae3          	bne	a4,a5,400870 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400880:	8552                	mv	a0,s4
  400882:	b17ff0ef          	jal	400398 <sbrk>
  if(p == (char*)-1)
  400886:	fd551ee3          	bne	a0,s5,400862 <malloc+0x7c>
        return 0;
  40088a:	4501                	li	a0,0
  40088c:	74a2                	ld	s1,40(sp)
  40088e:	6a42                	ld	s4,16(sp)
  400890:	6aa2                	ld	s5,8(sp)
  400892:	6b02                	ld	s6,0(sp)
  400894:	a03d                	j	4008c2 <malloc+0xdc>
  400896:	74a2                	ld	s1,40(sp)
  400898:	6a42                	ld	s4,16(sp)
  40089a:	6aa2                	ld	s5,8(sp)
  40089c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  40089e:	fae90fe3          	beq	s2,a4,40085c <malloc+0x76>
        p->s.size -= nunits;
  4008a2:	4137073b          	subw	a4,a4,s3
  4008a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
  4008a8:	02071693          	slli	a3,a4,0x20
  4008ac:	01c6d713          	srli	a4,a3,0x1c
  4008b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4008b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4008b6:	00000717          	auipc	a4,0x0
  4008ba:	74a73523          	sd	a0,1866(a4) # 401000 <freep>
      return (void*)(p + 1);
  4008be:	01078513          	addi	a0,a5,16
  }
}
  4008c2:	70e2                	ld	ra,56(sp)
  4008c4:	7442                	ld	s0,48(sp)
  4008c6:	7902                	ld	s2,32(sp)
  4008c8:	69e2                	ld	s3,24(sp)
  4008ca:	6121                	addi	sp,sp,64
  4008cc:	8082                	ret
  4008ce:	74a2                	ld	s1,40(sp)
  4008d0:	6a42                	ld	s4,16(sp)
  4008d2:	6aa2                	ld	s5,8(sp)
  4008d4:	6b02                	ld	s6,0(sp)
  4008d6:	b7f5                	j	4008c2 <malloc+0xdc>
