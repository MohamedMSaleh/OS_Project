
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  400000:	1141                	addi	sp,sp,-16
  400002:	e406                	sd	ra,8(sp)
  400004:	e022                	sd	s0,0(sp)
  400006:	0800                	addi	s0,sp,16
  if(fork() > 0)
  400008:	2ac000ef          	jal	4002b4 <fork>
  40000c:	00a04563          	bgtz	a0,400016 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  400010:	4501                	li	a0,0
  400012:	2aa000ef          	jal	4002bc <exit>
    sleep(5);  // Let child exit before parent.
  400016:	4515                	li	a0,5
  400018:	334000ef          	jal	40034c <sleep>
  40001c:	bfd5                	j	400010 <main+0x10>

000000000040001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  40001e:	1141                	addi	sp,sp,-16
  400020:	e406                	sd	ra,8(sp)
  400022:	e022                	sd	s0,0(sp)
  400024:	0800                	addi	s0,sp,16
  extern int main();
  main();
  400026:	fdbff0ef          	jal	400000 <main>
  exit(0);
  40002a:	4501                	li	a0,0
  40002c:	290000ef          	jal	4002bc <exit>

0000000000400030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400030:	1141                	addi	sp,sp,-16
  400032:	e406                	sd	ra,8(sp)
  400034:	e022                	sd	s0,0(sp)
  400036:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400038:	87aa                	mv	a5,a0
  40003a:	0585                	addi	a1,a1,1
  40003c:	0785                	addi	a5,a5,1
  40003e:	fff5c703          	lbu	a4,-1(a1)
  400042:	fee78fa3          	sb	a4,-1(a5)
  400046:	fb75                	bnez	a4,40003a <strcpy+0xa>
    ;
  return os;
}
  400048:	60a2                	ld	ra,8(sp)
  40004a:	6402                	ld	s0,0(sp)
  40004c:	0141                	addi	sp,sp,16
  40004e:	8082                	ret

0000000000400050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400050:	1141                	addi	sp,sp,-16
  400052:	e406                	sd	ra,8(sp)
  400054:	e022                	sd	s0,0(sp)
  400056:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  400058:	00054783          	lbu	a5,0(a0)
  40005c:	cb91                	beqz	a5,400070 <strcmp+0x20>
  40005e:	0005c703          	lbu	a4,0(a1)
  400062:	00f71763          	bne	a4,a5,400070 <strcmp+0x20>
    p++, q++;
  400066:	0505                	addi	a0,a0,1
  400068:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  40006a:	00054783          	lbu	a5,0(a0)
  40006e:	fbe5                	bnez	a5,40005e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  400070:	0005c503          	lbu	a0,0(a1)
}
  400074:	40a7853b          	subw	a0,a5,a0
  400078:	60a2                	ld	ra,8(sp)
  40007a:	6402                	ld	s0,0(sp)
  40007c:	0141                	addi	sp,sp,16
  40007e:	8082                	ret

0000000000400080 <strlen>:

uint
strlen(const char *s)
{
  400080:	1141                	addi	sp,sp,-16
  400082:	e406                	sd	ra,8(sp)
  400084:	e022                	sd	s0,0(sp)
  400086:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  400088:	00054783          	lbu	a5,0(a0)
  40008c:	cf99                	beqz	a5,4000aa <strlen+0x2a>
  40008e:	0505                	addi	a0,a0,1
  400090:	87aa                	mv	a5,a0
  400092:	86be                	mv	a3,a5
  400094:	0785                	addi	a5,a5,1
  400096:	fff7c703          	lbu	a4,-1(a5)
  40009a:	ff65                	bnez	a4,400092 <strlen+0x12>
  40009c:	40a6853b          	subw	a0,a3,a0
  4000a0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4000a2:	60a2                	ld	ra,8(sp)
  4000a4:	6402                	ld	s0,0(sp)
  4000a6:	0141                	addi	sp,sp,16
  4000a8:	8082                	ret
  for(n = 0; s[n]; n++)
  4000aa:	4501                	li	a0,0
  4000ac:	bfdd                	j	4000a2 <strlen+0x22>

00000000004000ae <memset>:

void*
memset(void *dst, int c, uint n)
{
  4000ae:	1141                	addi	sp,sp,-16
  4000b0:	e406                	sd	ra,8(sp)
  4000b2:	e022                	sd	s0,0(sp)
  4000b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  4000b6:	ca19                	beqz	a2,4000cc <memset+0x1e>
  4000b8:	87aa                	mv	a5,a0
  4000ba:	1602                	slli	a2,a2,0x20
  4000bc:	9201                	srli	a2,a2,0x20
  4000be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  4000c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  4000c6:	0785                	addi	a5,a5,1
  4000c8:	fee79de3          	bne	a5,a4,4000c2 <memset+0x14>
  }
  return dst;
}
  4000cc:	60a2                	ld	ra,8(sp)
  4000ce:	6402                	ld	s0,0(sp)
  4000d0:	0141                	addi	sp,sp,16
  4000d2:	8082                	ret

00000000004000d4 <strchr>:

char*
strchr(const char *s, char c)
{
  4000d4:	1141                	addi	sp,sp,-16
  4000d6:	e406                	sd	ra,8(sp)
  4000d8:	e022                	sd	s0,0(sp)
  4000da:	0800                	addi	s0,sp,16
  for(; *s; s++)
  4000dc:	00054783          	lbu	a5,0(a0)
  4000e0:	cf81                	beqz	a5,4000f8 <strchr+0x24>
    if(*s == c)
  4000e2:	00f58763          	beq	a1,a5,4000f0 <strchr+0x1c>
  for(; *s; s++)
  4000e6:	0505                	addi	a0,a0,1
  4000e8:	00054783          	lbu	a5,0(a0)
  4000ec:	fbfd                	bnez	a5,4000e2 <strchr+0xe>
      return (char*)s;
  return 0;
  4000ee:	4501                	li	a0,0
}
  4000f0:	60a2                	ld	ra,8(sp)
  4000f2:	6402                	ld	s0,0(sp)
  4000f4:	0141                	addi	sp,sp,16
  4000f6:	8082                	ret
  return 0;
  4000f8:	4501                	li	a0,0
  4000fa:	bfdd                	j	4000f0 <strchr+0x1c>

