
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
  400000:	dc010113          	addi	sp,sp,-576
  400004:	22113c23          	sd	ra,568(sp)
  400008:	22813823          	sd	s0,560(sp)
  40000c:	22913423          	sd	s1,552(sp)
  400010:	23213023          	sd	s2,544(sp)
  400014:	21313c23          	sd	s3,536(sp)
  400018:	21413823          	sd	s4,528(sp)
  40001c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  40001e:	00001797          	auipc	a5,0x1
  400022:	96278793          	addi	a5,a5,-1694 # 400980 <malloc+0x124>
  400026:	6398                	ld	a4,0(a5)
  400028:	fce43023          	sd	a4,-64(s0)
  40002c:	0087d783          	lhu	a5,8(a5)
  400030:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  400034:	00001517          	auipc	a0,0x1
  400038:	91c50513          	addi	a0,a0,-1764 # 400950 <malloc+0xf4>
  40003c:	766000ef          	jal	4007a2 <printf>
  memset(data, 'a', sizeof(data));
  400040:	20000613          	li	a2,512
  400044:	06100593          	li	a1,97
  400048:	dc040513          	addi	a0,s0,-576
  40004c:	12c000ef          	jal	400178 <memset>

  for(i = 0; i < 4; i++)
  400050:	4481                	li	s1,0
  400052:	4911                	li	s2,4
    if(fork() > 0)
  400054:	32a000ef          	jal	40037e <fork>
  400058:	00a04563          	bgtz	a0,400062 <main+0x62>
  for(i = 0; i < 4; i++)
  40005c:	2485                	addiw	s1,s1,1
  40005e:	ff249be3          	bne	s1,s2,400054 <main+0x54>
      break;

  printf("write %d\n", i);
  400062:	85a6                	mv	a1,s1
  400064:	00001517          	auipc	a0,0x1
  400068:	90450513          	addi	a0,a0,-1788 # 400968 <malloc+0x10c>
  40006c:	736000ef          	jal	4007a2 <printf>

  path[8] += i;
  400070:	fc844783          	lbu	a5,-56(s0)
  400074:	9fa5                	addw	a5,a5,s1
  400076:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  40007a:	20200593          	li	a1,514
  40007e:	fc040513          	addi	a0,s0,-64
  400082:	344000ef          	jal	4003c6 <open>
  400086:	892a                	mv	s2,a0
  400088:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  40008a:	dc040a13          	addi	s4,s0,-576
  40008e:	20000993          	li	s3,512
  400092:	864e                	mv	a2,s3
  400094:	85d2                	mv	a1,s4
  400096:	854a                	mv	a0,s2
  400098:	30e000ef          	jal	4003a6 <write>
  for(i = 0; i < 20; i++)
  40009c:	34fd                	addiw	s1,s1,-1
  40009e:	f8f5                	bnez	s1,400092 <main+0x92>
  close(fd);
  4000a0:	854a                	mv	a0,s2
  4000a2:	30c000ef          	jal	4003ae <close>

  printf("read\n");
  4000a6:	00001517          	auipc	a0,0x1
  4000aa:	8d250513          	addi	a0,a0,-1838 # 400978 <malloc+0x11c>
  4000ae:	6f4000ef          	jal	4007a2 <printf>

  fd = open(path, O_RDONLY);
  4000b2:	4581                	li	a1,0
  4000b4:	fc040513          	addi	a0,s0,-64
  4000b8:	30e000ef          	jal	4003c6 <open>
  4000bc:	892a                	mv	s2,a0
  4000be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  4000c0:	dc040a13          	addi	s4,s0,-576
  4000c4:	20000993          	li	s3,512
  4000c8:	864e                	mv	a2,s3
  4000ca:	85d2                	mv	a1,s4
  4000cc:	854a                	mv	a0,s2
  4000ce:	2d0000ef          	jal	40039e <read>
  for (i = 0; i < 20; i++)
  4000d2:	34fd                	addiw	s1,s1,-1
  4000d4:	f8f5                	bnez	s1,4000c8 <main+0xc8>
  close(fd);
  4000d6:	854a                	mv	a0,s2
  4000d8:	2d6000ef          	jal	4003ae <close>

  wait(0);
  4000dc:	4501                	li	a0,0
  4000de:	2b0000ef          	jal	40038e <wait>

  exit(0);
  4000e2:	4501                	li	a0,0
  4000e4:	2a2000ef          	jal	400386 <exit>

00000000004000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4000e8:	1141                	addi	sp,sp,-16
  4000ea:	e406                	sd	ra,8(sp)
  4000ec:	e022                	sd	s0,0(sp)
  4000ee:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4000f0:	f11ff0ef          	jal	400000 <main>
  exit(0);
  4000f4:	4501                	li	a0,0
  4000f6:	290000ef          	jal	400386 <exit>

00000000004000fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  4000fa:	1141                	addi	sp,sp,-16
  4000fc:	e406                	sd	ra,8(sp)
  4000fe:	e022                	sd	s0,0(sp)
  400100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400102:	87aa                	mv	a5,a0
  400104:	0585                	addi	a1,a1,1
  400106:	0785                	addi	a5,a5,1
  400108:	fff5c703          	lbu	a4,-1(a1)
  40010c:	fee78fa3          	sb	a4,-1(a5)
  400110:	fb75                	bnez	a4,400104 <strcpy+0xa>
    ;
  return os;
}
  400112:	60a2                	ld	ra,8(sp)
  400114:	6402                	ld	s0,0(sp)
  400116:	0141                	addi	sp,sp,16
  400118:	8082                	ret

000000000040011a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40011a:	1141                	addi	sp,sp,-16
  40011c:	e406                	sd	ra,8(sp)
  40011e:	e022                	sd	s0,0(sp)
  400120:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  400122:	00054783          	lbu	a5,0(a0)
  400126:	cb91                	beqz	a5,40013a <strcmp+0x20>
  400128:	0005c703          	lbu	a4,0(a1)
  40012c:	00f71763          	bne	a4,a5,40013a <strcmp+0x20>
    p++, q++;
  400130:	0505                	addi	a0,a0,1
  400132:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  400134:	00054783          	lbu	a5,0(a0)
  400138:	fbe5                	bnez	a5,400128 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  40013a:	0005c503          	lbu	a0,0(a1)
}
  40013e:	40a7853b          	subw	a0,a5,a0
  400142:	60a2                	ld	ra,8(sp)
  400144:	6402                	ld	s0,0(sp)
  400146:	0141                	addi	sp,sp,16
  400148:	8082                	ret

