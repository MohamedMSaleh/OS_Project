
user/_mkdir:     file format elf64-littleriscv


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
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  400026:	6088                	ld	a0,0(s1)
  400028:	344000ef          	jal	40036c <mkdir>
  40002c:	02054463          	bltz	a0,400054 <main+0x54>
  for(i = 1; i < argc; i++){
  400030:	04a1                	addi	s1,s1,8
  400032:	ff249ae3          	bne	s1,s2,400026 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
  400036:	4501                	li	a0,0
  400038:	2cc000ef          	jal	400304 <exit>
  40003c:	e426                	sd	s1,8(sp)
  40003e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  400040:	00001597          	auipc	a1,0x1
  400044:	89058593          	addi	a1,a1,-1904 # 4008d0 <malloc+0xf6>
  400048:	4509                	li	a0,2
  40004a:	6aa000ef          	jal	4006f4 <fprintf>
    exit(1);
  40004e:	4505                	li	a0,1
  400050:	2b4000ef          	jal	400304 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  400054:	6090                	ld	a2,0(s1)
  400056:	00001597          	auipc	a1,0x1
  40005a:	89258593          	addi	a1,a1,-1902 # 4008e8 <malloc+0x10e>
  40005e:	4509                	li	a0,2
  400060:	694000ef          	jal	4006f4 <fprintf>
      break;
  400064:	bfc9                	j	400036 <main+0x36>

0000000000400066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  400066:	1141                	addi	sp,sp,-16
  400068:	e406                	sd	ra,8(sp)
  40006a:	e022                	sd	s0,0(sp)
  40006c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  40006e:	f93ff0ef          	jal	400000 <main>
  exit(0);
  400072:	4501                	li	a0,0
  400074:	290000ef          	jal	400304 <exit>

0000000000400078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400078:	1141                	addi	sp,sp,-16
  40007a:	e406                	sd	ra,8(sp)
  40007c:	e022                	sd	s0,0(sp)
  40007e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400080:	87aa                	mv	a5,a0
  400082:	0585                	addi	a1,a1,1
  400084:	0785                	addi	a5,a5,1
  400086:	fff5c703          	lbu	a4,-1(a1)
  40008a:	fee78fa3          	sb	a4,-1(a5)
  40008e:	fb75                	bnez	a4,400082 <strcpy+0xa>
    ;
  return os;
}
  400090:	60a2                	ld	ra,8(sp)
  400092:	6402                	ld	s0,0(sp)
  400094:	0141                	addi	sp,sp,16
  400096:	8082                	ret

0000000000400098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400098:	1141                	addi	sp,sp,-16
  40009a:	e406                	sd	ra,8(sp)
  40009c:	e022                	sd	s0,0(sp)
  40009e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4000a0:	00054783          	lbu	a5,0(a0)
  4000a4:	cb91                	beqz	a5,4000b8 <strcmp+0x20>
  4000a6:	0005c703          	lbu	a4,0(a1)
  4000aa:	00f71763          	bne	a4,a5,4000b8 <strcmp+0x20>
    p++, q++;
  4000ae:	0505                	addi	a0,a0,1
  4000b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4000b2:	00054783          	lbu	a5,0(a0)
  4000b6:	fbe5                	bnez	a5,4000a6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4000b8:	0005c503          	lbu	a0,0(a1)
}
  4000bc:	40a7853b          	subw	a0,a5,a0
  4000c0:	60a2                	ld	ra,8(sp)
  4000c2:	6402                	ld	s0,0(sp)
  4000c4:	0141                	addi	sp,sp,16
  4000c6:	8082                	ret

00000000004000c8 <strlen>:

uint
strlen(const char *s)
{
  4000c8:	1141                	addi	sp,sp,-16
  4000ca:	e406                	sd	ra,8(sp)
  4000cc:	e022                	sd	s0,0(sp)
  4000ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4000d0:	00054783          	lbu	a5,0(a0)
  4000d4:	cf99                	beqz	a5,4000f2 <strlen+0x2a>
  4000d6:	0505                	addi	a0,a0,1
  4000d8:	87aa                	mv	a5,a0
  4000da:	86be                	mv	a3,a5
  4000dc:	0785                	addi	a5,a5,1
  4000de:	fff7c703          	lbu	a4,-1(a5)
  4000e2:	ff65                	bnez	a4,4000da <strlen+0x12>
  4000e4:	40a6853b          	subw	a0,a3,a0
  4000e8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4000ea:	60a2                	ld	ra,8(sp)
  4000ec:	6402                	ld	s0,0(sp)
  4000ee:	0141                	addi	sp,sp,16
  4000f0:	8082                	ret
  for(n = 0; s[n]; n++)
  4000f2:	4501                	li	a0,0
  4000f4:	bfdd                	j	4000ea <strlen+0x22>

00000000004000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  4000f6:	1141                	addi	sp,sp,-16
  4000f8:	e406                	sd	ra,8(sp)
  4000fa:	e022                	sd	s0,0(sp)
  4000fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  4000fe:	ca19                	beqz	a2,400114 <memset+0x1e>
  400100:	87aa                	mv	a5,a0
  400102:	1602                	slli	a2,a2,0x20
  400104:	9201                	srli	a2,a2,0x20
  400106:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  40010a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  40010e:	0785                	addi	a5,a5,1
  400110:	fee79de3          	bne	a5,a4,40010a <memset+0x14>
  }
  return dst;
}
  400114:	60a2                	ld	ra,8(sp)
  400116:	6402                	ld	s0,0(sp)
  400118:	0141                	addi	sp,sp,16
  40011a:	8082                	ret

000000000040011c <strchr>:

