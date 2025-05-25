
user/_kthreadtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <thread_func>:

#define STACK_SIZE 4096
#define TIMEOUT_TICKS 10000000
#define KTHREAD_DBG(fmt, ...) printf("[kthread-user] " fmt "\n", ##__VA_ARGS__)

void thread_func(void) {
  400000:	1141                	addi	sp,sp,-16
  400002:	e406                	sd	ra,8(sp)
  400004:	e022                	sd	s0,0(sp)
  400006:	0800                	addi	s0,sp,16
    KTHREAD_DBG("thread_func: started");
  400008:	00001517          	auipc	a0,0x1
  40000c:	95850513          	addi	a0,a0,-1704 # 400960 <malloc+0xf8>
  400010:	79e000ef          	jal	4007ae <printf>
    printf("[thread_func] Thread running!\n");
  400014:	00001517          	auipc	a0,0x1
  400018:	97c50513          	addi	a0,a0,-1668 # 400990 <malloc+0x128>
  40001c:	792000ef          	jal	4007ae <printf>
    KTHREAD_DBG("thread_func: finishing");
  400020:	00001517          	auipc	a0,0x1
  400024:	99050513          	addi	a0,a0,-1648 # 4009b0 <malloc+0x148>
  400028:	786000ef          	jal	4007ae <printf>
    kthread_exit(42);
  40002c:	02a00513          	li	a0,42
  400030:	40a000ef          	jal	40043a <kthread_exit>

0000000000400034 <main>:
}

int main(void) {
  400034:	7179                	addi	sp,sp,-48
  400036:	f406                	sd	ra,40(sp)
  400038:	f022                	sd	s0,32(sp)
  40003a:	1800                	addi	s0,sp,48
    KTHREAD_DBG("main: Starting kthreadtest");
  40003c:	00001517          	auipc	a0,0x1
  400040:	99c50513          	addi	a0,a0,-1636 # 4009d8 <malloc+0x170>
  400044:	76a000ef          	jal	4007ae <printf>
    void *stack = malloc(STACK_SIZE);
  400048:	6505                	lui	a0,0x1
  40004a:	01f000ef          	jal	400868 <malloc>
    if (!stack) {
  40004e:	c925                	beqz	a0,4000be <main+0x8a>
  400050:	ec26                	sd	s1,24(sp)
  400052:	e84a                	sd	s2,16(sp)
  400054:	84aa                	mv	s1,a0
        printf("Failed to allocate stack\n");
        exit(1);
    }
    
    int tid = kthread_create(thread_func, stack, STACK_SIZE);
  400056:	6605                	lui	a2,0x1
  400058:	85aa                	mv	a1,a0
  40005a:	00000517          	auipc	a0,0x0
  40005e:	fa650513          	addi	a0,a0,-90 # 400000 <thread_func>
  400062:	3d0000ef          	jal	400432 <kthread_create>
  400066:	892a                	mv	s2,a0
    KTHREAD_DBG("main: kthread_create returned tid=%d", tid);
  400068:	85aa                	mv	a1,a0
  40006a:	00001517          	auipc	a0,0x1
  40006e:	9be50513          	addi	a0,a0,-1602 # 400a28 <malloc+0x1c0>
  400072:	73c000ef          	jal	4007ae <printf>
    if (tid < 0) {
  400076:	04094f63          	bltz	s2,4000d4 <main+0xa0>
        printf("kthread_create failed\n");
        exit(1);
    }
    
    int status = 0;
  40007a:	fc042e23          	sw	zero,-36(s0)
    int ret = kthread_join(tid, &status);
  40007e:	fdc40593          	addi	a1,s0,-36
  400082:	854a                	mv	a0,s2
  400084:	3be000ef          	jal	400442 <kthread_join>
    if (ret == 0) {
  400088:	ed39                	bnez	a0,4000e6 <main+0xb2>
        printf("[main] Thread joined, exit status: %d\n", status);
  40008a:	fdc42583          	lw	a1,-36(s0)
  40008e:	00001517          	auipc	a0,0x1
  400092:	9ea50513          	addi	a0,a0,-1558 # 400a78 <malloc+0x210>
  400096:	718000ef          	jal	4007ae <printf>
    } else {
        printf("[main] kthread_join failed\n");
    }
    
    free(stack);
  40009a:	8526                	mv	a0,s1
  40009c:	746000ef          	jal	4007e2 <free>
    KTHREAD_DBG("main: kthread_join returned");
  4000a0:	00001517          	auipc	a0,0x1
  4000a4:	a2050513          	addi	a0,a0,-1504 # 400ac0 <malloc+0x258>
  4000a8:	706000ef          	jal	4007ae <printf>
    printf("[main] Exiting kthreadtest\n");
  4000ac:	00001517          	auipc	a0,0x1
  4000b0:	a4450513          	addi	a0,a0,-1468 # 400af0 <malloc+0x288>
  4000b4:	6fa000ef          	jal	4007ae <printf>
    exit(0);
  4000b8:	4501                	li	a0,0
  4000ba:	2d8000ef          	jal	400392 <exit>
  4000be:	ec26                	sd	s1,24(sp)
  4000c0:	e84a                	sd	s2,16(sp)
        printf("Failed to allocate stack\n");
  4000c2:	00001517          	auipc	a0,0x1
  4000c6:	94650513          	addi	a0,a0,-1722 # 400a08 <malloc+0x1a0>
  4000ca:	6e4000ef          	jal	4007ae <printf>
        exit(1);
  4000ce:	4505                	li	a0,1
  4000d0:	2c2000ef          	jal	400392 <exit>
        printf("kthread_create failed\n");
  4000d4:	00001517          	auipc	a0,0x1
  4000d8:	98c50513          	addi	a0,a0,-1652 # 400a60 <malloc+0x1f8>
  4000dc:	6d2000ef          	jal	4007ae <printf>
        exit(1);
  4000e0:	4505                	li	a0,1
  4000e2:	2b0000ef          	jal	400392 <exit>
        printf("[main] kthread_join failed\n");
  4000e6:	00001517          	auipc	a0,0x1
  4000ea:	9ba50513          	addi	a0,a0,-1606 # 400aa0 <malloc+0x238>
  4000ee:	6c0000ef          	jal	4007ae <printf>
  4000f2:	b765                	j	40009a <main+0x66>

00000000004000f4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4000f4:	1141                	addi	sp,sp,-16
  4000f6:	e406                	sd	ra,8(sp)
  4000f8:	e022                	sd	s0,0(sp)
  4000fa:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4000fc:	f39ff0ef          	jal	400034 <main>
  exit(0);
  400100:	4501                	li	a0,0
  400102:	290000ef          	jal	400392 <exit>

0000000000400106 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400106:	1141                	addi	sp,sp,-16
  400108:	e406                	sd	ra,8(sp)
  40010a:	e022                	sd	s0,0(sp)
  40010c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40010e:	87aa                	mv	a5,a0
  400110:	0585                	addi	a1,a1,1
  400112:	0785                	addi	a5,a5,1
  400114:	fff5c703          	lbu	a4,-1(a1)
  400118:	fee78fa3          	sb	a4,-1(a5)
  40011c:	fb75                	bnez	a4,400110 <strcpy+0xa>
    ;
  return os;
}
  40011e:	60a2                	ld	ra,8(sp)
  400120:	6402                	ld	s0,0(sp)
  400122:	0141                	addi	sp,sp,16
  400124:	8082                	ret