000000000040014a <strlen>:

uint
strlen(const char *s)
{
  40014a:	1141                	addi	sp,sp,-16
  40014c:	e406                	sd	ra,8(sp)
  40014e:	e022                	sd	s0,0(sp)
  400150:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  400152:	00054783          	lbu	a5,0(a0)
  400156:	cf99                	beqz	a5,400174 <strlen+0x2a>
  400158:	0505                	addi	a0,a0,1
  40015a:	87aa                	mv	a5,a0
  40015c:	86be                	mv	a3,a5
  40015e:	0785                	addi	a5,a5,1
  400160:	fff7c703          	lbu	a4,-1(a5)
  400164:	ff65                	bnez	a4,40015c <strlen+0x12>
  400166:	40a6853b          	subw	a0,a3,a0
  40016a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  40016c:	60a2                	ld	ra,8(sp)
  40016e:	6402                	ld	s0,0(sp)
  400170:	0141                	addi	sp,sp,16
  400172:	8082                	ret
  for(n = 0; s[n]; n++)
  400174:	4501                	li	a0,0
  400176:	bfdd                	j	40016c <strlen+0x22>

0000000000400178 <memset>:

void*
memset(void *dst, int c, uint n)
{
  400178:	1141                	addi	sp,sp,-16
  40017a:	e406                	sd	ra,8(sp)
  40017c:	e022                	sd	s0,0(sp)
  40017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400180:	ca19                	beqz	a2,400196 <memset+0x1e>
  400182:	87aa                	mv	a5,a0
  400184:	1602                	slli	a2,a2,0x20
  400186:	9201                	srli	a2,a2,0x20
  400188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  40018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400190:	0785                	addi	a5,a5,1
  400192:	fee79de3          	bne	a5,a4,40018c <memset+0x14>
  }
  return dst;
}
  400196:	60a2                	ld	ra,8(sp)
  400198:	6402                	ld	s0,0(sp)
  40019a:	0141                	addi	sp,sp,16
  40019c:	8082                	ret

000000000040019e <strchr>:

char*
strchr(const char *s, char c)
{
  40019e:	1141                	addi	sp,sp,-16
  4001a0:	e406                	sd	ra,8(sp)
  4001a2:	e022                	sd	s0,0(sp)
  4001a4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  4001a6:	00054783          	lbu	a5,0(a0)
  4001aa:	cf81                	beqz	a5,4001c2 <strchr+0x24>
    if(*s == c)
  4001ac:	00f58763          	beq	a1,a5,4001ba <strchr+0x1c>
  for(; *s; s++)
  4001b0:	0505                	addi	a0,a0,1
  4001b2:	00054783          	lbu	a5,0(a0)
  4001b6:	fbfd                	bnez	a5,4001ac <strchr+0xe>
      return (char*)s;
  return 0;
  4001b8:	4501                	li	a0,0
}
  4001ba:	60a2                	ld	ra,8(sp)
  4001bc:	6402                	ld	s0,0(sp)
  4001be:	0141                	addi	sp,sp,16
  4001c0:	8082                	ret
  return 0;
  4001c2:	4501                	li	a0,0
  4001c4:	bfdd                	j	4001ba <strchr+0x1c>

00000000004001c6 <gets>:

char*
gets(char *buf, int max)
{
  4001c6:	7159                	addi	sp,sp,-112
  4001c8:	f486                	sd	ra,104(sp)
  4001ca:	f0a2                	sd	s0,96(sp)
  4001cc:	eca6                	sd	s1,88(sp)
  4001ce:	e8ca                	sd	s2,80(sp)
  4001d0:	e4ce                	sd	s3,72(sp)
  4001d2:	e0d2                	sd	s4,64(sp)
  4001d4:	fc56                	sd	s5,56(sp)
  4001d6:	f85a                	sd	s6,48(sp)
  4001d8:	f45e                	sd	s7,40(sp)
  4001da:	f062                	sd	s8,32(sp)
  4001dc:	ec66                	sd	s9,24(sp)
  4001de:	e86a                	sd	s10,16(sp)
  4001e0:	1880                	addi	s0,sp,112
  4001e2:	8caa                	mv	s9,a0
  4001e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  4001e6:	892a                	mv	s2,a0
  4001e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
  4001ea:	f9f40b13          	addi	s6,s0,-97
  4001ee:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  4001f0:	4ba9                	li	s7,10
  4001f2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  4001f4:	8d26                	mv	s10,s1
  4001f6:	0014899b          	addiw	s3,s1,1
  4001fa:	84ce                	mv	s1,s3
  4001fc:	0349d563          	bge	s3,s4,400226 <gets+0x60>
    cc = read(0, &c, 1);
  400200:	8656                	mv	a2,s5
  400202:	85da                	mv	a1,s6
  400204:	4501                	li	a0,0
  400206:	198000ef          	jal	40039e <read>
    if(cc < 1)
  40020a:	00a05e63          	blez	a0,400226 <gets+0x60>
    buf[i++] = c;
  40020e:	f9f44783          	lbu	a5,-97(s0)
  400212:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400216:	01778763          	beq	a5,s7,400224 <gets+0x5e>
  40021a:	0905                	addi	s2,s2,1
  40021c:	fd879ce3          	bne	a5,s8,4001f4 <gets+0x2e>
    buf[i++] = c;
  400220:	8d4e                	mv	s10,s3
  400222:	a011                	j	400226 <gets+0x60>
  400224:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  400226:	9d66                	add	s10,s10,s9
  400228:	000d0023          	sb	zero,0(s10)
  return buf;
}
  40022c:	8566                	mv	a0,s9
  40022e:	70a6                	ld	ra,104(sp)
  400230:	7406                	ld	s0,96(sp)
  400232:	64e6                	ld	s1,88(sp)
  400234:	6946                	ld	s2,80(sp)
  400236:	69a6                	ld	s3,72(sp)
  400238:	6a06                	ld	s4,64(sp)
  40023a:	7ae2                	ld	s5,56(sp)
  40023c:	7b42                	ld	s6,48(sp)
  40023e:	7ba2                	ld	s7,40(sp)
  400240:	7c02                	ld	s8,32(sp)
  400242:	6ce2                	ld	s9,24(sp)
  400244:	6d42                	ld	s10,16(sp)
  400246:	6165                	addi	sp,sp,112
  400248:	8082                	ret