char*
strchr(const char *s, char c)
{
  40011c:	1141                	addi	sp,sp,-16
  40011e:	e406                	sd	ra,8(sp)
  400120:	e022                	sd	s0,0(sp)
  400122:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400124:	00054783          	lbu	a5,0(a0)
  400128:	cf81                	beqz	a5,400140 <strchr+0x24>
    if(*s == c)
  40012a:	00f58763          	beq	a1,a5,400138 <strchr+0x1c>
  for(; *s; s++)
  40012e:	0505                	addi	a0,a0,1
  400130:	00054783          	lbu	a5,0(a0)
  400134:	fbfd                	bnez	a5,40012a <strchr+0xe>
      return (char*)s;
  return 0;
  400136:	4501                	li	a0,0
}
  400138:	60a2                	ld	ra,8(sp)
  40013a:	6402                	ld	s0,0(sp)
  40013c:	0141                	addi	sp,sp,16
  40013e:	8082                	ret
  return 0;
  400140:	4501                	li	a0,0
  400142:	bfdd                	j	400138 <strchr+0x1c>

0000000000400144 <gets>:

char*
gets(char *buf, int max)
{
  400144:	7159                	addi	sp,sp,-112
  400146:	f486                	sd	ra,104(sp)
  400148:	f0a2                	sd	s0,96(sp)
  40014a:	eca6                	sd	s1,88(sp)
  40014c:	e8ca                	sd	s2,80(sp)
  40014e:	e4ce                	sd	s3,72(sp)
  400150:	e0d2                	sd	s4,64(sp)
  400152:	fc56                	sd	s5,56(sp)
  400154:	f85a                	sd	s6,48(sp)
  400156:	f45e                	sd	s7,40(sp)
  400158:	f062                	sd	s8,32(sp)
  40015a:	ec66                	sd	s9,24(sp)
  40015c:	e86a                	sd	s10,16(sp)
  40015e:	1880                	addi	s0,sp,112
  400160:	8caa                	mv	s9,a0
  400162:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400164:	892a                	mv	s2,a0
  400166:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400168:	f9f40b13          	addi	s6,s0,-97
  40016c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  40016e:	4ba9                	li	s7,10
  400170:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400172:	8d26                	mv	s10,s1
  400174:	0014899b          	addiw	s3,s1,1
  400178:	84ce                	mv	s1,s3
  40017a:	0349d563          	bge	s3,s4,4001a4 <gets+0x60>
    cc = read(0, &c, 1);
  40017e:	8656                	mv	a2,s5
  400180:	85da                	mv	a1,s6
  400182:	4501                	li	a0,0
  400184:	198000ef          	jal	40031c <read>
    if(cc < 1)
  400188:	00a05e63          	blez	a0,4001a4 <gets+0x60>
    buf[i++] = c;
  40018c:	f9f44783          	lbu	a5,-97(s0)
  400190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400194:	01778763          	beq	a5,s7,4001a2 <gets+0x5e>
  400198:	0905                	addi	s2,s2,1
  40019a:	fd879ce3          	bne	a5,s8,400172 <gets+0x2e>
    buf[i++] = c;
  40019e:	8d4e                	mv	s10,s3
  4001a0:	a011                	j	4001a4 <gets+0x60>
  4001a2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  4001a4:	9d66                	add	s10,s10,s9
  4001a6:	000d0023          	sb	zero,0(s10)
  return buf;
}
  4001aa:	8566                	mv	a0,s9
  4001ac:	70a6                	ld	ra,104(sp)
  4001ae:	7406                	ld	s0,96(sp)
  4001b0:	64e6                	ld	s1,88(sp)
  4001b2:	6946                	ld	s2,80(sp)
  4001b4:	69a6                	ld	s3,72(sp)
  4001b6:	6a06                	ld	s4,64(sp)
  4001b8:	7ae2                	ld	s5,56(sp)
  4001ba:	7b42                	ld	s6,48(sp)
  4001bc:	7ba2                	ld	s7,40(sp)
  4001be:	7c02                	ld	s8,32(sp)
  4001c0:	6ce2                	ld	s9,24(sp)
  4001c2:	6d42                	ld	s10,16(sp)
  4001c4:	6165                	addi	sp,sp,112
  4001c6:	8082                	ret

00000000004001c8 <stat>:

int
stat(const char *n, struct stat *st)
{
  4001c8:	1101                	addi	sp,sp,-32
  4001ca:	ec06                	sd	ra,24(sp)
  4001cc:	e822                	sd	s0,16(sp)
  4001ce:	e04a                	sd	s2,0(sp)
  4001d0:	1000                	addi	s0,sp,32
  4001d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4001d4:	4581                	li	a1,0
  4001d6:	16e000ef          	jal	400344 <open>
  if(fd < 0)
  4001da:	02054263          	bltz	a0,4001fe <stat+0x36>
  4001de:	e426                	sd	s1,8(sp)
  4001e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4001e2:	85ca                	mv	a1,s2
  4001e4:	178000ef          	jal	40035c <fstat>
  4001e8:	892a                	mv	s2,a0
  close(fd);
  4001ea:	8526                	mv	a0,s1
  4001ec:	140000ef          	jal	40032c <close>
  return r;
  4001f0:	64a2                	ld	s1,8(sp)
}
  4001f2:	854a                	mv	a0,s2
  4001f4:	60e2                	ld	ra,24(sp)
  4001f6:	6442                	ld	s0,16(sp)
  4001f8:	6902                	ld	s2,0(sp)
  4001fa:	6105                	addi	sp,sp,32
  4001fc:	8082                	ret
    return -1;
  4001fe:	597d                	li	s2,-1
  400200:	bfcd                	j	4001f2 <stat+0x2a>

0000000000400202 <atoi>:

int
atoi(const char *s)
{
  400202:	1141                	addi	sp,sp,-16
  400204:	e406                	sd	ra,8(sp)
  400206:	e022                	sd	s0,0(sp)
  400208:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  40020a:	00054683          	lbu	a3,0(a0)
  40020e:	fd06879b          	addiw	a5,a3,-48
  400212:	0ff7f793          	zext.b	a5,a5
  400216:	4625                	li	a2,9
  400218:	02f66963          	bltu	a2,a5,40024a <atoi+0x48>
  40021c:	872a                	mv	a4,a0
  n = 0;
  40021e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400220:	0705                	addi	a4,a4,1
  400222:	0025179b          	slliw	a5,a0,0x2
  400226:	9fa9                	addw	a5,a5,a0
  400228:	0017979b          	slliw	a5,a5,0x1
  40022c:	9fb5                	addw	a5,a5,a3
  40022e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400232:	00074683          	lbu	a3,0(a4)
  400236:	fd06879b          	addiw	a5,a3,-48
  40023a:	0ff7f793          	zext.b	a5,a5
  40023e:	fef671e3          	bgeu	a2,a5,400220 <atoi+0x1e>
  return n;
}
  400242:	60a2                	ld	ra,8(sp)
  400244:	6402                	ld	s0,0(sp)
  400246:	0141                	addi	sp,sp,16
  400248:	8082                	ret
  n = 0;
  40024a:	4501                	li	a0,0
  40024c:	bfdd                	j	400242 <atoi+0x40>

000000000040024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  40024e:	1141                	addi	sp,sp,-16
  400250:	e406                	sd	ra,8(sp)
  400252:	e022                	sd	s0,0(sp)
  400254:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400256:	02b57563          	bgeu	a0,a1,400280 <memmove+0x32>
    while(n-- > 0)
  40025a:	00c05f63          	blez	a2,400278 <memmove+0x2a>
  40025e:	1602                	slli	a2,a2,0x20
  400260:	9201                	srli	a2,a2,0x20
  400262:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400266:	872a                	mv	a4,a0
      *dst++ = *src++;
  400268:	0585                	addi	a1,a1,1
  40026a:	0705                	addi	a4,a4,1
  40026c:	fff5c683          	lbu	a3,-1(a1)
  400270:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400274:	fee79ae3          	bne	a5,a4,400268 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400278:	60a2                	ld	ra,8(sp)
  40027a:	6402                	ld	s0,0(sp)
  40027c:	0141                	addi	sp,sp,16
  40027e:	8082                	ret
    dst += n;
  400280:	00c50733          	add	a4,a0,a2
    src += n;
  400284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400286:	fec059e3          	blez	a2,400278 <memmove+0x2a>
  40028a:	fff6079b          	addiw	a5,a2,-1
  40028e:	1782                	slli	a5,a5,0x20
  400290:	9381                	srli	a5,a5,0x20
  400292:	fff7c793          	not	a5,a5
  400296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400298:	15fd                	addi	a1,a1,-1
  40029a:	177d                	addi	a4,a4,-1
  40029c:	0005c683          	lbu	a3,0(a1)
  4002a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  4002a4:	fef71ae3          	bne	a4,a5,400298 <memmove+0x4a>
  4002a8:	bfc1                	j	400278 <memmove+0x2a>

00000000004002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  4002aa:	1141                	addi	sp,sp,-16
  4002ac:	e406                	sd	ra,8(sp)
  4002ae:	e022                	sd	s0,0(sp)
  4002b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4002b2:	ca0d                	beqz	a2,4002e4 <memcmp+0x3a>
  4002b4:	fff6069b          	addiw	a3,a2,-1
  4002b8:	1682                	slli	a3,a3,0x20
  4002ba:	9281                	srli	a3,a3,0x20
  4002bc:	0685                	addi	a3,a3,1
  4002be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4002c0:	00054783          	lbu	a5,0(a0)
  4002c4:	0005c703          	lbu	a4,0(a1)
  4002c8:	00e79863          	bne	a5,a4,4002d8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4002cc:	0505                	addi	a0,a0,1
    p2++;
  4002ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4002d0:	fed518e3          	bne	a0,a3,4002c0 <memcmp+0x16>
  }
  return 0;
  4002d4:	4501                	li	a0,0
  4002d6:	a019                	j	4002dc <memcmp+0x32>
      return *p1 - *p2;
  4002d8:	40e7853b          	subw	a0,a5,a4
}
  4002dc:	60a2                	ld	ra,8(sp)
  4002de:	6402                	ld	s0,0(sp)
  4002e0:	0141                	addi	sp,sp,16
  4002e2:	8082                	ret
  return 0;
  4002e4:	4501                	li	a0,0
  4002e6:	bfdd                	j	4002dc <memcmp+0x32>

00000000004002e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4002e8:	1141                	addi	sp,sp,-16
  4002ea:	e406                	sd	ra,8(sp)
  4002ec:	e022                	sd	s0,0(sp)
  4002ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4002f0:	f5fff0ef          	jal	40024e <memmove>
}
  4002f4:	60a2                	ld	ra,8(sp)
  4002f6:	6402                	ld	s0,0(sp)
  4002f8:	0141                	addi	sp,sp,16
  4002fa:	8082                	ret

00000000004002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  4002fc:	4885                	li	a7,1
 ecall
  4002fe:	00000073          	ecall
 ret
  400302:	8082                	ret

0000000000400304 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400304:	4889                	li	a7,2
 ecall
  400306:	00000073          	ecall
 ret
  40030a:	8082                	ret

000000000040030c <wait>:
.global wait
wait:
 li a7, SYS_wait
  40030c:	488d                	li	a7,3
 ecall
  40030e:	00000073          	ecall
 ret
  400312:	8082                	ret

0000000000400314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400314:	4891                	li	a7,4
 ecall
  400316:	00000073          	ecall
 ret
  40031a:	8082                	ret

000000000040031c <read>:
.global read
read:
 li a7, SYS_read
  40031c:	4895                	li	a7,5
 ecall
  40031e:	00000073          	ecall
 ret
  400322:	8082                	ret

