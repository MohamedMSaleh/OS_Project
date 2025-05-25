
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <cat>:

char buf[512];

void
cat(int fd)
{
  400000:	7139                	addi	sp,sp,-64
  400002:	fc06                	sd	ra,56(sp)
  400004:	f822                	sd	s0,48(sp)
  400006:	f426                	sd	s1,40(sp)
  400008:	f04a                	sd	s2,32(sp)
  40000a:	ec4e                	sd	s3,24(sp)
  40000c:	e852                	sd	s4,16(sp)
  40000e:	e456                	sd	s5,8(sp)
  400010:	0080                	addi	s0,sp,64
  400012:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  400014:	00001917          	auipc	s2,0x1
  400018:	ffc90913          	addi	s2,s2,-4 # 401010 <buf>
  40001c:	20000a13          	li	s4,512
    if (write(1, buf, n) != n) {
  400020:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  400022:	8652                	mv	a2,s4
  400024:	85ca                	mv	a1,s2
  400026:	854e                	mv	a0,s3
  400028:	384000ef          	jal	4003ac <read>
  40002c:	84aa                	mv	s1,a0
  40002e:	02a05363          	blez	a0,400054 <cat+0x54>
    if (write(1, buf, n) != n) {
  400032:	8626                	mv	a2,s1
  400034:	85ca                	mv	a1,s2
  400036:	8556                	mv	a0,s5
  400038:	37c000ef          	jal	4003b4 <write>
  40003c:	fe9503e3          	beq	a0,s1,400022 <cat+0x22>
      fprintf(2, "cat: write error\n");
  400040:	00001597          	auipc	a1,0x1
  400044:	92058593          	addi	a1,a1,-1760 # 400960 <malloc+0xf6>
  400048:	4509                	li	a0,2
  40004a:	73a000ef          	jal	400784 <fprintf>
      exit(1);
  40004e:	4505                	li	a0,1
  400050:	344000ef          	jal	400394 <exit>
    }
  }
  if(n < 0){
  400054:	00054b63          	bltz	a0,40006a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  400058:	70e2                	ld	ra,56(sp)
  40005a:	7442                	ld	s0,48(sp)
  40005c:	74a2                	ld	s1,40(sp)
  40005e:	7902                	ld	s2,32(sp)
  400060:	69e2                	ld	s3,24(sp)
  400062:	6a42                	ld	s4,16(sp)
  400064:	6aa2                	ld	s5,8(sp)
  400066:	6121                	addi	sp,sp,64
  400068:	8082                	ret
    fprintf(2, "cat: read error\n");
  40006a:	00001597          	auipc	a1,0x1
  40006e:	90e58593          	addi	a1,a1,-1778 # 400978 <malloc+0x10e>
  400072:	4509                	li	a0,2
  400074:	710000ef          	jal	400784 <fprintf>
    exit(1);
  400078:	4505                	li	a0,1
  40007a:	31a000ef          	jal	400394 <exit>

000000000040007e <main>:

int
main(int argc, char *argv[])
{
  40007e:	7179                	addi	sp,sp,-48
  400080:	f406                	sd	ra,40(sp)
  400082:	f022                	sd	s0,32(sp)
  400084:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  400086:	4785                	li	a5,1
  400088:	04a7d263          	bge	a5,a0,4000cc <main+0x4e>
  40008c:	ec26                	sd	s1,24(sp)
  40008e:	e84a                	sd	s2,16(sp)
  400090:	e44e                	sd	s3,8(sp)
  400092:	00858913          	addi	s2,a1,8
  400096:	ffe5099b          	addiw	s3,a0,-2
  40009a:	02099793          	slli	a5,s3,0x20
  40009e:	01d7d993          	srli	s3,a5,0x1d
  4000a2:	05c1                	addi	a1,a1,16
  4000a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  4000a6:	4581                	li	a1,0
  4000a8:	00093503          	ld	a0,0(s2)
  4000ac:	328000ef          	jal	4003d4 <open>
  4000b0:	84aa                	mv	s1,a0
  4000b2:	02054663          	bltz	a0,4000de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  4000b6:	f4bff0ef          	jal	400000 <cat>
    close(fd);
  4000ba:	8526                	mv	a0,s1
  4000bc:	300000ef          	jal	4003bc <close>
  for(i = 1; i < argc; i++){
  4000c0:	0921                	addi	s2,s2,8
  4000c2:	ff3912e3          	bne	s2,s3,4000a6 <main+0x28>
  }
  exit(0);
  4000c6:	4501                	li	a0,0
  4000c8:	2cc000ef          	jal	400394 <exit>
  4000cc:	ec26                	sd	s1,24(sp)
  4000ce:	e84a                	sd	s2,16(sp)
  4000d0:	e44e                	sd	s3,8(sp)
    cat(0);
  4000d2:	4501                	li	a0,0
  4000d4:	f2dff0ef          	jal	400000 <cat>
    exit(0);
  4000d8:	4501                	li	a0,0
  4000da:	2ba000ef          	jal	400394 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  4000de:	00093603          	ld	a2,0(s2)
  4000e2:	00001597          	auipc	a1,0x1
  4000e6:	8ae58593          	addi	a1,a1,-1874 # 400990 <malloc+0x126>
  4000ea:	4509                	li	a0,2
  4000ec:	698000ef          	jal	400784 <fprintf>
      exit(1);
  4000f0:	4505                	li	a0,1
  4000f2:	2a2000ef          	jal	400394 <exit>

00000000004000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4000f6:	1141                	addi	sp,sp,-16
  4000f8:	e406                	sd	ra,8(sp)
  4000fa:	e022                	sd	s0,0(sp)
  4000fc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4000fe:	f81ff0ef          	jal	40007e <main>
  exit(0);
  400102:	4501                	li	a0,0
  400104:	290000ef          	jal	400394 <exit>

0000000000400108 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400108:	1141                	addi	sp,sp,-16
  40010a:	e406                	sd	ra,8(sp)
  40010c:	e022                	sd	s0,0(sp)
  40010e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400110:	87aa                	mv	a5,a0
  400112:	0585                	addi	a1,a1,1
  400114:	0785                	addi	a5,a5,1
  400116:	fff5c703          	lbu	a4,-1(a1)
  40011a:	fee78fa3          	sb	a4,-1(a5)
  40011e:	fb75                	bnez	a4,400112 <strcpy+0xa>
    ;
  return os;
}
  400120:	60a2                	ld	ra,8(sp)
  400122:	6402                	ld	s0,0(sp)
  400124:	0141                	addi	sp,sp,16
  400126:	8082                	ret

0000000000400128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400128:	1141                	addi	sp,sp,-16
  40012a:	e406                	sd	ra,8(sp)
  40012c:	e022                	sd	s0,0(sp)
  40012e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  400130:	00054783          	lbu	a5,0(a0)
  400134:	cb91                	beqz	a5,400148 <strcmp+0x20>
  400136:	0005c703          	lbu	a4,0(a1)
  40013a:	00f71763          	bne	a4,a5,400148 <strcmp+0x20>
    p++, q++;
  40013e:	0505                	addi	a0,a0,1
  400140:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  400142:	00054783          	lbu	a5,0(a0)
  400146:	fbe5                	bnez	a5,400136 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  400148:	0005c503          	lbu	a0,0(a1)
}
  40014c:	40a7853b          	subw	a0,a5,a0
  400150:	60a2                	ld	ra,8(sp)
  400152:	6402                	ld	s0,0(sp)
  400154:	0141                	addi	sp,sp,16
  400156:	8082                	ret

0000000000400158 <strlen>:

uint
strlen(const char *s)
{
  400158:	1141                	addi	sp,sp,-16
  40015a:	e406                	sd	ra,8(sp)
  40015c:	e022                	sd	s0,0(sp)
  40015e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  400160:	00054783          	lbu	a5,0(a0)
  400164:	cf99                	beqz	a5,400182 <strlen+0x2a>
  400166:	0505                	addi	a0,a0,1
  400168:	87aa                	mv	a5,a0
  40016a:	86be                	mv	a3,a5
  40016c:	0785                	addi	a5,a5,1
  40016e:	fff7c703          	lbu	a4,-1(a5)
  400172:	ff65                	bnez	a4,40016a <strlen+0x12>
  400174:	40a6853b          	subw	a0,a3,a0
  400178:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  40017a:	60a2                	ld	ra,8(sp)
  40017c:	6402                	ld	s0,0(sp)
  40017e:	0141                	addi	sp,sp,16
  400180:	8082                	ret
  for(n = 0; s[n]; n++)
  400182:	4501                	li	a0,0
  400184:	bfdd                	j	40017a <strlen+0x22>

0000000000400186 <memset>:

void*
memset(void *dst, int c, uint n)
{
  400186:	1141                	addi	sp,sp,-16
  400188:	e406                	sd	ra,8(sp)
  40018a:	e022                	sd	s0,0(sp)
  40018c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  40018e:	ca19                	beqz	a2,4001a4 <memset+0x1e>
  400190:	87aa                	mv	a5,a0
  400192:	1602                	slli	a2,a2,0x20
  400194:	9201                	srli	a2,a2,0x20
  400196:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  40019a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  40019e:	0785                	addi	a5,a5,1
  4001a0:	fee79de3          	bne	a5,a4,40019a <memset+0x14>
  }
  return dst;
}
  4001a4:	60a2                	ld	ra,8(sp)
  4001a6:	6402                	ld	s0,0(sp)
  4001a8:	0141                	addi	sp,sp,16
  4001aa:	8082                	ret

00000000004001ac <strchr>:

char*
strchr(const char *s, char c)
{
  4001ac:	1141                	addi	sp,sp,-16
  4001ae:	e406                	sd	ra,8(sp)
  4001b0:	e022                	sd	s0,0(sp)
  4001b2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  4001b4:	00054783          	lbu	a5,0(a0)
  4001b8:	cf81                	beqz	a5,4001d0 <strchr+0x24>
    if(*s == c)
  4001ba:	00f58763          	beq	a1,a5,4001c8 <strchr+0x1c>
  for(; *s; s++)
  4001be:	0505                	addi	a0,a0,1
  4001c0:	00054783          	lbu	a5,0(a0)
  4001c4:	fbfd                	bnez	a5,4001ba <strchr+0xe>
      return (char*)s;
  return 0;
  4001c6:	4501                	li	a0,0
}
  4001c8:	60a2                	ld	ra,8(sp)
  4001ca:	6402                	ld	s0,0(sp)
  4001cc:	0141                	addi	sp,sp,16
  4001ce:	8082                	ret
  return 0;
  4001d0:	4501                	li	a0,0
  4001d2:	bfdd                	j	4001c8 <strchr+0x1c>

00000000004001d4 <gets>:

char*
gets(char *buf, int max)
{
  4001d4:	7159                	addi	sp,sp,-112
  4001d6:	f486                	sd	ra,104(sp)
  4001d8:	f0a2                	sd	s0,96(sp)
  4001da:	eca6                	sd	s1,88(sp)
  4001dc:	e8ca                	sd	s2,80(sp)
  4001de:	e4ce                	sd	s3,72(sp)
  4001e0:	e0d2                	sd	s4,64(sp)
  4001e2:	fc56                	sd	s5,56(sp)
  4001e4:	f85a                	sd	s6,48(sp)
  4001e6:	f45e                	sd	s7,40(sp)
  4001e8:	f062                	sd	s8,32(sp)
  4001ea:	ec66                	sd	s9,24(sp)
  4001ec:	e86a                	sd	s10,16(sp)
  4001ee:	1880                	addi	s0,sp,112
  4001f0:	8caa                	mv	s9,a0
  4001f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  4001f4:	892a                	mv	s2,a0
  4001f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
  4001f8:	f9f40b13          	addi	s6,s0,-97
  4001fc:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  4001fe:	4ba9                	li	s7,10
  400200:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400202:	8d26                	mv	s10,s1
  400204:	0014899b          	addiw	s3,s1,1
  400208:	84ce                	mv	s1,s3
  40020a:	0349d563          	bge	s3,s4,400234 <gets+0x60>
    cc = read(0, &c, 1);
  40020e:	8656                	mv	a2,s5
  400210:	85da                	mv	a1,s6
  400212:	4501                	li	a0,0
  400214:	198000ef          	jal	4003ac <read>
    if(cc < 1)
  400218:	00a05e63          	blez	a0,400234 <gets+0x60>
    buf[i++] = c;
  40021c:	f9f44783          	lbu	a5,-97(s0)
  400220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400224:	01778763          	beq	a5,s7,400232 <gets+0x5e>
  400228:	0905                	addi	s2,s2,1
  40022a:	fd879ce3          	bne	a5,s8,400202 <gets+0x2e>
    buf[i++] = c;
  40022e:	8d4e                	mv	s10,s3
  400230:	a011                	j	400234 <gets+0x60>
  400232:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  400234:	9d66                	add	s10,s10,s9
  400236:	000d0023          	sb	zero,0(s10)
  return buf;
}
  40023a:	8566                	mv	a0,s9
  40023c:	70a6                	ld	ra,104(sp)
  40023e:	7406                	ld	s0,96(sp)
  400240:	64e6                	ld	s1,88(sp)
  400242:	6946                	ld	s2,80(sp)
  400244:	69a6                	ld	s3,72(sp)
  400246:	6a06                	ld	s4,64(sp)
  400248:	7ae2                	ld	s5,56(sp)
  40024a:	7b42                	ld	s6,48(sp)
  40024c:	7ba2                	ld	s7,40(sp)
  40024e:	7c02                	ld	s8,32(sp)
  400250:	6ce2                	ld	s9,24(sp)
  400252:	6d42                	ld	s10,16(sp)
  400254:	6165                	addi	sp,sp,112
  400256:	8082                	ret

0000000000400258 <stat>:

int
stat(const char *n, struct stat *st)
{
  400258:	1101                	addi	sp,sp,-32
  40025a:	ec06                	sd	ra,24(sp)
  40025c:	e822                	sd	s0,16(sp)
  40025e:	e04a                	sd	s2,0(sp)
  400260:	1000                	addi	s0,sp,32
  400262:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  400264:	4581                	li	a1,0
  400266:	16e000ef          	jal	4003d4 <open>
  if(fd < 0)
  40026a:	02054263          	bltz	a0,40028e <stat+0x36>
  40026e:	e426                	sd	s1,8(sp)
  400270:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  400272:	85ca                	mv	a1,s2
  400274:	178000ef          	jal	4003ec <fstat>
  400278:	892a                	mv	s2,a0
  close(fd);
  40027a:	8526                	mv	a0,s1
  40027c:	140000ef          	jal	4003bc <close>
  return r;
  400280:	64a2                	ld	s1,8(sp)
}
  400282:	854a                	mv	a0,s2
  400284:	60e2                	ld	ra,24(sp)
  400286:	6442                	ld	s0,16(sp)
  400288:	6902                	ld	s2,0(sp)
  40028a:	6105                	addi	sp,sp,32
  40028c:	8082                	ret
    return -1;
  40028e:	597d                	li	s2,-1
  400290:	bfcd                	j	400282 <stat+0x2a>

0000000000400292 <atoi>:

int
atoi(const char *s)
{
  400292:	1141                	addi	sp,sp,-16
  400294:	e406                	sd	ra,8(sp)
  400296:	e022                	sd	s0,0(sp)
  400298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  40029a:	00054683          	lbu	a3,0(a0)
  40029e:	fd06879b          	addiw	a5,a3,-48
  4002a2:	0ff7f793          	zext.b	a5,a5
  4002a6:	4625                	li	a2,9
  4002a8:	02f66963          	bltu	a2,a5,4002da <atoi+0x48>
  4002ac:	872a                	mv	a4,a0
  n = 0;
  4002ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  4002b0:	0705                	addi	a4,a4,1
  4002b2:	0025179b          	slliw	a5,a0,0x2
  4002b6:	9fa9                	addw	a5,a5,a0
  4002b8:	0017979b          	slliw	a5,a5,0x1
  4002bc:	9fb5                	addw	a5,a5,a3
  4002be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  4002c2:	00074683          	lbu	a3,0(a4)
  4002c6:	fd06879b          	addiw	a5,a3,-48
  4002ca:	0ff7f793          	zext.b	a5,a5
  4002ce:	fef671e3          	bgeu	a2,a5,4002b0 <atoi+0x1e>
  return n;
}
  4002d2:	60a2                	ld	ra,8(sp)
  4002d4:	6402                	ld	s0,0(sp)
  4002d6:	0141                	addi	sp,sp,16
  4002d8:	8082                	ret
  n = 0;
  4002da:	4501                	li	a0,0
  4002dc:	bfdd                	j	4002d2 <atoi+0x40>

00000000004002de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  4002de:	1141                	addi	sp,sp,-16
  4002e0:	e406                	sd	ra,8(sp)
  4002e2:	e022                	sd	s0,0(sp)
  4002e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  4002e6:	02b57563          	bgeu	a0,a1,400310 <memmove+0x32>
    while(n-- > 0)
  4002ea:	00c05f63          	blez	a2,400308 <memmove+0x2a>
  4002ee:	1602                	slli	a2,a2,0x20
  4002f0:	9201                	srli	a2,a2,0x20
  4002f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  4002f6:	872a                	mv	a4,a0
      *dst++ = *src++;
  4002f8:	0585                	addi	a1,a1,1
  4002fa:	0705                	addi	a4,a4,1
  4002fc:	fff5c683          	lbu	a3,-1(a1)
  400300:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400304:	fee79ae3          	bne	a5,a4,4002f8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400308:	60a2                	ld	ra,8(sp)
  40030a:	6402                	ld	s0,0(sp)
  40030c:	0141                	addi	sp,sp,16
  40030e:	8082                	ret
    dst += n;
  400310:	00c50733          	add	a4,a0,a2
    src += n;
  400314:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400316:	fec059e3          	blez	a2,400308 <memmove+0x2a>
  40031a:	fff6079b          	addiw	a5,a2,-1
  40031e:	1782                	slli	a5,a5,0x20
  400320:	9381                	srli	a5,a5,0x20
  400322:	fff7c793          	not	a5,a5
  400326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400328:	15fd                	addi	a1,a1,-1
  40032a:	177d                	addi	a4,a4,-1
  40032c:	0005c683          	lbu	a3,0(a1)
  400330:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  400334:	fef71ae3          	bne	a4,a5,400328 <memmove+0x4a>
  400338:	bfc1                	j	400308 <memmove+0x2a>

000000000040033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  40033a:	1141                	addi	sp,sp,-16
  40033c:	e406                	sd	ra,8(sp)
  40033e:	e022                	sd	s0,0(sp)
  400340:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  400342:	ca0d                	beqz	a2,400374 <memcmp+0x3a>
  400344:	fff6069b          	addiw	a3,a2,-1
  400348:	1682                	slli	a3,a3,0x20
  40034a:	9281                	srli	a3,a3,0x20
  40034c:	0685                	addi	a3,a3,1
  40034e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  400350:	00054783          	lbu	a5,0(a0)
  400354:	0005c703          	lbu	a4,0(a1)
  400358:	00e79863          	bne	a5,a4,400368 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  40035c:	0505                	addi	a0,a0,1
    p2++;
  40035e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  400360:	fed518e3          	bne	a0,a3,400350 <memcmp+0x16>
  }
  return 0;
  400364:	4501                	li	a0,0
  400366:	a019                	j	40036c <memcmp+0x32>
      return *p1 - *p2;
  400368:	40e7853b          	subw	a0,a5,a4
}
  40036c:	60a2                	ld	ra,8(sp)
  40036e:	6402                	ld	s0,0(sp)
  400370:	0141                	addi	sp,sp,16
  400372:	8082                	ret
  return 0;
  400374:	4501                	li	a0,0
  400376:	bfdd                	j	40036c <memcmp+0x32>