000000000040024a <stat>:

int
stat(const char *n, struct stat *st)
{
  40024a:	1101                	addi	sp,sp,-32
  40024c:	ec06                	sd	ra,24(sp)
  40024e:	e822                	sd	s0,16(sp)
  400250:	e04a                	sd	s2,0(sp)
  400252:	1000                	addi	s0,sp,32
  400254:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  400256:	4581                	li	a1,0
  400258:	16e000ef          	jal	4003c6 <open>
  if(fd < 0)
  40025c:	02054263          	bltz	a0,400280 <stat+0x36>
  400260:	e426                	sd	s1,8(sp)
  400262:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  400264:	85ca                	mv	a1,s2
  400266:	178000ef          	jal	4003de <fstat>
  40026a:	892a                	mv	s2,a0
  close(fd);
  40026c:	8526                	mv	a0,s1
  40026e:	140000ef          	jal	4003ae <close>
  return r;
  400272:	64a2                	ld	s1,8(sp)
}
  400274:	854a                	mv	a0,s2
  400276:	60e2                	ld	ra,24(sp)
  400278:	6442                	ld	s0,16(sp)
  40027a:	6902                	ld	s2,0(sp)
  40027c:	6105                	addi	sp,sp,32
  40027e:	8082                	ret
    return -1;
  400280:	597d                	li	s2,-1
  400282:	bfcd                	j	400274 <stat+0x2a>

0000000000400284 <atoi>:

int
atoi(const char *s)
{
  400284:	1141                	addi	sp,sp,-16
  400286:	e406                	sd	ra,8(sp)
  400288:	e022                	sd	s0,0(sp)
  40028a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  40028c:	00054683          	lbu	a3,0(a0)
  400290:	fd06879b          	addiw	a5,a3,-48
  400294:	0ff7f793          	zext.b	a5,a5
  400298:	4625                	li	a2,9
  40029a:	02f66963          	bltu	a2,a5,4002cc <atoi+0x48>
  40029e:	872a                	mv	a4,a0
  n = 0;
  4002a0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  4002a2:	0705                	addi	a4,a4,1
  4002a4:	0025179b          	slliw	a5,a0,0x2
  4002a8:	9fa9                	addw	a5,a5,a0
  4002aa:	0017979b          	slliw	a5,a5,0x1
  4002ae:	9fb5                	addw	a5,a5,a3
  4002b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  4002b4:	00074683          	lbu	a3,0(a4)
  4002b8:	fd06879b          	addiw	a5,a3,-48
  4002bc:	0ff7f793          	zext.b	a5,a5
  4002c0:	fef671e3          	bgeu	a2,a5,4002a2 <atoi+0x1e>
  return n;
}
  4002c4:	60a2                	ld	ra,8(sp)
  4002c6:	6402                	ld	s0,0(sp)
  4002c8:	0141                	addi	sp,sp,16
  4002ca:	8082                	ret
  n = 0;
  4002cc:	4501                	li	a0,0
  4002ce:	bfdd                	j	4002c4 <atoi+0x40>

00000000004002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  4002d0:	1141                	addi	sp,sp,-16
  4002d2:	e406                	sd	ra,8(sp)
  4002d4:	e022                	sd	s0,0(sp)
  4002d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  4002d8:	02b57563          	bgeu	a0,a1,400302 <memmove+0x32>
    while(n-- > 0)
  4002dc:	00c05f63          	blez	a2,4002fa <memmove+0x2a>
  4002e0:	1602                	slli	a2,a2,0x20
  4002e2:	9201                	srli	a2,a2,0x20
  4002e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  4002e8:	872a                	mv	a4,a0
      *dst++ = *src++;
  4002ea:	0585                	addi	a1,a1,1
  4002ec:	0705                	addi	a4,a4,1
  4002ee:	fff5c683          	lbu	a3,-1(a1)
  4002f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  4002f6:	fee79ae3          	bne	a5,a4,4002ea <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  4002fa:	60a2                	ld	ra,8(sp)
  4002fc:	6402                	ld	s0,0(sp)
  4002fe:	0141                	addi	sp,sp,16
  400300:	8082                	ret
    dst += n;
  400302:	00c50733          	add	a4,a0,a2
    src += n;
  400306:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400308:	fec059e3          	blez	a2,4002fa <memmove+0x2a>
  40030c:	fff6079b          	addiw	a5,a2,-1
  400310:	1782                	slli	a5,a5,0x20
  400312:	9381                	srli	a5,a5,0x20
  400314:	fff7c793          	not	a5,a5
  400318:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  40031a:	15fd                	addi	a1,a1,-1
  40031c:	177d                	addi	a4,a4,-1
  40031e:	0005c683          	lbu	a3,0(a1)
  400322:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  400326:	fef71ae3          	bne	a4,a5,40031a <memmove+0x4a>
  40032a:	bfc1                	j	4002fa <memmove+0x2a>

000000000040032c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  40032c:	1141                	addi	sp,sp,-16
  40032e:	e406                	sd	ra,8(sp)
  400330:	e022                	sd	s0,0(sp)
  400332:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  400334:	ca0d                	beqz	a2,400366 <memcmp+0x3a>
  400336:	fff6069b          	addiw	a3,a2,-1
  40033a:	1682                	slli	a3,a3,0x20
  40033c:	9281                	srli	a3,a3,0x20
  40033e:	0685                	addi	a3,a3,1
  400340:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  400342:	00054783          	lbu	a5,0(a0)
  400346:	0005c703          	lbu	a4,0(a1)
  40034a:	00e79863          	bne	a5,a4,40035a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  40034e:	0505                	addi	a0,a0,1
    p2++;
  400350:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  400352:	fed518e3          	bne	a0,a3,400342 <memcmp+0x16>
  }
  return 0;
  400356:	4501                	li	a0,0
  400358:	a019                	j	40035e <memcmp+0x32>
      return *p1 - *p2;
  40035a:	40e7853b          	subw	a0,a5,a4
}
  40035e:	60a2                	ld	ra,8(sp)
  400360:	6402                	ld	s0,0(sp)
  400362:	0141                	addi	sp,sp,16
  400364:	8082                	ret
  return 0;
  400366:	4501                	li	a0,0
  400368:	bfdd                	j	40035e <memcmp+0x32>

