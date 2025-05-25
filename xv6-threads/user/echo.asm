
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  400000:	7139                	addi	sp,sp,-64
  400002:	fc06                	sd	ra,56(sp)
  400004:	f822                	sd	s0,48(sp)
  400006:	f426                	sd	s1,40(sp)
  400008:	f04a                	sd	s2,32(sp)
  40000a:	ec4e                	sd	s3,24(sp)
  40000c:	e852                	sd	s4,16(sp)
  40000e:	e456                	sd	s5,8(sp)
  400010:	e05a                	sd	s6,0(sp)
  400012:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  400014:	4785                	li	a5,1
  400016:	06a7d063          	bge	a5,a0,400076 <main+0x76>
  40001a:	00858493          	addi	s1,a1,8
  40001e:	3579                	addiw	a0,a0,-2
  400020:	02051793          	slli	a5,a0,0x20
  400024:	01d7d513          	srli	a0,a5,0x1d
  400028:	00a48ab3          	add	s5,s1,a0
  40002c:	05c1                	addi	a1,a1,16
  40002e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  400032:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  400034:	00001b17          	auipc	s6,0x1
  400038:	8bcb0b13          	addi	s6,s6,-1860 # 4008f0 <malloc+0x100>
  40003c:	a809                	j	40004e <main+0x4e>
  40003e:	864e                	mv	a2,s3
  400040:	85da                	mv	a1,s6
  400042:	854e                	mv	a0,s3
  400044:	2f6000ef          	jal	40033a <write>
  for(i = 1; i < argc; i++){
  400048:	04a1                	addi	s1,s1,8
  40004a:	03448663          	beq	s1,s4,400076 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  40004e:	0004b903          	ld	s2,0(s1)
  400052:	854a                	mv	a0,s2
  400054:	08a000ef          	jal	4000de <strlen>
  400058:	862a                	mv	a2,a0
  40005a:	85ca                	mv	a1,s2
  40005c:	854e                	mv	a0,s3
  40005e:	2dc000ef          	jal	40033a <write>
    if(i + 1 < argc){
  400062:	fd549ee3          	bne	s1,s5,40003e <main+0x3e>
    } else {
      write(1, "\n", 1);
  400066:	4605                	li	a2,1
  400068:	00001597          	auipc	a1,0x1
  40006c:	89058593          	addi	a1,a1,-1904 # 4008f8 <malloc+0x108>
  400070:	8532                	mv	a0,a2
  400072:	2c8000ef          	jal	40033a <write>
    }
  }
  exit(0);
  400076:	4501                	li	a0,0
  400078:	2a2000ef          	jal	40031a <exit>

000000000040007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  40007c:	1141                	addi	sp,sp,-16
  40007e:	e406                	sd	ra,8(sp)
  400080:	e022                	sd	s0,0(sp)
  400082:	0800                	addi	s0,sp,16
  extern int main();
  main();
  400084:	f7dff0ef          	jal	400000 <main>
  exit(0);
  400088:	4501                	li	a0,0
  40008a:	290000ef          	jal	40031a <exit>

000000000040008e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  40008e:	1141                	addi	sp,sp,-16
  400090:	e406                	sd	ra,8(sp)
  400092:	e022                	sd	s0,0(sp)
  400094:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400096:	87aa                	mv	a5,a0
  400098:	0585                	addi	a1,a1,1
  40009a:	0785                	addi	a5,a5,1
  40009c:	fff5c703          	lbu	a4,-1(a1)
  4000a0:	fee78fa3          	sb	a4,-1(a5)
  4000a4:	fb75                	bnez	a4,400098 <strcpy+0xa>
    ;
  return os;
}
  4000a6:	60a2                	ld	ra,8(sp)
  4000a8:	6402                	ld	s0,0(sp)
  4000aa:	0141                	addi	sp,sp,16
  4000ac:	8082                	ret

00000000004000ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4000ae:	1141                	addi	sp,sp,-16
  4000b0:	e406                	sd	ra,8(sp)
  4000b2:	e022                	sd	s0,0(sp)
  4000b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4000b6:	00054783          	lbu	a5,0(a0)
  4000ba:	cb91                	beqz	a5,4000ce <strcmp+0x20>
  4000bc:	0005c703          	lbu	a4,0(a1)
  4000c0:	00f71763          	bne	a4,a5,4000ce <strcmp+0x20>
    p++, q++;
  4000c4:	0505                	addi	a0,a0,1
  4000c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4000c8:	00054783          	lbu	a5,0(a0)
  4000cc:	fbe5                	bnez	a5,4000bc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4000ce:	0005c503          	lbu	a0,0(a1)
}
  4000d2:	40a7853b          	subw	a0,a5,a0
  4000d6:	60a2                	ld	ra,8(sp)
  4000d8:	6402                	ld	s0,0(sp)
  4000da:	0141                	addi	sp,sp,16
  4000dc:	8082                	ret

00000000004000de <strlen>:

uint
strlen(const char *s)
{
  4000de:	1141                	addi	sp,sp,-16
  4000e0:	e406                	sd	ra,8(sp)
  4000e2:	e022                	sd	s0,0(sp)
  4000e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4000e6:	00054783          	lbu	a5,0(a0)
  4000ea:	cf99                	beqz	a5,400108 <strlen+0x2a>
  4000ec:	0505                	addi	a0,a0,1
  4000ee:	87aa                	mv	a5,a0
  4000f0:	86be                	mv	a3,a5
  4000f2:	0785                	addi	a5,a5,1
  4000f4:	fff7c703          	lbu	a4,-1(a5)
  4000f8:	ff65                	bnez	a4,4000f0 <strlen+0x12>
  4000fa:	40a6853b          	subw	a0,a3,a0
  4000fe:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  400100:	60a2                	ld	ra,8(sp)
  400102:	6402                	ld	s0,0(sp)
  400104:	0141                	addi	sp,sp,16
  400106:	8082                	ret
  for(n = 0; s[n]; n++)
  400108:	4501                	li	a0,0
  40010a:	bfdd                	j	400100 <strlen+0x22>

000000000040010c <memset>:

void*
memset(void *dst, int c, uint n)
{
  40010c:	1141                	addi	sp,sp,-16
  40010e:	e406                	sd	ra,8(sp)
  400110:	e022                	sd	s0,0(sp)
  400112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400114:	ca19                	beqz	a2,40012a <memset+0x1e>
  400116:	87aa                	mv	a5,a0
  400118:	1602                	slli	a2,a2,0x20
  40011a:	9201                	srli	a2,a2,0x20
  40011c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400124:	0785                	addi	a5,a5,1
  400126:	fee79de3          	bne	a5,a4,400120 <memset+0x14>
  }
  return dst;
}
  40012a:	60a2                	ld	ra,8(sp)
  40012c:	6402                	ld	s0,0(sp)
  40012e:	0141                	addi	sp,sp,16
  400130:	8082                	ret

