
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
  400000:	1101                	addi	sp,sp,-32
  400002:	ec06                	sd	ra,24(sp)
  400004:	e822                	sd	s0,16(sp)
  400006:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
  400008:	4785                	li	a5,1
  40000a:	02a7d963          	bge	a5,a0,40003c <main+0x3c>
  40000e:	e426                	sd	s1,8(sp)
  400010:	e04a                	sd	s2,0(sp)
  400012:	00858493          	addi	s1,a1,8
  400016:	ffe5091b          	addiw	s2,a0,-2
  40001a:	02091793          	slli	a5,s2,0x20
  40001e:	01d7d913          	srli	s2,a5,0x1d
  400022:	05c1                	addi	a1,a1,16
  400024:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  400026:	6088                	ld	a0,0(s1)
  400028:	1c8000ef          	jal	4001f0 <atoi>
  40002c:	2f6000ef          	jal	400322 <kill>
  for(i=1; i<argc; i++)
  400030:	04a1                	addi	s1,s1,8
  400032:	ff249ae3          	bne	s1,s2,400026 <main+0x26>
  exit(0);
  400036:	4501                	li	a0,0
  400038:	2ba000ef          	jal	4002f2 <exit>
  40003c:	e426                	sd	s1,8(sp)
  40003e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  400040:	00001597          	auipc	a1,0x1
  400044:	88058593          	addi	a1,a1,-1920 # 4008c0 <malloc+0xf8>
  400048:	4509                	li	a0,2
  40004a:	698000ef          	jal	4006e2 <fprintf>
    exit(1);
  40004e:	4505                	li	a0,1
  400050:	2a2000ef          	jal	4002f2 <exit>

0000000000400054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  400054:	1141                	addi	sp,sp,-16
  400056:	e406                	sd	ra,8(sp)
  400058:	e022                	sd	s0,0(sp)
  40005a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  40005c:	fa5ff0ef          	jal	400000 <main>
  exit(0);
  400060:	4501                	li	a0,0
  400062:	290000ef          	jal	4002f2 <exit>

0000000000400066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400066:	1141                	addi	sp,sp,-16
  400068:	e406                	sd	ra,8(sp)
  40006a:	e022                	sd	s0,0(sp)
  40006c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40006e:	87aa                	mv	a5,a0
  400070:	0585                	addi	a1,a1,1
  400072:	0785                	addi	a5,a5,1
  400074:	fff5c703          	lbu	a4,-1(a1)
  400078:	fee78fa3          	sb	a4,-1(a5)
  40007c:	fb75                	bnez	a4,400070 <strcpy+0xa>
    ;
  return os;
}
  40007e:	60a2                	ld	ra,8(sp)
  400080:	6402                	ld	s0,0(sp)
  400082:	0141                	addi	sp,sp,16
  400084:	8082                	ret

0000000000400086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400086:	1141                	addi	sp,sp,-16
  400088:	e406                	sd	ra,8(sp)
  40008a:	e022                	sd	s0,0(sp)
  40008c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  40008e:	00054783          	lbu	a5,0(a0)
  400092:	cb91                	beqz	a5,4000a6 <strcmp+0x20>
  400094:	0005c703          	lbu	a4,0(a1)
  400098:	00f71763          	bne	a4,a5,4000a6 <strcmp+0x20>
    p++, q++;
  40009c:	0505                	addi	a0,a0,1
  40009e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4000a0:	00054783          	lbu	a5,0(a0)
  4000a4:	fbe5                	bnez	a5,400094 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4000a6:	0005c503          	lbu	a0,0(a1)
}
  4000aa:	40a7853b          	subw	a0,a5,a0
  4000ae:	60a2                	ld	ra,8(sp)
  4000b0:	6402                	ld	s0,0(sp)
  4000b2:	0141                	addi	sp,sp,16
  4000b4:	8082                	ret

00000000004000b6 <strlen>:

uint
strlen(const char *s)
{
  4000b6:	1141                	addi	sp,sp,-16
  4000b8:	e406                	sd	ra,8(sp)
  4000ba:	e022                	sd	s0,0(sp)
  4000bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4000be:	00054783          	lbu	a5,0(a0)
  4000c2:	cf99                	beqz	a5,4000e0 <strlen+0x2a>
  4000c4:	0505                	addi	a0,a0,1
  4000c6:	87aa                	mv	a5,a0
  4000c8:	86be                	mv	a3,a5
  4000ca:	0785                	addi	a5,a5,1
  4000cc:	fff7c703          	lbu	a4,-1(a5)
  4000d0:	ff65                	bnez	a4,4000c8 <strlen+0x12>
  4000d2:	40a6853b          	subw	a0,a3,a0
  4000d6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4000d8:	60a2                	ld	ra,8(sp)
  4000da:	6402                	ld	s0,0(sp)
  4000dc:	0141                	addi	sp,sp,16
  4000de:	8082                	ret
  for(n = 0; s[n]; n++)
  4000e0:	4501                	li	a0,0
  4000e2:	bfdd                	j	4000d8 <strlen+0x22>

00000000004000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  4000e4:	1141                	addi	sp,sp,-16
  4000e6:	e406                	sd	ra,8(sp)
  4000e8:	e022                	sd	s0,0(sp)
  4000ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  4000ec:	ca19                	beqz	a2,400102 <memset+0x1e>
  4000ee:	87aa                	mv	a5,a0
  4000f0:	1602                	slli	a2,a2,0x20
  4000f2:	9201                	srli	a2,a2,0x20
  4000f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  4000f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  4000fc:	0785                	addi	a5,a5,1
  4000fe:	fee79de3          	bne	a5,a4,4000f8 <memset+0x14>
  }
  return dst;
}
  400102:	60a2                	ld	ra,8(sp)
  400104:	6402                	ld	s0,0(sp)
  400106:	0141                	addi	sp,sp,16
  400108:	8082                	ret

