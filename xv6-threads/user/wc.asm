
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
  400000:	7119                	addi	sp,sp,-128
  400002:	fc86                	sd	ra,120(sp)
  400004:	f8a2                	sd	s0,112(sp)
  400006:	f4a6                	sd	s1,104(sp)
  400008:	f0ca                	sd	s2,96(sp)
  40000a:	ecce                	sd	s3,88(sp)
  40000c:	e8d2                	sd	s4,80(sp)
  40000e:	e4d6                	sd	s5,72(sp)
  400010:	e0da                	sd	s6,64(sp)
  400012:	fc5e                	sd	s7,56(sp)
  400014:	f862                	sd	s8,48(sp)
  400016:	f466                	sd	s9,40(sp)
  400018:	f06a                	sd	s10,32(sp)
  40001a:	ec6e                	sd	s11,24(sp)
  40001c:	0100                	addi	s0,sp,128
  40001e:	f8a43423          	sd	a0,-120(s0)
  400022:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  400026:	4901                	li	s2,0
  l = w = c = 0;
  400028:	4c81                	li	s9,0
  40002a:	4c01                	li	s8,0
  40002c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  40002e:	00001d97          	auipc	s11,0x1
  400032:	fe2d8d93          	addi	s11,s11,-30 # 401010 <buf>
  400036:	20000d13          	li	s10,512
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  40003a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  40003c:	00001a17          	auipc	s4,0x1
  400040:	994a0a13          	addi	s4,s4,-1644 # 4009d0 <malloc+0x100>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  400044:	a035                	j	400070 <wc+0x70>
      if(strchr(" \r\t\n\v", buf[i]))
  400046:	8552                	mv	a0,s4
  400048:	1ca000ef          	jal	400212 <strchr>
  40004c:	c919                	beqz	a0,400062 <wc+0x62>
        inword = 0;
  40004e:	4901                	li	s2,0
    for(i=0; i<n; i++){
  400050:	0485                	addi	s1,s1,1
  400052:	01348d63          	beq	s1,s3,40006c <wc+0x6c>
      if(buf[i] == '\n')
  400056:	0004c583          	lbu	a1,0(s1)
  40005a:	ff5596e3          	bne	a1,s5,400046 <wc+0x46>
        l++;
  40005e:	2b85                	addiw	s7,s7,1
  400060:	b7dd                	j	400046 <wc+0x46>
      else if(!inword){
  400062:	fe0917e3          	bnez	s2,400050 <wc+0x50>
        w++;
  400066:	2c05                	addiw	s8,s8,1
        inword = 1;
  400068:	4905                	li	s2,1
  40006a:	b7dd                	j	400050 <wc+0x50>
  40006c:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  400070:	866a                	mv	a2,s10
  400072:	85ee                	mv	a1,s11
  400074:	f8843503          	ld	a0,-120(s0)
  400078:	39a000ef          	jal	400412 <read>
  40007c:	8b2a                	mv	s6,a0
  40007e:	00a05963          	blez	a0,400090 <wc+0x90>
  400082:	00001497          	auipc	s1,0x1
  400086:	f8e48493          	addi	s1,s1,-114 # 401010 <buf>
  40008a:	009b09b3          	add	s3,s6,s1
  40008e:	b7e1                	j	400056 <wc+0x56>
      }
    }
  }
  if(n < 0){
  400090:	02054c63          	bltz	a0,4000c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  400094:	f8043703          	ld	a4,-128(s0)
  400098:	86e6                	mv	a3,s9
  40009a:	8662                	mv	a2,s8
  40009c:	85de                	mv	a1,s7
  40009e:	00001517          	auipc	a0,0x1
  4000a2:	95250513          	addi	a0,a0,-1710 # 4009f0 <malloc+0x120>
  4000a6:	770000ef          	jal	400816 <printf>
}
  4000aa:	70e6                	ld	ra,120(sp)
  4000ac:	7446                	ld	s0,112(sp)
  4000ae:	74a6                	ld	s1,104(sp)
  4000b0:	7906                	ld	s2,96(sp)
  4000b2:	69e6                	ld	s3,88(sp)
  4000b4:	6a46                	ld	s4,80(sp)
  4000b6:	6aa6                	ld	s5,72(sp)
  4000b8:	6b06                	ld	s6,64(sp)
  4000ba:	7be2                	ld	s7,56(sp)
  4000bc:	7c42                	ld	s8,48(sp)
  4000be:	7ca2                	ld	s9,40(sp)
  4000c0:	7d02                	ld	s10,32(sp)
  4000c2:	6de2                	ld	s11,24(sp)
  4000c4:	6109                	addi	sp,sp,128
  4000c6:	8082                	ret
    printf("wc: read error\n");
  4000c8:	00001517          	auipc	a0,0x1
  4000cc:	91850513          	addi	a0,a0,-1768 # 4009e0 <malloc+0x110>
  4000d0:	746000ef          	jal	400816 <printf>
    exit(1);
  4000d4:	4505                	li	a0,1
  4000d6:	324000ef          	jal	4003fa <exit>

00000000004000da <main>:

int
main(int argc, char *argv[])
{
  4000da:	7179                	addi	sp,sp,-48
  4000dc:	f406                	sd	ra,40(sp)
  4000de:	f022                	sd	s0,32(sp)
  4000e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  4000e2:	4785                	li	a5,1
  4000e4:	04a7d463          	bge	a5,a0,40012c <main+0x52>
  4000e8:	ec26                	sd	s1,24(sp)
  4000ea:	e84a                	sd	s2,16(sp)
  4000ec:	e44e                	sd	s3,8(sp)
  4000ee:	00858913          	addi	s2,a1,8
  4000f2:	ffe5099b          	addiw	s3,a0,-2
  4000f6:	02099793          	slli	a5,s3,0x20
  4000fa:	01d7d993          	srli	s3,a5,0x1d
  4000fe:	05c1                	addi	a1,a1,16
  400100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  400102:	4581                	li	a1,0
  400104:	00093503          	ld	a0,0(s2)
  400108:	332000ef          	jal	40043a <open>
  40010c:	84aa                	mv	s1,a0
  40010e:	02054c63          	bltz	a0,400146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
  400112:	00093583          	ld	a1,0(s2)
  400116:	eebff0ef          	jal	400000 <wc>
    close(fd);
  40011a:	8526                	mv	a0,s1
  40011c:	306000ef          	jal	400422 <close>
  for(i = 1; i < argc; i++){
  400120:	0921                	addi	s2,s2,8
  400122:	ff3910e3          	bne	s2,s3,400102 <main+0x28>
  }
  exit(0);
  400126:	4501                	li	a0,0
  400128:	2d2000ef          	jal	4003fa <exit>
  40012c:	ec26                	sd	s1,24(sp)
  40012e:	e84a                	sd	s2,16(sp)
  400130:	e44e                	sd	s3,8(sp)
    wc(0, "");
  400132:	00001597          	auipc	a1,0x1
  400136:	8a658593          	addi	a1,a1,-1882 # 4009d8 <malloc+0x108>
  40013a:	4501                	li	a0,0
  40013c:	ec5ff0ef          	jal	400000 <wc>
    exit(0);
  400140:	4501                	li	a0,0
  400142:	2b8000ef          	jal	4003fa <exit>
      printf("wc: cannot open %s\n", argv[i]);
  400146:	00093583          	ld	a1,0(s2)
  40014a:	00001517          	auipc	a0,0x1
  40014e:	8b650513          	addi	a0,a0,-1866 # 400a00 <malloc+0x130>
  400152:	6c4000ef          	jal	400816 <printf>
      exit(1);
  400156:	4505                	li	a0,1
  400158:	2a2000ef          	jal	4003fa <exit>

000000000040015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  40015c:	1141                	addi	sp,sp,-16
  40015e:	e406                	sd	ra,8(sp)
  400160:	e022                	sd	s0,0(sp)
  400162:	0800                	addi	s0,sp,16
  extern int main();
  main();
  400164:	f77ff0ef          	jal	4000da <main>
  exit(0);
  400168:	4501                	li	a0,0
  40016a:	290000ef          	jal	4003fa <exit>

000000000040016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  40016e:	1141                	addi	sp,sp,-16
  400170:	e406                	sd	ra,8(sp)
  400172:	e022                	sd	s0,0(sp)
  400174:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  400176:	87aa                	mv	a5,a0
  400178:	0585                	addi	a1,a1,1
  40017a:	0785                	addi	a5,a5,1
  40017c:	fff5c703          	lbu	a4,-1(a1)
  400180:	fee78fa3          	sb	a4,-1(a5)
  400184:	fb75                	bnez	a4,400178 <strcpy+0xa>
    ;
  return os;
}
  400186:	60a2                	ld	ra,8(sp)
  400188:	6402                	ld	s0,0(sp)
  40018a:	0141                	addi	sp,sp,16
  40018c:	8082                	ret

000000000040018e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40018e:	1141                	addi	sp,sp,-16
  400190:	e406                	sd	ra,8(sp)
  400192:	e022                	sd	s0,0(sp)
  400194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  400196:	00054783          	lbu	a5,0(a0)
  40019a:	cb91                	beqz	a5,4001ae <strcmp+0x20>
  40019c:	0005c703          	lbu	a4,0(a1)
  4001a0:	00f71763          	bne	a4,a5,4001ae <strcmp+0x20>
    p++, q++;
  4001a4:	0505                	addi	a0,a0,1
  4001a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4001a8:	00054783          	lbu	a5,0(a0)
  4001ac:	fbe5                	bnez	a5,40019c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4001ae:	0005c503          	lbu	a0,0(a1)
}
  4001b2:	40a7853b          	subw	a0,a5,a0
  4001b6:	60a2                	ld	ra,8(sp)
  4001b8:	6402                	ld	s0,0(sp)
  4001ba:	0141                	addi	sp,sp,16
  4001bc:	8082                	ret

00000000004001be <strlen>:

uint
strlen(const char *s)
{
  4001be:	1141                	addi	sp,sp,-16
  4001c0:	e406                	sd	ra,8(sp)
  4001c2:	e022                	sd	s0,0(sp)
  4001c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4001c6:	00054783          	lbu	a5,0(a0)
  4001ca:	cf99                	beqz	a5,4001e8 <strlen+0x2a>
  4001cc:	0505                	addi	a0,a0,1
  4001ce:	87aa                	mv	a5,a0
  4001d0:	86be                	mv	a3,a5
  4001d2:	0785                	addi	a5,a5,1
  4001d4:	fff7c703          	lbu	a4,-1(a5)
  4001d8:	ff65                	bnez	a4,4001d0 <strlen+0x12>
  4001da:	40a6853b          	subw	a0,a3,a0
  4001de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4001e0:	60a2                	ld	ra,8(sp)
  4001e2:	6402                	ld	s0,0(sp)
  4001e4:	0141                	addi	sp,sp,16
  4001e6:	8082                	ret
  for(n = 0; s[n]; n++)
  4001e8:	4501                	li	a0,0
  4001ea:	bfdd                	j	4001e0 <strlen+0x22>

00000000004001ec <memset>:

void*
memset(void *dst, int c, uint n)
{
  4001ec:	1141                	addi	sp,sp,-16
  4001ee:	e406                	sd	ra,8(sp)
  4001f0:	e022                	sd	s0,0(sp)
  4001f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  4001f4:	ca19                	beqz	a2,40020a <memset+0x1e>
  4001f6:	87aa                	mv	a5,a0
  4001f8:	1602                	slli	a2,a2,0x20
  4001fa:	9201                	srli	a2,a2,0x20
  4001fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400200:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400204:	0785                	addi	a5,a5,1
  400206:	fee79de3          	bne	a5,a4,400200 <memset+0x14>
  }
  return dst;
}
  40020a:	60a2                	ld	ra,8(sp)
  40020c:	6402                	ld	s0,0(sp)
  40020e:	0141                	addi	sp,sp,16
  400210:	8082                	ret

0000000000400212 <strchr>:

char*
strchr(const char *s, char c)
{
  400212:	1141                	addi	sp,sp,-16
  400214:	e406                	sd	ra,8(sp)
  400216:	e022                	sd	s0,0(sp)
  400218:	0800                	addi	s0,sp,16
  for(; *s; s++)
  40021a:	00054783          	lbu	a5,0(a0)
  40021e:	cf81                	beqz	a5,400236 <strchr+0x24>
    if(*s == c)
  400220:	00f58763          	beq	a1,a5,40022e <strchr+0x1c>
  for(; *s; s++)
  400224:	0505                	addi	a0,a0,1
  400226:	00054783          	lbu	a5,0(a0)
  40022a:	fbfd                	bnez	a5,400220 <strchr+0xe>
      return (char*)s;
  return 0;
  40022c:	4501                	li	a0,0
}
  40022e:	60a2                	ld	ra,8(sp)
  400230:	6402                	ld	s0,0(sp)
  400232:	0141                	addi	sp,sp,16
  400234:	8082                	ret
  return 0;
  400236:	4501                	li	a0,0
  400238:	bfdd                	j	40022e <strchr+0x1c>

000000000040023a <gets>:

char*
gets(char *buf, int max)
{
  40023a:	7159                	addi	sp,sp,-112
  40023c:	f486                	sd	ra,104(sp)
  40023e:	f0a2                	sd	s0,96(sp)
  400240:	eca6                	sd	s1,88(sp)
  400242:	e8ca                	sd	s2,80(sp)
  400244:	e4ce                	sd	s3,72(sp)
  400246:	e0d2                	sd	s4,64(sp)
  400248:	fc56                	sd	s5,56(sp)
  40024a:	f85a                	sd	s6,48(sp)
  40024c:	f45e                	sd	s7,40(sp)
  40024e:	f062                	sd	s8,32(sp)
  400250:	ec66                	sd	s9,24(sp)
  400252:	e86a                	sd	s10,16(sp)
  400254:	1880                	addi	s0,sp,112
  400256:	8caa                	mv	s9,a0
  400258:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  40025a:	892a                	mv	s2,a0
  40025c:	4481                	li	s1,0
    cc = read(0, &c, 1);
  40025e:	f9f40b13          	addi	s6,s0,-97
  400262:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400264:	4ba9                	li	s7,10
  400266:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400268:	8d26                	mv	s10,s1
  40026a:	0014899b          	addiw	s3,s1,1
  40026e:	84ce                	mv	s1,s3
  400270:	0349d563          	bge	s3,s4,40029a <gets+0x60>
    cc = read(0, &c, 1);
  400274:	8656                	mv	a2,s5
  400276:	85da                	mv	a1,s6
  400278:	4501                	li	a0,0
  40027a:	198000ef          	jal	400412 <read>
    if(cc < 1)
  40027e:	00a05e63          	blez	a0,40029a <gets+0x60>
    buf[i++] = c;
  400282:	f9f44783          	lbu	a5,-97(s0)
  400286:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  40028a:	01778763          	beq	a5,s7,400298 <gets+0x5e>
  40028e:	0905                	addi	s2,s2,1
  400290:	fd879ce3          	bne	a5,s8,400268 <gets+0x2e>
    buf[i++] = c;
  400294:	8d4e                	mv	s10,s3
  400296:	a011                	j	40029a <gets+0x60>
  400298:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  40029a:	9d66                	add	s10,s10,s9
  40029c:	000d0023          	sb	zero,0(s10)
  return buf;
}
  4002a0:	8566                	mv	a0,s9
  4002a2:	70a6                	ld	ra,104(sp)
  4002a4:	7406                	ld	s0,96(sp)
  4002a6:	64e6                	ld	s1,88(sp)
  4002a8:	6946                	ld	s2,80(sp)
  4002aa:	69a6                	ld	s3,72(sp)
  4002ac:	6a06                	ld	s4,64(sp)
  4002ae:	7ae2                	ld	s5,56(sp)
  4002b0:	7b42                	ld	s6,48(sp)
  4002b2:	7ba2                	ld	s7,40(sp)
  4002b4:	7c02                	ld	s8,32(sp)
  4002b6:	6ce2                	ld	s9,24(sp)
  4002b8:	6d42                	ld	s10,16(sp)
  4002ba:	6165                	addi	sp,sp,112
  4002bc:	8082                	ret

00000000004002be <stat>:

int
stat(const char *n, struct stat *st)
{
  4002be:	1101                	addi	sp,sp,-32
  4002c0:	ec06                	sd	ra,24(sp)
  4002c2:	e822                	sd	s0,16(sp)
  4002c4:	e04a                	sd	s2,0(sp)
  4002c6:	1000                	addi	s0,sp,32
  4002c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4002ca:	4581                	li	a1,0
  4002cc:	16e000ef          	jal	40043a <open>
  if(fd < 0)
  4002d0:	02054263          	bltz	a0,4002f4 <stat+0x36>
  4002d4:	e426                	sd	s1,8(sp)
  4002d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4002d8:	85ca                	mv	a1,s2
  4002da:	178000ef          	jal	400452 <fstat>
  4002de:	892a                	mv	s2,a0
  close(fd);
  4002e0:	8526                	mv	a0,s1
  4002e2:	140000ef          	jal	400422 <close>
  return r;
  4002e6:	64a2                	ld	s1,8(sp)
}
  4002e8:	854a                	mv	a0,s2
  4002ea:	60e2                	ld	ra,24(sp)
  4002ec:	6442                	ld	s0,16(sp)
  4002ee:	6902                	ld	s2,0(sp)
  4002f0:	6105                	addi	sp,sp,32
  4002f2:	8082                	ret
    return -1;
  4002f4:	597d                	li	s2,-1
  4002f6:	bfcd                	j	4002e8 <stat+0x2a>

00000000004002f8 <atoi>:

int
atoi(const char *s)
{
  4002f8:	1141                	addi	sp,sp,-16
  4002fa:	e406                	sd	ra,8(sp)
  4002fc:	e022                	sd	s0,0(sp)
  4002fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400300:	00054683          	lbu	a3,0(a0)
  400304:	fd06879b          	addiw	a5,a3,-48
  400308:	0ff7f793          	zext.b	a5,a5
  40030c:	4625                	li	a2,9
  40030e:	02f66963          	bltu	a2,a5,400340 <atoi+0x48>
  400312:	872a                	mv	a4,a0
  n = 0;
  400314:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400316:	0705                	addi	a4,a4,1
  400318:	0025179b          	slliw	a5,a0,0x2
  40031c:	9fa9                	addw	a5,a5,a0
  40031e:	0017979b          	slliw	a5,a5,0x1
  400322:	9fb5                	addw	a5,a5,a3
  400324:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400328:	00074683          	lbu	a3,0(a4)
  40032c:	fd06879b          	addiw	a5,a3,-48
  400330:	0ff7f793          	zext.b	a5,a5
  400334:	fef671e3          	bgeu	a2,a5,400316 <atoi+0x1e>
  return n;
}
  400338:	60a2                	ld	ra,8(sp)
  40033a:	6402                	ld	s0,0(sp)
  40033c:	0141                	addi	sp,sp,16
  40033e:	8082                	ret
  n = 0;
  400340:	4501                	li	a0,0
  400342:	bfdd                	j	400338 <atoi+0x40>