0000000000400378 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  400378:	1141                	addi	sp,sp,-16
  40037a:	e406                	sd	ra,8(sp)
  40037c:	e022                	sd	s0,0(sp)
  40037e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400380:	f5fff0ef          	jal	4002de <memmove>
}
  400384:	60a2                	ld	ra,8(sp)
  400386:	6402                	ld	s0,0(sp)
  400388:	0141                	addi	sp,sp,16
  40038a:	8082                	ret

000000000040038c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  40038c:	4885                	li	a7,1
 ecall
  40038e:	00000073          	ecall
 ret
  400392:	8082                	ret

0000000000400394 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400394:	4889                	li	a7,2
 ecall
  400396:	00000073          	ecall
 ret
  40039a:	8082                	ret

000000000040039c <wait>:
.global wait
wait:
 li a7, SYS_wait
  40039c:	488d                	li	a7,3
 ecall
  40039e:	00000073          	ecall
 ret
  4003a2:	8082                	ret

00000000004003a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  4003a4:	4891                	li	a7,4
 ecall
  4003a6:	00000073          	ecall
 ret
  4003aa:	8082                	ret

00000000004003ac <read>:
.global read
read:
 li a7, SYS_read
  4003ac:	4895                	li	a7,5
 ecall
  4003ae:	00000073          	ecall
 ret
  4003b2:	8082                	ret