000000000040010a <strchr>:

char*
strchr(const char *s, char c)
{
  40010a:	1141                	addi	sp,sp,-16
  40010c:	e406                	sd	ra,8(sp)
  40010e:	e022                	sd	s0,0(sp)
  400110:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400112:	00054783          	lbu	a5,0(a0)
  400116:	cf81                	beqz	a5,40012e <strchr+0x24>
    if(*s == c)
  400118:	00f58763          	beq	a1,a5,400126 <strchr+0x1c>
  for(; *s; s++)
  40011c:	0505                	addi	a0,a0,1
  40011e:	00054783          	lbu	a5,0(a0)
  400122:	fbfd                	bnez	a5,400118 <strchr+0xe>
      return (char*)s;
  return 0;
  400124:	4501                	li	a0,0
}
  400126:	60a2                	ld	ra,8(sp)
  400128:	6402                	ld	s0,0(sp)
  40012a:	0141                	addi	sp,sp,16
  40012c:	8082                	ret
  return 0;
  40012e:	4501                	li	a0,0
  400130:	bfdd                	j	400126 <strchr+0x1c>

0000000000400132 <gets>:

char*
gets(char *buf, int max)
{
  400132:	7159                	addi	sp,sp,-112
  400134:	f486                	sd	ra,104(sp)
  400136:	f0a2                	sd	s0,96(sp)
  400138:	eca6                	sd	s1,88(sp)
  40013a:	e8ca                	sd	s2,80(sp)
  40013c:	e4ce                	sd	s3,72(sp)
  40013e:	e0d2                	sd	s4,64(sp)
  400140:	fc56                	sd	s5,56(sp)
  400142:	f85a                	sd	s6,48(sp)
  400144:	f45e                	sd	s7,40(sp)
  400146:	f062                	sd	s8,32(sp)
  400148:	ec66                	sd	s9,24(sp)
  40014a:	e86a                	sd	s10,16(sp)
  40014c:	1880                	addi	s0,sp,112
  40014e:	8caa                	mv	s9,a0
  400150:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400152:	892a                	mv	s2,a0
  400154:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400156:	f9f40b13          	addi	s6,s0,-97
  40015a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  40015c:	4ba9                	li	s7,10
  40015e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400160:	8d26                	mv	s10,s1
  400162:	0014899b          	addiw	s3,s1,1
  400166:	84ce                	mv	s1,s3
  400168:	0349d563          	bge	s3,s4,400192 <gets+0x60>
    cc = read(0, &c, 1);
  40016c:	8656                	mv	a2,s5
  40016e:	85da                	mv	a1,s6
  400170:	4501                	li	a0,0
  400172:	198000ef          	jal	40030a <read>
    if(cc < 1)
  400176:	00a05e63          	blez	a0,400192 <gets+0x60>
    buf[i++] = c;
  40017a:	f9f44783          	lbu	a5,-97(s0)
  40017e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400182:	01778763          	beq	a5,s7,400190 <gets+0x5e>
  400186:	0905                	addi	s2,s2,1
  400188:	fd879ce3          	bne	a5,s8,400160 <gets+0x2e>
    buf[i++] = c;
  40018c:	8d4e                	mv	s10,s3
  40018e:	a011                	j	400192 <gets+0x60>
  400190:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  400192:	9d66                	add	s10,s10,s9
  400194:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400198:	8566                	mv	a0,s9
  40019a:	70a6                	ld	ra,104(sp)
  40019c:	7406                	ld	s0,96(sp)
  40019e:	64e6                	ld	s1,88(sp)
  4001a0:	6946                	ld	s2,80(sp)
  4001a2:	69a6                	ld	s3,72(sp)
  4001a4:	6a06                	ld	s4,64(sp)
  4001a6:	7ae2                	ld	s5,56(sp)
  4001a8:	7b42                	ld	s6,48(sp)
  4001aa:	7ba2                	ld	s7,40(sp)
  4001ac:	7c02                	ld	s8,32(sp)
  4001ae:	6ce2                	ld	s9,24(sp)
  4001b0:	6d42                	ld	s10,16(sp)
  4001b2:	6165                	addi	sp,sp,112
  4001b4:	8082                	ret

00000000004001b6 <stat>:

int
stat(const char *n, struct stat *st)
{
  4001b6:	1101                	addi	sp,sp,-32
  4001b8:	ec06                	sd	ra,24(sp)
  4001ba:	e822                	sd	s0,16(sp)
  4001bc:	e04a                	sd	s2,0(sp)
  4001be:	1000                	addi	s0,sp,32
  4001c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4001c2:	4581                	li	a1,0
  4001c4:	16e000ef          	jal	400332 <open>
  if(fd < 0)
  4001c8:	02054263          	bltz	a0,4001ec <stat+0x36>
  4001cc:	e426                	sd	s1,8(sp)
  4001ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4001d0:	85ca                	mv	a1,s2
  4001d2:	178000ef          	jal	40034a <fstat>
  4001d6:	892a                	mv	s2,a0
  close(fd);
  4001d8:	8526                	mv	a0,s1
  4001da:	140000ef          	jal	40031a <close>
  return r;
  4001de:	64a2                	ld	s1,8(sp)
}
  4001e0:	854a                	mv	a0,s2
  4001e2:	60e2                	ld	ra,24(sp)
  4001e4:	6442                	ld	s0,16(sp)
  4001e6:	6902                	ld	s2,0(sp)
  4001e8:	6105                	addi	sp,sp,32
  4001ea:	8082                	ret
    return -1;
  4001ec:	597d                	li	s2,-1
  4001ee:	bfcd                	j	4001e0 <stat+0x2a>

00000000004001f0 <atoi>:

int
atoi(const char *s)
{
  4001f0:	1141                	addi	sp,sp,-16
  4001f2:	e406                	sd	ra,8(sp)
  4001f4:	e022                	sd	s0,0(sp)
  4001f6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  4001f8:	00054683          	lbu	a3,0(a0)
  4001fc:	fd06879b          	addiw	a5,a3,-48
  400200:	0ff7f793          	zext.b	a5,a5
  400204:	4625                	li	a2,9
  400206:	02f66963          	bltu	a2,a5,400238 <atoi+0x48>
  40020a:	872a                	mv	a4,a0
  n = 0;
  40020c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  40020e:	0705                	addi	a4,a4,1
  400210:	0025179b          	slliw	a5,a0,0x2
  400214:	9fa9                	addw	a5,a5,a0
  400216:	0017979b          	slliw	a5,a5,0x1
  40021a:	9fb5                	addw	a5,a5,a3
  40021c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400220:	00074683          	lbu	a3,0(a4)
  400224:	fd06879b          	addiw	a5,a3,-48
  400228:	0ff7f793          	zext.b	a5,a5
  40022c:	fef671e3          	bgeu	a2,a5,40020e <atoi+0x1e>
  return n;
}
  400230:	60a2                	ld	ra,8(sp)
  400232:	6402                	ld	s0,0(sp)
  400234:	0141                	addi	sp,sp,16
  400236:	8082                	ret
  n = 0;
  400238:	4501                	li	a0,0
  40023a:	bfdd                	j	400230 <atoi+0x40>

000000000040023c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  40023c:	1141                	addi	sp,sp,-16
  40023e:	e406                	sd	ra,8(sp)
  400240:	e022                	sd	s0,0(sp)
  400242:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400244:	02b57563          	bgeu	a0,a1,40026e <memmove+0x32>
    while(n-- > 0)
  400248:	00c05f63          	blez	a2,400266 <memmove+0x2a>
  40024c:	1602                	slli	a2,a2,0x20
  40024e:	9201                	srli	a2,a2,0x20
  400250:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400254:	872a                	mv	a4,a0
      *dst++ = *src++;
  400256:	0585                	addi	a1,a1,1
  400258:	0705                	addi	a4,a4,1
  40025a:	fff5c683          	lbu	a3,-1(a1)
  40025e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400262:	fee79ae3          	bne	a5,a4,400256 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400266:	60a2                	ld	ra,8(sp)
  400268:	6402                	ld	s0,0(sp)
  40026a:	0141                	addi	sp,sp,16
  40026c:	8082                	ret
    dst += n;
  40026e:	00c50733          	add	a4,a0,a2
    src += n;
  400272:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400274:	fec059e3          	blez	a2,400266 <memmove+0x2a>
  400278:	fff6079b          	addiw	a5,a2,-1
  40027c:	1782                	slli	a5,a5,0x20
  40027e:	9381                	srli	a5,a5,0x20
  400280:	fff7c793          	not	a5,a5
  400284:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400286:	15fd                	addi	a1,a1,-1
  400288:	177d                	addi	a4,a4,-1
  40028a:	0005c683          	lbu	a3,0(a1)
  40028e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  400292:	fef71ae3          	bne	a4,a5,400286 <memmove+0x4a>
  400296:	bfc1                	j	400266 <memmove+0x2a>

0000000000400298 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400298:	1141                	addi	sp,sp,-16
  40029a:	e406                	sd	ra,8(sp)
  40029c:	e022                	sd	s0,0(sp)
  40029e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4002a0:	ca0d                	beqz	a2,4002d2 <memcmp+0x3a>
  4002a2:	fff6069b          	addiw	a3,a2,-1
  4002a6:	1682                	slli	a3,a3,0x20
  4002a8:	9281                	srli	a3,a3,0x20
  4002aa:	0685                	addi	a3,a3,1
  4002ac:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4002ae:	00054783          	lbu	a5,0(a0)
  4002b2:	0005c703          	lbu	a4,0(a1)
  4002b6:	00e79863          	bne	a5,a4,4002c6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4002ba:	0505                	addi	a0,a0,1
    p2++;
  4002bc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4002be:	fed518e3          	bne	a0,a3,4002ae <memcmp+0x16>
  }
  return 0;
  4002c2:	4501                	li	a0,0
  4002c4:	a019                	j	4002ca <memcmp+0x32>
      return *p1 - *p2;
  4002c6:	40e7853b          	subw	a0,a5,a4
}
  4002ca:	60a2                	ld	ra,8(sp)
  4002cc:	6402                	ld	s0,0(sp)
  4002ce:	0141                	addi	sp,sp,16
  4002d0:	8082                	ret
  return 0;
  4002d2:	4501                	li	a0,0
  4002d4:	bfdd                	j	4002ca <memcmp+0x32>