0000000000400344 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400344:	1141                	addi	sp,sp,-16
  400346:	e406                	sd	ra,8(sp)
  400348:	e022                	sd	s0,0(sp)
  40034a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  40034c:	02b57563          	bgeu	a0,a1,400376 <memmove+0x32>
    while(n-- > 0)
  400350:	00c05f63          	blez	a2,40036e <memmove+0x2a>
  400354:	1602                	slli	a2,a2,0x20
  400356:	9201                	srli	a2,a2,0x20
  400358:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  40035c:	872a                	mv	a4,a0
      *dst++ = *src++;
  40035e:	0585                	addi	a1,a1,1
  400360:	0705                	addi	a4,a4,1
  400362:	fff5c683          	lbu	a3,-1(a1)
  400366:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  40036a:	fee79ae3          	bne	a5,a4,40035e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  40036e:	60a2                	ld	ra,8(sp)
  400370:	6402                	ld	s0,0(sp)
  400372:	0141                	addi	sp,sp,16
  400374:	8082                	ret
    dst += n;
  400376:	00c50733          	add	a4,a0,a2
    src += n;
  40037a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  40037c:	fec059e3          	blez	a2,40036e <memmove+0x2a>
  400380:	fff6079b          	addiw	a5,a2,-1
  400384:	1782                	slli	a5,a5,0x20
  400386:	9381                	srli	a5,a5,0x20
  400388:	fff7c793          	not	a5,a5
  40038c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  40038e:	15fd                	addi	a1,a1,-1
  400390:	177d                	addi	a4,a4,-1
  400392:	0005c683          	lbu	a3,0(a1)
  400396:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  40039a:	fef71ae3          	bne	a4,a5,40038e <memmove+0x4a>
  40039e:	bfc1                	j	40036e <memmove+0x2a>

00000000004003a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  4003a0:	1141                	addi	sp,sp,-16
  4003a2:	e406                	sd	ra,8(sp)
  4003a4:	e022                	sd	s0,0(sp)
  4003a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4003a8:	ca0d                	beqz	a2,4003da <memcmp+0x3a>
  4003aa:	fff6069b          	addiw	a3,a2,-1
  4003ae:	1682                	slli	a3,a3,0x20
  4003b0:	9281                	srli	a3,a3,0x20
  4003b2:	0685                	addi	a3,a3,1
  4003b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4003b6:	00054783          	lbu	a5,0(a0)
  4003ba:	0005c703          	lbu	a4,0(a1)
  4003be:	00e79863          	bne	a5,a4,4003ce <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4003c2:	0505                	addi	a0,a0,1
    p2++;
  4003c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4003c6:	fed518e3          	bne	a0,a3,4003b6 <memcmp+0x16>
  }
  return 0;
  4003ca:	4501                	li	a0,0
  4003cc:	a019                	j	4003d2 <memcmp+0x32>
      return *p1 - *p2;
  4003ce:	40e7853b          	subw	a0,a5,a4
}
  4003d2:	60a2                	ld	ra,8(sp)
  4003d4:	6402                	ld	s0,0(sp)
  4003d6:	0141                	addi	sp,sp,16
  4003d8:	8082                	ret
  return 0;
  4003da:	4501                	li	a0,0
  4003dc:	bfdd                	j	4003d2 <memcmp+0x32>

00000000004003de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4003de:	1141                	addi	sp,sp,-16
  4003e0:	e406                	sd	ra,8(sp)
  4003e2:	e022                	sd	s0,0(sp)
  4003e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4003e6:	f5fff0ef          	jal	400344 <memmove>
}
  4003ea:	60a2                	ld	ra,8(sp)
  4003ec:	6402                	ld	s0,0(sp)
  4003ee:	0141                	addi	sp,sp,16
  4003f0:	8082                	ret

00000000004003f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  4003f2:	4885                	li	a7,1
 ecall
  4003f4:	00000073          	ecall
 ret
  4003f8:	8082                	ret

00000000004003fa <exit>:
.global exit
exit:
 li a7, SYS_exit
  4003fa:	4889                	li	a7,2
 ecall
  4003fc:	00000073          	ecall
 ret
  400400:	8082                	ret

0000000000400402 <wait>:
.global wait
wait:
 li a7, SYS_wait
  400402:	488d                	li	a7,3
 ecall
  400404:	00000073          	ecall
 ret
  400408:	8082                	ret

000000000040040a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  40040a:	4891                	li	a7,4
 ecall
  40040c:	00000073          	ecall
 ret
  400410:	8082                	ret

0000000000400412 <read>:
.global read
read:
 li a7, SYS_read
  400412:	4895                	li	a7,5
 ecall
  400414:	00000073          	ecall
 ret
  400418:	8082                	ret

000000000040041a <write>:
.global write
write:
 li a7, SYS_write
  40041a:	48c1                	li	a7,16
 ecall
  40041c:	00000073          	ecall
 ret
  400420:	8082                	ret

0000000000400422 <close>:
.global close
close:
 li a7, SYS_close
  400422:	48d5                	li	a7,21
 ecall
  400424:	00000073          	ecall
 ret
  400428:	8082                	ret

000000000040042a <kill>:
.global kill
kill:
 li a7, SYS_kill
  40042a:	4899                	li	a7,6
 ecall
  40042c:	00000073          	ecall
 ret
  400430:	8082                	ret

0000000000400432 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400432:	489d                	li	a7,7
 ecall
  400434:	00000073          	ecall
 ret
  400438:	8082                	ret

000000000040043a <open>:
.global open
open:
 li a7, SYS_open
  40043a:	48bd                	li	a7,15
 ecall
  40043c:	00000073          	ecall
 ret
  400440:	8082                	ret

0000000000400442 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400442:	48c5                	li	a7,17
 ecall
  400444:	00000073          	ecall
 ret
  400448:	8082                	ret

000000000040044a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  40044a:	48c9                	li	a7,18
 ecall
  40044c:	00000073          	ecall
 ret
  400450:	8082                	ret

0000000000400452 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  400452:	48a1                	li	a7,8
 ecall
  400454:	00000073          	ecall
 ret
  400458:	8082                	ret

000000000040045a <link>:
.global link
link:
 li a7, SYS_link
  40045a:	48cd                	li	a7,19
 ecall
  40045c:	00000073          	ecall
 ret
  400460:	8082                	ret

0000000000400462 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400462:	48d1                	li	a7,20
 ecall
  400464:	00000073          	ecall
 ret
  400468:	8082                	ret

000000000040046a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  40046a:	48a5                	li	a7,9
 ecall
  40046c:	00000073          	ecall
 ret
  400470:	8082                	ret

0000000000400472 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400472:	48a9                	li	a7,10
 ecall
  400474:	00000073          	ecall
 ret
  400478:	8082                	ret

000000000040047a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  40047a:	48ad                	li	a7,11
 ecall
  40047c:	00000073          	ecall
 ret
  400480:	8082                	ret

0000000000400482 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  400482:	48b1                	li	a7,12
 ecall
  400484:	00000073          	ecall
 ret
  400488:	8082                	ret

000000000040048a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  40048a:	48b5                	li	a7,13
 ecall
  40048c:	00000073          	ecall
 ret
  400490:	8082                	ret

