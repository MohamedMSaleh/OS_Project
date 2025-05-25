
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
  400000:	1101                	addi	sp,sp,-32
  400002:	ec06                	sd	ra,24(sp)
  400004:	e822                	sd	s0,16(sp)
  400006:	e426                	sd	s1,8(sp)
  400008:	e04a                	sd	s2,0(sp)
  40000a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  40000c:	4589                	li	a1,2
  40000e:	00001517          	auipc	a0,0x1
  400012:	92250513          	addi	a0,a0,-1758 # 400930 <malloc+0x100>
  400016:	384000ef          	jal	40039a <open>
  40001a:	04054563          	bltz	a0,400064 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  40001e:	4501                	li	a0,0
  400020:	3b2000ef          	jal	4003d2 <dup>
  dup(0);  // stderr
  400024:	4501                	li	a0,0
  400026:	3ac000ef          	jal	4003d2 <dup>

  for(;;){
    printf("init: starting sh\n");
  40002a:	00001917          	auipc	s2,0x1
  40002e:	90e90913          	addi	s2,s2,-1778 # 400938 <malloc+0x108>
  400032:	854a                	mv	a0,s2
  400034:	742000ef          	jal	400776 <printf>
    pid = fork();
  400038:	31a000ef          	jal	400352 <fork>
  40003c:	84aa                	mv	s1,a0
    if(pid < 0){
  40003e:	04054363          	bltz	a0,400084 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  400042:	c931                	beqz	a0,400096 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  400044:	4501                	li	a0,0
  400046:	31c000ef          	jal	400362 <wait>
      if(wpid == pid){
  40004a:	fea484e3          	beq	s1,a0,400032 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  40004e:	fe055be3          	bgez	a0,400044 <main+0x44>
        printf("init: wait returned an error\n");
  400052:	00001517          	auipc	a0,0x1
  400056:	93650513          	addi	a0,a0,-1738 # 400988 <malloc+0x158>
  40005a:	71c000ef          	jal	400776 <printf>
        exit(1);
  40005e:	4505                	li	a0,1
  400060:	2fa000ef          	jal	40035a <exit>
    mknod("console", CONSOLE, 0);
  400064:	4601                	li	a2,0
  400066:	4585                	li	a1,1
  400068:	00001517          	auipc	a0,0x1
  40006c:	8c850513          	addi	a0,a0,-1848 # 400930 <malloc+0x100>
  400070:	332000ef          	jal	4003a2 <mknod>
    open("console", O_RDWR);
  400074:	4589                	li	a1,2
  400076:	00001517          	auipc	a0,0x1
  40007a:	8ba50513          	addi	a0,a0,-1862 # 400930 <malloc+0x100>
  40007e:	31c000ef          	jal	40039a <open>
  400082:	bf71                	j	40001e <main+0x1e>
      printf("init: fork failed\n");
  400084:	00001517          	auipc	a0,0x1
  400088:	8cc50513          	addi	a0,a0,-1844 # 400950 <malloc+0x120>
  40008c:	6ea000ef          	jal	400776 <printf>
      exit(1);
  400090:	4505                	li	a0,1
  400092:	2c8000ef          	jal	40035a <exit>
      exec("sh", argv);
  400096:	00001597          	auipc	a1,0x1
  40009a:	f6a58593          	addi	a1,a1,-150 # 401000 <argv>
  40009e:	00001517          	auipc	a0,0x1
  4000a2:	8ca50513          	addi	a0,a0,-1846 # 400968 <malloc+0x138>
  4000a6:	2ec000ef          	jal	400392 <exec>
      printf("init: exec sh failed\n");
  4000aa:	00001517          	auipc	a0,0x1
  4000ae:	8c650513          	addi	a0,a0,-1850 # 400970 <malloc+0x140>
  4000b2:	6c4000ef          	jal	400776 <printf>
      exit(1);
  4000b6:	4505                	li	a0,1
  4000b8:	2a2000ef          	jal	40035a <exit>

00000000004000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4000bc:	1141                	addi	sp,sp,-16
  4000be:	e406                	sd	ra,8(sp)
  4000c0:	e022                	sd	s0,0(sp)
  4000c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4000c4:	f3dff0ef          	jal	400000 <main>
  exit(0);
  4000c8:	4501                	li	a0,0
  4000ca:	290000ef          	jal	40035a <exit>

00000000004000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  4000ce:	1141                	addi	sp,sp,-16
  4000d0:	e406                	sd	ra,8(sp)
  4000d2:	e022                	sd	s0,0(sp)
  4000d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4000d6:	87aa                	mv	a5,a0
  4000d8:	0585                	addi	a1,a1,1
  4000da:	0785                	addi	a5,a5,1
  4000dc:	fff5c703          	lbu	a4,-1(a1)
  4000e0:	fee78fa3          	sb	a4,-1(a5)
  4000e4:	fb75                	bnez	a4,4000d8 <strcpy+0xa>
    ;
  return os;
}
  4000e6:	60a2                	ld	ra,8(sp)
  4000e8:	6402                	ld	s0,0(sp)
  4000ea:	0141                	addi	sp,sp,16
  4000ec:	8082                	ret

00000000004000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4000ee:	1141                	addi	sp,sp,-16
  4000f0:	e406                	sd	ra,8(sp)
  4000f2:	e022                	sd	s0,0(sp)
  4000f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4000f6:	00054783          	lbu	a5,0(a0)
  4000fa:	cb91                	beqz	a5,40010e <strcmp+0x20>
  4000fc:	0005c703          	lbu	a4,0(a1)
  400100:	00f71763          	bne	a4,a5,40010e <strcmp+0x20>
    p++, q++;
  400104:	0505                	addi	a0,a0,1
  400106:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  400108:	00054783          	lbu	a5,0(a0)
  40010c:	fbe5                	bnez	a5,4000fc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  40010e:	0005c503          	lbu	a0,0(a1)
}
  400112:	40a7853b          	subw	a0,a5,a0
  400116:	60a2                	ld	ra,8(sp)
  400118:	6402                	ld	s0,0(sp)
  40011a:	0141                	addi	sp,sp,16
  40011c:	8082                	ret

000000000040011e <strlen>:

uint
strlen(const char *s)
{
  40011e:	1141                	addi	sp,sp,-16
  400120:	e406                	sd	ra,8(sp)
  400122:	e022                	sd	s0,0(sp)
  400124:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  400126:	00054783          	lbu	a5,0(a0)
  40012a:	cf99                	beqz	a5,400148 <strlen+0x2a>
  40012c:	0505                	addi	a0,a0,1
  40012e:	87aa                	mv	a5,a0
  400130:	86be                	mv	a3,a5
  400132:	0785                	addi	a5,a5,1
  400134:	fff7c703          	lbu	a4,-1(a5)
  400138:	ff65                	bnez	a4,400130 <strlen+0x12>
  40013a:	40a6853b          	subw	a0,a3,a0
  40013e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  400140:	60a2                	ld	ra,8(sp)
  400142:	6402                	ld	s0,0(sp)
  400144:	0141                	addi	sp,sp,16
  400146:	8082                	ret
  for(n = 0; s[n]; n++)
  400148:	4501                	li	a0,0
  40014a:	bfdd                	j	400140 <strlen+0x22>

000000000040014c <memset>:

void*
memset(void *dst, int c, uint n)
{
  40014c:	1141                	addi	sp,sp,-16
  40014e:	e406                	sd	ra,8(sp)
  400150:	e022                	sd	s0,0(sp)
  400152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400154:	ca19                	beqz	a2,40016a <memset+0x1e>
  400156:	87aa                	mv	a5,a0
  400158:	1602                	slli	a2,a2,0x20
  40015a:	9201                	srli	a2,a2,0x20
  40015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400164:	0785                	addi	a5,a5,1
  400166:	fee79de3          	bne	a5,a4,400160 <memset+0x14>
  }
  return dst;
}
  40016a:	60a2                	ld	ra,8(sp)
  40016c:	6402                	ld	s0,0(sp)
  40016e:	0141                	addi	sp,sp,16
  400170:	8082                	ret

0000000000400172 <strchr>:

char*
strchr(const char *s, char c)
{
  400172:	1141                	addi	sp,sp,-16
  400174:	e406                	sd	ra,8(sp)
  400176:	e022                	sd	s0,0(sp)
  400178:	0800                	addi	s0,sp,16
  for(; *s; s++)
  40017a:	00054783          	lbu	a5,0(a0)
  40017e:	cf81                	beqz	a5,400196 <strchr+0x24>
    if(*s == c)
  400180:	00f58763          	beq	a1,a5,40018e <strchr+0x1c>
  for(; *s; s++)
  400184:	0505                	addi	a0,a0,1
  400186:	00054783          	lbu	a5,0(a0)
  40018a:	fbfd                	bnez	a5,400180 <strchr+0xe>
      return (char*)s;
  return 0;
  40018c:	4501                	li	a0,0
}
  40018e:	60a2                	ld	ra,8(sp)
  400190:	6402                	ld	s0,0(sp)
  400192:	0141                	addi	sp,sp,16
  400194:	8082                	ret
  return 0;
  400196:	4501                	li	a0,0
  400198:	bfdd                	j	40018e <strchr+0x1c>

000000000040019a <gets>:

char*
gets(char *buf, int max)
{
  40019a:	7159                	addi	sp,sp,-112
  40019c:	f486                	sd	ra,104(sp)
  40019e:	f0a2                	sd	s0,96(sp)
  4001a0:	eca6                	sd	s1,88(sp)
  4001a2:	e8ca                	sd	s2,80(sp)
  4001a4:	e4ce                	sd	s3,72(sp)
  4001a6:	e0d2                	sd	s4,64(sp)
  4001a8:	fc56                	sd	s5,56(sp)
  4001aa:	f85a                	sd	s6,48(sp)
  4001ac:	f45e                	sd	s7,40(sp)
  4001ae:	f062                	sd	s8,32(sp)
  4001b0:	ec66                	sd	s9,24(sp)
  4001b2:	e86a                	sd	s10,16(sp)
  4001b4:	1880                	addi	s0,sp,112
  4001b6:	8caa                	mv	s9,a0
  4001b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  4001ba:	892a                	mv	s2,a0
  4001bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
  4001be:	f9f40b13          	addi	s6,s0,-97
  4001c2:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  4001c4:	4ba9                	li	s7,10
  4001c6:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  4001c8:	8d26                	mv	s10,s1
  4001ca:	0014899b          	addiw	s3,s1,1
  4001ce:	84ce                	mv	s1,s3
  4001d0:	0349d563          	bge	s3,s4,4001fa <gets+0x60>
    cc = read(0, &c, 1);
  4001d4:	8656                	mv	a2,s5
  4001d6:	85da                	mv	a1,s6
  4001d8:	4501                	li	a0,0
  4001da:	198000ef          	jal	400372 <read>
    if(cc < 1)
  4001de:	00a05e63          	blez	a0,4001fa <gets+0x60>
    buf[i++] = c;
  4001e2:	f9f44783          	lbu	a5,-97(s0)
  4001e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  4001ea:	01778763          	beq	a5,s7,4001f8 <gets+0x5e>
  4001ee:	0905                	addi	s2,s2,1
  4001f0:	fd879ce3          	bne	a5,s8,4001c8 <gets+0x2e>
    buf[i++] = c;
  4001f4:	8d4e                	mv	s10,s3
  4001f6:	a011                	j	4001fa <gets+0x60>
  4001f8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  4001fa:	9d66                	add	s10,s10,s9
  4001fc:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400200:	8566                	mv	a0,s9
  400202:	70a6                	ld	ra,104(sp)
  400204:	7406                	ld	s0,96(sp)
  400206:	64e6                	ld	s1,88(sp)
  400208:	6946                	ld	s2,80(sp)
  40020a:	69a6                	ld	s3,72(sp)
  40020c:	6a06                	ld	s4,64(sp)
  40020e:	7ae2                	ld	s5,56(sp)
  400210:	7b42                	ld	s6,48(sp)
  400212:	7ba2                	ld	s7,40(sp)
  400214:	7c02                	ld	s8,32(sp)
  400216:	6ce2                	ld	s9,24(sp)
  400218:	6d42                	ld	s10,16(sp)
  40021a:	6165                	addi	sp,sp,112
  40021c:	8082                	ret

000000000040021e <stat>:

int
stat(const char *n, struct stat *st)
{
  40021e:	1101                	addi	sp,sp,-32
  400220:	ec06                	sd	ra,24(sp)
  400222:	e822                	sd	s0,16(sp)
  400224:	e04a                	sd	s2,0(sp)
  400226:	1000                	addi	s0,sp,32
  400228:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  40022a:	4581                	li	a1,0
  40022c:	16e000ef          	jal	40039a <open>
  if(fd < 0)
  400230:	02054263          	bltz	a0,400254 <stat+0x36>
  400234:	e426                	sd	s1,8(sp)
  400236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  400238:	85ca                	mv	a1,s2
  40023a:	178000ef          	jal	4003b2 <fstat>
  40023e:	892a                	mv	s2,a0
  close(fd);
  400240:	8526                	mv	a0,s1
  400242:	140000ef          	jal	400382 <close>
  return r;
  400246:	64a2                	ld	s1,8(sp)
}
  400248:	854a                	mv	a0,s2
  40024a:	60e2                	ld	ra,24(sp)
  40024c:	6442                	ld	s0,16(sp)
  40024e:	6902                	ld	s2,0(sp)
  400250:	6105                	addi	sp,sp,32
  400252:	8082                	ret
    return -1;
  400254:	597d                	li	s2,-1
  400256:	bfcd                	j	400248 <stat+0x2a>

0000000000400258 <atoi>:

int
atoi(const char *s)
{
  400258:	1141                	addi	sp,sp,-16
  40025a:	e406                	sd	ra,8(sp)
  40025c:	e022                	sd	s0,0(sp)
  40025e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400260:	00054683          	lbu	a3,0(a0)
  400264:	fd06879b          	addiw	a5,a3,-48
  400268:	0ff7f793          	zext.b	a5,a5
  40026c:	4625                	li	a2,9
  40026e:	02f66963          	bltu	a2,a5,4002a0 <atoi+0x48>
  400272:	872a                	mv	a4,a0
  n = 0;
  400274:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400276:	0705                	addi	a4,a4,1
  400278:	0025179b          	slliw	a5,a0,0x2
  40027c:	9fa9                	addw	a5,a5,a0
  40027e:	0017979b          	slliw	a5,a5,0x1
  400282:	9fb5                	addw	a5,a5,a3
  400284:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400288:	00074683          	lbu	a3,0(a4)
  40028c:	fd06879b          	addiw	a5,a3,-48
  400290:	0ff7f793          	zext.b	a5,a5
  400294:	fef671e3          	bgeu	a2,a5,400276 <atoi+0x1e>
  return n;
}
  400298:	60a2                	ld	ra,8(sp)
  40029a:	6402                	ld	s0,0(sp)
  40029c:	0141                	addi	sp,sp,16
  40029e:	8082                	ret
  n = 0;
  4002a0:	4501                	li	a0,0
  4002a2:	bfdd                	j	400298 <atoi+0x40>

00000000004002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  4002a4:	1141                	addi	sp,sp,-16
  4002a6:	e406                	sd	ra,8(sp)
  4002a8:	e022                	sd	s0,0(sp)
  4002aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  4002ac:	02b57563          	bgeu	a0,a1,4002d6 <memmove+0x32>
    while(n-- > 0)
  4002b0:	00c05f63          	blez	a2,4002ce <memmove+0x2a>
  4002b4:	1602                	slli	a2,a2,0x20
  4002b6:	9201                	srli	a2,a2,0x20
  4002b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  4002bc:	872a                	mv	a4,a0
      *dst++ = *src++;
  4002be:	0585                	addi	a1,a1,1
  4002c0:	0705                	addi	a4,a4,1
  4002c2:	fff5c683          	lbu	a3,-1(a1)
  4002c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  4002ca:	fee79ae3          	bne	a5,a4,4002be <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  4002ce:	60a2                	ld	ra,8(sp)
  4002d0:	6402                	ld	s0,0(sp)
  4002d2:	0141                	addi	sp,sp,16
  4002d4:	8082                	ret
    dst += n;
  4002d6:	00c50733          	add	a4,a0,a2
    src += n;
  4002da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  4002dc:	fec059e3          	blez	a2,4002ce <memmove+0x2a>
  4002e0:	fff6079b          	addiw	a5,a2,-1
  4002e4:	1782                	slli	a5,a5,0x20
  4002e6:	9381                	srli	a5,a5,0x20
  4002e8:	fff7c793          	not	a5,a5
  4002ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  4002ee:	15fd                	addi	a1,a1,-1
  4002f0:	177d                	addi	a4,a4,-1
  4002f2:	0005c683          	lbu	a3,0(a1)
  4002f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  4002fa:	fef71ae3          	bne	a4,a5,4002ee <memmove+0x4a>
  4002fe:	bfc1                	j	4002ce <memmove+0x2a>

0000000000400300 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400300:	1141                	addi	sp,sp,-16
  400302:	e406                	sd	ra,8(sp)
  400304:	e022                	sd	s0,0(sp)
  400306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  400308:	ca0d                	beqz	a2,40033a <memcmp+0x3a>
  40030a:	fff6069b          	addiw	a3,a2,-1
  40030e:	1682                	slli	a3,a3,0x20
  400310:	9281                	srli	a3,a3,0x20
  400312:	0685                	addi	a3,a3,1
  400314:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  400316:	00054783          	lbu	a5,0(a0)
  40031a:	0005c703          	lbu	a4,0(a1)
  40031e:	00e79863          	bne	a5,a4,40032e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  400322:	0505                	addi	a0,a0,1
    p2++;
  400324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  400326:	fed518e3          	bne	a0,a3,400316 <memcmp+0x16>
  }
  return 0;
  40032a:	4501                	li	a0,0
  40032c:	a019                	j	400332 <memcmp+0x32>
      return *p1 - *p2;
  40032e:	40e7853b          	subw	a0,a5,a4
}
  400332:	60a2                	ld	ra,8(sp)
  400334:	6402                	ld	s0,0(sp)
  400336:	0141                	addi	sp,sp,16
  400338:	8082                	ret
  return 0;
  40033a:	4501                	li	a0,0
  40033c:	bfdd                	j	400332 <memcmp+0x32>

