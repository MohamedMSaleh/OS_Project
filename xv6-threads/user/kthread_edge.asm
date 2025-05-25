
user/_kthread_edge:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <thread_func>:
#include "user/user.h"
#include "kernel/types.h"
#define STACK_SIZE 4096
#define TIMEOUT_TICKS 10000000

void thread_func() { kthread_exit(123); }
  400000:	1141                	addi	sp,sp,-16
  400002:	e406                	sd	ra,8(sp)
  400004:	e022                	sd	s0,0(sp)
  400006:	0800                	addi	s0,sp,16
  400008:	07b00513          	li	a0,123
  40000c:	47e000ef          	jal	40048a <kthread_exit>

0000000000400010 <main>:

int main() {
  400010:	711d                	addi	sp,sp,-96
  400012:	ec86                	sd	ra,88(sp)
  400014:	e8a2                	sd	s0,80(sp)
  400016:	e0ca                	sd	s2,64(sp)
  400018:	ec5e                	sd	s7,24(sp)
  40001a:	1080                	addi	s0,sp,96
  printf("[main] Starting kthread_edge\n");
  40001c:	00001517          	auipc	a0,0x1
  400020:	99450513          	addi	a0,a0,-1644 # 4009b0 <malloc+0xf8>
  400024:	7da000ef          	jal	4007fe <printf>
  void *stack = malloc(STACK_SIZE);
  400028:	6505                	lui	a0,0x1
  40002a:	08f000ef          	jal	4008b8 <malloc>
  40002e:	8baa                	mv	s7,a0
  int tid = kthread_create(thread_func, stack, STACK_SIZE);
  400030:	6605                	lui	a2,0x1
  400032:	85aa                	mv	a1,a0
  400034:	00000517          	auipc	a0,0x0
  400038:	fcc50513          	addi	a0,a0,-52 # 400000 <thread_func>
  40003c:	446000ef          	jal	400482 <kthread_create>
  400040:	892a                	mv	s2,a0
  printf("[main] kthread_create returned tid=%d\n", tid);
  400042:	85aa                	mv	a1,a0
  400044:	00001517          	auipc	a0,0x1
  400048:	98c50513          	addi	a0,a0,-1652 # 4009d0 <malloc+0x118>
  40004c:	7b2000ef          	jal	4007fe <printf>
  if (tid < 0) {
  400050:	02094e63          	bltz	s2,40008c <main+0x7c>
  400054:	e4a6                	sd	s1,72(sp)
  400056:	fc4e                	sd	s3,56(sp)
  400058:	f852                	sd	s4,48(sp)
  40005a:	f456                	sd	s5,40(sp)
  40005c:	f05a                	sd	s6,32(sp)
  40005e:	e862                	sd	s8,16(sp)
    printf("kthread_create failed\n");
    exit(1);
  }
  int status = 0;
  400060:	fa042623          	sw	zero,-84(s0)
  int ret = -1;
  int ticks = 0;
  400064:	4481                	li	s1,0
  while (ticks < TIMEOUT_TICKS) {
    ret = kthread_join(tid, &status);
  400066:	fac40b13          	addi	s6,s0,-84
    if (ret == 0) break;
    ticks++;
    if (ticks % 1000000 == 0) printf("[main] Waiting for thread to join...\n");
  40006a:	431beab7          	lui	s5,0x431be
  40006e:	e83a8a93          	addi	s5,s5,-381 # 431bde83 <base+0x42dbce73>
  400072:	000f4a37          	lui	s4,0xf4
  400076:	240a0a1b          	addiw	s4,s4,576 # f4240 <thread_func-0x30bdc0>
  40007a:	00001c17          	auipc	s8,0x1
  40007e:	996c0c13          	addi	s8,s8,-1642 # 400a10 <malloc+0x158>
  while (ticks < TIMEOUT_TICKS) {
  400082:	009899b7          	lui	s3,0x989
  400086:	68098993          	addi	s3,s3,1664 # 989680 <base+0x588670>
  40008a:	a015                	j	4000ae <main+0x9e>
  40008c:	e4a6                	sd	s1,72(sp)
  40008e:	fc4e                	sd	s3,56(sp)
  400090:	f852                	sd	s4,48(sp)
  400092:	f456                	sd	s5,40(sp)
  400094:	f05a                	sd	s6,32(sp)
  400096:	e862                	sd	s8,16(sp)
    printf("kthread_create failed\n");
  400098:	00001517          	auipc	a0,0x1
  40009c:	96050513          	addi	a0,a0,-1696 # 4009f8 <malloc+0x140>
  4000a0:	75e000ef          	jal	4007fe <printf>
    exit(1);
  4000a4:	4505                	li	a0,1
  4000a6:	33c000ef          	jal	4003e2 <exit>
  while (ticks < TIMEOUT_TICKS) {
  4000aa:	09348663          	beq	s1,s3,400136 <main+0x126>
    ret = kthread_join(tid, &status);
  4000ae:	85da                	mv	a1,s6
  4000b0:	854a                	mv	a0,s2
  4000b2:	3e0000ef          	jal	400492 <kthread_join>
    if (ret == 0) break;
  4000b6:	c115                	beqz	a0,4000da <main+0xca>
    ticks++;
  4000b8:	0014871b          	addiw	a4,s1,1
  4000bc:	84ba                	mv	s1,a4
    if (ticks % 1000000 == 0) printf("[main] Waiting for thread to join...\n");
  4000be:	035707b3          	mul	a5,a4,s5
  4000c2:	97c9                	srai	a5,a5,0x32
  4000c4:	41f7569b          	sraiw	a3,a4,0x1f
  4000c8:	9f95                	subw	a5,a5,a3
  4000ca:	02fa07bb          	mulw	a5,s4,a5
  4000ce:	9f1d                	subw	a4,a4,a5
  4000d0:	ff69                	bnez	a4,4000aa <main+0x9a>
  4000d2:	8562                	mv	a0,s8
  4000d4:	72a000ef          	jal	4007fe <printf>
  4000d8:	bfc9                	j	4000aa <main+0x9a>
  }
  if (ret == 0) {
    printf("[main] Thread joined, exit status: %d\n", status);
  4000da:	fac42583          	lw	a1,-84(s0)
  4000de:	00001517          	auipc	a0,0x1
  4000e2:	9e250513          	addi	a0,a0,-1566 # 400ac0 <malloc+0x208>
  4000e6:	718000ef          	jal	4007fe <printf>
  } else {
    printf("[main] kthread_join failed or timed out\n");
  }
  // Double join
  ret = kthread_join(tid, &status);
  4000ea:	fac40493          	addi	s1,s0,-84
  4000ee:	85a6                	mv	a1,s1
  4000f0:	854a                	mv	a0,s2
  4000f2:	3a0000ef          	jal	400492 <kthread_join>
  4000f6:	85aa                	mv	a1,a0
  printf("[main] Double join returned: %d (should fail)\n", ret);
  4000f8:	00001517          	auipc	a0,0x1
  4000fc:	94050513          	addi	a0,a0,-1728 # 400a38 <malloc+0x180>
  400100:	6fe000ef          	jal	4007fe <printf>
  // Join on invalid TID
  ret = kthread_join(9999, &status);
  400104:	85a6                	mv	a1,s1
  400106:	6509                	lui	a0,0x2
  400108:	70f50513          	addi	a0,a0,1807 # 270f <thread_func-0x3fd8f1>
  40010c:	386000ef          	jal	400492 <kthread_join>
  400110:	85aa                	mv	a1,a0
  printf("[main] Join on invalid TID returned: %d (should fail)\n", ret);
  400112:	00001517          	auipc	a0,0x1
  400116:	95650513          	addi	a0,a0,-1706 # 400a68 <malloc+0x1b0>
  40011a:	6e4000ef          	jal	4007fe <printf>
  free(stack);
  40011e:	855e                	mv	a0,s7
  400120:	712000ef          	jal	400832 <free>
  printf("[main] Exiting kthread_edge\n");
  400124:	00001517          	auipc	a0,0x1
  400128:	97c50513          	addi	a0,a0,-1668 # 400aa0 <malloc+0x1e8>
  40012c:	6d2000ef          	jal	4007fe <printf>
  exit(0);
  400130:	4501                	li	a0,0
  400132:	2b0000ef          	jal	4003e2 <exit>
    printf("[main] kthread_join failed or timed out\n");
  400136:	00001517          	auipc	a0,0x1
  40013a:	9b250513          	addi	a0,a0,-1614 # 400ae8 <malloc+0x230>
  40013e:	6c0000ef          	jal	4007fe <printf>
  400142:	b765                	j	4000ea <main+0xda>

0000000000400144 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  400144:	1141                	addi	sp,sp,-16
  400146:	e406                	sd	ra,8(sp)
  400148:	e022                	sd	s0,0(sp)
  40014a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  40014c:	ec5ff0ef          	jal	400010 <main>
  exit(0);
  400150:	4501                	li	a0,0
  400152:	290000ef          	jal	4003e2 <exit>

0000000000400156 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400156:	1141                	addi	sp,sp,-16
  400158:	e406                	sd	ra,8(sp)
  40015a:	e022                	sd	s0,0(sp)
  40015c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40015e:	87aa                	mv	a5,a0
  400160:	0585                	addi	a1,a1,1
  400162:	0785                	addi	a5,a5,1
  400164:	fff5c703          	lbu	a4,-1(a1)
  400168:	fee78fa3          	sb	a4,-1(a5)
  40016c:	fb75                	bnez	a4,400160 <strcpy+0xa>
    ;
  return os;
}
  40016e:	60a2                	ld	ra,8(sp)
  400170:	6402                	ld	s0,0(sp)
  400172:	0141                	addi	sp,sp,16
  400174:	8082                	ret

0000000000400176 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400176:	1141                	addi	sp,sp,-16
  400178:	e406                	sd	ra,8(sp)
  40017a:	e022                	sd	s0,0(sp)
  40017c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  40017e:	00054783          	lbu	a5,0(a0)
  400182:	cb91                	beqz	a5,400196 <strcmp+0x20>
  400184:	0005c703          	lbu	a4,0(a1)
  400188:	00f71763          	bne	a4,a5,400196 <strcmp+0x20>
    p++, q++;
  40018c:	0505                	addi	a0,a0,1
  40018e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  400190:	00054783          	lbu	a5,0(a0)
  400194:	fbe5                	bnez	a5,400184 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  400196:	0005c503          	lbu	a0,0(a1)
}
  40019a:	40a7853b          	subw	a0,a5,a0
  40019e:	60a2                	ld	ra,8(sp)
  4001a0:	6402                	ld	s0,0(sp)
  4001a2:	0141                	addi	sp,sp,16
  4001a4:	8082                	ret

00000000004001a6 <strlen>:

uint
strlen(const char *s)
{
  4001a6:	1141                	addi	sp,sp,-16
  4001a8:	e406                	sd	ra,8(sp)
  4001aa:	e022                	sd	s0,0(sp)
  4001ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4001ae:	00054783          	lbu	a5,0(a0)
  4001b2:	cf99                	beqz	a5,4001d0 <strlen+0x2a>
  4001b4:	0505                	addi	a0,a0,1
  4001b6:	87aa                	mv	a5,a0
  4001b8:	86be                	mv	a3,a5
  4001ba:	0785                	addi	a5,a5,1
  4001bc:	fff7c703          	lbu	a4,-1(a5)
  4001c0:	ff65                	bnez	a4,4001b8 <strlen+0x12>
  4001c2:	40a6853b          	subw	a0,a3,a0
  4001c6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4001c8:	60a2                	ld	ra,8(sp)
  4001ca:	6402                	ld	s0,0(sp)
  4001cc:	0141                	addi	sp,sp,16
  4001ce:	8082                	ret
  for(n = 0; s[n]; n++)
  4001d0:	4501                	li	a0,0
  4001d2:	bfdd                	j	4001c8 <strlen+0x22>

00000000004001d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  4001d4:	1141                	addi	sp,sp,-16
  4001d6:	e406                	sd	ra,8(sp)
  4001d8:	e022                	sd	s0,0(sp)
  4001da:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  4001dc:	ca19                	beqz	a2,4001f2 <memset+0x1e>
  4001de:	87aa                	mv	a5,a0
  4001e0:	1602                	slli	a2,a2,0x20
  4001e2:	9201                	srli	a2,a2,0x20
  4001e4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  4001e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  4001ec:	0785                	addi	a5,a5,1
  4001ee:	fee79de3          	bne	a5,a4,4001e8 <memset+0x14>
  }
  return dst;
}
  4001f2:	60a2                	ld	ra,8(sp)
  4001f4:	6402                	ld	s0,0(sp)
  4001f6:	0141                	addi	sp,sp,16
  4001f8:	8082                	ret