000000000040036a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  40036a:	1141                	addi	sp,sp,-16
  40036c:	e406                	sd	ra,8(sp)
  40036e:	e022                	sd	s0,0(sp)
  400370:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400372:	f5fff0ef          	jal	4002d0 <memmove>
}
  400376:	60a2                	ld	ra,8(sp)
  400378:	6402                	ld	s0,0(sp)
  40037a:	0141                	addi	sp,sp,16
  40037c:	8082                	ret

000000000040037e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  40037e:	4885                	li	a7,1
 ecall
  400380:	00000073          	ecall
 ret
  400384:	8082                	ret

0000000000400386 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400386:	4889                	li	a7,2
 ecall
  400388:	00000073          	ecall
 ret
  40038c:	8082                	ret

000000000040038e <wait>:
.global wait
wait:
 li a7, SYS_wait
  40038e:	488d                	li	a7,3
 ecall
  400390:	00000073          	ecall
 ret
  400394:	8082                	ret

0000000000400396 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400396:	4891                	li	a7,4
 ecall
  400398:	00000073          	ecall
 ret
  40039c:	8082                	ret

000000000040039e <read>:
.global read
read:
 li a7, SYS_read
  40039e:	4895                	li	a7,5
 ecall
  4003a0:	00000073          	ecall
 ret
  4003a4:	8082                	ret

00000000004003a6 <write>:
.global write
write:
 li a7, SYS_write
  4003a6:	48c1                	li	a7,16
 ecall
  4003a8:	00000073          	ecall
 ret
  4003ac:	8082                	ret

00000000004003ae <close>:
.global close
close:
 li a7, SYS_close
  4003ae:	48d5                	li	a7,21
 ecall
  4003b0:	00000073          	ecall
 ret
  4003b4:	8082                	ret

00000000004003b6 <kill>:
.global kill
kill:
 li a7, SYS_kill
  4003b6:	4899                	li	a7,6
 ecall
  4003b8:	00000073          	ecall
 ret
  4003bc:	8082                	ret

00000000004003be <exec>:
.global exec
exec:
 li a7, SYS_exec
  4003be:	489d                	li	a7,7
 ecall
  4003c0:	00000073          	ecall
 ret
  4003c4:	8082                	ret

00000000004003c6 <open>:
.global open
open:
 li a7, SYS_open
  4003c6:	48bd                	li	a7,15
 ecall
  4003c8:	00000073          	ecall
 ret
  4003cc:	8082                	ret

00000000004003ce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  4003ce:	48c5                	li	a7,17
 ecall
  4003d0:	00000073          	ecall
 ret
  4003d4:	8082                	ret

00000000004003d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  4003d6:	48c9                	li	a7,18
 ecall
  4003d8:	00000073          	ecall
 ret
  4003dc:	8082                	ret

00000000004003de <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  4003de:	48a1                	li	a7,8
 ecall
  4003e0:	00000073          	ecall
 ret
  4003e4:	8082                	ret

00000000004003e6 <link>:
.global link
link:
 li a7, SYS_link
  4003e6:	48cd                	li	a7,19
 ecall
  4003e8:	00000073          	ecall
 ret
  4003ec:	8082                	ret

00000000004003ee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  4003ee:	48d1                	li	a7,20
 ecall
  4003f0:	00000073          	ecall
 ret
  4003f4:	8082                	ret

00000000004003f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  4003f6:	48a5                	li	a7,9
 ecall
  4003f8:	00000073          	ecall
 ret
  4003fc:	8082                	ret

00000000004003fe <dup>:
.global dup
dup:
 li a7, SYS_dup
  4003fe:	48a9                	li	a7,10
 ecall
  400400:	00000073          	ecall
 ret
  400404:	8082                	ret

0000000000400406 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400406:	48ad                	li	a7,11
 ecall
  400408:	00000073          	ecall
 ret
  40040c:	8082                	ret

000000000040040e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  40040e:	48b1                	li	a7,12
 ecall
  400410:	00000073          	ecall
 ret
  400414:	8082                	ret

0000000000400416 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400416:	48b5                	li	a7,13
 ecall
  400418:	00000073          	ecall
 ret
  40041c:	8082                	ret

000000000040041e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  40041e:	48b9                	li	a7,14
 ecall
  400420:	00000073          	ecall
 ret
  400424:	8082                	ret

0000000000400426 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  400426:	48d9                	li	a7,22
 ecall
  400428:	00000073          	ecall
 ret
  40042c:	8082                	ret

000000000040042e <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  40042e:	48dd                	li	a7,23
 ecall
  400430:	00000073          	ecall
 ret
  400434:	8082                	ret

0000000000400436 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  400436:	48e1                	li	a7,24
 ecall
  400438:	00000073          	ecall
 ret
  40043c:	8082                	ret

000000000040043e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  40043e:	1101                	addi	sp,sp,-32
  400440:	ec06                	sd	ra,24(sp)
  400442:	e822                	sd	s0,16(sp)
  400444:	1000                	addi	s0,sp,32
  400446:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  40044a:	4605                	li	a2,1
  40044c:	fef40593          	addi	a1,s0,-17
  400450:	f57ff0ef          	jal	4003a6 <write>
}
  400454:	60e2                	ld	ra,24(sp)
  400456:	6442                	ld	s0,16(sp)
  400458:	6105                	addi	sp,sp,32
  40045a:	8082                	ret