000000000040033e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  40033e:	1141                	addi	sp,sp,-16
  400340:	e406                	sd	ra,8(sp)
  400342:	e022                	sd	s0,0(sp)
  400344:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400346:	f5fff0ef          	jal	4002a4 <memmove>
}
  40034a:	60a2                	ld	ra,8(sp)
  40034c:	6402                	ld	s0,0(sp)
  40034e:	0141                	addi	sp,sp,16
  400350:	8082                	ret

0000000000400352 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  400352:	4885                	li	a7,1
 ecall
  400354:	00000073          	ecall
 ret
  400358:	8082                	ret

000000000040035a <exit>:
.global exit
exit:
 li a7, SYS_exit
  40035a:	4889                	li	a7,2
 ecall
  40035c:	00000073          	ecall
 ret
  400360:	8082                	ret

0000000000400362 <wait>:
.global wait
wait:
 li a7, SYS_wait
  400362:	488d                	li	a7,3
 ecall
  400364:	00000073          	ecall
 ret
  400368:	8082                	ret

000000000040036a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  40036a:	4891                	li	a7,4
 ecall
  40036c:	00000073          	ecall
 ret
  400370:	8082                	ret

0000000000400372 <read>:
.global read
read:
 li a7, SYS_read
  400372:	4895                	li	a7,5
 ecall
  400374:	00000073          	ecall
 ret
  400378:	8082                	ret