0000000000400126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400126:	1141                	addi	sp,sp,-16
  400128:	e406                	sd	ra,8(sp)
  40012a:	e022                	sd	s0,0(sp)
  40012c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  40012e:	00054783          	lbu	a5,0(a0)
  400132:	cb91                	beqz	a5,400146 <strcmp+0x20>
  400134:	0005c703          	lbu	a4,0(a1)
  400138:	00f71763          	bne	a4,a5,400146 <strcmp+0x20>
    p++, q++;
  40013c:	0505                	addi	a0,a0,1
  40013e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  400140:	00054783          	lbu	a5,0(a0)
  400144:	fbe5                	bnez	a5,400134 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  400146:	0005c503          	lbu	a0,0(a1)
}
  40014a:	40a7853b          	subw	a0,a5,a0
  40014e:	60a2                	ld	ra,8(sp)
  400150:	6402                	ld	s0,0(sp)
  400152:	0141                	addi	sp,sp,16
  400154:	8082                	ret

0000000000400156 <strlen>:

uint
strlen(const char *s)
{
  400156:	1141                	addi	sp,sp,-16
  400158:	e406                	sd	ra,8(sp)
  40015a:	e022                	sd	s0,0(sp)
  40015c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  40015e:	00054783          	lbu	a5,0(a0)
  400162:	cf99                	beqz	a5,400180 <strlen+0x2a>
  400164:	0505                	addi	a0,a0,1
  400166:	87aa                	mv	a5,a0
  400168:	86be                	mv	a3,a5
  40016a:	0785                	addi	a5,a5,1
  40016c:	fff7c703          	lbu	a4,-1(a5)
  400170:	ff65                	bnez	a4,400168 <strlen+0x12>
  400172:	40a6853b          	subw	a0,a3,a0
  400176:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  400178:	60a2                	ld	ra,8(sp)
  40017a:	6402                	ld	s0,0(sp)
  40017c:	0141                	addi	sp,sp,16
  40017e:	8082                	ret
  for(n = 0; s[n]; n++)
  400180:	4501                	li	a0,0
  400182:	bfdd                	j	400178 <strlen+0x22>

0000000000400184 <memset>:

void*
memset(void *dst, int c, uint n)
{
  400184:	1141                	addi	sp,sp,-16
  400186:	e406                	sd	ra,8(sp)
  400188:	e022                	sd	s0,0(sp)
  40018a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  40018c:	ca19                	beqz	a2,4001a2 <memset+0x1e>
  40018e:	87aa                	mv	a5,a0
  400190:	1602                	slli	a2,a2,0x20
  400192:	9201                	srli	a2,a2,0x20
  400194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400198:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  40019c:	0785                	addi	a5,a5,1
  40019e:	fee79de3          	bne	a5,a4,400198 <memset+0x14>
  }
  return dst;
}
  4001a2:	60a2                	ld	ra,8(sp)
  4001a4:	6402                	ld	s0,0(sp)
  4001a6:	0141                	addi	sp,sp,16
  4001a8:	8082                	ret

00000000004001aa <strchr>:

char*
strchr(const char *s, char c)
{
  4001aa:	1141                	addi	sp,sp,-16
  4001ac:	e406                	sd	ra,8(sp)
  4001ae:	e022                	sd	s0,0(sp)
  4001b0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  4001b2:	00054783          	lbu	a5,0(a0)
  4001b6:	cf81                	beqz	a5,4001ce <strchr+0x24>
    if(*s == c)
  4001b8:	00f58763          	beq	a1,a5,4001c6 <strchr+0x1c>
  for(; *s; s++)
  4001bc:	0505                	addi	a0,a0,1
  4001be:	00054783          	lbu	a5,0(a0)
  4001c2:	fbfd                	bnez	a5,4001b8 <strchr+0xe>
      return (char*)s;
  return 0;
  4001c4:	4501                	li	a0,0
}
  4001c6:	60a2                	ld	ra,8(sp)
  4001c8:	6402                	ld	s0,0(sp)
  4001ca:	0141                	addi	sp,sp,16
  4001cc:	8082                	ret
  return 0;
  4001ce:	4501                	li	a0,0
  4001d0:	bfdd                	j	4001c6 <strchr+0x1c>

00000000004001d2 <gets>:

char*
gets(char *buf, int max)
{
  4001d2:	7159                	addi	sp,sp,-112
  4001d4:	f486                	sd	ra,104(sp)
  4001d6:	f0a2                	sd	s0,96(sp)
  4001d8:	eca6                	sd	s1,88(sp)
  4001da:	e8ca                	sd	s2,80(sp)
  4001dc:	e4ce                	sd	s3,72(sp)
  4001de:	e0d2                	sd	s4,64(sp)
  4001e0:	fc56                	sd	s5,56(sp)
  4001e2:	f85a                	sd	s6,48(sp)
  4001e4:	f45e                	sd	s7,40(sp)
  4001e6:	f062                	sd	s8,32(sp)
  4001e8:	ec66                	sd	s9,24(sp)
  4001ea:	e86a                	sd	s10,16(sp)
  4001ec:	1880                	addi	s0,sp,112
  4001ee:	8caa                	mv	s9,a0
  4001f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  4001f2:	892a                	mv	s2,a0
  4001f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
  4001f6:	f9f40b13          	addi	s6,s0,-97
  4001fa:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  4001fc:	4ba9                	li	s7,10
  4001fe:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400200:	8d26                	mv	s10,s1
  400202:	0014899b          	addiw	s3,s1,1
  400206:	84ce                	mv	s1,s3
  400208:	0349d563          	bge	s3,s4,400232 <gets+0x60>
    cc = read(0, &c, 1);
  40020c:	8656                	mv	a2,s5
  40020e:	85da                	mv	a1,s6
  400210:	4501                	li	a0,0
  400212:	198000ef          	jal	4003aa <read>
    if(cc < 1)
  400216:	00a05e63          	blez	a0,400232 <gets+0x60>
    buf[i++] = c;
  40021a:	f9f44783          	lbu	a5,-97(s0)
  40021e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400222:	01778763          	beq	a5,s7,400230 <gets+0x5e>
  400226:	0905                	addi	s2,s2,1
  400228:	fd879ce3          	bne	a5,s8,400200 <gets+0x2e>
    buf[i++] = c;
  40022c:	8d4e                	mv	s10,s3
  40022e:	a011                	j	400232 <gets+0x60>
  400230:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  400232:	9d66                	add	s10,s10,s9
  400234:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400238:	8566                	mv	a0,s9
  40023a:	70a6                	ld	ra,104(sp)
  40023c:	7406                	ld	s0,96(sp)
  40023e:	64e6                	ld	s1,88(sp)
  400240:	6946                	ld	s2,80(sp)
  400242:	69a6                	ld	s3,72(sp)
  400244:	6a06                	ld	s4,64(sp)
  400246:	7ae2                	ld	s5,56(sp)
  400248:	7b42                	ld	s6,48(sp)
  40024a:	7ba2                	ld	s7,40(sp)
  40024c:	7c02                	ld	s8,32(sp)
  40024e:	6ce2                	ld	s9,24(sp)
  400250:	6d42                	ld	s10,16(sp)
  400252:	6165                	addi	sp,sp,112
  400254:	8082                	ret

0000000000400256 <stat>:

int
stat(const char *n, struct stat *st)
{
  400256:	1101                	addi	sp,sp,-32
  400258:	ec06                	sd	ra,24(sp)
  40025a:	e822                	sd	s0,16(sp)
  40025c:	e04a                	sd	s2,0(sp)
  40025e:	1000                	addi	s0,sp,32
  400260:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  400262:	4581                	li	a1,0
  400264:	16e000ef          	jal	4003d2 <open>
  if(fd < 0)
  400268:	02054263          	bltz	a0,40028c <stat+0x36>
  40026c:	e426                	sd	s1,8(sp)
  40026e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  400270:	85ca                	mv	a1,s2
  400272:	178000ef          	jal	4003ea <fstat>
  400276:	892a                	mv	s2,a0
  close(fd);
  400278:	8526                	mv	a0,s1
  40027a:	140000ef          	jal	4003ba <close>
  return r;
  40027e:	64a2                	ld	s1,8(sp)
}
  400280:	854a                	mv	a0,s2
  400282:	60e2                	ld	ra,24(sp)
  400284:	6442                	ld	s0,16(sp)
  400286:	6902                	ld	s2,0(sp)
  400288:	6105                	addi	sp,sp,32
  40028a:	8082                	ret
    return -1;
  40028c:	597d                	li	s2,-1
  40028e:	bfcd                	j	400280 <stat+0x2a>

0000000000400290 <atoi>:

int
atoi(const char *s)
{
  400290:	1141                	addi	sp,sp,-16
  400292:	e406                	sd	ra,8(sp)
  400294:	e022                	sd	s0,0(sp)
  400296:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400298:	00054683          	lbu	a3,0(a0)
  40029c:	fd06879b          	addiw	a5,a3,-48
  4002a0:	0ff7f793          	zext.b	a5,a5
  4002a4:	4625                	li	a2,9
  4002a6:	02f66963          	bltu	a2,a5,4002d8 <atoi+0x48>
  4002aa:	872a                	mv	a4,a0
  n = 0;
  4002ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  4002ae:	0705                	addi	a4,a4,1
  4002b0:	0025179b          	slliw	a5,a0,0x2
  4002b4:	9fa9                	addw	a5,a5,a0
  4002b6:	0017979b          	slliw	a5,a5,0x1
  4002ba:	9fb5                	addw	a5,a5,a3
  4002bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  4002c0:	00074683          	lbu	a3,0(a4)
  4002c4:	fd06879b          	addiw	a5,a3,-48
  4002c8:	0ff7f793          	zext.b	a5,a5
  4002cc:	fef671e3          	bgeu	a2,a5,4002ae <atoi+0x1e>
  return n;
}
  4002d0:	60a2                	ld	ra,8(sp)
  4002d2:	6402                	ld	s0,0(sp)
  4002d4:	0141                	addi	sp,sp,16
  4002d6:	8082                	ret
  n = 0;
  4002d8:	4501                	li	a0,0
  4002da:	bfdd                	j	4002d0 <atoi+0x40>

00000000004002dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  4002dc:	1141                	addi	sp,sp,-16
  4002de:	e406                	sd	ra,8(sp)
  4002e0:	e022                	sd	s0,0(sp)
  4002e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  4002e4:	02b57563          	bgeu	a0,a1,40030e <memmove+0x32>
    while(n-- > 0)
  4002e8:	00c05f63          	blez	a2,400306 <memmove+0x2a>
  4002ec:	1602                	slli	a2,a2,0x20
  4002ee:	9201                	srli	a2,a2,0x20
  4002f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  4002f4:	872a                	mv	a4,a0
      *dst++ = *src++;
  4002f6:	0585                	addi	a1,a1,1
  4002f8:	0705                	addi	a4,a4,1
  4002fa:	fff5c683          	lbu	a3,-1(a1)
  4002fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400302:	fee79ae3          	bne	a5,a4,4002f6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400306:	60a2                	ld	ra,8(sp)
  400308:	6402                	ld	s0,0(sp)
  40030a:	0141                	addi	sp,sp,16
  40030c:	8082                	ret
    dst += n;
  40030e:	00c50733          	add	a4,a0,a2
    src += n;
  400312:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400314:	fec059e3          	blez	a2,400306 <memmove+0x2a>
  400318:	fff6079b          	addiw	a5,a2,-1 # fff <thread_func-0x3ff001>
  40031c:	1782                	slli	a5,a5,0x20
  40031e:	9381                	srli	a5,a5,0x20
  400320:	fff7c793          	not	a5,a5
  400324:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400326:	15fd                	addi	a1,a1,-1
  400328:	177d                	addi	a4,a4,-1
  40032a:	0005c683          	lbu	a3,0(a1)
  40032e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  400332:	fef71ae3          	bne	a4,a5,400326 <memmove+0x4a>
  400336:	bfc1                	j	400306 <memmove+0x2a>

0000000000400338 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400338:	1141                	addi	sp,sp,-16
  40033a:	e406                	sd	ra,8(sp)
  40033c:	e022                	sd	s0,0(sp)
  40033e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  400340:	ca0d                	beqz	a2,400372 <memcmp+0x3a>
  400342:	fff6069b          	addiw	a3,a2,-1
  400346:	1682                	slli	a3,a3,0x20
  400348:	9281                	srli	a3,a3,0x20
  40034a:	0685                	addi	a3,a3,1
  40034c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  40034e:	00054783          	lbu	a5,0(a0)
  400352:	0005c703          	lbu	a4,0(a1)
  400356:	00e79863          	bne	a5,a4,400366 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  40035a:	0505                	addi	a0,a0,1
    p2++;
  40035c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  40035e:	fed518e3          	bne	a0,a3,40034e <memcmp+0x16>
  }
  return 0;
  400362:	4501                	li	a0,0
  400364:	a019                	j	40036a <memcmp+0x32>
      return *p1 - *p2;
  400366:	40e7853b          	subw	a0,a5,a4
}
  40036a:	60a2                	ld	ra,8(sp)
  40036c:	6402                	ld	s0,0(sp)
  40036e:	0141                	addi	sp,sp,16
  400370:	8082                	ret
  return 0;
  400372:	4501                	li	a0,0
  400374:	bfdd                	j	40036a <memcmp+0x32>

