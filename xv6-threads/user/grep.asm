
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  400000:	7179                	addi	sp,sp,-48
  400002:	f406                	sd	ra,40(sp)
  400004:	f022                	sd	s0,32(sp)
  400006:	ec26                	sd	s1,24(sp)
  400008:	e84a                	sd	s2,16(sp)
  40000a:	e44e                	sd	s3,8(sp)
  40000c:	e052                	sd	s4,0(sp)
  40000e:	1800                	addi	s0,sp,48
  400010:	892a                	mv	s2,a0
  400012:	89ae                	mv	s3,a1
  400014:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  400016:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  40001a:	85a6                	mv	a1,s1
  40001c:	854e                	mv	a0,s3
  40001e:	02c000ef          	jal	40004a <matchhere>
  400022:	e919                	bnez	a0,400038 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  400024:	0004c783          	lbu	a5,0(s1)
  400028:	cb89                	beqz	a5,40003a <matchstar+0x3a>
  40002a:	0485                	addi	s1,s1,1
  40002c:	2781                	sext.w	a5,a5
  40002e:	ff2786e3          	beq	a5,s2,40001a <matchstar+0x1a>
  400032:	ff4904e3          	beq	s2,s4,40001a <matchstar+0x1a>
  400036:	a011                	j	40003a <matchstar+0x3a>
      return 1;
  400038:	4505                	li	a0,1
  return 0;
}
  40003a:	70a2                	ld	ra,40(sp)
  40003c:	7402                	ld	s0,32(sp)
  40003e:	64e2                	ld	s1,24(sp)
  400040:	6942                	ld	s2,16(sp)
  400042:	69a2                	ld	s3,8(sp)
  400044:	6a02                	ld	s4,0(sp)
  400046:	6145                	addi	sp,sp,48
  400048:	8082                	ret

000000000040004a <matchhere>:
  if(re[0] == '\0')
  40004a:	00054703          	lbu	a4,0(a0)
  40004e:	c73d                	beqz	a4,4000bc <matchhere+0x72>
{
  400050:	1141                	addi	sp,sp,-16
  400052:	e406                	sd	ra,8(sp)
  400054:	e022                	sd	s0,0(sp)
  400056:	0800                	addi	s0,sp,16
  400058:	87aa                	mv	a5,a0
  if(re[1] == '*')
  40005a:	00154683          	lbu	a3,1(a0)
  40005e:	02a00613          	li	a2,42
  400062:	02c68563          	beq	a3,a2,40008c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  400066:	02400613          	li	a2,36
  40006a:	02c70863          	beq	a4,a2,40009a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  40006e:	0005c683          	lbu	a3,0(a1)
  return 0;
  400072:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  400074:	ca81                	beqz	a3,400084 <matchhere+0x3a>
  400076:	02e00613          	li	a2,46
  40007a:	02c70b63          	beq	a4,a2,4000b0 <matchhere+0x66>
  return 0;
  40007e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  400080:	02d70863          	beq	a4,a3,4000b0 <matchhere+0x66>
}
  400084:	60a2                	ld	ra,8(sp)
  400086:	6402                	ld	s0,0(sp)
  400088:	0141                	addi	sp,sp,16
  40008a:	8082                	ret
    return matchstar(re[0], re+2, text);
  40008c:	862e                	mv	a2,a1
  40008e:	00250593          	addi	a1,a0,2
  400092:	853a                	mv	a0,a4
  400094:	f6dff0ef          	jal	400000 <matchstar>
  400098:	b7f5                	j	400084 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  40009a:	c691                	beqz	a3,4000a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  40009c:	0005c683          	lbu	a3,0(a1)
  4000a0:	fef9                	bnez	a3,40007e <matchhere+0x34>
  return 0;
  4000a2:	4501                	li	a0,0
  4000a4:	b7c5                	j	400084 <matchhere+0x3a>
    return *text == '\0';
  4000a6:	0005c503          	lbu	a0,0(a1)
  4000aa:	00153513          	seqz	a0,a0
  4000ae:	bfd9                	j	400084 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  4000b0:	0585                	addi	a1,a1,1
  4000b2:	00178513          	addi	a0,a5,1
  4000b6:	f95ff0ef          	jal	40004a <matchhere>
  4000ba:	b7e9                	j	400084 <matchhere+0x3a>
    return 1;
  4000bc:	4505                	li	a0,1
}
  4000be:	8082                	ret

00000000004000c0 <match>:
{
  4000c0:	1101                	addi	sp,sp,-32
  4000c2:	ec06                	sd	ra,24(sp)
  4000c4:	e822                	sd	s0,16(sp)
  4000c6:	e426                	sd	s1,8(sp)
  4000c8:	e04a                	sd	s2,0(sp)
  4000ca:	1000                	addi	s0,sp,32
  4000cc:	892a                	mv	s2,a0
  4000ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  4000d0:	00054703          	lbu	a4,0(a0)
  4000d4:	05e00793          	li	a5,94
  4000d8:	00f70c63          	beq	a4,a5,4000f0 <match+0x30>
    if(matchhere(re, text))
  4000dc:	85a6                	mv	a1,s1
  4000de:	854a                	mv	a0,s2
  4000e0:	f6bff0ef          	jal	40004a <matchhere>
  4000e4:	e911                	bnez	a0,4000f8 <match+0x38>
  }while(*text++ != '\0');
  4000e6:	0485                	addi	s1,s1,1
  4000e8:	fff4c783          	lbu	a5,-1(s1)
  4000ec:	fbe5                	bnez	a5,4000dc <match+0x1c>
  4000ee:	a031                	j	4000fa <match+0x3a>
    return matchhere(re+1, text);
  4000f0:	0505                	addi	a0,a0,1
  4000f2:	f59ff0ef          	jal	40004a <matchhere>
  4000f6:	a011                	j	4000fa <match+0x3a>
      return 1;
  4000f8:	4505                	li	a0,1
}
  4000fa:	60e2                	ld	ra,24(sp)
  4000fc:	6442                	ld	s0,16(sp)
  4000fe:	64a2                	ld	s1,8(sp)
  400100:	6902                	ld	s2,0(sp)
  400102:	6105                	addi	sp,sp,32
  400104:	8082                	ret