000000000040037a <write>:
.global write
write:
 li a7, SYS_write
  40037a:	48c1                	li	a7,16
 ecall
  40037c:	00000073          	ecall
 ret
  400380:	8082                	ret

0000000000400382 <close>:
.global close
close:
 li a7, SYS_close
  400382:	48d5                	li	a7,21
 ecall
  400384:	00000073          	ecall
 ret
  400388:	8082                	ret

000000000040038a <kill>:
.global kill
kill:
 li a7, SYS_kill
  40038a:	4899                	li	a7,6
 ecall
  40038c:	00000073          	ecall
 ret
  400390:	8082                	ret

0000000000400392 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400392:	489d                	li	a7,7
 ecall
  400394:	00000073          	ecall
 ret
  400398:	8082                	ret

000000000040039a <open>:
.global open
open:
 li a7, SYS_open
  40039a:	48bd                	li	a7,15
 ecall
  40039c:	00000073          	ecall
 ret
  4003a0:	8082                	ret

00000000004003a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  4003a2:	48c5                	li	a7,17
 ecall
  4003a4:	00000073          	ecall
 ret
  4003a8:	8082                	ret

00000000004003aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  4003aa:	48c9                	li	a7,18
 ecall
  4003ac:	00000073          	ecall
 ret
  4003b0:	8082                	ret