000000000040045c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  40045c:	7139                	addi	sp,sp,-64
  40045e:	fc06                	sd	ra,56(sp)
  400460:	f822                	sd	s0,48(sp)
  400462:	f426                	sd	s1,40(sp)
  400464:	f04a                	sd	s2,32(sp)
  400466:	ec4e                	sd	s3,24(sp)
  400468:	0080                	addi	s0,sp,64
  40046a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  40046c:	c299                	beqz	a3,400472 <printint+0x16>
  40046e:	0605ce63          	bltz	a1,4004ea <printint+0x8e>
  neg = 0;
  400472:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400474:	fc040313          	addi	t1,s0,-64
  neg = 0;
  400478:	869a                	mv	a3,t1
  i = 0;
  40047a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  40047c:	00000817          	auipc	a6,0x0
  400480:	51c80813          	addi	a6,a6,1308 # 400998 <digits>
  400484:	88be                	mv	a7,a5
  400486:	0017851b          	addiw	a0,a5,1
  40048a:	87aa                	mv	a5,a0
  40048c:	02c5f73b          	remuw	a4,a1,a2
  400490:	1702                	slli	a4,a4,0x20
  400492:	9301                	srli	a4,a4,0x20
  400494:	9742                	add	a4,a4,a6
  400496:	00074703          	lbu	a4,0(a4)
  40049a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  40049e:	872e                	mv	a4,a1
  4004a0:	02c5d5bb          	divuw	a1,a1,a2
  4004a4:	0685                	addi	a3,a3,1
  4004a6:	fcc77fe3          	bgeu	a4,a2,400484 <printint+0x28>
  if(neg)
  4004aa:	000e0c63          	beqz	t3,4004c2 <printint+0x66>
    buf[i++] = '-';
  4004ae:	fd050793          	addi	a5,a0,-48
  4004b2:	00878533          	add	a0,a5,s0
  4004b6:	02d00793          	li	a5,45
  4004ba:	fef50823          	sb	a5,-16(a0)
  4004be:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  4004c2:	fff7899b          	addiw	s3,a5,-1
  4004c6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  4004ca:	fff4c583          	lbu	a1,-1(s1)
  4004ce:	854a                	mv	a0,s2
  4004d0:	f6fff0ef          	jal	40043e <putc>
  while(--i >= 0)
  4004d4:	39fd                	addiw	s3,s3,-1
  4004d6:	14fd                	addi	s1,s1,-1
  4004d8:	fe09d9e3          	bgez	s3,4004ca <printint+0x6e>
}
  4004dc:	70e2                	ld	ra,56(sp)
  4004de:	7442                	ld	s0,48(sp)
  4004e0:	74a2                	ld	s1,40(sp)
  4004e2:	7902                	ld	s2,32(sp)
  4004e4:	69e2                	ld	s3,24(sp)
  4004e6:	6121                	addi	sp,sp,64
  4004e8:	8082                	ret
    x = -xx;
  4004ea:	40b005bb          	negw	a1,a1
    neg = 1;
  4004ee:	4e05                	li	t3,1
    x = -xx;
  4004f0:	b751                	j	400474 <printint+0x18>