0000000000400376 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  400376:	1141                	addi	sp,sp,-16
  400378:	e406                	sd	ra,8(sp)
  40037a:	e022                	sd	s0,0(sp)
  40037c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  40037e:	f5fff0ef          	jal	4002dc <memmove>
}
  400382:	60a2                	ld	ra,8(sp)
  400384:	6402                	ld	s0,0(sp)
  400386:	0141                	addi	sp,sp,16
  400388:	8082                	ret

000000000040038a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  40038a:	4885                	li	a7,1
 ecall
  40038c:	00000073          	ecall
 ret
  400390:	8082                	ret

0000000000400392 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400392:	4889                	li	a7,2
 ecall
  400394:	00000073          	ecall
 ret
  400398:	8082                	ret

000000000040039a <wait>:
.global wait
wait:
 li a7, SYS_wait
  40039a:	488d                	li	a7,3
 ecall
  40039c:	00000073          	ecall
 ret
  4003a0:	8082                	ret

00000000004003a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  4003a2:	4891                	li	a7,4
 ecall
  4003a4:	00000073          	ecall
 ret
  4003a8:	8082                	ret

00000000004003aa <read>:
.global read
read:
 li a7, SYS_read
  4003aa:	4895                	li	a7,5
 ecall
  4003ac:	00000073          	ecall
 ret
  4003b0:	8082                	ret

00000000004003b2 <write>:
.global write
write:
 li a7, SYS_write
  4003b2:	48c1                	li	a7,16
 ecall
  4003b4:	00000073          	ecall
 ret
  4003b8:	8082                	ret

00000000004003ba <close>:
.global close
close:
 li a7, SYS_close
  4003ba:	48d5                	li	a7,21
 ecall
  4003bc:	00000073          	ecall
 ret
  4003c0:	8082                	ret

00000000004003c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
  4003c2:	4899                	li	a7,6
 ecall
  4003c4:	00000073          	ecall
 ret
  4003c8:	8082                	ret

00000000004003ca <exec>:
.global exec
exec:
 li a7, SYS_exec
  4003ca:	489d                	li	a7,7
 ecall
  4003cc:	00000073          	ecall
 ret
  4003d0:	8082                	ret

00000000004003d2 <open>:
.global open
open:
 li a7, SYS_open
  4003d2:	48bd                	li	a7,15
 ecall
  4003d4:	00000073          	ecall
 ret
  4003d8:	8082                	ret

00000000004003da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  4003da:	48c5                	li	a7,17
 ecall
  4003dc:	00000073          	ecall
 ret
  4003e0:	8082                	ret

00000000004003e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  4003e2:	48c9                	li	a7,18
 ecall
  4003e4:	00000073          	ecall
 ret
  4003e8:	8082                	ret

00000000004003ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  4003ea:	48a1                	li	a7,8
 ecall
  4003ec:	00000073          	ecall
 ret
  4003f0:	8082                	ret

00000000004003f2 <link>:
.global link
link:
 li a7, SYS_link
  4003f2:	48cd                	li	a7,19
 ecall
  4003f4:	00000073          	ecall
 ret
  4003f8:	8082                	ret

00000000004003fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  4003fa:	48d1                	li	a7,20
 ecall
  4003fc:	00000073          	ecall
 ret
  400400:	8082                	ret

0000000000400402 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400402:	48a5                	li	a7,9
 ecall
  400404:	00000073          	ecall
 ret
  400408:	8082                	ret

000000000040040a <dup>:
.global dup
dup:
 li a7, SYS_dup
  40040a:	48a9                	li	a7,10
 ecall
  40040c:	00000073          	ecall
 ret
  400410:	8082                	ret

0000000000400412 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400412:	48ad                	li	a7,11
 ecall
  400414:	00000073          	ecall
 ret
  400418:	8082                	ret

000000000040041a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  40041a:	48b1                	li	a7,12
 ecall
  40041c:	00000073          	ecall
 ret
  400420:	8082                	ret

0000000000400422 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400422:	48b5                	li	a7,13
 ecall
  400424:	00000073          	ecall
 ret
  400428:	8082                	ret

000000000040042a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  40042a:	48b9                	li	a7,14
 ecall
  40042c:	00000073          	ecall
 ret
  400430:	8082                	ret

0000000000400432 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  400432:	48d9                	li	a7,22
 ecall
  400434:	00000073          	ecall
 ret
  400438:	8082                	ret

000000000040043a <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  40043a:	48dd                	li	a7,23
 ecall
  40043c:	00000073          	ecall
 ret
  400440:	8082                	ret

0000000000400442 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  400442:	48e1                	li	a7,24
 ecall
  400444:	00000073          	ecall
 ret
  400448:	8082                	ret