00000000004002d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4002d6:	1141                	addi	sp,sp,-16
  4002d8:	e406                	sd	ra,8(sp)
  4002da:	e022                	sd	s0,0(sp)
  4002dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4002de:	f5fff0ef          	jal	40023c <memmove>
}
  4002e2:	60a2                	ld	ra,8(sp)
  4002e4:	6402                	ld	s0,0(sp)
  4002e6:	0141                	addi	sp,sp,16
  4002e8:	8082                	ret

00000000004002ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  4002ea:	4885                	li	a7,1
 ecall
  4002ec:	00000073          	ecall
 ret
  4002f0:	8082                	ret

00000000004002f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
  4002f2:	4889                	li	a7,2
 ecall
  4002f4:	00000073          	ecall
 ret
  4002f8:	8082                	ret

00000000004002fa <wait>:
.global wait
wait:
 li a7, SYS_wait
  4002fa:	488d                	li	a7,3
 ecall
  4002fc:	00000073          	ecall
 ret
  400300:	8082                	ret

0000000000400302 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400302:	4891                	li	a7,4
 ecall
  400304:	00000073          	ecall
 ret
  400308:	8082                	ret

000000000040030a <read>:
.global read
read:
 li a7, SYS_read
  40030a:	4895                	li	a7,5
 ecall
  40030c:	00000073          	ecall
 ret
  400310:	8082                	ret