00000000004003b4 <write>:
.global write
write:
 li a7, SYS_write
  4003b4:	48c1                	li	a7,16
 ecall
  4003b6:	00000073          	ecall
 ret
  4003ba:	8082                	ret

00000000004003bc <close>:
.global close
close:
 li a7, SYS_close
  4003bc:	48d5                	li	a7,21
 ecall
  4003be:	00000073          	ecall
 ret
  4003c2:	8082                	ret

00000000004003c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
  4003c4:	4899                	li	a7,6
 ecall
  4003c6:	00000073          	ecall
 ret
  4003ca:	8082                	ret

00000000004003cc <exec>:
.global exec
exec:
 li a7, SYS_exec
  4003cc:	489d                	li	a7,7
 ecall
  4003ce:	00000073          	ecall
 ret
  4003d2:	8082                	ret

00000000004003d4 <open>:
.global open
open:
 li a7, SYS_open
  4003d4:	48bd                	li	a7,15
 ecall
  4003d6:	00000073          	ecall
 ret
  4003da:	8082                	ret

00000000004003dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  4003dc:	48c5                	li	a7,17
 ecall
  4003de:	00000073          	ecall
 ret
  4003e2:	8082                	ret

00000000004003e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  4003e4:	48c9                	li	a7,18
 ecall
  4003e6:	00000073          	ecall
 ret
  4003ea:	8082                	ret

