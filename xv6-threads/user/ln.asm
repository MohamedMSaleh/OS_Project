
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  400000:	1101                	addi	sp,sp,-32
  400002:	ec06                	sd	ra,24(sp)
  400004:	e822                	sd	s0,16(sp)
  400006:	1000                	addi	s0,sp,32
  if(argc != 3){
  400008:	478d                	li	a5,3
  40000a:	00f50d63          	beq	a0,a5,400024 <main+0x24>
  40000e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  400010:	00001597          	auipc	a1,0x1
  400014:	8b058593          	addi	a1,a1,-1872 # 4008c0 <malloc+0xfe>
  400018:	4509                	li	a0,2
  40001a:	6c2000ef          	jal	4006dc <fprintf>
    exit(1);
  40001e:	4505                	li	a0,1
  400020:	2cc000ef          	jal	4002ec <exit>
  400024:	e426                	sd	s1,8(sp)
  400026:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  400028:	698c                	ld	a1,16(a1)
  40002a:	6488                	ld	a0,8(s1)
  40002c:	320000ef          	jal	40034c <link>
  400030:	00054563          	bltz	a0,40003a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  400034:	4501                	li	a0,0
  400036:	2b6000ef          	jal	4002ec <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  40003a:	6894                	ld	a3,16(s1)
  40003c:	6490                	ld	a2,8(s1)
  40003e:	00001597          	auipc	a1,0x1
  400042:	89a58593          	addi	a1,a1,-1894 # 4008d8 <malloc+0x116>
  400046:	4509                	li	a0,2
  400048:	694000ef          	jal	4006dc <fprintf>
  40004c:	b7e5                	j	400034 <main+0x34>

000000000040004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  40004e:	1141                	addi	sp,sp,-16
  400050:	e406                	sd	ra,8(sp)
  400052:	e022                	sd	s0,0(sp)
  400054:	0800                	addi	s0,sp,16
  extern int main();
  main();
  400056:	fabff0ef          	jal	400000 <main>
  exit(0);
  40005a:	4501                	li	a0,0
  40005c:	290000ef          	jal	4002ec <exit>

0000000000400060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400060:	1141                	addi	sp,sp,-16
  400062:	e406                	sd	ra,8(sp)
  400064:	e022                	sd	s0,0(sp)
  400066:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400068:	87aa                	mv	a5,a0
  40006a:	0585                	addi	a1,a1,1
  40006c:	0785                	addi	a5,a5,1
  40006e:	fff5c703          	lbu	a4,-1(a1)
  400072:	fee78fa3          	sb	a4,-1(a5)
  400076:	fb75                	bnez	a4,40006a <strcpy+0xa>
    ;
  return os;
}
  400078:	60a2                	ld	ra,8(sp)
  40007a:	6402                	ld	s0,0(sp)
  40007c:	0141                	addi	sp,sp,16
  40007e:	8082                	ret

0000000000400080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400080:	1141                	addi	sp,sp,-16
  400082:	e406                	sd	ra,8(sp)
  400084:	e022                	sd	s0,0(sp)
  400086:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  400088:	00054783          	lbu	a5,0(a0)
  40008c:	cb91                	beqz	a5,4000a0 <strcmp+0x20>
  40008e:	0005c703          	lbu	a4,0(a1)
  400092:	00f71763          	bne	a4,a5,4000a0 <strcmp+0x20>
    p++, q++;
  400096:	0505                	addi	a0,a0,1
  400098:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  40009a:	00054783          	lbu	a5,0(a0)
  40009e:	fbe5                	bnez	a5,40008e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4000a0:	0005c503          	lbu	a0,0(a1)
}
  4000a4:	40a7853b          	subw	a0,a5,a0
  4000a8:	60a2                	ld	ra,8(sp)
  4000aa:	6402                	ld	s0,0(sp)
  4000ac:	0141                	addi	sp,sp,16
  4000ae:	8082                	ret

00000000004000b0 <strlen>:

uint
strlen(const char *s)
{
  4000b0:	1141                	addi	sp,sp,-16
  4000b2:	e406                	sd	ra,8(sp)
  4000b4:	e022                	sd	s0,0(sp)
  4000b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4000b8:	00054783          	lbu	a5,0(a0)
  4000bc:	cf99                	beqz	a5,4000da <strlen+0x2a>
  4000be:	0505                	addi	a0,a0,1
  4000c0:	87aa                	mv	a5,a0
  4000c2:	86be                	mv	a3,a5
  4000c4:	0785                	addi	a5,a5,1
  4000c6:	fff7c703          	lbu	a4,-1(a5)
  4000ca:	ff65                	bnez	a4,4000c2 <strlen+0x12>
  4000cc:	40a6853b          	subw	a0,a3,a0
  4000d0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4000d2:	60a2                	ld	ra,8(sp)
  4000d4:	6402                	ld	s0,0(sp)
  4000d6:	0141                	addi	sp,sp,16
  4000d8:	8082                	ret
  for(n = 0; s[n]; n++)
  4000da:	4501                	li	a0,0
  4000dc:	bfdd                	j	4000d2 <strlen+0x22>

00000000004000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  4000de:	1141                	addi	sp,sp,-16
  4000e0:	e406                	sd	ra,8(sp)
  4000e2:	e022                	sd	s0,0(sp)
  4000e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  4000e6:	ca19                	beqz	a2,4000fc <memset+0x1e>
  4000e8:	87aa                	mv	a5,a0
  4000ea:	1602                	slli	a2,a2,0x20
  4000ec:	9201                	srli	a2,a2,0x20
  4000ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  4000f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  4000f6:	0785                	addi	a5,a5,1
  4000f8:	fee79de3          	bne	a5,a4,4000f2 <memset+0x14>
  }
  return dst;
}
  4000fc:	60a2                	ld	ra,8(sp)
  4000fe:	6402                	ld	s0,0(sp)
  400100:	0141                	addi	sp,sp,16
  400102:	8082                	ret