0000000000400132 <strchr>:

char*
strchr(const char *s, char c)
{
  400132:	1141                	addi	sp,sp,-16
  400134:	e406                	sd	ra,8(sp)
  400136:	e022                	sd	s0,0(sp)
  400138:	0800                	addi	s0,sp,16
  for(; *s; s++)
  40013a:	00054783          	lbu	a5,0(a0)
  40013e:	cf81                	beqz	a5,400156 <strchr+0x24>
    if(*s == c)
  400140:	00f58763          	beq	a1,a5,40014e <strchr+0x1c>
  for(; *s; s++)
  400144:	0505                	addi	a0,a0,1
  400146:	00054783          	lbu	a5,0(a0)
  40014a:	fbfd                	bnez	a5,400140 <strchr+0xe>
      return (char*)s;
  return 0;
  40014c:	4501                	li	a0,0
}
  40014e:	60a2                	ld	ra,8(sp)
  400150:	6402                	ld	s0,0(sp)
  400152:	0141                	addi	sp,sp,16
  400154:	8082                	ret
  return 0;
  400156:	4501                	li	a0,0
  400158:	bfdd                	j	40014e <strchr+0x1c>

000000000040015a <gets>:

char*
gets(char *buf, int max)
{
  40015a:	7159                	addi	sp,sp,-112
  40015c:	f486                	sd	ra,104(sp)
  40015e:	f0a2                	sd	s0,96(sp)
  400160:	eca6                	sd	s1,88(sp)
  400162:	e8ca                	sd	s2,80(sp)
  400164:	e4ce                	sd	s3,72(sp)
  400166:	e0d2                	sd	s4,64(sp)
  400168:	fc56                	sd	s5,56(sp)
  40016a:	f85a                	sd	s6,48(sp)
  40016c:	f45e                	sd	s7,40(sp)
  40016e:	f062                	sd	s8,32(sp)
  400170:	ec66                	sd	s9,24(sp)
  400172:	e86a                	sd	s10,16(sp)
  400174:	1880                	addi	s0,sp,112
  400176:	8caa                	mv	s9,a0
  400178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  40017a:	892a                	mv	s2,a0
  40017c:	4481                	li	s1,0
    cc = read(0, &c, 1);
  40017e:	f9f40b13          	addi	s6,s0,-97
  400182:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400184:	4ba9                	li	s7,10
  400186:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400188:	8d26                	mv	s10,s1
  40018a:	0014899b          	addiw	s3,s1,1
  40018e:	84ce                	mv	s1,s3
  400190:	0349d563          	bge	s3,s4,4001ba <gets+0x60>
    cc = read(0, &c, 1);
  400194:	8656                	mv	a2,s5
  400196:	85da                	mv	a1,s6
  400198:	4501                	li	a0,0
  40019a:	198000ef          	jal	400332 <read>
    if(cc < 1)
  40019e:	00a05e63          	blez	a0,4001ba <gets+0x60>
    buf[i++] = c;
  4001a2:	f9f44783          	lbu	a5,-97(s0)
  4001a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  4001aa:	01778763          	beq	a5,s7,4001b8 <gets+0x5e>
  4001ae:	0905                	addi	s2,s2,1
  4001b0:	fd879ce3          	bne	a5,s8,400188 <gets+0x2e>
    buf[i++] = c;
  4001b4:	8d4e                	mv	s10,s3
  4001b6:	a011                	j	4001ba <gets+0x60>
  4001b8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  4001ba:	9d66                	add	s10,s10,s9
  4001bc:	000d0023          	sb	zero,0(s10)
  return buf;
}
  4001c0:	8566                	mv	a0,s9
  4001c2:	70a6                	ld	ra,104(sp)
  4001c4:	7406                	ld	s0,96(sp)
  4001c6:	64e6                	ld	s1,88(sp)
  4001c8:	6946                	ld	s2,80(sp)
  4001ca:	69a6                	ld	s3,72(sp)
  4001cc:	6a06                	ld	s4,64(sp)
  4001ce:	7ae2                	ld	s5,56(sp)
  4001d0:	7b42                	ld	s6,48(sp)
  4001d2:	7ba2                	ld	s7,40(sp)
  4001d4:	7c02                	ld	s8,32(sp)
  4001d6:	6ce2                	ld	s9,24(sp)
  4001d8:	6d42                	ld	s10,16(sp)
  4001da:	6165                	addi	sp,sp,112
  4001dc:	8082                	ret

00000000004001de <stat>:

int
stat(const char *n, struct stat *st)
{
  4001de:	1101                	addi	sp,sp,-32
  4001e0:	ec06                	sd	ra,24(sp)
  4001e2:	e822                	sd	s0,16(sp)
  4001e4:	e04a                	sd	s2,0(sp)
  4001e6:	1000                	addi	s0,sp,32
  4001e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4001ea:	4581                	li	a1,0
  4001ec:	16e000ef          	jal	40035a <open>
  if(fd < 0)
  4001f0:	02054263          	bltz	a0,400214 <stat+0x36>
  4001f4:	e426                	sd	s1,8(sp)
  4001f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4001f8:	85ca                	mv	a1,s2
  4001fa:	178000ef          	jal	400372 <fstat>
  4001fe:	892a                	mv	s2,a0
  close(fd);
  400200:	8526                	mv	a0,s1
  400202:	140000ef          	jal	400342 <close>
  return r;
  400206:	64a2                	ld	s1,8(sp)
}
  400208:	854a                	mv	a0,s2
  40020a:	60e2                	ld	ra,24(sp)
  40020c:	6442                	ld	s0,16(sp)
  40020e:	6902                	ld	s2,0(sp)
  400210:	6105                	addi	sp,sp,32
  400212:	8082                	ret
    return -1;
  400214:	597d                	li	s2,-1
  400216:	bfcd                	j	400208 <stat+0x2a>