00000000004003b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  4003b2:	48a1                	li	a7,8
 ecall
  4003b4:	00000073          	ecall
 ret
  4003b8:	8082                	ret

00000000004003ba <link>:
.global link
link:
 li a7, SYS_link
  4003ba:	48cd                	li	a7,19
 ecall
  4003bc:	00000073          	ecall
 ret
  4003c0:	8082                	ret

00000000004003c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  4003c2:	48d1                	li	a7,20
 ecall
  4003c4:	00000073          	ecall
 ret
  4003c8:	8082                	ret

00000000004003ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  4003ca:	48a5                	li	a7,9
 ecall
  4003cc:	00000073          	ecall
 ret
  4003d0:	8082                	ret

00000000004003d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
  4003d2:	48a9                	li	a7,10
 ecall
  4003d4:	00000073          	ecall
 ret
  4003d8:	8082                	ret

00000000004003da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  4003da:	48ad                	li	a7,11
 ecall
  4003dc:	00000073          	ecall
 ret
  4003e0:	8082                	ret

00000000004003e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  4003e2:	48b1                	li	a7,12
 ecall
  4003e4:	00000073          	ecall
 ret
  4003e8:	8082                	ret

00000000004003ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  4003ea:	48b5                	li	a7,13
 ecall
  4003ec:	00000073          	ecall
 ret
  4003f0:	8082                	ret

00000000004003f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  4003f2:	48b9                	li	a7,14
 ecall
  4003f4:	00000073          	ecall
 ret
  4003f8:	8082                	ret

00000000004003fa <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  4003fa:	48d9                	li	a7,22
 ecall
  4003fc:	00000073          	ecall
 ret
  400400:	8082                	ret

0000000000400402 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  400402:	48dd                	li	a7,23
 ecall
  400404:	00000073          	ecall
 ret
  400408:	8082                	ret

000000000040040a <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  40040a:	48e1                	li	a7,24
 ecall
  40040c:	00000073          	ecall
 ret
  400410:	8082                	ret

0000000000400412 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  400412:	1101                	addi	sp,sp,-32
  400414:	ec06                	sd	ra,24(sp)
  400416:	e822                	sd	s0,16(sp)
  400418:	1000                	addi	s0,sp,32
  40041a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  40041e:	4605                	li	a2,1
  400420:	fef40593          	addi	a1,s0,-17
  400424:	f57ff0ef          	jal	40037a <write>
}
  400428:	60e2                	ld	ra,24(sp)
  40042a:	6442                	ld	s0,16(sp)
  40042c:	6105                	addi	sp,sp,32
  40042e:	8082                	ret