0000000000400324 <write>:
.global write
write:
 li a7, SYS_write
  400324:	48c1                	li	a7,16
 ecall
  400326:	00000073          	ecall
 ret
  40032a:	8082                	ret

000000000040032c <close>:
.global close
close:
 li a7, SYS_close
  40032c:	48d5                	li	a7,21
 ecall
  40032e:	00000073          	ecall
 ret
  400332:	8082                	ret

0000000000400334 <kill>:
.global kill
kill:
 li a7, SYS_kill
  400334:	4899                	li	a7,6
 ecall
  400336:	00000073          	ecall
 ret
  40033a:	8082                	ret

000000000040033c <exec>:
.global exec
exec:
 li a7, SYS_exec
  40033c:	489d                	li	a7,7
 ecall
  40033e:	00000073          	ecall
 ret
  400342:	8082                	ret

0000000000400344 <open>:
.global open
open:
 li a7, SYS_open
  400344:	48bd                	li	a7,15
 ecall
  400346:	00000073          	ecall
 ret
  40034a:	8082                	ret

000000000040034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  40034c:	48c5                	li	a7,17
 ecall
  40034e:	00000073          	ecall
 ret
  400352:	8082                	ret

0000000000400354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400354:	48c9                	li	a7,18
 ecall
  400356:	00000073          	ecall
 ret
  40035a:	8082                	ret

000000000040035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  40035c:	48a1                	li	a7,8
 ecall
  40035e:	00000073          	ecall
 ret
  400362:	8082                	ret

0000000000400364 <link>:
.global link
link:
 li a7, SYS_link
  400364:	48cd                	li	a7,19
 ecall
  400366:	00000073          	ecall
 ret
  40036a:	8082                	ret

000000000040036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  40036c:	48d1                	li	a7,20
 ecall
  40036e:	00000073          	ecall
 ret
  400372:	8082                	ret

0000000000400374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400374:	48a5                	li	a7,9
 ecall
  400376:	00000073          	ecall
 ret
  40037a:	8082                	ret

000000000040037c <dup>:
.global dup
dup:
 li a7, SYS_dup
  40037c:	48a9                	li	a7,10
 ecall
  40037e:	00000073          	ecall
 ret
  400382:	8082                	ret

0000000000400384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400384:	48ad                	li	a7,11
 ecall
  400386:	00000073          	ecall
 ret
  40038a:	8082                	ret

000000000040038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  40038c:	48b1                	li	a7,12
 ecall
  40038e:	00000073          	ecall
 ret
  400392:	8082                	ret

0000000000400394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400394:	48b5                	li	a7,13
 ecall
  400396:	00000073          	ecall
 ret
  40039a:	8082                	ret

000000000040039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  40039c:	48b9                	li	a7,14
 ecall
  40039e:	00000073          	ecall
 ret
  4003a2:	8082                	ret

00000000004003a4 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  4003a4:	48d9                	li	a7,22
 ecall
  4003a6:	00000073          	ecall
 ret
  4003aa:	8082                	ret

00000000004003ac <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  4003ac:	48dd                	li	a7,23
 ecall
  4003ae:	00000073          	ecall
 ret
  4003b2:	8082                	ret

00000000004003b4 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4003b4:	48e1                	li	a7,24
 ecall
  4003b6:	00000073          	ecall
 ret
  4003ba:	8082                	ret

00000000004003bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4003bc:	1101                	addi	sp,sp,-32
  4003be:	ec06                	sd	ra,24(sp)
  4003c0:	e822                	sd	s0,16(sp)
  4003c2:	1000                	addi	s0,sp,32
  4003c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4003c8:	4605                	li	a2,1
  4003ca:	fef40593          	addi	a1,s0,-17
  4003ce:	f57ff0ef          	jal	400324 <write>
}
  4003d2:	60e2                	ld	ra,24(sp)
  4003d4:	6442                	ld	s0,16(sp)
  4003d6:	6105                	addi	sp,sp,32
  4003d8:	8082                	ret

00000000004003da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4003da:	7139                	addi	sp,sp,-64
  4003dc:	fc06                	sd	ra,56(sp)
  4003de:	f822                	sd	s0,48(sp)
  4003e0:	f426                	sd	s1,40(sp)
  4003e2:	f04a                	sd	s2,32(sp)
  4003e4:	ec4e                	sd	s3,24(sp)
  4003e6:	0080                	addi	s0,sp,64
  4003e8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4003ea:	c299                	beqz	a3,4003f0 <printint+0x16>
  4003ec:	0605ce63          	bltz	a1,400468 <printint+0x8e>
  neg = 0;
  4003f0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4003f2:	fc040313          	addi	t1,s0,-64
  neg = 0;
  4003f6:	869a                	mv	a3,t1
  i = 0;
  4003f8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  4003fa:	00000817          	auipc	a6,0x0
  4003fe:	51680813          	addi	a6,a6,1302 # 400910 <digits>
  400402:	88be                	mv	a7,a5
  400404:	0017851b          	addiw	a0,a5,1
  400408:	87aa                	mv	a5,a0
  40040a:	02c5f73b          	remuw	a4,a1,a2
  40040e:	1702                	slli	a4,a4,0x20
  400410:	9301                	srli	a4,a4,0x20
  400412:	9742                	add	a4,a4,a6
  400414:	00074703          	lbu	a4,0(a4)
  400418:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  40041c:	872e                	mv	a4,a1
  40041e:	02c5d5bb          	divuw	a1,a1,a2
  400422:	0685                	addi	a3,a3,1
  400424:	fcc77fe3          	bgeu	a4,a2,400402 <printint+0x28>
  if(neg)
  400428:	000e0c63          	beqz	t3,400440 <printint+0x66>
    buf[i++] = '-';
  40042c:	fd050793          	addi	a5,a0,-48
  400430:	00878533          	add	a0,a5,s0
  400434:	02d00793          	li	a5,45
  400438:	fef50823          	sb	a5,-16(a0)
  40043c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400440:	fff7899b          	addiw	s3,a5,-1
  400444:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400448:	fff4c583          	lbu	a1,-1(s1)
  40044c:	854a                	mv	a0,s2
  40044e:	f6fff0ef          	jal	4003bc <putc>
  while(--i >= 0)
  400452:	39fd                	addiw	s3,s3,-1
  400454:	14fd                	addi	s1,s1,-1
  400456:	fe09d9e3          	bgez	s3,400448 <printint+0x6e>
}
  40045a:	70e2                	ld	ra,56(sp)
  40045c:	7442                	ld	s0,48(sp)
  40045e:	74a2                	ld	s1,40(sp)
  400460:	7902                	ld	s2,32(sp)
  400462:	69e2                	ld	s3,24(sp)
  400464:	6121                	addi	sp,sp,64
  400466:	8082                	ret
    x = -xx;
  400468:	40b005bb          	negw	a1,a1
    neg = 1;
  40046c:	4e05                	li	t3,1
    x = -xx;
  40046e:	b751                	j	4003f2 <printint+0x18>