00000000004000fc <gets>:

char*
gets(char *buf, int max)
{
  4000fc:	7159                	addi	sp,sp,-112
  4000fe:	f486                	sd	ra,104(sp)
  400100:	f0a2                	sd	s0,96(sp)
  400102:	eca6                	sd	s1,88(sp)
  400104:	e8ca                	sd	s2,80(sp)
  400106:	e4ce                	sd	s3,72(sp)
  400108:	e0d2                	sd	s4,64(sp)
  40010a:	fc56                	sd	s5,56(sp)
  40010c:	f85a                	sd	s6,48(sp)
  40010e:	f45e                	sd	s7,40(sp)
  400110:	f062                	sd	s8,32(sp)
  400112:	ec66                	sd	s9,24(sp)
  400114:	e86a                	sd	s10,16(sp)
  400116:	1880                	addi	s0,sp,112
  400118:	8caa                	mv	s9,a0
  40011a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  40011c:	892a                	mv	s2,a0
  40011e:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400120:	f9f40b13          	addi	s6,s0,-97
  400124:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400126:	4ba9                	li	s7,10
  400128:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  40012a:	8d26                	mv	s10,s1
  40012c:	0014899b          	addiw	s3,s1,1
  400130:	84ce                	mv	s1,s3
  400132:	0349d563          	bge	s3,s4,40015c <gets+0x60>
    cc = read(0, &c, 1);
  400136:	8656                	mv	a2,s5
  400138:	85da                	mv	a1,s6
  40013a:	4501                	li	a0,0
  40013c:	198000ef          	jal	4002d4 <read>
    if(cc < 1)
  400140:	00a05e63          	blez	a0,40015c <gets+0x60>
    buf[i++] = c;
  400144:	f9f44783          	lbu	a5,-97(s0)
  400148:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  40014c:	01778763          	beq	a5,s7,40015a <gets+0x5e>
  400150:	0905                	addi	s2,s2,1
  400152:	fd879ce3          	bne	a5,s8,40012a <gets+0x2e>
    buf[i++] = c;
  400156:	8d4e                	mv	s10,s3
  400158:	a011                	j	40015c <gets+0x60>
  40015a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  40015c:	9d66                	add	s10,s10,s9
  40015e:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400162:	8566                	mv	a0,s9
  400164:	70a6                	ld	ra,104(sp)
  400166:	7406                	ld	s0,96(sp)
  400168:	64e6                	ld	s1,88(sp)
  40016a:	6946                	ld	s2,80(sp)
  40016c:	69a6                	ld	s3,72(sp)
  40016e:	6a06                	ld	s4,64(sp)
  400170:	7ae2                	ld	s5,56(sp)
  400172:	7b42                	ld	s6,48(sp)
  400174:	7ba2                	ld	s7,40(sp)
  400176:	7c02                	ld	s8,32(sp)
  400178:	6ce2                	ld	s9,24(sp)
  40017a:	6d42                	ld	s10,16(sp)
  40017c:	6165                	addi	sp,sp,112
  40017e:	8082                	ret

0000000000400180 <stat>:

int
stat(const char *n, struct stat *st)
{
  400180:	1101                	addi	sp,sp,-32
  400182:	ec06                	sd	ra,24(sp)
  400184:	e822                	sd	s0,16(sp)
  400186:	e04a                	sd	s2,0(sp)
  400188:	1000                	addi	s0,sp,32
  40018a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  40018c:	4581                	li	a1,0
  40018e:	16e000ef          	jal	4002fc <open>
  if(fd < 0)
  400192:	02054263          	bltz	a0,4001b6 <stat+0x36>
  400196:	e426                	sd	s1,8(sp)
  400198:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  40019a:	85ca                	mv	a1,s2
  40019c:	178000ef          	jal	400314 <fstat>
  4001a0:	892a                	mv	s2,a0
  close(fd);
  4001a2:	8526                	mv	a0,s1
  4001a4:	140000ef          	jal	4002e4 <close>
  return r;
  4001a8:	64a2                	ld	s1,8(sp)
}
  4001aa:	854a                	mv	a0,s2
  4001ac:	60e2                	ld	ra,24(sp)
  4001ae:	6442                	ld	s0,16(sp)
  4001b0:	6902                	ld	s2,0(sp)
  4001b2:	6105                	addi	sp,sp,32
  4001b4:	8082                	ret
    return -1;
  4001b6:	597d                	li	s2,-1
  4001b8:	bfcd                	j	4001aa <stat+0x2a>

00000000004001ba <atoi>:

int
atoi(const char *s)
{
  4001ba:	1141                	addi	sp,sp,-16
  4001bc:	e406                	sd	ra,8(sp)
  4001be:	e022                	sd	s0,0(sp)
  4001c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  4001c2:	00054683          	lbu	a3,0(a0)
  4001c6:	fd06879b          	addiw	a5,a3,-48
  4001ca:	0ff7f793          	zext.b	a5,a5
  4001ce:	4625                	li	a2,9
  4001d0:	02f66963          	bltu	a2,a5,400202 <atoi+0x48>
  4001d4:	872a                	mv	a4,a0
  n = 0;
  4001d6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  4001d8:	0705                	addi	a4,a4,1
  4001da:	0025179b          	slliw	a5,a0,0x2
  4001de:	9fa9                	addw	a5,a5,a0
  4001e0:	0017979b          	slliw	a5,a5,0x1
  4001e4:	9fb5                	addw	a5,a5,a3
  4001e6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  4001ea:	00074683          	lbu	a3,0(a4)
  4001ee:	fd06879b          	addiw	a5,a3,-48
  4001f2:	0ff7f793          	zext.b	a5,a5
  4001f6:	fef671e3          	bgeu	a2,a5,4001d8 <atoi+0x1e>
  return n;
}
  4001fa:	60a2                	ld	ra,8(sp)
  4001fc:	6402                	ld	s0,0(sp)
  4001fe:	0141                	addi	sp,sp,16
  400200:	8082                	ret
  n = 0;
  400202:	4501                	li	a0,0
  400204:	bfdd                	j	4001fa <atoi+0x40>

0000000000400206 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400206:	1141                	addi	sp,sp,-16
  400208:	e406                	sd	ra,8(sp)
  40020a:	e022                	sd	s0,0(sp)
  40020c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  40020e:	02b57563          	bgeu	a0,a1,400238 <memmove+0x32>
    while(n-- > 0)
  400212:	00c05f63          	blez	a2,400230 <memmove+0x2a>
  400216:	1602                	slli	a2,a2,0x20
  400218:	9201                	srli	a2,a2,0x20
  40021a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  40021e:	872a                	mv	a4,a0
      *dst++ = *src++;
  400220:	0585                	addi	a1,a1,1
  400222:	0705                	addi	a4,a4,1
  400224:	fff5c683          	lbu	a3,-1(a1)
  400228:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  40022c:	fee79ae3          	bne	a5,a4,400220 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400230:	60a2                	ld	ra,8(sp)
  400232:	6402                	ld	s0,0(sp)
  400234:	0141                	addi	sp,sp,16
  400236:	8082                	ret
    dst += n;
  400238:	00c50733          	add	a4,a0,a2
    src += n;
  40023c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  40023e:	fec059e3          	blez	a2,400230 <memmove+0x2a>
  400242:	fff6079b          	addiw	a5,a2,-1
  400246:	1782                	slli	a5,a5,0x20
  400248:	9381                	srli	a5,a5,0x20
  40024a:	fff7c793          	not	a5,a5
  40024e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400250:	15fd                	addi	a1,a1,-1
  400252:	177d                	addi	a4,a4,-1
  400254:	0005c683          	lbu	a3,0(a1)
  400258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  40025c:	fef71ae3          	bne	a4,a5,400250 <memmove+0x4a>
  400260:	bfc1                	j	400230 <memmove+0x2a>

0000000000400262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400262:	1141                	addi	sp,sp,-16
  400264:	e406                	sd	ra,8(sp)
  400266:	e022                	sd	s0,0(sp)
  400268:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  40026a:	ca0d                	beqz	a2,40029c <memcmp+0x3a>
  40026c:	fff6069b          	addiw	a3,a2,-1
  400270:	1682                	slli	a3,a3,0x20
  400272:	9281                	srli	a3,a3,0x20
  400274:	0685                	addi	a3,a3,1
  400276:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  400278:	00054783          	lbu	a5,0(a0)
  40027c:	0005c703          	lbu	a4,0(a1)
  400280:	00e79863          	bne	a5,a4,400290 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  400284:	0505                	addi	a0,a0,1
    p2++;
  400286:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  400288:	fed518e3          	bne	a0,a3,400278 <memcmp+0x16>
  }
  return 0;
  40028c:	4501                	li	a0,0
  40028e:	a019                	j	400294 <memcmp+0x32>
      return *p1 - *p2;
  400290:	40e7853b          	subw	a0,a5,a4
}
  400294:	60a2                	ld	ra,8(sp)
  400296:	6402                	ld	s0,0(sp)
  400298:	0141                	addi	sp,sp,16
  40029a:	8082                	ret
  return 0;
  40029c:	4501                	li	a0,0
  40029e:	bfdd                	j	400294 <memcmp+0x32>