0000000000400312 <write>:
.global write
write:
 li a7, SYS_write
  400312:	48c1                	li	a7,16
 ecall
  400314:	00000073          	ecall
 ret
  400318:	8082                	ret

000000000040031a <close>:
.global close
close:
 li a7, SYS_close
  40031a:	48d5                	li	a7,21
 ecall
  40031c:	00000073          	ecall
 ret
  400320:	8082                	ret

0000000000400322 <kill>:
.global kill
kill:
 li a7, SYS_kill
  400322:	4899                	li	a7,6
 ecall
  400324:	00000073          	ecall
 ret
  400328:	8082                	ret

000000000040032a <exec>:
.global exec
exec:
 li a7, SYS_exec
  40032a:	489d                	li	a7,7
 ecall
  40032c:	00000073          	ecall
 ret
  400330:	8082                	ret

0000000000400332 <open>:
.global open
open:
 li a7, SYS_open
  400332:	48bd                	li	a7,15
 ecall
  400334:	00000073          	ecall
 ret
  400338:	8082                	ret

000000000040033a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  40033a:	48c5                	li	a7,17
 ecall
  40033c:	00000073          	ecall
 ret
  400340:	8082                	ret

0000000000400342 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400342:	48c9                	li	a7,18
 ecall
  400344:	00000073          	ecall
 ret
  400348:	8082                	ret

000000000040034a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  40034a:	48a1                	li	a7,8
 ecall
  40034c:	00000073          	ecall
 ret
  400350:	8082                	ret

0000000000400352 <link>:
.global link
link:
 li a7, SYS_link
  400352:	48cd                	li	a7,19
 ecall
  400354:	00000073          	ecall
 ret
  400358:	8082                	ret

000000000040035a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  40035a:	48d1                	li	a7,20
 ecall
  40035c:	00000073          	ecall
 ret
  400360:	8082                	ret

0000000000400362 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400362:	48a5                	li	a7,9
 ecall
  400364:	00000073          	ecall
 ret
  400368:	8082                	ret

000000000040036a <dup>:
.global dup
dup:
 li a7, SYS_dup
  40036a:	48a9                	li	a7,10
 ecall
  40036c:	00000073          	ecall
 ret
  400370:	8082                	ret

0000000000400372 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400372:	48ad                	li	a7,11
 ecall
  400374:	00000073          	ecall
 ret
  400378:	8082                	ret

000000000040037a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  40037a:	48b1                	li	a7,12
 ecall
  40037c:	00000073          	ecall
 ret
  400380:	8082                	ret

0000000000400382 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400382:	48b5                	li	a7,13
 ecall
  400384:	00000073          	ecall
 ret
  400388:	8082                	ret

000000000040038a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  40038a:	48b9                	li	a7,14
 ecall
  40038c:	00000073          	ecall
 ret
  400390:	8082                	ret

0000000000400392 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  400392:	48d9                	li	a7,22
 ecall
  400394:	00000073          	ecall
 ret
  400398:	8082                	ret

000000000040039a <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  40039a:	48dd                	li	a7,23
 ecall
  40039c:	00000073          	ecall
 ret
  4003a0:	8082                	ret

00000000004003a2 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4003a2:	48e1                	li	a7,24
 ecall
  4003a4:	00000073          	ecall
 ret
  4003a8:	8082                	ret

00000000004003aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4003aa:	1101                	addi	sp,sp,-32
  4003ac:	ec06                	sd	ra,24(sp)
  4003ae:	e822                	sd	s0,16(sp)
  4003b0:	1000                	addi	s0,sp,32
  4003b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4003b6:	4605                	li	a2,1
  4003b8:	fef40593          	addi	a1,s0,-17
  4003bc:	f57ff0ef          	jal	400312 <write>
}
  4003c0:	60e2                	ld	ra,24(sp)
  4003c2:	6442                	ld	s0,16(sp)
  4003c4:	6105                	addi	sp,sp,32
  4003c6:	8082                	ret

00000000004003c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4003c8:	7139                	addi	sp,sp,-64
  4003ca:	fc06                	sd	ra,56(sp)
  4003cc:	f822                	sd	s0,48(sp)
  4003ce:	f426                	sd	s1,40(sp)
  4003d0:	f04a                	sd	s2,32(sp)
  4003d2:	ec4e                	sd	s3,24(sp)
  4003d4:	0080                	addi	s0,sp,64
  4003d6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4003d8:	c299                	beqz	a3,4003de <printint+0x16>
  4003da:	0605ce63          	bltz	a1,400456 <printint+0x8e>
  neg = 0;
  4003de:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4003e0:	fc040313          	addi	t1,s0,-64
  neg = 0;
  4003e4:	869a                	mv	a3,t1
  i = 0;
  4003e6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  4003e8:	00000817          	auipc	a6,0x0
  4003ec:	4f880813          	addi	a6,a6,1272 # 4008e0 <digits>
  4003f0:	88be                	mv	a7,a5
  4003f2:	0017851b          	addiw	a0,a5,1
  4003f6:	87aa                	mv	a5,a0
  4003f8:	02c5f73b          	remuw	a4,a1,a2
  4003fc:	1702                	slli	a4,a4,0x20
  4003fe:	9301                	srli	a4,a4,0x20
  400400:	9742                	add	a4,a4,a6
  400402:	00074703          	lbu	a4,0(a4)
  400406:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  40040a:	872e                	mv	a4,a1
  40040c:	02c5d5bb          	divuw	a1,a1,a2
  400410:	0685                	addi	a3,a3,1
  400412:	fcc77fe3          	bgeu	a4,a2,4003f0 <printint+0x28>
  if(neg)
  400416:	000e0c63          	beqz	t3,40042e <printint+0x66>
    buf[i++] = '-';
  40041a:	fd050793          	addi	a5,a0,-48
  40041e:	00878533          	add	a0,a5,s0
  400422:	02d00793          	li	a5,45
  400426:	fef50823          	sb	a5,-16(a0)
  40042a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  40042e:	fff7899b          	addiw	s3,a5,-1
  400432:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400436:	fff4c583          	lbu	a1,-1(s1)
  40043a:	854a                	mv	a0,s2
  40043c:	f6fff0ef          	jal	4003aa <putc>
  while(--i >= 0)
  400440:	39fd                	addiw	s3,s3,-1
  400442:	14fd                	addi	s1,s1,-1
  400444:	fe09d9e3          	bgez	s3,400436 <printint+0x6e>
}
  400448:	70e2                	ld	ra,56(sp)
  40044a:	7442                	ld	s0,48(sp)
  40044c:	74a2                	ld	s1,40(sp)
  40044e:	7902                	ld	s2,32(sp)
  400450:	69e2                	ld	s3,24(sp)
  400452:	6121                	addi	sp,sp,64
  400454:	8082                	ret
    x = -xx;
  400456:	40b005bb          	negw	a1,a1
    neg = 1;
  40045a:	4e05                	li	t3,1
    x = -xx;
  40045c:	b751                	j	4003e0 <printint+0x18>

