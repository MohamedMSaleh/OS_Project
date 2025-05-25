
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
  400000:	7179                	addi	sp,sp,-48
  400002:	f406                	sd	ra,40(sp)
  400004:	f022                	sd	s0,32(sp)
  400006:	ec26                	sd	s1,24(sp)
  400008:	1800                	addi	s0,sp,48
  40000a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  40000c:	2de000ef          	jal	4002ea <strlen>
  400010:	02051793          	slli	a5,a0,0x20
  400014:	9381                	srli	a5,a5,0x20
  400016:	97a6                	add	a5,a5,s1
  400018:	02f00693          	li	a3,47
  40001c:	0097e963          	bltu	a5,s1,40002e <fmtname+0x2e>
  400020:	0007c703          	lbu	a4,0(a5)
  400024:	00d70563          	beq	a4,a3,40002e <fmtname+0x2e>
  400028:	17fd                	addi	a5,a5,-1
  40002a:	fe97fbe3          	bgeu	a5,s1,400020 <fmtname+0x20>
    ;
  p++;
  40002e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  400032:	8526                	mv	a0,s1
  400034:	2b6000ef          	jal	4002ea <strlen>
  400038:	47b5                	li	a5,13
  40003a:	00a7f863          	bgeu	a5,a0,40004a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  40003e:	8526                	mv	a0,s1
  400040:	70a2                	ld	ra,40(sp)
  400042:	7402                	ld	s0,32(sp)
  400044:	64e2                	ld	s1,24(sp)
  400046:	6145                	addi	sp,sp,48
  400048:	8082                	ret
  40004a:	e84a                	sd	s2,16(sp)
  40004c:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  40004e:	8526                	mv	a0,s1
  400050:	29a000ef          	jal	4002ea <strlen>
  400054:	862a                	mv	a2,a0
  400056:	00002997          	auipc	s3,0x2
  40005a:	fba98993          	addi	s3,s3,-70 # 402010 <buf.0>
  40005e:	85a6                	mv	a1,s1
  400060:	854e                	mv	a0,s3
  400062:	40e000ef          	jal	400470 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  400066:	8526                	mv	a0,s1
  400068:	282000ef          	jal	4002ea <strlen>
  40006c:	892a                	mv	s2,a0
  40006e:	8526                	mv	a0,s1
  400070:	27a000ef          	jal	4002ea <strlen>
  400074:	1902                	slli	s2,s2,0x20
  400076:	02095913          	srli	s2,s2,0x20
  40007a:	4639                	li	a2,14
  40007c:	9e09                	subw	a2,a2,a0
  40007e:	02000593          	li	a1,32
  400082:	01298533          	add	a0,s3,s2
  400086:	292000ef          	jal	400318 <memset>
  return buf;
  40008a:	84ce                	mv	s1,s3
  40008c:	6942                	ld	s2,16(sp)
  40008e:	69a2                	ld	s3,8(sp)
  400090:	b77d                	j	40003e <fmtname+0x3e>

0000000000400092 <ls>:

void
ls(char *path)
{
  400092:	d7010113          	addi	sp,sp,-656
  400096:	28113423          	sd	ra,648(sp)
  40009a:	28813023          	sd	s0,640(sp)
  40009e:	27213823          	sd	s2,624(sp)
  4000a2:	0d00                	addi	s0,sp,656
  4000a4:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  4000a6:	4581                	li	a1,0
  4000a8:	4be000ef          	jal	400566 <open>
  4000ac:	06054363          	bltz	a0,400112 <ls+0x80>
  4000b0:	26913c23          	sd	s1,632(sp)
  4000b4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  4000b6:	d7840593          	addi	a1,s0,-648
  4000ba:	4c4000ef          	jal	40057e <fstat>
  4000be:	06054363          	bltz	a0,400124 <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  4000c2:	d8041783          	lh	a5,-640(s0)
  4000c6:	4705                	li	a4,1
  4000c8:	06e78c63          	beq	a5,a4,400140 <ls+0xae>
  4000cc:	37f9                	addiw	a5,a5,-2
  4000ce:	17c2                	slli	a5,a5,0x30
  4000d0:	93c1                	srli	a5,a5,0x30
  4000d2:	02f76263          	bltu	a4,a5,4000f6 <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  4000d6:	854a                	mv	a0,s2
  4000d8:	f29ff0ef          	jal	400000 <fmtname>
  4000dc:	85aa                	mv	a1,a0
  4000de:	d8842703          	lw	a4,-632(s0)
  4000e2:	d7c42683          	lw	a3,-644(s0)
  4000e6:	d8041603          	lh	a2,-640(s0)
  4000ea:	00001517          	auipc	a0,0x1
  4000ee:	a3650513          	addi	a0,a0,-1482 # 400b20 <malloc+0x124>
  4000f2:	051000ef          	jal	400942 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  4000f6:	8526                	mv	a0,s1
  4000f8:	456000ef          	jal	40054e <close>
  4000fc:	27813483          	ld	s1,632(sp)
}
  400100:	28813083          	ld	ra,648(sp)
  400104:	28013403          	ld	s0,640(sp)
  400108:	27013903          	ld	s2,624(sp)
  40010c:	29010113          	addi	sp,sp,656
  400110:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
  400112:	864a                	mv	a2,s2
  400114:	00001597          	auipc	a1,0x1
  400118:	9dc58593          	addi	a1,a1,-1572 # 400af0 <malloc+0xf4>
  40011c:	4509                	li	a0,2
  40011e:	7f8000ef          	jal	400916 <fprintf>
    return;
  400122:	bff9                	j	400100 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
  400124:	864a                	mv	a2,s2
  400126:	00001597          	auipc	a1,0x1
  40012a:	9e258593          	addi	a1,a1,-1566 # 400b08 <malloc+0x10c>
  40012e:	4509                	li	a0,2
  400130:	7e6000ef          	jal	400916 <fprintf>
    close(fd);
  400134:	8526                	mv	a0,s1
  400136:	418000ef          	jal	40054e <close>
    return;
  40013a:	27813483          	ld	s1,632(sp)
  40013e:	b7c9                	j	400100 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
  400140:	854a                	mv	a0,s2
  400142:	1a8000ef          	jal	4002ea <strlen>
  400146:	2541                	addiw	a0,a0,16
  400148:	20000793          	li	a5,512
  40014c:	00a7f963          	bgeu	a5,a0,40015e <ls+0xcc>
      printf("ls: path too long\n");
  400150:	00001517          	auipc	a0,0x1
  400154:	9e050513          	addi	a0,a0,-1568 # 400b30 <malloc+0x134>
  400158:	7ea000ef          	jal	400942 <printf>
      break;
  40015c:	bf69                	j	4000f6 <ls+0x64>
  40015e:	27313423          	sd	s3,616(sp)
  400162:	27413023          	sd	s4,608(sp)
  400166:	25513c23          	sd	s5,600(sp)
  40016a:	25613823          	sd	s6,592(sp)
  40016e:	25713423          	sd	s7,584(sp)
  400172:	25813023          	sd	s8,576(sp)
  400176:	23913c23          	sd	s9,568(sp)
  40017a:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
  40017e:	da040993          	addi	s3,s0,-608
  400182:	85ca                	mv	a1,s2
  400184:	854e                	mv	a0,s3
  400186:	114000ef          	jal	40029a <strcpy>
    p = buf+strlen(buf);
  40018a:	854e                	mv	a0,s3
  40018c:	15e000ef          	jal	4002ea <strlen>
  400190:	1502                	slli	a0,a0,0x20
  400192:	9101                	srli	a0,a0,0x20
  400194:	99aa                	add	s3,s3,a0
    *p++ = '/';
  400196:	00198c93          	addi	s9,s3,1
  40019a:	02f00793          	li	a5,47
  40019e:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
  4001a2:	d9040a13          	addi	s4,s0,-624
  4001a6:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
  4001a8:	d9240c13          	addi	s8,s0,-622
  4001ac:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
  4001ae:	d7840b13          	addi	s6,s0,-648
  4001b2:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
  4001b6:	00001d17          	auipc	s10,0x1
  4001ba:	96ad0d13          	addi	s10,s10,-1686 # 400b20 <malloc+0x124>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
  4001be:	a801                	j	4001ce <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
  4001c0:	85d6                	mv	a1,s5
  4001c2:	00001517          	auipc	a0,0x1
  4001c6:	94650513          	addi	a0,a0,-1722 # 400b08 <malloc+0x10c>
  4001ca:	778000ef          	jal	400942 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
  4001ce:	864a                	mv	a2,s2
  4001d0:	85d2                	mv	a1,s4
  4001d2:	8526                	mv	a0,s1
  4001d4:	36a000ef          	jal	40053e <read>
  4001d8:	05251063          	bne	a0,s2,400218 <ls+0x186>
      if(de.inum == 0)
  4001dc:	d9045783          	lhu	a5,-624(s0)
  4001e0:	d7fd                	beqz	a5,4001ce <ls+0x13c>
      memmove(p, de.name, DIRSIZ);
  4001e2:	865e                	mv	a2,s7
  4001e4:	85e2                	mv	a1,s8
  4001e6:	8566                	mv	a0,s9
  4001e8:	288000ef          	jal	400470 <memmove>
      p[DIRSIZ] = 0;
  4001ec:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
  4001f0:	85da                	mv	a1,s6
  4001f2:	8556                	mv	a0,s5
  4001f4:	1f6000ef          	jal	4003ea <stat>
  4001f8:	fc0544e3          	bltz	a0,4001c0 <ls+0x12e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
  4001fc:	8556                	mv	a0,s5
  4001fe:	e03ff0ef          	jal	400000 <fmtname>
  400202:	85aa                	mv	a1,a0
  400204:	d8842703          	lw	a4,-632(s0)
  400208:	d7c42683          	lw	a3,-644(s0)
  40020c:	d8041603          	lh	a2,-640(s0)
  400210:	856a                	mv	a0,s10
  400212:	730000ef          	jal	400942 <printf>
  400216:	bf65                	j	4001ce <ls+0x13c>
  400218:	26813983          	ld	s3,616(sp)
  40021c:	26013a03          	ld	s4,608(sp)
  400220:	25813a83          	ld	s5,600(sp)
  400224:	25013b03          	ld	s6,592(sp)
  400228:	24813b83          	ld	s7,584(sp)
  40022c:	24013c03          	ld	s8,576(sp)
  400230:	23813c83          	ld	s9,568(sp)
  400234:	23013d03          	ld	s10,560(sp)
  400238:	bd7d                	j	4000f6 <ls+0x64>