00000000004001fa <strchr>:

char*
strchr(const char *s, char c)
{
  4001fa:	1141                	addi	sp,sp,-16
  4001fc:	e406                	sd	ra,8(sp)
  4001fe:	e022                	sd	s0,0(sp)
  400200:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400202:	00054783          	lbu	a5,0(a0)
  400206:	cf81                	beqz	a5,40021e <strchr+0x24>
    if(*s == c)
  400208:	00f58763          	beq	a1,a5,400216 <strchr+0x1c>
  for(; *s; s++)
  40020c:	0505                	addi	a0,a0,1
  40020e:	00054783          	lbu	a5,0(a0)
  400212:	fbfd                	bnez	a5,400208 <strchr+0xe>
      return (char*)s;
  return 0;
  400214:	4501                	li	a0,0
}
  400216:	60a2                	ld	ra,8(sp)
  400218:	6402                	ld	s0,0(sp)
  40021a:	0141                	addi	sp,sp,16
  40021c:	8082                	ret
  return 0;
  40021e:	4501                	li	a0,0
  400220:	bfdd                	j	400216 <strchr+0x1c>

0000000000400222 <gets>:

char*
gets(char *buf, int max)
{
  400222:	7159                	addi	sp,sp,-112
  400224:	f486                	sd	ra,104(sp)
  400226:	f0a2                	sd	s0,96(sp)
  400228:	eca6                	sd	s1,88(sp)
  40022a:	e8ca                	sd	s2,80(sp)
  40022c:	e4ce                	sd	s3,72(sp)
  40022e:	e0d2                	sd	s4,64(sp)
  400230:	fc56                	sd	s5,56(sp)
  400232:	f85a                	sd	s6,48(sp)
  400234:	f45e                	sd	s7,40(sp)
  400236:	f062                	sd	s8,32(sp)
  400238:	ec66                	sd	s9,24(sp)
  40023a:	e86a                	sd	s10,16(sp)
  40023c:	1880                	addi	s0,sp,112
  40023e:	8caa                	mv	s9,a0
  400240:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400242:	892a                	mv	s2,a0
  400244:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400246:	f9f40b13          	addi	s6,s0,-97
  40024a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  40024c:	4ba9                	li	s7,10
  40024e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400250:	8d26                	mv	s10,s1
  400252:	0014899b          	addiw	s3,s1,1
  400256:	84ce                	mv	s1,s3
  400258:	0349d563          	bge	s3,s4,400282 <gets+0x60>
    cc = read(0, &c, 1);
  40025c:	8656                	mv	a2,s5
  40025e:	85da                	mv	a1,s6
  400260:	4501                	li	a0,0
  400262:	198000ef          	jal	4003fa <read>
    if(cc < 1)
  400266:	00a05e63          	blez	a0,400282 <gets+0x60>
    buf[i++] = c;
  40026a:	f9f44783          	lbu	a5,-97(s0)
  40026e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400272:	01778763          	beq	a5,s7,400280 <gets+0x5e>
  400276:	0905                	addi	s2,s2,1
  400278:	fd879ce3          	bne	a5,s8,400250 <gets+0x2e>
    buf[i++] = c;
  40027c:	8d4e                	mv	s10,s3
  40027e:	a011                	j	400282 <gets+0x60>
  400280:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  400282:	9d66                	add	s10,s10,s9
  400284:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400288:	8566                	mv	a0,s9
  40028a:	70a6                	ld	ra,104(sp)
  40028c:	7406                	ld	s0,96(sp)
  40028e:	64e6                	ld	s1,88(sp)
  400290:	6946                	ld	s2,80(sp)
  400292:	69a6                	ld	s3,72(sp)
  400294:	6a06                	ld	s4,64(sp)
  400296:	7ae2                	ld	s5,56(sp)
  400298:	7b42                	ld	s6,48(sp)
  40029a:	7ba2                	ld	s7,40(sp)
  40029c:	7c02                	ld	s8,32(sp)
  40029e:	6ce2                	ld	s9,24(sp)
  4002a0:	6d42                	ld	s10,16(sp)
  4002a2:	6165                	addi	sp,sp,112
  4002a4:	8082                	ret

00000000004002a6 <stat>:

int
stat(const char *n, struct stat *st)
{
  4002a6:	1101                	addi	sp,sp,-32
  4002a8:	ec06                	sd	ra,24(sp)
  4002aa:	e822                	sd	s0,16(sp)
  4002ac:	e04a                	sd	s2,0(sp)
  4002ae:	1000                	addi	s0,sp,32
  4002b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4002b2:	4581                	li	a1,0
  4002b4:	16e000ef          	jal	400422 <open>
  if(fd < 0)
  4002b8:	02054263          	bltz	a0,4002dc <stat+0x36>
  4002bc:	e426                	sd	s1,8(sp)
  4002be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4002c0:	85ca                	mv	a1,s2
  4002c2:	178000ef          	jal	40043a <fstat>
  4002c6:	892a                	mv	s2,a0
  close(fd);
  4002c8:	8526                	mv	a0,s1
  4002ca:	140000ef          	jal	40040a <close>
  return r;
  4002ce:	64a2                	ld	s1,8(sp)
}
  4002d0:	854a                	mv	a0,s2
  4002d2:	60e2                	ld	ra,24(sp)
  4002d4:	6442                	ld	s0,16(sp)
  4002d6:	6902                	ld	s2,0(sp)
  4002d8:	6105                	addi	sp,sp,32
  4002da:	8082                	ret
    return -1;
  4002dc:	597d                	li	s2,-1
  4002de:	bfcd                	j	4002d0 <stat+0x2a>

00000000004002e0 <atoi>:

int
atoi(const char *s)
{
  4002e0:	1141                	addi	sp,sp,-16
  4002e2:	e406                	sd	ra,8(sp)
  4002e4:	e022                	sd	s0,0(sp)
  4002e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  4002e8:	00054683          	lbu	a3,0(a0)
  4002ec:	fd06879b          	addiw	a5,a3,-48
  4002f0:	0ff7f793          	zext.b	a5,a5
  4002f4:	4625                	li	a2,9
  4002f6:	02f66963          	bltu	a2,a5,400328 <atoi+0x48>
  4002fa:	872a                	mv	a4,a0
  n = 0;
  4002fc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  4002fe:	0705                	addi	a4,a4,1
  400300:	0025179b          	slliw	a5,a0,0x2
  400304:	9fa9                	addw	a5,a5,a0
  400306:	0017979b          	slliw	a5,a5,0x1
  40030a:	9fb5                	addw	a5,a5,a3
  40030c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400310:	00074683          	lbu	a3,0(a4)
  400314:	fd06879b          	addiw	a5,a3,-48
  400318:	0ff7f793          	zext.b	a5,a5
  40031c:	fef671e3          	bgeu	a2,a5,4002fe <atoi+0x1e>
  return n;
}
  400320:	60a2                	ld	ra,8(sp)
  400322:	6402                	ld	s0,0(sp)
  400324:	0141                	addi	sp,sp,16
  400326:	8082                	ret
  n = 0;
  400328:	4501                	li	a0,0
  40032a:	bfdd                	j	400320 <atoi+0x40>

000000000040032c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  40032c:	1141                	addi	sp,sp,-16
  40032e:	e406                	sd	ra,8(sp)
  400330:	e022                	sd	s0,0(sp)
  400332:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400334:	02b57563          	bgeu	a0,a1,40035e <memmove+0x32>
    while(n-- > 0)
  400338:	00c05f63          	blez	a2,400356 <memmove+0x2a>
  40033c:	1602                	slli	a2,a2,0x20
  40033e:	9201                	srli	a2,a2,0x20
  400340:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400344:	872a                	mv	a4,a0
      *dst++ = *src++;
  400346:	0585                	addi	a1,a1,1
  400348:	0705                	addi	a4,a4,1
  40034a:	fff5c683          	lbu	a3,-1(a1)
  40034e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400352:	fee79ae3          	bne	a5,a4,400346 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400356:	60a2                	ld	ra,8(sp)
  400358:	6402                	ld	s0,0(sp)
  40035a:	0141                	addi	sp,sp,16
  40035c:	8082                	ret
    dst += n;
  40035e:	00c50733          	add	a4,a0,a2
    src += n;
  400362:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400364:	fec059e3          	blez	a2,400356 <memmove+0x2a>
  400368:	fff6079b          	addiw	a5,a2,-1 # fff <thread_func-0x3ff001>
  40036c:	1782                	slli	a5,a5,0x20
  40036e:	9381                	srli	a5,a5,0x20
  400370:	fff7c793          	not	a5,a5
  400374:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400376:	15fd                	addi	a1,a1,-1
  400378:	177d                	addi	a4,a4,-1
  40037a:	0005c683          	lbu	a3,0(a1)
  40037e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  400382:	fef71ae3          	bne	a4,a5,400376 <memmove+0x4a>
  400386:	bfc1                	j	400356 <memmove+0x2a>

0000000000400388 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400388:	1141                	addi	sp,sp,-16
  40038a:	e406                	sd	ra,8(sp)
  40038c:	e022                	sd	s0,0(sp)
  40038e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  400390:	ca0d                	beqz	a2,4003c2 <memcmp+0x3a>
  400392:	fff6069b          	addiw	a3,a2,-1
  400396:	1682                	slli	a3,a3,0x20
  400398:	9281                	srli	a3,a3,0x20
  40039a:	0685                	addi	a3,a3,1
  40039c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  40039e:	00054783          	lbu	a5,0(a0)
  4003a2:	0005c703          	lbu	a4,0(a1)
  4003a6:	00e79863          	bne	a5,a4,4003b6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4003aa:	0505                	addi	a0,a0,1
    p2++;
  4003ac:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4003ae:	fed518e3          	bne	a0,a3,40039e <memcmp+0x16>
  }
  return 0;
  4003b2:	4501                	li	a0,0
  4003b4:	a019                	j	4003ba <memcmp+0x32>
      return *p1 - *p2;
  4003b6:	40e7853b          	subw	a0,a5,a4
}
  4003ba:	60a2                	ld	ra,8(sp)
  4003bc:	6402                	ld	s0,0(sp)
  4003be:	0141                	addi	sp,sp,16
  4003c0:	8082                	ret
  return 0;
  4003c2:	4501                	li	a0,0
  4003c4:	bfdd                	j	4003ba <memcmp+0x32>