00000000004003ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  4003ec:	48a1                	li	a7,8
 ecall
  4003ee:	00000073          	ecall
 ret
  4003f2:	8082                	ret

00000000004003f4 <link>:
.global link
link:
 li a7, SYS_link
  4003f4:	48cd                	li	a7,19
 ecall
  4003f6:	00000073          	ecall
 ret
  4003fa:	8082                	ret

00000000004003fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  4003fc:	48d1                	li	a7,20
 ecall
  4003fe:	00000073          	ecall
 ret
  400402:	8082                	ret

0000000000400404 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400404:	48a5                	li	a7,9
 ecall
  400406:	00000073          	ecall
 ret
  40040a:	8082                	ret

000000000040040c <dup>:
.global dup
dup:
 li a7, SYS_dup
  40040c:	48a9                	li	a7,10
 ecall
  40040e:	00000073          	ecall
 ret
  400412:	8082                	ret

0000000000400414 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400414:	48ad                	li	a7,11
 ecall
  400416:	00000073          	ecall
 ret
  40041a:	8082                	ret

000000000040041c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  40041c:	48b1                	li	a7,12
 ecall
  40041e:	00000073          	ecall
 ret
  400422:	8082                	ret

0000000000400424 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400424:	48b5                	li	a7,13
 ecall
  400426:	00000073          	ecall
 ret
  40042a:	8082                	ret

000000000040042c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  40042c:	48b9                	li	a7,14
 ecall
  40042e:	00000073          	ecall
 ret
  400432:	8082                	ret

0000000000400434 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  400434:	48d9                	li	a7,22
 ecall
  400436:	00000073          	ecall
 ret
  40043a:	8082                	ret

000000000040043c <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  40043c:	48dd                	li	a7,23
 ecall
  40043e:	00000073          	ecall
 ret
  400442:	8082                	ret

0000000000400444 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  400444:	48e1                	li	a7,24
 ecall
  400446:	00000073          	ecall
 ret
  40044a:	8082                	ret

000000000040044c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  40044c:	1101                	addi	sp,sp,-32
  40044e:	ec06                	sd	ra,24(sp)
  400450:	e822                	sd	s0,16(sp)
  400452:	1000                	addi	s0,sp,32
  400454:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  400458:	4605                	li	a2,1
  40045a:	fef40593          	addi	a1,s0,-17
  40045e:	f57ff0ef          	jal	4003b4 <write>
}
  400462:	60e2                	ld	ra,24(sp)
  400464:	6442                	ld	s0,16(sp)
  400466:	6105                	addi	sp,sp,32
  400468:	8082                	ret