0000000000400104 <strchr>:

char*
strchr(const char *s, char c)
{
  400104:	1141                	addi	sp,sp,-16
  400106:	e406                	sd	ra,8(sp)
  400108:	e022                	sd	s0,0(sp)
  40010a:	0800                	addi	s0,sp,16
  for(; *s; s++)
  40010c:	00054783          	lbu	a5,0(a0)
  400110:	cf81                	beqz	a5,400128 <strchr+0x24>
    if(*s == c)
  400112:	00f58763          	beq	a1,a5,400120 <strchr+0x1c>
  for(; *s; s++)
  400116:	0505                	addi	a0,a0,1
  400118:	00054783          	lbu	a5,0(a0)
  40011c:	fbfd                	bnez	a5,400112 <strchr+0xe>
      return (char*)s;
  return 0;
  40011e:	4501                	li	a0,0
}
  400120:	60a2                	ld	ra,8(sp)
  400122:	6402                	ld	s0,0(sp)
  400124:	0141                	addi	sp,sp,16
  400126:	8082                	ret
  return 0;
  400128:	4501                	li	a0,0
  40012a:	bfdd                	j	400120 <strchr+0x1c>

000000000040012c <gets>:

char*
gets(char *buf, int max)
{
  40012c:	7159                	addi	sp,sp,-112
  40012e:	f486                	sd	ra,104(sp)
  400130:	f0a2                	sd	s0,96(sp)
  400132:	eca6                	sd	s1,88(sp)
  400134:	e8ca                	sd	s2,80(sp)
  400136:	e4ce                	sd	s3,72(sp)
  400138:	e0d2                	sd	s4,64(sp)
  40013a:	fc56                	sd	s5,56(sp)
  40013c:	f85a                	sd	s6,48(sp)
  40013e:	f45e                	sd	s7,40(sp)
  400140:	f062                	sd	s8,32(sp)
  400142:	ec66                	sd	s9,24(sp)
  400144:	e86a                	sd	s10,16(sp)
  400146:	1880                	addi	s0,sp,112
  400148:	8caa                	mv	s9,a0
  40014a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  40014c:	892a                	mv	s2,a0
  40014e:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400150:	f9f40b13          	addi	s6,s0,-97
  400154:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400156:	4ba9                	li	s7,10
  400158:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  40015a:	8d26                	mv	s10,s1
  40015c:	0014899b          	addiw	s3,s1,1
  400160:	84ce                	mv	s1,s3
  400162:	0349d563          	bge	s3,s4,40018c <gets+0x60>
    cc = read(0, &c, 1);
  400166:	8656                	mv	a2,s5
  400168:	85da                	mv	a1,s6
  40016a:	4501                	li	a0,0
  40016c:	198000ef          	jal	400304 <read>
    if(cc < 1)
  400170:	00a05e63          	blez	a0,40018c <gets+0x60>
    buf[i++] = c;
  400174:	f9f44783          	lbu	a5,-97(s0)
  400178:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  40017c:	01778763          	beq	a5,s7,40018a <gets+0x5e>
  400180:	0905                	addi	s2,s2,1
  400182:	fd879ce3          	bne	a5,s8,40015a <gets+0x2e>
    buf[i++] = c;
  400186:	8d4e                	mv	s10,s3
  400188:	a011                	j	40018c <gets+0x60>
  40018a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  40018c:	9d66                	add	s10,s10,s9
  40018e:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400192:	8566                	mv	a0,s9
  400194:	70a6                	ld	ra,104(sp)
  400196:	7406                	ld	s0,96(sp)
  400198:	64e6                	ld	s1,88(sp)
  40019a:	6946                	ld	s2,80(sp)
  40019c:	69a6                	ld	s3,72(sp)
  40019e:	6a06                	ld	s4,64(sp)
  4001a0:	7ae2                	ld	s5,56(sp)
  4001a2:	7b42                	ld	s6,48(sp)
  4001a4:	7ba2                	ld	s7,40(sp)
  4001a6:	7c02                	ld	s8,32(sp)
  4001a8:	6ce2                	ld	s9,24(sp)
  4001aa:	6d42                	ld	s10,16(sp)
  4001ac:	6165                	addi	sp,sp,112
  4001ae:	8082                	ret

00000000004001b0 <stat>:

int
stat(const char *n, struct stat *st)
{
  4001b0:	1101                	addi	sp,sp,-32
  4001b2:	ec06                	sd	ra,24(sp)
  4001b4:	e822                	sd	s0,16(sp)
  4001b6:	e04a                	sd	s2,0(sp)
  4001b8:	1000                	addi	s0,sp,32
  4001ba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4001bc:	4581                	li	a1,0
  4001be:	16e000ef          	jal	40032c <open>
  if(fd < 0)
  4001c2:	02054263          	bltz	a0,4001e6 <stat+0x36>
  4001c6:	e426                	sd	s1,8(sp)
  4001c8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4001ca:	85ca                	mv	a1,s2
  4001cc:	178000ef          	jal	400344 <fstat>
  4001d0:	892a                	mv	s2,a0
  close(fd);
  4001d2:	8526                	mv	a0,s1
  4001d4:	140000ef          	jal	400314 <close>
  return r;
  4001d8:	64a2                	ld	s1,8(sp)
}
  4001da:	854a                	mv	a0,s2
  4001dc:	60e2                	ld	ra,24(sp)
  4001de:	6442                	ld	s0,16(sp)
  4001e0:	6902                	ld	s2,0(sp)
  4001e2:	6105                	addi	sp,sp,32
  4001e4:	8082                	ret
    return -1;
  4001e6:	597d                	li	s2,-1
  4001e8:	bfcd                	j	4001da <stat+0x2a>

00000000004001ea <atoi>:

int
atoi(const char *s)
{
  4001ea:	1141                	addi	sp,sp,-16
  4001ec:	e406                	sd	ra,8(sp)
  4001ee:	e022                	sd	s0,0(sp)
  4001f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  4001f2:	00054683          	lbu	a3,0(a0)
  4001f6:	fd06879b          	addiw	a5,a3,-48
  4001fa:	0ff7f793          	zext.b	a5,a5
  4001fe:	4625                	li	a2,9
  400200:	02f66963          	bltu	a2,a5,400232 <atoi+0x48>
  400204:	872a                	mv	a4,a0
  n = 0;
  400206:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400208:	0705                	addi	a4,a4,1
  40020a:	0025179b          	slliw	a5,a0,0x2
  40020e:	9fa9                	addw	a5,a5,a0
  400210:	0017979b          	slliw	a5,a5,0x1
  400214:	9fb5                	addw	a5,a5,a3
  400216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  40021a:	00074683          	lbu	a3,0(a4)
  40021e:	fd06879b          	addiw	a5,a3,-48
  400222:	0ff7f793          	zext.b	a5,a5
  400226:	fef671e3          	bgeu	a2,a5,400208 <atoi+0x1e>
  return n;
}
  40022a:	60a2                	ld	ra,8(sp)
  40022c:	6402                	ld	s0,0(sp)
  40022e:	0141                	addi	sp,sp,16
  400230:	8082                	ret
  n = 0;
  400232:	4501                	li	a0,0
  400234:	bfdd                	j	40022a <atoi+0x40>

0000000000400236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400236:	1141                	addi	sp,sp,-16
  400238:	e406                	sd	ra,8(sp)
  40023a:	e022                	sd	s0,0(sp)
  40023c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  40023e:	02b57563          	bgeu	a0,a1,400268 <memmove+0x32>
    while(n-- > 0)
  400242:	00c05f63          	blez	a2,400260 <memmove+0x2a>
  400246:	1602                	slli	a2,a2,0x20
  400248:	9201                	srli	a2,a2,0x20
  40024a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  40024e:	872a                	mv	a4,a0
      *dst++ = *src++;
  400250:	0585                	addi	a1,a1,1
  400252:	0705                	addi	a4,a4,1
  400254:	fff5c683          	lbu	a3,-1(a1)
  400258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  40025c:	fee79ae3          	bne	a5,a4,400250 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400260:	60a2                	ld	ra,8(sp)
  400262:	6402                	ld	s0,0(sp)
  400264:	0141                	addi	sp,sp,16
  400266:	8082                	ret
    dst += n;
  400268:	00c50733          	add	a4,a0,a2
    src += n;
  40026c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  40026e:	fec059e3          	blez	a2,400260 <memmove+0x2a>
  400272:	fff6079b          	addiw	a5,a2,-1
  400276:	1782                	slli	a5,a5,0x20
  400278:	9381                	srli	a5,a5,0x20
  40027a:	fff7c793          	not	a5,a5
  40027e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400280:	15fd                	addi	a1,a1,-1
  400282:	177d                	addi	a4,a4,-1
  400284:	0005c683          	lbu	a3,0(a1)
  400288:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  40028c:	fef71ae3          	bne	a4,a5,400280 <memmove+0x4a>
  400290:	bfc1                	j	400260 <memmove+0x2a>

0000000000400292 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400292:	1141                	addi	sp,sp,-16
  400294:	e406                	sd	ra,8(sp)
  400296:	e022                	sd	s0,0(sp)
  400298:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  40029a:	ca0d                	beqz	a2,4002cc <memcmp+0x3a>
  40029c:	fff6069b          	addiw	a3,a2,-1
  4002a0:	1682                	slli	a3,a3,0x20
  4002a2:	9281                	srli	a3,a3,0x20
  4002a4:	0685                	addi	a3,a3,1
  4002a6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4002a8:	00054783          	lbu	a5,0(a0)
  4002ac:	0005c703          	lbu	a4,0(a1)
  4002b0:	00e79863          	bne	a5,a4,4002c0 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4002b4:	0505                	addi	a0,a0,1
    p2++;
  4002b6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4002b8:	fed518e3          	bne	a0,a3,4002a8 <memcmp+0x16>
  }
  return 0;
  4002bc:	4501                	li	a0,0
  4002be:	a019                	j	4002c4 <memcmp+0x32>
      return *p1 - *p2;
  4002c0:	40e7853b          	subw	a0,a5,a4
}
  4002c4:	60a2                	ld	ra,8(sp)
  4002c6:	6402                	ld	s0,0(sp)
  4002c8:	0141                	addi	sp,sp,16
  4002ca:	8082                	ret
  return 0;
  4002cc:	4501                	li	a0,0
  4002ce:	bfdd                	j	4002c4 <memcmp+0x32>