00000000004002a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4002a0:	1141                	addi	sp,sp,-16
  4002a2:	e406                	sd	ra,8(sp)
  4002a4:	e022                	sd	s0,0(sp)
  4002a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4002a8:	f5fff0ef          	jal	400206 <memmove>
}
  4002ac:	60a2                	ld	ra,8(sp)
  4002ae:	6402                	ld	s0,0(sp)
  4002b0:	0141                	addi	sp,sp,16
  4002b2:	8082                	ret

00000000004002b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  4002b4:	4885                	li	a7,1
 ecall
  4002b6:	00000073          	ecall
 ret
  4002ba:	8082                	ret

00000000004002bc <exit>:
.global exit
exit:
 li a7, SYS_exit
  4002bc:	4889                	li	a7,2
 ecall
  4002be:	00000073          	ecall
 ret
  4002c2:	8082                	ret

00000000004002c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
  4002c4:	488d                	li	a7,3
 ecall
  4002c6:	00000073          	ecall
 ret
  4002ca:	8082                	ret

00000000004002cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  4002cc:	4891                	li	a7,4
 ecall
  4002ce:	00000073          	ecall
 ret
  4002d2:	8082                	ret

00000000004002d4 <read>:
.global read
read:
 li a7, SYS_read
  4002d4:	4895                	li	a7,5
 ecall
  4002d6:	00000073          	ecall
 ret
  4002da:	8082                	ret

00000000004002dc <write>:
.global write
write:
 li a7, SYS_write
  4002dc:	48c1                	li	a7,16
 ecall
  4002de:	00000073          	ecall
 ret
  4002e2:	8082                	ret

00000000004002e4 <close>:
.global close
close:
 li a7, SYS_close
  4002e4:	48d5                	li	a7,21
 ecall
  4002e6:	00000073          	ecall
 ret
  4002ea:	8082                	ret