00000000004003c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4003c6:	1141                	addi	sp,sp,-16
  4003c8:	e406                	sd	ra,8(sp)
  4003ca:	e022                	sd	s0,0(sp)
  4003cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4003ce:	f5fff0ef          	jal	40032c <memmove>
}
  4003d2:	60a2                	ld	ra,8(sp)
  4003d4:	6402                	ld	s0,0(sp)
  4003d6:	0141                	addi	sp,sp,16
  4003d8:	8082                	ret

00000000004003da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  4003da:	4885                	li	a7,1
 ecall
  4003dc:	00000073          	ecall
 ret
  4003e0:	8082                	ret

00000000004003e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
  4003e2:	4889                	li	a7,2
 ecall
  4003e4:	00000073          	ecall
 ret
  4003e8:	8082                	ret

00000000004003ea <wait>:
.global wait
wait:
 li a7, SYS_wait
  4003ea:	488d                	li	a7,3
 ecall
  4003ec:	00000073          	ecall
 ret
  4003f0:	8082                	ret

00000000004003f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  4003f2:	4891                	li	a7,4
 ecall
  4003f4:	00000073          	ecall
 ret
  4003f8:	8082                	ret

00000000004003fa <read>:
.global read
read:
 li a7, SYS_read
  4003fa:	4895                	li	a7,5
 ecall
  4003fc:	00000073          	ecall
 ret
  400400:	8082                	ret