000000000040045e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  40045e:	711d                	addi	sp,sp,-96
  400460:	ec86                	sd	ra,88(sp)
  400462:	e8a2                	sd	s0,80(sp)
  400464:	e4a6                	sd	s1,72(sp)
  400466:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400468:	0005c483          	lbu	s1,0(a1)
  40046c:	26048663          	beqz	s1,4006d8 <vprintf+0x27a>
  400470:	e0ca                	sd	s2,64(sp)
  400472:	fc4e                	sd	s3,56(sp)
  400474:	f852                	sd	s4,48(sp)
  400476:	f456                	sd	s5,40(sp)
  400478:	f05a                	sd	s6,32(sp)
  40047a:	ec5e                	sd	s7,24(sp)
  40047c:	e862                	sd	s8,16(sp)
  40047e:	e466                	sd	s9,8(sp)
  400480:	8b2a                	mv	s6,a0
  400482:	8a2e                	mv	s4,a1
  400484:	8bb2                	mv	s7,a2
  state = 0;
  400486:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400488:	4901                	li	s2,0
  40048a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  40048c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  400490:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  400494:	06c00c93          	li	s9,108
  400498:	a00d                	j	4004ba <vprintf+0x5c>
        putc(fd, c0);
  40049a:	85a6                	mv	a1,s1
  40049c:	855a                	mv	a0,s6
  40049e:	f0dff0ef          	jal	4003aa <putc>
  4004a2:	a019                	j	4004a8 <vprintf+0x4a>
    } else if(state == '%'){
  4004a4:	03598363          	beq	s3,s5,4004ca <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4004a8:	0019079b          	addiw	a5,s2,1
  4004ac:	893e                	mv	s2,a5
  4004ae:	873e                	mv	a4,a5
  4004b0:	97d2                	add	a5,a5,s4
  4004b2:	0007c483          	lbu	s1,0(a5)
  4004b6:	20048963          	beqz	s1,4006c8 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4004ba:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4004be:	fe0993e3          	bnez	s3,4004a4 <vprintf+0x46>
      if(c0 == '%'){
  4004c2:	fd579ce3          	bne	a5,s5,40049a <vprintf+0x3c>
        state = '%';
  4004c6:	89be                	mv	s3,a5
  4004c8:	b7c5                	j	4004a8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4004ca:	00ea06b3          	add	a3,s4,a4
  4004ce:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4004d2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4004d4:	c681                	beqz	a3,4004dc <vprintf+0x7e>
  4004d6:	9752                	add	a4,a4,s4
  4004d8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4004dc:	03878e63          	beq	a5,s8,400518 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4004e0:	05978863          	beq	a5,s9,400530 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  4004e4:	07500713          	li	a4,117
  4004e8:	0ee78263          	beq	a5,a4,4005cc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  4004ec:	07800713          	li	a4,120
  4004f0:	12e78463          	beq	a5,a4,400618 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  4004f4:	07000713          	li	a4,112
  4004f8:	14e78963          	beq	a5,a4,40064a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  4004fc:	07300713          	li	a4,115
  400500:	18e78863          	beq	a5,a4,400690 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400504:	02500713          	li	a4,37
  400508:	04e79463          	bne	a5,a4,400550 <vprintf+0xf2>
        putc(fd, '%');
  40050c:	85ba                	mv	a1,a4
  40050e:	855a                	mv	a0,s6
  400510:	e9bff0ef          	jal	4003aa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400514:	4981                	li	s3,0
  400516:	bf49                	j	4004a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400518:	008b8493          	addi	s1,s7,8
  40051c:	4685                	li	a3,1
  40051e:	4629                	li	a2,10
  400520:	000ba583          	lw	a1,0(s7)
  400524:	855a                	mv	a0,s6
  400526:	ea3ff0ef          	jal	4003c8 <printint>
  40052a:	8ba6                	mv	s7,s1
      state = 0;
  40052c:	4981                	li	s3,0
  40052e:	bfad                	j	4004a8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400530:	06400793          	li	a5,100
  400534:	02f68963          	beq	a3,a5,400566 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400538:	06c00793          	li	a5,108
  40053c:	04f68263          	beq	a3,a5,400580 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400540:	07500793          	li	a5,117
  400544:	0af68063          	beq	a3,a5,4005e4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400548:	07800793          	li	a5,120
  40054c:	0ef68263          	beq	a3,a5,400630 <vprintf+0x1d2>
        putc(fd, '%');
  400550:	02500593          	li	a1,37
  400554:	855a                	mv	a0,s6
  400556:	e55ff0ef          	jal	4003aa <putc>
        putc(fd, c0);
  40055a:	85a6                	mv	a1,s1
  40055c:	855a                	mv	a0,s6
  40055e:	e4dff0ef          	jal	4003aa <putc>
      state = 0;
  400562:	4981                	li	s3,0
  400564:	b791                	j	4004a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400566:	008b8493          	addi	s1,s7,8
  40056a:	4685                	li	a3,1
  40056c:	4629                	li	a2,10
  40056e:	000ba583          	lw	a1,0(s7)
  400572:	855a                	mv	a0,s6
  400574:	e55ff0ef          	jal	4003c8 <printint>
        i += 1;
  400578:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  40057a:	8ba6                	mv	s7,s1
      state = 0;
  40057c:	4981                	li	s3,0
        i += 1;
  40057e:	b72d                	j	4004a8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400580:	06400793          	li	a5,100
  400584:	02f60763          	beq	a2,a5,4005b2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400588:	07500793          	li	a5,117
  40058c:	06f60963          	beq	a2,a5,4005fe <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  400590:	07800793          	li	a5,120
  400594:	faf61ee3          	bne	a2,a5,400550 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400598:	008b8493          	addi	s1,s7,8
  40059c:	4681                	li	a3,0
  40059e:	4641                	li	a2,16
  4005a0:	000ba583          	lw	a1,0(s7)
  4005a4:	855a                	mv	a0,s6
  4005a6:	e23ff0ef          	jal	4003c8 <printint>
        i += 2;
  4005aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005ac:	8ba6                	mv	s7,s1
      state = 0;
  4005ae:	4981                	li	s3,0
        i += 2;
  4005b0:	bde5                	j	4004a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005b2:	008b8493          	addi	s1,s7,8
  4005b6:	4685                	li	a3,1
  4005b8:	4629                	li	a2,10
  4005ba:	000ba583          	lw	a1,0(s7)
  4005be:	855a                	mv	a0,s6
  4005c0:	e09ff0ef          	jal	4003c8 <printint>
        i += 2;
  4005c4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005c6:	8ba6                	mv	s7,s1
      state = 0;
  4005c8:	4981                	li	s3,0
        i += 2;
  4005ca:	bdf9                	j	4004a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4005cc:	008b8493          	addi	s1,s7,8
  4005d0:	4681                	li	a3,0
  4005d2:	4629                	li	a2,10
  4005d4:	000ba583          	lw	a1,0(s7)
  4005d8:	855a                	mv	a0,s6
  4005da:	defff0ef          	jal	4003c8 <printint>
  4005de:	8ba6                	mv	s7,s1
      state = 0;
  4005e0:	4981                	li	s3,0
  4005e2:	b5d9                	j	4004a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005e4:	008b8493          	addi	s1,s7,8
  4005e8:	4681                	li	a3,0
  4005ea:	4629                	li	a2,10
  4005ec:	000ba583          	lw	a1,0(s7)
  4005f0:	855a                	mv	a0,s6
  4005f2:	dd7ff0ef          	jal	4003c8 <printint>
        i += 1;
  4005f6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005f8:	8ba6                	mv	s7,s1
      state = 0;
  4005fa:	4981                	li	s3,0
        i += 1;
  4005fc:	b575                	j	4004a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005fe:	008b8493          	addi	s1,s7,8
  400602:	4681                	li	a3,0
  400604:	4629                	li	a2,10
  400606:	000ba583          	lw	a1,0(s7)
  40060a:	855a                	mv	a0,s6
  40060c:	dbdff0ef          	jal	4003c8 <printint>
        i += 2;
  400610:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400612:	8ba6                	mv	s7,s1
      state = 0;
  400614:	4981                	li	s3,0
        i += 2;
  400616:	bd49                	j	4004a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400618:	008b8493          	addi	s1,s7,8
  40061c:	4681                	li	a3,0
  40061e:	4641                	li	a2,16
  400620:	000ba583          	lw	a1,0(s7)
  400624:	855a                	mv	a0,s6
  400626:	da3ff0ef          	jal	4003c8 <printint>
  40062a:	8ba6                	mv	s7,s1
      state = 0;
  40062c:	4981                	li	s3,0
  40062e:	bdad                	j	4004a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400630:	008b8493          	addi	s1,s7,8
  400634:	4681                	li	a3,0
  400636:	4641                	li	a2,16
  400638:	000ba583          	lw	a1,0(s7)
  40063c:	855a                	mv	a0,s6
  40063e:	d8bff0ef          	jal	4003c8 <printint>
        i += 1;
  400642:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400644:	8ba6                	mv	s7,s1
      state = 0;
  400646:	4981                	li	s3,0
        i += 1;
  400648:	b585                	j	4004a8 <vprintf+0x4a>
  40064a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  40064c:	008b8d13          	addi	s10,s7,8
  400650:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400654:	03000593          	li	a1,48
  400658:	855a                	mv	a0,s6
  40065a:	d51ff0ef          	jal	4003aa <putc>
  putc(fd, 'x');
  40065e:	07800593          	li	a1,120
  400662:	855a                	mv	a0,s6
  400664:	d47ff0ef          	jal	4003aa <putc>
  400668:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  40066a:	00000b97          	auipc	s7,0x0
  40066e:	276b8b93          	addi	s7,s7,630 # 4008e0 <digits>
  400672:	03c9d793          	srli	a5,s3,0x3c
  400676:	97de                	add	a5,a5,s7
  400678:	0007c583          	lbu	a1,0(a5)
  40067c:	855a                	mv	a0,s6
  40067e:	d2dff0ef          	jal	4003aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400682:	0992                	slli	s3,s3,0x4
  400684:	34fd                	addiw	s1,s1,-1
  400686:	f4f5                	bnez	s1,400672 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400688:	8bea                	mv	s7,s10
      state = 0;
  40068a:	4981                	li	s3,0
  40068c:	6d02                	ld	s10,0(sp)
  40068e:	bd29                	j	4004a8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  400690:	008b8993          	addi	s3,s7,8
  400694:	000bb483          	ld	s1,0(s7)
  400698:	cc91                	beqz	s1,4006b4 <vprintf+0x256>
        for(; *s; s++)
  40069a:	0004c583          	lbu	a1,0(s1)
  40069e:	c195                	beqz	a1,4006c2 <vprintf+0x264>
          putc(fd, *s);
  4006a0:	855a                	mv	a0,s6
  4006a2:	d09ff0ef          	jal	4003aa <putc>
        for(; *s; s++)
  4006a6:	0485                	addi	s1,s1,1
  4006a8:	0004c583          	lbu	a1,0(s1)
  4006ac:	f9f5                	bnez	a1,4006a0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006ae:	8bce                	mv	s7,s3
      state = 0;
  4006b0:	4981                	li	s3,0
  4006b2:	bbdd                	j	4004a8 <vprintf+0x4a>
          s = "(null)";
  4006b4:	00000497          	auipc	s1,0x0
  4006b8:	22448493          	addi	s1,s1,548 # 4008d8 <malloc+0x110>
        for(; *s; s++)
  4006bc:	02800593          	li	a1,40
  4006c0:	b7c5                	j	4006a0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006c2:	8bce                	mv	s7,s3
      state = 0;
  4006c4:	4981                	li	s3,0
  4006c6:	b3cd                	j	4004a8 <vprintf+0x4a>
  4006c8:	6906                	ld	s2,64(sp)
  4006ca:	79e2                	ld	s3,56(sp)
  4006cc:	7a42                	ld	s4,48(sp)
  4006ce:	7aa2                	ld	s5,40(sp)
  4006d0:	7b02                	ld	s6,32(sp)
  4006d2:	6be2                	ld	s7,24(sp)
  4006d4:	6c42                	ld	s8,16(sp)
  4006d6:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4006d8:	60e6                	ld	ra,88(sp)
  4006da:	6446                	ld	s0,80(sp)
  4006dc:	64a6                	ld	s1,72(sp)
  4006de:	6125                	addi	sp,sp,96
  4006e0:	8082                	ret

00000000004006e2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4006e2:	715d                	addi	sp,sp,-80
  4006e4:	ec06                	sd	ra,24(sp)
  4006e6:	e822                	sd	s0,16(sp)
  4006e8:	1000                	addi	s0,sp,32
  4006ea:	e010                	sd	a2,0(s0)
  4006ec:	e414                	sd	a3,8(s0)
  4006ee:	e818                	sd	a4,16(s0)
  4006f0:	ec1c                	sd	a5,24(s0)
  4006f2:	03043023          	sd	a6,32(s0)
  4006f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  4006fa:	8622                	mv	a2,s0
  4006fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400700:	d5fff0ef          	jal	40045e <vprintf>
  return 0;
}
  400704:	4501                	li	a0,0
  400706:	60e2                	ld	ra,24(sp)
  400708:	6442                	ld	s0,16(sp)
  40070a:	6161                	addi	sp,sp,80
  40070c:	8082                	ret

000000000040070e <printf>:

int
printf(const char *fmt, ...)
{
  40070e:	711d                	addi	sp,sp,-96
  400710:	ec06                	sd	ra,24(sp)
  400712:	e822                	sd	s0,16(sp)
  400714:	1000                	addi	s0,sp,32
  400716:	e40c                	sd	a1,8(s0)
  400718:	e810                	sd	a2,16(s0)
  40071a:	ec14                	sd	a3,24(s0)
  40071c:	f018                	sd	a4,32(s0)
  40071e:	f41c                	sd	a5,40(s0)
  400720:	03043823          	sd	a6,48(s0)
  400724:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400728:	00840613          	addi	a2,s0,8
  40072c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400730:	85aa                	mv	a1,a0
  400732:	4505                	li	a0,1
  400734:	d2bff0ef          	jal	40045e <vprintf>
  return 0;
}
  400738:	4501                	li	a0,0
  40073a:	60e2                	ld	ra,24(sp)
  40073c:	6442                	ld	s0,16(sp)
  40073e:	6125                	addi	sp,sp,96
  400740:	8082                	ret

0000000000400742 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  400742:	1141                	addi	sp,sp,-16
  400744:	e406                	sd	ra,8(sp)
  400746:	e022                	sd	s0,0(sp)
  400748:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  40074a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40074e:	00001797          	auipc	a5,0x1
  400752:	8b27b783          	ld	a5,-1870(a5) # 401000 <freep>
  400756:	a02d                	j	400780 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400758:	4618                	lw	a4,8(a2)
  40075a:	9f2d                	addw	a4,a4,a1
  40075c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400760:	6398                	ld	a4,0(a5)
  400762:	6310                	ld	a2,0(a4)
  400764:	a83d                	j	4007a2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400766:	ff852703          	lw	a4,-8(a0)
  40076a:	9f31                	addw	a4,a4,a2
  40076c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  40076e:	ff053683          	ld	a3,-16(a0)
  400772:	a091                	j	4007b6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400774:	6398                	ld	a4,0(a5)
  400776:	00e7e463          	bltu	a5,a4,40077e <free+0x3c>
  40077a:	00e6ea63          	bltu	a3,a4,40078e <free+0x4c>
{
  40077e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400780:	fed7fae3          	bgeu	a5,a3,400774 <free+0x32>
  400784:	6398                	ld	a4,0(a5)
  400786:	00e6e463          	bltu	a3,a4,40078e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40078a:	fee7eae3          	bltu	a5,a4,40077e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  40078e:	ff852583          	lw	a1,-8(a0)
  400792:	6390                	ld	a2,0(a5)
  400794:	02059813          	slli	a6,a1,0x20
  400798:	01c85713          	srli	a4,a6,0x1c
  40079c:	9736                	add	a4,a4,a3
  40079e:	fae60de3          	beq	a2,a4,400758 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4007a2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4007a6:	4790                	lw	a2,8(a5)
  4007a8:	02061593          	slli	a1,a2,0x20
  4007ac:	01c5d713          	srli	a4,a1,0x1c
  4007b0:	973e                	add	a4,a4,a5
  4007b2:	fae68ae3          	beq	a3,a4,400766 <free+0x24>
    p->s.ptr = bp->s.ptr;
  4007b6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4007b8:	00001717          	auipc	a4,0x1
  4007bc:	84f73423          	sd	a5,-1976(a4) # 401000 <freep>
}
  4007c0:	60a2                	ld	ra,8(sp)
  4007c2:	6402                	ld	s0,0(sp)
  4007c4:	0141                	addi	sp,sp,16
  4007c6:	8082                	ret

00000000004007c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4007c8:	7139                	addi	sp,sp,-64
  4007ca:	fc06                	sd	ra,56(sp)
  4007cc:	f822                	sd	s0,48(sp)
  4007ce:	f04a                	sd	s2,32(sp)
  4007d0:	ec4e                	sd	s3,24(sp)
  4007d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4007d4:	02051993          	slli	s3,a0,0x20
  4007d8:	0209d993          	srli	s3,s3,0x20
  4007dc:	09bd                	addi	s3,s3,15
  4007de:	0049d993          	srli	s3,s3,0x4
  4007e2:	2985                	addiw	s3,s3,1
  4007e4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4007e6:	00001517          	auipc	a0,0x1
  4007ea:	81a53503          	ld	a0,-2022(a0) # 401000 <freep>
  4007ee:	c905                	beqz	a0,40081e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4007f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4007f2:	4798                	lw	a4,8(a5)
  4007f4:	09377663          	bgeu	a4,s3,400880 <malloc+0xb8>
  4007f8:	f426                	sd	s1,40(sp)
  4007fa:	e852                	sd	s4,16(sp)
  4007fc:	e456                	sd	s5,8(sp)
  4007fe:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400800:	8a4e                	mv	s4,s3
  400802:	6705                	lui	a4,0x1
  400804:	00e9f363          	bgeu	s3,a4,40080a <malloc+0x42>
  400808:	6a05                	lui	s4,0x1
  40080a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  40080e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  400812:	00000497          	auipc	s1,0x0
  400816:	7ee48493          	addi	s1,s1,2030 # 401000 <freep>
  if(p == (char*)-1)
  40081a:	5afd                	li	s5,-1
  40081c:	a83d                	j	40085a <malloc+0x92>
  40081e:	f426                	sd	s1,40(sp)
  400820:	e852                	sd	s4,16(sp)
  400822:	e456                	sd	s5,8(sp)
  400824:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  400826:	00000797          	auipc	a5,0x0
  40082a:	7ea78793          	addi	a5,a5,2026 # 401010 <base>
  40082e:	00000717          	auipc	a4,0x0
  400832:	7cf73923          	sd	a5,2002(a4) # 401000 <freep>
  400836:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400838:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  40083c:	b7d1                	j	400800 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  40083e:	6398                	ld	a4,0(a5)
  400840:	e118                	sd	a4,0(a0)
  400842:	a899                	j	400898 <malloc+0xd0>
  hp->s.size = nu;
  400844:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400848:	0541                	addi	a0,a0,16
  40084a:	ef9ff0ef          	jal	400742 <free>
  return freep;
  40084e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  400850:	c125                	beqz	a0,4008b0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400852:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400854:	4798                	lw	a4,8(a5)
  400856:	03277163          	bgeu	a4,s2,400878 <malloc+0xb0>
    if(p == freep)
  40085a:	6098                	ld	a4,0(s1)
  40085c:	853e                	mv	a0,a5
  40085e:	fef71ae3          	bne	a4,a5,400852 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400862:	8552                	mv	a0,s4
  400864:	b17ff0ef          	jal	40037a <sbrk>
  if(p == (char*)-1)
  400868:	fd551ee3          	bne	a0,s5,400844 <malloc+0x7c>
        return 0;
  40086c:	4501                	li	a0,0
  40086e:	74a2                	ld	s1,40(sp)
  400870:	6a42                	ld	s4,16(sp)
  400872:	6aa2                	ld	s5,8(sp)
  400874:	6b02                	ld	s6,0(sp)
  400876:	a03d                	j	4008a4 <malloc+0xdc>
  400878:	74a2                	ld	s1,40(sp)
  40087a:	6a42                	ld	s4,16(sp)
  40087c:	6aa2                	ld	s5,8(sp)
  40087e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400880:	fae90fe3          	beq	s2,a4,40083e <malloc+0x76>
        p->s.size -= nunits;
  400884:	4137073b          	subw	a4,a4,s3
  400888:	c798                	sw	a4,8(a5)
        p += p->s.size;
  40088a:	02071693          	slli	a3,a4,0x20
  40088e:	01c6d713          	srli	a4,a3,0x1c
  400892:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  400894:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400898:	00000717          	auipc	a4,0x0
  40089c:	76a73423          	sd	a0,1896(a4) # 401000 <freep>
      return (void*)(p + 1);
  4008a0:	01078513          	addi	a0,a5,16
  }
}
  4008a4:	70e2                	ld	ra,56(sp)
  4008a6:	7442                	ld	s0,48(sp)
  4008a8:	7902                	ld	s2,32(sp)
  4008aa:	69e2                	ld	s3,24(sp)
  4008ac:	6121                	addi	sp,sp,64
  4008ae:	8082                	ret
  4008b0:	74a2                	ld	s1,40(sp)
  4008b2:	6a42                	ld	s4,16(sp)
  4008b4:	6aa2                	ld	s5,8(sp)
  4008b6:	6b02                	ld	s6,0(sp)
  4008b8:	b7f5                	j	4008a4 <malloc+0xdc>