0000000000400106 <grep>:
{
  400106:	711d                	addi	sp,sp,-96
  400108:	ec86                	sd	ra,88(sp)
  40010a:	e8a2                	sd	s0,80(sp)
  40010c:	e4a6                	sd	s1,72(sp)
  40010e:	e0ca                	sd	s2,64(sp)
  400110:	fc4e                	sd	s3,56(sp)
  400112:	f852                	sd	s4,48(sp)
  400114:	f456                	sd	s5,40(sp)
  400116:	f05a                	sd	s6,32(sp)
  400118:	ec5e                	sd	s7,24(sp)
  40011a:	e862                	sd	s8,16(sp)
  40011c:	e466                	sd	s9,8(sp)
  40011e:	e06a                	sd	s10,0(sp)
  400120:	1080                	addi	s0,sp,96
  400122:	8aaa                	mv	s5,a0
  400124:	8cae                	mv	s9,a1
  m = 0;
  400126:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  400128:	3ff00d13          	li	s10,1023
  40012c:	00002b97          	auipc	s7,0x2
  400130:	ee4b8b93          	addi	s7,s7,-284 # 402010 <buf>
    while((q = strchr(p, '\n')) != 0){
  400134:	49a9                	li	s3,10
        write(1, p, q+1 - p);
  400136:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  400138:	a82d                	j	400172 <grep+0x6c>
      p = q+1;
  40013a:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
  40013e:	85ce                	mv	a1,s3
  400140:	854a                	mv	a0,s2
  400142:	1d6000ef          	jal	400318 <strchr>
  400146:	84aa                	mv	s1,a0
  400148:	c11d                	beqz	a0,40016e <grep+0x68>
      *q = 0;
  40014a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
  40014e:	85ca                	mv	a1,s2
  400150:	8556                	mv	a0,s5
  400152:	f6fff0ef          	jal	4000c0 <match>
  400156:	d175                	beqz	a0,40013a <grep+0x34>
        *q = '\n';
  400158:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
  40015c:	00148613          	addi	a2,s1,1
  400160:	4126063b          	subw	a2,a2,s2
  400164:	85ca                	mv	a1,s2
  400166:	8562                	mv	a0,s8
  400168:	3b8000ef          	jal	400520 <write>
  40016c:	b7f9                	j	40013a <grep+0x34>
    if(m > 0){
  40016e:	03604463          	bgtz	s6,400196 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  400172:	416d063b          	subw	a2,s10,s6
  400176:	016b85b3          	add	a1,s7,s6
  40017a:	8566                	mv	a0,s9
  40017c:	39c000ef          	jal	400518 <read>
  400180:	02a05863          	blez	a0,4001b0 <grep+0xaa>
    m += n;
  400184:	00ab0a3b          	addw	s4,s6,a0
  400188:	8b52                	mv	s6,s4
    buf[m] = '\0';
  40018a:	014b87b3          	add	a5,s7,s4
  40018e:	00078023          	sb	zero,0(a5)
    p = buf;
  400192:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
  400194:	b76d                	j	40013e <grep+0x38>
      m -= p - buf;
  400196:	00002517          	auipc	a0,0x2
  40019a:	e7a50513          	addi	a0,a0,-390 # 402010 <buf>
  40019e:	40a907b3          	sub	a5,s2,a0
  4001a2:	40fa063b          	subw	a2,s4,a5
  4001a6:	8b32                	mv	s6,a2
      memmove(buf, p, m);
  4001a8:	85ca                	mv	a1,s2
  4001aa:	2a0000ef          	jal	40044a <memmove>
  4001ae:	b7d1                	j	400172 <grep+0x6c>
}
  4001b0:	60e6                	ld	ra,88(sp)
  4001b2:	6446                	ld	s0,80(sp)
  4001b4:	64a6                	ld	s1,72(sp)
  4001b6:	6906                	ld	s2,64(sp)
  4001b8:	79e2                	ld	s3,56(sp)
  4001ba:	7a42                	ld	s4,48(sp)
  4001bc:	7aa2                	ld	s5,40(sp)
  4001be:	7b02                	ld	s6,32(sp)
  4001c0:	6be2                	ld	s7,24(sp)
  4001c2:	6c42                	ld	s8,16(sp)
  4001c4:	6ca2                	ld	s9,8(sp)
  4001c6:	6d02                	ld	s10,0(sp)
  4001c8:	6125                	addi	sp,sp,96
  4001ca:	8082                	ret

00000000004001cc <main>:
{
  4001cc:	7179                	addi	sp,sp,-48
  4001ce:	f406                	sd	ra,40(sp)
  4001d0:	f022                	sd	s0,32(sp)
  4001d2:	ec26                	sd	s1,24(sp)
  4001d4:	e84a                	sd	s2,16(sp)
  4001d6:	e44e                	sd	s3,8(sp)
  4001d8:	e052                	sd	s4,0(sp)
  4001da:	1800                	addi	s0,sp,48
  if(argc <= 1){
  4001dc:	4785                	li	a5,1
  4001de:	04a7d663          	bge	a5,a0,40022a <main+0x5e>
  pattern = argv[1];
  4001e2:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
  4001e6:	4789                	li	a5,2
  4001e8:	04a7db63          	bge	a5,a0,40023e <main+0x72>
  4001ec:	01058913          	addi	s2,a1,16
  4001f0:	ffd5099b          	addiw	s3,a0,-3
  4001f4:	02099793          	slli	a5,s3,0x20
  4001f8:	01d7d993          	srli	s3,a5,0x1d
  4001fc:	05e1                	addi	a1,a1,24
  4001fe:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
  400200:	4581                	li	a1,0
  400202:	00093503          	ld	a0,0(s2)
  400206:	33a000ef          	jal	400540 <open>
  40020a:	84aa                	mv	s1,a0
  40020c:	04054063          	bltz	a0,40024c <main+0x80>
    grep(pattern, fd);
  400210:	85aa                	mv	a1,a0
  400212:	8552                	mv	a0,s4
  400214:	ef3ff0ef          	jal	400106 <grep>
    close(fd);
  400218:	8526                	mv	a0,s1
  40021a:	30e000ef          	jal	400528 <close>
  for(i = 2; i < argc; i++){
  40021e:	0921                	addi	s2,s2,8
  400220:	ff3910e3          	bne	s2,s3,400200 <main+0x34>
  exit(0);
  400224:	4501                	li	a0,0
  400226:	2da000ef          	jal	400500 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
  40022a:	00001597          	auipc	a1,0x1
  40022e:	8a658593          	addi	a1,a1,-1882 # 400ad0 <malloc+0xfa>
  400232:	4509                	li	a0,2
  400234:	6bc000ef          	jal	4008f0 <fprintf>
    exit(1);
  400238:	4505                	li	a0,1
  40023a:	2c6000ef          	jal	400500 <exit>
    grep(pattern, 0);
  40023e:	4581                	li	a1,0
  400240:	8552                	mv	a0,s4
  400242:	ec5ff0ef          	jal	400106 <grep>
    exit(0);
  400246:	4501                	li	a0,0
  400248:	2b8000ef          	jal	400500 <exit>
      printf("grep: cannot open %s\n", argv[i]);
  40024c:	00093583          	ld	a1,0(s2)
  400250:	00001517          	auipc	a0,0x1
  400254:	8a050513          	addi	a0,a0,-1888 # 400af0 <malloc+0x11a>
  400258:	6c4000ef          	jal	40091c <printf>
      exit(1);
  40025c:	4505                	li	a0,1
  40025e:	2a2000ef          	jal	400500 <exit>

0000000000400262 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  400262:	1141                	addi	sp,sp,-16
  400264:	e406                	sd	ra,8(sp)
  400266:	e022                	sd	s0,0(sp)
  400268:	0800                	addi	s0,sp,16
  extern int main();
  main();
  40026a:	f63ff0ef          	jal	4001cc <main>
  exit(0);
  40026e:	4501                	li	a0,0
  400270:	290000ef          	jal	400500 <exit>

0000000000400274 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400274:	1141                	addi	sp,sp,-16
  400276:	e406                	sd	ra,8(sp)
  400278:	e022                	sd	s0,0(sp)
  40027a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40027c:	87aa                	mv	a5,a0
  40027e:	0585                	addi	a1,a1,1
  400280:	0785                	addi	a5,a5,1
  400282:	fff5c703          	lbu	a4,-1(a1)
  400286:	fee78fa3          	sb	a4,-1(a5)
  40028a:	fb75                	bnez	a4,40027e <strcpy+0xa>
    ;
  return os;
}
  40028c:	60a2                	ld	ra,8(sp)
  40028e:	6402                	ld	s0,0(sp)
  400290:	0141                	addi	sp,sp,16
  400292:	8082                	ret

0000000000400294 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  400294:	1141                	addi	sp,sp,-16
  400296:	e406                	sd	ra,8(sp)
  400298:	e022                	sd	s0,0(sp)
  40029a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  40029c:	00054783          	lbu	a5,0(a0)
  4002a0:	cb91                	beqz	a5,4002b4 <strcmp+0x20>
  4002a2:	0005c703          	lbu	a4,0(a1)
  4002a6:	00f71763          	bne	a4,a5,4002b4 <strcmp+0x20>
    p++, q++;
  4002aa:	0505                	addi	a0,a0,1
  4002ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4002ae:	00054783          	lbu	a5,0(a0)
  4002b2:	fbe5                	bnez	a5,4002a2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4002b4:	0005c503          	lbu	a0,0(a1)
}
  4002b8:	40a7853b          	subw	a0,a5,a0
  4002bc:	60a2                	ld	ra,8(sp)
  4002be:	6402                	ld	s0,0(sp)
  4002c0:	0141                	addi	sp,sp,16
  4002c2:	8082                	ret

00000000004002c4 <strlen>:

uint
strlen(const char *s)
{
  4002c4:	1141                	addi	sp,sp,-16
  4002c6:	e406                	sd	ra,8(sp)
  4002c8:	e022                	sd	s0,0(sp)
  4002ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4002cc:	00054783          	lbu	a5,0(a0)
  4002d0:	cf99                	beqz	a5,4002ee <strlen+0x2a>
  4002d2:	0505                	addi	a0,a0,1
  4002d4:	87aa                	mv	a5,a0
  4002d6:	86be                	mv	a3,a5
  4002d8:	0785                	addi	a5,a5,1
  4002da:	fff7c703          	lbu	a4,-1(a5)
  4002de:	ff65                	bnez	a4,4002d6 <strlen+0x12>
  4002e0:	40a6853b          	subw	a0,a3,a0
  4002e4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  4002e6:	60a2                	ld	ra,8(sp)
  4002e8:	6402                	ld	s0,0(sp)
  4002ea:	0141                	addi	sp,sp,16
  4002ec:	8082                	ret
  for(n = 0; s[n]; n++)
  4002ee:	4501                	li	a0,0
  4002f0:	bfdd                	j	4002e6 <strlen+0x22>

00000000004002f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  4002f2:	1141                	addi	sp,sp,-16
  4002f4:	e406                	sd	ra,8(sp)
  4002f6:	e022                	sd	s0,0(sp)
  4002f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  4002fa:	ca19                	beqz	a2,400310 <memset+0x1e>
  4002fc:	87aa                	mv	a5,a0
  4002fe:	1602                	slli	a2,a2,0x20
  400300:	9201                	srli	a2,a2,0x20
  400302:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400306:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  40030a:	0785                	addi	a5,a5,1
  40030c:	fee79de3          	bne	a5,a4,400306 <memset+0x14>
  }
  return dst;
}
  400310:	60a2                	ld	ra,8(sp)
  400312:	6402                	ld	s0,0(sp)
  400314:	0141                	addi	sp,sp,16
  400316:	8082                	ret

0000000000400318 <strchr>:

char*
strchr(const char *s, char c)
{
  400318:	1141                	addi	sp,sp,-16
  40031a:	e406                	sd	ra,8(sp)
  40031c:	e022                	sd	s0,0(sp)
  40031e:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400320:	00054783          	lbu	a5,0(a0)
  400324:	cf81                	beqz	a5,40033c <strchr+0x24>
    if(*s == c)
  400326:	00f58763          	beq	a1,a5,400334 <strchr+0x1c>
  for(; *s; s++)
  40032a:	0505                	addi	a0,a0,1
  40032c:	00054783          	lbu	a5,0(a0)
  400330:	fbfd                	bnez	a5,400326 <strchr+0xe>
      return (char*)s;
  return 0;
  400332:	4501                	li	a0,0
}
  400334:	60a2                	ld	ra,8(sp)
  400336:	6402                	ld	s0,0(sp)
  400338:	0141                	addi	sp,sp,16
  40033a:	8082                	ret
  return 0;
  40033c:	4501                	li	a0,0
  40033e:	bfdd                	j	400334 <strchr+0x1c>

0000000000400340 <gets>:

char*
gets(char *buf, int max)
{
  400340:	7159                	addi	sp,sp,-112
  400342:	f486                	sd	ra,104(sp)
  400344:	f0a2                	sd	s0,96(sp)
  400346:	eca6                	sd	s1,88(sp)
  400348:	e8ca                	sd	s2,80(sp)
  40034a:	e4ce                	sd	s3,72(sp)
  40034c:	e0d2                	sd	s4,64(sp)
  40034e:	fc56                	sd	s5,56(sp)
  400350:	f85a                	sd	s6,48(sp)
  400352:	f45e                	sd	s7,40(sp)
  400354:	f062                	sd	s8,32(sp)
  400356:	ec66                	sd	s9,24(sp)
  400358:	e86a                	sd	s10,16(sp)
  40035a:	1880                	addi	s0,sp,112
  40035c:	8caa                	mv	s9,a0
  40035e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400360:	892a                	mv	s2,a0
  400362:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400364:	f9f40b13          	addi	s6,s0,-97
  400368:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  40036a:	4ba9                	li	s7,10
  40036c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  40036e:	8d26                	mv	s10,s1
  400370:	0014899b          	addiw	s3,s1,1
  400374:	84ce                	mv	s1,s3
  400376:	0349d563          	bge	s3,s4,4003a0 <gets+0x60>
    cc = read(0, &c, 1);
  40037a:	8656                	mv	a2,s5
  40037c:	85da                	mv	a1,s6
  40037e:	4501                	li	a0,0
  400380:	198000ef          	jal	400518 <read>
    if(cc < 1)
  400384:	00a05e63          	blez	a0,4003a0 <gets+0x60>
    buf[i++] = c;
  400388:	f9f44783          	lbu	a5,-97(s0)
  40038c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400390:	01778763          	beq	a5,s7,40039e <gets+0x5e>
  400394:	0905                	addi	s2,s2,1
  400396:	fd879ce3          	bne	a5,s8,40036e <gets+0x2e>
    buf[i++] = c;
  40039a:	8d4e                	mv	s10,s3
  40039c:	a011                	j	4003a0 <gets+0x60>
  40039e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  4003a0:	9d66                	add	s10,s10,s9
  4003a2:	000d0023          	sb	zero,0(s10)
  return buf;
}
  4003a6:	8566                	mv	a0,s9
  4003a8:	70a6                	ld	ra,104(sp)
  4003aa:	7406                	ld	s0,96(sp)
  4003ac:	64e6                	ld	s1,88(sp)
  4003ae:	6946                	ld	s2,80(sp)
  4003b0:	69a6                	ld	s3,72(sp)
  4003b2:	6a06                	ld	s4,64(sp)
  4003b4:	7ae2                	ld	s5,56(sp)
  4003b6:	7b42                	ld	s6,48(sp)
  4003b8:	7ba2                	ld	s7,40(sp)
  4003ba:	7c02                	ld	s8,32(sp)
  4003bc:	6ce2                	ld	s9,24(sp)
  4003be:	6d42                	ld	s10,16(sp)
  4003c0:	6165                	addi	sp,sp,112
  4003c2:	8082                	ret

00000000004003c4 <stat>:

int
stat(const char *n, struct stat *st)
{
  4003c4:	1101                	addi	sp,sp,-32
  4003c6:	ec06                	sd	ra,24(sp)
  4003c8:	e822                	sd	s0,16(sp)
  4003ca:	e04a                	sd	s2,0(sp)
  4003cc:	1000                	addi	s0,sp,32
  4003ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4003d0:	4581                	li	a1,0
  4003d2:	16e000ef          	jal	400540 <open>
  if(fd < 0)
  4003d6:	02054263          	bltz	a0,4003fa <stat+0x36>
  4003da:	e426                	sd	s1,8(sp)
  4003dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  4003de:	85ca                	mv	a1,s2
  4003e0:	178000ef          	jal	400558 <fstat>
  4003e4:	892a                	mv	s2,a0
  close(fd);
  4003e6:	8526                	mv	a0,s1
  4003e8:	140000ef          	jal	400528 <close>
  return r;
  4003ec:	64a2                	ld	s1,8(sp)
}
  4003ee:	854a                	mv	a0,s2
  4003f0:	60e2                	ld	ra,24(sp)
  4003f2:	6442                	ld	s0,16(sp)
  4003f4:	6902                	ld	s2,0(sp)
  4003f6:	6105                	addi	sp,sp,32
  4003f8:	8082                	ret
    return -1;
  4003fa:	597d                	li	s2,-1
  4003fc:	bfcd                	j	4003ee <stat+0x2a>

00000000004003fe <atoi>:

int
atoi(const char *s)
{
  4003fe:	1141                	addi	sp,sp,-16
  400400:	e406                	sd	ra,8(sp)
  400402:	e022                	sd	s0,0(sp)
  400404:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400406:	00054683          	lbu	a3,0(a0)
  40040a:	fd06879b          	addiw	a5,a3,-48
  40040e:	0ff7f793          	zext.b	a5,a5
  400412:	4625                	li	a2,9
  400414:	02f66963          	bltu	a2,a5,400446 <atoi+0x48>
  400418:	872a                	mv	a4,a0
  n = 0;
  40041a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  40041c:	0705                	addi	a4,a4,1
  40041e:	0025179b          	slliw	a5,a0,0x2
  400422:	9fa9                	addw	a5,a5,a0
  400424:	0017979b          	slliw	a5,a5,0x1
  400428:	9fb5                	addw	a5,a5,a3
  40042a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  40042e:	00074683          	lbu	a3,0(a4)
  400432:	fd06879b          	addiw	a5,a3,-48
  400436:	0ff7f793          	zext.b	a5,a5
  40043a:	fef671e3          	bgeu	a2,a5,40041c <atoi+0x1e>
  return n;
}
  40043e:	60a2                	ld	ra,8(sp)
  400440:	6402                	ld	s0,0(sp)
  400442:	0141                	addi	sp,sp,16
  400444:	8082                	ret
  n = 0;
  400446:	4501                	li	a0,0
  400448:	bfdd                	j	40043e <atoi+0x40>

000000000040044a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  40044a:	1141                	addi	sp,sp,-16
  40044c:	e406                	sd	ra,8(sp)
  40044e:	e022                	sd	s0,0(sp)
  400450:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400452:	02b57563          	bgeu	a0,a1,40047c <memmove+0x32>
    while(n-- > 0)
  400456:	00c05f63          	blez	a2,400474 <memmove+0x2a>
  40045a:	1602                	slli	a2,a2,0x20
  40045c:	9201                	srli	a2,a2,0x20
  40045e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400462:	872a                	mv	a4,a0
      *dst++ = *src++;
  400464:	0585                	addi	a1,a1,1
  400466:	0705                	addi	a4,a4,1
  400468:	fff5c683          	lbu	a3,-1(a1)
  40046c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400470:	fee79ae3          	bne	a5,a4,400464 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400474:	60a2                	ld	ra,8(sp)
  400476:	6402                	ld	s0,0(sp)
  400478:	0141                	addi	sp,sp,16
  40047a:	8082                	ret
    dst += n;
  40047c:	00c50733          	add	a4,a0,a2
    src += n;
  400480:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400482:	fec059e3          	blez	a2,400474 <memmove+0x2a>
  400486:	fff6079b          	addiw	a5,a2,-1
  40048a:	1782                	slli	a5,a5,0x20
  40048c:	9381                	srli	a5,a5,0x20
  40048e:	fff7c793          	not	a5,a5
  400492:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400494:	15fd                	addi	a1,a1,-1
  400496:	177d                	addi	a4,a4,-1
  400498:	0005c683          	lbu	a3,0(a1)
  40049c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  4004a0:	fef71ae3          	bne	a4,a5,400494 <memmove+0x4a>
  4004a4:	bfc1                	j	400474 <memmove+0x2a>

00000000004004a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  4004a6:	1141                	addi	sp,sp,-16
  4004a8:	e406                	sd	ra,8(sp)
  4004aa:	e022                	sd	s0,0(sp)
  4004ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4004ae:	ca0d                	beqz	a2,4004e0 <memcmp+0x3a>
  4004b0:	fff6069b          	addiw	a3,a2,-1
  4004b4:	1682                	slli	a3,a3,0x20
  4004b6:	9281                	srli	a3,a3,0x20
  4004b8:	0685                	addi	a3,a3,1
  4004ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4004bc:	00054783          	lbu	a5,0(a0)
  4004c0:	0005c703          	lbu	a4,0(a1)
  4004c4:	00e79863          	bne	a5,a4,4004d4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4004c8:	0505                	addi	a0,a0,1
    p2++;
  4004ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4004cc:	fed518e3          	bne	a0,a3,4004bc <memcmp+0x16>
  }
  return 0;
  4004d0:	4501                	li	a0,0
  4004d2:	a019                	j	4004d8 <memcmp+0x32>
      return *p1 - *p2;
  4004d4:	40e7853b          	subw	a0,a5,a4
}
  4004d8:	60a2                	ld	ra,8(sp)
  4004da:	6402                	ld	s0,0(sp)
  4004dc:	0141                	addi	sp,sp,16
  4004de:	8082                	ret
  return 0;
  4004e0:	4501                	li	a0,0
  4004e2:	bfdd                	j	4004d8 <memcmp+0x32>