00000000004002ec <kill>:
.global kill
kill:
 li a7, SYS_kill
  4002ec:	4899                	li	a7,6
 ecall
  4002ee:	00000073          	ecall
 ret
  4002f2:	8082                	ret

00000000004002f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
  4002f4:	489d                	li	a7,7
 ecall
  4002f6:	00000073          	ecall
 ret
  4002fa:	8082                	ret

00000000004002fc <open>:
.global open
open:
 li a7, SYS_open
  4002fc:	48bd                	li	a7,15
 ecall
  4002fe:	00000073          	ecall
 ret
  400302:	8082                	ret

0000000000400304 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400304:	48c5                	li	a7,17
 ecall
  400306:	00000073          	ecall
 ret
  40030a:	8082                	ret

000000000040030c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  40030c:	48c9                	li	a7,18
 ecall
  40030e:	00000073          	ecall
 ret
  400312:	8082                	ret

0000000000400314 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  400314:	48a1                	li	a7,8
 ecall
  400316:	00000073          	ecall
 ret
  40031a:	8082                	ret

000000000040031c <link>:
.global link
link:
 li a7, SYS_link
  40031c:	48cd                	li	a7,19
 ecall
  40031e:	00000073          	ecall
 ret
  400322:	8082                	ret

0000000000400324 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400324:	48d1                	li	a7,20
 ecall
  400326:	00000073          	ecall
 ret
  40032a:	8082                	ret

000000000040032c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  40032c:	48a5                	li	a7,9
 ecall
  40032e:	00000073          	ecall
 ret
  400332:	8082                	ret

0000000000400334 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400334:	48a9                	li	a7,10
 ecall
  400336:	00000073          	ecall
 ret
  40033a:	8082                	ret

000000000040033c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  40033c:	48ad                	li	a7,11
 ecall
  40033e:	00000073          	ecall
 ret
  400342:	8082                	ret

0000000000400344 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  400344:	48b1                	li	a7,12
 ecall
  400346:	00000073          	ecall
 ret
  40034a:	8082                	ret

000000000040034c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  40034c:	48b5                	li	a7,13
 ecall
  40034e:	00000073          	ecall
 ret
  400352:	8082                	ret

0000000000400354 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  400354:	48b9                	li	a7,14
 ecall
  400356:	00000073          	ecall
 ret
  40035a:	8082                	ret

000000000040035c <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  40035c:	48d9                	li	a7,22
 ecall
  40035e:	00000073          	ecall
 ret
  400362:	8082                	ret

0000000000400364 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  400364:	48dd                	li	a7,23
 ecall
  400366:	00000073          	ecall
 ret
  40036a:	8082                	ret

000000000040036c <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  40036c:	48e1                	li	a7,24
 ecall
  40036e:	00000073          	ecall
 ret
  400372:	8082                	ret

0000000000400374 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  400374:	1101                	addi	sp,sp,-32
  400376:	ec06                	sd	ra,24(sp)
  400378:	e822                	sd	s0,16(sp)
  40037a:	1000                	addi	s0,sp,32
  40037c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  400380:	4605                	li	a2,1
  400382:	fef40593          	addi	a1,s0,-17
  400386:	f57ff0ef          	jal	4002dc <write>
}
  40038a:	60e2                	ld	ra,24(sp)
  40038c:	6442                	ld	s0,16(sp)
  40038e:	6105                	addi	sp,sp,32
  400390:	8082                	ret

0000000000400392 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  400392:	7139                	addi	sp,sp,-64
  400394:	fc06                	sd	ra,56(sp)
  400396:	f822                	sd	s0,48(sp)
  400398:	f426                	sd	s1,40(sp)
  40039a:	f04a                	sd	s2,32(sp)
  40039c:	ec4e                	sd	s3,24(sp)
  40039e:	0080                	addi	s0,sp,64
  4003a0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4003a2:	c299                	beqz	a3,4003a8 <printint+0x16>
  4003a4:	0605ce63          	bltz	a1,400420 <printint+0x8e>
  neg = 0;
  4003a8:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4003aa:	fc040313          	addi	t1,s0,-64
  neg = 0;
  4003ae:	869a                	mv	a3,t1
  i = 0;
  4003b0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  4003b2:	00000817          	auipc	a6,0x0
  4003b6:	4e680813          	addi	a6,a6,1254 # 400898 <digits>
  4003ba:	88be                	mv	a7,a5
  4003bc:	0017851b          	addiw	a0,a5,1
  4003c0:	87aa                	mv	a5,a0
  4003c2:	02c5f73b          	remuw	a4,a1,a2
  4003c6:	1702                	slli	a4,a4,0x20
  4003c8:	9301                	srli	a4,a4,0x20
  4003ca:	9742                	add	a4,a4,a6
  4003cc:	00074703          	lbu	a4,0(a4)
  4003d0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  4003d4:	872e                	mv	a4,a1
  4003d6:	02c5d5bb          	divuw	a1,a1,a2
  4003da:	0685                	addi	a3,a3,1
  4003dc:	fcc77fe3          	bgeu	a4,a2,4003ba <printint+0x28>
  if(neg)
  4003e0:	000e0c63          	beqz	t3,4003f8 <printint+0x66>
    buf[i++] = '-';
  4003e4:	fd050793          	addi	a5,a0,-48
  4003e8:	00878533          	add	a0,a5,s0
  4003ec:	02d00793          	li	a5,45
  4003f0:	fef50823          	sb	a5,-16(a0)
  4003f4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  4003f8:	fff7899b          	addiw	s3,a5,-1
  4003fc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400400:	fff4c583          	lbu	a1,-1(s1)
  400404:	854a                	mv	a0,s2
  400406:	f6fff0ef          	jal	400374 <putc>
  while(--i >= 0)
  40040a:	39fd                	addiw	s3,s3,-1
  40040c:	14fd                	addi	s1,s1,-1
  40040e:	fe09d9e3          	bgez	s3,400400 <printint+0x6e>
}
  400412:	70e2                	ld	ra,56(sp)
  400414:	7442                	ld	s0,48(sp)
  400416:	74a2                	ld	s1,40(sp)
  400418:	7902                	ld	s2,32(sp)
  40041a:	69e2                	ld	s3,24(sp)
  40041c:	6121                	addi	sp,sp,64
  40041e:	8082                	ret
    x = -xx;
  400420:	40b005bb          	negw	a1,a1
    neg = 1;
  400424:	4e05                	li	t3,1
    x = -xx;
  400426:	b751                	j	4003aa <printint+0x18>