0000000000400218 <atoi>:

int
atoi(const char *s)
{
  400218:	1141                	addi	sp,sp,-16
  40021a:	e406                	sd	ra,8(sp)
  40021c:	e022                	sd	s0,0(sp)
  40021e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400220:	00054683          	lbu	a3,0(a0)
  400224:	fd06879b          	addiw	a5,a3,-48
  400228:	0ff7f793          	zext.b	a5,a5
  40022c:	4625                	li	a2,9
  40022e:	02f66963          	bltu	a2,a5,400260 <atoi+0x48>
  400232:	872a                	mv	a4,a0
  n = 0;
  400234:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400236:	0705                	addi	a4,a4,1
  400238:	0025179b          	slliw	a5,a0,0x2
  40023c:	9fa9                	addw	a5,a5,a0
  40023e:	0017979b          	slliw	a5,a5,0x1
  400242:	9fb5                	addw	a5,a5,a3
  400244:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400248:	00074683          	lbu	a3,0(a4)
  40024c:	fd06879b          	addiw	a5,a3,-48
  400250:	0ff7f793          	zext.b	a5,a5
  400254:	fef671e3          	bgeu	a2,a5,400236 <atoi+0x1e>
  return n;
}
  400258:	60a2                	ld	ra,8(sp)
  40025a:	6402                	ld	s0,0(sp)
  40025c:	0141                	addi	sp,sp,16
  40025e:	8082                	ret
  n = 0;
  400260:	4501                	li	a0,0
  400262:	bfdd                	j	400258 <atoi+0x40>

0000000000400264 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400264:	1141                	addi	sp,sp,-16
  400266:	e406                	sd	ra,8(sp)
  400268:	e022                	sd	s0,0(sp)
  40026a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  40026c:	02b57563          	bgeu	a0,a1,400296 <memmove+0x32>
    while(n-- > 0)
  400270:	00c05f63          	blez	a2,40028e <memmove+0x2a>
  400274:	1602                	slli	a2,a2,0x20
  400276:	9201                	srli	a2,a2,0x20
  400278:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  40027c:	872a                	mv	a4,a0
      *dst++ = *src++;
  40027e:	0585                	addi	a1,a1,1
  400280:	0705                	addi	a4,a4,1
  400282:	fff5c683          	lbu	a3,-1(a1)
  400286:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  40028a:	fee79ae3          	bne	a5,a4,40027e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  40028e:	60a2                	ld	ra,8(sp)
  400290:	6402                	ld	s0,0(sp)
  400292:	0141                	addi	sp,sp,16
  400294:	8082                	ret
    dst += n;
  400296:	00c50733          	add	a4,a0,a2
    src += n;
  40029a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  40029c:	fec059e3          	blez	a2,40028e <memmove+0x2a>
  4002a0:	fff6079b          	addiw	a5,a2,-1
  4002a4:	1782                	slli	a5,a5,0x20
  4002a6:	9381                	srli	a5,a5,0x20
  4002a8:	fff7c793          	not	a5,a5
  4002ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  4002ae:	15fd                	addi	a1,a1,-1
  4002b0:	177d                	addi	a4,a4,-1
  4002b2:	0005c683          	lbu	a3,0(a1)
  4002b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  4002ba:	fef71ae3          	bne	a4,a5,4002ae <memmove+0x4a>
  4002be:	bfc1                	j	40028e <memmove+0x2a>

00000000004002c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  4002c0:	1141                	addi	sp,sp,-16
  4002c2:	e406                	sd	ra,8(sp)
  4002c4:	e022                	sd	s0,0(sp)
  4002c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4002c8:	ca0d                	beqz	a2,4002fa <memcmp+0x3a>
  4002ca:	fff6069b          	addiw	a3,a2,-1
  4002ce:	1682                	slli	a3,a3,0x20
  4002d0:	9281                	srli	a3,a3,0x20
  4002d2:	0685                	addi	a3,a3,1
  4002d4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4002d6:	00054783          	lbu	a5,0(a0)
  4002da:	0005c703          	lbu	a4,0(a1)
  4002de:	00e79863          	bne	a5,a4,4002ee <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4002e2:	0505                	addi	a0,a0,1
    p2++;
  4002e4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4002e6:	fed518e3          	bne	a0,a3,4002d6 <memcmp+0x16>
  }
  return 0;
  4002ea:	4501                	li	a0,0
  4002ec:	a019                	j	4002f2 <memcmp+0x32>
      return *p1 - *p2;
  4002ee:	40e7853b          	subw	a0,a5,a4
}
  4002f2:	60a2                	ld	ra,8(sp)
  4002f4:	6402                	ld	s0,0(sp)
  4002f6:	0141                	addi	sp,sp,16
  4002f8:	8082                	ret
  return 0;
  4002fa:	4501                	li	a0,0
  4002fc:	bfdd                	j	4002f2 <memcmp+0x32>

00000000004002fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4002fe:	1141                	addi	sp,sp,-16
  400300:	e406                	sd	ra,8(sp)
  400302:	e022                	sd	s0,0(sp)
  400304:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400306:	f5fff0ef          	jal	400264 <memmove>
}
  40030a:	60a2                	ld	ra,8(sp)
  40030c:	6402                	ld	s0,0(sp)
  40030e:	0141                	addi	sp,sp,16
  400310:	8082                	ret