0000000000400430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  400430:	7139                	addi	sp,sp,-64
  400432:	fc06                	sd	ra,56(sp)
  400434:	f822                	sd	s0,48(sp)
  400436:	f426                	sd	s1,40(sp)
  400438:	f04a                	sd	s2,32(sp)
  40043a:	ec4e                	sd	s3,24(sp)
  40043c:	0080                	addi	s0,sp,64
  40043e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  400440:	c299                	beqz	a3,400446 <printint+0x16>
  400442:	0605ce63          	bltz	a1,4004be <printint+0x8e>
  neg = 0;
  400446:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400448:	fc040313          	addi	t1,s0,-64
  neg = 0;
  40044c:	869a                	mv	a3,t1
  i = 0;
  40044e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  400450:	00000817          	auipc	a6,0x0
  400454:	56080813          	addi	a6,a6,1376 # 4009b0 <digits>
  400458:	88be                	mv	a7,a5
  40045a:	0017851b          	addiw	a0,a5,1
  40045e:	87aa                	mv	a5,a0
  400460:	02c5f73b          	remuw	a4,a1,a2
  400464:	1702                	slli	a4,a4,0x20
  400466:	9301                	srli	a4,a4,0x20
  400468:	9742                	add	a4,a4,a6
  40046a:	00074703          	lbu	a4,0(a4)
  40046e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400472:	872e                	mv	a4,a1
  400474:	02c5d5bb          	divuw	a1,a1,a2
  400478:	0685                	addi	a3,a3,1
  40047a:	fcc77fe3          	bgeu	a4,a2,400458 <printint+0x28>
  if(neg)
  40047e:	000e0c63          	beqz	t3,400496 <printint+0x66>
    buf[i++] = '-';
  400482:	fd050793          	addi	a5,a0,-48
  400486:	00878533          	add	a0,a5,s0
  40048a:	02d00793          	li	a5,45
  40048e:	fef50823          	sb	a5,-16(a0)
  400492:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400496:	fff7899b          	addiw	s3,a5,-1
  40049a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  40049e:	fff4c583          	lbu	a1,-1(s1)
  4004a2:	854a                	mv	a0,s2
  4004a4:	f6fff0ef          	jal	400412 <putc>
  while(--i >= 0)
  4004a8:	39fd                	addiw	s3,s3,-1
  4004aa:	14fd                	addi	s1,s1,-1
  4004ac:	fe09d9e3          	bgez	s3,40049e <printint+0x6e>
}
  4004b0:	70e2                	ld	ra,56(sp)
  4004b2:	7442                	ld	s0,48(sp)
  4004b4:	74a2                	ld	s1,40(sp)
  4004b6:	7902                	ld	s2,32(sp)
  4004b8:	69e2                	ld	s3,24(sp)
  4004ba:	6121                	addi	sp,sp,64
  4004bc:	8082                	ret
    x = -xx;
  4004be:	40b005bb          	negw	a1,a1
    neg = 1;
  4004c2:	4e05                	li	t3,1
    x = -xx;
  4004c4:	b751                	j	400448 <printint+0x18>