000000000040023a <main>:

int
main(int argc, char *argv[])
{
  40023a:	1101                	addi	sp,sp,-32
  40023c:	ec06                	sd	ra,24(sp)
  40023e:	e822                	sd	s0,16(sp)
  400240:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
  400242:	4785                	li	a5,1
  400244:	02a7d763          	bge	a5,a0,400272 <main+0x38>
  400248:	e426                	sd	s1,8(sp)
  40024a:	e04a                	sd	s2,0(sp)
  40024c:	00858493          	addi	s1,a1,8
  400250:	ffe5091b          	addiw	s2,a0,-2
  400254:	02091793          	slli	a5,s2,0x20
  400258:	01d7d913          	srli	s2,a5,0x1d
  40025c:	05c1                	addi	a1,a1,16
  40025e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  400260:	6088                	ld	a0,0(s1)
  400262:	e31ff0ef          	jal	400092 <ls>
  for(i=1; i<argc; i++)
  400266:	04a1                	addi	s1,s1,8
  400268:	ff249ce3          	bne	s1,s2,400260 <main+0x26>
  exit(0);
  40026c:	4501                	li	a0,0
  40026e:	2b8000ef          	jal	400526 <exit>
  400272:	e426                	sd	s1,8(sp)
  400274:	e04a                	sd	s2,0(sp)
    ls(".");
  400276:	00001517          	auipc	a0,0x1
  40027a:	8d250513          	addi	a0,a0,-1838 # 400b48 <malloc+0x14c>
  40027e:	e15ff0ef          	jal	400092 <ls>
    exit(0);
  400282:	4501                	li	a0,0
  400284:	2a2000ef          	jal	400526 <exit>

0000000000400288 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  400288:	1141                	addi	sp,sp,-16
  40028a:	e406                	sd	ra,8(sp)
  40028c:	e022                	sd	s0,0(sp)
  40028e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  400290:	fabff0ef          	jal	40023a <main>
  exit(0);
  400294:	4501                	li	a0,0
  400296:	290000ef          	jal	400526 <exit>

000000000040029a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  40029a:	1141                	addi	sp,sp,-16
  40029c:	e406                	sd	ra,8(sp)
  40029e:	e022                	sd	s0,0(sp)
  4002a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4002a2:	87aa                	mv	a5,a0
  4002a4:	0585                	addi	a1,a1,1
  4002a6:	0785                	addi	a5,a5,1
  4002a8:	fff5c703          	lbu	a4,-1(a1)
  4002ac:	fee78fa3          	sb	a4,-1(a5)
  4002b0:	fb75                	bnez	a4,4002a4 <strcpy+0xa>
    ;
  return os;
}
  4002b2:	60a2                	ld	ra,8(sp)
  4002b4:	6402                	ld	s0,0(sp)
  4002b6:	0141                	addi	sp,sp,16
  4002b8:	8082                	ret

00000000004002ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4002ba:	1141                	addi	sp,sp,-16
  4002bc:	e406                	sd	ra,8(sp)
  4002be:	e022                	sd	s0,0(sp)
  4002c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4002c2:	00054783          	lbu	a5,0(a0)
  4002c6:	cb91                	beqz	a5,4002da <strcmp+0x20>
  4002c8:	0005c703          	lbu	a4,0(a1)
  4002cc:	00f71763          	bne	a4,a5,4002da <strcmp+0x20>
    p++, q++;
  4002d0:	0505                	addi	a0,a0,1
  4002d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4002d4:	00054783          	lbu	a5,0(a0)
  4002d8:	fbe5                	bnez	a5,4002c8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4002da:	0005c503          	lbu	a0,0(a1)
}
  4002de:	40a7853b          	subw	a0,a5,a0
  4002e2:	60a2                	ld	ra,8(sp)
  4002e4:	6402                	ld	s0,0(sp)
  4002e6:	0141                	addi	sp,sp,16
  4002e8:	8082                	ret