0000000000400402 <write>:
.global write
write:
 li a7, SYS_write
  400402:	48c1                	li	a7,16
 ecall
  400404:	00000073          	ecall
 ret
  400408:	8082                	ret

000000000040040a <close>:
.global close
close:
 li a7, SYS_close
  40040a:	48d5                	li	a7,21
 ecall
  40040c:	00000073          	ecall
 ret
  400410:	8082                	ret

0000000000400412 <kill>:
.global kill
kill:
 li a7, SYS_kill
  400412:	4899                	li	a7,6
 ecall
  400414:	00000073          	ecall
 ret
  400418:	8082                	ret

000000000040041a <exec>:
.global exec
exec:
 li a7, SYS_exec
  40041a:	489d                	li	a7,7
 ecall
  40041c:	00000073          	ecall
 ret
  400420:	8082                	ret

0000000000400422 <open>:
.global open
open:
 li a7, SYS_open
  400422:	48bd                	li	a7,15
 ecall
  400424:	00000073          	ecall
 ret
  400428:	8082                	ret

000000000040042a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  40042a:	48c5                	li	a7,17
 ecall
  40042c:	00000073          	ecall
 ret
  400430:	8082                	ret

0000000000400432 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400432:	48c9                	li	a7,18
 ecall
  400434:	00000073          	ecall
 ret
  400438:	8082                	ret

000000000040043a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  40043a:	48a1                	li	a7,8
 ecall
  40043c:	00000073          	ecall
 ret
  400440:	8082                	ret

0000000000400442 <link>:
.global link
link:
 li a7, SYS_link
  400442:	48cd                	li	a7,19
 ecall
  400444:	00000073          	ecall
 ret
  400448:	8082                	ret

000000000040044a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  40044a:	48d1                	li	a7,20
 ecall
  40044c:	00000073          	ecall
 ret
  400450:	8082                	ret

0000000000400452 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400452:	48a5                	li	a7,9
 ecall
  400454:	00000073          	ecall
 ret
  400458:	8082                	ret

000000000040045a <dup>:
.global dup
dup:
 li a7, SYS_dup
  40045a:	48a9                	li	a7,10
 ecall
  40045c:	00000073          	ecall
 ret
  400460:	8082                	ret