0000000000400312 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  400312:	4885                	li	a7,1
 ecall
  400314:	00000073          	ecall
 ret
  400318:	8082                	ret

000000000040031a <exit>:
.global exit
exit:
 li a7, SYS_exit
  40031a:	4889                	li	a7,2
 ecall
  40031c:	00000073          	ecall
 ret
  400320:	8082                	ret

0000000000400322 <wait>:
.global wait
wait:
 li a7, SYS_wait
  400322:	488d                	li	a7,3
 ecall
  400324:	00000073          	ecall
 ret
  400328:	8082                	ret

000000000040032a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  40032a:	4891                	li	a7,4
 ecall
  40032c:	00000073          	ecall
 ret
  400330:	8082                	ret

0000000000400332 <read>:
.global read
read:
 li a7, SYS_read
  400332:	4895                	li	a7,5
 ecall
  400334:	00000073          	ecall
 ret
  400338:	8082                	ret

000000000040033a <write>:
.global write
write:
 li a7, SYS_write
  40033a:	48c1                	li	a7,16
 ecall
  40033c:	00000073          	ecall
 ret
  400340:	8082                	ret

0000000000400342 <close>:
.global close
close:
 li a7, SYS_close
  400342:	48d5                	li	a7,21
 ecall
  400344:	00000073          	ecall
 ret
  400348:	8082                	ret

000000000040034a <kill>:
.global kill
kill:
 li a7, SYS_kill
  40034a:	4899                	li	a7,6
 ecall
  40034c:	00000073          	ecall
 ret
  400350:	8082                	ret

0000000000400352 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400352:	489d                	li	a7,7
 ecall
  400354:	00000073          	ecall
 ret
  400358:	8082                	ret

000000000040035a <open>:
.global open
open:
 li a7, SYS_open
  40035a:	48bd                	li	a7,15
 ecall
  40035c:	00000073          	ecall
 ret
  400360:	8082                	ret

0000000000400362 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400362:	48c5                	li	a7,17
 ecall
  400364:	00000073          	ecall
 ret
  400368:	8082                	ret

000000000040036a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  40036a:	48c9                	li	a7,18
 ecall
  40036c:	00000073          	ecall
 ret
  400370:	8082                	ret

0000000000400372 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  400372:	48a1                	li	a7,8
 ecall
  400374:	00000073          	ecall
 ret
  400378:	8082                	ret

000000000040037a <link>:
.global link
link:
 li a7, SYS_link
  40037a:	48cd                	li	a7,19
 ecall
  40037c:	00000073          	ecall
 ret
  400380:	8082                	ret

0000000000400382 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400382:	48d1                	li	a7,20
 ecall
  400384:	00000073          	ecall
 ret
  400388:	8082                	ret

000000000040038a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  40038a:	48a5                	li	a7,9
 ecall
  40038c:	00000073          	ecall
 ret
  400390:	8082                	ret

0000000000400392 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400392:	48a9                	li	a7,10
 ecall
  400394:	00000073          	ecall
 ret
  400398:	8082                	ret

000000000040039a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  40039a:	48ad                	li	a7,11
 ecall
  40039c:	00000073          	ecall
 ret
  4003a0:	8082                	ret

00000000004003a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  4003a2:	48b1                	li	a7,12
 ecall
  4003a4:	00000073          	ecall
 ret
  4003a8:	8082                	ret

00000000004003aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  4003aa:	48b5                	li	a7,13
 ecall
  4003ac:	00000073          	ecall
 ret
  4003b0:	8082                	ret

00000000004003b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  4003b2:	48b9                	li	a7,14
 ecall
  4003b4:	00000073          	ecall
 ret
  4003b8:	8082                	ret

00000000004003ba <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  4003ba:	48d9                	li	a7,22
 ecall
  4003bc:	00000073          	ecall
 ret
  4003c0:	8082                	ret

00000000004003c2 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  4003c2:	48dd                	li	a7,23
 ecall
  4003c4:	00000073          	ecall
 ret
  4003c8:	8082                	ret

00000000004003ca <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4003ca:	48e1                	li	a7,24
 ecall
  4003cc:	00000073          	ecall
 ret
  4003d0:	8082                	ret

00000000004003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4003d2:	1101                	addi	sp,sp,-32
  4003d4:	ec06                	sd	ra,24(sp)
  4003d6:	e822                	sd	s0,16(sp)
  4003d8:	1000                	addi	s0,sp,32
  4003da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4003de:	4605                	li	a2,1
  4003e0:	fef40593          	addi	a1,s0,-17
  4003e4:	f57ff0ef          	jal	40033a <write>
}
  4003e8:	60e2                	ld	ra,24(sp)
  4003ea:	6442                	ld	s0,16(sp)
  4003ec:	6105                	addi	sp,sp,32
  4003ee:	8082                	ret