000000000040046a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  40046a:	7139                	addi	sp,sp,-64
  40046c:	fc06                	sd	ra,56(sp)
  40046e:	f822                	sd	s0,48(sp)
  400470:	f426                	sd	s1,40(sp)
  400472:	f04a                	sd	s2,32(sp)
  400474:	ec4e                	sd	s3,24(sp)
  400476:	0080                	addi	s0,sp,64
  400478:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  40047a:	c299                	beqz	a3,400480 <printint+0x16>
  40047c:	0605ce63          	bltz	a1,4004f8 <printint+0x8e>
  neg = 0;
  400480:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400482:	fc040313          	addi	t1,s0,-64
  neg = 0;
  400486:	869a                	mv	a3,t1
  i = 0;
  400488:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  40048a:	00000817          	auipc	a6,0x0
  40048e:	52680813          	addi	a6,a6,1318 # 4009b0 <digits>
  400492:	88be                	mv	a7,a5
  400494:	0017851b          	addiw	a0,a5,1
  400498:	87aa                	mv	a5,a0
  40049a:	02c5f73b          	remuw	a4,a1,a2
  40049e:	1702                	slli	a4,a4,0x20
  4004a0:	9301                	srli	a4,a4,0x20
  4004a2:	9742                	add	a4,a4,a6
  4004a4:	00074703          	lbu	a4,0(a4)
  4004a8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  4004ac:	872e                	mv	a4,a1
  4004ae:	02c5d5bb          	divuw	a1,a1,a2
  4004b2:	0685                	addi	a3,a3,1
  4004b4:	fcc77fe3          	bgeu	a4,a2,400492 <printint+0x28>
  if(neg)
  4004b8:	000e0c63          	beqz	t3,4004d0 <printint+0x66>
    buf[i++] = '-';
  4004bc:	fd050793          	addi	a5,a0,-48
  4004c0:	00878533          	add	a0,a5,s0
  4004c4:	02d00793          	li	a5,45
  4004c8:	fef50823          	sb	a5,-16(a0)
  4004cc:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  4004d0:	fff7899b          	addiw	s3,a5,-1
  4004d4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  4004d8:	fff4c583          	lbu	a1,-1(s1)
  4004dc:	854a                	mv	a0,s2
  4004de:	f6fff0ef          	jal	40044c <putc>
  while(--i >= 0)
  4004e2:	39fd                	addiw	s3,s3,-1
  4004e4:	14fd                	addi	s1,s1,-1
  4004e6:	fe09d9e3          	bgez	s3,4004d8 <printint+0x6e>
}
  4004ea:	70e2                	ld	ra,56(sp)
  4004ec:	7442                	ld	s0,48(sp)
  4004ee:	74a2                	ld	s1,40(sp)
  4004f0:	7902                	ld	s2,32(sp)
  4004f2:	69e2                	ld	s3,24(sp)
  4004f4:	6121                	addi	sp,sp,64
  4004f6:	8082                	ret
    x = -xx;
  4004f8:	40b005bb          	negw	a1,a1
    neg = 1;
  4004fc:	4e05                	li	t3,1
    x = -xx;
  4004fe:	b751                	j	400482 <printint+0x18>