0000000000400492 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  400492:	48b9                	li	a7,14
 ecall
  400494:	00000073          	ecall
 ret
  400498:	8082                	ret

000000000040049a <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  40049a:	48d9                	li	a7,22
 ecall
  40049c:	00000073          	ecall
 ret
  4004a0:	8082                	ret

00000000004004a2 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  4004a2:	48dd                	li	a7,23
 ecall
  4004a4:	00000073          	ecall
 ret
  4004a8:	8082                	ret

00000000004004aa <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4004aa:	48e1                	li	a7,24
 ecall
  4004ac:	00000073          	ecall
 ret
  4004b0:	8082                	ret

00000000004004b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4004b2:	1101                	addi	sp,sp,-32
  4004b4:	ec06                	sd	ra,24(sp)
  4004b6:	e822                	sd	s0,16(sp)
  4004b8:	1000                	addi	s0,sp,32
  4004ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4004be:	4605                	li	a2,1
  4004c0:	fef40593          	addi	a1,s0,-17
  4004c4:	f57ff0ef          	jal	40041a <write>
}
  4004c8:	60e2                	ld	ra,24(sp)
  4004ca:	6442                	ld	s0,16(sp)
  4004cc:	6105                	addi	sp,sp,32
  4004ce:	8082                	ret

00000000004004d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4004d0:	7139                	addi	sp,sp,-64
  4004d2:	fc06                	sd	ra,56(sp)
  4004d4:	f822                	sd	s0,48(sp)
  4004d6:	f426                	sd	s1,40(sp)
  4004d8:	f04a                	sd	s2,32(sp)
  4004da:	ec4e                	sd	s3,24(sp)
  4004dc:	0080                	addi	s0,sp,64
  4004de:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4004e0:	c299                	beqz	a3,4004e6 <printint+0x16>
  4004e2:	0605ce63          	bltz	a1,40055e <printint+0x8e>
  neg = 0;
  4004e6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4004e8:	fc040313          	addi	t1,s0,-64
  neg = 0;
  4004ec:	869a                	mv	a3,t1
  i = 0;
  4004ee:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  4004f0:	00000817          	auipc	a6,0x0
  4004f4:	53080813          	addi	a6,a6,1328 # 400a20 <digits>
  4004f8:	88be                	mv	a7,a5
  4004fa:	0017851b          	addiw	a0,a5,1
  4004fe:	87aa                	mv	a5,a0
  400500:	02c5f73b          	remuw	a4,a1,a2
  400504:	1702                	slli	a4,a4,0x20
  400506:	9301                	srli	a4,a4,0x20
  400508:	9742                	add	a4,a4,a6
  40050a:	00074703          	lbu	a4,0(a4)
  40050e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400512:	872e                	mv	a4,a1
  400514:	02c5d5bb          	divuw	a1,a1,a2
  400518:	0685                	addi	a3,a3,1
  40051a:	fcc77fe3          	bgeu	a4,a2,4004f8 <printint+0x28>
  if(neg)
  40051e:	000e0c63          	beqz	t3,400536 <printint+0x66>
    buf[i++] = '-';
  400522:	fd050793          	addi	a5,a0,-48
  400526:	00878533          	add	a0,a5,s0
  40052a:	02d00793          	li	a5,45
  40052e:	fef50823          	sb	a5,-16(a0)
  400532:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400536:	fff7899b          	addiw	s3,a5,-1
  40053a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  40053e:	fff4c583          	lbu	a1,-1(s1)
  400542:	854a                	mv	a0,s2
  400544:	f6fff0ef          	jal	4004b2 <putc>
  while(--i >= 0)
  400548:	39fd                	addiw	s3,s3,-1
  40054a:	14fd                	addi	s1,s1,-1
  40054c:	fe09d9e3          	bgez	s3,40053e <printint+0x6e>
}
  400550:	70e2                	ld	ra,56(sp)
  400552:	7442                	ld	s0,48(sp)
  400554:	74a2                	ld	s1,40(sp)
  400556:	7902                	ld	s2,32(sp)
  400558:	69e2                	ld	s3,24(sp)
  40055a:	6121                	addi	sp,sp,64
  40055c:	8082                	ret
    x = -xx;
  40055e:	40b005bb          	negw	a1,a1
    neg = 1;
  400562:	4e05                	li	t3,1
    x = -xx;
  400564:	b751                	j	4004e8 <printint+0x18>