00000000004003f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4003f0:	7139                	addi	sp,sp,-64
  4003f2:	fc06                	sd	ra,56(sp)
  4003f4:	f822                	sd	s0,48(sp)
  4003f6:	f426                	sd	s1,40(sp)
  4003f8:	f04a                	sd	s2,32(sp)
  4003fa:	ec4e                	sd	s3,24(sp)
  4003fc:	0080                	addi	s0,sp,64
  4003fe:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  400400:	c299                	beqz	a3,400406 <printint+0x16>
  400402:	0605ce63          	bltz	a1,40047e <printint+0x8e>
  neg = 0;
  400406:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400408:	fc040313          	addi	t1,s0,-64
  neg = 0;
  40040c:	869a                	mv	a3,t1
  i = 0;
  40040e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  400410:	00000817          	auipc	a6,0x0
  400414:	4f880813          	addi	a6,a6,1272 # 400908 <digits>
  400418:	88be                	mv	a7,a5
  40041a:	0017851b          	addiw	a0,a5,1
  40041e:	87aa                	mv	a5,a0
  400420:	02c5f73b          	remuw	a4,a1,a2
  400424:	1702                	slli	a4,a4,0x20
  400426:	9301                	srli	a4,a4,0x20
  400428:	9742                	add	a4,a4,a6
  40042a:	00074703          	lbu	a4,0(a4)
  40042e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400432:	872e                	mv	a4,a1
  400434:	02c5d5bb          	divuw	a1,a1,a2
  400438:	0685                	addi	a3,a3,1
  40043a:	fcc77fe3          	bgeu	a4,a2,400418 <printint+0x28>
  if(neg)
  40043e:	000e0c63          	beqz	t3,400456 <printint+0x66>
    buf[i++] = '-';
  400442:	fd050793          	addi	a5,a0,-48
  400446:	00878533          	add	a0,a5,s0
  40044a:	02d00793          	li	a5,45
  40044e:	fef50823          	sb	a5,-16(a0)
  400452:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400456:	fff7899b          	addiw	s3,a5,-1
  40045a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  40045e:	fff4c583          	lbu	a1,-1(s1)
  400462:	854a                	mv	a0,s2
  400464:	f6fff0ef          	jal	4003d2 <putc>
  while(--i >= 0)
  400468:	39fd                	addiw	s3,s3,-1
  40046a:	14fd                	addi	s1,s1,-1
  40046c:	fe09d9e3          	bgez	s3,40045e <printint+0x6e>
}
  400470:	70e2                	ld	ra,56(sp)
  400472:	7442                	ld	s0,48(sp)
  400474:	74a2                	ld	s1,40(sp)
  400476:	7902                	ld	s2,32(sp)
  400478:	69e2                	ld	s3,24(sp)
  40047a:	6121                	addi	sp,sp,64
  40047c:	8082                	ret
    x = -xx;
  40047e:	40b005bb          	negw	a1,a1
    neg = 1;
  400482:	4e05                	li	t3,1
    x = -xx;
  400484:	b751                	j	400408 <printint+0x18>