00000000004002ea <strlen>:

uint
strlen(const char *s)
{
  4002ea:	1141                	addi	sp,sp,-16
  4002ec:	e406                	sd	ra,8(sp)
  4002ee:	e022                	sd	s0,0(sp)
  4002f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4002f2:	00054783          	lbu	a5,0(a0)
  4002f6:	cf99                	beqz	a5,400314 <strlen+0x2a>
  4002f8:	0505                	addi	a0,a0,1
  4002fa:	87aa                	mv	a5,a0
  4002fc:	86be                	mv	a3,a5
  4002fe:	0785                	addi	a5,a5,1
  400300:	fff7c703          	lbu	a4,-1(a5)
  400304:	ff65                	bnez	a4,4002fc <strlen+0x12>
  400306:	40a6853b          	subw	a0,a3,a0
  40030a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  40030c:	60a2                	ld	ra,8(sp)
  40030e:	6402                	ld	s0,0(sp)
  400310:	0141                	addi	sp,sp,16
  400312:	8082                	ret
  for(n = 0; s[n]; n++)
  400314:	4501                	li	a0,0
  400316:	bfdd                	j	40030c <strlen+0x22>

0000000000400318 <memset>:

void*
memset(void *dst, int c, uint n)
{
  400318:	1141                	addi	sp,sp,-16
  40031a:	e406                	sd	ra,8(sp)
  40031c:	e022                	sd	s0,0(sp)
  40031e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400320:	ca19                	beqz	a2,400336 <memset+0x1e>
  400322:	87aa                	mv	a5,a0
  400324:	1602                	slli	a2,a2,0x20
  400326:	9201                	srli	a2,a2,0x20
  400328:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  40032c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400330:	0785                	addi	a5,a5,1
  400332:	fee79de3          	bne	a5,a4,40032c <memset+0x14>
  }
  return dst;
}
  400336:	60a2                	ld	ra,8(sp)
  400338:	6402                	ld	s0,0(sp)
  40033a:	0141                	addi	sp,sp,16
  40033c:	8082                	ret

000000000040033e <strchr>:

char*
strchr(const char *s, char c)
{
  40033e:	1141                	addi	sp,sp,-16
  400340:	e406                	sd	ra,8(sp)
  400342:	e022                	sd	s0,0(sp)
  400344:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400346:	00054783          	lbu	a5,0(a0)
  40034a:	cf81                	beqz	a5,400362 <strchr+0x24>
    if(*s == c)
  40034c:	00f58763          	beq	a1,a5,40035a <strchr+0x1c>
  for(; *s; s++)
  400350:	0505                	addi	a0,a0,1
  400352:	00054783          	lbu	a5,0(a0)
  400356:	fbfd                	bnez	a5,40034c <strchr+0xe>
      return (char*)s;
  return 0;
  400358:	4501                	li	a0,0
}
  40035a:	60a2                	ld	ra,8(sp)
  40035c:	6402                	ld	s0,0(sp)
  40035e:	0141                	addi	sp,sp,16
  400360:	8082                	ret
  return 0;
  400362:	4501                	li	a0,0
  400364:	bfdd                	j	40035a <strchr+0x1c>

0000000000400366 <gets>:

char*
gets(char *buf, int max)
{
  400366:	7159                	addi	sp,sp,-112
  400368:	f486                	sd	ra,104(sp)
  40036a:	f0a2                	sd	s0,96(sp)
  40036c:	eca6                	sd	s1,88(sp)
  40036e:	e8ca                	sd	s2,80(sp)
  400370:	e4ce                	sd	s3,72(sp)
  400372:	e0d2                	sd	s4,64(sp)
  400374:	fc56                	sd	s5,56(sp)
  400376:	f85a                	sd	s6,48(sp)
  400378:	f45e                	sd	s7,40(sp)
  40037a:	f062                	sd	s8,32(sp)
  40037c:	ec66                	sd	s9,24(sp)
  40037e:	e86a                	sd	s10,16(sp)
  400380:	1880                	addi	s0,sp,112
  400382:	8caa                	mv	s9,a0
  400384:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400386:	892a                	mv	s2,a0
  400388:	4481                	li	s1,0
    cc = read(0, &c, 1);
  40038a:	f9f40b13          	addi	s6,s0,-97
  40038e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400390:	4ba9                	li	s7,10
  400392:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400394:	8d26                	mv	s10,s1
  400396:	0014899b          	addiw	s3,s1,1
  40039a:	84ce                	mv	s1,s3
  40039c:	0349d563          	bge	s3,s4,4003c6 <gets+0x60>
    cc = read(0, &c, 1);
  4003a0:	8656                	mv	a2,s5
  4003a2:	85da                	mv	a1,s6
  4003a4:	4501                	li	a0,0
  4003a6:	198000ef          	jal	40053e <read>
    if(cc < 1)
  4003aa:	00a05e63          	blez	a0,4003c6 <gets+0x60>
    buf[i++] = c;
  4003ae:	f9f44783          	lbu	a5,-97(s0)
  4003b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  4003b6:	01778763          	beq	a5,s7,4003c4 <gets+0x5e>
  4003ba:	0905                	addi	s2,s2,1
  4003bc:	fd879ce3          	bne	a5,s8,400394 <gets+0x2e>
    buf[i++] = c;
  4003c0:	8d4e                	mv	s10,s3
  4003c2:	a011                	j	4003c6 <gets+0x60>
  4003c4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  4003c6:	9d66                	add	s10,s10,s9
  4003c8:	000d0023          	sb	zero,0(s10)
  return buf;
}
  4003cc:	8566                	mv	a0,s9
  4003ce:	70a6                	ld	ra,104(sp)
  4003d0:	7406                	ld	s0,96(sp)
  4003d2:	64e6                	ld	s1,88(sp)
  4003d4:	6946                	ld	s2,80(sp)
  4003d6:	69a6                	ld	s3,72(sp)
  4003d8:	6a06                	ld	s4,64(sp)
  4003da:	7ae2                	ld	s5,56(sp)
  4003dc:	7b42                	ld	s6,48(sp)
  4003de:	7ba2                	ld	s7,40(sp)
  4003e0:	7c02                	ld	s8,32(sp)
  4003e2:	6ce2                	ld	s9,24(sp)
  4003e4:	6d42                	ld	s10,16(sp)
  4003e6:	6165                	addi	sp,sp,112
  4003e8:	8082                	ret

00000000004003ea <stat>:

int
stat(const char *n, struct stat *st)
{
  4003ea:	1101                	addi	sp,sp,-32
  4003ec:	ec06                	sd	ra,24(sp)
  4003ee:	e822                	sd	s0,16(sp)
  4003f0:	e04a                	sd	s2,0(sp)
  4003f2:	1000                	addi	s0,sp,32
  4003f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  4003f6:	4581                	li	a1,0
  4003f8:	16e000ef          	jal	400566 <open>
  if(fd < 0)
  4003fc:	02054263          	bltz	a0,400420 <stat+0x36>
  400400:	e426                	sd	s1,8(sp)
  400402:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  400404:	85ca                	mv	a1,s2
  400406:	178000ef          	jal	40057e <fstat>
  40040a:	892a                	mv	s2,a0
  close(fd);
  40040c:	8526                	mv	a0,s1
  40040e:	140000ef          	jal	40054e <close>
  return r;
  400412:	64a2                	ld	s1,8(sp)
}
  400414:	854a                	mv	a0,s2
  400416:	60e2                	ld	ra,24(sp)
  400418:	6442                	ld	s0,16(sp)
  40041a:	6902                	ld	s2,0(sp)
  40041c:	6105                	addi	sp,sp,32
  40041e:	8082                	ret
    return -1;
  400420:	597d                	li	s2,-1
  400422:	bfcd                	j	400414 <stat+0x2a>