000000000040044a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  40044a:	1101                	addi	sp,sp,-32
  40044c:	ec06                	sd	ra,24(sp)
  40044e:	e822                	sd	s0,16(sp)
  400450:	1000                	addi	s0,sp,32
  400452:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  400456:	4605                	li	a2,1
  400458:	fef40593          	addi	a1,s0,-17
  40045c:	f57ff0ef          	jal	4003b2 <write>
}
  400460:	60e2                	ld	ra,24(sp)
  400462:	6442                	ld	s0,16(sp)
  400464:	6105                	addi	sp,sp,32
  400466:	8082                	ret

0000000000400468 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  400468:	7139                	addi	sp,sp,-64
  40046a:	fc06                	sd	ra,56(sp)
  40046c:	f822                	sd	s0,48(sp)
  40046e:	f426                	sd	s1,40(sp)
  400470:	f04a                	sd	s2,32(sp)
  400472:	ec4e                	sd	s3,24(sp)
  400474:	0080                	addi	s0,sp,64
  400476:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  400478:	c299                	beqz	a3,40047e <printint+0x16>
  40047a:	0605ce63          	bltz	a1,4004f6 <printint+0x8e>
  neg = 0;
  40047e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400480:	fc040313          	addi	t1,s0,-64
  neg = 0;
  400484:	869a                	mv	a3,t1
  i = 0;
  400486:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  400488:	00000817          	auipc	a6,0x0
  40048c:	69080813          	addi	a6,a6,1680 # 400b18 <digits>
  400490:	88be                	mv	a7,a5
  400492:	0017851b          	addiw	a0,a5,1
  400496:	87aa                	mv	a5,a0
  400498:	02c5f73b          	remuw	a4,a1,a2
  40049c:	1702                	slli	a4,a4,0x20
  40049e:	9301                	srli	a4,a4,0x20
  4004a0:	9742                	add	a4,a4,a6
  4004a2:	00074703          	lbu	a4,0(a4)
  4004a6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  4004aa:	872e                	mv	a4,a1
  4004ac:	02c5d5bb          	divuw	a1,a1,a2
  4004b0:	0685                	addi	a3,a3,1
  4004b2:	fcc77fe3          	bgeu	a4,a2,400490 <printint+0x28>
  if(neg)
  4004b6:	000e0c63          	beqz	t3,4004ce <printint+0x66>
    buf[i++] = '-';
  4004ba:	fd050793          	addi	a5,a0,-48
  4004be:	00878533          	add	a0,a5,s0
  4004c2:	02d00793          	li	a5,45
  4004c6:	fef50823          	sb	a5,-16(a0)
  4004ca:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  4004ce:	fff7899b          	addiw	s3,a5,-1
  4004d2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  4004d6:	fff4c583          	lbu	a1,-1(s1)
  4004da:	854a                	mv	a0,s2
  4004dc:	f6fff0ef          	jal	40044a <putc>
  while(--i >= 0)
  4004e0:	39fd                	addiw	s3,s3,-1
  4004e2:	14fd                	addi	s1,s1,-1
  4004e4:	fe09d9e3          	bgez	s3,4004d6 <printint+0x6e>
}
  4004e8:	70e2                	ld	ra,56(sp)
  4004ea:	7442                	ld	s0,48(sp)
  4004ec:	74a2                	ld	s1,40(sp)
  4004ee:	7902                	ld	s2,32(sp)
  4004f0:	69e2                	ld	s3,24(sp)
  4004f2:	6121                	addi	sp,sp,64
  4004f4:	8082                	ret
    x = -xx;
  4004f6:	40b005bb          	negw	a1,a1
    neg = 1;
  4004fa:	4e05                	li	t3,1
    x = -xx;
  4004fc:	b751                	j	400480 <printint+0x18>