0000000000400486 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400486:	711d                	addi	sp,sp,-96
  400488:	ec86                	sd	ra,88(sp)
  40048a:	e8a2                	sd	s0,80(sp)
  40048c:	e4a6                	sd	s1,72(sp)
  40048e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400490:	0005c483          	lbu	s1,0(a1)
  400494:	26048663          	beqz	s1,400700 <vprintf+0x27a>
  400498:	e0ca                	sd	s2,64(sp)
  40049a:	fc4e                	sd	s3,56(sp)
  40049c:	f852                	sd	s4,48(sp)
  40049e:	f456                	sd	s5,40(sp)
  4004a0:	f05a                	sd	s6,32(sp)
  4004a2:	ec5e                	sd	s7,24(sp)
  4004a4:	e862                	sd	s8,16(sp)
  4004a6:	e466                	sd	s9,8(sp)
  4004a8:	8b2a                	mv	s6,a0
  4004aa:	8a2e                	mv	s4,a1
  4004ac:	8bb2                	mv	s7,a2
  state = 0;
  4004ae:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  4004b0:	4901                	li	s2,0
  4004b2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  4004b4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  4004b8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  4004bc:	06c00c93          	li	s9,108
  4004c0:	a00d                	j	4004e2 <vprintf+0x5c>
        putc(fd, c0);
  4004c2:	85a6                	mv	a1,s1
  4004c4:	855a                	mv	a0,s6
  4004c6:	f0dff0ef          	jal	4003d2 <putc>
  4004ca:	a019                	j	4004d0 <vprintf+0x4a>
    } else if(state == '%'){
  4004cc:	03598363          	beq	s3,s5,4004f2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4004d0:	0019079b          	addiw	a5,s2,1
  4004d4:	893e                	mv	s2,a5
  4004d6:	873e                	mv	a4,a5
  4004d8:	97d2                	add	a5,a5,s4
  4004da:	0007c483          	lbu	s1,0(a5)
  4004de:	20048963          	beqz	s1,4006f0 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4004e2:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4004e6:	fe0993e3          	bnez	s3,4004cc <vprintf+0x46>
      if(c0 == '%'){
  4004ea:	fd579ce3          	bne	a5,s5,4004c2 <vprintf+0x3c>
        state = '%';
  4004ee:	89be                	mv	s3,a5
  4004f0:	b7c5                	j	4004d0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4004f2:	00ea06b3          	add	a3,s4,a4
  4004f6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4004fa:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4004fc:	c681                	beqz	a3,400504 <vprintf+0x7e>
  4004fe:	9752                	add	a4,a4,s4
  400500:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  400504:	03878e63          	beq	a5,s8,400540 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400508:	05978863          	beq	a5,s9,400558 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  40050c:	07500713          	li	a4,117
  400510:	0ee78263          	beq	a5,a4,4005f4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400514:	07800713          	li	a4,120
  400518:	12e78463          	beq	a5,a4,400640 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  40051c:	07000713          	li	a4,112
  400520:	14e78963          	beq	a5,a4,400672 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400524:	07300713          	li	a4,115
  400528:	18e78863          	beq	a5,a4,4006b8 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  40052c:	02500713          	li	a4,37
  400530:	04e79463          	bne	a5,a4,400578 <vprintf+0xf2>
        putc(fd, '%');
  400534:	85ba                	mv	a1,a4
  400536:	855a                	mv	a0,s6
  400538:	e9bff0ef          	jal	4003d2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  40053c:	4981                	li	s3,0
  40053e:	bf49                	j	4004d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400540:	008b8493          	addi	s1,s7,8
  400544:	4685                	li	a3,1
  400546:	4629                	li	a2,10
  400548:	000ba583          	lw	a1,0(s7)
  40054c:	855a                	mv	a0,s6
  40054e:	ea3ff0ef          	jal	4003f0 <printint>
  400552:	8ba6                	mv	s7,s1
      state = 0;
  400554:	4981                	li	s3,0
  400556:	bfad                	j	4004d0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400558:	06400793          	li	a5,100
  40055c:	02f68963          	beq	a3,a5,40058e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400560:	06c00793          	li	a5,108
  400564:	04f68263          	beq	a3,a5,4005a8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400568:	07500793          	li	a5,117
  40056c:	0af68063          	beq	a3,a5,40060c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400570:	07800793          	li	a5,120
  400574:	0ef68263          	beq	a3,a5,400658 <vprintf+0x1d2>
        putc(fd, '%');
  400578:	02500593          	li	a1,37
  40057c:	855a                	mv	a0,s6
  40057e:	e55ff0ef          	jal	4003d2 <putc>
        putc(fd, c0);
  400582:	85a6                	mv	a1,s1
  400584:	855a                	mv	a0,s6
  400586:	e4dff0ef          	jal	4003d2 <putc>
      state = 0;
  40058a:	4981                	li	s3,0
  40058c:	b791                	j	4004d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  40058e:	008b8493          	addi	s1,s7,8
  400592:	4685                	li	a3,1
  400594:	4629                	li	a2,10
  400596:	000ba583          	lw	a1,0(s7)
  40059a:	855a                	mv	a0,s6
  40059c:	e55ff0ef          	jal	4003f0 <printint>
        i += 1;
  4005a0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005a2:	8ba6                	mv	s7,s1
      state = 0;
  4005a4:	4981                	li	s3,0
        i += 1;
  4005a6:	b72d                	j	4004d0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4005a8:	06400793          	li	a5,100
  4005ac:	02f60763          	beq	a2,a5,4005da <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  4005b0:	07500793          	li	a5,117
  4005b4:	06f60963          	beq	a2,a5,400626 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  4005b8:	07800793          	li	a5,120
  4005bc:	faf61ee3          	bne	a2,a5,400578 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005c0:	008b8493          	addi	s1,s7,8
  4005c4:	4681                	li	a3,0
  4005c6:	4641                	li	a2,16
  4005c8:	000ba583          	lw	a1,0(s7)
  4005cc:	855a                	mv	a0,s6
  4005ce:	e23ff0ef          	jal	4003f0 <printint>
        i += 2;
  4005d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005d4:	8ba6                	mv	s7,s1
      state = 0;
  4005d6:	4981                	li	s3,0
        i += 2;
  4005d8:	bde5                	j	4004d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005da:	008b8493          	addi	s1,s7,8
  4005de:	4685                	li	a3,1
  4005e0:	4629                	li	a2,10
  4005e2:	000ba583          	lw	a1,0(s7)
  4005e6:	855a                	mv	a0,s6
  4005e8:	e09ff0ef          	jal	4003f0 <printint>
        i += 2;
  4005ec:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005ee:	8ba6                	mv	s7,s1
      state = 0;
  4005f0:	4981                	li	s3,0
        i += 2;
  4005f2:	bdf9                	j	4004d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4005f4:	008b8493          	addi	s1,s7,8
  4005f8:	4681                	li	a3,0
  4005fa:	4629                	li	a2,10
  4005fc:	000ba583          	lw	a1,0(s7)
  400600:	855a                	mv	a0,s6
  400602:	defff0ef          	jal	4003f0 <printint>
  400606:	8ba6                	mv	s7,s1
      state = 0;
  400608:	4981                	li	s3,0
  40060a:	b5d9                	j	4004d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  40060c:	008b8493          	addi	s1,s7,8
  400610:	4681                	li	a3,0
  400612:	4629                	li	a2,10
  400614:	000ba583          	lw	a1,0(s7)
  400618:	855a                	mv	a0,s6
  40061a:	dd7ff0ef          	jal	4003f0 <printint>
        i += 1;
  40061e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400620:	8ba6                	mv	s7,s1
      state = 0;
  400622:	4981                	li	s3,0
        i += 1;
  400624:	b575                	j	4004d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400626:	008b8493          	addi	s1,s7,8
  40062a:	4681                	li	a3,0
  40062c:	4629                	li	a2,10
  40062e:	000ba583          	lw	a1,0(s7)
  400632:	855a                	mv	a0,s6
  400634:	dbdff0ef          	jal	4003f0 <printint>
        i += 2;
  400638:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  40063a:	8ba6                	mv	s7,s1
      state = 0;
  40063c:	4981                	li	s3,0
        i += 2;
  40063e:	bd49                	j	4004d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400640:	008b8493          	addi	s1,s7,8
  400644:	4681                	li	a3,0
  400646:	4641                	li	a2,16
  400648:	000ba583          	lw	a1,0(s7)
  40064c:	855a                	mv	a0,s6
  40064e:	da3ff0ef          	jal	4003f0 <printint>
  400652:	8ba6                	mv	s7,s1
      state = 0;
  400654:	4981                	li	s3,0
  400656:	bdad                	j	4004d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400658:	008b8493          	addi	s1,s7,8
  40065c:	4681                	li	a3,0
  40065e:	4641                	li	a2,16
  400660:	000ba583          	lw	a1,0(s7)
  400664:	855a                	mv	a0,s6
  400666:	d8bff0ef          	jal	4003f0 <printint>
        i += 1;
  40066a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  40066c:	8ba6                	mv	s7,s1
      state = 0;
  40066e:	4981                	li	s3,0
        i += 1;
  400670:	b585                	j	4004d0 <vprintf+0x4a>
  400672:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  400674:	008b8d13          	addi	s10,s7,8
  400678:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  40067c:	03000593          	li	a1,48
  400680:	855a                	mv	a0,s6
  400682:	d51ff0ef          	jal	4003d2 <putc>
  putc(fd, 'x');
  400686:	07800593          	li	a1,120
  40068a:	855a                	mv	a0,s6
  40068c:	d47ff0ef          	jal	4003d2 <putc>
  400690:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400692:	00000b97          	auipc	s7,0x0
  400696:	276b8b93          	addi	s7,s7,630 # 400908 <digits>
  40069a:	03c9d793          	srli	a5,s3,0x3c
  40069e:	97de                	add	a5,a5,s7
  4006a0:	0007c583          	lbu	a1,0(a5)
  4006a4:	855a                	mv	a0,s6
  4006a6:	d2dff0ef          	jal	4003d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  4006aa:	0992                	slli	s3,s3,0x4
  4006ac:	34fd                	addiw	s1,s1,-1
  4006ae:	f4f5                	bnez	s1,40069a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  4006b0:	8bea                	mv	s7,s10
      state = 0;
  4006b2:	4981                	li	s3,0
  4006b4:	6d02                	ld	s10,0(sp)
  4006b6:	bd29                	j	4004d0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  4006b8:	008b8993          	addi	s3,s7,8
  4006bc:	000bb483          	ld	s1,0(s7)
  4006c0:	cc91                	beqz	s1,4006dc <vprintf+0x256>
        for(; *s; s++)
  4006c2:	0004c583          	lbu	a1,0(s1)
  4006c6:	c195                	beqz	a1,4006ea <vprintf+0x264>
          putc(fd, *s);
  4006c8:	855a                	mv	a0,s6
  4006ca:	d09ff0ef          	jal	4003d2 <putc>
        for(; *s; s++)
  4006ce:	0485                	addi	s1,s1,1
  4006d0:	0004c583          	lbu	a1,0(s1)
  4006d4:	f9f5                	bnez	a1,4006c8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006d6:	8bce                	mv	s7,s3
      state = 0;
  4006d8:	4981                	li	s3,0
  4006da:	bbdd                	j	4004d0 <vprintf+0x4a>
          s = "(null)";
  4006dc:	00000497          	auipc	s1,0x0
  4006e0:	22448493          	addi	s1,s1,548 # 400900 <malloc+0x110>
        for(; *s; s++)
  4006e4:	02800593          	li	a1,40
  4006e8:	b7c5                	j	4006c8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006ea:	8bce                	mv	s7,s3
      state = 0;
  4006ec:	4981                	li	s3,0
  4006ee:	b3cd                	j	4004d0 <vprintf+0x4a>
  4006f0:	6906                	ld	s2,64(sp)
  4006f2:	79e2                	ld	s3,56(sp)
  4006f4:	7a42                	ld	s4,48(sp)
  4006f6:	7aa2                	ld	s5,40(sp)
  4006f8:	7b02                	ld	s6,32(sp)
  4006fa:	6be2                	ld	s7,24(sp)
  4006fc:	6c42                	ld	s8,16(sp)
  4006fe:	6ca2                	ld	s9,8(sp)
    }
  }
}
  400700:	60e6                	ld	ra,88(sp)
  400702:	6446                	ld	s0,80(sp)
  400704:	64a6                	ld	s1,72(sp)
  400706:	6125                	addi	sp,sp,96
  400708:	8082                	ret