0000000000400424 <atoi>:

int
atoi(const char *s)
{
  400424:	1141                	addi	sp,sp,-16
  400426:	e406                	sd	ra,8(sp)
  400428:	e022                	sd	s0,0(sp)
  40042a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  40042c:	00054683          	lbu	a3,0(a0)
  400430:	fd06879b          	addiw	a5,a3,-48
  400434:	0ff7f793          	zext.b	a5,a5
  400438:	4625                	li	a2,9
  40043a:	02f66963          	bltu	a2,a5,40046c <atoi+0x48>
  40043e:	872a                	mv	a4,a0
  n = 0;
  400440:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400442:	0705                	addi	a4,a4,1
  400444:	0025179b          	slliw	a5,a0,0x2
  400448:	9fa9                	addw	a5,a5,a0
  40044a:	0017979b          	slliw	a5,a5,0x1
  40044e:	9fb5                	addw	a5,a5,a3
  400450:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400454:	00074683          	lbu	a3,0(a4)
  400458:	fd06879b          	addiw	a5,a3,-48
  40045c:	0ff7f793          	zext.b	a5,a5
  400460:	fef671e3          	bgeu	a2,a5,400442 <atoi+0x1e>
  return n;
}
  400464:	60a2                	ld	ra,8(sp)
  400466:	6402                	ld	s0,0(sp)
  400468:	0141                	addi	sp,sp,16
  40046a:	8082                	ret
  n = 0;
  40046c:	4501                	li	a0,0
  40046e:	bfdd                	j	400464 <atoi+0x40>

0000000000400470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400470:	1141                	addi	sp,sp,-16
  400472:	e406                	sd	ra,8(sp)
  400474:	e022                	sd	s0,0(sp)
  400476:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400478:	02b57563          	bgeu	a0,a1,4004a2 <memmove+0x32>
    while(n-- > 0)
  40047c:	00c05f63          	blez	a2,40049a <memmove+0x2a>
  400480:	1602                	slli	a2,a2,0x20
  400482:	9201                	srli	a2,a2,0x20
  400484:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400488:	872a                	mv	a4,a0
      *dst++ = *src++;
  40048a:	0585                	addi	a1,a1,1
  40048c:	0705                	addi	a4,a4,1
  40048e:	fff5c683          	lbu	a3,-1(a1)
  400492:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400496:	fee79ae3          	bne	a5,a4,40048a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  40049a:	60a2                	ld	ra,8(sp)
  40049c:	6402                	ld	s0,0(sp)
  40049e:	0141                	addi	sp,sp,16
  4004a0:	8082                	ret
    dst += n;
  4004a2:	00c50733          	add	a4,a0,a2
    src += n;
  4004a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  4004a8:	fec059e3          	blez	a2,40049a <memmove+0x2a>
  4004ac:	fff6079b          	addiw	a5,a2,-1
  4004b0:	1782                	slli	a5,a5,0x20
  4004b2:	9381                	srli	a5,a5,0x20
  4004b4:	fff7c793          	not	a5,a5
  4004b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  4004ba:	15fd                	addi	a1,a1,-1
  4004bc:	177d                	addi	a4,a4,-1
  4004be:	0005c683          	lbu	a3,0(a1)
  4004c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  4004c6:	fef71ae3          	bne	a4,a5,4004ba <memmove+0x4a>
  4004ca:	bfc1                	j	40049a <memmove+0x2a>

00000000004004cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  4004cc:	1141                	addi	sp,sp,-16
  4004ce:	e406                	sd	ra,8(sp)
  4004d0:	e022                	sd	s0,0(sp)
  4004d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  4004d4:	ca0d                	beqz	a2,400506 <memcmp+0x3a>
  4004d6:	fff6069b          	addiw	a3,a2,-1
  4004da:	1682                	slli	a3,a3,0x20
  4004dc:	9281                	srli	a3,a3,0x20
  4004de:	0685                	addi	a3,a3,1
  4004e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  4004e2:	00054783          	lbu	a5,0(a0)
  4004e6:	0005c703          	lbu	a4,0(a1)
  4004ea:	00e79863          	bne	a5,a4,4004fa <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  4004ee:	0505                	addi	a0,a0,1
    p2++;
  4004f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  4004f2:	fed518e3          	bne	a0,a3,4004e2 <memcmp+0x16>
  }
  return 0;
  4004f6:	4501                	li	a0,0
  4004f8:	a019                	j	4004fe <memcmp+0x32>
      return *p1 - *p2;
  4004fa:	40e7853b          	subw	a0,a5,a4
}
  4004fe:	60a2                	ld	ra,8(sp)
  400500:	6402                	ld	s0,0(sp)
  400502:	0141                	addi	sp,sp,16
  400504:	8082                	ret
  return 0;
  400506:	4501                	li	a0,0
  400508:	bfdd                	j	4004fe <memcmp+0x32>

000000000040050a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  40050a:	1141                	addi	sp,sp,-16
  40050c:	e406                	sd	ra,8(sp)
  40050e:	e022                	sd	s0,0(sp)
  400510:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400512:	f5fff0ef          	jal	400470 <memmove>
}
  400516:	60a2                	ld	ra,8(sp)
  400518:	6402                	ld	s0,0(sp)
  40051a:	0141                	addi	sp,sp,16
  40051c:	8082                	ret

000000000040051e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  40051e:	4885                	li	a7,1
 ecall
  400520:	00000073          	ecall
 ret
  400524:	8082                	ret

0000000000400526 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400526:	4889                	li	a7,2
 ecall
  400528:	00000073          	ecall
 ret
  40052c:	8082                	ret

000000000040052e <wait>:
.global wait
wait:
 li a7, SYS_wait
  40052e:	488d                	li	a7,3
 ecall
  400530:	00000073          	ecall
 ret
  400534:	8082                	ret

0000000000400536 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400536:	4891                	li	a7,4
 ecall
  400538:	00000073          	ecall
 ret
  40053c:	8082                	ret

000000000040053e <read>:
.global read
read:
 li a7, SYS_read
  40053e:	4895                	li	a7,5
 ecall
  400540:	00000073          	ecall
 ret
  400544:	8082                	ret

0000000000400546 <write>:
.global write
write:
 li a7, SYS_write
  400546:	48c1                	li	a7,16
 ecall
  400548:	00000073          	ecall
 ret
  40054c:	8082                	ret

000000000040054e <close>:
.global close
close:
 li a7, SYS_close
  40054e:	48d5                	li	a7,21
 ecall
  400550:	00000073          	ecall
 ret
  400554:	8082                	ret

0000000000400556 <kill>:
.global kill
kill:
 li a7, SYS_kill
  400556:	4899                	li	a7,6
 ecall
  400558:	00000073          	ecall
 ret
  40055c:	8082                	ret