00000000004004c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  4004c6:	711d                	addi	sp,sp,-96
  4004c8:	ec86                	sd	ra,88(sp)
  4004ca:	e8a2                	sd	s0,80(sp)
  4004cc:	e4a6                	sd	s1,72(sp)
  4004ce:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  4004d0:	0005c483          	lbu	s1,0(a1)
  4004d4:	26048663          	beqz	s1,400740 <vprintf+0x27a>
  4004d8:	e0ca                	sd	s2,64(sp)
  4004da:	fc4e                	sd	s3,56(sp)
  4004dc:	f852                	sd	s4,48(sp)
  4004de:	f456                	sd	s5,40(sp)
  4004e0:	f05a                	sd	s6,32(sp)
  4004e2:	ec5e                	sd	s7,24(sp)
  4004e4:	e862                	sd	s8,16(sp)
  4004e6:	e466                	sd	s9,8(sp)
  4004e8:	8b2a                	mv	s6,a0
  4004ea:	8a2e                	mv	s4,a1
  4004ec:	8bb2                	mv	s7,a2
  state = 0;
  4004ee:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  4004f0:	4901                	li	s2,0
  4004f2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  4004f4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  4004f8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  4004fc:	06c00c93          	li	s9,108
  400500:	a00d                	j	400522 <vprintf+0x5c>
        putc(fd, c0);
  400502:	85a6                	mv	a1,s1
  400504:	855a                	mv	a0,s6
  400506:	f0dff0ef          	jal	400412 <putc>
  40050a:	a019                	j	400510 <vprintf+0x4a>
    } else if(state == '%'){
  40050c:	03598363          	beq	s3,s5,400532 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  400510:	0019079b          	addiw	a5,s2,1
  400514:	893e                	mv	s2,a5
  400516:	873e                	mv	a4,a5
  400518:	97d2                	add	a5,a5,s4
  40051a:	0007c483          	lbu	s1,0(a5)
  40051e:	20048963          	beqz	s1,400730 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  400522:	0004879b          	sext.w	a5,s1
    if(state == 0){
  400526:	fe0993e3          	bnez	s3,40050c <vprintf+0x46>
      if(c0 == '%'){
  40052a:	fd579ce3          	bne	a5,s5,400502 <vprintf+0x3c>
        state = '%';
  40052e:	89be                	mv	s3,a5
  400530:	b7c5                	j	400510 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  400532:	00ea06b3          	add	a3,s4,a4
  400536:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  40053a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  40053c:	c681                	beqz	a3,400544 <vprintf+0x7e>
  40053e:	9752                	add	a4,a4,s4
  400540:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  400544:	03878e63          	beq	a5,s8,400580 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400548:	05978863          	beq	a5,s9,400598 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  40054c:	07500713          	li	a4,117
  400550:	0ee78263          	beq	a5,a4,400634 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400554:	07800713          	li	a4,120
  400558:	12e78463          	beq	a5,a4,400680 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  40055c:	07000713          	li	a4,112
  400560:	14e78963          	beq	a5,a4,4006b2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400564:	07300713          	li	a4,115
  400568:	18e78863          	beq	a5,a4,4006f8 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  40056c:	02500713          	li	a4,37
  400570:	04e79463          	bne	a5,a4,4005b8 <vprintf+0xf2>
        putc(fd, '%');
  400574:	85ba                	mv	a1,a4
  400576:	855a                	mv	a0,s6
  400578:	e9bff0ef          	jal	400412 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  40057c:	4981                	li	s3,0
  40057e:	bf49                	j	400510 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400580:	008b8493          	addi	s1,s7,8
  400584:	4685                	li	a3,1
  400586:	4629                	li	a2,10
  400588:	000ba583          	lw	a1,0(s7)
  40058c:	855a                	mv	a0,s6
  40058e:	ea3ff0ef          	jal	400430 <printint>
  400592:	8ba6                	mv	s7,s1
      state = 0;
  400594:	4981                	li	s3,0
  400596:	bfad                	j	400510 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400598:	06400793          	li	a5,100
  40059c:	02f68963          	beq	a3,a5,4005ce <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4005a0:	06c00793          	li	a5,108
  4005a4:	04f68263          	beq	a3,a5,4005e8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  4005a8:	07500793          	li	a5,117
  4005ac:	0af68063          	beq	a3,a5,40064c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  4005b0:	07800793          	li	a5,120
  4005b4:	0ef68263          	beq	a3,a5,400698 <vprintf+0x1d2>
        putc(fd, '%');
  4005b8:	02500593          	li	a1,37
  4005bc:	855a                	mv	a0,s6
  4005be:	e55ff0ef          	jal	400412 <putc>
        putc(fd, c0);
  4005c2:	85a6                	mv	a1,s1
  4005c4:	855a                	mv	a0,s6
  4005c6:	e4dff0ef          	jal	400412 <putc>
      state = 0;
  4005ca:	4981                	li	s3,0
  4005cc:	b791                	j	400510 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005ce:	008b8493          	addi	s1,s7,8
  4005d2:	4685                	li	a3,1
  4005d4:	4629                	li	a2,10
  4005d6:	000ba583          	lw	a1,0(s7)
  4005da:	855a                	mv	a0,s6
  4005dc:	e55ff0ef          	jal	400430 <printint>
        i += 1;
  4005e0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005e2:	8ba6                	mv	s7,s1
      state = 0;
  4005e4:	4981                	li	s3,0
        i += 1;
  4005e6:	b72d                	j	400510 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4005e8:	06400793          	li	a5,100
  4005ec:	02f60763          	beq	a2,a5,40061a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  4005f0:	07500793          	li	a5,117
  4005f4:	06f60963          	beq	a2,a5,400666 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  4005f8:	07800793          	li	a5,120
  4005fc:	faf61ee3          	bne	a2,a5,4005b8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400600:	008b8493          	addi	s1,s7,8
  400604:	4681                	li	a3,0
  400606:	4641                	li	a2,16
  400608:	000ba583          	lw	a1,0(s7)
  40060c:	855a                	mv	a0,s6
  40060e:	e23ff0ef          	jal	400430 <printint>
        i += 2;
  400612:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  400614:	8ba6                	mv	s7,s1
      state = 0;
  400616:	4981                	li	s3,0
        i += 2;
  400618:	bde5                	j	400510 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  40061a:	008b8493          	addi	s1,s7,8
  40061e:	4685                	li	a3,1
  400620:	4629                	li	a2,10
  400622:	000ba583          	lw	a1,0(s7)
  400626:	855a                	mv	a0,s6
  400628:	e09ff0ef          	jal	400430 <printint>
        i += 2;
  40062c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  40062e:	8ba6                	mv	s7,s1
      state = 0;
  400630:	4981                	li	s3,0
        i += 2;
  400632:	bdf9                	j	400510 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  400634:	008b8493          	addi	s1,s7,8
  400638:	4681                	li	a3,0
  40063a:	4629                	li	a2,10
  40063c:	000ba583          	lw	a1,0(s7)
  400640:	855a                	mv	a0,s6
  400642:	defff0ef          	jal	400430 <printint>
  400646:	8ba6                	mv	s7,s1
      state = 0;
  400648:	4981                	li	s3,0
  40064a:	b5d9                	j	400510 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  40064c:	008b8493          	addi	s1,s7,8
  400650:	4681                	li	a3,0
  400652:	4629                	li	a2,10
  400654:	000ba583          	lw	a1,0(s7)
  400658:	855a                	mv	a0,s6
  40065a:	dd7ff0ef          	jal	400430 <printint>
        i += 1;
  40065e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400660:	8ba6                	mv	s7,s1
      state = 0;
  400662:	4981                	li	s3,0
        i += 1;
  400664:	b575                	j	400510 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400666:	008b8493          	addi	s1,s7,8
  40066a:	4681                	li	a3,0
  40066c:	4629                	li	a2,10
  40066e:	000ba583          	lw	a1,0(s7)
  400672:	855a                	mv	a0,s6
  400674:	dbdff0ef          	jal	400430 <printint>
        i += 2;
  400678:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  40067a:	8ba6                	mv	s7,s1
      state = 0;
  40067c:	4981                	li	s3,0
        i += 2;
  40067e:	bd49                	j	400510 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400680:	008b8493          	addi	s1,s7,8
  400684:	4681                	li	a3,0
  400686:	4641                	li	a2,16
  400688:	000ba583          	lw	a1,0(s7)
  40068c:	855a                	mv	a0,s6
  40068e:	da3ff0ef          	jal	400430 <printint>
  400692:	8ba6                	mv	s7,s1
      state = 0;
  400694:	4981                	li	s3,0
  400696:	bdad                	j	400510 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400698:	008b8493          	addi	s1,s7,8
  40069c:	4681                	li	a3,0
  40069e:	4641                	li	a2,16
  4006a0:	000ba583          	lw	a1,0(s7)
  4006a4:	855a                	mv	a0,s6
  4006a6:	d8bff0ef          	jal	400430 <printint>
        i += 1;
  4006aa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006ac:	8ba6                	mv	s7,s1
      state = 0;
  4006ae:	4981                	li	s3,0
        i += 1;
  4006b0:	b585                	j	400510 <vprintf+0x4a>
  4006b2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  4006b4:	008b8d13          	addi	s10,s7,8
  4006b8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  4006bc:	03000593          	li	a1,48
  4006c0:	855a                	mv	a0,s6
  4006c2:	d51ff0ef          	jal	400412 <putc>
  putc(fd, 'x');
  4006c6:	07800593          	li	a1,120
  4006ca:	855a                	mv	a0,s6
  4006cc:	d47ff0ef          	jal	400412 <putc>
  4006d0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  4006d2:	00000b97          	auipc	s7,0x0
  4006d6:	2deb8b93          	addi	s7,s7,734 # 4009b0 <digits>
  4006da:	03c9d793          	srli	a5,s3,0x3c
  4006de:	97de                	add	a5,a5,s7
  4006e0:	0007c583          	lbu	a1,0(a5)
  4006e4:	855a                	mv	a0,s6
  4006e6:	d2dff0ef          	jal	400412 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  4006ea:	0992                	slli	s3,s3,0x4
  4006ec:	34fd                	addiw	s1,s1,-1
  4006ee:	f4f5                	bnez	s1,4006da <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  4006f0:	8bea                	mv	s7,s10
      state = 0;
  4006f2:	4981                	li	s3,0
  4006f4:	6d02                	ld	s10,0(sp)
  4006f6:	bd29                	j	400510 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  4006f8:	008b8993          	addi	s3,s7,8
  4006fc:	000bb483          	ld	s1,0(s7)
  400700:	cc91                	beqz	s1,40071c <vprintf+0x256>
        for(; *s; s++)
  400702:	0004c583          	lbu	a1,0(s1)
  400706:	c195                	beqz	a1,40072a <vprintf+0x264>
          putc(fd, *s);
  400708:	855a                	mv	a0,s6
  40070a:	d09ff0ef          	jal	400412 <putc>
        for(; *s; s++)
  40070e:	0485                	addi	s1,s1,1
  400710:	0004c583          	lbu	a1,0(s1)
  400714:	f9f5                	bnez	a1,400708 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400716:	8bce                	mv	s7,s3
      state = 0;
  400718:	4981                	li	s3,0
  40071a:	bbdd                	j	400510 <vprintf+0x4a>
          s = "(null)";
  40071c:	00000497          	auipc	s1,0x0
  400720:	28c48493          	addi	s1,s1,652 # 4009a8 <malloc+0x178>
        for(; *s; s++)
  400724:	02800593          	li	a1,40
  400728:	b7c5                	j	400708 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  40072a:	8bce                	mv	s7,s3
      state = 0;
  40072c:	4981                	li	s3,0
  40072e:	b3cd                	j	400510 <vprintf+0x4a>
  400730:	6906                	ld	s2,64(sp)
  400732:	79e2                	ld	s3,56(sp)
  400734:	7a42                	ld	s4,48(sp)
  400736:	7aa2                	ld	s5,40(sp)
  400738:	7b02                	ld	s6,32(sp)
  40073a:	6be2                	ld	s7,24(sp)
  40073c:	6c42                	ld	s8,16(sp)
  40073e:	6ca2                	ld	s9,8(sp)
    }
  }
}
  400740:	60e6                	ld	ra,88(sp)
  400742:	6446                	ld	s0,80(sp)
  400744:	64a6                	ld	s1,72(sp)
  400746:	6125                	addi	sp,sp,96
  400748:	8082                	ret