00000000004004f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  4004f2:	711d                	addi	sp,sp,-96
  4004f4:	ec86                	sd	ra,88(sp)
  4004f6:	e8a2                	sd	s0,80(sp)
  4004f8:	e4a6                	sd	s1,72(sp)
  4004fa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  4004fc:	0005c483          	lbu	s1,0(a1)
  400500:	26048663          	beqz	s1,40076c <vprintf+0x27a>
  400504:	e0ca                	sd	s2,64(sp)
  400506:	fc4e                	sd	s3,56(sp)
  400508:	f852                	sd	s4,48(sp)
  40050a:	f456                	sd	s5,40(sp)
  40050c:	f05a                	sd	s6,32(sp)
  40050e:	ec5e                	sd	s7,24(sp)
  400510:	e862                	sd	s8,16(sp)
  400512:	e466                	sd	s9,8(sp)
  400514:	8b2a                	mv	s6,a0
  400516:	8a2e                	mv	s4,a1
  400518:	8bb2                	mv	s7,a2
  state = 0;
  40051a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  40051c:	4901                	li	s2,0
  40051e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  400520:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  400524:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  400528:	06c00c93          	li	s9,108
  40052c:	a00d                	j	40054e <vprintf+0x5c>
        putc(fd, c0);
  40052e:	85a6                	mv	a1,s1
  400530:	855a                	mv	a0,s6
  400532:	f0dff0ef          	jal	40043e <putc>
  400536:	a019                	j	40053c <vprintf+0x4a>
    } else if(state == '%'){
  400538:	03598363          	beq	s3,s5,40055e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  40053c:	0019079b          	addiw	a5,s2,1
  400540:	893e                	mv	s2,a5
  400542:	873e                	mv	a4,a5
  400544:	97d2                	add	a5,a5,s4
  400546:	0007c483          	lbu	s1,0(a5)
  40054a:	20048963          	beqz	s1,40075c <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  40054e:	0004879b          	sext.w	a5,s1
    if(state == 0){
  400552:	fe0993e3          	bnez	s3,400538 <vprintf+0x46>
      if(c0 == '%'){
  400556:	fd579ce3          	bne	a5,s5,40052e <vprintf+0x3c>
        state = '%';
  40055a:	89be                	mv	s3,a5
  40055c:	b7c5                	j	40053c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  40055e:	00ea06b3          	add	a3,s4,a4
  400562:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  400566:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  400568:	c681                	beqz	a3,400570 <vprintf+0x7e>
  40056a:	9752                	add	a4,a4,s4
  40056c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  400570:	03878e63          	beq	a5,s8,4005ac <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400574:	05978863          	beq	a5,s9,4005c4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  400578:	07500713          	li	a4,117
  40057c:	0ee78263          	beq	a5,a4,400660 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400580:	07800713          	li	a4,120
  400584:	12e78463          	beq	a5,a4,4006ac <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400588:	07000713          	li	a4,112
  40058c:	14e78963          	beq	a5,a4,4006de <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400590:	07300713          	li	a4,115
  400594:	18e78863          	beq	a5,a4,400724 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400598:	02500713          	li	a4,37
  40059c:	04e79463          	bne	a5,a4,4005e4 <vprintf+0xf2>
        putc(fd, '%');
  4005a0:	85ba                	mv	a1,a4
  4005a2:	855a                	mv	a0,s6
  4005a4:	e9bff0ef          	jal	40043e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  4005a8:	4981                	li	s3,0
  4005aa:	bf49                	j	40053c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  4005ac:	008b8493          	addi	s1,s7,8
  4005b0:	4685                	li	a3,1
  4005b2:	4629                	li	a2,10
  4005b4:	000ba583          	lw	a1,0(s7)
  4005b8:	855a                	mv	a0,s6
  4005ba:	ea3ff0ef          	jal	40045c <printint>
  4005be:	8ba6                	mv	s7,s1
      state = 0;
  4005c0:	4981                	li	s3,0
  4005c2:	bfad                	j	40053c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  4005c4:	06400793          	li	a5,100
  4005c8:	02f68963          	beq	a3,a5,4005fa <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4005cc:	06c00793          	li	a5,108
  4005d0:	04f68263          	beq	a3,a5,400614 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  4005d4:	07500793          	li	a5,117
  4005d8:	0af68063          	beq	a3,a5,400678 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  4005dc:	07800793          	li	a5,120
  4005e0:	0ef68263          	beq	a3,a5,4006c4 <vprintf+0x1d2>
        putc(fd, '%');
  4005e4:	02500593          	li	a1,37
  4005e8:	855a                	mv	a0,s6
  4005ea:	e55ff0ef          	jal	40043e <putc>
        putc(fd, c0);
  4005ee:	85a6                	mv	a1,s1
  4005f0:	855a                	mv	a0,s6
  4005f2:	e4dff0ef          	jal	40043e <putc>
      state = 0;
  4005f6:	4981                	li	s3,0
  4005f8:	b791                	j	40053c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4005fa:	008b8493          	addi	s1,s7,8
  4005fe:	4685                	li	a3,1
  400600:	4629                	li	a2,10
  400602:	000ba583          	lw	a1,0(s7)
  400606:	855a                	mv	a0,s6
  400608:	e55ff0ef          	jal	40045c <printint>
        i += 1;
  40060c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  40060e:	8ba6                	mv	s7,s1
      state = 0;
  400610:	4981                	li	s3,0
        i += 1;
  400612:	b72d                	j	40053c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400614:	06400793          	li	a5,100
  400618:	02f60763          	beq	a2,a5,400646 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  40061c:	07500793          	li	a5,117
  400620:	06f60963          	beq	a2,a5,400692 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  400624:	07800793          	li	a5,120
  400628:	faf61ee3          	bne	a2,a5,4005e4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  40062c:	008b8493          	addi	s1,s7,8
  400630:	4681                	li	a3,0
  400632:	4641                	li	a2,16
  400634:	000ba583          	lw	a1,0(s7)
  400638:	855a                	mv	a0,s6
  40063a:	e23ff0ef          	jal	40045c <printint>
        i += 2;
  40063e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  400640:	8ba6                	mv	s7,s1
      state = 0;
  400642:	4981                	li	s3,0
        i += 2;
  400644:	bde5                	j	40053c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400646:	008b8493          	addi	s1,s7,8
  40064a:	4685                	li	a3,1
  40064c:	4629                	li	a2,10
  40064e:	000ba583          	lw	a1,0(s7)
  400652:	855a                	mv	a0,s6
  400654:	e09ff0ef          	jal	40045c <printint>
        i += 2;
  400658:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  40065a:	8ba6                	mv	s7,s1
      state = 0;
  40065c:	4981                	li	s3,0
        i += 2;
  40065e:	bdf9                	j	40053c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  400660:	008b8493          	addi	s1,s7,8
  400664:	4681                	li	a3,0
  400666:	4629                	li	a2,10
  400668:	000ba583          	lw	a1,0(s7)
  40066c:	855a                	mv	a0,s6
  40066e:	defff0ef          	jal	40045c <printint>
  400672:	8ba6                	mv	s7,s1
      state = 0;
  400674:	4981                	li	s3,0
  400676:	b5d9                	j	40053c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400678:	008b8493          	addi	s1,s7,8
  40067c:	4681                	li	a3,0
  40067e:	4629                	li	a2,10
  400680:	000ba583          	lw	a1,0(s7)
  400684:	855a                	mv	a0,s6
  400686:	dd7ff0ef          	jal	40045c <printint>
        i += 1;
  40068a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  40068c:	8ba6                	mv	s7,s1
      state = 0;
  40068e:	4981                	li	s3,0
        i += 1;
  400690:	b575                	j	40053c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400692:	008b8493          	addi	s1,s7,8
  400696:	4681                	li	a3,0
  400698:	4629                	li	a2,10
  40069a:	000ba583          	lw	a1,0(s7)
  40069e:	855a                	mv	a0,s6
  4006a0:	dbdff0ef          	jal	40045c <printint>
        i += 2;
  4006a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006a6:	8ba6                	mv	s7,s1
      state = 0;
  4006a8:	4981                	li	s3,0
        i += 2;
  4006aa:	bd49                	j	40053c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  4006ac:	008b8493          	addi	s1,s7,8
  4006b0:	4681                	li	a3,0
  4006b2:	4641                	li	a2,16
  4006b4:	000ba583          	lw	a1,0(s7)
  4006b8:	855a                	mv	a0,s6
  4006ba:	da3ff0ef          	jal	40045c <printint>
  4006be:	8ba6                	mv	s7,s1
      state = 0;
  4006c0:	4981                	li	s3,0
  4006c2:	bdad                	j	40053c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006c4:	008b8493          	addi	s1,s7,8
  4006c8:	4681                	li	a3,0
  4006ca:	4641                	li	a2,16
  4006cc:	000ba583          	lw	a1,0(s7)
  4006d0:	855a                	mv	a0,s6
  4006d2:	d8bff0ef          	jal	40045c <printint>
        i += 1;
  4006d6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006d8:	8ba6                	mv	s7,s1
      state = 0;
  4006da:	4981                	li	s3,0
        i += 1;
  4006dc:	b585                	j	40053c <vprintf+0x4a>
  4006de:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  4006e0:	008b8d13          	addi	s10,s7,8
  4006e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  4006e8:	03000593          	li	a1,48
  4006ec:	855a                	mv	a0,s6
  4006ee:	d51ff0ef          	jal	40043e <putc>
  putc(fd, 'x');
  4006f2:	07800593          	li	a1,120
  4006f6:	855a                	mv	a0,s6
  4006f8:	d47ff0ef          	jal	40043e <putc>
  4006fc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  4006fe:	00000b97          	auipc	s7,0x0
  400702:	29ab8b93          	addi	s7,s7,666 # 400998 <digits>
  400706:	03c9d793          	srli	a5,s3,0x3c
  40070a:	97de                	add	a5,a5,s7
  40070c:	0007c583          	lbu	a1,0(a5)
  400710:	855a                	mv	a0,s6
  400712:	d2dff0ef          	jal	40043e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400716:	0992                	slli	s3,s3,0x4
  400718:	34fd                	addiw	s1,s1,-1
  40071a:	f4f5                	bnez	s1,400706 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  40071c:	8bea                	mv	s7,s10
      state = 0;
  40071e:	4981                	li	s3,0
  400720:	6d02                	ld	s10,0(sp)
  400722:	bd29                	j	40053c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  400724:	008b8993          	addi	s3,s7,8
  400728:	000bb483          	ld	s1,0(s7)
  40072c:	cc91                	beqz	s1,400748 <vprintf+0x256>
        for(; *s; s++)
  40072e:	0004c583          	lbu	a1,0(s1)
  400732:	c195                	beqz	a1,400756 <vprintf+0x264>
          putc(fd, *s);
  400734:	855a                	mv	a0,s6
  400736:	d09ff0ef          	jal	40043e <putc>
        for(; *s; s++)
  40073a:	0485                	addi	s1,s1,1
  40073c:	0004c583          	lbu	a1,0(s1)
  400740:	f9f5                	bnez	a1,400734 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400742:	8bce                	mv	s7,s3
      state = 0;
  400744:	4981                	li	s3,0
  400746:	bbdd                	j	40053c <vprintf+0x4a>
          s = "(null)";
  400748:	00000497          	auipc	s1,0x0
  40074c:	24848493          	addi	s1,s1,584 # 400990 <malloc+0x134>
        for(; *s; s++)
  400750:	02800593          	li	a1,40
  400754:	b7c5                	j	400734 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400756:	8bce                	mv	s7,s3
      state = 0;
  400758:	4981                	li	s3,0
  40075a:	b3cd                	j	40053c <vprintf+0x4a>
  40075c:	6906                	ld	s2,64(sp)
  40075e:	79e2                	ld	s3,56(sp)
  400760:	7a42                	ld	s4,48(sp)
  400762:	7aa2                	ld	s5,40(sp)
  400764:	7b02                	ld	s6,32(sp)
  400766:	6be2                	ld	s7,24(sp)
  400768:	6c42                	ld	s8,16(sp)
  40076a:	6ca2                	ld	s9,8(sp)
    }
  }
}
  40076c:	60e6                	ld	ra,88(sp)
  40076e:	6446                	ld	s0,80(sp)
  400770:	64a6                	ld	s1,72(sp)
  400772:	6125                	addi	sp,sp,96
  400774:	8082                	ret