000000000040055e <exec>:
.global exec
exec:
 li a7, SYS_exec
  40055e:	489d                	li	a7,7
 ecall
  400560:	00000073          	ecall
 ret
  400564:	8082                	ret

0000000000400566 <open>:
.global open
open:
 li a7, SYS_open
  400566:	48bd                	li	a7,15
 ecall
  400568:	00000073          	ecall
 ret
  40056c:	8082                	ret

000000000040056e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  40056e:	48c5                	li	a7,17
 ecall
  400570:	00000073          	ecall
 ret
  400574:	8082                	ret

0000000000400576 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400576:	48c9                	li	a7,18
 ecall
  400578:	00000073          	ecall
 ret
  40057c:	8082                	ret

000000000040057e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  40057e:	48a1                	li	a7,8
 ecall
  400580:	00000073          	ecall
 ret
  400584:	8082                	ret

0000000000400586 <link>:
.global link
link:
 li a7, SYS_link
  400586:	48cd                	li	a7,19
 ecall
  400588:	00000073          	ecall
 ret
  40058c:	8082                	ret

000000000040058e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  40058e:	48d1                	li	a7,20
 ecall
  400590:	00000073          	ecall
 ret
  400594:	8082                	ret

0000000000400596 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400596:	48a5                	li	a7,9
 ecall
  400598:	00000073          	ecall
 ret
  40059c:	8082                	ret

000000000040059e <dup>:
.global dup
dup:
 li a7, SYS_dup
  40059e:	48a9                	li	a7,10
 ecall
  4005a0:	00000073          	ecall
 ret
  4005a4:	8082                	ret

00000000004005a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  4005a6:	48ad                	li	a7,11
 ecall
  4005a8:	00000073          	ecall
 ret
  4005ac:	8082                	ret

00000000004005ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  4005ae:	48b1                	li	a7,12
 ecall
  4005b0:	00000073          	ecall
 ret
  4005b4:	8082                	ret

00000000004005b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  4005b6:	48b5                	li	a7,13
 ecall
  4005b8:	00000073          	ecall
 ret
  4005bc:	8082                	ret

00000000004005be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  4005be:	48b9                	li	a7,14
 ecall
  4005c0:	00000073          	ecall
 ret
  4005c4:	8082                	ret

00000000004005c6 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  4005c6:	48d9                	li	a7,22
 ecall
  4005c8:	00000073          	ecall
 ret
  4005cc:	8082                	ret

00000000004005ce <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  4005ce:	48dd                	li	a7,23
 ecall
  4005d0:	00000073          	ecall
 ret
  4005d4:	8082                	ret

00000000004005d6 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  4005d6:	48e1                	li	a7,24
 ecall
  4005d8:	00000073          	ecall
 ret
  4005dc:	8082                	ret

00000000004005de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  4005de:	1101                	addi	sp,sp,-32
  4005e0:	ec06                	sd	ra,24(sp)
  4005e2:	e822                	sd	s0,16(sp)
  4005e4:	1000                	addi	s0,sp,32
  4005e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  4005ea:	4605                	li	a2,1
  4005ec:	fef40593          	addi	a1,s0,-17
  4005f0:	f57ff0ef          	jal	400546 <write>
}
  4005f4:	60e2                	ld	ra,24(sp)
  4005f6:	6442                	ld	s0,16(sp)
  4005f8:	6105                	addi	sp,sp,32
  4005fa:	8082                	ret

00000000004005fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  4005fc:	7139                	addi	sp,sp,-64
  4005fe:	fc06                	sd	ra,56(sp)
  400600:	f822                	sd	s0,48(sp)
  400602:	f426                	sd	s1,40(sp)
  400604:	f04a                	sd	s2,32(sp)
  400606:	ec4e                	sd	s3,24(sp)
  400608:	0080                	addi	s0,sp,64
  40060a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  40060c:	c299                	beqz	a3,400612 <printint+0x16>
  40060e:	0605ce63          	bltz	a1,40068a <printint+0x8e>
  neg = 0;
  400612:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400614:	fc040313          	addi	t1,s0,-64
  neg = 0;
  400618:	869a                	mv	a3,t1
  i = 0;
  40061a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  40061c:	00000817          	auipc	a6,0x0
  400620:	53c80813          	addi	a6,a6,1340 # 400b58 <digits>
  400624:	88be                	mv	a7,a5
  400626:	0017851b          	addiw	a0,a5,1
  40062a:	87aa                	mv	a5,a0
  40062c:	02c5f73b          	remuw	a4,a1,a2
  400630:	1702                	slli	a4,a4,0x20
  400632:	9301                	srli	a4,a4,0x20
  400634:	9742                	add	a4,a4,a6
  400636:	00074703          	lbu	a4,0(a4)
  40063a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  40063e:	872e                	mv	a4,a1
  400640:	02c5d5bb          	divuw	a1,a1,a2
  400644:	0685                	addi	a3,a3,1
  400646:	fcc77fe3          	bgeu	a4,a2,400624 <printint+0x28>
  if(neg)
  40064a:	000e0c63          	beqz	t3,400662 <printint+0x66>
    buf[i++] = '-';
  40064e:	fd050793          	addi	a5,a0,-48
  400652:	00878533          	add	a0,a5,s0
  400656:	02d00793          	li	a5,45
  40065a:	fef50823          	sb	a5,-16(a0)
  40065e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400662:	fff7899b          	addiw	s3,a5,-1
  400666:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  40066a:	fff4c583          	lbu	a1,-1(s1)
  40066e:	854a                	mv	a0,s2
  400670:	f6fff0ef          	jal	4005de <putc>
  while(--i >= 0)
  400674:	39fd                	addiw	s3,s3,-1
  400676:	14fd                	addi	s1,s1,-1
  400678:	fe09d9e3          	bgez	s3,40066a <printint+0x6e>
}
  40067c:	70e2                	ld	ra,56(sp)
  40067e:	7442                	ld	s0,48(sp)
  400680:	74a2                	ld	s1,40(sp)
  400682:	7902                	ld	s2,32(sp)
  400684:	69e2                	ld	s3,24(sp)
  400686:	6121                	addi	sp,sp,64
  400688:	8082                	ret
    x = -xx;
  40068a:	40b005bb          	negw	a1,a1
    neg = 1;
  40068e:	4e05                	li	t3,1
    x = -xx;
  400690:	b751                	j	400614 <printint+0x18>