000000000040074a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  40074a:	715d                	addi	sp,sp,-80
  40074c:	ec06                	sd	ra,24(sp)
  40074e:	e822                	sd	s0,16(sp)
  400750:	1000                	addi	s0,sp,32
  400752:	e010                	sd	a2,0(s0)
  400754:	e414                	sd	a3,8(s0)
  400756:	e818                	sd	a4,16(s0)
  400758:	ec1c                	sd	a5,24(s0)
  40075a:	03043023          	sd	a6,32(s0)
  40075e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  400762:	8622                	mv	a2,s0
  400764:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400768:	d5fff0ef          	jal	4004c6 <vprintf>
  return 0;
}
  40076c:	4501                	li	a0,0
  40076e:	60e2                	ld	ra,24(sp)
  400770:	6442                	ld	s0,16(sp)
  400772:	6161                	addi	sp,sp,80
  400774:	8082                	ret

0000000000400776 <printf>:

int
printf(const char *fmt, ...)
{
  400776:	711d                	addi	sp,sp,-96
  400778:	ec06                	sd	ra,24(sp)
  40077a:	e822                	sd	s0,16(sp)
  40077c:	1000                	addi	s0,sp,32
  40077e:	e40c                	sd	a1,8(s0)
  400780:	e810                	sd	a2,16(s0)
  400782:	ec14                	sd	a3,24(s0)
  400784:	f018                	sd	a4,32(s0)
  400786:	f41c                	sd	a5,40(s0)
  400788:	03043823          	sd	a6,48(s0)
  40078c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400790:	00840613          	addi	a2,s0,8
  400794:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400798:	85aa                	mv	a1,a0
  40079a:	4505                	li	a0,1
  40079c:	d2bff0ef          	jal	4004c6 <vprintf>
  return 0;
}
  4007a0:	4501                	li	a0,0
  4007a2:	60e2                	ld	ra,24(sp)
  4007a4:	6442                	ld	s0,16(sp)
  4007a6:	6125                	addi	sp,sp,96
  4007a8:	8082                	ret

00000000004007aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  4007aa:	1141                	addi	sp,sp,-16
  4007ac:	e406                	sd	ra,8(sp)
  4007ae:	e022                	sd	s0,0(sp)
  4007b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  4007b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4007b6:	00001797          	auipc	a5,0x1
  4007ba:	85a7b783          	ld	a5,-1958(a5) # 401010 <freep>
  4007be:	a02d                	j	4007e8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  4007c0:	4618                	lw	a4,8(a2)
  4007c2:	9f2d                	addw	a4,a4,a1
  4007c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  4007c8:	6398                	ld	a4,0(a5)
  4007ca:	6310                	ld	a2,0(a4)
  4007cc:	a83d                	j	40080a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  4007ce:	ff852703          	lw	a4,-8(a0)
  4007d2:	9f31                	addw	a4,a4,a2
  4007d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  4007d6:	ff053683          	ld	a3,-16(a0)
  4007da:	a091                	j	40081e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4007dc:	6398                	ld	a4,0(a5)
  4007de:	00e7e463          	bltu	a5,a4,4007e6 <free+0x3c>
  4007e2:	00e6ea63          	bltu	a3,a4,4007f6 <free+0x4c>
{
  4007e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4007e8:	fed7fae3          	bgeu	a5,a3,4007dc <free+0x32>
  4007ec:	6398                	ld	a4,0(a5)
  4007ee:	00e6e463          	bltu	a3,a4,4007f6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4007f2:	fee7eae3          	bltu	a5,a4,4007e6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4007f6:	ff852583          	lw	a1,-8(a0)
  4007fa:	6390                	ld	a2,0(a5)
  4007fc:	02059813          	slli	a6,a1,0x20
  400800:	01c85713          	srli	a4,a6,0x1c
  400804:	9736                	add	a4,a4,a3
  400806:	fae60de3          	beq	a2,a4,4007c0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  40080a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  40080e:	4790                	lw	a2,8(a5)
  400810:	02061593          	slli	a1,a2,0x20
  400814:	01c5d713          	srli	a4,a1,0x1c
  400818:	973e                	add	a4,a4,a5
  40081a:	fae68ae3          	beq	a3,a4,4007ce <free+0x24>
    p->s.ptr = bp->s.ptr;
  40081e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  400820:	00000717          	auipc	a4,0x0
  400824:	7ef73823          	sd	a5,2032(a4) # 401010 <freep>
}
  400828:	60a2                	ld	ra,8(sp)
  40082a:	6402                	ld	s0,0(sp)
  40082c:	0141                	addi	sp,sp,16
  40082e:	8082                	ret