0000000000400428 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400428:	711d                	addi	sp,sp,-96
  40042a:	ec86                	sd	ra,88(sp)
  40042c:	e8a2                	sd	s0,80(sp)
  40042e:	e4a6                	sd	s1,72(sp)
  400430:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400432:	0005c483          	lbu	s1,0(a1)
  400436:	26048663          	beqz	s1,4006a2 <vprintf+0x27a>
  40043a:	e0ca                	sd	s2,64(sp)
  40043c:	fc4e                	sd	s3,56(sp)
  40043e:	f852                	sd	s4,48(sp)
  400440:	f456                	sd	s5,40(sp)
  400442:	f05a                	sd	s6,32(sp)
  400444:	ec5e                	sd	s7,24(sp)
  400446:	e862                	sd	s8,16(sp)
  400448:	e466                	sd	s9,8(sp)
  40044a:	8b2a                	mv	s6,a0
  40044c:	8a2e                	mv	s4,a1
  40044e:	8bb2                	mv	s7,a2
  state = 0;
  400450:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400452:	4901                	li	s2,0
  400454:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  400456:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  40045a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  40045e:	06c00c93          	li	s9,108
  400462:	a00d                	j	400484 <vprintf+0x5c>
        putc(fd, c0);
  400464:	85a6                	mv	a1,s1
  400466:	855a                	mv	a0,s6
  400468:	f0dff0ef          	jal	400374 <putc>
  40046c:	a019                	j	400472 <vprintf+0x4a>
    } else if(state == '%'){
  40046e:	03598363          	beq	s3,s5,400494 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  400472:	0019079b          	addiw	a5,s2,1
  400476:	893e                	mv	s2,a5
  400478:	873e                	mv	a4,a5
  40047a:	97d2                	add	a5,a5,s4
  40047c:	0007c483          	lbu	s1,0(a5)
  400480:	20048963          	beqz	s1,400692 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  400484:	0004879b          	sext.w	a5,s1
    if(state == 0){
  400488:	fe0993e3          	bnez	s3,40046e <vprintf+0x46>
      if(c0 == '%'){
  40048c:	fd579ce3          	bne	a5,s5,400464 <vprintf+0x3c>
        state = '%';
  400490:	89be                	mv	s3,a5
  400492:	b7c5                	j	400472 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  400494:	00ea06b3          	add	a3,s4,a4
  400498:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  40049c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  40049e:	c681                	beqz	a3,4004a6 <vprintf+0x7e>
  4004a0:	9752                	add	a4,a4,s4
  4004a2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4004a6:	03878e63          	beq	a5,s8,4004e2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4004aa:	05978863          	beq	a5,s9,4004fa <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  4004ae:	07500713          	li	a4,117
  4004b2:	0ee78263          	beq	a5,a4,400596 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  4004b6:	07800713          	li	a4,120
  4004ba:	12e78463          	beq	a5,a4,4005e2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  4004be:	07000713          	li	a4,112
  4004c2:	14e78963          	beq	a5,a4,400614 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  4004c6:	07300713          	li	a4,115
  4004ca:	18e78863          	beq	a5,a4,40065a <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  4004ce:	02500713          	li	a4,37
  4004d2:	04e79463          	bne	a5,a4,40051a <vprintf+0xf2>
        putc(fd, '%');
  4004d6:	85ba                	mv	a1,a4
  4004d8:	855a                	mv	a0,s6
  4004da:	e9bff0ef          	jal	400374 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  4004de:	4981                	li	s3,0
  4004e0:	bf49                	j	400472 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  4004e2:	008b8493          	addi	s1,s7,8
  4004e6:	4685                	li	a3,1
  4004e8:	4629                	li	a2,10
  4004ea:	000ba583          	lw	a1,0(s7)
  4004ee:	855a                	mv	a0,s6
  4004f0:	ea3ff0ef          	jal	400392 <printint>
  4004f4:	8ba6                	mv	s7,s1
      state = 0;
  4004f6:	4981                	li	s3,0
  4004f8:	bfad                	j	400472 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  4004fa:	06400793          	li	a5,100
  4004fe:	02f68963          	beq	a3,a5,400530 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400502:	06c00793          	li	a5,108
  400506:	04f68263          	beq	a3,a5,40054a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  40050a:	07500793          	li	a5,117
  40050e:	0af68063          	beq	a3,a5,4005ae <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400512:	07800793          	li	a5,120
  400516:	0ef68263          	beq	a3,a5,4005fa <vprintf+0x1d2>
        putc(fd, '%');
  40051a:	02500593          	li	a1,37
  40051e:	855a                	mv	a0,s6
  400520:	e55ff0ef          	jal	400374 <putc>
        putc(fd, c0);
  400524:	85a6                	mv	a1,s1
  400526:	855a                	mv	a0,s6
  400528:	e4dff0ef          	jal	400374 <putc>
      state = 0;
  40052c:	4981                	li	s3,0
  40052e:	b791                	j	400472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400530:	008b8493          	addi	s1,s7,8
  400534:	4685                	li	a3,1
  400536:	4629                	li	a2,10
  400538:	000ba583          	lw	a1,0(s7)
  40053c:	855a                	mv	a0,s6
  40053e:	e55ff0ef          	jal	400392 <printint>
        i += 1;
  400542:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  400544:	8ba6                	mv	s7,s1
      state = 0;
  400546:	4981                	li	s3,0
        i += 1;
  400548:	b72d                	j	400472 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  40054a:	06400793          	li	a5,100
  40054e:	02f60763          	beq	a2,a5,40057c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400552:	07500793          	li	a5,117
  400556:	06f60963          	beq	a2,a5,4005c8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  40055a:	07800793          	li	a5,120
  40055e:	faf61ee3          	bne	a2,a5,40051a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400562:	008b8493          	addi	s1,s7,8
  400566:	4681                	li	a3,0
  400568:	4641                	li	a2,16
  40056a:	000ba583          	lw	a1,0(s7)
  40056e:	855a                	mv	a0,s6
  400570:	e23ff0ef          	jal	400392 <printint>
        i += 2;
  400574:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  400576:	8ba6                	mv	s7,s1
      state = 0;
  400578:	4981                	li	s3,0
        i += 2;
  40057a:	bde5                	j	400472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  40057c:	008b8493          	addi	s1,s7,8
  400580:	4685                	li	a3,1
  400582:	4629                	li	a2,10
  400584:	000ba583          	lw	a1,0(s7)
  400588:	855a                	mv	a0,s6
  40058a:	e09ff0ef          	jal	400392 <printint>
        i += 2;
  40058e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  400590:	8ba6                	mv	s7,s1
      state = 0;
  400592:	4981                	li	s3,0
        i += 2;
  400594:	bdf9                	j	400472 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  400596:	008b8493          	addi	s1,s7,8
  40059a:	4681                	li	a3,0
  40059c:	4629                	li	a2,10
  40059e:	000ba583          	lw	a1,0(s7)
  4005a2:	855a                	mv	a0,s6
  4005a4:	defff0ef          	jal	400392 <printint>
  4005a8:	8ba6                	mv	s7,s1
      state = 0;
  4005aa:	4981                	li	s3,0
  4005ac:	b5d9                	j	400472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005ae:	008b8493          	addi	s1,s7,8
  4005b2:	4681                	li	a3,0
  4005b4:	4629                	li	a2,10
  4005b6:	000ba583          	lw	a1,0(s7)
  4005ba:	855a                	mv	a0,s6
  4005bc:	dd7ff0ef          	jal	400392 <printint>
        i += 1;
  4005c0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005c2:	8ba6                	mv	s7,s1
      state = 0;
  4005c4:	4981                	li	s3,0
        i += 1;
  4005c6:	b575                	j	400472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005c8:	008b8493          	addi	s1,s7,8
  4005cc:	4681                	li	a3,0
  4005ce:	4629                	li	a2,10
  4005d0:	000ba583          	lw	a1,0(s7)
  4005d4:	855a                	mv	a0,s6
  4005d6:	dbdff0ef          	jal	400392 <printint>
        i += 2;
  4005da:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005dc:	8ba6                	mv	s7,s1
      state = 0;
  4005de:	4981                	li	s3,0
        i += 2;
  4005e0:	bd49                	j	400472 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  4005e2:	008b8493          	addi	s1,s7,8
  4005e6:	4681                	li	a3,0
  4005e8:	4641                	li	a2,16
  4005ea:	000ba583          	lw	a1,0(s7)
  4005ee:	855a                	mv	a0,s6
  4005f0:	da3ff0ef          	jal	400392 <printint>
  4005f4:	8ba6                	mv	s7,s1
      state = 0;
  4005f6:	4981                	li	s3,0
  4005f8:	bdad                	j	400472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005fa:	008b8493          	addi	s1,s7,8
  4005fe:	4681                	li	a3,0
  400600:	4641                	li	a2,16
  400602:	000ba583          	lw	a1,0(s7)
  400606:	855a                	mv	a0,s6
  400608:	d8bff0ef          	jal	400392 <printint>
        i += 1;
  40060c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  40060e:	8ba6                	mv	s7,s1
      state = 0;
  400610:	4981                	li	s3,0
        i += 1;
  400612:	b585                	j	400472 <vprintf+0x4a>
  400614:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  400616:	008b8d13          	addi	s10,s7,8
  40061a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  40061e:	03000593          	li	a1,48
  400622:	855a                	mv	a0,s6
  400624:	d51ff0ef          	jal	400374 <putc>
  putc(fd, 'x');
  400628:	07800593          	li	a1,120
  40062c:	855a                	mv	a0,s6
  40062e:	d47ff0ef          	jal	400374 <putc>
  400632:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400634:	00000b97          	auipc	s7,0x0
  400638:	264b8b93          	addi	s7,s7,612 # 400898 <digits>
  40063c:	03c9d793          	srli	a5,s3,0x3c
  400640:	97de                	add	a5,a5,s7
  400642:	0007c583          	lbu	a1,0(a5)
  400646:	855a                	mv	a0,s6
  400648:	d2dff0ef          	jal	400374 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  40064c:	0992                	slli	s3,s3,0x4
  40064e:	34fd                	addiw	s1,s1,-1
  400650:	f4f5                	bnez	s1,40063c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400652:	8bea                	mv	s7,s10
      state = 0;
  400654:	4981                	li	s3,0
  400656:	6d02                	ld	s10,0(sp)
  400658:	bd29                	j	400472 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  40065a:	008b8993          	addi	s3,s7,8
  40065e:	000bb483          	ld	s1,0(s7)
  400662:	cc91                	beqz	s1,40067e <vprintf+0x256>
        for(; *s; s++)
  400664:	0004c583          	lbu	a1,0(s1)
  400668:	c195                	beqz	a1,40068c <vprintf+0x264>
          putc(fd, *s);
  40066a:	855a                	mv	a0,s6
  40066c:	d09ff0ef          	jal	400374 <putc>
        for(; *s; s++)
  400670:	0485                	addi	s1,s1,1
  400672:	0004c583          	lbu	a1,0(s1)
  400676:	f9f5                	bnez	a1,40066a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400678:	8bce                	mv	s7,s3
      state = 0;
  40067a:	4981                	li	s3,0
  40067c:	bbdd                	j	400472 <vprintf+0x4a>
          s = "(null)";
  40067e:	00000497          	auipc	s1,0x0
  400682:	21248493          	addi	s1,s1,530 # 400890 <malloc+0xfe>
        for(; *s; s++)
  400686:	02800593          	li	a1,40
  40068a:	b7c5                	j	40066a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  40068c:	8bce                	mv	s7,s3
      state = 0;
  40068e:	4981                	li	s3,0
  400690:	b3cd                	j	400472 <vprintf+0x4a>
  400692:	6906                	ld	s2,64(sp)
  400694:	79e2                	ld	s3,56(sp)
  400696:	7a42                	ld	s4,48(sp)
  400698:	7aa2                	ld	s5,40(sp)
  40069a:	7b02                	ld	s6,32(sp)
  40069c:	6be2                	ld	s7,24(sp)
  40069e:	6c42                	ld	s8,16(sp)
  4006a0:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4006a2:	60e6                	ld	ra,88(sp)
  4006a4:	6446                	ld	s0,80(sp)
  4006a6:	64a6                	ld	s1,72(sp)
  4006a8:	6125                	addi	sp,sp,96
  4006aa:	8082                	ret

00000000004006ac <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4006ac:	715d                	addi	sp,sp,-80
  4006ae:	ec06                	sd	ra,24(sp)
  4006b0:	e822                	sd	s0,16(sp)
  4006b2:	1000                	addi	s0,sp,32
  4006b4:	e010                	sd	a2,0(s0)
  4006b6:	e414                	sd	a3,8(s0)
  4006b8:	e818                	sd	a4,16(s0)
  4006ba:	ec1c                	sd	a5,24(s0)
  4006bc:	03043023          	sd	a6,32(s0)
  4006c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  4006c4:	8622                	mv	a2,s0
  4006c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  4006ca:	d5fff0ef          	jal	400428 <vprintf>
  return 0;
}
  4006ce:	4501                	li	a0,0
  4006d0:	60e2                	ld	ra,24(sp)
  4006d2:	6442                	ld	s0,16(sp)
  4006d4:	6161                	addi	sp,sp,80
  4006d6:	8082                	ret

00000000004006d8 <printf>:

int
printf(const char *fmt, ...)
{
  4006d8:	711d                	addi	sp,sp,-96
  4006da:	ec06                	sd	ra,24(sp)
  4006dc:	e822                	sd	s0,16(sp)
  4006de:	1000                	addi	s0,sp,32
  4006e0:	e40c                	sd	a1,8(s0)
  4006e2:	e810                	sd	a2,16(s0)
  4006e4:	ec14                	sd	a3,24(s0)
  4006e6:	f018                	sd	a4,32(s0)
  4006e8:	f41c                	sd	a5,40(s0)
  4006ea:	03043823          	sd	a6,48(s0)
  4006ee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  4006f2:	00840613          	addi	a2,s0,8
  4006f6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  4006fa:	85aa                	mv	a1,a0
  4006fc:	4505                	li	a0,1
  4006fe:	d2bff0ef          	jal	400428 <vprintf>
  return 0;
}
  400702:	4501                	li	a0,0
  400704:	60e2                	ld	ra,24(sp)
  400706:	6442                	ld	s0,16(sp)
  400708:	6125                	addi	sp,sp,96
  40070a:	8082                	ret

000000000040070c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  40070c:	1141                	addi	sp,sp,-16
  40070e:	e406                	sd	ra,8(sp)
  400710:	e022                	sd	s0,0(sp)
  400712:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  400714:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400718:	00001797          	auipc	a5,0x1
  40071c:	8e87b783          	ld	a5,-1816(a5) # 401000 <freep>
  400720:	a02d                	j	40074a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400722:	4618                	lw	a4,8(a2)
  400724:	9f2d                	addw	a4,a4,a1
  400726:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  40072a:	6398                	ld	a4,0(a5)
  40072c:	6310                	ld	a2,0(a4)
  40072e:	a83d                	j	40076c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400730:	ff852703          	lw	a4,-8(a0)
  400734:	9f31                	addw	a4,a4,a2
  400736:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400738:	ff053683          	ld	a3,-16(a0)
  40073c:	a091                	j	400780 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40073e:	6398                	ld	a4,0(a5)
  400740:	00e7e463          	bltu	a5,a4,400748 <free+0x3c>
  400744:	00e6ea63          	bltu	a3,a4,400758 <free+0x4c>
{
  400748:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40074a:	fed7fae3          	bgeu	a5,a3,40073e <free+0x32>
  40074e:	6398                	ld	a4,0(a5)
  400750:	00e6e463          	bltu	a3,a4,400758 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400754:	fee7eae3          	bltu	a5,a4,400748 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  400758:	ff852583          	lw	a1,-8(a0)
  40075c:	6390                	ld	a2,0(a5)
  40075e:	02059813          	slli	a6,a1,0x20
  400762:	01c85713          	srli	a4,a6,0x1c
  400766:	9736                	add	a4,a4,a3
  400768:	fae60de3          	beq	a2,a4,400722 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  40076c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  400770:	4790                	lw	a2,8(a5)
  400772:	02061593          	slli	a1,a2,0x20
  400776:	01c5d713          	srli	a4,a1,0x1c
  40077a:	973e                	add	a4,a4,a5
  40077c:	fae68ae3          	beq	a3,a4,400730 <free+0x24>
    p->s.ptr = bp->s.ptr;
  400780:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  400782:	00001717          	auipc	a4,0x1
  400786:	86f73f23          	sd	a5,-1922(a4) # 401000 <freep>
}
  40078a:	60a2                	ld	ra,8(sp)
  40078c:	6402                	ld	s0,0(sp)
  40078e:	0141                	addi	sp,sp,16
  400790:	8082                	ret

0000000000400792 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  400792:	7139                	addi	sp,sp,-64
  400794:	fc06                	sd	ra,56(sp)
  400796:	f822                	sd	s0,48(sp)
  400798:	f04a                	sd	s2,32(sp)
  40079a:	ec4e                	sd	s3,24(sp)
  40079c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  40079e:	02051993          	slli	s3,a0,0x20
  4007a2:	0209d993          	srli	s3,s3,0x20
  4007a6:	09bd                	addi	s3,s3,15
  4007a8:	0049d993          	srli	s3,s3,0x4
  4007ac:	2985                	addiw	s3,s3,1
  4007ae:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4007b0:	00001517          	auipc	a0,0x1
  4007b4:	85053503          	ld	a0,-1968(a0) # 401000 <freep>
  4007b8:	c905                	beqz	a0,4007e8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4007ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4007bc:	4798                	lw	a4,8(a5)
  4007be:	09377663          	bgeu	a4,s3,40084a <malloc+0xb8>
  4007c2:	f426                	sd	s1,40(sp)
  4007c4:	e852                	sd	s4,16(sp)
  4007c6:	e456                	sd	s5,8(sp)
  4007c8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  4007ca:	8a4e                	mv	s4,s3
  4007cc:	6705                	lui	a4,0x1
  4007ce:	00e9f363          	bgeu	s3,a4,4007d4 <malloc+0x42>
  4007d2:	6a05                	lui	s4,0x1
  4007d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  4007d8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  4007dc:	00001497          	auipc	s1,0x1
  4007e0:	82448493          	addi	s1,s1,-2012 # 401000 <freep>
  if(p == (char*)-1)
  4007e4:	5afd                	li	s5,-1
  4007e6:	a83d                	j	400824 <malloc+0x92>
  4007e8:	f426                	sd	s1,40(sp)
  4007ea:	e852                	sd	s4,16(sp)
  4007ec:	e456                	sd	s5,8(sp)
  4007ee:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  4007f0:	00001797          	auipc	a5,0x1
  4007f4:	82078793          	addi	a5,a5,-2016 # 401010 <base>
  4007f8:	00001717          	auipc	a4,0x1
  4007fc:	80f73423          	sd	a5,-2040(a4) # 401000 <freep>
  400800:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400802:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  400806:	b7d1                	j	4007ca <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400808:	6398                	ld	a4,0(a5)
  40080a:	e118                	sd	a4,0(a0)
  40080c:	a899                	j	400862 <malloc+0xd0>
  hp->s.size = nu;
  40080e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400812:	0541                	addi	a0,a0,16
  400814:	ef9ff0ef          	jal	40070c <free>
  return freep;
  400818:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  40081a:	c125                	beqz	a0,40087a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  40081c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40081e:	4798                	lw	a4,8(a5)
  400820:	03277163          	bgeu	a4,s2,400842 <malloc+0xb0>
    if(p == freep)
  400824:	6098                	ld	a4,0(s1)
  400826:	853e                	mv	a0,a5
  400828:	fef71ae3          	bne	a4,a5,40081c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  40082c:	8552                	mv	a0,s4
  40082e:	b17ff0ef          	jal	400344 <sbrk>
  if(p == (char*)-1)
  400832:	fd551ee3          	bne	a0,s5,40080e <malloc+0x7c>
        return 0;
  400836:	4501                	li	a0,0
  400838:	74a2                	ld	s1,40(sp)
  40083a:	6a42                	ld	s4,16(sp)
  40083c:	6aa2                	ld	s5,8(sp)
  40083e:	6b02                	ld	s6,0(sp)
  400840:	a03d                	j	40086e <malloc+0xdc>
  400842:	74a2                	ld	s1,40(sp)
  400844:	6a42                	ld	s4,16(sp)
  400846:	6aa2                	ld	s5,8(sp)
  400848:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  40084a:	fae90fe3          	beq	s2,a4,400808 <malloc+0x76>
        p->s.size -= nunits;
  40084e:	4137073b          	subw	a4,a4,s3
  400852:	c798                	sw	a4,8(a5)
        p += p->s.size;
  400854:	02071693          	slli	a3,a4,0x20
  400858:	01c6d713          	srli	a4,a3,0x1c
  40085c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  40085e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400862:	00000717          	auipc	a4,0x0
  400866:	78a73f23          	sd	a0,1950(a4) # 401000 <freep>
      return (void*)(p + 1);
  40086a:	01078513          	addi	a0,a5,16
  }
}
  40086e:	70e2                	ld	ra,56(sp)
  400870:	7442                	ld	s0,48(sp)
  400872:	7902                	ld	s2,32(sp)
  400874:	69e2                	ld	s3,24(sp)
  400876:	6121                	addi	sp,sp,64
  400878:	8082                	ret
  40087a:	74a2                	ld	s1,40(sp)
  40087c:	6a42                	ld	s4,16(sp)
  40087e:	6aa2                	ld	s5,8(sp)
  400880:	6b02                	ld	s6,0(sp)
  400882:	b7f5                	j	40086e <malloc+0xdc>