00000000004004fe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  4004fe:	711d                	addi	sp,sp,-96
  400500:	ec86                	sd	ra,88(sp)
  400502:	e8a2                	sd	s0,80(sp)
  400504:	e4a6                	sd	s1,72(sp)
  400506:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400508:	0005c483          	lbu	s1,0(a1)
  40050c:	26048663          	beqz	s1,400778 <vprintf+0x27a>
  400510:	e0ca                	sd	s2,64(sp)
  400512:	fc4e                	sd	s3,56(sp)
  400514:	f852                	sd	s4,48(sp)
  400516:	f456                	sd	s5,40(sp)
  400518:	f05a                	sd	s6,32(sp)
  40051a:	ec5e                	sd	s7,24(sp)
  40051c:	e862                	sd	s8,16(sp)
  40051e:	e466                	sd	s9,8(sp)
  400520:	8b2a                	mv	s6,a0
  400522:	8a2e                	mv	s4,a1
  400524:	8bb2                	mv	s7,a2
  state = 0;
  400526:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400528:	4901                	li	s2,0
  40052a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  40052c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  400530:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  400534:	06c00c93          	li	s9,108
  400538:	a00d                	j	40055a <vprintf+0x5c>
        putc(fd, c0);
  40053a:	85a6                	mv	a1,s1
  40053c:	855a                	mv	a0,s6
  40053e:	f0dff0ef          	jal	40044a <putc>
  400542:	a019                	j	400548 <vprintf+0x4a>
    } else if(state == '%'){
  400544:	03598363          	beq	s3,s5,40056a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  400548:	0019079b          	addiw	a5,s2,1
  40054c:	893e                	mv	s2,a5
  40054e:	873e                	mv	a4,a5
  400550:	97d2                	add	a5,a5,s4
  400552:	0007c483          	lbu	s1,0(a5)
  400556:	20048963          	beqz	s1,400768 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  40055a:	0004879b          	sext.w	a5,s1
    if(state == 0){
  40055e:	fe0993e3          	bnez	s3,400544 <vprintf+0x46>
      if(c0 == '%'){
  400562:	fd579ce3          	bne	a5,s5,40053a <vprintf+0x3c>
        state = '%';
  400566:	89be                	mv	s3,a5
  400568:	b7c5                	j	400548 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  40056a:	00ea06b3          	add	a3,s4,a4
  40056e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  400572:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  400574:	c681                	beqz	a3,40057c <vprintf+0x7e>
  400576:	9752                	add	a4,a4,s4
  400578:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  40057c:	03878e63          	beq	a5,s8,4005b8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400580:	05978863          	beq	a5,s9,4005d0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  400584:	07500713          	li	a4,117
  400588:	0ee78263          	beq	a5,a4,40066c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  40058c:	07800713          	li	a4,120
  400590:	12e78463          	beq	a5,a4,4006b8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400594:	07000713          	li	a4,112
  400598:	14e78963          	beq	a5,a4,4006ea <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  40059c:	07300713          	li	a4,115
  4005a0:	18e78863          	beq	a5,a4,400730 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  4005a4:	02500713          	li	a4,37
  4005a8:	04e79463          	bne	a5,a4,4005f0 <vprintf+0xf2>
        putc(fd, '%');
  4005ac:	85ba                	mv	a1,a4
  4005ae:	855a                	mv	a0,s6
  4005b0:	e9bff0ef          	jal	40044a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  4005b4:	4981                	li	s3,0
  4005b6:	bf49                	j	400548 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  4005b8:	008b8493          	addi	s1,s7,8
  4005bc:	4685                	li	a3,1
  4005be:	4629                	li	a2,10
  4005c0:	000ba583          	lw	a1,0(s7)
  4005c4:	855a                	mv	a0,s6
  4005c6:	ea3ff0ef          	jal	400468 <printint>
  4005ca:	8ba6                	mv	s7,s1
      state = 0;
  4005cc:	4981                	li	s3,0
  4005ce:	bfad                	j	400548 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  4005d0:	06400793          	li	a5,100
  4005d4:	02f68963          	beq	a3,a5,400606 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4005d8:	06c00793          	li	a5,108
  4005dc:	04f68263          	beq	a3,a5,400620 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  4005e0:	07500793          	li	a5,117
  4005e4:	0af68063          	beq	a3,a5,400684 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  4005e8:	07800793          	li	a5,120
  4005ec:	0ef68263          	beq	a3,a5,4006d0 <vprintf+0x1d2>
        putc(fd, '%');
  4005f0:	02500593          	li	a1,37
  4005f4:	855a                	mv	a0,s6
  4005f6:	e55ff0ef          	jal	40044a <putc>
        putc(fd, c0);
  4005fa:	85a6                	mv	a1,s1
  4005fc:	855a                	mv	a0,s6
  4005fe:	e4dff0ef          	jal	40044a <putc>
      state = 0;
  400602:	4981                	li	s3,0
  400604:	b791                	j	400548 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400606:	008b8493          	addi	s1,s7,8
  40060a:	4685                	li	a3,1
  40060c:	4629                	li	a2,10
  40060e:	000ba583          	lw	a1,0(s7)
  400612:	855a                	mv	a0,s6
  400614:	e55ff0ef          	jal	400468 <printint>
        i += 1;
  400618:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  40061a:	8ba6                	mv	s7,s1
      state = 0;
  40061c:	4981                	li	s3,0
        i += 1;
  40061e:	b72d                	j	400548 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400620:	06400793          	li	a5,100
  400624:	02f60763          	beq	a2,a5,400652 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400628:	07500793          	li	a5,117
  40062c:	06f60963          	beq	a2,a5,40069e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  400630:	07800793          	li	a5,120
  400634:	faf61ee3          	bne	a2,a5,4005f0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400638:	008b8493          	addi	s1,s7,8
  40063c:	4681                	li	a3,0
  40063e:	4641                	li	a2,16
  400640:	000ba583          	lw	a1,0(s7)
  400644:	855a                	mv	a0,s6
  400646:	e23ff0ef          	jal	400468 <printint>
        i += 2;
  40064a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  40064c:	8ba6                	mv	s7,s1
      state = 0;
  40064e:	4981                	li	s3,0
        i += 2;
  400650:	bde5                	j	400548 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400652:	008b8493          	addi	s1,s7,8
  400656:	4685                	li	a3,1
  400658:	4629                	li	a2,10
  40065a:	000ba583          	lw	a1,0(s7)
  40065e:	855a                	mv	a0,s6
  400660:	e09ff0ef          	jal	400468 <printint>
        i += 2;
  400664:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  400666:	8ba6                	mv	s7,s1
      state = 0;
  400668:	4981                	li	s3,0
        i += 2;
  40066a:	bdf9                	j	400548 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  40066c:	008b8493          	addi	s1,s7,8
  400670:	4681                	li	a3,0
  400672:	4629                	li	a2,10
  400674:	000ba583          	lw	a1,0(s7)
  400678:	855a                	mv	a0,s6
  40067a:	defff0ef          	jal	400468 <printint>
  40067e:	8ba6                	mv	s7,s1
      state = 0;
  400680:	4981                	li	s3,0
  400682:	b5d9                	j	400548 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400684:	008b8493          	addi	s1,s7,8
  400688:	4681                	li	a3,0
  40068a:	4629                	li	a2,10
  40068c:	000ba583          	lw	a1,0(s7)
  400690:	855a                	mv	a0,s6
  400692:	dd7ff0ef          	jal	400468 <printint>
        i += 1;
  400696:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400698:	8ba6                	mv	s7,s1
      state = 0;
  40069a:	4981                	li	s3,0
        i += 1;
  40069c:	b575                	j	400548 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  40069e:	008b8493          	addi	s1,s7,8
  4006a2:	4681                	li	a3,0
  4006a4:	4629                	li	a2,10
  4006a6:	000ba583          	lw	a1,0(s7)
  4006aa:	855a                	mv	a0,s6
  4006ac:	dbdff0ef          	jal	400468 <printint>
        i += 2;
  4006b0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006b2:	8ba6                	mv	s7,s1
      state = 0;
  4006b4:	4981                	li	s3,0
        i += 2;
  4006b6:	bd49                	j	400548 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  4006b8:	008b8493          	addi	s1,s7,8
  4006bc:	4681                	li	a3,0
  4006be:	4641                	li	a2,16
  4006c0:	000ba583          	lw	a1,0(s7)
  4006c4:	855a                	mv	a0,s6
  4006c6:	da3ff0ef          	jal	400468 <printint>
  4006ca:	8ba6                	mv	s7,s1
      state = 0;
  4006cc:	4981                	li	s3,0
  4006ce:	bdad                	j	400548 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006d0:	008b8493          	addi	s1,s7,8
  4006d4:	4681                	li	a3,0
  4006d6:	4641                	li	a2,16
  4006d8:	000ba583          	lw	a1,0(s7)
  4006dc:	855a                	mv	a0,s6
  4006de:	d8bff0ef          	jal	400468 <printint>
        i += 1;
  4006e2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006e4:	8ba6                	mv	s7,s1
      state = 0;
  4006e6:	4981                	li	s3,0
        i += 1;
  4006e8:	b585                	j	400548 <vprintf+0x4a>
  4006ea:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  4006ec:	008b8d13          	addi	s10,s7,8
  4006f0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  4006f4:	03000593          	li	a1,48
  4006f8:	855a                	mv	a0,s6
  4006fa:	d51ff0ef          	jal	40044a <putc>
  putc(fd, 'x');
  4006fe:	07800593          	li	a1,120
  400702:	855a                	mv	a0,s6
  400704:	d47ff0ef          	jal	40044a <putc>
  400708:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  40070a:	00000b97          	auipc	s7,0x0
  40070e:	40eb8b93          	addi	s7,s7,1038 # 400b18 <digits>
  400712:	03c9d793          	srli	a5,s3,0x3c
  400716:	97de                	add	a5,a5,s7
  400718:	0007c583          	lbu	a1,0(a5)
  40071c:	855a                	mv	a0,s6
  40071e:	d2dff0ef          	jal	40044a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400722:	0992                	slli	s3,s3,0x4
  400724:	34fd                	addiw	s1,s1,-1
  400726:	f4f5                	bnez	s1,400712 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400728:	8bea                	mv	s7,s10
      state = 0;
  40072a:	4981                	li	s3,0
  40072c:	6d02                	ld	s10,0(sp)
  40072e:	bd29                	j	400548 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  400730:	008b8993          	addi	s3,s7,8
  400734:	000bb483          	ld	s1,0(s7)
  400738:	cc91                	beqz	s1,400754 <vprintf+0x256>
        for(; *s; s++)
  40073a:	0004c583          	lbu	a1,0(s1)
  40073e:	c195                	beqz	a1,400762 <vprintf+0x264>
          putc(fd, *s);
  400740:	855a                	mv	a0,s6
  400742:	d09ff0ef          	jal	40044a <putc>
        for(; *s; s++)
  400746:	0485                	addi	s1,s1,1
  400748:	0004c583          	lbu	a1,0(s1)
  40074c:	f9f5                	bnez	a1,400740 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  40074e:	8bce                	mv	s7,s3
      state = 0;
  400750:	4981                	li	s3,0
  400752:	bbdd                	j	400548 <vprintf+0x4a>
          s = "(null)";
  400754:	00000497          	auipc	s1,0x0
  400758:	3bc48493          	addi	s1,s1,956 # 400b10 <malloc+0x2a8>
        for(; *s; s++)
  40075c:	02800593          	li	a1,40
  400760:	b7c5                	j	400740 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400762:	8bce                	mv	s7,s3
      state = 0;
  400764:	4981                	li	s3,0
  400766:	b3cd                	j	400548 <vprintf+0x4a>
  400768:	6906                	ld	s2,64(sp)
  40076a:	79e2                	ld	s3,56(sp)
  40076c:	7a42                	ld	s4,48(sp)
  40076e:	7aa2                	ld	s5,40(sp)
  400770:	7b02                	ld	s6,32(sp)
  400772:	6be2                	ld	s7,24(sp)
  400774:	6c42                	ld	s8,16(sp)
  400776:	6ca2                	ld	s9,8(sp)
    }
  }
}
  400778:	60e6                	ld	ra,88(sp)
  40077a:	6446                	ld	s0,80(sp)
  40077c:	64a6                	ld	s1,72(sp)
  40077e:	6125                	addi	sp,sp,96
  400780:	8082                	ret