0000000000400500 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400500:	711d                	addi	sp,sp,-96
  400502:	ec86                	sd	ra,88(sp)
  400504:	e8a2                	sd	s0,80(sp)
  400506:	e4a6                	sd	s1,72(sp)
  400508:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  40050a:	0005c483          	lbu	s1,0(a1)
  40050e:	26048663          	beqz	s1,40077a <vprintf+0x27a>
  400512:	e0ca                	sd	s2,64(sp)
  400514:	fc4e                	sd	s3,56(sp)
  400516:	f852                	sd	s4,48(sp)
  400518:	f456                	sd	s5,40(sp)
  40051a:	f05a                	sd	s6,32(sp)
  40051c:	ec5e                	sd	s7,24(sp)
  40051e:	e862                	sd	s8,16(sp)
  400520:	e466                	sd	s9,8(sp)
  400522:	8b2a                	mv	s6,a0
  400524:	8a2e                	mv	s4,a1
  400526:	8bb2                	mv	s7,a2
  state = 0;
  400528:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  40052a:	4901                	li	s2,0
  40052c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  40052e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  400532:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  400536:	06c00c93          	li	s9,108
  40053a:	a00d                	j	40055c <vprintf+0x5c>
        putc(fd, c0);
  40053c:	85a6                	mv	a1,s1
  40053e:	855a                	mv	a0,s6
  400540:	f0dff0ef          	jal	40044c <putc>
  400544:	a019                	j	40054a <vprintf+0x4a>
    } else if(state == '%'){
  400546:	03598363          	beq	s3,s5,40056c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  40054a:	0019079b          	addiw	a5,s2,1
  40054e:	893e                	mv	s2,a5
  400550:	873e                	mv	a4,a5
  400552:	97d2                	add	a5,a5,s4
  400554:	0007c483          	lbu	s1,0(a5)
  400558:	20048963          	beqz	s1,40076a <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  40055c:	0004879b          	sext.w	a5,s1
    if(state == 0){
  400560:	fe0993e3          	bnez	s3,400546 <vprintf+0x46>
      if(c0 == '%'){
  400564:	fd579ce3          	bne	a5,s5,40053c <vprintf+0x3c>
        state = '%';
  400568:	89be                	mv	s3,a5
  40056a:	b7c5                	j	40054a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  40056c:	00ea06b3          	add	a3,s4,a4
  400570:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  400574:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  400576:	c681                	beqz	a3,40057e <vprintf+0x7e>
  400578:	9752                	add	a4,a4,s4
  40057a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  40057e:	03878e63          	beq	a5,s8,4005ba <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400582:	05978863          	beq	a5,s9,4005d2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  400586:	07500713          	li	a4,117
  40058a:	0ee78263          	beq	a5,a4,40066e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  40058e:	07800713          	li	a4,120
  400592:	12e78463          	beq	a5,a4,4006ba <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400596:	07000713          	li	a4,112
  40059a:	14e78963          	beq	a5,a4,4006ec <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  40059e:	07300713          	li	a4,115
  4005a2:	18e78863          	beq	a5,a4,400732 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  4005a6:	02500713          	li	a4,37
  4005aa:	04e79463          	bne	a5,a4,4005f2 <vprintf+0xf2>
        putc(fd, '%');
  4005ae:	85ba                	mv	a1,a4
  4005b0:	855a                	mv	a0,s6
  4005b2:	e9bff0ef          	jal	40044c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  4005b6:	4981                	li	s3,0
  4005b8:	bf49                	j	40054a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  4005ba:	008b8493          	addi	s1,s7,8
  4005be:	4685                	li	a3,1
  4005c0:	4629                	li	a2,10
  4005c2:	000ba583          	lw	a1,0(s7)
  4005c6:	855a                	mv	a0,s6
  4005c8:	ea3ff0ef          	jal	40046a <printint>
  4005cc:	8ba6                	mv	s7,s1
      state = 0;
  4005ce:	4981                	li	s3,0
  4005d0:	bfad                	j	40054a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  4005d2:	06400793          	li	a5,100
  4005d6:	02f68963          	beq	a3,a5,400608 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4005da:	06c00793          	li	a5,108
  4005de:	04f68263          	beq	a3,a5,400622 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  4005e2:	07500793          	li	a5,117
  4005e6:	0af68063          	beq	a3,a5,400686 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  4005ea:	07800793          	li	a5,120
  4005ee:	0ef68263          	beq	a3,a5,4006d2 <vprintf+0x1d2>
        putc(fd, '%');
  4005f2:	02500593          	li	a1,37
  4005f6:	855a                	mv	a0,s6
  4005f8:	e55ff0ef          	jal	40044c <putc>
        putc(fd, c0);
  4005fc:	85a6                	mv	a1,s1
  4005fe:	855a                	mv	a0,s6
  400600:	e4dff0ef          	jal	40044c <putc>
      state = 0;
  400604:	4981                	li	s3,0
  400606:	b791                	j	40054a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400608:	008b8493          	addi	s1,s7,8
  40060c:	4685                	li	a3,1
  40060e:	4629                	li	a2,10
  400610:	000ba583          	lw	a1,0(s7)
  400614:	855a                	mv	a0,s6
  400616:	e55ff0ef          	jal	40046a <printint>
        i += 1;
  40061a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  40061c:	8ba6                	mv	s7,s1
      state = 0;
  40061e:	4981                	li	s3,0
        i += 1;
  400620:	b72d                	j	40054a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400622:	06400793          	li	a5,100
  400626:	02f60763          	beq	a2,a5,400654 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  40062a:	07500793          	li	a5,117
  40062e:	06f60963          	beq	a2,a5,4006a0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  400632:	07800793          	li	a5,120
  400636:	faf61ee3          	bne	a2,a5,4005f2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  40063a:	008b8493          	addi	s1,s7,8
  40063e:	4681                	li	a3,0
  400640:	4641                	li	a2,16
  400642:	000ba583          	lw	a1,0(s7)
  400646:	855a                	mv	a0,s6
  400648:	e23ff0ef          	jal	40046a <printint>
        i += 2;
  40064c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  40064e:	8ba6                	mv	s7,s1
      state = 0;
  400650:	4981                	li	s3,0
        i += 2;
  400652:	bde5                	j	40054a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400654:	008b8493          	addi	s1,s7,8
  400658:	4685                	li	a3,1
  40065a:	4629                	li	a2,10
  40065c:	000ba583          	lw	a1,0(s7)
  400660:	855a                	mv	a0,s6
  400662:	e09ff0ef          	jal	40046a <printint>
        i += 2;
  400666:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  400668:	8ba6                	mv	s7,s1
      state = 0;
  40066a:	4981                	li	s3,0
        i += 2;
  40066c:	bdf9                	j	40054a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  40066e:	008b8493          	addi	s1,s7,8
  400672:	4681                	li	a3,0
  400674:	4629                	li	a2,10
  400676:	000ba583          	lw	a1,0(s7)
  40067a:	855a                	mv	a0,s6
  40067c:	defff0ef          	jal	40046a <printint>
  400680:	8ba6                	mv	s7,s1
      state = 0;
  400682:	4981                	li	s3,0
  400684:	b5d9                	j	40054a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400686:	008b8493          	addi	s1,s7,8
  40068a:	4681                	li	a3,0
  40068c:	4629                	li	a2,10
  40068e:	000ba583          	lw	a1,0(s7)
  400692:	855a                	mv	a0,s6
  400694:	dd7ff0ef          	jal	40046a <printint>
        i += 1;
  400698:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  40069a:	8ba6                	mv	s7,s1
      state = 0;
  40069c:	4981                	li	s3,0
        i += 1;
  40069e:	b575                	j	40054a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006a0:	008b8493          	addi	s1,s7,8
  4006a4:	4681                	li	a3,0
  4006a6:	4629                	li	a2,10
  4006a8:	000ba583          	lw	a1,0(s7)
  4006ac:	855a                	mv	a0,s6
  4006ae:	dbdff0ef          	jal	40046a <printint>
        i += 2;
  4006b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006b4:	8ba6                	mv	s7,s1
      state = 0;
  4006b6:	4981                	li	s3,0
        i += 2;
  4006b8:	bd49                	j	40054a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  4006ba:	008b8493          	addi	s1,s7,8
  4006be:	4681                	li	a3,0
  4006c0:	4641                	li	a2,16
  4006c2:	000ba583          	lw	a1,0(s7)
  4006c6:	855a                	mv	a0,s6
  4006c8:	da3ff0ef          	jal	40046a <printint>
  4006cc:	8ba6                	mv	s7,s1
      state = 0;
  4006ce:	4981                	li	s3,0
  4006d0:	bdad                	j	40054a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006d2:	008b8493          	addi	s1,s7,8
  4006d6:	4681                	li	a3,0
  4006d8:	4641                	li	a2,16
  4006da:	000ba583          	lw	a1,0(s7)
  4006de:	855a                	mv	a0,s6
  4006e0:	d8bff0ef          	jal	40046a <printint>
        i += 1;
  4006e4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006e6:	8ba6                	mv	s7,s1
      state = 0;
  4006e8:	4981                	li	s3,0
        i += 1;
  4006ea:	b585                	j	40054a <vprintf+0x4a>
  4006ec:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  4006ee:	008b8d13          	addi	s10,s7,8
  4006f2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  4006f6:	03000593          	li	a1,48
  4006fa:	855a                	mv	a0,s6
  4006fc:	d51ff0ef          	jal	40044c <putc>
  putc(fd, 'x');
  400700:	07800593          	li	a1,120
  400704:	855a                	mv	a0,s6
  400706:	d47ff0ef          	jal	40044c <putc>
  40070a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  40070c:	00000b97          	auipc	s7,0x0
  400710:	2a4b8b93          	addi	s7,s7,676 # 4009b0 <digits>
  400714:	03c9d793          	srli	a5,s3,0x3c
  400718:	97de                	add	a5,a5,s7
  40071a:	0007c583          	lbu	a1,0(a5)
  40071e:	855a                	mv	a0,s6
  400720:	d2dff0ef          	jal	40044c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400724:	0992                	slli	s3,s3,0x4
  400726:	34fd                	addiw	s1,s1,-1
  400728:	f4f5                	bnez	s1,400714 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  40072a:	8bea                	mv	s7,s10
      state = 0;
  40072c:	4981                	li	s3,0
  40072e:	6d02                	ld	s10,0(sp)
  400730:	bd29                	j	40054a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  400732:	008b8993          	addi	s3,s7,8
  400736:	000bb483          	ld	s1,0(s7)
  40073a:	cc91                	beqz	s1,400756 <vprintf+0x256>
        for(; *s; s++)
  40073c:	0004c583          	lbu	a1,0(s1)
  400740:	c195                	beqz	a1,400764 <vprintf+0x264>
          putc(fd, *s);
  400742:	855a                	mv	a0,s6
  400744:	d09ff0ef          	jal	40044c <putc>
        for(; *s; s++)
  400748:	0485                	addi	s1,s1,1
  40074a:	0004c583          	lbu	a1,0(s1)
  40074e:	f9f5                	bnez	a1,400742 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400750:	8bce                	mv	s7,s3
      state = 0;
  400752:	4981                	li	s3,0
  400754:	bbdd                	j	40054a <vprintf+0x4a>
          s = "(null)";
  400756:	00000497          	auipc	s1,0x0
  40075a:	25248493          	addi	s1,s1,594 # 4009a8 <malloc+0x13e>
        for(; *s; s++)
  40075e:	02800593          	li	a1,40
  400762:	b7c5                	j	400742 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400764:	8bce                	mv	s7,s3
      state = 0;
  400766:	4981                	li	s3,0
  400768:	b3cd                	j	40054a <vprintf+0x4a>
  40076a:	6906                	ld	s2,64(sp)
  40076c:	79e2                	ld	s3,56(sp)
  40076e:	7a42                	ld	s4,48(sp)
  400770:	7aa2                	ld	s5,40(sp)
  400772:	7b02                	ld	s6,32(sp)
  400774:	6be2                	ld	s7,24(sp)
  400776:	6c42                	ld	s8,16(sp)
  400778:	6ca2                	ld	s9,8(sp)
    }
  }
}
  40077a:	60e6                	ld	ra,88(sp)
  40077c:	6446                	ld	s0,80(sp)
  40077e:	64a6                	ld	s1,72(sp)
  400780:	6125                	addi	sp,sp,96
  400782:	8082                	ret