00000000004002d0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4002d0:	1141                	addi	sp,sp,-16
  4002d2:	e406                	sd	ra,8(sp)
  4002d4:	e022                	sd	s0,0(sp)
  4002d6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4002d8:	f5fff0ef          	jal	400236 <memmove>
}
  4002dc:	60a2                	ld	ra,8(sp)
  4002de:	6402                	ld	s0,0(sp)
  4002e0:	0141                	addi	sp,sp,16
  4002e2:	8082                	ret

00000000004002e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  4002e4:	4885                	li	a7,1
 ecall
  4002e6:	00000073          	ecall
 ret
  4002ea:	8082                	ret

00000000004002ec <exit>:
.global exit
exit:
 li a7, SYS_exit
  4002ec:	4889                	li	a7,2
 ecall
  4002ee:	00000073          	ecall
 ret
  4002f2:	8082                	ret

00000000004002f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
  4002f4:	488d                	li	a7,3
 ecall
  4002f6:	00000073          	ecall
 ret
  4002fa:	8082                	ret

00000000004002fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  4002fc:	4891                	li	a7,4
 ecall
  4002fe:	00000073          	ecall
 ret
  400302:	8082                	ret

0000000000400304 <read>:
.global read
read:
 li a7, SYS_read
  400304:	4895                	li	a7,5
 ecall
  400306:	00000073          	ecall
 ret
  40030a:	8082                	ret