000000000040070a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  40070a:	715d                	addi	sp,sp,-80
  40070c:	ec06                	sd	ra,24(sp)
  40070e:	e822                	sd	s0,16(sp)
  400710:	1000                	addi	s0,sp,32
  400712:	e010                	sd	a2,0(s0)
  400714:	e414                	sd	a3,8(s0)
  400716:	e818                	sd	a4,16(s0)
  400718:	ec1c                	sd	a5,24(s0)
  40071a:	03043023          	sd	a6,32(s0)
  40071e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  400722:	8622                	mv	a2,s0
  400724:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400728:	d5fff0ef          	jal	400486 <vprintf>
  return 0;
}
  40072c:	4501                	li	a0,0
  40072e:	60e2                	ld	ra,24(sp)
  400730:	6442                	ld	s0,16(sp)
  400732:	6161                	addi	sp,sp,80
  400734:	8082                	ret

0000000000400736 <printf>:

int
printf(const char *fmt, ...)
{
  400736:	711d                	addi	sp,sp,-96
  400738:	ec06                	sd	ra,24(sp)
  40073a:	e822                	sd	s0,16(sp)
  40073c:	1000                	addi	s0,sp,32
  40073e:	e40c                	sd	a1,8(s0)
  400740:	e810                	sd	a2,16(s0)
  400742:	ec14                	sd	a3,24(s0)
  400744:	f018                	sd	a4,32(s0)
  400746:	f41c                	sd	a5,40(s0)
  400748:	03043823          	sd	a6,48(s0)
  40074c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400750:	00840613          	addi	a2,s0,8
  400754:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400758:	85aa                	mv	a1,a0
  40075a:	4505                	li	a0,1
  40075c:	d2bff0ef          	jal	400486 <vprintf>
  return 0;
}
  400760:	4501                	li	a0,0
  400762:	60e2                	ld	ra,24(sp)
  400764:	6442                	ld	s0,16(sp)
  400766:	6125                	addi	sp,sp,96
  400768:	8082                	ret

000000000040076a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  40076a:	1141                	addi	sp,sp,-16
  40076c:	e406                	sd	ra,8(sp)
  40076e:	e022                	sd	s0,0(sp)
  400770:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  400772:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400776:	00001797          	auipc	a5,0x1
  40077a:	88a7b783          	ld	a5,-1910(a5) # 401000 <freep>
  40077e:	a02d                	j	4007a8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400780:	4618                	lw	a4,8(a2)
  400782:	9f2d                	addw	a4,a4,a1
  400784:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400788:	6398                	ld	a4,0(a5)
  40078a:	6310                	ld	a2,0(a4)
  40078c:	a83d                	j	4007ca <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  40078e:	ff852703          	lw	a4,-8(a0)
  400792:	9f31                	addw	a4,a4,a2
  400794:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400796:	ff053683          	ld	a3,-16(a0)
  40079a:	a091                	j	4007de <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40079c:	6398                	ld	a4,0(a5)
  40079e:	00e7e463          	bltu	a5,a4,4007a6 <free+0x3c>
  4007a2:	00e6ea63          	bltu	a3,a4,4007b6 <free+0x4c>
{
  4007a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4007a8:	fed7fae3          	bgeu	a5,a3,40079c <free+0x32>
  4007ac:	6398                	ld	a4,0(a5)
  4007ae:	00e6e463          	bltu	a3,a4,4007b6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4007b2:	fee7eae3          	bltu	a5,a4,4007a6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4007b6:	ff852583          	lw	a1,-8(a0)
  4007ba:	6390                	ld	a2,0(a5)
  4007bc:	02059813          	slli	a6,a1,0x20
  4007c0:	01c85713          	srli	a4,a6,0x1c
  4007c4:	9736                	add	a4,a4,a3
  4007c6:	fae60de3          	beq	a2,a4,400780 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4007ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4007ce:	4790                	lw	a2,8(a5)
  4007d0:	02061593          	slli	a1,a2,0x20
  4007d4:	01c5d713          	srli	a4,a1,0x1c
  4007d8:	973e                	add	a4,a4,a5
  4007da:	fae68ae3          	beq	a3,a4,40078e <free+0x24>
    p->s.ptr = bp->s.ptr;
  4007de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4007e0:	00001717          	auipc	a4,0x1
  4007e4:	82f73023          	sd	a5,-2016(a4) # 401000 <freep>
}
  4007e8:	60a2                	ld	ra,8(sp)
  4007ea:	6402                	ld	s0,0(sp)
  4007ec:	0141                	addi	sp,sp,16
  4007ee:	8082                	ret