0000000000400566 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400566:	711d                	addi	sp,sp,-96
  400568:	ec86                	sd	ra,88(sp)
  40056a:	e8a2                	sd	s0,80(sp)
  40056c:	e4a6                	sd	s1,72(sp)
  40056e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400570:	0005c483          	lbu	s1,0(a1)
  400574:	26048663          	beqz	s1,4007e0 <vprintf+0x27a>
  400578:	e0ca                	sd	s2,64(sp)
  40057a:	fc4e                	sd	s3,56(sp)
  40057c:	f852                	sd	s4,48(sp)
  40057e:	f456                	sd	s5,40(sp)
  400580:	f05a                	sd	s6,32(sp)
  400582:	ec5e                	sd	s7,24(sp)
  400584:	e862                	sd	s8,16(sp)
  400586:	e466                	sd	s9,8(sp)
  400588:	8b2a                	mv	s6,a0
  40058a:	8a2e                	mv	s4,a1
  40058c:	8bb2                	mv	s7,a2
  state = 0;
  40058e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400590:	4901                	li	s2,0
  400592:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  400594:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  400598:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  40059c:	06c00c93          	li	s9,108
  4005a0:	a00d                	j	4005c2 <vprintf+0x5c>
        putc(fd, c0);
  4005a2:	85a6                	mv	a1,s1
  4005a4:	855a                	mv	a0,s6
  4005a6:	f0dff0ef          	jal	4004b2 <putc>
  4005aa:	a019                	j	4005b0 <vprintf+0x4a>
    } else if(state == '%'){
  4005ac:	03598363          	beq	s3,s5,4005d2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4005b0:	0019079b          	addiw	a5,s2,1
  4005b4:	893e                	mv	s2,a5
  4005b6:	873e                	mv	a4,a5
  4005b8:	97d2                	add	a5,a5,s4
  4005ba:	0007c483          	lbu	s1,0(a5)
  4005be:	20048963          	beqz	s1,4007d0 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4005c2:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4005c6:	fe0993e3          	bnez	s3,4005ac <vprintf+0x46>
      if(c0 == '%'){
  4005ca:	fd579ce3          	bne	a5,s5,4005a2 <vprintf+0x3c>
        state = '%';
  4005ce:	89be                	mv	s3,a5
  4005d0:	b7c5                	j	4005b0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4005d2:	00ea06b3          	add	a3,s4,a4
  4005d6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4005da:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4005dc:	c681                	beqz	a3,4005e4 <vprintf+0x7e>
  4005de:	9752                	add	a4,a4,s4
  4005e0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4005e4:	03878e63          	beq	a5,s8,400620 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4005e8:	05978863          	beq	a5,s9,400638 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  4005ec:	07500713          	li	a4,117
  4005f0:	0ee78263          	beq	a5,a4,4006d4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  4005f4:	07800713          	li	a4,120
  4005f8:	12e78463          	beq	a5,a4,400720 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  4005fc:	07000713          	li	a4,112
  400600:	14e78963          	beq	a5,a4,400752 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400604:	07300713          	li	a4,115
  400608:	18e78863          	beq	a5,a4,400798 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  40060c:	02500713          	li	a4,37
  400610:	04e79463          	bne	a5,a4,400658 <vprintf+0xf2>
        putc(fd, '%');
  400614:	85ba                	mv	a1,a4
  400616:	855a                	mv	a0,s6
  400618:	e9bff0ef          	jal	4004b2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  40061c:	4981                	li	s3,0
  40061e:	bf49                	j	4005b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400620:	008b8493          	addi	s1,s7,8
  400624:	4685                	li	a3,1
  400626:	4629                	li	a2,10
  400628:	000ba583          	lw	a1,0(s7)
  40062c:	855a                	mv	a0,s6
  40062e:	ea3ff0ef          	jal	4004d0 <printint>
  400632:	8ba6                	mv	s7,s1
      state = 0;
  400634:	4981                	li	s3,0
  400636:	bfad                	j	4005b0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400638:	06400793          	li	a5,100
  40063c:	02f68963          	beq	a3,a5,40066e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400640:	06c00793          	li	a5,108
  400644:	04f68263          	beq	a3,a5,400688 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400648:	07500793          	li	a5,117
  40064c:	0af68063          	beq	a3,a5,4006ec <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400650:	07800793          	li	a5,120
  400654:	0ef68263          	beq	a3,a5,400738 <vprintf+0x1d2>
        putc(fd, '%');
  400658:	02500593          	li	a1,37
  40065c:	855a                	mv	a0,s6
  40065e:	e55ff0ef          	jal	4004b2 <putc>
        putc(fd, c0);
  400662:	85a6                	mv	a1,s1
  400664:	855a                	mv	a0,s6
  400666:	e4dff0ef          	jal	4004b2 <putc>
      state = 0;
  40066a:	4981                	li	s3,0
  40066c:	b791                	j	4005b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  40066e:	008b8493          	addi	s1,s7,8
  400672:	4685                	li	a3,1
  400674:	4629                	li	a2,10
  400676:	000ba583          	lw	a1,0(s7)
  40067a:	855a                	mv	a0,s6
  40067c:	e55ff0ef          	jal	4004d0 <printint>
        i += 1;
  400680:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  400682:	8ba6                	mv	s7,s1
      state = 0;
  400684:	4981                	li	s3,0
        i += 1;
  400686:	b72d                	j	4005b0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400688:	06400793          	li	a5,100
  40068c:	02f60763          	beq	a2,a5,4006ba <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400690:	07500793          	li	a5,117
  400694:	06f60963          	beq	a2,a5,400706 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  400698:	07800793          	li	a5,120
  40069c:	faf61ee3          	bne	a2,a5,400658 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006a0:	008b8493          	addi	s1,s7,8
  4006a4:	4681                	li	a3,0
  4006a6:	4641                	li	a2,16
  4006a8:	000ba583          	lw	a1,0(s7)
  4006ac:	855a                	mv	a0,s6
  4006ae:	e23ff0ef          	jal	4004d0 <printint>
        i += 2;
  4006b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4006b4:	8ba6                	mv	s7,s1
      state = 0;
  4006b6:	4981                	li	s3,0
        i += 2;
  4006b8:	bde5                	j	4005b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4006ba:	008b8493          	addi	s1,s7,8
  4006be:	4685                	li	a3,1
  4006c0:	4629                	li	a2,10
  4006c2:	000ba583          	lw	a1,0(s7)
  4006c6:	855a                	mv	a0,s6
  4006c8:	e09ff0ef          	jal	4004d0 <printint>
        i += 2;
  4006cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4006ce:	8ba6                	mv	s7,s1
      state = 0;
  4006d0:	4981                	li	s3,0
        i += 2;
  4006d2:	bdf9                	j	4005b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4006d4:	008b8493          	addi	s1,s7,8
  4006d8:	4681                	li	a3,0
  4006da:	4629                	li	a2,10
  4006dc:	000ba583          	lw	a1,0(s7)
  4006e0:	855a                	mv	a0,s6
  4006e2:	defff0ef          	jal	4004d0 <printint>
  4006e6:	8ba6                	mv	s7,s1
      state = 0;
  4006e8:	4981                	li	s3,0
  4006ea:	b5d9                	j	4005b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4006ec:	008b8493          	addi	s1,s7,8
  4006f0:	4681                	li	a3,0
  4006f2:	4629                	li	a2,10
  4006f4:	000ba583          	lw	a1,0(s7)
  4006f8:	855a                	mv	a0,s6
  4006fa:	dd7ff0ef          	jal	4004d0 <printint>
        i += 1;
  4006fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400700:	8ba6                	mv	s7,s1
      state = 0;
  400702:	4981                	li	s3,0
        i += 1;
  400704:	b575                	j	4005b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400706:	008b8493          	addi	s1,s7,8
  40070a:	4681                	li	a3,0
  40070c:	4629                	li	a2,10
  40070e:	000ba583          	lw	a1,0(s7)
  400712:	855a                	mv	a0,s6
  400714:	dbdff0ef          	jal	4004d0 <printint>
        i += 2;
  400718:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  40071a:	8ba6                	mv	s7,s1
      state = 0;
  40071c:	4981                	li	s3,0
        i += 2;
  40071e:	bd49                	j	4005b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400720:	008b8493          	addi	s1,s7,8
  400724:	4681                	li	a3,0
  400726:	4641                	li	a2,16
  400728:	000ba583          	lw	a1,0(s7)
  40072c:	855a                	mv	a0,s6
  40072e:	da3ff0ef          	jal	4004d0 <printint>
  400732:	8ba6                	mv	s7,s1
      state = 0;
  400734:	4981                	li	s3,0
  400736:	bdad                	j	4005b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400738:	008b8493          	addi	s1,s7,8
  40073c:	4681                	li	a3,0
  40073e:	4641                	li	a2,16
  400740:	000ba583          	lw	a1,0(s7)
  400744:	855a                	mv	a0,s6
  400746:	d8bff0ef          	jal	4004d0 <printint>
        i += 1;
  40074a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  40074c:	8ba6                	mv	s7,s1
      state = 0;
  40074e:	4981                	li	s3,0
        i += 1;
  400750:	b585                	j	4005b0 <vprintf+0x4a>
  400752:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  400754:	008b8d13          	addi	s10,s7,8
  400758:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  40075c:	03000593          	li	a1,48
  400760:	855a                	mv	a0,s6
  400762:	d51ff0ef          	jal	4004b2 <putc>
  putc(fd, 'x');
  400766:	07800593          	li	a1,120
  40076a:	855a                	mv	a0,s6
  40076c:	d47ff0ef          	jal	4004b2 <putc>
  400770:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400772:	00000b97          	auipc	s7,0x0
  400776:	2aeb8b93          	addi	s7,s7,686 # 400a20 <digits>
  40077a:	03c9d793          	srli	a5,s3,0x3c
  40077e:	97de                	add	a5,a5,s7
  400780:	0007c583          	lbu	a1,0(a5)
  400784:	855a                	mv	a0,s6
  400786:	d2dff0ef          	jal	4004b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  40078a:	0992                	slli	s3,s3,0x4
  40078c:	34fd                	addiw	s1,s1,-1
  40078e:	f4f5                	bnez	s1,40077a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400790:	8bea                	mv	s7,s10
      state = 0;
  400792:	4981                	li	s3,0
  400794:	6d02                	ld	s10,0(sp)
  400796:	bd29                	j	4005b0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  400798:	008b8993          	addi	s3,s7,8
  40079c:	000bb483          	ld	s1,0(s7)
  4007a0:	cc91                	beqz	s1,4007bc <vprintf+0x256>
        for(; *s; s++)
  4007a2:	0004c583          	lbu	a1,0(s1)
  4007a6:	c195                	beqz	a1,4007ca <vprintf+0x264>
          putc(fd, *s);
  4007a8:	855a                	mv	a0,s6
  4007aa:	d09ff0ef          	jal	4004b2 <putc>
        for(; *s; s++)
  4007ae:	0485                	addi	s1,s1,1
  4007b0:	0004c583          	lbu	a1,0(s1)
  4007b4:	f9f5                	bnez	a1,4007a8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4007b6:	8bce                	mv	s7,s3
      state = 0;
  4007b8:	4981                	li	s3,0
  4007ba:	bbdd                	j	4005b0 <vprintf+0x4a>
          s = "(null)";
  4007bc:	00000497          	auipc	s1,0x0
  4007c0:	25c48493          	addi	s1,s1,604 # 400a18 <malloc+0x148>
        for(; *s; s++)
  4007c4:	02800593          	li	a1,40
  4007c8:	b7c5                	j	4007a8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4007ca:	8bce                	mv	s7,s3
      state = 0;
  4007cc:	4981                	li	s3,0
  4007ce:	b3cd                	j	4005b0 <vprintf+0x4a>
  4007d0:	6906                	ld	s2,64(sp)
  4007d2:	79e2                	ld	s3,56(sp)
  4007d4:	7a42                	ld	s4,48(sp)
  4007d6:	7aa2                	ld	s5,40(sp)
  4007d8:	7b02                	ld	s6,32(sp)
  4007da:	6be2                	ld	s7,24(sp)
  4007dc:	6c42                	ld	s8,16(sp)
  4007de:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4007e0:	60e6                	ld	ra,88(sp)
  4007e2:	6446                	ld	s0,80(sp)
  4007e4:	64a6                	ld	s1,72(sp)
  4007e6:	6125                	addi	sp,sp,96
  4007e8:	8082                	ret

00000000004007ea <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4007ea:	715d                	addi	sp,sp,-80
  4007ec:	ec06                	sd	ra,24(sp)
  4007ee:	e822                	sd	s0,16(sp)
  4007f0:	1000                	addi	s0,sp,32
  4007f2:	e010                	sd	a2,0(s0)
  4007f4:	e414                	sd	a3,8(s0)
  4007f6:	e818                	sd	a4,16(s0)
  4007f8:	ec1c                	sd	a5,24(s0)
  4007fa:	03043023          	sd	a6,32(s0)
  4007fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  400802:	8622                	mv	a2,s0
  400804:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400808:	d5fff0ef          	jal	400566 <vprintf>
  return 0;
}
  40080c:	4501                	li	a0,0
  40080e:	60e2                	ld	ra,24(sp)
  400810:	6442                	ld	s0,16(sp)
  400812:	6161                	addi	sp,sp,80
  400814:	8082                	ret

0000000000400816 <printf>:

int
printf(const char *fmt, ...)
{
  400816:	711d                	addi	sp,sp,-96
  400818:	ec06                	sd	ra,24(sp)
  40081a:	e822                	sd	s0,16(sp)
  40081c:	1000                	addi	s0,sp,32
  40081e:	e40c                	sd	a1,8(s0)
  400820:	e810                	sd	a2,16(s0)
  400822:	ec14                	sd	a3,24(s0)
  400824:	f018                	sd	a4,32(s0)
  400826:	f41c                	sd	a5,40(s0)
  400828:	03043823          	sd	a6,48(s0)
  40082c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400830:	00840613          	addi	a2,s0,8
  400834:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400838:	85aa                	mv	a1,a0
  40083a:	4505                	li	a0,1
  40083c:	d2bff0ef          	jal	400566 <vprintf>
  return 0;
}
  400840:	4501                	li	a0,0
  400842:	60e2                	ld	ra,24(sp)
  400844:	6442                	ld	s0,16(sp)
  400846:	6125                	addi	sp,sp,96
  400848:	8082                	ret

000000000040084a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  40084a:	1141                	addi	sp,sp,-16
  40084c:	e406                	sd	ra,8(sp)
  40084e:	e022                	sd	s0,0(sp)
  400850:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  400852:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400856:	00000797          	auipc	a5,0x0
  40085a:	7aa7b783          	ld	a5,1962(a5) # 401000 <freep>
  40085e:	a02d                	j	400888 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400860:	4618                	lw	a4,8(a2)
  400862:	9f2d                	addw	a4,a4,a1
  400864:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400868:	6398                	ld	a4,0(a5)
  40086a:	6310                	ld	a2,0(a4)
  40086c:	a83d                	j	4008aa <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  40086e:	ff852703          	lw	a4,-8(a0)
  400872:	9f31                	addw	a4,a4,a2
  400874:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  400876:	ff053683          	ld	a3,-16(a0)
  40087a:	a091                	j	4008be <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40087c:	6398                	ld	a4,0(a5)
  40087e:	00e7e463          	bltu	a5,a4,400886 <free+0x3c>
  400882:	00e6ea63          	bltu	a3,a4,400896 <free+0x4c>
{
  400886:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400888:	fed7fae3          	bgeu	a5,a3,40087c <free+0x32>
  40088c:	6398                	ld	a4,0(a5)
  40088e:	00e6e463          	bltu	a3,a4,400896 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400892:	fee7eae3          	bltu	a5,a4,400886 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  400896:	ff852583          	lw	a1,-8(a0)
  40089a:	6390                	ld	a2,0(a5)
  40089c:	02059813          	slli	a6,a1,0x20
  4008a0:	01c85713          	srli	a4,a6,0x1c
  4008a4:	9736                	add	a4,a4,a3
  4008a6:	fae60de3          	beq	a2,a4,400860 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4008aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4008ae:	4790                	lw	a2,8(a5)
  4008b0:	02061593          	slli	a1,a2,0x20
  4008b4:	01c5d713          	srli	a4,a1,0x1c
  4008b8:	973e                	add	a4,a4,a5
  4008ba:	fae68ae3          	beq	a3,a4,40086e <free+0x24>
    p->s.ptr = bp->s.ptr;
  4008be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4008c0:	00000717          	auipc	a4,0x0
  4008c4:	74f73023          	sd	a5,1856(a4) # 401000 <freep>
}
  4008c8:	60a2                	ld	ra,8(sp)
  4008ca:	6402                	ld	s0,0(sp)
  4008cc:	0141                	addi	sp,sp,16
  4008ce:	8082                	ret

00000000004008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4008d0:	7139                	addi	sp,sp,-64
  4008d2:	fc06                	sd	ra,56(sp)
  4008d4:	f822                	sd	s0,48(sp)
  4008d6:	f04a                	sd	s2,32(sp)
  4008d8:	ec4e                	sd	s3,24(sp)
  4008da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4008dc:	02051993          	slli	s3,a0,0x20
  4008e0:	0209d993          	srli	s3,s3,0x20
  4008e4:	09bd                	addi	s3,s3,15
  4008e6:	0049d993          	srli	s3,s3,0x4
  4008ea:	2985                	addiw	s3,s3,1
  4008ec:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4008ee:	00000517          	auipc	a0,0x0
  4008f2:	71253503          	ld	a0,1810(a0) # 401000 <freep>
  4008f6:	c905                	beqz	a0,400926 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4008f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4008fa:	4798                	lw	a4,8(a5)
  4008fc:	09377663          	bgeu	a4,s3,400988 <malloc+0xb8>
  400900:	f426                	sd	s1,40(sp)
  400902:	e852                	sd	s4,16(sp)
  400904:	e456                	sd	s5,8(sp)
  400906:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400908:	8a4e                	mv	s4,s3
  40090a:	6705                	lui	a4,0x1
  40090c:	00e9f363          	bgeu	s3,a4,400912 <malloc+0x42>
  400910:	6a05                	lui	s4,0x1
  400912:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400916:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  40091a:	00000497          	auipc	s1,0x0
  40091e:	6e648493          	addi	s1,s1,1766 # 401000 <freep>
  if(p == (char*)-1)
  400922:	5afd                	li	s5,-1
  400924:	a83d                	j	400962 <malloc+0x92>
  400926:	f426                	sd	s1,40(sp)
  400928:	e852                	sd	s4,16(sp)
  40092a:	e456                	sd	s5,8(sp)
  40092c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  40092e:	00001797          	auipc	a5,0x1
  400932:	8e278793          	addi	a5,a5,-1822 # 401210 <base>
  400936:	00000717          	auipc	a4,0x0
  40093a:	6cf73523          	sd	a5,1738(a4) # 401000 <freep>
  40093e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400940:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  400944:	b7d1                	j	400908 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400946:	6398                	ld	a4,0(a5)
  400948:	e118                	sd	a4,0(a0)
  40094a:	a899                	j	4009a0 <malloc+0xd0>
  hp->s.size = nu;
  40094c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400950:	0541                	addi	a0,a0,16
  400952:	ef9ff0ef          	jal	40084a <free>
  return freep;
  400956:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  400958:	c125                	beqz	a0,4009b8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  40095a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40095c:	4798                	lw	a4,8(a5)
  40095e:	03277163          	bgeu	a4,s2,400980 <malloc+0xb0>
    if(p == freep)
  400962:	6098                	ld	a4,0(s1)
  400964:	853e                	mv	a0,a5
  400966:	fef71ae3          	bne	a4,a5,40095a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  40096a:	8552                	mv	a0,s4
  40096c:	b17ff0ef          	jal	400482 <sbrk>
  if(p == (char*)-1)
  400970:	fd551ee3          	bne	a0,s5,40094c <malloc+0x7c>
        return 0;
  400974:	4501                	li	a0,0
  400976:	74a2                	ld	s1,40(sp)
  400978:	6a42                	ld	s4,16(sp)
  40097a:	6aa2                	ld	s5,8(sp)
  40097c:	6b02                	ld	s6,0(sp)
  40097e:	a03d                	j	4009ac <malloc+0xdc>
  400980:	74a2                	ld	s1,40(sp)
  400982:	6a42                	ld	s4,16(sp)
  400984:	6aa2                	ld	s5,8(sp)
  400986:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400988:	fae90fe3          	beq	s2,a4,400946 <malloc+0x76>
        p->s.size -= nunits;
  40098c:	4137073b          	subw	a4,a4,s3
  400990:	c798                	sw	a4,8(a5)
        p += p->s.size;
  400992:	02071693          	slli	a3,a4,0x20
  400996:	01c6d713          	srli	a4,a3,0x1c
  40099a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  40099c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4009a0:	00000717          	auipc	a4,0x0
  4009a4:	66a73023          	sd	a0,1632(a4) # 401000 <freep>
      return (void*)(p + 1);
  4009a8:	01078513          	addi	a0,a5,16
  }
}
  4009ac:	70e2                	ld	ra,56(sp)
  4009ae:	7442                	ld	s0,48(sp)
  4009b0:	7902                	ld	s2,32(sp)
  4009b2:	69e2                	ld	s3,24(sp)
  4009b4:	6121                	addi	sp,sp,64
  4009b6:	8082                	ret
  4009b8:	74a2                	ld	s1,40(sp)
  4009ba:	6a42                	ld	s4,16(sp)
  4009bc:	6aa2                	ld	s5,8(sp)
  4009be:	6b02                	ld	s6,0(sp)
  4009c0:	b7f5                	j	4009ac <malloc+0xdc>