0000000000400782 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  400782:	715d                	addi	sp,sp,-80
  400784:	ec06                	sd	ra,24(sp)
  400786:	e822                	sd	s0,16(sp)
  400788:	1000                	addi	s0,sp,32
  40078a:	e010                	sd	a2,0(s0)
  40078c:	e414                	sd	a3,8(s0)
  40078e:	e818                	sd	a4,16(s0)
  400790:	ec1c                	sd	a5,24(s0)
  400792:	03043023          	sd	a6,32(s0)
  400796:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  40079a:	8622                	mv	a2,s0
  40079c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  4007a0:	d5fff0ef          	jal	4004fe <vprintf>
  return 0;
}
  4007a4:	4501                	li	a0,0
  4007a6:	60e2                	ld	ra,24(sp)
  4007a8:	6442                	ld	s0,16(sp)
  4007aa:	6161                	addi	sp,sp,80
  4007ac:	8082                	ret

00000000004007ae <printf>:

int
printf(const char *fmt, ...)
{
  4007ae:	711d                	addi	sp,sp,-96
  4007b0:	ec06                	sd	ra,24(sp)
  4007b2:	e822                	sd	s0,16(sp)
  4007b4:	1000                	addi	s0,sp,32
  4007b6:	e40c                	sd	a1,8(s0)
  4007b8:	e810                	sd	a2,16(s0)
  4007ba:	ec14                	sd	a3,24(s0)
  4007bc:	f018                	sd	a4,32(s0)
  4007be:	f41c                	sd	a5,40(s0)
  4007c0:	03043823          	sd	a6,48(s0)
  4007c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  4007c8:	00840613          	addi	a2,s0,8
  4007cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  4007d0:	85aa                	mv	a1,a0
  4007d2:	4505                	li	a0,1
  4007d4:	d2bff0ef          	jal	4004fe <vprintf>
  return 0;
}
  4007d8:	4501                	li	a0,0
  4007da:	60e2                	ld	ra,24(sp)
  4007dc:	6442                	ld	s0,16(sp)
  4007de:	6125                	addi	sp,sp,96
  4007e0:	8082                	ret