0000000000400470 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400470:	711d                	addi	sp,sp,-96
  400472:	ec86                	sd	ra,88(sp)
  400474:	e8a2                	sd	s0,80(sp)
  400476:	e4a6                	sd	s1,72(sp)
  400478:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  40047a:	0005c483          	lbu	s1,0(a1)
  40047e:	26048663          	beqz	s1,4006ea <vprintf+0x27a>
  400482:	e0ca                	sd	s2,64(sp)
  400484:	fc4e                	sd	s3,56(sp)
  400486:	f852                	sd	s4,48(sp)
  400488:	f456                	sd	s5,40(sp)
  40048a:	f05a                	sd	s6,32(sp)
  40048c:	ec5e                	sd	s7,24(sp)
  40048e:	e862                	sd	s8,16(sp)
  400490:	e466                	sd	s9,8(sp)
  400492:	8b2a                	mv	s6,a0
  400494:	8a2e                	mv	s4,a1
  400496:	8bb2                	mv	s7,a2
  state = 0;
  400498:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  40049a:	4901                	li	s2,0
  40049c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  40049e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  4004a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  4004a6:	06c00c93          	li	s9,108
  4004aa:	a00d                	j	4004cc <vprintf+0x5c>
        putc(fd, c0);
  4004ac:	85a6                	mv	a1,s1
  4004ae:	855a                	mv	a0,s6
  4004b0:	f0dff0ef          	jal	4003bc <putc>
  4004b4:	a019                	j	4004ba <vprintf+0x4a>
    } else if(state == '%'){
  4004b6:	03598363          	beq	s3,s5,4004dc <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4004ba:	0019079b          	addiw	a5,s2,1
  4004be:	893e                	mv	s2,a5
  4004c0:	873e                	mv	a4,a5
  4004c2:	97d2                	add	a5,a5,s4
  4004c4:	0007c483          	lbu	s1,0(a5)
  4004c8:	20048963          	beqz	s1,4006da <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4004cc:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4004d0:	fe0993e3          	bnez	s3,4004b6 <vprintf+0x46>
      if(c0 == '%'){
  4004d4:	fd579ce3          	bne	a5,s5,4004ac <vprintf+0x3c>
        state = '%';
  4004d8:	89be                	mv	s3,a5
  4004da:	b7c5                	j	4004ba <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4004dc:	00ea06b3          	add	a3,s4,a4
  4004e0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4004e4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4004e6:	c681                	beqz	a3,4004ee <vprintf+0x7e>
  4004e8:	9752                	add	a4,a4,s4
  4004ea:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4004ee:	03878e63          	beq	a5,s8,40052a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4004f2:	05978863          	beq	a5,s9,400542 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  4004f6:	07500713          	li	a4,117
  4004fa:	0ee78263          	beq	a5,a4,4005de <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  4004fe:	07800713          	li	a4,120
  400502:	12e78463          	beq	a5,a4,40062a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400506:	07000713          	li	a4,112
  40050a:	14e78963          	beq	a5,a4,40065c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  40050e:	07300713          	li	a4,115
  400512:	18e78863          	beq	a5,a4,4006a2 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400516:	02500713          	li	a4,37
  40051a:	04e79463          	bne	a5,a4,400562 <vprintf+0xf2>
        putc(fd, '%');
  40051e:	85ba                	mv	a1,a4
  400520:	855a                	mv	a0,s6
  400522:	e9bff0ef          	jal	4003bc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400526:	4981                	li	s3,0
  400528:	bf49                	j	4004ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  40052a:	008b8493          	addi	s1,s7,8
  40052e:	4685                	li	a3,1
  400530:	4629                	li	a2,10
  400532:	000ba583          	lw	a1,0(s7)
  400536:	855a                	mv	a0,s6
  400538:	ea3ff0ef          	jal	4003da <printint>
  40053c:	8ba6                	mv	s7,s1
      state = 0;
  40053e:	4981                	li	s3,0
  400540:	bfad                	j	4004ba <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400542:	06400793          	li	a5,100
  400546:	02f68963          	beq	a3,a5,400578 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  40054a:	06c00793          	li	a5,108
  40054e:	04f68263          	beq	a3,a5,400592 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400552:	07500793          	li	a5,117
  400556:	0af68063          	beq	a3,a5,4005f6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  40055a:	07800793          	li	a5,120
  40055e:	0ef68263          	beq	a3,a5,400642 <vprintf+0x1d2>
        putc(fd, '%');
  400562:	02500593          	li	a1,37
  400566:	855a                	mv	a0,s6
  400568:	e55ff0ef          	jal	4003bc <putc>
        putc(fd, c0);
  40056c:	85a6                	mv	a1,s1
  40056e:	855a                	mv	a0,s6
  400570:	e4dff0ef          	jal	4003bc <putc>
      state = 0;
  400574:	4981                	li	s3,0
  400576:	b791                	j	4004ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400578:	008b8493          	addi	s1,s7,8
  40057c:	4685                	li	a3,1
  40057e:	4629                	li	a2,10
  400580:	000ba583          	lw	a1,0(s7)
  400584:	855a                	mv	a0,s6
  400586:	e55ff0ef          	jal	4003da <printint>
        i += 1;
  40058a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  40058c:	8ba6                	mv	s7,s1
      state = 0;
  40058e:	4981                	li	s3,0
        i += 1;
  400590:	b72d                	j	4004ba <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400592:	06400793          	li	a5,100
  400596:	02f60763          	beq	a2,a5,4005c4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  40059a:	07500793          	li	a5,117
  40059e:	06f60963          	beq	a2,a5,400610 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  4005a2:	07800793          	li	a5,120
  4005a6:	faf61ee3          	bne	a2,a5,400562 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005aa:	008b8493          	addi	s1,s7,8
  4005ae:	4681                	li	a3,0
  4005b0:	4641                	li	a2,16
  4005b2:	000ba583          	lw	a1,0(s7)
  4005b6:	855a                	mv	a0,s6
  4005b8:	e23ff0ef          	jal	4003da <printint>
        i += 2;
  4005bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4005be:	8ba6                	mv	s7,s1
      state = 0;
  4005c0:	4981                	li	s3,0
        i += 2;
  4005c2:	bde5                	j	4004ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005c4:	008b8493          	addi	s1,s7,8
  4005c8:	4685                	li	a3,1
  4005ca:	4629                	li	a2,10
  4005cc:	000ba583          	lw	a1,0(s7)
  4005d0:	855a                	mv	a0,s6
  4005d2:	e09ff0ef          	jal	4003da <printint>
        i += 2;
  4005d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005d8:	8ba6                	mv	s7,s1
      state = 0;
  4005da:	4981                	li	s3,0
        i += 2;
  4005dc:	bdf9                	j	4004ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4005de:	008b8493          	addi	s1,s7,8
  4005e2:	4681                	li	a3,0
  4005e4:	4629                	li	a2,10
  4005e6:	000ba583          	lw	a1,0(s7)
  4005ea:	855a                	mv	a0,s6
  4005ec:	defff0ef          	jal	4003da <printint>
  4005f0:	8ba6                	mv	s7,s1
      state = 0;
  4005f2:	4981                	li	s3,0
  4005f4:	b5d9                	j	4004ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4005f6:	008b8493          	addi	s1,s7,8
  4005fa:	4681                	li	a3,0
  4005fc:	4629                	li	a2,10
  4005fe:	000ba583          	lw	a1,0(s7)
  400602:	855a                	mv	a0,s6
  400604:	dd7ff0ef          	jal	4003da <printint>
        i += 1;
  400608:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  40060a:	8ba6                	mv	s7,s1
      state = 0;
  40060c:	4981                	li	s3,0
        i += 1;
  40060e:	b575                	j	4004ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400610:	008b8493          	addi	s1,s7,8
  400614:	4681                	li	a3,0
  400616:	4629                	li	a2,10
  400618:	000ba583          	lw	a1,0(s7)
  40061c:	855a                	mv	a0,s6
  40061e:	dbdff0ef          	jal	4003da <printint>
        i += 2;
  400622:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400624:	8ba6                	mv	s7,s1
      state = 0;
  400626:	4981                	li	s3,0
        i += 2;
  400628:	bd49                	j	4004ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  40062a:	008b8493          	addi	s1,s7,8
  40062e:	4681                	li	a3,0
  400630:	4641                	li	a2,16
  400632:	000ba583          	lw	a1,0(s7)
  400636:	855a                	mv	a0,s6
  400638:	da3ff0ef          	jal	4003da <printint>
  40063c:	8ba6                	mv	s7,s1
      state = 0;
  40063e:	4981                	li	s3,0
  400640:	bdad                	j	4004ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400642:	008b8493          	addi	s1,s7,8
  400646:	4681                	li	a3,0
  400648:	4641                	li	a2,16
  40064a:	000ba583          	lw	a1,0(s7)
  40064e:	855a                	mv	a0,s6
  400650:	d8bff0ef          	jal	4003da <printint>
        i += 1;
  400654:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400656:	8ba6                	mv	s7,s1
      state = 0;
  400658:	4981                	li	s3,0
        i += 1;
  40065a:	b585                	j	4004ba <vprintf+0x4a>
  40065c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  40065e:	008b8d13          	addi	s10,s7,8
  400662:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400666:	03000593          	li	a1,48
  40066a:	855a                	mv	a0,s6
  40066c:	d51ff0ef          	jal	4003bc <putc>
  putc(fd, 'x');
  400670:	07800593          	li	a1,120
  400674:	855a                	mv	a0,s6
  400676:	d47ff0ef          	jal	4003bc <putc>
  40067a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  40067c:	00000b97          	auipc	s7,0x0
  400680:	294b8b93          	addi	s7,s7,660 # 400910 <digits>
  400684:	03c9d793          	srli	a5,s3,0x3c
  400688:	97de                	add	a5,a5,s7
  40068a:	0007c583          	lbu	a1,0(a5)
  40068e:	855a                	mv	a0,s6
  400690:	d2dff0ef          	jal	4003bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400694:	0992                	slli	s3,s3,0x4
  400696:	34fd                	addiw	s1,s1,-1
  400698:	f4f5                	bnez	s1,400684 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  40069a:	8bea                	mv	s7,s10
      state = 0;
  40069c:	4981                	li	s3,0
  40069e:	6d02                	ld	s10,0(sp)
  4006a0:	bd29                	j	4004ba <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  4006a2:	008b8993          	addi	s3,s7,8
  4006a6:	000bb483          	ld	s1,0(s7)
  4006aa:	cc91                	beqz	s1,4006c6 <vprintf+0x256>
        for(; *s; s++)
  4006ac:	0004c583          	lbu	a1,0(s1)
  4006b0:	c195                	beqz	a1,4006d4 <vprintf+0x264>
          putc(fd, *s);
  4006b2:	855a                	mv	a0,s6
  4006b4:	d09ff0ef          	jal	4003bc <putc>
        for(; *s; s++)
  4006b8:	0485                	addi	s1,s1,1
  4006ba:	0004c583          	lbu	a1,0(s1)
  4006be:	f9f5                	bnez	a1,4006b2 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006c0:	8bce                	mv	s7,s3
      state = 0;
  4006c2:	4981                	li	s3,0
  4006c4:	bbdd                	j	4004ba <vprintf+0x4a>
          s = "(null)";
  4006c6:	00000497          	auipc	s1,0x0
  4006ca:	24248493          	addi	s1,s1,578 # 400908 <malloc+0x12e>
        for(; *s; s++)
  4006ce:	02800593          	li	a1,40
  4006d2:	b7c5                	j	4006b2 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4006d4:	8bce                	mv	s7,s3
      state = 0;
  4006d6:	4981                	li	s3,0
  4006d8:	b3cd                	j	4004ba <vprintf+0x4a>
  4006da:	6906                	ld	s2,64(sp)
  4006dc:	79e2                	ld	s3,56(sp)
  4006de:	7a42                	ld	s4,48(sp)
  4006e0:	7aa2                	ld	s5,40(sp)
  4006e2:	7b02                	ld	s6,32(sp)
  4006e4:	6be2                	ld	s7,24(sp)
  4006e6:	6c42                	ld	s8,16(sp)
  4006e8:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4006ea:	60e6                	ld	ra,88(sp)
  4006ec:	6446                	ld	s0,80(sp)
  4006ee:	64a6                	ld	s1,72(sp)
  4006f0:	6125                	addi	sp,sp,96
  4006f2:	8082                	ret

00000000004006f4 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4006f4:	715d                	addi	sp,sp,-80
  4006f6:	ec06                	sd	ra,24(sp)
  4006f8:	e822                	sd	s0,16(sp)
  4006fa:	1000                	addi	s0,sp,32
  4006fc:	e010                	sd	a2,0(s0)
  4006fe:	e414                	sd	a3,8(s0)
  400700:	e818                	sd	a4,16(s0)
  400702:	ec1c                	sd	a5,24(s0)
  400704:	03043023          	sd	a6,32(s0)
  400708:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  40070c:	8622                	mv	a2,s0
  40070e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400712:	d5fff0ef          	jal	400470 <vprintf>
  return 0;
}
  400716:	4501                	li	a0,0
  400718:	60e2                	ld	ra,24(sp)
  40071a:	6442                	ld	s0,16(sp)
  40071c:	6161                	addi	sp,sp,80
  40071e:	8082                	ret

0000000000400720 <printf>:

int
printf(const char *fmt, ...)
{
  400720:	711d                	addi	sp,sp,-96
  400722:	ec06                	sd	ra,24(sp)
  400724:	e822                	sd	s0,16(sp)
  400726:	1000                	addi	s0,sp,32
  400728:	e40c                	sd	a1,8(s0)
  40072a:	e810                	sd	a2,16(s0)
  40072c:	ec14                	sd	a3,24(s0)
  40072e:	f018                	sd	a4,32(s0)
  400730:	f41c                	sd	a5,40(s0)
  400732:	03043823          	sd	a6,48(s0)
  400736:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  40073a:	00840613          	addi	a2,s0,8
  40073e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400742:	85aa                	mv	a1,a0
  400744:	4505                	li	a0,1
  400746:	d2bff0ef          	jal	400470 <vprintf>
  return 0;
}
  40074a:	4501                	li	a0,0
  40074c:	60e2                	ld	ra,24(sp)
  40074e:	6442                	ld	s0,16(sp)
  400750:	6125                	addi	sp,sp,96
  400752:	8082                	ret

0000000000400754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  400754:	1141                	addi	sp,sp,-16
  400756:	e406                	sd	ra,8(sp)
  400758:	e022                	sd	s0,0(sp)
  40075a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  40075c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400760:	00001797          	auipc	a5,0x1
  400764:	8a07b783          	ld	a5,-1888(a5) # 401000 <freep>
  400768:	a02d                	j	400792 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  40076a:	4618                	lw	a4,8(a2)
  40076c:	9f2d                	addw	a4,a4,a1
  40076e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400772:	6398                	ld	a4,0(a5)
  400774:	6310                	ld	a2,0(a4)
  400776:	a83d                	j	4007b4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400778:	ff852703          	lw	a4,-8(a0)
  40077c:	9f31                	addw	a4,a4,a2
  40077e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400780:	ff053683          	ld	a3,-16(a0)
  400784:	a091                	j	4007c8 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400786:	6398                	ld	a4,0(a5)
  400788:	00e7e463          	bltu	a5,a4,400790 <free+0x3c>
  40078c:	00e6ea63          	bltu	a3,a4,4007a0 <free+0x4c>
{
  400790:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400792:	fed7fae3          	bgeu	a5,a3,400786 <free+0x32>
  400796:	6398                	ld	a4,0(a5)
  400798:	00e6e463          	bltu	a3,a4,4007a0 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40079c:	fee7eae3          	bltu	a5,a4,400790 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4007a0:	ff852583          	lw	a1,-8(a0)
  4007a4:	6390                	ld	a2,0(a5)
  4007a6:	02059813          	slli	a6,a1,0x20
  4007aa:	01c85713          	srli	a4,a6,0x1c
  4007ae:	9736                	add	a4,a4,a3
  4007b0:	fae60de3          	beq	a2,a4,40076a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4007b4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4007b8:	4790                	lw	a2,8(a5)
  4007ba:	02061593          	slli	a1,a2,0x20
  4007be:	01c5d713          	srli	a4,a1,0x1c
  4007c2:	973e                	add	a4,a4,a5
  4007c4:	fae68ae3          	beq	a3,a4,400778 <free+0x24>
    p->s.ptr = bp->s.ptr;
  4007c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4007ca:	00001717          	auipc	a4,0x1
  4007ce:	82f73b23          	sd	a5,-1994(a4) # 401000 <freep>
}
  4007d2:	60a2                	ld	ra,8(sp)
  4007d4:	6402                	ld	s0,0(sp)
  4007d6:	0141                	addi	sp,sp,16
  4007d8:	8082                	ret

00000000004007da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4007da:	7139                	addi	sp,sp,-64
  4007dc:	fc06                	sd	ra,56(sp)
  4007de:	f822                	sd	s0,48(sp)
  4007e0:	f04a                	sd	s2,32(sp)
  4007e2:	ec4e                	sd	s3,24(sp)
  4007e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4007e6:	02051993          	slli	s3,a0,0x20
  4007ea:	0209d993          	srli	s3,s3,0x20
  4007ee:	09bd                	addi	s3,s3,15
  4007f0:	0049d993          	srli	s3,s3,0x4
  4007f4:	2985                	addiw	s3,s3,1
  4007f6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4007f8:	00001517          	auipc	a0,0x1
  4007fc:	80853503          	ld	a0,-2040(a0) # 401000 <freep>
  400800:	c905                	beqz	a0,400830 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400804:	4798                	lw	a4,8(a5)
  400806:	09377663          	bgeu	a4,s3,400892 <malloc+0xb8>
  40080a:	f426                	sd	s1,40(sp)
  40080c:	e852                	sd	s4,16(sp)
  40080e:	e456                	sd	s5,8(sp)
  400810:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400812:	8a4e                	mv	s4,s3
  400814:	6705                	lui	a4,0x1
  400816:	00e9f363          	bgeu	s3,a4,40081c <malloc+0x42>
  40081a:	6a05                	lui	s4,0x1
  40081c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400820:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  400824:	00000497          	auipc	s1,0x0
  400828:	7dc48493          	addi	s1,s1,2012 # 401000 <freep>
  if(p == (char*)-1)
  40082c:	5afd                	li	s5,-1
  40082e:	a83d                	j	40086c <malloc+0x92>
  400830:	f426                	sd	s1,40(sp)
  400832:	e852                	sd	s4,16(sp)
  400834:	e456                	sd	s5,8(sp)
  400836:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  400838:	00000797          	auipc	a5,0x0
  40083c:	7d878793          	addi	a5,a5,2008 # 401010 <base>
  400840:	00000717          	auipc	a4,0x0
  400844:	7cf73023          	sd	a5,1984(a4) # 401000 <freep>
  400848:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  40084a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  40084e:	b7d1                	j	400812 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400850:	6398                	ld	a4,0(a5)
  400852:	e118                	sd	a4,0(a0)
  400854:	a899                	j	4008aa <malloc+0xd0>
  hp->s.size = nu;
  400856:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  40085a:	0541                	addi	a0,a0,16
  40085c:	ef9ff0ef          	jal	400754 <free>
  return freep;
  400860:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  400862:	c125                	beqz	a0,4008c2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400866:	4798                	lw	a4,8(a5)
  400868:	03277163          	bgeu	a4,s2,40088a <malloc+0xb0>
    if(p == freep)
  40086c:	6098                	ld	a4,0(s1)
  40086e:	853e                	mv	a0,a5
  400870:	fef71ae3          	bne	a4,a5,400864 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400874:	8552                	mv	a0,s4
  400876:	b17ff0ef          	jal	40038c <sbrk>
  if(p == (char*)-1)
  40087a:	fd551ee3          	bne	a0,s5,400856 <malloc+0x7c>
        return 0;
  40087e:	4501                	li	a0,0
  400880:	74a2                	ld	s1,40(sp)
  400882:	6a42                	ld	s4,16(sp)
  400884:	6aa2                	ld	s5,8(sp)
  400886:	6b02                	ld	s6,0(sp)
  400888:	a03d                	j	4008b6 <malloc+0xdc>
  40088a:	74a2                	ld	s1,40(sp)
  40088c:	6a42                	ld	s4,16(sp)
  40088e:	6aa2                	ld	s5,8(sp)
  400890:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400892:	fae90fe3          	beq	s2,a4,400850 <malloc+0x76>
        p->s.size -= nunits;
  400896:	4137073b          	subw	a4,a4,s3
  40089a:	c798                	sw	a4,8(a5)
        p += p->s.size;
  40089c:	02071693          	slli	a3,a4,0x20
  4008a0:	01c6d713          	srli	a4,a3,0x1c
  4008a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4008a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4008aa:	00000717          	auipc	a4,0x0
  4008ae:	74a73b23          	sd	a0,1878(a4) # 401000 <freep>
      return (void*)(p + 1);
  4008b2:	01078513          	addi	a0,a5,16
  }
}
  4008b6:	70e2                	ld	ra,56(sp)
  4008b8:	7442                	ld	s0,48(sp)
  4008ba:	7902                	ld	s2,32(sp)
  4008bc:	69e2                	ld	s3,24(sp)
  4008be:	6121                	addi	sp,sp,64
  4008c0:	8082                	ret
  4008c2:	74a2                	ld	s1,40(sp)
  4008c4:	6a42                	ld	s4,16(sp)
  4008c6:	6aa2                	ld	s5,8(sp)
  4008c8:	6b02                	ld	s6,0(sp)
  4008ca:	b7f5                	j	4008b6 <malloc+0xdc>