0000000000400784 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  400784:	715d                	addi	sp,sp,-80
  400786:	ec06                	sd	ra,24(sp)
  400788:	e822                	sd	s0,16(sp)
  40078a:	1000                	addi	s0,sp,32
  40078c:	e010                	sd	a2,0(s0)
  40078e:	e414                	sd	a3,8(s0)
  400790:	e818                	sd	a4,16(s0)
  400792:	ec1c                	sd	a5,24(s0)
  400794:	03043023          	sd	a6,32(s0)
  400798:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  40079c:	8622                	mv	a2,s0
  40079e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  4007a2:	d5fff0ef          	jal	400500 <vprintf>
  return 0;
}
  4007a6:	4501                	li	a0,0
  4007a8:	60e2                	ld	ra,24(sp)
  4007aa:	6442                	ld	s0,16(sp)
  4007ac:	6161                	addi	sp,sp,80
  4007ae:	8082                	ret

00000000004007b0 <printf>:

int
printf(const char *fmt, ...)
{
  4007b0:	711d                	addi	sp,sp,-96
  4007b2:	ec06                	sd	ra,24(sp)
  4007b4:	e822                	sd	s0,16(sp)
  4007b6:	1000                	addi	s0,sp,32
  4007b8:	e40c                	sd	a1,8(s0)
  4007ba:	e810                	sd	a2,16(s0)
  4007bc:	ec14                	sd	a3,24(s0)
  4007be:	f018                	sd	a4,32(s0)
  4007c0:	f41c                	sd	a5,40(s0)
  4007c2:	03043823          	sd	a6,48(s0)
  4007c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  4007ca:	00840613          	addi	a2,s0,8
  4007ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  4007d2:	85aa                	mv	a1,a0
  4007d4:	4505                	li	a0,1
  4007d6:	d2bff0ef          	jal	400500 <vprintf>
  return 0;
}
  4007da:	4501                	li	a0,0
  4007dc:	60e2                	ld	ra,24(sp)
  4007de:	6442                	ld	s0,16(sp)
  4007e0:	6125                	addi	sp,sp,96
  4007e2:	8082                	ret