0000000000400830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  400830:	7139                	addi	sp,sp,-64
  400832:	fc06                	sd	ra,56(sp)
  400834:	f822                	sd	s0,48(sp)
  400836:	f04a                	sd	s2,32(sp)
  400838:	ec4e                	sd	s3,24(sp)
  40083a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  40083c:	02051993          	slli	s3,a0,0x20
  400840:	0209d993          	srli	s3,s3,0x20
  400844:	09bd                	addi	s3,s3,15
  400846:	0049d993          	srli	s3,s3,0x4
  40084a:	2985                	addiw	s3,s3,1
  40084c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  40084e:	00000517          	auipc	a0,0x0
  400852:	7c253503          	ld	a0,1986(a0) # 401010 <freep>
  400856:	c905                	beqz	a0,400886 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40085a:	4798                	lw	a4,8(a5)
  40085c:	09377663          	bgeu	a4,s3,4008e8 <malloc+0xb8>
  400860:	f426                	sd	s1,40(sp)
  400862:	e852                	sd	s4,16(sp)
  400864:	e456                	sd	s5,8(sp)
  400866:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400868:	8a4e                	mv	s4,s3
  40086a:	6705                	lui	a4,0x1
  40086c:	00e9f363          	bgeu	s3,a4,400872 <malloc+0x42>
  400870:	6a05                	lui	s4,0x1
  400872:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400876:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  40087a:	00000497          	auipc	s1,0x0
  40087e:	79648493          	addi	s1,s1,1942 # 401010 <freep>
  if(p == (char*)-1)
  400882:	5afd                	li	s5,-1
  400884:	a83d                	j	4008c2 <malloc+0x92>
  400886:	f426                	sd	s1,40(sp)
  400888:	e852                	sd	s4,16(sp)
  40088a:	e456                	sd	s5,8(sp)
  40088c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  40088e:	00000797          	auipc	a5,0x0
  400892:	79278793          	addi	a5,a5,1938 # 401020 <base>
  400896:	00000717          	auipc	a4,0x0
  40089a:	76f73d23          	sd	a5,1914(a4) # 401010 <freep>
  40089e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  4008a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  4008a4:	b7d1                	j	400868 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  4008a6:	6398                	ld	a4,0(a5)
  4008a8:	e118                	sd	a4,0(a0)
  4008aa:	a899                	j	400900 <malloc+0xd0>
  hp->s.size = nu;
  4008ac:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  4008b0:	0541                	addi	a0,a0,16
  4008b2:	ef9ff0ef          	jal	4007aa <free>
  return freep;
  4008b6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  4008b8:	c125                	beqz	a0,400918 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4008ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4008bc:	4798                	lw	a4,8(a5)
  4008be:	03277163          	bgeu	a4,s2,4008e0 <malloc+0xb0>
    if(p == freep)
  4008c2:	6098                	ld	a4,0(s1)
  4008c4:	853e                	mv	a0,a5
  4008c6:	fef71ae3          	bne	a4,a5,4008ba <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  4008ca:	8552                	mv	a0,s4
  4008cc:	b17ff0ef          	jal	4003e2 <sbrk>
  if(p == (char*)-1)
  4008d0:	fd551ee3          	bne	a0,s5,4008ac <malloc+0x7c>
        return 0;
  4008d4:	4501                	li	a0,0
  4008d6:	74a2                	ld	s1,40(sp)
  4008d8:	6a42                	ld	s4,16(sp)
  4008da:	6aa2                	ld	s5,8(sp)
  4008dc:	6b02                	ld	s6,0(sp)
  4008de:	a03d                	j	40090c <malloc+0xdc>
  4008e0:	74a2                	ld	s1,40(sp)
  4008e2:	6a42                	ld	s4,16(sp)
  4008e4:	6aa2                	ld	s5,8(sp)
  4008e6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  4008e8:	fae90fe3          	beq	s2,a4,4008a6 <malloc+0x76>
        p->s.size -= nunits;
  4008ec:	4137073b          	subw	a4,a4,s3
  4008f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
  4008f2:	02071693          	slli	a3,a4,0x20
  4008f6:	01c6d713          	srli	a4,a3,0x1c
  4008fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4008fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400900:	00000717          	auipc	a4,0x0
  400904:	70a73823          	sd	a0,1808(a4) # 401010 <freep>
      return (void*)(p + 1);
  400908:	01078513          	addi	a0,a5,16
  }
}
  40090c:	70e2                	ld	ra,56(sp)
  40090e:	7442                	ld	s0,48(sp)
  400910:	7902                	ld	s2,32(sp)
  400912:	69e2                	ld	s3,24(sp)
  400914:	6121                	addi	sp,sp,64
  400916:	8082                	ret
  400918:	74a2                	ld	s1,40(sp)
  40091a:	6a42                	ld	s4,16(sp)
  40091c:	6aa2                	ld	s5,8(sp)
  40091e:	6b02                	ld	s6,0(sp)
  400920:	b7f5                	j	40090c <malloc+0xdc>