00000000004004e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  4004e4:	1141                	addi	sp,sp,-16
  4004e6:	e406                	sd	ra,8(sp)
  4004e8:	e022                	sd	s0,0(sp)
  4004ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  4004ec:	f5fff0ef          	jal	40044a <memmove>
}
  4004f0:	60a2                	ld	ra,8(sp)
  4004f2:	6402                	ld	s0,0(sp)
  4004f4:	0141                	addi	sp,sp,16
  4004f6:	8082                	ret

00000000004004f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  4004f8:	4885                	li	a7,1
 ecall
  4004fa:	00000073          	ecall
 ret
  4004fe:	8082                	ret

0000000000400500 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400500:	4889                	li	a7,2
 ecall
  400502:	00000073          	ecall
 ret
  400506:	8082                	ret

0000000000400508 <wait>:
.global wait
wait:
 li a7, SYS_wait
  400508:	488d                	li	a7,3
 ecall
  40050a:	00000073          	ecall
 ret
  40050e:	8082                	ret

0000000000400510 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400510:	4891                	li	a7,4
 ecall
  400512:	00000073          	ecall
 ret
  400516:	8082                	ret

0000000000400518 <read>:
.global read
read:
 li a7, SYS_read
  400518:	4895                	li	a7,5
 ecall
  40051a:	00000073          	ecall
 ret
  40051e:	8082                	ret