00000000004007e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  4007e4:	1141                	addi	sp,sp,-16
  4007e6:	e406                	sd	ra,8(sp)
  4007e8:	e022                	sd	s0,0(sp)
  4007ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  4007ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4007f0:	00001797          	auipc	a5,0x1
  4007f4:	8107b783          	ld	a5,-2032(a5) # 401000 <freep>
  4007f8:	a02d                	j	400822 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  4007fa:	4618                	lw	a4,8(a2)
  4007fc:	9f2d                	addw	a4,a4,a1
  4007fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400802:	6398                	ld	a4,0(a5)
  400804:	6310                	ld	a2,0(a4)
  400806:	a83d                	j	400844 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400808:	ff852703          	lw	a4,-8(a0)
  40080c:	9f31                	addw	a4,a4,a2
  40080e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400810:	ff053683          	ld	a3,-16(a0)
  400814:	a091                	j	400858 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400816:	6398                	ld	a4,0(a5)
  400818:	00e7e463          	bltu	a5,a4,400820 <free+0x3c>
  40081c:	00e6ea63          	bltu	a3,a4,400830 <free+0x4c>
{
  400820:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400822:	fed7fae3          	bgeu	a5,a3,400816 <free+0x32>
  400826:	6398                	ld	a4,0(a5)
  400828:	00e6e463          	bltu	a3,a4,400830 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40082c:	fee7eae3          	bltu	a5,a4,400820 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  400830:	ff852583          	lw	a1,-8(a0)
  400834:	6390                	ld	a2,0(a5)
  400836:	02059813          	slli	a6,a1,0x20
  40083a:	01c85713          	srli	a4,a6,0x1c
  40083e:	9736                	add	a4,a4,a3
  400840:	fae60de3          	beq	a2,a4,4007fa <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  400844:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  400848:	4790                	lw	a2,8(a5)
  40084a:	02061593          	slli	a1,a2,0x20
  40084e:	01c5d713          	srli	a4,a1,0x1c
  400852:	973e                	add	a4,a4,a5
  400854:	fae68ae3          	beq	a3,a4,400808 <free+0x24>
    p->s.ptr = bp->s.ptr;
  400858:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  40085a:	00000717          	auipc	a4,0x0
  40085e:	7af73323          	sd	a5,1958(a4) # 401000 <freep>
}
  400862:	60a2                	ld	ra,8(sp)
  400864:	6402                	ld	s0,0(sp)
  400866:	0141                	addi	sp,sp,16
  400868:	8082                	ret

000000000040086a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  40086a:	7139                	addi	sp,sp,-64
  40086c:	fc06                	sd	ra,56(sp)
  40086e:	f822                	sd	s0,48(sp)
  400870:	f04a                	sd	s2,32(sp)
  400872:	ec4e                	sd	s3,24(sp)
  400874:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  400876:	02051993          	slli	s3,a0,0x20
  40087a:	0209d993          	srli	s3,s3,0x20
  40087e:	09bd                	addi	s3,s3,15
  400880:	0049d993          	srli	s3,s3,0x4
  400884:	2985                	addiw	s3,s3,1
  400886:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  400888:	00000517          	auipc	a0,0x0
  40088c:	77853503          	ld	a0,1912(a0) # 401000 <freep>
  400890:	c905                	beqz	a0,4008c0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400894:	4798                	lw	a4,8(a5)
  400896:	09377663          	bgeu	a4,s3,400922 <malloc+0xb8>
  40089a:	f426                	sd	s1,40(sp)
  40089c:	e852                	sd	s4,16(sp)
  40089e:	e456                	sd	s5,8(sp)
  4008a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  4008a2:	8a4e                	mv	s4,s3
  4008a4:	6705                	lui	a4,0x1
  4008a6:	00e9f363          	bgeu	s3,a4,4008ac <malloc+0x42>
  4008aa:	6a05                	lui	s4,0x1
  4008ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  4008b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  4008b4:	00000497          	auipc	s1,0x0
  4008b8:	74c48493          	addi	s1,s1,1868 # 401000 <freep>
  if(p == (char*)-1)
  4008bc:	5afd                	li	s5,-1
  4008be:	a83d                	j	4008fc <malloc+0x92>
  4008c0:	f426                	sd	s1,40(sp)
  4008c2:	e852                	sd	s4,16(sp)
  4008c4:	e456                	sd	s5,8(sp)
  4008c6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  4008c8:	00001797          	auipc	a5,0x1
  4008cc:	94878793          	addi	a5,a5,-1720 # 401210 <base>
  4008d0:	00000717          	auipc	a4,0x0
  4008d4:	72f73823          	sd	a5,1840(a4) # 401000 <freep>
  4008d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  4008da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  4008de:	b7d1                	j	4008a2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  4008e0:	6398                	ld	a4,0(a5)
  4008e2:	e118                	sd	a4,0(a0)
  4008e4:	a899                	j	40093a <malloc+0xd0>
  hp->s.size = nu;
  4008e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  4008ea:	0541                	addi	a0,a0,16
  4008ec:	ef9ff0ef          	jal	4007e4 <free>
  return freep;
  4008f0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  4008f2:	c125                	beqz	a0,400952 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4008f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4008f6:	4798                	lw	a4,8(a5)
  4008f8:	03277163          	bgeu	a4,s2,40091a <malloc+0xb0>
    if(p == freep)
  4008fc:	6098                	ld	a4,0(s1)
  4008fe:	853e                	mv	a0,a5
  400900:	fef71ae3          	bne	a4,a5,4008f4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400904:	8552                	mv	a0,s4
  400906:	b17ff0ef          	jal	40041c <sbrk>
  if(p == (char*)-1)
  40090a:	fd551ee3          	bne	a0,s5,4008e6 <malloc+0x7c>
        return 0;
  40090e:	4501                	li	a0,0
  400910:	74a2                	ld	s1,40(sp)
  400912:	6a42                	ld	s4,16(sp)
  400914:	6aa2                	ld	s5,8(sp)
  400916:	6b02                	ld	s6,0(sp)
  400918:	a03d                	j	400946 <malloc+0xdc>
  40091a:	74a2                	ld	s1,40(sp)
  40091c:	6a42                	ld	s4,16(sp)
  40091e:	6aa2                	ld	s5,8(sp)
  400920:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400922:	fae90fe3          	beq	s2,a4,4008e0 <malloc+0x76>
        p->s.size -= nunits;
  400926:	4137073b          	subw	a4,a4,s3
  40092a:	c798                	sw	a4,8(a5)
        p += p->s.size;
  40092c:	02071693          	slli	a3,a4,0x20
  400930:	01c6d713          	srli	a4,a3,0x1c
  400934:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  400936:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  40093a:	00000717          	auipc	a4,0x0
  40093e:	6ca73323          	sd	a0,1734(a4) # 401000 <freep>
      return (void*)(p + 1);
  400942:	01078513          	addi	a0,a5,16
  }
}
  400946:	70e2                	ld	ra,56(sp)
  400948:	7442                	ld	s0,48(sp)
  40094a:	7902                	ld	s2,32(sp)
  40094c:	69e2                	ld	s3,24(sp)
  40094e:	6121                	addi	sp,sp,64
  400950:	8082                	ret
  400952:	74a2                	ld	s1,40(sp)
  400954:	6a42                	ld	s4,16(sp)
  400956:	6aa2                	ld	s5,8(sp)
  400958:	6b02                	ld	s6,0(sp)
  40095a:	b7f5                	j	400946 <malloc+0xdc>