0000000000400776 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  400776:	715d                	addi	sp,sp,-80
  400778:	ec06                	sd	ra,24(sp)
  40077a:	e822                	sd	s0,16(sp)
  40077c:	1000                	addi	s0,sp,32
  40077e:	e010                	sd	a2,0(s0)
  400780:	e414                	sd	a3,8(s0)
  400782:	e818                	sd	a4,16(s0)
  400784:	ec1c                	sd	a5,24(s0)
  400786:	03043023          	sd	a6,32(s0)
  40078a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  40078e:	8622                	mv	a2,s0
  400790:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400794:	d5fff0ef          	jal	4004f2 <vprintf>
  return 0;
}
  400798:	4501                	li	a0,0
  40079a:	60e2                	ld	ra,24(sp)
  40079c:	6442                	ld	s0,16(sp)
  40079e:	6161                	addi	sp,sp,80
  4007a0:	8082                	ret

00000000004007a2 <printf>:

int
printf(const char *fmt, ...)
{
  4007a2:	711d                	addi	sp,sp,-96
  4007a4:	ec06                	sd	ra,24(sp)
  4007a6:	e822                	sd	s0,16(sp)
  4007a8:	1000                	addi	s0,sp,32
  4007aa:	e40c                	sd	a1,8(s0)
  4007ac:	e810                	sd	a2,16(s0)
  4007ae:	ec14                	sd	a3,24(s0)
  4007b0:	f018                	sd	a4,32(s0)
  4007b2:	f41c                	sd	a5,40(s0)
  4007b4:	03043823          	sd	a6,48(s0)
  4007b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  4007bc:	00840613          	addi	a2,s0,8
  4007c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  4007c4:	85aa                	mv	a1,a0
  4007c6:	4505                	li	a0,1
  4007c8:	d2bff0ef          	jal	4004f2 <vprintf>
  return 0;
}
  4007cc:	4501                	li	a0,0
  4007ce:	60e2                	ld	ra,24(sp)
  4007d0:	6442                	ld	s0,16(sp)
  4007d2:	6125                	addi	sp,sp,96
  4007d4:	8082                	ret

00000000004007d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  4007d6:	1141                	addi	sp,sp,-16
  4007d8:	e406                	sd	ra,8(sp)
  4007da:	e022                	sd	s0,0(sp)
  4007dc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  4007de:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4007e2:	00001797          	auipc	a5,0x1
  4007e6:	81e7b783          	ld	a5,-2018(a5) # 401000 <freep>
  4007ea:	a02d                	j	400814 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  4007ec:	4618                	lw	a4,8(a2)
  4007ee:	9f2d                	addw	a4,a4,a1
  4007f0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  4007f4:	6398                	ld	a4,0(a5)
  4007f6:	6310                	ld	a2,0(a4)
  4007f8:	a83d                	j	400836 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  4007fa:	ff852703          	lw	a4,-8(a0)
  4007fe:	9f31                	addw	a4,a4,a2
  400800:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400802:	ff053683          	ld	a3,-16(a0)
  400806:	a091                	j	40084a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400808:	6398                	ld	a4,0(a5)
  40080a:	00e7e463          	bltu	a5,a4,400812 <free+0x3c>
  40080e:	00e6ea63          	bltu	a3,a4,400822 <free+0x4c>
{
  400812:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400814:	fed7fae3          	bgeu	a5,a3,400808 <free+0x32>
  400818:	6398                	ld	a4,0(a5)
  40081a:	00e6e463          	bltu	a3,a4,400822 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40081e:	fee7eae3          	bltu	a5,a4,400812 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  400822:	ff852583          	lw	a1,-8(a0)
  400826:	6390                	ld	a2,0(a5)
  400828:	02059813          	slli	a6,a1,0x20
  40082c:	01c85713          	srli	a4,a6,0x1c
  400830:	9736                	add	a4,a4,a3
  400832:	fae60de3          	beq	a2,a4,4007ec <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  400836:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  40083a:	4790                	lw	a2,8(a5)
  40083c:	02061593          	slli	a1,a2,0x20
  400840:	01c5d713          	srli	a4,a1,0x1c
  400844:	973e                	add	a4,a4,a5
  400846:	fae68ae3          	beq	a3,a4,4007fa <free+0x24>
    p->s.ptr = bp->s.ptr;
  40084a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  40084c:	00000717          	auipc	a4,0x0
  400850:	7af73a23          	sd	a5,1972(a4) # 401000 <freep>
}
  400854:	60a2                	ld	ra,8(sp)
  400856:	6402                	ld	s0,0(sp)
  400858:	0141                	addi	sp,sp,16
  40085a:	8082                	ret