0000000000400520 <write>:
.global write
write:
 li a7, SYS_write
  400520:	48c1                	li	a7,16
 ecall
  400522:	00000073          	ecall
 ret
  400526:	8082                	ret

0000000000400528 <close>:
.global close
close:
 li a7, SYS_close
  400528:	48d5                	li	a7,21
 ecall
  40052a:	00000073          	ecall
 ret
  40052e:	8082                	ret

0000000000400530 <kill>:
.global kill
kill:
 li a7, SYS_kill
  400530:	4899                	li	a7,6
 ecall
  400532:	00000073          	ecall
 ret
  400536:	8082                	ret

0000000000400538 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400538:	489d                	li	a7,7
 ecall
  40053a:	00000073          	ecall
 ret
  40053e:	8082                	ret

0000000000400540 <open>:
.global open
open:
 li a7, SYS_open
  400540:	48bd                	li	a7,15
 ecall
  400542:	00000073          	ecall
 ret
  400546:	8082                	ret

0000000000400548 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400548:	48c5                	li	a7,17
 ecall
  40054a:	00000073          	ecall
 ret
  40054e:	8082                	ret

0000000000400550 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400550:	48c9                	li	a7,18
 ecall
  400552:	00000073          	ecall
 ret
  400556:	8082                	ret