000000000040030c <write>:
.global write
write:
 li a7, SYS_write
  40030c:	48c1                	li	a7,16
 ecall
  40030e:	00000073          	ecall
 ret
  400312:	8082                	ret

0000000000400314 <close>:
.global close
close:
 li a7, SYS_close
  400314:	48d5                	li	a7,21
 ecall
  400316:	00000073          	ecall
 ret
  40031a:	8082                	ret

000000000040031c <kill>:
.global kill
kill:
 li a7, SYS_kill
  40031c:	4899                	li	a7,6
 ecall
  40031e:	00000073          	ecall
 ret
  400322:	8082                	ret

0000000000400324 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400324:	489d                	li	a7,7
 ecall
  400326:	00000073          	ecall
 ret
  40032a:	8082                	ret

000000000040032c <open>:
.global open
open:
 li a7, SYS_open
  40032c:	48bd                	li	a7,15
 ecall
  40032e:	00000073          	ecall
 ret
  400332:	8082                	ret

0000000000400334 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400334:	48c5                	li	a7,17
 ecall
  400336:	00000073          	ecall
 ret
  40033a:	8082                	ret

000000000040033c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  40033c:	48c9                	li	a7,18
 ecall
  40033e:	00000073          	ecall
 ret
  400342:	8082                	ret

0000000000400344 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  400344:	48a1                	li	a7,8
 ecall
  400346:	00000073          	ecall
 ret
  40034a:	8082                	ret

000000000040034c <link>:
.global link
link:
 li a7, SYS_link
  40034c:	48cd                	li	a7,19
 ecall
  40034e:	00000073          	ecall
 ret
  400352:	8082                	ret

0000000000400354 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400354:	48d1                	li	a7,20
 ecall
  400356:	00000073          	ecall
 ret
  40035a:	8082                	ret

000000000040035c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  40035c:	48a5                	li	a7,9
 ecall
  40035e:	00000073          	ecall
 ret
  400362:	8082                	ret

0000000000400364 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400364:	48a9                	li	a7,10
 ecall
  400366:	00000073          	ecall
 ret
  40036a:	8082                	ret

000000000040036c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  40036c:	48ad                	li	a7,11
 ecall
  40036e:	00000073          	ecall
 ret
  400372:	8082                	ret

0000000000400374 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  400374:	48b1                	li	a7,12
 ecall
  400376:	00000073          	ecall
 ret
  40037a:	8082                	ret

000000000040037c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  40037c:	48b5                	li	a7,13
 ecall
  40037e:	00000073          	ecall
 ret
  400382:	8082                	ret

0000000000400384 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  400384:	48b9                	li	a7,14
 ecall
  400386:	00000073          	ecall
 ret
  40038a:	8082                	ret

000000000040038c <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  40038c:	48d9                	li	a7,22
 ecall
  40038e:	00000073          	ecall
 ret
  400392:	8082                	ret

0000000000400394 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  400394:	48dd                	li	a7,23
 ecall
  400396:	00000073          	ecall
 ret
  40039a:	8082                	ret

000000000040039c <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  40039c:	48e1                	li	a7,24
 ecall
  40039e:	00000073          	ecall
 ret
  4003a2:	8082                	ret

00000000004003a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4003a4:	1101                	addi	sp,sp,-32
  4003a6:	ec06                	sd	ra,24(sp)
  4003a8:	e822                	sd	s0,16(sp)
  4003aa:	1000                	addi	s0,sp,32
  4003ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4003b0:	4605                	li	a2,1
  4003b2:	fef40593          	addi	a1,s0,-17
  4003b6:	f57ff0ef          	jal	40030c <write>
}
  4003ba:	60e2                	ld	ra,24(sp)
  4003bc:	6442                	ld	s0,16(sp)
  4003be:	6105                	addi	sp,sp,32
  4003c0:	8082                	ret

00000000004003c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4003c2:	7139                	addi	sp,sp,-64
  4003c4:	fc06                	sd	ra,56(sp)
  4003c6:	f822                	sd	s0,48(sp)
  4003c8:	f426                	sd	s1,40(sp)
  4003ca:	f04a                	sd	s2,32(sp)
  4003cc:	ec4e                	sd	s3,24(sp)
  4003ce:	0080                	addi	s0,sp,64
  4003d0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4003d2:	c299                	beqz	a3,4003d8 <printint+0x16>
  4003d4:	0605ce63          	bltz	a1,400450 <printint+0x8e>
  neg = 0;
  4003d8:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4003da:	fc040313          	addi	t1,s0,-64
  neg = 0;
  4003de:	869a                	mv	a3,t1
  i = 0;
  4003e0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  4003e2:	00000817          	auipc	a6,0x0
  4003e6:	51680813          	addi	a6,a6,1302 # 4008f8 <digits>
  4003ea:	88be                	mv	a7,a5
  4003ec:	0017851b          	addiw	a0,a5,1
  4003f0:	87aa                	mv	a5,a0
  4003f2:	02c5f73b          	remuw	a4,a1,a2
  4003f6:	1702                	slli	a4,a4,0x20
  4003f8:	9301                	srli	a4,a4,0x20
  4003fa:	9742                	add	a4,a4,a6
  4003fc:	00074703          	lbu	a4,0(a4)
  400400:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400404:	872e                	mv	a4,a1
  400406:	02c5d5bb          	divuw	a1,a1,a2
  40040a:	0685                	addi	a3,a3,1
  40040c:	fcc77fe3          	bgeu	a4,a2,4003ea <printint+0x28>
  if(neg)
  400410:	000e0c63          	beqz	t3,400428 <printint+0x66>
    buf[i++] = '-';
  400414:	fd050793          	addi	a5,a0,-48
  400418:	00878533          	add	a0,a5,s0
  40041c:	02d00793          	li	a5,45
  400420:	fef50823          	sb	a5,-16(a0)
  400424:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400428:	fff7899b          	addiw	s3,a5,-1
  40042c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400430:	fff4c583          	lbu	a1,-1(s1)
  400434:	854a                	mv	a0,s2
  400436:	f6fff0ef          	jal	4003a4 <putc>
  while(--i >= 0)
  40043a:	39fd                	addiw	s3,s3,-1
  40043c:	14fd                	addi	s1,s1,-1
  40043e:	fe09d9e3          	bgez	s3,400430 <printint+0x6e>
}
  400442:	70e2                	ld	ra,56(sp)
  400444:	7442                	ld	s0,48(sp)
  400446:	74a2                	ld	s1,40(sp)
  400448:	7902                	ld	s2,32(sp)
  40044a:	69e2                	ld	s3,24(sp)
  40044c:	6121                	addi	sp,sp,64
  40044e:	8082                	ret
    x = -xx;
  400450:	40b005bb          	negw	a1,a1
    neg = 1;
  400454:	4e05                	li	t3,1
    x = -xx;
  400456:	b751                	j	4003da <printint+0x18>