0000000000400692 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400692:	711d                	addi	sp,sp,-96
  400694:	ec86                	sd	ra,88(sp)
  400696:	e8a2                	sd	s0,80(sp)
  400698:	e4a6                	sd	s1,72(sp)
  40069a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  40069c:	0005c483          	lbu	s1,0(a1)
  4006a0:	26048663          	beqz	s1,40090c <vprintf+0x27a>
  4006a4:	e0ca                	sd	s2,64(sp)
  4006a6:	fc4e                	sd	s3,56(sp)
  4006a8:	f852                	sd	s4,48(sp)
  4006aa:	f456                	sd	s5,40(sp)
  4006ac:	f05a                	sd	s6,32(sp)
  4006ae:	ec5e                	sd	s7,24(sp)
  4006b0:	e862                	sd	s8,16(sp)
  4006b2:	e466                	sd	s9,8(sp)
  4006b4:	8b2a                	mv	s6,a0
  4006b6:	8a2e                	mv	s4,a1
  4006b8:	8bb2                	mv	s7,a2
  state = 0;
  4006ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  4006bc:	4901                	li	s2,0
  4006be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  4006c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  4006c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  4006c8:	06c00c93          	li	s9,108
  4006cc:	a00d                	j	4006ee <vprintf+0x5c>
        putc(fd, c0);
  4006ce:	85a6                	mv	a1,s1
  4006d0:	855a                	mv	a0,s6
  4006d2:	f0dff0ef          	jal	4005de <putc>
  4006d6:	a019                	j	4006dc <vprintf+0x4a>
    } else if(state == '%'){
  4006d8:	03598363          	beq	s3,s5,4006fe <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  4006dc:	0019079b          	addiw	a5,s2,1
  4006e0:	893e                	mv	s2,a5
  4006e2:	873e                	mv	a4,a5
  4006e4:	97d2                	add	a5,a5,s4
  4006e6:	0007c483          	lbu	s1,0(a5)
  4006ea:	20048963          	beqz	s1,4008fc <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  4006ee:	0004879b          	sext.w	a5,s1
    if(state == 0){
  4006f2:	fe0993e3          	bnez	s3,4006d8 <vprintf+0x46>
      if(c0 == '%'){
  4006f6:	fd579ce3          	bne	a5,s5,4006ce <vprintf+0x3c>
        state = '%';
  4006fa:	89be                	mv	s3,a5
  4006fc:	b7c5                	j	4006dc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  4006fe:	00ea06b3          	add	a3,s4,a4
  400702:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  400706:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  400708:	c681                	beqz	a3,400710 <vprintf+0x7e>
  40070a:	9752                	add	a4,a4,s4
  40070c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  400710:	03878e63          	beq	a5,s8,40074c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400714:	05978863          	beq	a5,s9,400764 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  400718:	07500713          	li	a4,117
  40071c:	0ee78263          	beq	a5,a4,400800 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400720:	07800713          	li	a4,120
  400724:	12e78463          	beq	a5,a4,40084c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400728:	07000713          	li	a4,112
  40072c:	14e78963          	beq	a5,a4,40087e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400730:	07300713          	li	a4,115
  400734:	18e78863          	beq	a5,a4,4008c4 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400738:	02500713          	li	a4,37
  40073c:	04e79463          	bne	a5,a4,400784 <vprintf+0xf2>
        putc(fd, '%');
  400740:	85ba                	mv	a1,a4
  400742:	855a                	mv	a0,s6
  400744:	e9bff0ef          	jal	4005de <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400748:	4981                	li	s3,0
  40074a:	bf49                	j	4006dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  40074c:	008b8493          	addi	s1,s7,8
  400750:	4685                	li	a3,1
  400752:	4629                	li	a2,10
  400754:	000ba583          	lw	a1,0(s7)
  400758:	855a                	mv	a0,s6
  40075a:	ea3ff0ef          	jal	4005fc <printint>
  40075e:	8ba6                	mv	s7,s1
      state = 0;
  400760:	4981                	li	s3,0
  400762:	bfad                	j	4006dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400764:	06400793          	li	a5,100
  400768:	02f68963          	beq	a3,a5,40079a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  40076c:	06c00793          	li	a5,108
  400770:	04f68263          	beq	a3,a5,4007b4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400774:	07500793          	li	a5,117
  400778:	0af68063          	beq	a3,a5,400818 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  40077c:	07800793          	li	a5,120
  400780:	0ef68263          	beq	a3,a5,400864 <vprintf+0x1d2>
        putc(fd, '%');
  400784:	02500593          	li	a1,37
  400788:	855a                	mv	a0,s6
  40078a:	e55ff0ef          	jal	4005de <putc>
        putc(fd, c0);
  40078e:	85a6                	mv	a1,s1
  400790:	855a                	mv	a0,s6
  400792:	e4dff0ef          	jal	4005de <putc>
      state = 0;
  400796:	4981                	li	s3,0
  400798:	b791                	j	4006dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  40079a:	008b8493          	addi	s1,s7,8
  40079e:	4685                	li	a3,1
  4007a0:	4629                	li	a2,10
  4007a2:	000ba583          	lw	a1,0(s7)
  4007a6:	855a                	mv	a0,s6
  4007a8:	e55ff0ef          	jal	4005fc <printint>
        i += 1;
  4007ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  4007ae:	8ba6                	mv	s7,s1
      state = 0;
  4007b0:	4981                	li	s3,0
        i += 1;
  4007b2:	b72d                	j	4006dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  4007b4:	06400793          	li	a5,100
  4007b8:	02f60763          	beq	a2,a5,4007e6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  4007bc:	07500793          	li	a5,117
  4007c0:	06f60963          	beq	a2,a5,400832 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  4007c4:	07800793          	li	a5,120
  4007c8:	faf61ee3          	bne	a2,a5,400784 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  4007cc:	008b8493          	addi	s1,s7,8
  4007d0:	4681                	li	a3,0
  4007d2:	4641                	li	a2,16
  4007d4:	000ba583          	lw	a1,0(s7)
  4007d8:	855a                	mv	a0,s6
  4007da:	e23ff0ef          	jal	4005fc <printint>
        i += 2;
  4007de:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  4007e0:	8ba6                	mv	s7,s1
      state = 0;
  4007e2:	4981                	li	s3,0
        i += 2;
  4007e4:	bde5                	j	4006dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  4007e6:	008b8493          	addi	s1,s7,8
  4007ea:	4685                	li	a3,1
  4007ec:	4629                	li	a2,10
  4007ee:	000ba583          	lw	a1,0(s7)
  4007f2:	855a                	mv	a0,s6
  4007f4:	e09ff0ef          	jal	4005fc <printint>
        i += 2;
  4007f8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  4007fa:	8ba6                	mv	s7,s1
      state = 0;
  4007fc:	4981                	li	s3,0
        i += 2;
  4007fe:	bdf9                	j	4006dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  400800:	008b8493          	addi	s1,s7,8
  400804:	4681                	li	a3,0
  400806:	4629                	li	a2,10
  400808:	000ba583          	lw	a1,0(s7)
  40080c:	855a                	mv	a0,s6
  40080e:	defff0ef          	jal	4005fc <printint>
  400812:	8ba6                	mv	s7,s1
      state = 0;
  400814:	4981                	li	s3,0
  400816:	b5d9                	j	4006dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400818:	008b8493          	addi	s1,s7,8
  40081c:	4681                	li	a3,0
  40081e:	4629                	li	a2,10
  400820:	000ba583          	lw	a1,0(s7)
  400824:	855a                	mv	a0,s6
  400826:	dd7ff0ef          	jal	4005fc <printint>
        i += 1;
  40082a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  40082c:	8ba6                	mv	s7,s1
      state = 0;
  40082e:	4981                	li	s3,0
        i += 1;
  400830:	b575                	j	4006dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400832:	008b8493          	addi	s1,s7,8
  400836:	4681                	li	a3,0
  400838:	4629                	li	a2,10
  40083a:	000ba583          	lw	a1,0(s7)
  40083e:	855a                	mv	a0,s6
  400840:	dbdff0ef          	jal	4005fc <printint>
        i += 2;
  400844:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400846:	8ba6                	mv	s7,s1
      state = 0;
  400848:	4981                	li	s3,0
        i += 2;
  40084a:	bd49                	j	4006dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  40084c:	008b8493          	addi	s1,s7,8
  400850:	4681                	li	a3,0
  400852:	4641                	li	a2,16
  400854:	000ba583          	lw	a1,0(s7)
  400858:	855a                	mv	a0,s6
  40085a:	da3ff0ef          	jal	4005fc <printint>
  40085e:	8ba6                	mv	s7,s1
      state = 0;
  400860:	4981                	li	s3,0
  400862:	bdad                	j	4006dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400864:	008b8493          	addi	s1,s7,8
  400868:	4681                	li	a3,0
  40086a:	4641                	li	a2,16
  40086c:	000ba583          	lw	a1,0(s7)
  400870:	855a                	mv	a0,s6
  400872:	d8bff0ef          	jal	4005fc <printint>
        i += 1;
  400876:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400878:	8ba6                	mv	s7,s1
      state = 0;
  40087a:	4981                	li	s3,0
        i += 1;
  40087c:	b585                	j	4006dc <vprintf+0x4a>
  40087e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  400880:	008b8d13          	addi	s10,s7,8
  400884:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400888:	03000593          	li	a1,48
  40088c:	855a                	mv	a0,s6
  40088e:	d51ff0ef          	jal	4005de <putc>
  putc(fd, 'x');
  400892:	07800593          	li	a1,120
  400896:	855a                	mv	a0,s6
  400898:	d47ff0ef          	jal	4005de <putc>
  40089c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  40089e:	00000b97          	auipc	s7,0x0
  4008a2:	2bab8b93          	addi	s7,s7,698 # 400b58 <digits>
  4008a6:	03c9d793          	srli	a5,s3,0x3c
  4008aa:	97de                	add	a5,a5,s7
  4008ac:	0007c583          	lbu	a1,0(a5)
  4008b0:	855a                	mv	a0,s6
  4008b2:	d2dff0ef          	jal	4005de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  4008b6:	0992                	slli	s3,s3,0x4
  4008b8:	34fd                	addiw	s1,s1,-1
  4008ba:	f4f5                	bnez	s1,4008a6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  4008bc:	8bea                	mv	s7,s10
      state = 0;
  4008be:	4981                	li	s3,0
  4008c0:	6d02                	ld	s10,0(sp)
  4008c2:	bd29                	j	4006dc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  4008c4:	008b8993          	addi	s3,s7,8
  4008c8:	000bb483          	ld	s1,0(s7)
  4008cc:	cc91                	beqz	s1,4008e8 <vprintf+0x256>
        for(; *s; s++)
  4008ce:	0004c583          	lbu	a1,0(s1)
  4008d2:	c195                	beqz	a1,4008f6 <vprintf+0x264>
          putc(fd, *s);
  4008d4:	855a                	mv	a0,s6
  4008d6:	d09ff0ef          	jal	4005de <putc>
        for(; *s; s++)
  4008da:	0485                	addi	s1,s1,1
  4008dc:	0004c583          	lbu	a1,0(s1)
  4008e0:	f9f5                	bnez	a1,4008d4 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4008e2:	8bce                	mv	s7,s3
      state = 0;
  4008e4:	4981                	li	s3,0
  4008e6:	bbdd                	j	4006dc <vprintf+0x4a>
          s = "(null)";
  4008e8:	00000497          	auipc	s1,0x0
  4008ec:	26848493          	addi	s1,s1,616 # 400b50 <malloc+0x154>
        for(; *s; s++)
  4008f0:	02800593          	li	a1,40
  4008f4:	b7c5                	j	4008d4 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4008f6:	8bce                	mv	s7,s3
      state = 0;
  4008f8:	4981                	li	s3,0
  4008fa:	b3cd                	j	4006dc <vprintf+0x4a>
  4008fc:	6906                	ld	s2,64(sp)
  4008fe:	79e2                	ld	s3,56(sp)
  400900:	7a42                	ld	s4,48(sp)
  400902:	7aa2                	ld	s5,40(sp)
  400904:	7b02                	ld	s6,32(sp)
  400906:	6be2                	ld	s7,24(sp)
  400908:	6c42                	ld	s8,16(sp)
  40090a:	6ca2                	ld	s9,8(sp)
    }
  }
}
  40090c:	60e6                	ld	ra,88(sp)
  40090e:	6446                	ld	s0,80(sp)
  400910:	64a6                	ld	s1,72(sp)
  400912:	6125                	addi	sp,sp,96
  400914:	8082                	ret