000000000040085c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  40085c:	7139                	addi	sp,sp,-64
  40085e:	fc06                	sd	ra,56(sp)
  400860:	f822                	sd	s0,48(sp)
  400862:	f04a                	sd	s2,32(sp)
  400864:	ec4e                	sd	s3,24(sp)
  400866:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  400868:	02051993          	slli	s3,a0,0x20
  40086c:	0209d993          	srli	s3,s3,0x20
  400870:	09bd                	addi	s3,s3,15
  400872:	0049d993          	srli	s3,s3,0x4
  400876:	2985                	addiw	s3,s3,1
  400878:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  40087a:	00000517          	auipc	a0,0x0
  40087e:	78653503          	ld	a0,1926(a0) # 401000 <freep>
  400882:	c905                	beqz	a0,4008b2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400884:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400886:	4798                	lw	a4,8(a5)
  400888:	09377663          	bgeu	a4,s3,400914 <malloc+0xb8>
  40088c:	f426                	sd	s1,40(sp)
  40088e:	e852                	sd	s4,16(sp)
  400890:	e456                	sd	s5,8(sp)
  400892:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400894:	8a4e                	mv	s4,s3
  400896:	6705                	lui	a4,0x1
  400898:	00e9f363          	bgeu	s3,a4,40089e <malloc+0x42>
  40089c:	6a05                	lui	s4,0x1
  40089e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  4008a2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  4008a6:	00000497          	auipc	s1,0x0
  4008aa:	75a48493          	addi	s1,s1,1882 # 401000 <freep>
  if(p == (char*)-1)
  4008ae:	5afd                	li	s5,-1
  4008b0:	a83d                	j	4008ee <malloc+0x92>
  4008b2:	f426                	sd	s1,40(sp)
  4008b4:	e852                	sd	s4,16(sp)
  4008b6:	e456                	sd	s5,8(sp)
  4008b8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  4008ba:	00000797          	auipc	a5,0x0
  4008be:	75678793          	addi	a5,a5,1878 # 401010 <base>
  4008c2:	00000717          	auipc	a4,0x0
  4008c6:	72f73f23          	sd	a5,1854(a4) # 401000 <freep>
  4008ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  4008cc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  4008d0:	b7d1                	j	400894 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  4008d2:	6398                	ld	a4,0(a5)
  4008d4:	e118                	sd	a4,0(a0)
  4008d6:	a899                	j	40092c <malloc+0xd0>
  hp->s.size = nu;
  4008d8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  4008dc:	0541                	addi	a0,a0,16
  4008de:	ef9ff0ef          	jal	4007d6 <free>
  return freep;
  4008e2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  4008e4:	c125                	beqz	a0,400944 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4008e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4008e8:	4798                	lw	a4,8(a5)
  4008ea:	03277163          	bgeu	a4,s2,40090c <malloc+0xb0>
    if(p == freep)
  4008ee:	6098                	ld	a4,0(s1)
  4008f0:	853e                	mv	a0,a5
  4008f2:	fef71ae3          	bne	a4,a5,4008e6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  4008f6:	8552                	mv	a0,s4
  4008f8:	b17ff0ef          	jal	40040e <sbrk>
  if(p == (char*)-1)
  4008fc:	fd551ee3          	bne	a0,s5,4008d8 <malloc+0x7c>
        return 0;
  400900:	4501                	li	a0,0
  400902:	74a2                	ld	s1,40(sp)
  400904:	6a42                	ld	s4,16(sp)
  400906:	6aa2                	ld	s5,8(sp)
  400908:	6b02                	ld	s6,0(sp)
  40090a:	a03d                	j	400938 <malloc+0xdc>
  40090c:	74a2                	ld	s1,40(sp)
  40090e:	6a42                	ld	s4,16(sp)
  400910:	6aa2                	ld	s5,8(sp)
  400912:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400914:	fae90fe3          	beq	s2,a4,4008d2 <malloc+0x76>
        p->s.size -= nunits;
  400918:	4137073b          	subw	a4,a4,s3
  40091c:	c798                	sw	a4,8(a5)
        p += p->s.size;
  40091e:	02071693          	slli	a3,a4,0x20
  400922:	01c6d713          	srli	a4,a3,0x1c
  400926:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  400928:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  40092c:	00000717          	auipc	a4,0x0
  400930:	6ca73a23          	sd	a0,1748(a4) # 401000 <freep>
      return (void*)(p + 1);
  400934:	01078513          	addi	a0,a5,16
  }
}
  400938:	70e2                	ld	ra,56(sp)
  40093a:	7442                	ld	s0,48(sp)
  40093c:	7902                	ld	s2,32(sp)
  40093e:	69e2                	ld	s3,24(sp)
  400940:	6121                	addi	sp,sp,64
  400942:	8082                	ret
  400944:	74a2                	ld	s1,40(sp)
  400946:	6a42                	ld	s4,16(sp)
  400948:	6aa2                	ld	s5,8(sp)
  40094a:	6b02                	ld	s6,0(sp)
  40094c:	b7f5                	j	400938 <malloc+0xdc>