0000000000400558 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  400558:	48a1                	li	a7,8
 ecall
  40055a:	00000073          	ecall
 ret
  40055e:	8082                	ret

0000000000400560 <link>:
.global link
link:
 li a7, SYS_link
  400560:	48cd                	li	a7,19
 ecall
  400562:	00000073          	ecall
 ret
  400566:	8082                	ret

0000000000400568 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400568:	48d1                	li	a7,20
 ecall
  40056a:	00000073          	ecall
 ret
  40056e:	8082                	ret

0000000000400570 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400570:	48a5                	li	a7,9
 ecall
  400572:	00000073          	ecall
 ret
  400576:	8082                	ret

0000000000400578 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400578:	48a9                	li	a7,10
 ecall
  40057a:	00000073          	ecall
 ret
  40057e:	8082                	ret

0000000000400580 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400580:	48ad                	li	a7,11
 ecall
  400582:	00000073          	ecall
 ret
  400586:	8082                	ret

0000000000400588 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  400588:	48b1                	li	a7,12
 ecall
  40058a:	00000073          	ecall
 ret
  40058e:	8082                	ret

0000000000400590 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400590:	48b5                	li	a7,13
 ecall
  400592:	00000073          	ecall
 ret
  400596:	8082                	ret

0000000000400598 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  400598:	48b9                	li	a7,14
 ecall
  40059a:	00000073          	ecall
 ret
  40059e:	8082                	ret

00000000004005a0 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  4005a0:	48d9                	li	a7,22
 ecall
  4005a2:	00000073          	ecall
 ret
  4005a6:	8082                	ret

00000000004005a8 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  4005a8:	48dd                	li	a7,23
 ecall
  4005aa:	00000073          	ecall
 ret
  4005ae:	8082                	ret

00000000004005b0 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4005b0:	48e1                	li	a7,24
 ecall
  4005b2:	00000073          	ecall
 ret
  4005b6:	8082                	ret

00000000004005b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4005b8:	1101                	addi	sp,sp,-32
  4005ba:	ec06                	sd	ra,24(sp)
  4005bc:	e822                	sd	s0,16(sp)
  4005be:	1000                	addi	s0,sp,32
  4005c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4005c4:	4605                	li	a2,1
  4005c6:	fef40593          	addi	a1,s0,-17
  4005ca:	f57ff0ef          	jal	400520 <write>
}
  4005ce:	60e2                	ld	ra,24(sp)
  4005d0:	6442                	ld	s0,16(sp)
  4005d2:	6105                	addi	sp,sp,32
  4005d4:	8082                	ret

00000000004005d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4005d6:	7139                	addi	sp,sp,-64
  4005d8:	fc06                	sd	ra,56(sp)
  4005da:	f822                	sd	s0,48(sp)
  4005dc:	f426                	sd	s1,40(sp)
  4005de:	f04a                	sd	s2,32(sp)
  4005e0:	ec4e                	sd	s3,24(sp)
  4005e2:	0080                	addi	s0,sp,64
  4005e4:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  4005e6:	c299                	beqz	a3,4005ec <printint+0x16>
  4005e8:	0605ce63          	bltz	a1,400664 <printint+0x8e>
  neg = 0;
  4005ec:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  4005ee:	fc040313          	addi	t1,s0,-64
  neg = 0;
  4005f2:	869a                	mv	a3,t1
  i = 0;
  4005f4:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  4005f6:	00000817          	auipc	a6,0x0
  4005fa:	51a80813          	addi	a6,a6,1306 # 400b10 <digits>
  4005fe:	88be                	mv	a7,a5
  400600:	0017851b          	addiw	a0,a5,1
  400604:	87aa                	mv	a5,a0
  400606:	02c5f73b          	remuw	a4,a1,a2
  40060a:	1702                	slli	a4,a4,0x20
  40060c:	9301                	srli	a4,a4,0x20
  40060e:	9742                	add	a4,a4,a6
  400610:	00074703          	lbu	a4,0(a4)
  400614:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400618:	872e                	mv	a4,a1
  40061a:	02c5d5bb          	divuw	a1,a1,a2
  40061e:	0685                	addi	a3,a3,1
  400620:	fcc77fe3          	bgeu	a4,a2,4005fe <printint+0x28>
  if(neg)
  400624:	000e0c63          	beqz	t3,40063c <printint+0x66>
    buf[i++] = '-';
  400628:	fd050793          	addi	a5,a0,-48
  40062c:	00878533          	add	a0,a5,s0
  400630:	02d00793          	li	a5,45
  400634:	fef50823          	sb	a5,-16(a0)
  400638:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  40063c:	fff7899b          	addiw	s3,a5,-1
  400640:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400644:	fff4c583          	lbu	a1,-1(s1)
  400648:	854a                	mv	a0,s2
  40064a:	f6fff0ef          	jal	4005b8 <putc>
  while(--i >= 0)
  40064e:	39fd                	addiw	s3,s3,-1
  400650:	14fd                	addi	s1,s1,-1
  400652:	fe09d9e3          	bgez	s3,400644 <printint+0x6e>
}
  400656:	70e2                	ld	ra,56(sp)
  400658:	7442                	ld	s0,48(sp)
  40065a:	74a2                	ld	s1,40(sp)
  40065c:	7902                	ld	s2,32(sp)
  40065e:	69e2                	ld	s3,24(sp)
  400660:	6121                	addi	sp,sp,64
  400662:	8082                	ret
    x = -xx;
  400664:	40b005bb          	negw	a1,a1
    neg = 1;
  400668:	4e05                	li	t3,1
    x = -xx;
  40066a:	b751                	j	4005ee <printint+0x18>