00000000004007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4007f0:	7139                	addi	sp,sp,-64
  4007f2:	fc06                	sd	ra,56(sp)
  4007f4:	f822                	sd	s0,48(sp)
  4007f6:	f04a                	sd	s2,32(sp)
  4007f8:	ec4e                	sd	s3,24(sp)
  4007fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4007fc:	02051993          	slli	s3,a0,0x20
  400800:	0209d993          	srli	s3,s3,0x20
  400804:	09bd                	addi	s3,s3,15
  400806:	0049d993          	srli	s3,s3,0x4
  40080a:	2985                	addiw	s3,s3,1
  40080c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  40080e:	00000517          	auipc	a0,0x0
  400812:	7f253503          	ld	a0,2034(a0) # 401000 <freep>
  400816:	c905                	beqz	a0,400846 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40081a:	4798                	lw	a4,8(a5)
  40081c:	09377663          	bgeu	a4,s3,4008a8 <malloc+0xb8>
  400820:	f426                	sd	s1,40(sp)
  400822:	e852                	sd	s4,16(sp)
  400824:	e456                	sd	s5,8(sp)
  400826:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400828:	8a4e                	mv	s4,s3
  40082a:	6705                	lui	a4,0x1
  40082c:	00e9f363          	bgeu	s3,a4,400832 <malloc+0x42>
  400830:	6a05                	lui	s4,0x1
  400832:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400836:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  40083a:	00000497          	auipc	s1,0x0
  40083e:	7c648493          	addi	s1,s1,1990 # 401000 <freep>
  if(p == (char*)-1)
  400842:	5afd                	li	s5,-1
  400844:	a83d                	j	400882 <malloc+0x92>
  400846:	f426                	sd	s1,40(sp)
  400848:	e852                	sd	s4,16(sp)
  40084a:	e456                	sd	s5,8(sp)
  40084c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  40084e:	00000797          	auipc	a5,0x0
  400852:	7c278793          	addi	a5,a5,1986 # 401010 <base>
  400856:	00000717          	auipc	a4,0x0
  40085a:	7af73523          	sd	a5,1962(a4) # 401000 <freep>
  40085e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400860:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  400864:	b7d1                	j	400828 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400866:	6398                	ld	a4,0(a5)
  400868:	e118                	sd	a4,0(a0)
  40086a:	a899                	j	4008c0 <malloc+0xd0>
  hp->s.size = nu;
  40086c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400870:	0541                	addi	a0,a0,16
  400872:	ef9ff0ef          	jal	40076a <free>
  return freep;
  400876:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  400878:	c125                	beqz	a0,4008d8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  40087a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40087c:	4798                	lw	a4,8(a5)
  40087e:	03277163          	bgeu	a4,s2,4008a0 <malloc+0xb0>
    if(p == freep)
  400882:	6098                	ld	a4,0(s1)
  400884:	853e                	mv	a0,a5
  400886:	fef71ae3          	bne	a4,a5,40087a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  40088a:	8552                	mv	a0,s4
  40088c:	b17ff0ef          	jal	4003a2 <sbrk>
  if(p == (char*)-1)
  400890:	fd551ee3          	bne	a0,s5,40086c <malloc+0x7c>
        return 0;
  400894:	4501                	li	a0,0
  400896:	74a2                	ld	s1,40(sp)
  400898:	6a42                	ld	s4,16(sp)
  40089a:	6aa2                	ld	s5,8(sp)
  40089c:	6b02                	ld	s6,0(sp)
  40089e:	a03d                	j	4008cc <malloc+0xdc>
  4008a0:	74a2                	ld	s1,40(sp)
  4008a2:	6a42                	ld	s4,16(sp)
  4008a4:	6aa2                	ld	s5,8(sp)
  4008a6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  4008a8:	fae90fe3          	beq	s2,a4,400866 <malloc+0x76>
        p->s.size -= nunits;
  4008ac:	4137073b          	subw	a4,a4,s3
  4008b0:	c798                	sw	a4,8(a5)
        p += p->s.size;
  4008b2:	02071693          	slli	a3,a4,0x20
  4008b6:	01c6d713          	srli	a4,a3,0x1c
  4008ba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4008bc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4008c0:	00000717          	auipc	a4,0x0
  4008c4:	74a73023          	sd	a0,1856(a4) # 401000 <freep>
      return (void*)(p + 1);
  4008c8:	01078513          	addi	a0,a5,16
  }
}
  4008cc:	70e2                	ld	ra,56(sp)
  4008ce:	7442                	ld	s0,48(sp)
  4008d0:	7902                	ld	s2,32(sp)
  4008d2:	69e2                	ld	s3,24(sp)
  4008d4:	6121                	addi	sp,sp,64
  4008d6:	8082                	ret
  4008d8:	74a2                	ld	s1,40(sp)
  4008da:	6a42                	ld	s4,16(sp)
  4008dc:	6aa2                	ld	s5,8(sp)
  4008de:	6b02                	ld	s6,0(sp)
  4008e0:	b7f5                	j	4008cc <malloc+0xdc>