0000000000400458 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400458:	711d                	addi	sp,sp,-96
  40045a:	ec86                	sd	ra,88(sp)
  40045c:	e8a2                	sd	s0,80(sp)
  40045e:	e4a6                	sd	s1,72(sp)
  400460:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400462:	0005c483          	lbu	s1,0(a1)
  400466:	26048663          	beqz	s1,4006d2 <vprintf+0x27a>
  40046a:	e0ca                	sd	s2,64(sp)
  40046c:	fc4e                	sd	s3,56(sp)
  40046e:	f852                	sd	s4,48(sp)
  400470:	f456                	sd	s5,40(sp)
  400472:	f05a                	sd	s6,32(sp)
  400474:	ec5e                	sd	s7,24(sp)
  400476:	e862                	sd	s8,16(sp)
  400478:	e466                	sd	s9,8(sp)
  40047a:	8b2a                	mv	s6,a0
  40047c:	8a2e                	mv	s4,a1
  40047e:	8bb2                	mv	s7,a2
  state = 0;
  400480:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400482:	4901                	li	s2,0
  400484:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  400486:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  40048a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  40048e:	06c00c93          	li	s9,108
  400492:	a00d                	j	4004b4 <vprintf+0x5c>
        putc(fd, c0);
  400494:	85a6                	mv	a1,s1
  400496:	855a                	mv	a0,s6
  400498:	f0dff0ef          	jal	4003a4 <putc>
  40049c:	a019                	j	4004a2 <vprintf+0x4a>
    } else if(state == '%'){
  40049e:	03598363          	beq	s3,s5,4004c4 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4004a2:	0019079b          	addiw	a5,s2,1
  4004a6:	893e                	mv	s2,a5
  4004a8:	873e                	mv	a4,a5
  4004aa:	97d2                	add	a5,a5,s4
  4004ac:	0007c483          	lbu	s1,0(a5)
  4004b0:	20048963          	beqz	s1,4006c2 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4004b4:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4004b8:	fe0993e3          	bnez	s3,40049e <vprintf+0x46>
      if(c0 == '%'){
  4004bc:	fd579ce3          	bne	a5,s5,400494 <vprintf+0x3c>
        state = '%';
  4004c0:	89be                	mv	s3,a5
  4004c2:	b7c5                	j	4004a2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4004c4:	00ea06b3          	add	a3,s4,a4
  4004c8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4004cc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4004ce:	c681                	beqz	a3,4004d6 <vprintf+0x7e>
  4004d0:	9752                	add	a4,a4,s4
  4004d2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4004d6:	03878e63          	beq	a5,s8,400512 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4004da:	05978863          	beq	a5,s9,40052a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  4004de:	07500713          	li	a4,117
  4004e2:	0ee78263          	beq	a5,a4,4005c6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  4004e6:	07800713          	li	a4,120
  4004ea:	12e78463          	beq	a5,a4,400612 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  4004ee:	07000713          	li	a4,112
  4004f2:	14e78963          	beq	a5,a4,400644 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  4004f6:	07300713          	li	a4,115
  4004fa:	18e78863          	beq	a5,a4,40068a <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  4004fe:	02500713          	li	a4,37
  400502:	04e79463          	bne	a5,a4,40054a <vprintf+0xf2>
        putc(fd, '%');
  400506:	85ba                	mv	a1,a4
  400508:	855a                	mv	a0,s6
  40050a:	e9bff0ef          	jal	4003a4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  40050e:	4981                	li	s3,0
  400510:	bf49                	j	4004a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400512:	008b8493          	addi	s1,s7,8
  400516:	4685                	li	a3,1
  400518:	4629                	li	a2,10
  40051a:	000ba583          	lw	a1,0(s7)
  40051e:	855a                	mv	a0,s6
  400520:	ea3ff0ef          	jal	4003c2 <printint>
  400524:	8ba6                	mv	s7,s1
      state = 0;
  400526:	4981                	li	s3,0
  400528:	bfad                	j	4004a2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  40052a:	06400793          	li	a5,100
  40052e:	02f68963          	beq	a3,a5,400560 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400532:	06c00793          	li	a5,108
  400536:	04f68263          	beq	a3,a5,40057a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  40053a:	07500793          	li	a5,117
  40053e:	0af68063          	beq	a3,a5,4005de <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400542:	07800793          	li	a5,120
  400546:	0ef68263          	beq	a3,a5,40062a <vprintf+0x1d2>
        putc(fd, '%');
  40054a:	02500593          	li	a1,37
  40054e:	855a                	mv	a0,s6
  400550:	e55ff0ef          	jal	4003a4 <putc>
        putc(fd, c0);
  400554:	85a6                	mv	a1,s1
  400556:	855a                	mv	a0,s6
  400558:	e4dff0ef          	jal	4003a4 <putc>
      state = 0;
  40055c:	4981                	li	s3,0
  40055e:	b791                	j	4004a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400560:	008b8493          	addi	s1,s7,8
  400564:	4685                	li	a3,1
  400566:	4629                	li	a2,10
  400568:	000ba583          	lw	a1,0(s7)
  40056c:	855a                	mv	a0,s6
  40056e:	e55ff0ef          	jal	4003c2 <printint>
        i += 1;
  400572:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  400574:	8ba6                	mv	s7,s1
      state = 0;
  400576:	4981                	li	s3,0
        i += 1;
  400578:	b72d                	j	4004a2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  40057a:	06400793          	li	a5,100
  40057e:	02f60763          	beq	a2,a5,4005ac <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400582:	07500793          	li	a5,117
  400586:	06f60963          	beq	a2,a5,4005f8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  40058a:	07800793          	li	a5,120
  40058e:	faf61ee3          	bne	a2,a5,40054a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400592:	008b8493          	addi	s1,s7,8
  400596:	4681                	li	a3,0
  400598:	4641                	li	a2,16
  40059a:	000ba583          	lw	a1,0(s7)
  40059e:	855a                	mv	a0,s6
  4005a0:	e23ff0ef          	jal	4003c2 <printint>
        i += 2;
  4005a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005a6:	8ba6                	mv	s7,s1
      state = 0;
  4005a8:	4981                	li	s3,0
        i += 2;
  4005aa:	bde5                	j	4004a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005ac:	008b8493          	addi	s1,s7,8
  4005b0:	4685                	li	a3,1
  4005b2:	4629                	li	a2,10
  4005b4:	000ba583          	lw	a1,0(s7)
  4005b8:	855a                	mv	a0,s6
  4005ba:	e09ff0ef          	jal	4003c2 <printint>
        i += 2;
  4005be:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005c0:	8ba6                	mv	s7,s1
      state = 0;
  4005c2:	4981                	li	s3,0
        i += 2;
  4005c4:	bdf9                	j	4004a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4005c6:	008b8493          	addi	s1,s7,8
  4005ca:	4681                	li	a3,0
  4005cc:	4629                	li	a2,10
  4005ce:	000ba583          	lw	a1,0(s7)
  4005d2:	855a                	mv	a0,s6
  4005d4:	defff0ef          	jal	4003c2 <printint>
  4005d8:	8ba6                	mv	s7,s1
      state = 0;
  4005da:	4981                	li	s3,0
  4005dc:	b5d9                	j	4004a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005de:	008b8493          	addi	s1,s7,8
  4005e2:	4681                	li	a3,0
  4005e4:	4629                	li	a2,10
  4005e6:	000ba583          	lw	a1,0(s7)
  4005ea:	855a                	mv	a0,s6
  4005ec:	dd7ff0ef          	jal	4003c2 <printint>
        i += 1;
  4005f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005f2:	8ba6                	mv	s7,s1
      state = 0;
  4005f4:	4981                	li	s3,0
        i += 1;
  4005f6:	b575                	j	4004a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005f8:	008b8493          	addi	s1,s7,8
  4005fc:	4681                	li	a3,0
  4005fe:	4629                	li	a2,10
  400600:	000ba583          	lw	a1,0(s7)
  400604:	855a                	mv	a0,s6
  400606:	dbdff0ef          	jal	4003c2 <printint>
        i += 2;
  40060a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  40060c:	8ba6                	mv	s7,s1
      state = 0;
  40060e:	4981                	li	s3,0
        i += 2;
  400610:	bd49                	j	4004a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400612:	008b8493          	addi	s1,s7,8
  400616:	4681                	li	a3,0
  400618:	4641                	li	a2,16
  40061a:	000ba583          	lw	a1,0(s7)
  40061e:	855a                	mv	a0,s6
  400620:	da3ff0ef          	jal	4003c2 <printint>
  400624:	8ba6                	mv	s7,s1
      state = 0;
  400626:	4981                	li	s3,0
  400628:	bdad                	j	4004a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  40062a:	008b8493          	addi	s1,s7,8
  40062e:	4681                	li	a3,0
  400630:	4641                	li	a2,16
  400632:	000ba583          	lw	a1,0(s7)
  400636:	855a                	mv	a0,s6
  400638:	d8bff0ef          	jal	4003c2 <printint>
        i += 1;
  40063c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  40063e:	8ba6                	mv	s7,s1
      state = 0;
  400640:	4981                	li	s3,0
        i += 1;
  400642:	b585                	j	4004a2 <vprintf+0x4a>
  400644:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  400646:	008b8d13          	addi	s10,s7,8
  40064a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  40064e:	03000593          	li	a1,48
  400652:	855a                	mv	a0,s6
  400654:	d51ff0ef          	jal	4003a4 <putc>
  putc(fd, 'x');
  400658:	07800593          	li	a1,120
  40065c:	855a                	mv	a0,s6
  40065e:	d47ff0ef          	jal	4003a4 <putc>
  400662:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400664:	00000b97          	auipc	s7,0x0
  400668:	294b8b93          	addi	s7,s7,660 # 4008f8 <digits>
  40066c:	03c9d793          	srli	a5,s3,0x3c
  400670:	97de                	add	a5,a5,s7
  400672:	0007c583          	lbu	a1,0(a5)
  400676:	855a                	mv	a0,s6
  400678:	d2dff0ef          	jal	4003a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  40067c:	0992                	slli	s3,s3,0x4
  40067e:	34fd                	addiw	s1,s1,-1
  400680:	f4f5                	bnez	s1,40066c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400682:	8bea                	mv	s7,s10
      state = 0;
  400684:	4981                	li	s3,0
  400686:	6d02                	ld	s10,0(sp)
  400688:	bd29                	j	4004a2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  40068a:	008b8993          	addi	s3,s7,8
  40068e:	000bb483          	ld	s1,0(s7)
  400692:	cc91                	beqz	s1,4006ae <vprintf+0x256>
        for(; *s; s++)
  400694:	0004c583          	lbu	a1,0(s1)
  400698:	c195                	beqz	a1,4006bc <vprintf+0x264>
          putc(fd, *s);
  40069a:	855a                	mv	a0,s6
  40069c:	d09ff0ef          	jal	4003a4 <putc>
        for(; *s; s++)
  4006a0:	0485                	addi	s1,s1,1
  4006a2:	0004c583          	lbu	a1,0(s1)
  4006a6:	f9f5                	bnez	a1,40069a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006a8:	8bce                	mv	s7,s3
      state = 0;
  4006aa:	4981                	li	s3,0
  4006ac:	bbdd                	j	4004a2 <vprintf+0x4a>
          s = "(null)";
  4006ae:	00000497          	auipc	s1,0x0
  4006b2:	24248493          	addi	s1,s1,578 # 4008f0 <malloc+0x12e>
        for(; *s; s++)
  4006b6:	02800593          	li	a1,40
  4006ba:	b7c5                	j	40069a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006bc:	8bce                	mv	s7,s3
      state = 0;
  4006be:	4981                	li	s3,0
  4006c0:	b3cd                	j	4004a2 <vprintf+0x4a>
  4006c2:	6906                	ld	s2,64(sp)
  4006c4:	79e2                	ld	s3,56(sp)
  4006c6:	7a42                	ld	s4,48(sp)
  4006c8:	7aa2                	ld	s5,40(sp)
  4006ca:	7b02                	ld	s6,32(sp)
  4006cc:	6be2                	ld	s7,24(sp)
  4006ce:	6c42                	ld	s8,16(sp)
  4006d0:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4006d2:	60e6                	ld	ra,88(sp)
  4006d4:	6446                	ld	s0,80(sp)
  4006d6:	64a6                	ld	s1,72(sp)
  4006d8:	6125                	addi	sp,sp,96
  4006da:	8082                	ret

00000000004006dc <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4006dc:	715d                	addi	sp,sp,-80
  4006de:	ec06                	sd	ra,24(sp)
  4006e0:	e822                	sd	s0,16(sp)
  4006e2:	1000                	addi	s0,sp,32
  4006e4:	e010                	sd	a2,0(s0)
  4006e6:	e414                	sd	a3,8(s0)
  4006e8:	e818                	sd	a4,16(s0)
  4006ea:	ec1c                	sd	a5,24(s0)
  4006ec:	03043023          	sd	a6,32(s0)
  4006f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  4006f4:	8622                	mv	a2,s0
  4006f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  4006fa:	d5fff0ef          	jal	400458 <vprintf>
  return 0;
}
  4006fe:	4501                	li	a0,0
  400700:	60e2                	ld	ra,24(sp)
  400702:	6442                	ld	s0,16(sp)
  400704:	6161                	addi	sp,sp,80
  400706:	8082                	ret

0000000000400708 <printf>:

int
printf(const char *fmt, ...)
{
  400708:	711d                	addi	sp,sp,-96
  40070a:	ec06                	sd	ra,24(sp)
  40070c:	e822                	sd	s0,16(sp)
  40070e:	1000                	addi	s0,sp,32
  400710:	e40c                	sd	a1,8(s0)
  400712:	e810                	sd	a2,16(s0)
  400714:	ec14                	sd	a3,24(s0)
  400716:	f018                	sd	a4,32(s0)
  400718:	f41c                	sd	a5,40(s0)
  40071a:	03043823          	sd	a6,48(s0)
  40071e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400722:	00840613          	addi	a2,s0,8
  400726:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  40072a:	85aa                	mv	a1,a0
  40072c:	4505                	li	a0,1
  40072e:	d2bff0ef          	jal	400458 <vprintf>
  return 0;
}
  400732:	4501                	li	a0,0
  400734:	60e2                	ld	ra,24(sp)
  400736:	6442                	ld	s0,16(sp)
  400738:	6125                	addi	sp,sp,96
  40073a:	8082                	ret

000000000040073c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  40073c:	1141                	addi	sp,sp,-16
  40073e:	e406                	sd	ra,8(sp)
  400740:	e022                	sd	s0,0(sp)
  400742:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  400744:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400748:	00001797          	auipc	a5,0x1
  40074c:	8b87b783          	ld	a5,-1864(a5) # 401000 <freep>
  400750:	a02d                	j	40077a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400752:	4618                	lw	a4,8(a2)
  400754:	9f2d                	addw	a4,a4,a1
  400756:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  40075a:	6398                	ld	a4,0(a5)
  40075c:	6310                	ld	a2,0(a4)
  40075e:	a83d                	j	40079c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400760:	ff852703          	lw	a4,-8(a0)
  400764:	9f31                	addw	a4,a4,a2
  400766:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400768:	ff053683          	ld	a3,-16(a0)
  40076c:	a091                	j	4007b0 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40076e:	6398                	ld	a4,0(a5)
  400770:	00e7e463          	bltu	a5,a4,400778 <free+0x3c>
  400774:	00e6ea63          	bltu	a3,a4,400788 <free+0x4c>
{
  400778:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40077a:	fed7fae3          	bgeu	a5,a3,40076e <free+0x32>
  40077e:	6398                	ld	a4,0(a5)
  400780:	00e6e463          	bltu	a3,a4,400788 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400784:	fee7eae3          	bltu	a5,a4,400778 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  400788:	ff852583          	lw	a1,-8(a0)
  40078c:	6390                	ld	a2,0(a5)
  40078e:	02059813          	slli	a6,a1,0x20
  400792:	01c85713          	srli	a4,a6,0x1c
  400796:	9736                	add	a4,a4,a3
  400798:	fae60de3          	beq	a2,a4,400752 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  40079c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4007a0:	4790                	lw	a2,8(a5)
  4007a2:	02061593          	slli	a1,a2,0x20
  4007a6:	01c5d713          	srli	a4,a1,0x1c
  4007aa:	973e                	add	a4,a4,a5
  4007ac:	fae68ae3          	beq	a3,a4,400760 <free+0x24>
    p->s.ptr = bp->s.ptr;
  4007b0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4007b2:	00001717          	auipc	a4,0x1
  4007b6:	84f73723          	sd	a5,-1970(a4) # 401000 <freep>
}
  4007ba:	60a2                	ld	ra,8(sp)
  4007bc:	6402                	ld	s0,0(sp)
  4007be:	0141                	addi	sp,sp,16
  4007c0:	8082                	ret

00000000004007c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4007c2:	7139                	addi	sp,sp,-64
  4007c4:	fc06                	sd	ra,56(sp)
  4007c6:	f822                	sd	s0,48(sp)
  4007c8:	f04a                	sd	s2,32(sp)
  4007ca:	ec4e                	sd	s3,24(sp)
  4007cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4007ce:	02051993          	slli	s3,a0,0x20
  4007d2:	0209d993          	srli	s3,s3,0x20
  4007d6:	09bd                	addi	s3,s3,15
  4007d8:	0049d993          	srli	s3,s3,0x4
  4007dc:	2985                	addiw	s3,s3,1
  4007de:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4007e0:	00001517          	auipc	a0,0x1
  4007e4:	82053503          	ld	a0,-2016(a0) # 401000 <freep>
  4007e8:	c905                	beqz	a0,400818 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4007ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4007ec:	4798                	lw	a4,8(a5)
  4007ee:	09377663          	bgeu	a4,s3,40087a <malloc+0xb8>
  4007f2:	f426                	sd	s1,40(sp)
  4007f4:	e852                	sd	s4,16(sp)
  4007f6:	e456                	sd	s5,8(sp)
  4007f8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  4007fa:	8a4e                	mv	s4,s3
  4007fc:	6705                	lui	a4,0x1
  4007fe:	00e9f363          	bgeu	s3,a4,400804 <malloc+0x42>
  400802:	6a05                	lui	s4,0x1
  400804:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400808:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  40080c:	00000497          	auipc	s1,0x0
  400810:	7f448493          	addi	s1,s1,2036 # 401000 <freep>
  if(p == (char*)-1)
  400814:	5afd                	li	s5,-1
  400816:	a83d                	j	400854 <malloc+0x92>
  400818:	f426                	sd	s1,40(sp)
  40081a:	e852                	sd	s4,16(sp)
  40081c:	e456                	sd	s5,8(sp)
  40081e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  400820:	00000797          	auipc	a5,0x0
  400824:	7f078793          	addi	a5,a5,2032 # 401010 <base>
  400828:	00000717          	auipc	a4,0x0
  40082c:	7cf73c23          	sd	a5,2008(a4) # 401000 <freep>
  400830:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400832:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  400836:	b7d1                	j	4007fa <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400838:	6398                	ld	a4,0(a5)
  40083a:	e118                	sd	a4,0(a0)
  40083c:	a899                	j	400892 <malloc+0xd0>
  hp->s.size = nu;
  40083e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400842:	0541                	addi	a0,a0,16
  400844:	ef9ff0ef          	jal	40073c <free>
  return freep;
  400848:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  40084a:	c125                	beqz	a0,4008aa <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  40084c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40084e:	4798                	lw	a4,8(a5)
  400850:	03277163          	bgeu	a4,s2,400872 <malloc+0xb0>
    if(p == freep)
  400854:	6098                	ld	a4,0(s1)
  400856:	853e                	mv	a0,a5
  400858:	fef71ae3          	bne	a4,a5,40084c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  40085c:	8552                	mv	a0,s4
  40085e:	b17ff0ef          	jal	400374 <sbrk>
  if(p == (char*)-1)
  400862:	fd551ee3          	bne	a0,s5,40083e <malloc+0x7c>
        return 0;
  400866:	4501                	li	a0,0
  400868:	74a2                	ld	s1,40(sp)
  40086a:	6a42                	ld	s4,16(sp)
  40086c:	6aa2                	ld	s5,8(sp)
  40086e:	6b02                	ld	s6,0(sp)
  400870:	a03d                	j	40089e <malloc+0xdc>
  400872:	74a2                	ld	s1,40(sp)
  400874:	6a42                	ld	s4,16(sp)
  400876:	6aa2                	ld	s5,8(sp)
  400878:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  40087a:	fae90fe3          	beq	s2,a4,400838 <malloc+0x76>
        p->s.size -= nunits;
  40087e:	4137073b          	subw	a4,a4,s3
  400882:	c798                	sw	a4,8(a5)
        p += p->s.size;
  400884:	02071693          	slli	a3,a4,0x20
  400888:	01c6d713          	srli	a4,a3,0x1c
  40088c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  40088e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400892:	00000717          	auipc	a4,0x0
  400896:	76a73723          	sd	a0,1902(a4) # 401000 <freep>
      return (void*)(p + 1);
  40089a:	01078513          	addi	a0,a5,16
  }
}
  40089e:	70e2                	ld	ra,56(sp)
  4008a0:	7442                	ld	s0,48(sp)
  4008a2:	7902                	ld	s2,32(sp)
  4008a4:	69e2                	ld	s3,24(sp)
  4008a6:	6121                	addi	sp,sp,64
  4008a8:	8082                	ret
  4008aa:	74a2                	ld	s1,40(sp)
  4008ac:	6a42                	ld	s4,16(sp)
  4008ae:	6aa2                	ld	s5,8(sp)
  4008b0:	6b02                	ld	s6,0(sp)
  4008b2:	b7f5                	j	40089e <malloc+0xdc>