000000000040066c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  40066c:	711d                	addi	sp,sp,-96
  40066e:	ec86                	sd	ra,88(sp)
  400670:	e8a2                	sd	s0,80(sp)
  400672:	e4a6                	sd	s1,72(sp)
  400674:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400676:	0005c483          	lbu	s1,0(a1)
  40067a:	26048663          	beqz	s1,4008e6 <vprintf+0x27a>
  40067e:	e0ca                	sd	s2,64(sp)
  400680:	fc4e                	sd	s3,56(sp)
  400682:	f852                	sd	s4,48(sp)
  400684:	f456                	sd	s5,40(sp)
  400686:	f05a                	sd	s6,32(sp)
  400688:	ec5e                	sd	s7,24(sp)
  40068a:	e862                	sd	s8,16(sp)
  40068c:	e466                	sd	s9,8(sp)
  40068e:	8b2a                	mv	s6,a0
  400690:	8a2e                	mv	s4,a1
  400692:	8bb2                	mv	s7,a2
  state = 0;
  400694:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400696:	4901                	li	s2,0
  400698:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  40069a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  40069e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  4006a2:	06c00c93          	li	s9,108
  4006a6:	a00d                	j	4006c8 <vprintf+0x5c>
        putc(fd, c0);
  4006a8:	85a6                	mv	a1,s1
  4006aa:	855a                	mv	a0,s6
  4006ac:	f0dff0ef          	jal	4005b8 <putc>
  4006b0:	a019                	j	4006b6 <vprintf+0x4a>
    } else if(state == '%'){
  4006b2:	03598363          	beq	s3,s5,4006d8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4006b6:	0019079b          	addiw	a5,s2,1
  4006ba:	893e                	mv	s2,a5
  4006bc:	873e                	mv	a4,a5
  4006be:	97d2                	add	a5,a5,s4
  4006c0:	0007c483          	lbu	s1,0(a5)
  4006c4:	20048963          	beqz	s1,4008d6 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4006c8:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4006cc:	fe0993e3          	bnez	s3,4006b2 <vprintf+0x46>
      if(c0 == '%'){
  4006d0:	fd579ce3          	bne	a5,s5,4006a8 <vprintf+0x3c>
        state = '%';
  4006d4:	89be                	mv	s3,a5
  4006d6:	b7c5                	j	4006b6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4006d8:	00ea06b3          	add	a3,s4,a4
  4006dc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  4006e0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  4006e2:	c681                	beqz	a3,4006ea <vprintf+0x7e>
  4006e4:	9752                	add	a4,a4,s4
  4006e6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  4006ea:	03878e63          	beq	a5,s8,400726 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  4006ee:	05978863          	beq	a5,s9,40073e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  4006f2:	07500713          	li	a4,117
  4006f6:	0ee78263          	beq	a5,a4,4007da <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  4006fa:	07800713          	li	a4,120
  4006fe:	12e78463          	beq	a5,a4,400826 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400702:	07000713          	li	a4,112
  400706:	14e78963          	beq	a5,a4,400858 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  40070a:	07300713          	li	a4,115
  40070e:	18e78863          	beq	a5,a4,40089e <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400712:	02500713          	li	a4,37
  400716:	04e79463          	bne	a5,a4,40075e <vprintf+0xf2>
        putc(fd, '%');
  40071a:	85ba                	mv	a1,a4
  40071c:	855a                	mv	a0,s6
  40071e:	e9bff0ef          	jal	4005b8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400722:	4981                	li	s3,0
  400724:	bf49                	j	4006b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400726:	008b8493          	addi	s1,s7,8
  40072a:	4685                	li	a3,1
  40072c:	4629                	li	a2,10
  40072e:	000ba583          	lw	a1,0(s7)
  400732:	855a                	mv	a0,s6
  400734:	ea3ff0ef          	jal	4005d6 <printint>
  400738:	8ba6                	mv	s7,s1
      state = 0;
  40073a:	4981                	li	s3,0
  40073c:	bfad                	j	4006b6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  40073e:	06400793          	li	a5,100
  400742:	02f68963          	beq	a3,a5,400774 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400746:	06c00793          	li	a5,108
  40074a:	04f68263          	beq	a3,a5,40078e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  40074e:	07500793          	li	a5,117
  400752:	0af68063          	beq	a3,a5,4007f2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400756:	07800793          	li	a5,120
  40075a:	0ef68263          	beq	a3,a5,40083e <vprintf+0x1d2>
        putc(fd, '%');
  40075e:	02500593          	li	a1,37
  400762:	855a                	mv	a0,s6
  400764:	e55ff0ef          	jal	4005b8 <putc>
        putc(fd, c0);
  400768:	85a6                	mv	a1,s1
  40076a:	855a                	mv	a0,s6
  40076c:	e4dff0ef          	jal	4005b8 <putc>
      state = 0;
  400770:	4981                	li	s3,0
  400772:	b791                	j	4006b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400774:	008b8493          	addi	s1,s7,8
  400778:	4685                	li	a3,1
  40077a:	4629                	li	a2,10
  40077c:	000ba583          	lw	a1,0(s7)
  400780:	855a                	mv	a0,s6
  400782:	e55ff0ef          	jal	4005d6 <printint>
        i += 1;
  400786:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  400788:	8ba6                	mv	s7,s1
      state = 0;
  40078a:	4981                	li	s3,0
        i += 1;
  40078c:	b72d                	j	4006b6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  40078e:	06400793          	li	a5,100
  400792:	02f60763          	beq	a2,a5,4007c0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400796:	07500793          	li	a5,117
  40079a:	06f60963          	beq	a2,a5,40080c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  40079e:	07800793          	li	a5,120
  4007a2:	faf61ee3          	bne	a2,a5,40075e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4007a6:	008b8493          	addi	s1,s7,8
  4007aa:	4681                	li	a3,0
  4007ac:	4641                	li	a2,16
  4007ae:	000ba583          	lw	a1,0(s7)
  4007b2:	855a                	mv	a0,s6
  4007b4:	e23ff0ef          	jal	4005d6 <printint>
        i += 2;
  4007b8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4007ba:	8ba6                	mv	s7,s1
      state = 0;
  4007bc:	4981                	li	s3,0
        i += 2;
  4007be:	bde5                	j	4006b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4007c0:	008b8493          	addi	s1,s7,8
  4007c4:	4685                	li	a3,1
  4007c6:	4629                	li	a2,10
  4007c8:	000ba583          	lw	a1,0(s7)
  4007cc:	855a                	mv	a0,s6
  4007ce:	e09ff0ef          	jal	4005d6 <printint>
        i += 2;
  4007d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4007d4:	8ba6                	mv	s7,s1
      state = 0;
  4007d6:	4981                	li	s3,0
        i += 2;
  4007d8:	bdf9                	j	4006b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  4007da:	008b8493          	addi	s1,s7,8
  4007de:	4681                	li	a3,0
  4007e0:	4629                	li	a2,10
  4007e2:	000ba583          	lw	a1,0(s7)
  4007e6:	855a                	mv	a0,s6
  4007e8:	defff0ef          	jal	4005d6 <printint>
  4007ec:	8ba6                	mv	s7,s1
      state = 0;
  4007ee:	4981                	li	s3,0
  4007f0:	b5d9                	j	4006b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  4007f2:	008b8493          	addi	s1,s7,8
  4007f6:	4681                	li	a3,0
  4007f8:	4629                	li	a2,10
  4007fa:	000ba583          	lw	a1,0(s7)
  4007fe:	855a                	mv	a0,s6
  400800:	dd7ff0ef          	jal	4005d6 <printint>
        i += 1;
  400804:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400806:	8ba6                	mv	s7,s1
      state = 0;
  400808:	4981                	li	s3,0
        i += 1;
  40080a:	b575                	j	4006b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  40080c:	008b8493          	addi	s1,s7,8
  400810:	4681                	li	a3,0
  400812:	4629                	li	a2,10
  400814:	000ba583          	lw	a1,0(s7)
  400818:	855a                	mv	a0,s6
  40081a:	dbdff0ef          	jal	4005d6 <printint>
        i += 2;
  40081e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400820:	8ba6                	mv	s7,s1
      state = 0;
  400822:	4981                	li	s3,0
        i += 2;
  400824:	bd49                	j	4006b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400826:	008b8493          	addi	s1,s7,8
  40082a:	4681                	li	a3,0
  40082c:	4641                	li	a2,16
  40082e:	000ba583          	lw	a1,0(s7)
  400832:	855a                	mv	a0,s6
  400834:	da3ff0ef          	jal	4005d6 <printint>
  400838:	8ba6                	mv	s7,s1
      state = 0;
  40083a:	4981                	li	s3,0
  40083c:	bdad                	j	4006b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  40083e:	008b8493          	addi	s1,s7,8
  400842:	4681                	li	a3,0
  400844:	4641                	li	a2,16
  400846:	000ba583          	lw	a1,0(s7)
  40084a:	855a                	mv	a0,s6
  40084c:	d8bff0ef          	jal	4005d6 <printint>
        i += 1;
  400850:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400852:	8ba6                	mv	s7,s1
      state = 0;
  400854:	4981                	li	s3,0
        i += 1;
  400856:	b585                	j	4006b6 <vprintf+0x4a>
  400858:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  40085a:	008b8d13          	addi	s10,s7,8
  40085e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400862:	03000593          	li	a1,48
  400866:	855a                	mv	a0,s6
  400868:	d51ff0ef          	jal	4005b8 <putc>
  putc(fd, 'x');
  40086c:	07800593          	li	a1,120
  400870:	855a                	mv	a0,s6
  400872:	d47ff0ef          	jal	4005b8 <putc>
  400876:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400878:	00000b97          	auipc	s7,0x0
  40087c:	298b8b93          	addi	s7,s7,664 # 400b10 <digits>
  400880:	03c9d793          	srli	a5,s3,0x3c
  400884:	97de                	add	a5,a5,s7
  400886:	0007c583          	lbu	a1,0(a5)
  40088a:	855a                	mv	a0,s6
  40088c:	d2dff0ef          	jal	4005b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400890:	0992                	slli	s3,s3,0x4
  400892:	34fd                	addiw	s1,s1,-1
  400894:	f4f5                	bnez	s1,400880 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400896:	8bea                	mv	s7,s10
      state = 0;
  400898:	4981                	li	s3,0
  40089a:	6d02                	ld	s10,0(sp)
  40089c:	bd29                	j	4006b6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  40089e:	008b8993          	addi	s3,s7,8
  4008a2:	000bb483          	ld	s1,0(s7)
  4008a6:	cc91                	beqz	s1,4008c2 <vprintf+0x256>
        for(; *s; s++)
  4008a8:	0004c583          	lbu	a1,0(s1)
  4008ac:	c195                	beqz	a1,4008d0 <vprintf+0x264>
          putc(fd, *s);
  4008ae:	855a                	mv	a0,s6
  4008b0:	d09ff0ef          	jal	4005b8 <putc>
        for(; *s; s++)
  4008b4:	0485                	addi	s1,s1,1
  4008b6:	0004c583          	lbu	a1,0(s1)
  4008ba:	f9f5                	bnez	a1,4008ae <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4008bc:	8bce                	mv	s7,s3
      state = 0;
  4008be:	4981                	li	s3,0
  4008c0:	bbdd                	j	4006b6 <vprintf+0x4a>
          s = "(null)";
  4008c2:	00000497          	auipc	s1,0x0
  4008c6:	24648493          	addi	s1,s1,582 # 400b08 <malloc+0x132>
        for(; *s; s++)
  4008ca:	02800593          	li	a1,40
  4008ce:	b7c5                	j	4008ae <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4008d0:	8bce                	mv	s7,s3
      state = 0;
  4008d2:	4981                	li	s3,0
  4008d4:	b3cd                	j	4006b6 <vprintf+0x4a>
  4008d6:	6906                	ld	s2,64(sp)
  4008d8:	79e2                	ld	s3,56(sp)
  4008da:	7a42                	ld	s4,48(sp)
  4008dc:	7aa2                	ld	s5,40(sp)
  4008de:	7b02                	ld	s6,32(sp)
  4008e0:	6be2                	ld	s7,24(sp)
  4008e2:	6c42                	ld	s8,16(sp)
  4008e4:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4008e6:	60e6                	ld	ra,88(sp)
  4008e8:	6446                	ld	s0,80(sp)
  4008ea:	64a6                	ld	s1,72(sp)
  4008ec:	6125                	addi	sp,sp,96
  4008ee:	8082                	ret

00000000004008f0 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4008f0:	715d                	addi	sp,sp,-80
  4008f2:	ec06                	sd	ra,24(sp)
  4008f4:	e822                	sd	s0,16(sp)
  4008f6:	1000                	addi	s0,sp,32
  4008f8:	e010                	sd	a2,0(s0)
  4008fa:	e414                	sd	a3,8(s0)
  4008fc:	e818                	sd	a4,16(s0)
  4008fe:	ec1c                	sd	a5,24(s0)
  400900:	03043023          	sd	a6,32(s0)
  400904:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  400908:	8622                	mv	a2,s0
  40090a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  40090e:	d5fff0ef          	jal	40066c <vprintf>
  return 0;
}
  400912:	4501                	li	a0,0
  400914:	60e2                	ld	ra,24(sp)
  400916:	6442                	ld	s0,16(sp)
  400918:	6161                	addi	sp,sp,80
  40091a:	8082                	ret

000000000040091c <printf>:

int
printf(const char *fmt, ...)
{
  40091c:	711d                	addi	sp,sp,-96
  40091e:	ec06                	sd	ra,24(sp)
  400920:	e822                	sd	s0,16(sp)
  400922:	1000                	addi	s0,sp,32
  400924:	e40c                	sd	a1,8(s0)
  400926:	e810                	sd	a2,16(s0)
  400928:	ec14                	sd	a3,24(s0)
  40092a:	f018                	sd	a4,32(s0)
  40092c:	f41c                	sd	a5,40(s0)
  40092e:	03043823          	sd	a6,48(s0)
  400932:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  400936:	00840613          	addi	a2,s0,8
  40093a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  40093e:	85aa                	mv	a1,a0
  400940:	4505                	li	a0,1
  400942:	d2bff0ef          	jal	40066c <vprintf>
  return 0;
}
  400946:	4501                	li	a0,0
  400948:	60e2                	ld	ra,24(sp)
  40094a:	6442                	ld	s0,16(sp)
  40094c:	6125                	addi	sp,sp,96
  40094e:	8082                	ret

0000000000400950 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  400950:	1141                	addi	sp,sp,-16
  400952:	e406                	sd	ra,8(sp)
  400954:	e022                	sd	s0,0(sp)
  400956:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  400958:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40095c:	00001797          	auipc	a5,0x1
  400960:	6a47b783          	ld	a5,1700(a5) # 402000 <freep>
  400964:	a02d                	j	40098e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  400966:	4618                	lw	a4,8(a2)
  400968:	9f2d                	addw	a4,a4,a1
  40096a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  40096e:	6398                	ld	a4,0(a5)
  400970:	6310                	ld	a2,0(a4)
  400972:	a83d                	j	4009b0 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  400974:	ff852703          	lw	a4,-8(a0)
  400978:	9f31                	addw	a4,a4,a2
  40097a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  40097c:	ff053683          	ld	a3,-16(a0)
  400980:	a091                	j	4009c4 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400982:	6398                	ld	a4,0(a5)
  400984:	00e7e463          	bltu	a5,a4,40098c <free+0x3c>
  400988:	00e6ea63          	bltu	a3,a4,40099c <free+0x4c>
{
  40098c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40098e:	fed7fae3          	bgeu	a5,a3,400982 <free+0x32>
  400992:	6398                	ld	a4,0(a5)
  400994:	00e6e463          	bltu	a3,a4,40099c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  400998:	fee7eae3          	bltu	a5,a4,40098c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  40099c:	ff852583          	lw	a1,-8(a0)
  4009a0:	6390                	ld	a2,0(a5)
  4009a2:	02059813          	slli	a6,a1,0x20
  4009a6:	01c85713          	srli	a4,a6,0x1c
  4009aa:	9736                	add	a4,a4,a3
  4009ac:	fae60de3          	beq	a2,a4,400966 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4009b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4009b4:	4790                	lw	a2,8(a5)
  4009b6:	02061593          	slli	a1,a2,0x20
  4009ba:	01c5d713          	srli	a4,a1,0x1c
  4009be:	973e                	add	a4,a4,a5
  4009c0:	fae68ae3          	beq	a3,a4,400974 <free+0x24>
    p->s.ptr = bp->s.ptr;
  4009c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4009c6:	00001717          	auipc	a4,0x1
  4009ca:	62f73d23          	sd	a5,1594(a4) # 402000 <freep>
}
  4009ce:	60a2                	ld	ra,8(sp)
  4009d0:	6402                	ld	s0,0(sp)
  4009d2:	0141                	addi	sp,sp,16
  4009d4:	8082                	ret

00000000004009d6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4009d6:	7139                	addi	sp,sp,-64
  4009d8:	fc06                	sd	ra,56(sp)
  4009da:	f822                	sd	s0,48(sp)
  4009dc:	f04a                	sd	s2,32(sp)
  4009de:	ec4e                	sd	s3,24(sp)
  4009e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4009e2:	02051993          	slli	s3,a0,0x20
  4009e6:	0209d993          	srli	s3,s3,0x20
  4009ea:	09bd                	addi	s3,s3,15
  4009ec:	0049d993          	srli	s3,s3,0x4
  4009f0:	2985                	addiw	s3,s3,1
  4009f2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4009f4:	00001517          	auipc	a0,0x1
  4009f8:	60c53503          	ld	a0,1548(a0) # 402000 <freep>
  4009fc:	c905                	beqz	a0,400a2c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4009fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400a00:	4798                	lw	a4,8(a5)
  400a02:	09377663          	bgeu	a4,s3,400a8e <malloc+0xb8>
  400a06:	f426                	sd	s1,40(sp)
  400a08:	e852                	sd	s4,16(sp)
  400a0a:	e456                	sd	s5,8(sp)
  400a0c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400a0e:	8a4e                	mv	s4,s3
  400a10:	6705                	lui	a4,0x1
  400a12:	00e9f363          	bgeu	s3,a4,400a18 <malloc+0x42>
  400a16:	6a05                	lui	s4,0x1
  400a18:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400a1c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  400a20:	00001497          	auipc	s1,0x1
  400a24:	5e048493          	addi	s1,s1,1504 # 402000 <freep>
  if(p == (char*)-1)
  400a28:	5afd                	li	s5,-1
  400a2a:	a83d                	j	400a68 <malloc+0x92>
  400a2c:	f426                	sd	s1,40(sp)
  400a2e:	e852                	sd	s4,16(sp)
  400a30:	e456                	sd	s5,8(sp)
  400a32:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  400a34:	00002797          	auipc	a5,0x2
  400a38:	9dc78793          	addi	a5,a5,-1572 # 402410 <base>
  400a3c:	00001717          	auipc	a4,0x1
  400a40:	5cf73223          	sd	a5,1476(a4) # 402000 <freep>
  400a44:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400a46:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  400a4a:	b7d1                	j	400a0e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400a4c:	6398                	ld	a4,0(a5)
  400a4e:	e118                	sd	a4,0(a0)
  400a50:	a899                	j	400aa6 <malloc+0xd0>
  hp->s.size = nu;
  400a52:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400a56:	0541                	addi	a0,a0,16
  400a58:	ef9ff0ef          	jal	400950 <free>
  return freep;
  400a5c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  400a5e:	c125                	beqz	a0,400abe <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400a60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400a62:	4798                	lw	a4,8(a5)
  400a64:	03277163          	bgeu	a4,s2,400a86 <malloc+0xb0>
    if(p == freep)
  400a68:	6098                	ld	a4,0(s1)
  400a6a:	853e                	mv	a0,a5
  400a6c:	fef71ae3          	bne	a4,a5,400a60 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400a70:	8552                	mv	a0,s4
  400a72:	b17ff0ef          	jal	400588 <sbrk>
  if(p == (char*)-1)
  400a76:	fd551ee3          	bne	a0,s5,400a52 <malloc+0x7c>
        return 0;
  400a7a:	4501                	li	a0,0
  400a7c:	74a2                	ld	s1,40(sp)
  400a7e:	6a42                	ld	s4,16(sp)
  400a80:	6aa2                	ld	s5,8(sp)
  400a82:	6b02                	ld	s6,0(sp)
  400a84:	a03d                	j	400ab2 <malloc+0xdc>
  400a86:	74a2                	ld	s1,40(sp)
  400a88:	6a42                	ld	s4,16(sp)
  400a8a:	6aa2                	ld	s5,8(sp)
  400a8c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400a8e:	fae90fe3          	beq	s2,a4,400a4c <malloc+0x76>
        p->s.size -= nunits;
  400a92:	4137073b          	subw	a4,a4,s3
  400a96:	c798                	sw	a4,8(a5)
        p += p->s.size;
  400a98:	02071693          	slli	a3,a4,0x20
  400a9c:	01c6d713          	srli	a4,a3,0x1c
  400aa0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  400aa2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400aa6:	00001717          	auipc	a4,0x1
  400aaa:	54a73d23          	sd	a0,1370(a4) # 402000 <freep>
      return (void*)(p + 1);
  400aae:	01078513          	addi	a0,a5,16
  }
}
  400ab2:	70e2                	ld	ra,56(sp)
  400ab4:	7442                	ld	s0,48(sp)
  400ab6:	7902                	ld	s2,32(sp)
  400ab8:	69e2                	ld	s3,24(sp)
  400aba:	6121                	addi	sp,sp,64
  400abc:	8082                	ret
  400abe:	74a2                	ld	s1,40(sp)
  400ac0:	6a42                	ld	s4,16(sp)
  400ac2:	6aa2                	ld	s5,8(sp)
  400ac4:	6b02                	ld	s6,0(sp)
  400ac6:	b7f5                	j	400ab2 <malloc+0xdc>