0000000000400916 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  400916:	715d                	addi	sp,sp,-80
  400918:	ec06                	sd	ra,24(sp)
  40091a:	e822                	sd	s0,16(sp)
  40091c:	1000                	addi	s0,sp,32
  40091e:	e010                	sd	a2,0(s0)
  400920:	e414                	sd	a3,8(s0)
  400922:	e818                	sd	a4,16(s0)
  400924:	ec1c                	sd	a5,24(s0)
  400926:	03043023          	sd	a6,32(s0)
  40092a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  40092e:	8622                	mv	a2,s0
  400930:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  400934:	d5fff0ef          	jal	400692 <vprintf>
  return 0;
}
  400938:	4501                	li	a0,0
  40093a:	60e2                	ld	ra,24(sp)
  40093c:	6442                	ld	s0,16(sp)
  40093e:	6161                	addi	sp,sp,80
  400940:	8082                	ret

0000000000400942 <printf>:

int
printf(const char *fmt, ...)
{
  400942:	711d                	addi	sp,sp,-96
  400944:	ec06                	sd	ra,24(sp)
  400946:	e822                	sd	s0,16(sp)
  400948:	1000                	addi	s0,sp,32
  40094a:	e40c                	sd	a1,8(s0)
  40094c:	e810                	sd	a2,16(s0)
  40094e:	ec14                	sd	a3,24(s0)
  400950:	f018                	sd	a4,32(s0)
  400952:	f41c                	sd	a5,40(s0)
  400954:	03043823          	sd	a6,48(s0)
  400958:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  40095c:	00840613          	addi	a2,s0,8
  400960:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  400964:	85aa                	mv	a1,a0
  400966:	4505                	li	a0,1
  400968:	d2bff0ef          	jal	400692 <vprintf>
  return 0;
}
  40096c:	4501                	li	a0,0
  40096e:	60e2                	ld	ra,24(sp)
  400970:	6442                	ld	s0,16(sp)
  400972:	6125                	addi	sp,sp,96
  400974:	8082                	ret