0000000000400462 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400462:	48ad                	li	a7,11
 ecall
  400464:	00000073          	ecall
 ret
  400468:	8082                	ret

000000000040046a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  40046a:	48b1                	li	a7,12
 ecall
  40046c:	00000073          	ecall
 ret
  400470:	8082                	ret

0000000000400472 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400472:	48b5                	li	a7,13
 ecall
  400474:	00000073          	ecall
 ret
  400478:	8082                	ret

000000000040047a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  40047a:	48b9                	li	a7,14
 ecall
  40047c:	00000073          	ecall
 ret
  400480:	8082                	ret

0000000000400482 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  400482:	48d9                	li	a7,22
 ecall
  400484:	00000073          	ecall
 ret
  400488:	8082                	ret

000000000040048a <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  40048a:	48dd                	li	a7,23
 ecall
  40048c:	00000073          	ecall
 ret
  400490:	8082                	ret

0000000000400492 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  400492:	48e1                	li	a7,24
 ecall
  400494:	00000073          	ecall
 ret
  400498:	8082                	ret

000000000040049a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  40049a:	1101                	addi	sp,sp,-32
  40049c:	ec06                	sd	ra,24(sp)
  40049e:	e822                	sd	s0,16(sp)
  4004a0:	1000                	addi	s0,sp,32
  4004a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4004a6:	4605                	li	a2,1
  4004a8:	fef40593          	addi	a1,s0,-17
  4004ac:	f57ff0ef          	jal	400402 <write>
}
  4004b0:	60e2                	ld	ra,24(sp)
  4004b2:	6442                	ld	s0,16(sp)
  4004b4:	6105                	addi	sp,sp,32
  4004b6:	8082                	ret

00000000004004b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4004b8:	7139                	addi	sp,sp,-64
  4004ba:	fc06                	sd	ra,56(sp)
  4004bc:	f822                	sd	s0,48(sp)
  4004be:	f426                	sd	s1,40(sp)
  4004c0:	f04a                	sd	s2,32(sp)
  4004c2:	ec4e                	sd	s3,24(sp)
  4004c4:	0080                	addi	s0,sp,64
  4004c6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4004c8:	c299                	beqz	a3,4004ce <printint+0x16>
  4004ca:	0605ce63          	bltz	a1,400546 <printint+0x8e>
  neg = 0;
  4004ce:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4004d0:	fc040313          	addi	t1,s0,-64
  neg = 0;
  4004d4:	869a                	mv	a3,t1
  i = 0;
  4004d6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  4004d8:	00000817          	auipc	a6,0x0
  4004dc:	64880813          	addi	a6,a6,1608 # 400b20 <digits>
  4004e0:	88be                	mv	a7,a5
  4004e2:	0017851b          	addiw	a0,a5,1
  4004e6:	87aa                	mv	a5,a0
  4004e8:	02c5f73b          	remuw	a4,a1,a2
  4004ec:	1702                	slli	a4,a4,0x20
  4004ee:	9301                	srli	a4,a4,0x20
  4004f0:	9742                	add	a4,a4,a6
  4004f2:	00074703          	lbu	a4,0(a4)
  4004f6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  4004fa:	872e                	mv	a4,a1
  4004fc:	02c5d5bb          	divuw	a1,a1,a2
  400500:	0685                	addi	a3,a3,1
  400502:	fcc77fe3          	bgeu	a4,a2,4004e0 <printint+0x28>
  if(neg)
  400506:	000e0c63          	beqz	t3,40051e <printint+0x66>
    buf[i++] = '-';
  40050a:	fd050793          	addi	a5,a0,-48
  40050e:	00878533          	add	a0,a5,s0
  400512:	02d00793          	li	a5,45
  400516:	fef50823          	sb	a5,-16(a0)
  40051a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  40051e:	fff7899b          	addiw	s3,a5,-1
  400522:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400526:	fff4c583          	lbu	a1,-1(s1)
  40052a:	854a                	mv	a0,s2
  40052c:	f6fff0ef          	jal	40049a <putc>
  while(--i >= 0)
  400530:	39fd                	addiw	s3,s3,-1
  400532:	14fd                	addi	s1,s1,-1
  400534:	fe09d9e3          	bgez	s3,400526 <printint+0x6e>
}
  400538:	70e2                	ld	ra,56(sp)
  40053a:	7442                	ld	s0,48(sp)
  40053c:	74a2                	ld	s1,40(sp)
  40053e:	7902                	ld	s2,32(sp)
  400540:	69e2                	ld	s3,24(sp)
  400542:	6121                	addi	sp,sp,64
  400544:	8082                	ret
    x = -xx;
  400546:	40b005bb          	negw	a1,a1
    neg = 1;
  40054a:	4e05                	li	t3,1
    x = -xx;
  40054c:	b751                	j	4004d0 <printint+0x18>