00000000004007e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  4007e2:	1141                	addi	sp,sp,-16
  4007e4:	e406                	sd	ra,8(sp)
  4007e6:	e022                	sd	s0,0(sp)
  4007e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  4007ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4007ee:	00001797          	auipc	a5,0x1
  4007f2:	8127b783          	ld	a5,-2030(a5) # 401000 <freep>
  4007f6:	a02d                	j	400820 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  4007f8:	4618                	lw	a4,8(a2)
  4007fa:	9f2d                	addw	a4,a4,a1
  4007fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400800:	6398                	ld	a4,0(a5)
  400802:	6310                	ld	a2,0(a4)
  400804:	a83d                	j	400842 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400806:	ff852703          	lw	a4,-8(a0)
  40080a:	9f31                	addw	a4,a4,a2
  40080c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  40080e:	ff053683          	ld	a3,-16(a0)
  400812:	a091                	j	400856 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400814:	6398                	ld	a4,0(a5)
  400816:	00e7e463          	bltu	a5,a4,40081e <free+0x3c>
  40081a:	00e6ea63          	bltu	a3,a4,40082e <free+0x4c>
{
  40081e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400820:	fed7fae3          	bgeu	a5,a3,400814 <free+0x32>
  400824:	6398                	ld	a4,0(a5)
  400826:	00e6e463          	bltu	a3,a4,40082e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40082a:	fee7eae3          	bltu	a5,a4,40081e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  40082e:	ff852583          	lw	a1,-8(a0)
  400832:	6390                	ld	a2,0(a5)
  400834:	02059813          	slli	a6,a1,0x20
  400838:	01c85713          	srli	a4,a6,0x1c
  40083c:	9736                	add	a4,a4,a3
  40083e:	fae60de3          	beq	a2,a4,4007f8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  400842:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  400846:	4790                	lw	a2,8(a5)
  400848:	02061593          	slli	a1,a2,0x20
  40084c:	01c5d713          	srli	a4,a1,0x1c
  400850:	973e                	add	a4,a4,a5
  400852:	fae68ae3          	beq	a3,a4,400806 <free+0x24>
    p->s.ptr = bp->s.ptr;
  400856:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  400858:	00000717          	auipc	a4,0x0
  40085c:	7af73423          	sd	a5,1960(a4) # 401000 <freep>
}
  400860:	60a2                	ld	ra,8(sp)
  400862:	6402                	ld	s0,0(sp)
  400864:	0141                	addi	sp,sp,16
  400866:	8082                	ret

0000000000400868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  400868:	7139                	addi	sp,sp,-64
  40086a:	fc06                	sd	ra,56(sp)
  40086c:	f822                	sd	s0,48(sp)
  40086e:	f04a                	sd	s2,32(sp)
  400870:	ec4e                	sd	s3,24(sp)
  400872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  400874:	02051993          	slli	s3,a0,0x20
  400878:	0209d993          	srli	s3,s3,0x20
  40087c:	09bd                	addi	s3,s3,15
  40087e:	0049d993          	srli	s3,s3,0x4
  400882:	2985                	addiw	s3,s3,1
  400884:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  400886:	00000517          	auipc	a0,0x0
  40088a:	77a53503          	ld	a0,1914(a0) # 401000 <freep>
  40088e:	c905                	beqz	a0,4008be <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400892:	4798                	lw	a4,8(a5)
  400894:	09377663          	bgeu	a4,s3,400920 <malloc+0xb8>
  400898:	f426                	sd	s1,40(sp)
  40089a:	e852                	sd	s4,16(sp)
  40089c:	e456                	sd	s5,8(sp)
  40089e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  4008a0:	8a4e                	mv	s4,s3
  4008a2:	6705                	lui	a4,0x1
  4008a4:	00e9f363          	bgeu	s3,a4,4008aa <malloc+0x42>
  4008a8:	6a05                	lui	s4,0x1
  4008aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  4008ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  4008b2:	00000497          	auipc	s1,0x0
  4008b6:	74e48493          	addi	s1,s1,1870 # 401000 <freep>
  if(p == (char*)-1)
  4008ba:	5afd                	li	s5,-1
  4008bc:	a83d                	j	4008fa <malloc+0x92>
  4008be:	f426                	sd	s1,40(sp)
  4008c0:	e852                	sd	s4,16(sp)
  4008c2:	e456                	sd	s5,8(sp)
  4008c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  4008c6:	00000797          	auipc	a5,0x0
  4008ca:	74a78793          	addi	a5,a5,1866 # 401010 <base>
  4008ce:	00000717          	auipc	a4,0x0
  4008d2:	72f73923          	sd	a5,1842(a4) # 401000 <freep>
  4008d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  4008d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  4008dc:	b7d1                	j	4008a0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  4008de:	6398                	ld	a4,0(a5)
  4008e0:	e118                	sd	a4,0(a0)
  4008e2:	a899                	j	400938 <malloc+0xd0>
  hp->s.size = nu;
  4008e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  4008e8:	0541                	addi	a0,a0,16
  4008ea:	ef9ff0ef          	jal	4007e2 <free>
  return freep;
  4008ee:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  4008f0:	c125                	beqz	a0,400950 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4008f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4008f4:	4798                	lw	a4,8(a5)
  4008f6:	03277163          	bgeu	a4,s2,400918 <malloc+0xb0>
    if(p == freep)
  4008fa:	6098                	ld	a4,0(s1)
  4008fc:	853e                	mv	a0,a5
  4008fe:	fef71ae3          	bne	a4,a5,4008f2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400902:	8552                	mv	a0,s4
  400904:	b17ff0ef          	jal	40041a <sbrk>
  if(p == (char*)-1)
  400908:	fd551ee3          	bne	a0,s5,4008e4 <malloc+0x7c>
        return 0;
  40090c:	4501                	li	a0,0
  40090e:	74a2                	ld	s1,40(sp)
  400910:	6a42                	ld	s4,16(sp)
  400912:	6aa2                	ld	s5,8(sp)
  400914:	6b02                	ld	s6,0(sp)
  400916:	a03d                	j	400944 <malloc+0xdc>
  400918:	74a2                	ld	s1,40(sp)
  40091a:	6a42                	ld	s4,16(sp)
  40091c:	6aa2                	ld	s5,8(sp)
  40091e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400920:	fae90fe3          	beq	s2,a4,4008de <malloc+0x76>
        p->s.size -= nunits;
  400924:	4137073b          	subw	a4,a4,s3
  400928:	c798                	sw	a4,8(a5)
        p += p->s.size;
  40092a:	02071693          	slli	a3,a4,0x20
  40092e:	01c6d713          	srli	a4,a3,0x1c
  400932:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  400934:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400938:	00000717          	auipc	a4,0x0
  40093c:	6ca73423          	sd	a0,1736(a4) # 401000 <freep>
      return (void*)(p + 1);
  400940:	01078513          	addi	a0,a5,16
  }
}
  400944:	70e2                	ld	ra,56(sp)
  400946:	7442                	ld	s0,48(sp)
  400948:	7902                	ld	s2,32(sp)
  40094a:	69e2                	ld	s3,24(sp)
  40094c:	6121                	addi	sp,sp,64
  40094e:	8082                	ret
  400950:	74a2                	ld	s1,40(sp)
  400952:	6a42                	ld	s4,16(sp)
  400954:	6aa2                	ld	s5,8(sp)
  400956:	6b02                	ld	s6,0(sp)
  400958:	b7f5                	j	400944 <malloc+0xdc>