0000000000400976 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  400976:	1141                	addi	sp,sp,-16
  400978:	e406                	sd	ra,8(sp)
  40097a:	e022                	sd	s0,0(sp)
  40097c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  40097e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  400982:	00001797          	auipc	a5,0x1
  400986:	67e7b783          	ld	a5,1662(a5) # 402000 <freep>
  40098a:	a02d                	j	4009b4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  40098c:	4618                	lw	a4,8(a2)
  40098e:	9f2d                	addw	a4,a4,a1
  400990:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  400994:	6398                	ld	a4,0(a5)
  400996:	6310                	ld	a2,0(a4)
  400998:	a83d                	j	4009d6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  40099a:	ff852703          	lw	a4,-8(a0)
  40099e:	9f31                	addw	a4,a4,a2
  4009a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  4009a2:	ff053683          	ld	a3,-16(a0)
  4009a6:	a091                	j	4009ea <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4009a8:	6398                	ld	a4,0(a5)
  4009aa:	00e7e463          	bltu	a5,a4,4009b2 <free+0x3c>
  4009ae:	00e6ea63          	bltu	a3,a4,4009c2 <free+0x4c>
{
  4009b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4009b4:	fed7fae3          	bgeu	a5,a3,4009a8 <free+0x32>
  4009b8:	6398                	ld	a4,0(a5)
  4009ba:	00e6e463          	bltu	a3,a4,4009c2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4009be:	fee7eae3          	bltu	a5,a4,4009b2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4009c2:	ff852583          	lw	a1,-8(a0)
  4009c6:	6390                	ld	a2,0(a5)
  4009c8:	02059813          	slli	a6,a1,0x20
  4009cc:	01c85713          	srli	a4,a6,0x1c
  4009d0:	9736                	add	a4,a4,a3
  4009d2:	fae60de3          	beq	a2,a4,40098c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4009d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4009da:	4790                	lw	a2,8(a5)
  4009dc:	02061593          	slli	a1,a2,0x20
  4009e0:	01c5d713          	srli	a4,a1,0x1c
  4009e4:	973e                	add	a4,a4,a5
  4009e6:	fae68ae3          	beq	a3,a4,40099a <free+0x24>
    p->s.ptr = bp->s.ptr;
  4009ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4009ec:	00001717          	auipc	a4,0x1
  4009f0:	60f73a23          	sd	a5,1556(a4) # 402000 <freep>
}
  4009f4:	60a2                	ld	ra,8(sp)
  4009f6:	6402                	ld	s0,0(sp)
  4009f8:	0141                	addi	sp,sp,16
  4009fa:	8082                	ret

00000000004009fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4009fc:	7139                	addi	sp,sp,-64
  4009fe:	fc06                	sd	ra,56(sp)
  400a00:	f822                	sd	s0,48(sp)
  400a02:	f04a                	sd	s2,32(sp)
  400a04:	ec4e                	sd	s3,24(sp)
  400a06:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  400a08:	02051993          	slli	s3,a0,0x20
  400a0c:	0209d993          	srli	s3,s3,0x20
  400a10:	09bd                	addi	s3,s3,15
  400a12:	0049d993          	srli	s3,s3,0x4
  400a16:	2985                	addiw	s3,s3,1
  400a18:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  400a1a:	00001517          	auipc	a0,0x1
  400a1e:	5e653503          	ld	a0,1510(a0) # 402000 <freep>
  400a22:	c905                	beqz	a0,400a52 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400a24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400a26:	4798                	lw	a4,8(a5)
  400a28:	09377663          	bgeu	a4,s3,400ab4 <malloc+0xb8>
  400a2c:	f426                	sd	s1,40(sp)
  400a2e:	e852                	sd	s4,16(sp)
  400a30:	e456                	sd	s5,8(sp)
  400a32:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  400a34:	8a4e                	mv	s4,s3
  400a36:	6705                	lui	a4,0x1
  400a38:	00e9f363          	bgeu	s3,a4,400a3e <malloc+0x42>
  400a3c:	6a05                	lui	s4,0x1
  400a3e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  400a42:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  400a46:	00001497          	auipc	s1,0x1
  400a4a:	5ba48493          	addi	s1,s1,1466 # 402000 <freep>
  if(p == (char*)-1)
  400a4e:	5afd                	li	s5,-1
  400a50:	a83d                	j	400a8e <malloc+0x92>
  400a52:	f426                	sd	s1,40(sp)
  400a54:	e852                	sd	s4,16(sp)
  400a56:	e456                	sd	s5,8(sp)
  400a58:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  400a5a:	00001797          	auipc	a5,0x1
  400a5e:	5c678793          	addi	a5,a5,1478 # 402020 <base>
  400a62:	00001717          	auipc	a4,0x1
  400a66:	58f73f23          	sd	a5,1438(a4) # 402000 <freep>
  400a6a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  400a6c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  400a70:	b7d1                	j	400a34 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  400a72:	6398                	ld	a4,0(a5)
  400a74:	e118                	sd	a4,0(a0)
  400a76:	a899                	j	400acc <malloc+0xd0>
  hp->s.size = nu;
  400a78:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  400a7c:	0541                	addi	a0,a0,16
  400a7e:	ef9ff0ef          	jal	400976 <free>
  return freep;
  400a82:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  400a84:	c125                	beqz	a0,400ae4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  400a86:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  400a88:	4798                	lw	a4,8(a5)
  400a8a:	03277163          	bgeu	a4,s2,400aac <malloc+0xb0>
    if(p == freep)
  400a8e:	6098                	ld	a4,0(s1)
  400a90:	853e                	mv	a0,a5
  400a92:	fef71ae3          	bne	a4,a5,400a86 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  400a96:	8552                	mv	a0,s4
  400a98:	b17ff0ef          	jal	4005ae <sbrk>
  if(p == (char*)-1)
  400a9c:	fd551ee3          	bne	a0,s5,400a78 <malloc+0x7c>
        return 0;
  400aa0:	4501                	li	a0,0
  400aa2:	74a2                	ld	s1,40(sp)
  400aa4:	6a42                	ld	s4,16(sp)
  400aa6:	6aa2                	ld	s5,8(sp)
  400aa8:	6b02                	ld	s6,0(sp)
  400aaa:	a03d                	j	400ad8 <malloc+0xdc>
  400aac:	74a2                	ld	s1,40(sp)
  400aae:	6a42                	ld	s4,16(sp)
  400ab0:	6aa2                	ld	s5,8(sp)
  400ab2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  400ab4:	fae90fe3          	beq	s2,a4,400a72 <malloc+0x76>
        p->s.size -= nunits;
  400ab8:	4137073b          	subw	a4,a4,s3
  400abc:	c798                	sw	a4,8(a5)
        p += p->s.size;
  400abe:	02071693          	slli	a3,a4,0x20
  400ac2:	01c6d713          	srli	a4,a3,0x1c
  400ac6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  400ac8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  400acc:	00001717          	auipc	a4,0x1
  400ad0:	52a73a23          	sd	a0,1332(a4) # 402000 <freep>
      return (void*)(p + 1);
  400ad4:	01078513          	addi	a0,a5,16
  }
}
  400ad8:	70e2                	ld	ra,56(sp)
  400ada:	7442                	ld	s0,48(sp)
  400adc:	7902                	ld	s2,32(sp)
  400ade:	69e2                	ld	s3,24(sp)
  400ae0:	6121                	addi	sp,sp,64
  400ae2:	8082                	ret
  400ae4:	74a2                	ld	s1,40(sp)
  400ae6:	6a42                	ld	s4,16(sp)
  400ae8:	6aa2                	ld	s5,8(sp)
  400aea:	6b02                	ld	s6,0(sp)
  400aec:	b7f5                	j	400ad8 <malloc+0xdc>