000000000040054e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  40054e:	711d                	addi	sp,sp,-96
  400550:	ec86                	sd	ra,88(sp)
  400552:	e8a2                	sd	s0,80(sp)
  400554:	e4a6                	sd	s1,72(sp)
  400556:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400558:	0005c483          	lbu	s1,0(a1)
  40055c:	26048663          	beqz	s1,4007c8 <vprintf+0x27a>
  400560:	e0ca                	sd	s2,64(sp)
  400562:	fc4e                	sd	s3,56(sp)
  400564:	f852                	sd	s4,48(sp)
  400566:	f456                	sd	s5,40(sp)
  400568:	f05a                	sd	s6,32(sp)
  40056a:	ec5e                	sd	s7,24(sp)
  40056c:	e862                	sd	s8,16(sp)
  40056e:	e466                	sd	s9,8(sp)
  400570:	8b2a                	mv	s6,a0
  400572:	8a2e                	mv	s4,a1
  400574:	8bb2                	mv	s7,a2
  state = 0;
  400576:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400578:	4901                	li	s2,0
  40057a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  40057c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  400580:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  400584:	06c00c93          	li	s9,108
  400588:	a00d                	j	4005aa <vprintf+0x5c>
        putc(fd, c0);
  40058a:	85a6                	mv	a1,s1
  40058c:	855a                	mv	a0,s6
  40058e:	f0dff0ef          	jal	40049a <putc>
  400592:	a019                	j	400598 <vprintf+0x4a>
    } else if(state == '%'){
  400594:	03598363          	beq	s3,s5,4005ba <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  400598:	0019079b          	addiw	a5,s2,1
  40059c:	893e                	mv	s2,a5
  40059e:	873e                	mv	a4,a5
  4005a0:	97d2                	add	a5,a5,s4
  4005a2:	0007c483          	lbu	s1,0(a5)
  4005a6:	20048963          	beqz	s1,4007b8 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4005aa:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4005ae:	fe0993e3          	bnez	s3,400594 <vprintf+0x46>
      if(c0 == '%'){
  4005b2:	fd579ce3          	bne	a5,s5,40058a <vprintf+0x3c>
        state = '%';
  4005b6:	89be                	mv	s3,a5
  4005b8:	b7c5                	j	400598 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4005ba:	00ea06b3          	add	a3,s4,a4
  4005be:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4005c2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4005c4:	c681                	beqz	a3,4005cc <vprintf+0x7e>
  4005c6:	9752                	add	a4,a4,s4
  4005c8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4005cc:	03878e63          	beq	a5,s8,400608 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4005d0:	05978863          	beq	a5,s9,400620 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  4005d4:	07500713          	li	a4,117
  4005d8:	0ee78263          	beq	a5,a4,4006bc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  4005dc:	07800713          	li	a4,120
  4005e0:	12e78463          	beq	a5,a4,400708 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  4005e4:	07000713          	li	a4,112
  4005e8:	14e78963          	beq	a5,a4,40073a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  4005ec:	07300713          	li	a4,115
  4005f0:	18e78863          	beq	a5,a4,400780 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  4005f4:	02500713          	li	a4,37
  4005f8:	04e79463          	bne	a5,a4,400640 <vprintf+0xf2>
        putc(fd, '%');
  4005fc:	85ba                	mv	a1,a4
  4005fe:	855a                	mv	a0,s6
  400600:	e9bff0ef          	jal	40049a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400604:	4981                	li	s3,0
  400606:	bf49                	j	400598 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400608:	008b8493          	addi	s1,s7,8
  40060c:	4685                	li	a3,1
  40060e:	4629                	li	a2,10
  400610:	000ba583          	lw	a1,0(s7)
  400614:	855a                	mv	a0,s6
  400616:	ea3ff0ef          	jal	4004b8 <printint>
  40061a:	8ba6                	mv	s7,s1
      state = 0;
  40061c:	4981                	li	s3,0
  40061e:	bfad                	j	400598 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400620:	06400793          	li	a5,100
  400624:	02f68963          	beq	a3,a5,400656 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400628:	06c00793          	li	a5,108
  40062c:	04f68263          	beq	a3,a5,400670 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400630:	07500793          	li	a5,117
  400634:	0af68063          	beq	a3,a5,4006d4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400638:	07800793          	li	a5,120
  40063c:	0ef68263          	beq	a3,a5,400720 <vprintf+0x1d2>
        putc(fd, '%');
  400640:	02500593          	li	a1,37
  400644:	855a                	mv	a0,s6
  400646:	e55ff0ef          	jal	40049a <putc>
        putc(fd, c0);
  40064a:	85a6                	mv	a1,s1
  40064c:	855a                	mv	a0,s6
  40064e:	e4dff0ef          	jal	40049a <putc>
      state = 0;
  400652:	4981                	li	s3,0
  400654:	b791                	j	400598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400656:	008b8493          	addi	s1,s7,8
  40065a:	4685                	li	a3,1
  40065c:	4629                	li	a2,10
  40065e:	000ba583          	lw	a1,0(s7)
  400662:	855a                	mv	a0,s6
  400664:	e55ff0ef          	jal	4004b8 <printint>
        i += 1;
  400668:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  40066a:	8ba6                	mv	s7,s1
      state = 0;
  40066c:	4981                	li	s3,0
        i += 1;
  40066e:	b72d                	j	400598 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400670:	06400793          	li	a5,100
  400674:	02f60763          	beq	a2,a5,4006a2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400678:	07500793          	li	a5,117
  40067c:	06f60963          	beq	a2,a5,4006ee <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  400680:	07800793          	li	a5,120
  400684:	faf61ee3          	bne	a2,a5,400640 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400688:	008b8493          	addi	s1,s7,8
  40068c:	4681                	li	a3,0
  40068e:	4641                	li	a2,16
  400690:	000ba583          	lw	a1,0(s7)
  400694:	855a                	mv	a0,s6
  400696:	e23ff0ef          	jal	4004b8 <printint>
        i += 2;
  40069a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  40069c:	8ba6                	mv	s7,s1
      state = 0;
  40069e:	4981                	li	s3,0
        i += 2;
  4006a0:	bde5                	j	400598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4006a2:	008b8493          	addi	s1,s7,8
  4006a6:	4685                	li	a3,1
  4006a8:	4629                	li	a2,10
  4006aa:	000ba583          	lw	a1,0(s7)
  4006ae:	855a                	mv	a0,s6
  4006b0:	e09ff0ef          	jal	4004b8 <printint>
        i += 2;
  4006b4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4006b6:	8ba6                	mv	s7,s1
      state = 0;
  4006b8:	4981                	li	s3,0
        i += 2;
  4006ba:	bdf9                	j	400598 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4006bc:	008b8493          	addi	s1,s7,8
  4006c0:	4681                	li	a3,0
  4006c2:	4629                	li	a2,10
  4006c4:	000ba583          	lw	a1,0(s7)
  4006c8:	855a                	mv	a0,s6
  4006ca:	defff0ef          	jal	4004b8 <printint>
  4006ce:	8ba6                	mv	s7,s1
      state = 0;
  4006d0:	4981                	li	s3,0
  4006d2:	b5d9                	j	400598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006d4:	008b8493          	addi	s1,s7,8
  4006d8:	4681                	li	a3,0
  4006da:	4629                	li	a2,10
  4006dc:	000ba583          	lw	a1,0(s7)
  4006e0:	855a                	mv	a0,s6
  4006e2:	dd7ff0ef          	jal	4004b8 <printint>
        i += 1;
  4006e6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006e8:	8ba6                	mv	s7,s1
      state = 0;
  4006ea:	4981                	li	s3,0
        i += 1;
  4006ec:	b575                	j	400598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006ee:	008b8493          	addi	s1,s7,8
  4006f2:	4681                	li	a3,0
  4006f4:	4629                	li	a2,10
  4006f6:	000ba583          	lw	a1,0(s7)
  4006fa:	855a                	mv	a0,s6
  4006fc:	dbdff0ef          	jal	4004b8 <printint>
        i += 2;
  400700:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400702:	8ba6                	mv	s7,s1
      state = 0;
  400704:	4981                	li	s3,0
        i += 2;
  400706:	bd49                	j	400598 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400708:	008b8493          	addi	s1,s7,8
  40070c:	4681                	li	a3,0
  40070e:	4641                	li	a2,16
  400710:	000ba583          	lw	a1,0(s7)
  400714:	855a                	mv	a0,s6
  400716:	da3ff0ef          	jal	4004b8 <printint>
  40071a:	8ba6                	mv	s7,s1
      state = 0;
  40071c:	4981                	li	s3,0
  40071e:	bdad                	j	400598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400720:	008b8493          	addi	s1,s7,8
  400724:	4681                	li	a3,0
  400726:	4641                	li	a2,16
  400728:	000ba583          	lw	a1,0(s7)
  40072c:	855a                	mv	a0,s6
  40072e:	d8bff0ef          	jal	4004b8 <printint>
        i += 1;
  400732:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400734:	8ba6                	mv	s7,s1
      state = 0;
  400736:	4981                	li	s3,0
        i += 1;
  400738:	b585                	j	400598 <vprintf+0x4a>
  40073a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  40073c:	008b8d13          	addi	s10,s7,8
  400740:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400744:	03000593          	li	a1,48
  400748:	855a                	mv	a0,s6
  40074a:	d51ff0ef          	jal	40049a <putc>
  putc(fd, 'x');
  40074e:	07800593          	li	a1,120
  400752:	855a                	mv	a0,s6
  400754:	d47ff0ef          	jal	40049a <putc>
  400758:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  40075a:	00000b97          	auipc	s7,0x0
  40075e:	3c6b8b93          	addi	s7,s7,966 # 400b20 <digits>
  400762:	03c9d793          	srli	a5,s3,0x3c
  400766:	97de                	add	a5,a5,s7
  400768:	0007c583          	lbu	a1,0(a5)
  40076c:	855a                	mv	a0,s6
  40076e:	d2dff0ef          	jal	40049a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400772:	0992                	slli	s3,s3,0x4
  400774:	34fd                	addiw	s1,s1,-1
  400776:	f4f5                	bnez	s1,400762 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400778:	8bea                	mv	s7,s10
      state = 0;
  40077a:	4981                	li	s3,0
  40077c:	6d02                	ld	s10,0(sp)
  40077e:	bd29                	j	400598 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  400780:	008b8993          	addi	s3,s7,8
  400784:	000bb483          	ld	s1,0(s7)
  400788:	cc91                	beqz	s1,4007a4 <vprintf+0x256>
        for(; *s; s++)
  40078a:	0004c583          	lbu	a1,0(s1)
  40078e:	c195                	beqz	a1,4007b2 <vprintf+0x264>
          putc(fd, *s);
  400790:	855a                	mv	a0,s6
  400792:	d09ff0ef          	jal	40049a <putc>
        for(; *s; s++)
  400796:	0485                	addi	s1,s1,1
  400798:	0004c583          	lbu	a1,0(s1)
  40079c:	f9f5                	bnez	a1,400790 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  40079e:	8bce                	mv	s7,s3
      state = 0;
  4007a0:	4981                	li	s3,0
  4007a2:	bbdd                	j	400598 <vprintf+0x4a>
          s = "(null)";
  4007a4:	00000497          	auipc	s1,0x0
  4007a8:	37448493          	addi	s1,s1,884 # 400b18 <malloc+0x260>
        for(; *s; s++)
  4007ac:	02800593          	li	a1,40
  4007b0:	b7c5                	j	400790 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4007b2:	8bce                	mv	s7,s3
      state = 0;
  4007b4:	4981                	li	s3,0
  4007b6:	b3cd                	j	400598 <vprintf+0x4a>
  4007b8:	6906                	ld	s2,64(sp)
  4007ba:	79e2                	ld	s3,56(sp)
  4007bc:	7a42                	ld	s4,48(sp)
  4007be:	7aa2                	ld	s5,40(sp)
  4007c0:	7b02                	ld	s6,32(sp)
  4007c2:	6be2                	ld	s7,24(sp)
  4007c4:	6c42                	ld	s8,16(sp)
  4007c6:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4007c8:	60e6                	ld	ra,88(sp)
  4007ca:	6446                	ld	s0,80(sp)
  4007cc:	64a6                	ld	s1,72(sp)
  4007ce:	6125                	addi	sp,sp,96
  4007d0:	8082                	ret

00000000004007d2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4007d2:	715d                	addi	sp,sp,-80
  4007d4:	ec06                	sd	ra,24(sp)
  4007d6:	e822                	sd	s0,16(sp)
  4007d8:	1000                	addi	s0,sp,32
  4007da:	e010                	sd	a2,0(s0)
  4007dc:	e414                	sd	a3,8(s0)
  4007de:	e818                	sd	a4,16(s0)
  4007e0:	ec1c                	sd	a5,24(s0)
  4007e2:	03043023          	sd	a6,32(s0)
  4007e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  4007ea:	8622                	mv	a2,s0
  4007ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  4007f0:	d5fff0ef          	jal	40054e <vprintf>
  return 0;
}
  4007f4:	4501                	li	a0,0
  4007f6:	60e2                	ld	ra,24(sp)
  4007f8:	6442                	ld	s0,16(sp)
  4007fa:	6161                	addi	sp,sp,80
  4007fc:	8082                	ret

00000000004007fe <printf>:

int
printf(const char *fmt, ...)
{
  4007fe:	711d                	addi	sp,sp,-96
  400800:	ec06                	sd	ra,24(sp)
  400802:	e822                	sd	s0,16(sp)
  400804:	1000                	addi	s0,sp,32
  400806:	e40c                	sd	a1,8(s0)
  400808:	e810                	sd	a2,16(s0)
  40080a:	ec14                	sd	a3,24(s0)
  40080c:	f018                	sd	a4,32(s0)
  40080e:	f41c                	sd	a5,40(s0)
  400810:	03043823          	sd	a6,48(s0)
  400814:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400818:	00840613          	addi	a2,s0,8
  40081c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400820:	85aa                	mv	a1,a0
  400822:	4505                	li	a0,1
  400824:	d2bff0ef          	jal	40054e <vprintf>
  return 0;
}
  400828:	4501                	li	a0,0
  40082a:	60e2                	ld	ra,24(sp)
  40082c:	6442                	ld	s0,16(sp)
  40082e:	6125                	addi	sp,sp,96
  400830:	8082                	ret

0000000000400832 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  400832:	1141                	addi	sp,sp,-16
  400834:	e406                	sd	ra,8(sp)
  400836:	e022                	sd	s0,0(sp)
  400838:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  40083a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40083e:	00000797          	auipc	a5,0x0
  400842:	7c27b783          	ld	a5,1986(a5) # 401000 <freep>
  400846:	a02d                	j	400870 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400848:	4618                	lw	a4,8(a2)
  40084a:	9f2d                	addw	a4,a4,a1
  40084c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400850:	6398                	ld	a4,0(a5)
  400852:	6310                	ld	a2,0(a4)
  400854:	a83d                	j	400892 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400856:	ff852703          	lw	a4,-8(a0)
  40085a:	9f31                	addw	a4,a4,a2
  40085c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  40085e:	ff053683          	ld	a3,-16(a0)
  400862:	a091                	j	4008a6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400864:	6398                	ld	a4,0(a5)
  400866:	00e7e463          	bltu	a5,a4,40086e <free+0x3c>
  40086a:	00e6ea63          	bltu	a3,a4,40087e <free+0x4c>
{
  40086e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400870:	fed7fae3          	bgeu	a5,a3,400864 <free+0x32>
  400874:	6398                	ld	a4,0(a5)
  400876:	00e6e463          	bltu	a3,a4,40087e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40087a:	fee7eae3          	bltu	a5,a4,40086e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  40087e:	ff852583          	lw	a1,-8(a0)
  400882:	6390                	ld	a2,0(a5)
  400884:	02059813          	slli	a6,a1,0x20
  400888:	01c85713          	srli	a4,a6,0x1c
  40088c:	9736                	add	a4,a4,a3
  40088e:	fae60de3          	beq	a2,a4,400848 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  400892:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  400896:	4790                	lw	a2,8(a5)
  400898:	02061593          	slli	a1,a2,0x20
  40089c:	01c5d713          	srli	a4,a1,0x1c
  4008a0:	973e                	add	a4,a4,a5
  4008a2:	fae68ae3          	beq	a3,a4,400856 <free+0x24>
    p->s.ptr = bp->s.ptr;
  4008a6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4008a8:	00000717          	auipc	a4,0x0
  4008ac:	74f73c23          	sd	a5,1880(a4) # 401000 <freep>
}
  4008b0:	60a2                	ld	ra,8(sp)
  4008b2:	6402                	ld	s0,0(sp)
  4008b4:	0141                	addi	sp,sp,16
  4008b6:	8082                	ret

00000000004008b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4008b8:	7139                	addi	sp,sp,-64
  4008ba:	fc06                	sd	ra,56(sp)
  4008bc:	f822                	sd	s0,48(sp)
  4008be:	f04a                	sd	s2,32(sp)
  4008c0:	ec4e                	sd	s3,24(sp)
  4008c2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4008c4:	02051993          	slli	s3,a0,0x20
  4008c8:	0209d993          	srli	s3,s3,0x20
  4008cc:	09bd                	addi	s3,s3,15
  4008ce:	0049d993          	srli	s3,s3,0x4
  4008d2:	2985                	addiw	s3,s3,1
  4008d4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4008d6:	00000517          	auipc	a0,0x0
  4008da:	72a53503          	ld	a0,1834(a0) # 401000 <freep>
  4008de:	c905                	beqz	a0,40090e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4008e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4008e2:	4798                	lw	a4,8(a5)
  4008e4:	09377663          	bgeu	a4,s3,400970 <malloc+0xb8>
  4008e8:	f426                	sd	s1,40(sp)
  4008ea:	e852                	sd	s4,16(sp)
  4008ec:	e456                	sd	s5,8(sp)
  4008ee:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  4008f0:	8a4e                	mv	s4,s3
  4008f2:	6705                	lui	a4,0x1
  4008f4:	00e9f363          	bgeu	s3,a4,4008fa <malloc+0x42>
  4008f8:	6a05                	lui	s4,0x1
  4008fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  4008fe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  400902:	00000497          	auipc	s1,0x0
  400906:	6fe48493          	addi	s1,s1,1790 # 401000 <freep>
  if(p == (char*)-1)
  40090a:	5afd                	li	s5,-1
  40090c:	a83d                	j	40094a <malloc+0x92>
  40090e:	f426                	sd	s1,40(sp)
  400910:	e852                	sd	s4,16(sp)
  400912:	e456                	sd	s5,8(sp)
  400914:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  400916:	00000797          	auipc	a5,0x0
  40091a:	6fa78793          	addi	a5,a5,1786 # 401010 <base>
  40091e:	00000717          	auipc	a4,0x0
  400922:	6ef73123          	sd	a5,1762(a4) # 401000 <freep>
  400926:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400928:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  40092c:	b7d1                	j	4008f0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  40092e:	6398                	ld	a4,0(a5)
  400930:	e118                	sd	a4,0(a0)
  400932:	a899                	j	400988 <malloc+0xd0>
  hp->s.size = nu;
  400934:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400938:	0541                	addi	a0,a0,16
  40093a:	ef9ff0ef          	jal	400832 <free>
  return freep;
  40093e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  400940:	c125                	beqz	a0,4009a0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400942:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400944:	4798                	lw	a4,8(a5)
  400946:	03277163          	bgeu	a4,s2,400968 <malloc+0xb0>
    if(p == freep)
  40094a:	6098                	ld	a4,0(s1)
  40094c:	853e                	mv	a0,a5
  40094e:	fef71ae3          	bne	a4,a5,400942 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400952:	8552                	mv	a0,s4
  400954:	b17ff0ef          	jal	40046a <sbrk>
  if(p == (char*)-1)
  400958:	fd551ee3          	bne	a0,s5,400934 <malloc+0x7c>
        return 0;
  40095c:	4501                	li	a0,0
  40095e:	74a2                	ld	s1,40(sp)
  400960:	6a42                	ld	s4,16(sp)
  400962:	6aa2                	ld	s5,8(sp)
  400964:	6b02                	ld	s6,0(sp)
  400966:	a03d                	j	400994 <malloc+0xdc>
  400968:	74a2                	ld	s1,40(sp)
  40096a:	6a42                	ld	s4,16(sp)
  40096c:	6aa2                	ld	s5,8(sp)
  40096e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400970:	fae90fe3          	beq	s2,a4,40092e <malloc+0x76>
        p->s.size -= nunits;
  400974:	4137073b          	subw	a4,a4,s3
  400978:	c798                	sw	a4,8(a5)
        p += p->s.size;
  40097a:	02071693          	slli	a3,a4,0x20
  40097e:	01c6d713          	srli	a4,a3,0x1c
  400982:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  400984:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400988:	00000717          	auipc	a4,0x0
  40098c:	66a73c23          	sd	a0,1656(a4) # 401000 <freep>
      return (void*)(p + 1);
  400990:	01078513          	addi	a0,a5,16
  }
}
  400994:	70e2                	ld	ra,56(sp)
  400996:	7442                	ld	s0,48(sp)
  400998:	7902                	ld	s2,32(sp)
  40099a:	69e2                	ld	s3,24(sp)
  40099c:	6121                	addi	sp,sp,64
  40099e:	8082                	ret
  4009a0:	74a2                	ld	s1,40(sp)
  4009a2:	6a42                	ld	s4,16(sp)
  4009a4:	6aa2                	ld	s5,8(sp)
  4009a6:	6b02                	ld	s6,0(sp)
  4009a8:	b7f5                	j	400994 <malloc+0xdc>
