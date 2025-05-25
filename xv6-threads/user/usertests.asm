
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
  400000:	711d                	addi	sp,sp,-96
  400002:	ec86                	sd	ra,88(sp)
  400004:	e8a2                	sd	s0,80(sp)
  400006:	e4a6                	sd	s1,72(sp)
  400008:	e0ca                	sd	s2,64(sp)
  40000a:	fc4e                	sd	s3,56(sp)
  40000c:	f852                	sd	s4,48(sp)
  40000e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
  400010:	00007797          	auipc	a5,0x7
  400014:	65878793          	addi	a5,a5,1624 # 407668 <malloc+0x2490>
  400018:	638c                	ld	a1,0(a5)
  40001a:	6790                	ld	a2,8(a5)
  40001c:	6b94                	ld	a3,16(a5)
  40001e:	6f98                	ld	a4,24(a5)
  400020:	739c                	ld	a5,32(a5)
  400022:	fab43423          	sd	a1,-88(s0)
  400026:	fac43823          	sd	a2,-80(s0)
  40002a:	fad43c23          	sd	a3,-72(s0)
  40002e:	fce43023          	sd	a4,-64(s0)
  400032:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  400036:	fa840493          	addi	s1,s0,-88
  40003a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
  40003e:	20100993          	li	s3,513
  400042:	0004b903          	ld	s2,0(s1)
  400046:	85ce                	mv	a1,s3
  400048:	854a                	mv	a0,s2
  40004a:	4f9040ef          	jal	404d42 <open>
    if(fd >= 0){
  40004e:	00055d63          	bgez	a0,400068 <copyinstr1+0x68>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  400052:	04a1                	addi	s1,s1,8
  400054:	ff4497e3          	bne	s1,s4,400042 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
  400058:	60e6                	ld	ra,88(sp)
  40005a:	6446                	ld	s0,80(sp)
  40005c:	64a6                	ld	s1,72(sp)
  40005e:	6906                	ld	s2,64(sp)
  400060:	79e2                	ld	s3,56(sp)
  400062:	7a42                	ld	s4,48(sp)
  400064:	6125                	addi	sp,sp,96
  400066:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
  400068:	862a                	mv	a2,a0
  40006a:	85ca                	mv	a1,s2
  40006c:	00005517          	auipc	a0,0x5
  400070:	26450513          	addi	a0,a0,612 # 4052d0 <malloc+0xf8>
  400074:	0aa050ef          	jal	40511e <printf>
      exit(1);
  400078:	4505                	li	a0,1
  40007a:	489040ef          	jal	404d02 <exit>

000000000040007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
  40007e:	0000a797          	auipc	a5,0xa
  400082:	4ea78793          	addi	a5,a5,1258 # 40a568 <uninit>
  400086:	0000d697          	auipc	a3,0xd
  40008a:	bf268693          	addi	a3,a3,-1038 # 40cc78 <buf>
    if(uninit[i] != '\0'){
  40008e:	0007c703          	lbu	a4,0(a5)
  400092:	e709                	bnez	a4,40009c <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
  400094:	0785                	addi	a5,a5,1
  400096:	fed79ce3          	bne	a5,a3,40008e <bsstest+0x10>
  40009a:	8082                	ret
{
  40009c:	1141                	addi	sp,sp,-16
  40009e:	e406                	sd	ra,8(sp)
  4000a0:	e022                	sd	s0,0(sp)
  4000a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
  4000a4:	85aa                	mv	a1,a0
  4000a6:	00005517          	auipc	a0,0x5
  4000aa:	24a50513          	addi	a0,a0,586 # 4052f0 <malloc+0x118>
  4000ae:	070050ef          	jal	40511e <printf>
      exit(1);
  4000b2:	4505                	li	a0,1
  4000b4:	44f040ef          	jal	404d02 <exit>

00000000004000b8 <opentest>:
{
  4000b8:	1101                	addi	sp,sp,-32
  4000ba:	ec06                	sd	ra,24(sp)
  4000bc:	e822                	sd	s0,16(sp)
  4000be:	e426                	sd	s1,8(sp)
  4000c0:	1000                	addi	s0,sp,32
  4000c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
  4000c4:	4581                	li	a1,0
  4000c6:	00005517          	auipc	a0,0x5
  4000ca:	24250513          	addi	a0,a0,578 # 405308 <malloc+0x130>
  4000ce:	475040ef          	jal	404d42 <open>
  if(fd < 0){
  4000d2:	02054263          	bltz	a0,4000f6 <opentest+0x3e>
  close(fd);
  4000d6:	455040ef          	jal	404d2a <close>
  fd = open("doesnotexist", 0);
  4000da:	4581                	li	a1,0
  4000dc:	00005517          	auipc	a0,0x5
  4000e0:	24c50513          	addi	a0,a0,588 # 405328 <malloc+0x150>
  4000e4:	45f040ef          	jal	404d42 <open>
  if(fd >= 0){
  4000e8:	02055163          	bgez	a0,40010a <opentest+0x52>
}
  4000ec:	60e2                	ld	ra,24(sp)
  4000ee:	6442                	ld	s0,16(sp)
  4000f0:	64a2                	ld	s1,8(sp)
  4000f2:	6105                	addi	sp,sp,32
  4000f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
  4000f6:	85a6                	mv	a1,s1
  4000f8:	00005517          	auipc	a0,0x5
  4000fc:	21850513          	addi	a0,a0,536 # 405310 <malloc+0x138>
  400100:	01e050ef          	jal	40511e <printf>
    exit(1);
  400104:	4505                	li	a0,1
  400106:	3fd040ef          	jal	404d02 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
  40010a:	85a6                	mv	a1,s1
  40010c:	00005517          	auipc	a0,0x5
  400110:	22c50513          	addi	a0,a0,556 # 405338 <malloc+0x160>
  400114:	00a050ef          	jal	40511e <printf>
    exit(1);
  400118:	4505                	li	a0,1
  40011a:	3e9040ef          	jal	404d02 <exit>

000000000040011e <truncate2>:
{
  40011e:	7179                	addi	sp,sp,-48
  400120:	f406                	sd	ra,40(sp)
  400122:	f022                	sd	s0,32(sp)
  400124:	ec26                	sd	s1,24(sp)
  400126:	e84a                	sd	s2,16(sp)
  400128:	e44e                	sd	s3,8(sp)
  40012a:	1800                	addi	s0,sp,48
  40012c:	89aa                	mv	s3,a0
  unlink("truncfile");
  40012e:	00005517          	auipc	a0,0x5
  400132:	23250513          	addi	a0,a0,562 # 405360 <malloc+0x188>
  400136:	41d040ef          	jal	404d52 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
  40013a:	60100593          	li	a1,1537
  40013e:	00005517          	auipc	a0,0x5
  400142:	22250513          	addi	a0,a0,546 # 405360 <malloc+0x188>
  400146:	3fd040ef          	jal	404d42 <open>
  40014a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
  40014c:	4611                	li	a2,4
  40014e:	00005597          	auipc	a1,0x5
  400152:	22258593          	addi	a1,a1,546 # 405370 <malloc+0x198>
  400156:	3cd040ef          	jal	404d22 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
  40015a:	40100593          	li	a1,1025
  40015e:	00005517          	auipc	a0,0x5
  400162:	20250513          	addi	a0,a0,514 # 405360 <malloc+0x188>
  400166:	3dd040ef          	jal	404d42 <open>
  40016a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
  40016c:	4605                	li	a2,1
  40016e:	00005597          	auipc	a1,0x5
  400172:	20a58593          	addi	a1,a1,522 # 405378 <malloc+0x1a0>
  400176:	8526                	mv	a0,s1
  400178:	3ab040ef          	jal	404d22 <write>
  if(n != -1){
  40017c:	57fd                	li	a5,-1
  40017e:	02f51563          	bne	a0,a5,4001a8 <truncate2+0x8a>
  unlink("truncfile");
  400182:	00005517          	auipc	a0,0x5
  400186:	1de50513          	addi	a0,a0,478 # 405360 <malloc+0x188>
  40018a:	3c9040ef          	jal	404d52 <unlink>
  close(fd1);
  40018e:	8526                	mv	a0,s1
  400190:	39b040ef          	jal	404d2a <close>
  close(fd2);
  400194:	854a                	mv	a0,s2
  400196:	395040ef          	jal	404d2a <close>
}
  40019a:	70a2                	ld	ra,40(sp)
  40019c:	7402                	ld	s0,32(sp)
  40019e:	64e2                	ld	s1,24(sp)
  4001a0:	6942                	ld	s2,16(sp)
  4001a2:	69a2                	ld	s3,8(sp)
  4001a4:	6145                	addi	sp,sp,48
  4001a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
  4001a8:	862a                	mv	a2,a0
  4001aa:	85ce                	mv	a1,s3
  4001ac:	00005517          	auipc	a0,0x5
  4001b0:	1d450513          	addi	a0,a0,468 # 405380 <malloc+0x1a8>
  4001b4:	76b040ef          	jal	40511e <printf>
    exit(1);
  4001b8:	4505                	li	a0,1
  4001ba:	349040ef          	jal	404d02 <exit>

00000000004001be <createtest>:
{
  4001be:	7139                	addi	sp,sp,-64
  4001c0:	fc06                	sd	ra,56(sp)
  4001c2:	f822                	sd	s0,48(sp)
  4001c4:	f426                	sd	s1,40(sp)
  4001c6:	f04a                	sd	s2,32(sp)
  4001c8:	ec4e                	sd	s3,24(sp)
  4001ca:	e852                	sd	s4,16(sp)
  4001cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
  4001ce:	06100793          	li	a5,97
  4001d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
  4001d6:	fc040523          	sb	zero,-54(s0)
  4001da:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
  4001de:	fc840a13          	addi	s4,s0,-56
  4001e2:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
  4001e6:	06400913          	li	s2,100
    name[1] = '0' + i;
  4001ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
  4001ee:	85ce                	mv	a1,s3
  4001f0:	8552                	mv	a0,s4
  4001f2:	351040ef          	jal	404d42 <open>
    close(fd);
  4001f6:	335040ef          	jal	404d2a <close>
  for(i = 0; i < N; i++){
  4001fa:	2485                	addiw	s1,s1,1
  4001fc:	0ff4f493          	zext.b	s1,s1
  400200:	ff2495e3          	bne	s1,s2,4001ea <createtest+0x2c>
  name[0] = 'a';
  400204:	06100793          	li	a5,97
  400208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
  40020c:	fc040523          	sb	zero,-54(s0)
  400210:	03000493          	li	s1,48
    unlink(name);
  400214:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
  400218:	06400913          	li	s2,100
    name[1] = '0' + i;
  40021c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
  400220:	854e                	mv	a0,s3
  400222:	331040ef          	jal	404d52 <unlink>
  for(i = 0; i < N; i++){
  400226:	2485                	addiw	s1,s1,1
  400228:	0ff4f493          	zext.b	s1,s1
  40022c:	ff2498e3          	bne	s1,s2,40021c <createtest+0x5e>
}
  400230:	70e2                	ld	ra,56(sp)
  400232:	7442                	ld	s0,48(sp)
  400234:	74a2                	ld	s1,40(sp)
  400236:	7902                	ld	s2,32(sp)
  400238:	69e2                	ld	s3,24(sp)
  40023a:	6a42                	ld	s4,16(sp)
  40023c:	6121                	addi	sp,sp,64
  40023e:	8082                	ret

0000000000400240 <bigwrite>:
{
  400240:	715d                	addi	sp,sp,-80
  400242:	e486                	sd	ra,72(sp)
  400244:	e0a2                	sd	s0,64(sp)
  400246:	fc26                	sd	s1,56(sp)
  400248:	f84a                	sd	s2,48(sp)
  40024a:	f44e                	sd	s3,40(sp)
  40024c:	f052                	sd	s4,32(sp)
  40024e:	ec56                	sd	s5,24(sp)
  400250:	e85a                	sd	s6,16(sp)
  400252:	e45e                	sd	s7,8(sp)
  400254:	e062                	sd	s8,0(sp)
  400256:	0880                	addi	s0,sp,80
  400258:	8c2a                	mv	s8,a0
  unlink("bigwrite");
  40025a:	00005517          	auipc	a0,0x5
  40025e:	14e50513          	addi	a0,a0,334 # 4053a8 <malloc+0x1d0>
  400262:	2f1040ef          	jal	404d52 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
  400266:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
  40026a:	20200b93          	li	s7,514
  40026e:	00005a97          	auipc	s5,0x5
  400272:	13aa8a93          	addi	s5,s5,314 # 4053a8 <malloc+0x1d0>
      int cc = write(fd, buf, sz);
  400276:	0000da17          	auipc	s4,0xd
  40027a:	a02a0a13          	addi	s4,s4,-1534 # 40cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
  40027e:	6b0d                	lui	s6,0x3
  400280:	1c9b0b13          	addi	s6,s6,457 # 31c9 <copyinstr1-0x3fce37>
    fd = open("bigwrite", O_CREATE | O_RDWR);
  400284:	85de                	mv	a1,s7
  400286:	8556                	mv	a0,s5
  400288:	2bb040ef          	jal	404d42 <open>
  40028c:	892a                	mv	s2,a0
    if(fd < 0){
  40028e:	04054663          	bltz	a0,4002da <bigwrite+0x9a>
      int cc = write(fd, buf, sz);
  400292:	8626                	mv	a2,s1
  400294:	85d2                	mv	a1,s4
  400296:	28d040ef          	jal	404d22 <write>
  40029a:	89aa                	mv	s3,a0
      if(cc != sz){
  40029c:	04a49963          	bne	s1,a0,4002ee <bigwrite+0xae>
      int cc = write(fd, buf, sz);
  4002a0:	8626                	mv	a2,s1
  4002a2:	85d2                	mv	a1,s4
  4002a4:	854a                	mv	a0,s2
  4002a6:	27d040ef          	jal	404d22 <write>
      if(cc != sz){
  4002aa:	04951363          	bne	a0,s1,4002f0 <bigwrite+0xb0>
    close(fd);
  4002ae:	854a                	mv	a0,s2
  4002b0:	27b040ef          	jal	404d2a <close>
    unlink("bigwrite");
  4002b4:	8556                	mv	a0,s5
  4002b6:	29d040ef          	jal	404d52 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
  4002ba:	1d74849b          	addiw	s1,s1,471
  4002be:	fd6493e3          	bne	s1,s6,400284 <bigwrite+0x44>
}
  4002c2:	60a6                	ld	ra,72(sp)
  4002c4:	6406                	ld	s0,64(sp)
  4002c6:	74e2                	ld	s1,56(sp)
  4002c8:	7942                	ld	s2,48(sp)
  4002ca:	79a2                	ld	s3,40(sp)
  4002cc:	7a02                	ld	s4,32(sp)
  4002ce:	6ae2                	ld	s5,24(sp)
  4002d0:	6b42                	ld	s6,16(sp)
  4002d2:	6ba2                	ld	s7,8(sp)
  4002d4:	6c02                	ld	s8,0(sp)
  4002d6:	6161                	addi	sp,sp,80
  4002d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
  4002da:	85e2                	mv	a1,s8
  4002dc:	00005517          	auipc	a0,0x5
  4002e0:	0dc50513          	addi	a0,a0,220 # 4053b8 <malloc+0x1e0>
  4002e4:	63b040ef          	jal	40511e <printf>
      exit(1);
  4002e8:	4505                	li	a0,1
  4002ea:	219040ef          	jal	404d02 <exit>
      if(cc != sz){
  4002ee:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
  4002f0:	86aa                	mv	a3,a0
  4002f2:	864e                	mv	a2,s3
  4002f4:	85e2                	mv	a1,s8
  4002f6:	00005517          	auipc	a0,0x5
  4002fa:	0e250513          	addi	a0,a0,226 # 4053d8 <malloc+0x200>
  4002fe:	621040ef          	jal	40511e <printf>
        exit(1);
  400302:	4505                	li	a0,1
  400304:	1ff040ef          	jal	404d02 <exit>

0000000000400308 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
  400308:	7139                	addi	sp,sp,-64
  40030a:	fc06                	sd	ra,56(sp)
  40030c:	f822                	sd	s0,48(sp)
  40030e:	f426                	sd	s1,40(sp)
  400310:	f04a                	sd	s2,32(sp)
  400312:	ec4e                	sd	s3,24(sp)
  400314:	e852                	sd	s4,16(sp)
  400316:	e456                	sd	s5,8(sp)
  400318:	e05a                	sd	s6,0(sp)
  40031a:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
  40031c:	00005517          	auipc	a0,0x5
  400320:	0d450513          	addi	a0,a0,212 # 4053f0 <malloc+0x218>
  400324:	22f040ef          	jal	404d52 <unlink>
  400328:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
  40032c:	20100a93          	li	s5,513
  400330:	00005997          	auipc	s3,0x5
  400334:	0c098993          	addi	s3,s3,192 # 4053f0 <malloc+0x218>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
  400338:	4b05                	li	s6,1
  40033a:	5a7d                	li	s4,-1
  40033c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
  400340:	85d6                	mv	a1,s5
  400342:	854e                	mv	a0,s3
  400344:	1ff040ef          	jal	404d42 <open>
  400348:	84aa                	mv	s1,a0
    if(fd < 0){
  40034a:	04054d63          	bltz	a0,4003a4 <badwrite+0x9c>
    write(fd, (char*)0xffffffffffL, 1);
  40034e:	865a                	mv	a2,s6
  400350:	85d2                	mv	a1,s4
  400352:	1d1040ef          	jal	404d22 <write>
    close(fd);
  400356:	8526                	mv	a0,s1
  400358:	1d3040ef          	jal	404d2a <close>
    unlink("junk");
  40035c:	854e                	mv	a0,s3
  40035e:	1f5040ef          	jal	404d52 <unlink>
  for(int i = 0; i < assumed_free; i++){
  400362:	397d                	addiw	s2,s2,-1
  400364:	fc091ee3          	bnez	s2,400340 <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
  400368:	20100593          	li	a1,513
  40036c:	00005517          	auipc	a0,0x5
  400370:	08450513          	addi	a0,a0,132 # 4053f0 <malloc+0x218>
  400374:	1cf040ef          	jal	404d42 <open>
  400378:	84aa                	mv	s1,a0
  if(fd < 0){
  40037a:	02054e63          	bltz	a0,4003b6 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
  40037e:	4605                	li	a2,1
  400380:	00005597          	auipc	a1,0x5
  400384:	ff858593          	addi	a1,a1,-8 # 405378 <malloc+0x1a0>
  400388:	19b040ef          	jal	404d22 <write>
  40038c:	4785                	li	a5,1
  40038e:	02f50d63          	beq	a0,a5,4003c8 <badwrite+0xc0>
    printf("write failed\n");
  400392:	00005517          	auipc	a0,0x5
  400396:	07e50513          	addi	a0,a0,126 # 405410 <malloc+0x238>
  40039a:	585040ef          	jal	40511e <printf>
    exit(1);
  40039e:	4505                	li	a0,1
  4003a0:	163040ef          	jal	404d02 <exit>
      printf("open junk failed\n");
  4003a4:	00005517          	auipc	a0,0x5
  4003a8:	05450513          	addi	a0,a0,84 # 4053f8 <malloc+0x220>
  4003ac:	573040ef          	jal	40511e <printf>
      exit(1);
  4003b0:	4505                	li	a0,1
  4003b2:	151040ef          	jal	404d02 <exit>
    printf("open junk failed\n");
  4003b6:	00005517          	auipc	a0,0x5
  4003ba:	04250513          	addi	a0,a0,66 # 4053f8 <malloc+0x220>
  4003be:	561040ef          	jal	40511e <printf>
    exit(1);
  4003c2:	4505                	li	a0,1
  4003c4:	13f040ef          	jal	404d02 <exit>
  }
  close(fd);
  4003c8:	8526                	mv	a0,s1
  4003ca:	161040ef          	jal	404d2a <close>
  unlink("junk");
  4003ce:	00005517          	auipc	a0,0x5
  4003d2:	02250513          	addi	a0,a0,34 # 4053f0 <malloc+0x218>
  4003d6:	17d040ef          	jal	404d52 <unlink>

  exit(0);
  4003da:	4501                	li	a0,0
  4003dc:	127040ef          	jal	404d02 <exit>

00000000004003e0 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
  4003e0:	711d                	addi	sp,sp,-96
  4003e2:	ec86                	sd	ra,88(sp)
  4003e4:	e8a2                	sd	s0,80(sp)
  4003e6:	e4a6                	sd	s1,72(sp)
  4003e8:	e0ca                	sd	s2,64(sp)
  4003ea:	fc4e                	sd	s3,56(sp)
  4003ec:	f852                	sd	s4,48(sp)
  4003ee:	f456                	sd	s5,40(sp)
  4003f0:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
  4003f2:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
  4003f4:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
  4003f8:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
  4003fc:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
  400400:	40000a93          	li	s5,1024
    name[0] = 'z';
  400404:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
  400408:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
  40040c:	41f4d71b          	sraiw	a4,s1,0x1f
  400410:	01b7571b          	srliw	a4,a4,0x1b
  400414:	009707bb          	addw	a5,a4,s1
  400418:	4057d69b          	sraiw	a3,a5,0x5
  40041c:	0306869b          	addiw	a3,a3,48
  400420:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
  400424:	8bfd                	andi	a5,a5,31
  400426:	9f99                	subw	a5,a5,a4
  400428:	0307879b          	addiw	a5,a5,48
  40042c:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
  400430:	fa040223          	sb	zero,-92(s0)
    unlink(name);
  400434:	854a                	mv	a0,s2
  400436:	11d040ef          	jal	404d52 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
  40043a:	85d2                	mv	a1,s4
  40043c:	854a                	mv	a0,s2
  40043e:	105040ef          	jal	404d42 <open>
    if(fd < 0){
  400442:	00054763          	bltz	a0,400450 <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
  400446:	0e5040ef          	jal	404d2a <close>
  for(int i = 0; i < nzz; i++){
  40044a:	2485                	addiw	s1,s1,1
  40044c:	fb549ce3          	bne	s1,s5,400404 <outofinodes+0x24>
  400450:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
  400452:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
  400456:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
  40045a:	40000993          	li	s3,1024
    name[0] = 'z';
  40045e:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
  400462:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
  400466:	41f4d71b          	sraiw	a4,s1,0x1f
  40046a:	01b7571b          	srliw	a4,a4,0x1b
  40046e:	009707bb          	addw	a5,a4,s1
  400472:	4057d69b          	sraiw	a3,a5,0x5
  400476:	0306869b          	addiw	a3,a3,48
  40047a:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
  40047e:	8bfd                	andi	a5,a5,31
  400480:	9f99                	subw	a5,a5,a4
  400482:	0307879b          	addiw	a5,a5,48
  400486:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
  40048a:	fa040223          	sb	zero,-92(s0)
    unlink(name);
  40048e:	8552                	mv	a0,s4
  400490:	0c3040ef          	jal	404d52 <unlink>
  for(int i = 0; i < nzz; i++){
  400494:	2485                	addiw	s1,s1,1
  400496:	fd3494e3          	bne	s1,s3,40045e <outofinodes+0x7e>
  }
}
  40049a:	60e6                	ld	ra,88(sp)
  40049c:	6446                	ld	s0,80(sp)
  40049e:	64a6                	ld	s1,72(sp)
  4004a0:	6906                	ld	s2,64(sp)
  4004a2:	79e2                	ld	s3,56(sp)
  4004a4:	7a42                	ld	s4,48(sp)
  4004a6:	7aa2                	ld	s5,40(sp)
  4004a8:	6125                	addi	sp,sp,96
  4004aa:	8082                	ret

00000000004004ac <copyin>:
{
  4004ac:	7175                	addi	sp,sp,-144
  4004ae:	e506                	sd	ra,136(sp)
  4004b0:	e122                	sd	s0,128(sp)
  4004b2:	fca6                	sd	s1,120(sp)
  4004b4:	f8ca                	sd	s2,112(sp)
  4004b6:	f4ce                	sd	s3,104(sp)
  4004b8:	f0d2                	sd	s4,96(sp)
  4004ba:	ecd6                	sd	s5,88(sp)
  4004bc:	e8da                	sd	s6,80(sp)
  4004be:	e4de                	sd	s7,72(sp)
  4004c0:	e0e2                	sd	s8,64(sp)
  4004c2:	fc66                	sd	s9,56(sp)
  4004c4:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
  4004c6:	00007797          	auipc	a5,0x7
  4004ca:	1a278793          	addi	a5,a5,418 # 407668 <malloc+0x2490>
  4004ce:	638c                	ld	a1,0(a5)
  4004d0:	6790                	ld	a2,8(a5)
  4004d2:	6b94                	ld	a3,16(a5)
  4004d4:	6f98                	ld	a4,24(a5)
  4004d6:	739c                	ld	a5,32(a5)
  4004d8:	f6b43c23          	sd	a1,-136(s0)
  4004dc:	f8c43023          	sd	a2,-128(s0)
  4004e0:	f8d43423          	sd	a3,-120(s0)
  4004e4:	f8e43823          	sd	a4,-112(s0)
  4004e8:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  4004ec:	f7840913          	addi	s2,s0,-136
  4004f0:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
  4004f4:	20100b13          	li	s6,513
  4004f8:	00005a97          	auipc	s5,0x5
  4004fc:	f28a8a93          	addi	s5,s5,-216 # 405420 <malloc+0x248>
    int n = write(fd, (void*)addr, 8192);
  400500:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
  400502:	4c05                	li	s8,1
    if(pipe(fds) < 0){
  400504:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
  400508:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
  40050c:	85da                	mv	a1,s6
  40050e:	8556                	mv	a0,s5
  400510:	033040ef          	jal	404d42 <open>
  400514:	84aa                	mv	s1,a0
    if(fd < 0){
  400516:	06054a63          	bltz	a0,40058a <copyin+0xde>
    int n = write(fd, (void*)addr, 8192);
  40051a:	8652                	mv	a2,s4
  40051c:	85ce                	mv	a1,s3
  40051e:	005040ef          	jal	404d22 <write>
    if(n >= 0){
  400522:	06055d63          	bgez	a0,40059c <copyin+0xf0>
    close(fd);
  400526:	8526                	mv	a0,s1
  400528:	003040ef          	jal	404d2a <close>
    unlink("copyin1");
  40052c:	8556                	mv	a0,s5
  40052e:	025040ef          	jal	404d52 <unlink>
    n = write(1, (char*)addr, 8192);
  400532:	8652                	mv	a2,s4
  400534:	85ce                	mv	a1,s3
  400536:	8562                	mv	a0,s8
  400538:	7ea040ef          	jal	404d22 <write>
    if(n > 0){
  40053c:	06a04b63          	bgtz	a0,4005b2 <copyin+0x106>
    if(pipe(fds) < 0){
  400540:	855e                	mv	a0,s7
  400542:	7d0040ef          	jal	404d12 <pipe>
  400546:	08054163          	bltz	a0,4005c8 <copyin+0x11c>
    n = write(fds[1], (char*)addr, 8192);
  40054a:	8652                	mv	a2,s4
  40054c:	85ce                	mv	a1,s3
  40054e:	f7442503          	lw	a0,-140(s0)
  400552:	7d0040ef          	jal	404d22 <write>
    if(n > 0){
  400556:	08a04263          	bgtz	a0,4005da <copyin+0x12e>
    close(fds[0]);
  40055a:	f7042503          	lw	a0,-144(s0)
  40055e:	7cc040ef          	jal	404d2a <close>
    close(fds[1]);
  400562:	f7442503          	lw	a0,-140(s0)
  400566:	7c4040ef          	jal	404d2a <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  40056a:	0921                	addi	s2,s2,8
  40056c:	f9991ee3          	bne	s2,s9,400508 <copyin+0x5c>
}
  400570:	60aa                	ld	ra,136(sp)
  400572:	640a                	ld	s0,128(sp)
  400574:	74e6                	ld	s1,120(sp)
  400576:	7946                	ld	s2,112(sp)
  400578:	79a6                	ld	s3,104(sp)
  40057a:	7a06                	ld	s4,96(sp)
  40057c:	6ae6                	ld	s5,88(sp)
  40057e:	6b46                	ld	s6,80(sp)
  400580:	6ba6                	ld	s7,72(sp)
  400582:	6c06                	ld	s8,64(sp)
  400584:	7ce2                	ld	s9,56(sp)
  400586:	6149                	addi	sp,sp,144
  400588:	8082                	ret
      printf("open(copyin1) failed\n");
  40058a:	00005517          	auipc	a0,0x5
  40058e:	e9e50513          	addi	a0,a0,-354 # 405428 <malloc+0x250>
  400592:	38d040ef          	jal	40511e <printf>
      exit(1);
  400596:	4505                	li	a0,1
  400598:	76a040ef          	jal	404d02 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
  40059c:	862a                	mv	a2,a0
  40059e:	85ce                	mv	a1,s3
  4005a0:	00005517          	auipc	a0,0x5
  4005a4:	ea050513          	addi	a0,a0,-352 # 405440 <malloc+0x268>
  4005a8:	377040ef          	jal	40511e <printf>
      exit(1);
  4005ac:	4505                	li	a0,1
  4005ae:	754040ef          	jal	404d02 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
  4005b2:	862a                	mv	a2,a0
  4005b4:	85ce                	mv	a1,s3
  4005b6:	00005517          	auipc	a0,0x5
  4005ba:	eba50513          	addi	a0,a0,-326 # 405470 <malloc+0x298>
  4005be:	361040ef          	jal	40511e <printf>
      exit(1);
  4005c2:	4505                	li	a0,1
  4005c4:	73e040ef          	jal	404d02 <exit>
      printf("pipe() failed\n");
  4005c8:	00005517          	auipc	a0,0x5
  4005cc:	ed850513          	addi	a0,a0,-296 # 4054a0 <malloc+0x2c8>
  4005d0:	34f040ef          	jal	40511e <printf>
      exit(1);
  4005d4:	4505                	li	a0,1
  4005d6:	72c040ef          	jal	404d02 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
  4005da:	862a                	mv	a2,a0
  4005dc:	85ce                	mv	a1,s3
  4005de:	00005517          	auipc	a0,0x5
  4005e2:	ed250513          	addi	a0,a0,-302 # 4054b0 <malloc+0x2d8>
  4005e6:	339040ef          	jal	40511e <printf>
      exit(1);
  4005ea:	4505                	li	a0,1
  4005ec:	716040ef          	jal	404d02 <exit>

00000000004005f0 <copyout>:
{
  4005f0:	7135                	addi	sp,sp,-160
  4005f2:	ed06                	sd	ra,152(sp)
  4005f4:	e922                	sd	s0,144(sp)
  4005f6:	e526                	sd	s1,136(sp)
  4005f8:	e14a                	sd	s2,128(sp)
  4005fa:	fcce                	sd	s3,120(sp)
  4005fc:	f8d2                	sd	s4,112(sp)
  4005fe:	f4d6                	sd	s5,104(sp)
  400600:	f0da                	sd	s6,96(sp)
  400602:	ecde                	sd	s7,88(sp)
  400604:	e8e2                	sd	s8,80(sp)
  400606:	e4e6                	sd	s9,72(sp)
  400608:	1100                	addi	s0,sp,160
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
  40060a:	00007797          	auipc	a5,0x7
  40060e:	05e78793          	addi	a5,a5,94 # 407668 <malloc+0x2490>
  400612:	7788                	ld	a0,40(a5)
  400614:	7b8c                	ld	a1,48(a5)
  400616:	7f90                	ld	a2,56(a5)
  400618:	63b4                	ld	a3,64(a5)
  40061a:	67b8                	ld	a4,72(a5)
  40061c:	6bbc                	ld	a5,80(a5)
  40061e:	f6a43823          	sd	a0,-144(s0)
  400622:	f6b43c23          	sd	a1,-136(s0)
  400626:	f8c43023          	sd	a2,-128(s0)
  40062a:	f8d43423          	sd	a3,-120(s0)
  40062e:	f8e43823          	sd	a4,-112(s0)
  400632:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  400636:	f7040913          	addi	s2,s0,-144
  40063a:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
  40063e:	00005b17          	auipc	s6,0x5
  400642:	ea2b0b13          	addi	s6,s6,-350 # 4054e0 <malloc+0x308>
    int n = read(fd, (void*)addr, 8192);
  400646:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
  400648:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
  40064c:	4a05                	li	s4,1
  40064e:	00005b97          	auipc	s7,0x5
  400652:	d2ab8b93          	addi	s7,s7,-726 # 405378 <malloc+0x1a0>
    uint64 addr = addrs[ai];
  400656:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
  40065a:	4581                	li	a1,0
  40065c:	855a                	mv	a0,s6
  40065e:	6e4040ef          	jal	404d42 <open>
  400662:	84aa                	mv	s1,a0
    if(fd < 0){
  400664:	06054863          	bltz	a0,4006d4 <copyout+0xe4>
    int n = read(fd, (void*)addr, 8192);
  400668:	8656                	mv	a2,s5
  40066a:	85ce                	mv	a1,s3
  40066c:	6ae040ef          	jal	404d1a <read>
    if(n > 0){
  400670:	06a04b63          	bgtz	a0,4006e6 <copyout+0xf6>
    close(fd);
  400674:	8526                	mv	a0,s1
  400676:	6b4040ef          	jal	404d2a <close>
    if(pipe(fds) < 0){
  40067a:	8562                	mv	a0,s8
  40067c:	696040ef          	jal	404d12 <pipe>
  400680:	06054e63          	bltz	a0,4006fc <copyout+0x10c>
    n = write(fds[1], "x", 1);
  400684:	8652                	mv	a2,s4
  400686:	85de                	mv	a1,s7
  400688:	f6c42503          	lw	a0,-148(s0)
  40068c:	696040ef          	jal	404d22 <write>
    if(n != 1){
  400690:	07451f63          	bne	a0,s4,40070e <copyout+0x11e>
    n = read(fds[0], (void*)addr, 8192);
  400694:	8656                	mv	a2,s5
  400696:	85ce                	mv	a1,s3
  400698:	f6842503          	lw	a0,-152(s0)
  40069c:	67e040ef          	jal	404d1a <read>
    if(n > 0){
  4006a0:	08a04063          	bgtz	a0,400720 <copyout+0x130>
    close(fds[0]);
  4006a4:	f6842503          	lw	a0,-152(s0)
  4006a8:	682040ef          	jal	404d2a <close>
    close(fds[1]);
  4006ac:	f6c42503          	lw	a0,-148(s0)
  4006b0:	67a040ef          	jal	404d2a <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  4006b4:	0921                	addi	s2,s2,8
  4006b6:	fb9910e3          	bne	s2,s9,400656 <copyout+0x66>
}
  4006ba:	60ea                	ld	ra,152(sp)
  4006bc:	644a                	ld	s0,144(sp)
  4006be:	64aa                	ld	s1,136(sp)
  4006c0:	690a                	ld	s2,128(sp)
  4006c2:	79e6                	ld	s3,120(sp)
  4006c4:	7a46                	ld	s4,112(sp)
  4006c6:	7aa6                	ld	s5,104(sp)
  4006c8:	7b06                	ld	s6,96(sp)
  4006ca:	6be6                	ld	s7,88(sp)
  4006cc:	6c46                	ld	s8,80(sp)
  4006ce:	6ca6                	ld	s9,72(sp)
  4006d0:	610d                	addi	sp,sp,160
  4006d2:	8082                	ret
      printf("open(README) failed\n");
  4006d4:	00005517          	auipc	a0,0x5
  4006d8:	e1450513          	addi	a0,a0,-492 # 4054e8 <malloc+0x310>
  4006dc:	243040ef          	jal	40511e <printf>
      exit(1);
  4006e0:	4505                	li	a0,1
  4006e2:	620040ef          	jal	404d02 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
  4006e6:	862a                	mv	a2,a0
  4006e8:	85ce                	mv	a1,s3
  4006ea:	00005517          	auipc	a0,0x5
  4006ee:	e1650513          	addi	a0,a0,-490 # 405500 <malloc+0x328>
  4006f2:	22d040ef          	jal	40511e <printf>
      exit(1);
  4006f6:	4505                	li	a0,1
  4006f8:	60a040ef          	jal	404d02 <exit>
      printf("pipe() failed\n");
  4006fc:	00005517          	auipc	a0,0x5
  400700:	da450513          	addi	a0,a0,-604 # 4054a0 <malloc+0x2c8>
  400704:	21b040ef          	jal	40511e <printf>
      exit(1);
  400708:	4505                	li	a0,1
  40070a:	5f8040ef          	jal	404d02 <exit>
      printf("pipe write failed\n");
  40070e:	00005517          	auipc	a0,0x5
  400712:	e2250513          	addi	a0,a0,-478 # 405530 <malloc+0x358>
  400716:	209040ef          	jal	40511e <printf>
      exit(1);
  40071a:	4505                	li	a0,1
  40071c:	5e6040ef          	jal	404d02 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
  400720:	862a                	mv	a2,a0
  400722:	85ce                	mv	a1,s3
  400724:	00005517          	auipc	a0,0x5
  400728:	e2450513          	addi	a0,a0,-476 # 405548 <malloc+0x370>
  40072c:	1f3040ef          	jal	40511e <printf>
      exit(1);
  400730:	4505                	li	a0,1
  400732:	5d0040ef          	jal	404d02 <exit>

0000000000400736 <truncate1>:
{
  400736:	711d                	addi	sp,sp,-96
  400738:	ec86                	sd	ra,88(sp)
  40073a:	e8a2                	sd	s0,80(sp)
  40073c:	e4a6                	sd	s1,72(sp)
  40073e:	e0ca                	sd	s2,64(sp)
  400740:	fc4e                	sd	s3,56(sp)
  400742:	f852                	sd	s4,48(sp)
  400744:	f456                	sd	s5,40(sp)
  400746:	1080                	addi	s0,sp,96
  400748:	8aaa                	mv	s5,a0
  unlink("truncfile");
  40074a:	00005517          	auipc	a0,0x5
  40074e:	c1650513          	addi	a0,a0,-1002 # 405360 <malloc+0x188>
  400752:	600040ef          	jal	404d52 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
  400756:	60100593          	li	a1,1537
  40075a:	00005517          	auipc	a0,0x5
  40075e:	c0650513          	addi	a0,a0,-1018 # 405360 <malloc+0x188>
  400762:	5e0040ef          	jal	404d42 <open>
  400766:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
  400768:	4611                	li	a2,4
  40076a:	00005597          	auipc	a1,0x5
  40076e:	c0658593          	addi	a1,a1,-1018 # 405370 <malloc+0x198>
  400772:	5b0040ef          	jal	404d22 <write>
  close(fd1);
  400776:	8526                	mv	a0,s1
  400778:	5b2040ef          	jal	404d2a <close>
  int fd2 = open("truncfile", O_RDONLY);
  40077c:	4581                	li	a1,0
  40077e:	00005517          	auipc	a0,0x5
  400782:	be250513          	addi	a0,a0,-1054 # 405360 <malloc+0x188>
  400786:	5bc040ef          	jal	404d42 <open>
  40078a:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
  40078c:	02000613          	li	a2,32
  400790:	fa040593          	addi	a1,s0,-96
  400794:	586040ef          	jal	404d1a <read>
  if(n != 4){
  400798:	4791                	li	a5,4
  40079a:	0af51863          	bne	a0,a5,40084a <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
  40079e:	40100593          	li	a1,1025
  4007a2:	00005517          	auipc	a0,0x5
  4007a6:	bbe50513          	addi	a0,a0,-1090 # 405360 <malloc+0x188>
  4007aa:	598040ef          	jal	404d42 <open>
  4007ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
  4007b0:	4581                	li	a1,0
  4007b2:	00005517          	auipc	a0,0x5
  4007b6:	bae50513          	addi	a0,a0,-1106 # 405360 <malloc+0x188>
  4007ba:	588040ef          	jal	404d42 <open>
  4007be:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
  4007c0:	02000613          	li	a2,32
  4007c4:	fa040593          	addi	a1,s0,-96
  4007c8:	552040ef          	jal	404d1a <read>
  4007cc:	8a2a                	mv	s4,a0
  if(n != 0){
  4007ce:	e949                	bnez	a0,400860 <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
  4007d0:	02000613          	li	a2,32
  4007d4:	fa040593          	addi	a1,s0,-96
  4007d8:	8526                	mv	a0,s1
  4007da:	540040ef          	jal	404d1a <read>
  4007de:	8a2a                	mv	s4,a0
  if(n != 0){
  4007e0:	e155                	bnez	a0,400884 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
  4007e2:	4619                	li	a2,6
  4007e4:	00005597          	auipc	a1,0x5
  4007e8:	df458593          	addi	a1,a1,-524 # 4055d8 <malloc+0x400>
  4007ec:	854e                	mv	a0,s3
  4007ee:	534040ef          	jal	404d22 <write>
  n = read(fd3, buf, sizeof(buf));
  4007f2:	02000613          	li	a2,32
  4007f6:	fa040593          	addi	a1,s0,-96
  4007fa:	854a                	mv	a0,s2
  4007fc:	51e040ef          	jal	404d1a <read>
  if(n != 6){
  400800:	4799                	li	a5,6
  400802:	0af51363          	bne	a0,a5,4008a8 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
  400806:	02000613          	li	a2,32
  40080a:	fa040593          	addi	a1,s0,-96
  40080e:	8526                	mv	a0,s1
  400810:	50a040ef          	jal	404d1a <read>
  if(n != 2){
  400814:	4789                	li	a5,2
  400816:	0af51463          	bne	a0,a5,4008be <truncate1+0x188>
  unlink("truncfile");
  40081a:	00005517          	auipc	a0,0x5
  40081e:	b4650513          	addi	a0,a0,-1210 # 405360 <malloc+0x188>
  400822:	530040ef          	jal	404d52 <unlink>
  close(fd1);
  400826:	854e                	mv	a0,s3
  400828:	502040ef          	jal	404d2a <close>
  close(fd2);
  40082c:	8526                	mv	a0,s1
  40082e:	4fc040ef          	jal	404d2a <close>
  close(fd3);
  400832:	854a                	mv	a0,s2
  400834:	4f6040ef          	jal	404d2a <close>
}
  400838:	60e6                	ld	ra,88(sp)
  40083a:	6446                	ld	s0,80(sp)
  40083c:	64a6                	ld	s1,72(sp)
  40083e:	6906                	ld	s2,64(sp)
  400840:	79e2                	ld	s3,56(sp)
  400842:	7a42                	ld	s4,48(sp)
  400844:	7aa2                	ld	s5,40(sp)
  400846:	6125                	addi	sp,sp,96
  400848:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
  40084a:	862a                	mv	a2,a0
  40084c:	85d6                	mv	a1,s5
  40084e:	00005517          	auipc	a0,0x5
  400852:	d2a50513          	addi	a0,a0,-726 # 405578 <malloc+0x3a0>
  400856:	0c9040ef          	jal	40511e <printf>
    exit(1);
  40085a:	4505                	li	a0,1
  40085c:	4a6040ef          	jal	404d02 <exit>
    printf("aaa fd3=%d\n", fd3);
  400860:	85ca                	mv	a1,s2
  400862:	00005517          	auipc	a0,0x5
  400866:	d3650513          	addi	a0,a0,-714 # 405598 <malloc+0x3c0>
  40086a:	0b5040ef          	jal	40511e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
  40086e:	8652                	mv	a2,s4
  400870:	85d6                	mv	a1,s5
  400872:	00005517          	auipc	a0,0x5
  400876:	d3650513          	addi	a0,a0,-714 # 4055a8 <malloc+0x3d0>
  40087a:	0a5040ef          	jal	40511e <printf>
    exit(1);
  40087e:	4505                	li	a0,1
  400880:	482040ef          	jal	404d02 <exit>
    printf("bbb fd2=%d\n", fd2);
  400884:	85a6                	mv	a1,s1
  400886:	00005517          	auipc	a0,0x5
  40088a:	d4250513          	addi	a0,a0,-702 # 4055c8 <malloc+0x3f0>
  40088e:	091040ef          	jal	40511e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
  400892:	8652                	mv	a2,s4
  400894:	85d6                	mv	a1,s5
  400896:	00005517          	auipc	a0,0x5
  40089a:	d1250513          	addi	a0,a0,-750 # 4055a8 <malloc+0x3d0>
  40089e:	081040ef          	jal	40511e <printf>
    exit(1);
  4008a2:	4505                	li	a0,1
  4008a4:	45e040ef          	jal	404d02 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
  4008a8:	862a                	mv	a2,a0
  4008aa:	85d6                	mv	a1,s5
  4008ac:	00005517          	auipc	a0,0x5
  4008b0:	d3450513          	addi	a0,a0,-716 # 4055e0 <malloc+0x408>
  4008b4:	06b040ef          	jal	40511e <printf>
    exit(1);
  4008b8:	4505                	li	a0,1
  4008ba:	448040ef          	jal	404d02 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
  4008be:	862a                	mv	a2,a0
  4008c0:	85d6                	mv	a1,s5
  4008c2:	00005517          	auipc	a0,0x5
  4008c6:	d3e50513          	addi	a0,a0,-706 # 405600 <malloc+0x428>
  4008ca:	055040ef          	jal	40511e <printf>
    exit(1);
  4008ce:	4505                	li	a0,1
  4008d0:	432040ef          	jal	404d02 <exit>

00000000004008d4 <writetest>:
{
  4008d4:	715d                	addi	sp,sp,-80
  4008d6:	e486                	sd	ra,72(sp)
  4008d8:	e0a2                	sd	s0,64(sp)
  4008da:	fc26                	sd	s1,56(sp)
  4008dc:	f84a                	sd	s2,48(sp)
  4008de:	f44e                	sd	s3,40(sp)
  4008e0:	f052                	sd	s4,32(sp)
  4008e2:	ec56                	sd	s5,24(sp)
  4008e4:	e85a                	sd	s6,16(sp)
  4008e6:	e45e                	sd	s7,8(sp)
  4008e8:	0880                	addi	s0,sp,80
  4008ea:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
  4008ec:	20200593          	li	a1,514
  4008f0:	00005517          	auipc	a0,0x5
  4008f4:	d3050513          	addi	a0,a0,-720 # 405620 <malloc+0x448>
  4008f8:	44a040ef          	jal	404d42 <open>
  if(fd < 0){
  4008fc:	08054f63          	bltz	a0,40099a <writetest+0xc6>
  400900:	89aa                	mv	s3,a0
  400902:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
  400904:	44a9                	li	s1,10
  400906:	00005a17          	auipc	s4,0x5
  40090a:	d42a0a13          	addi	s4,s4,-702 # 405648 <malloc+0x470>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
  40090e:	00005b17          	auipc	s6,0x5
  400912:	d72b0b13          	addi	s6,s6,-654 # 405680 <malloc+0x4a8>
  for(i = 0; i < N; i++){
  400916:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
  40091a:	8626                	mv	a2,s1
  40091c:	85d2                	mv	a1,s4
  40091e:	854e                	mv	a0,s3
  400920:	402040ef          	jal	404d22 <write>
  400924:	08951563          	bne	a0,s1,4009ae <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
  400928:	8626                	mv	a2,s1
  40092a:	85da                	mv	a1,s6
  40092c:	854e                	mv	a0,s3
  40092e:	3f4040ef          	jal	404d22 <write>
  400932:	08951963          	bne	a0,s1,4009c4 <writetest+0xf0>
  for(i = 0; i < N; i++){
  400936:	2905                	addiw	s2,s2,1
  400938:	ff5911e3          	bne	s2,s5,40091a <writetest+0x46>
  close(fd);
  40093c:	854e                	mv	a0,s3
  40093e:	3ec040ef          	jal	404d2a <close>
  fd = open("small", O_RDONLY);
  400942:	4581                	li	a1,0
  400944:	00005517          	auipc	a0,0x5
  400948:	cdc50513          	addi	a0,a0,-804 # 405620 <malloc+0x448>
  40094c:	3f6040ef          	jal	404d42 <open>
  400950:	84aa                	mv	s1,a0
  if(fd < 0){
  400952:	08054463          	bltz	a0,4009da <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
  400956:	7d000613          	li	a2,2000
  40095a:	0000c597          	auipc	a1,0xc
  40095e:	31e58593          	addi	a1,a1,798 # 40cc78 <buf>
  400962:	3b8040ef          	jal	404d1a <read>
  if(i != N*SZ*2){
  400966:	7d000793          	li	a5,2000
  40096a:	08f51263          	bne	a0,a5,4009ee <writetest+0x11a>
  close(fd);
  40096e:	8526                	mv	a0,s1
  400970:	3ba040ef          	jal	404d2a <close>
  if(unlink("small") < 0){
  400974:	00005517          	auipc	a0,0x5
  400978:	cac50513          	addi	a0,a0,-852 # 405620 <malloc+0x448>
  40097c:	3d6040ef          	jal	404d52 <unlink>
  400980:	08054163          	bltz	a0,400a02 <writetest+0x12e>
}
  400984:	60a6                	ld	ra,72(sp)
  400986:	6406                	ld	s0,64(sp)
  400988:	74e2                	ld	s1,56(sp)
  40098a:	7942                	ld	s2,48(sp)
  40098c:	79a2                	ld	s3,40(sp)
  40098e:	7a02                	ld	s4,32(sp)
  400990:	6ae2                	ld	s5,24(sp)
  400992:	6b42                	ld	s6,16(sp)
  400994:	6ba2                	ld	s7,8(sp)
  400996:	6161                	addi	sp,sp,80
  400998:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
  40099a:	85de                	mv	a1,s7
  40099c:	00005517          	auipc	a0,0x5
  4009a0:	c8c50513          	addi	a0,a0,-884 # 405628 <malloc+0x450>
  4009a4:	77a040ef          	jal	40511e <printf>
    exit(1);
  4009a8:	4505                	li	a0,1
  4009aa:	358040ef          	jal	404d02 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
  4009ae:	864a                	mv	a2,s2
  4009b0:	85de                	mv	a1,s7
  4009b2:	00005517          	auipc	a0,0x5
  4009b6:	ca650513          	addi	a0,a0,-858 # 405658 <malloc+0x480>
  4009ba:	764040ef          	jal	40511e <printf>
      exit(1);
  4009be:	4505                	li	a0,1
  4009c0:	342040ef          	jal	404d02 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
  4009c4:	864a                	mv	a2,s2
  4009c6:	85de                	mv	a1,s7
  4009c8:	00005517          	auipc	a0,0x5
  4009cc:	cc850513          	addi	a0,a0,-824 # 405690 <malloc+0x4b8>
  4009d0:	74e040ef          	jal	40511e <printf>
      exit(1);
  4009d4:	4505                	li	a0,1
  4009d6:	32c040ef          	jal	404d02 <exit>
    printf("%s: error: open small failed!\n", s);
  4009da:	85de                	mv	a1,s7
  4009dc:	00005517          	auipc	a0,0x5
  4009e0:	cdc50513          	addi	a0,a0,-804 # 4056b8 <malloc+0x4e0>
  4009e4:	73a040ef          	jal	40511e <printf>
    exit(1);
  4009e8:	4505                	li	a0,1
  4009ea:	318040ef          	jal	404d02 <exit>
    printf("%s: read failed\n", s);
  4009ee:	85de                	mv	a1,s7
  4009f0:	00005517          	auipc	a0,0x5
  4009f4:	ce850513          	addi	a0,a0,-792 # 4056d8 <malloc+0x500>
  4009f8:	726040ef          	jal	40511e <printf>
    exit(1);
  4009fc:	4505                	li	a0,1
  4009fe:	304040ef          	jal	404d02 <exit>
    printf("%s: unlink small failed\n", s);
  400a02:	85de                	mv	a1,s7
  400a04:	00005517          	auipc	a0,0x5
  400a08:	cec50513          	addi	a0,a0,-788 # 4056f0 <malloc+0x518>
  400a0c:	712040ef          	jal	40511e <printf>
    exit(1);
  400a10:	4505                	li	a0,1
  400a12:	2f0040ef          	jal	404d02 <exit>

0000000000400a16 <writebig>:
{
  400a16:	7139                	addi	sp,sp,-64
  400a18:	fc06                	sd	ra,56(sp)
  400a1a:	f822                	sd	s0,48(sp)
  400a1c:	f426                	sd	s1,40(sp)
  400a1e:	f04a                	sd	s2,32(sp)
  400a20:	ec4e                	sd	s3,24(sp)
  400a22:	e852                	sd	s4,16(sp)
  400a24:	e456                	sd	s5,8(sp)
  400a26:	e05a                	sd	s6,0(sp)
  400a28:	0080                	addi	s0,sp,64
  400a2a:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
  400a2c:	20200593          	li	a1,514
  400a30:	00005517          	auipc	a0,0x5
  400a34:	ce050513          	addi	a0,a0,-800 # 405710 <malloc+0x538>
  400a38:	30a040ef          	jal	404d42 <open>
  if(fd < 0){
  400a3c:	06054a63          	bltz	a0,400ab0 <writebig+0x9a>
  400a40:	8a2a                	mv	s4,a0
  400a42:	4481                	li	s1,0
    ((int*)buf)[0] = i;
  400a44:	0000c997          	auipc	s3,0xc
  400a48:	23498993          	addi	s3,s3,564 # 40cc78 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
  400a4c:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
  400a50:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
  400a54:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
  400a58:	864a                	mv	a2,s2
  400a5a:	85ce                	mv	a1,s3
  400a5c:	8552                	mv	a0,s4
  400a5e:	2c4040ef          	jal	404d22 <write>
  400a62:	07251163          	bne	a0,s2,400ac4 <writebig+0xae>
  for(i = 0; i < MAXFILE; i++){
  400a66:	2485                	addiw	s1,s1,1
  400a68:	ff5496e3          	bne	s1,s5,400a54 <writebig+0x3e>
  close(fd);
  400a6c:	8552                	mv	a0,s4
  400a6e:	2bc040ef          	jal	404d2a <close>
  fd = open("big", O_RDONLY);
  400a72:	4581                	li	a1,0
  400a74:	00005517          	auipc	a0,0x5
  400a78:	c9c50513          	addi	a0,a0,-868 # 405710 <malloc+0x538>
  400a7c:	2c6040ef          	jal	404d42 <open>
  400a80:	8a2a                	mv	s4,a0
  n = 0;
  400a82:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
  400a84:	40000993          	li	s3,1024
  400a88:	0000c917          	auipc	s2,0xc
  400a8c:	1f090913          	addi	s2,s2,496 # 40cc78 <buf>
  if(fd < 0){
  400a90:	04054563          	bltz	a0,400ada <writebig+0xc4>
    i = read(fd, buf, BSIZE);
  400a94:	864e                	mv	a2,s3
  400a96:	85ca                	mv	a1,s2
  400a98:	8552                	mv	a0,s4
  400a9a:	280040ef          	jal	404d1a <read>
    if(i == 0){
  400a9e:	c921                	beqz	a0,400aee <writebig+0xd8>
    } else if(i != BSIZE){
  400aa0:	09351b63          	bne	a0,s3,400b36 <writebig+0x120>
    if(((int*)buf)[0] != n){
  400aa4:	00092683          	lw	a3,0(s2)
  400aa8:	0a969263          	bne	a3,s1,400b4c <writebig+0x136>
    n++;
  400aac:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
  400aae:	b7dd                	j	400a94 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
  400ab0:	85da                	mv	a1,s6
  400ab2:	00005517          	auipc	a0,0x5
  400ab6:	c6650513          	addi	a0,a0,-922 # 405718 <malloc+0x540>
  400aba:	664040ef          	jal	40511e <printf>
    exit(1);
  400abe:	4505                	li	a0,1
  400ac0:	242040ef          	jal	404d02 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
  400ac4:	8626                	mv	a2,s1
  400ac6:	85da                	mv	a1,s6
  400ac8:	00005517          	auipc	a0,0x5
  400acc:	c7050513          	addi	a0,a0,-912 # 405738 <malloc+0x560>
  400ad0:	64e040ef          	jal	40511e <printf>
      exit(1);
  400ad4:	4505                	li	a0,1
  400ad6:	22c040ef          	jal	404d02 <exit>
    printf("%s: error: open big failed!\n", s);
  400ada:	85da                	mv	a1,s6
  400adc:	00005517          	auipc	a0,0x5
  400ae0:	c8450513          	addi	a0,a0,-892 # 405760 <malloc+0x588>
  400ae4:	63a040ef          	jal	40511e <printf>
    exit(1);
  400ae8:	4505                	li	a0,1
  400aea:	218040ef          	jal	404d02 <exit>
      if(n != MAXFILE){
  400aee:	10c00793          	li	a5,268
  400af2:	02f49763          	bne	s1,a5,400b20 <writebig+0x10a>
  close(fd);
  400af6:	8552                	mv	a0,s4
  400af8:	232040ef          	jal	404d2a <close>
  if(unlink("big") < 0){
  400afc:	00005517          	auipc	a0,0x5
  400b00:	c1450513          	addi	a0,a0,-1004 # 405710 <malloc+0x538>
  400b04:	24e040ef          	jal	404d52 <unlink>
  400b08:	04054d63          	bltz	a0,400b62 <writebig+0x14c>
}
  400b0c:	70e2                	ld	ra,56(sp)
  400b0e:	7442                	ld	s0,48(sp)
  400b10:	74a2                	ld	s1,40(sp)
  400b12:	7902                	ld	s2,32(sp)
  400b14:	69e2                	ld	s3,24(sp)
  400b16:	6a42                	ld	s4,16(sp)
  400b18:	6aa2                	ld	s5,8(sp)
  400b1a:	6b02                	ld	s6,0(sp)
  400b1c:	6121                	addi	sp,sp,64
  400b1e:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
  400b20:	8626                	mv	a2,s1
  400b22:	85da                	mv	a1,s6
  400b24:	00005517          	auipc	a0,0x5
  400b28:	c5c50513          	addi	a0,a0,-932 # 405780 <malloc+0x5a8>
  400b2c:	5f2040ef          	jal	40511e <printf>
        exit(1);
  400b30:	4505                	li	a0,1
  400b32:	1d0040ef          	jal	404d02 <exit>
      printf("%s: read failed %d\n", s, i);
  400b36:	862a                	mv	a2,a0
  400b38:	85da                	mv	a1,s6
  400b3a:	00005517          	auipc	a0,0x5
  400b3e:	c6e50513          	addi	a0,a0,-914 # 4057a8 <malloc+0x5d0>
  400b42:	5dc040ef          	jal	40511e <printf>
      exit(1);
  400b46:	4505                	li	a0,1
  400b48:	1ba040ef          	jal	404d02 <exit>
      printf("%s: read content of block %d is %d\n", s,
  400b4c:	8626                	mv	a2,s1
  400b4e:	85da                	mv	a1,s6
  400b50:	00005517          	auipc	a0,0x5
  400b54:	c7050513          	addi	a0,a0,-912 # 4057c0 <malloc+0x5e8>
  400b58:	5c6040ef          	jal	40511e <printf>
      exit(1);
  400b5c:	4505                	li	a0,1
  400b5e:	1a4040ef          	jal	404d02 <exit>
    printf("%s: unlink big failed\n", s);
  400b62:	85da                	mv	a1,s6
  400b64:	00005517          	auipc	a0,0x5
  400b68:	c8450513          	addi	a0,a0,-892 # 4057e8 <malloc+0x610>
  400b6c:	5b2040ef          	jal	40511e <printf>
    exit(1);
  400b70:	4505                	li	a0,1
  400b72:	190040ef          	jal	404d02 <exit>

0000000000400b76 <unlinkread>:
{
  400b76:	7179                	addi	sp,sp,-48
  400b78:	f406                	sd	ra,40(sp)
  400b7a:	f022                	sd	s0,32(sp)
  400b7c:	ec26                	sd	s1,24(sp)
  400b7e:	e84a                	sd	s2,16(sp)
  400b80:	e44e                	sd	s3,8(sp)
  400b82:	1800                	addi	s0,sp,48
  400b84:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
  400b86:	20200593          	li	a1,514
  400b8a:	00005517          	auipc	a0,0x5
  400b8e:	c7650513          	addi	a0,a0,-906 # 405800 <malloc+0x628>
  400b92:	1b0040ef          	jal	404d42 <open>
  if(fd < 0){
  400b96:	0a054f63          	bltz	a0,400c54 <unlinkread+0xde>
  400b9a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
  400b9c:	4615                	li	a2,5
  400b9e:	00005597          	auipc	a1,0x5
  400ba2:	c9258593          	addi	a1,a1,-878 # 405830 <malloc+0x658>
  400ba6:	17c040ef          	jal	404d22 <write>
  close(fd);
  400baa:	8526                	mv	a0,s1
  400bac:	17e040ef          	jal	404d2a <close>
  fd = open("unlinkread", O_RDWR);
  400bb0:	4589                	li	a1,2
  400bb2:	00005517          	auipc	a0,0x5
  400bb6:	c4e50513          	addi	a0,a0,-946 # 405800 <malloc+0x628>
  400bba:	188040ef          	jal	404d42 <open>
  400bbe:	84aa                	mv	s1,a0
  if(fd < 0){
  400bc0:	0a054463          	bltz	a0,400c68 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
  400bc4:	00005517          	auipc	a0,0x5
  400bc8:	c3c50513          	addi	a0,a0,-964 # 405800 <malloc+0x628>
  400bcc:	186040ef          	jal	404d52 <unlink>
  400bd0:	e555                	bnez	a0,400c7c <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
  400bd2:	20200593          	li	a1,514
  400bd6:	00005517          	auipc	a0,0x5
  400bda:	c2a50513          	addi	a0,a0,-982 # 405800 <malloc+0x628>
  400bde:	164040ef          	jal	404d42 <open>
  400be2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
  400be4:	460d                	li	a2,3
  400be6:	00005597          	auipc	a1,0x5
  400bea:	c9258593          	addi	a1,a1,-878 # 405878 <malloc+0x6a0>
  400bee:	134040ef          	jal	404d22 <write>
  close(fd1);
  400bf2:	854a                	mv	a0,s2
  400bf4:	136040ef          	jal	404d2a <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
  400bf8:	660d                	lui	a2,0x3
  400bfa:	0000c597          	auipc	a1,0xc
  400bfe:	07e58593          	addi	a1,a1,126 # 40cc78 <buf>
  400c02:	8526                	mv	a0,s1
  400c04:	116040ef          	jal	404d1a <read>
  400c08:	4795                	li	a5,5
  400c0a:	08f51363          	bne	a0,a5,400c90 <unlinkread+0x11a>
  if(buf[0] != 'h'){
  400c0e:	0000c717          	auipc	a4,0xc
  400c12:	06a74703          	lbu	a4,106(a4) # 40cc78 <buf>
  400c16:	06800793          	li	a5,104
  400c1a:	08f71563          	bne	a4,a5,400ca4 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
  400c1e:	4629                	li	a2,10
  400c20:	0000c597          	auipc	a1,0xc
  400c24:	05858593          	addi	a1,a1,88 # 40cc78 <buf>
  400c28:	8526                	mv	a0,s1
  400c2a:	0f8040ef          	jal	404d22 <write>
  400c2e:	47a9                	li	a5,10
  400c30:	08f51463          	bne	a0,a5,400cb8 <unlinkread+0x142>
  close(fd);
  400c34:	8526                	mv	a0,s1
  400c36:	0f4040ef          	jal	404d2a <close>
  unlink("unlinkread");
  400c3a:	00005517          	auipc	a0,0x5
  400c3e:	bc650513          	addi	a0,a0,-1082 # 405800 <malloc+0x628>
  400c42:	110040ef          	jal	404d52 <unlink>
}
  400c46:	70a2                	ld	ra,40(sp)
  400c48:	7402                	ld	s0,32(sp)
  400c4a:	64e2                	ld	s1,24(sp)
  400c4c:	6942                	ld	s2,16(sp)
  400c4e:	69a2                	ld	s3,8(sp)
  400c50:	6145                	addi	sp,sp,48
  400c52:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
  400c54:	85ce                	mv	a1,s3
  400c56:	00005517          	auipc	a0,0x5
  400c5a:	bba50513          	addi	a0,a0,-1094 # 405810 <malloc+0x638>
  400c5e:	4c0040ef          	jal	40511e <printf>
    exit(1);
  400c62:	4505                	li	a0,1
  400c64:	09e040ef          	jal	404d02 <exit>
    printf("%s: open unlinkread failed\n", s);
  400c68:	85ce                	mv	a1,s3
  400c6a:	00005517          	auipc	a0,0x5
  400c6e:	bce50513          	addi	a0,a0,-1074 # 405838 <malloc+0x660>
  400c72:	4ac040ef          	jal	40511e <printf>
    exit(1);
  400c76:	4505                	li	a0,1
  400c78:	08a040ef          	jal	404d02 <exit>
    printf("%s: unlink unlinkread failed\n", s);
  400c7c:	85ce                	mv	a1,s3
  400c7e:	00005517          	auipc	a0,0x5
  400c82:	bda50513          	addi	a0,a0,-1062 # 405858 <malloc+0x680>
  400c86:	498040ef          	jal	40511e <printf>
    exit(1);
  400c8a:	4505                	li	a0,1
  400c8c:	076040ef          	jal	404d02 <exit>
    printf("%s: unlinkread read failed", s);
  400c90:	85ce                	mv	a1,s3
  400c92:	00005517          	auipc	a0,0x5
  400c96:	bee50513          	addi	a0,a0,-1042 # 405880 <malloc+0x6a8>
  400c9a:	484040ef          	jal	40511e <printf>
    exit(1);
  400c9e:	4505                	li	a0,1
  400ca0:	062040ef          	jal	404d02 <exit>
    printf("%s: unlinkread wrong data\n", s);
  400ca4:	85ce                	mv	a1,s3
  400ca6:	00005517          	auipc	a0,0x5
  400caa:	bfa50513          	addi	a0,a0,-1030 # 4058a0 <malloc+0x6c8>
  400cae:	470040ef          	jal	40511e <printf>
    exit(1);
  400cb2:	4505                	li	a0,1
  400cb4:	04e040ef          	jal	404d02 <exit>
    printf("%s: unlinkread write failed\n", s);
  400cb8:	85ce                	mv	a1,s3
  400cba:	00005517          	auipc	a0,0x5
  400cbe:	c0650513          	addi	a0,a0,-1018 # 4058c0 <malloc+0x6e8>
  400cc2:	45c040ef          	jal	40511e <printf>
    exit(1);
  400cc6:	4505                	li	a0,1
  400cc8:	03a040ef          	jal	404d02 <exit>

0000000000400ccc <linktest>:
{
  400ccc:	1101                	addi	sp,sp,-32
  400cce:	ec06                	sd	ra,24(sp)
  400cd0:	e822                	sd	s0,16(sp)
  400cd2:	e426                	sd	s1,8(sp)
  400cd4:	e04a                	sd	s2,0(sp)
  400cd6:	1000                	addi	s0,sp,32
  400cd8:	892a                	mv	s2,a0
  unlink("lf1");
  400cda:	00005517          	auipc	a0,0x5
  400cde:	c0650513          	addi	a0,a0,-1018 # 4058e0 <malloc+0x708>
  400ce2:	070040ef          	jal	404d52 <unlink>
  unlink("lf2");
  400ce6:	00005517          	auipc	a0,0x5
  400cea:	c0250513          	addi	a0,a0,-1022 # 4058e8 <malloc+0x710>
  400cee:	064040ef          	jal	404d52 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
  400cf2:	20200593          	li	a1,514
  400cf6:	00005517          	auipc	a0,0x5
  400cfa:	bea50513          	addi	a0,a0,-1046 # 4058e0 <malloc+0x708>
  400cfe:	044040ef          	jal	404d42 <open>
  if(fd < 0){
  400d02:	0c054f63          	bltz	a0,400de0 <linktest+0x114>
  400d06:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
  400d08:	4615                	li	a2,5
  400d0a:	00005597          	auipc	a1,0x5
  400d0e:	b2658593          	addi	a1,a1,-1242 # 405830 <malloc+0x658>
  400d12:	010040ef          	jal	404d22 <write>
  400d16:	4795                	li	a5,5
  400d18:	0cf51e63          	bne	a0,a5,400df4 <linktest+0x128>
  close(fd);
  400d1c:	8526                	mv	a0,s1
  400d1e:	00c040ef          	jal	404d2a <close>
  if(link("lf1", "lf2") < 0){
  400d22:	00005597          	auipc	a1,0x5
  400d26:	bc658593          	addi	a1,a1,-1082 # 4058e8 <malloc+0x710>
  400d2a:	00005517          	auipc	a0,0x5
  400d2e:	bb650513          	addi	a0,a0,-1098 # 4058e0 <malloc+0x708>
  400d32:	030040ef          	jal	404d62 <link>
  400d36:	0c054963          	bltz	a0,400e08 <linktest+0x13c>
  unlink("lf1");
  400d3a:	00005517          	auipc	a0,0x5
  400d3e:	ba650513          	addi	a0,a0,-1114 # 4058e0 <malloc+0x708>
  400d42:	010040ef          	jal	404d52 <unlink>
  if(open("lf1", 0) >= 0){
  400d46:	4581                	li	a1,0
  400d48:	00005517          	auipc	a0,0x5
  400d4c:	b9850513          	addi	a0,a0,-1128 # 4058e0 <malloc+0x708>
  400d50:	7f3030ef          	jal	404d42 <open>
  400d54:	0c055463          	bgez	a0,400e1c <linktest+0x150>
  fd = open("lf2", 0);
  400d58:	4581                	li	a1,0
  400d5a:	00005517          	auipc	a0,0x5
  400d5e:	b8e50513          	addi	a0,a0,-1138 # 4058e8 <malloc+0x710>
  400d62:	7e1030ef          	jal	404d42 <open>
  400d66:	84aa                	mv	s1,a0
  if(fd < 0){
  400d68:	0c054463          	bltz	a0,400e30 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
  400d6c:	660d                	lui	a2,0x3
  400d6e:	0000c597          	auipc	a1,0xc
  400d72:	f0a58593          	addi	a1,a1,-246 # 40cc78 <buf>
  400d76:	7a5030ef          	jal	404d1a <read>
  400d7a:	4795                	li	a5,5
  400d7c:	0cf51463          	bne	a0,a5,400e44 <linktest+0x178>
  close(fd);
  400d80:	8526                	mv	a0,s1
  400d82:	7a9030ef          	jal	404d2a <close>
  if(link("lf2", "lf2") >= 0){
  400d86:	00005597          	auipc	a1,0x5
  400d8a:	b6258593          	addi	a1,a1,-1182 # 4058e8 <malloc+0x710>
  400d8e:	852e                	mv	a0,a1
  400d90:	7d3030ef          	jal	404d62 <link>
  400d94:	0c055263          	bgez	a0,400e58 <linktest+0x18c>
  unlink("lf2");
  400d98:	00005517          	auipc	a0,0x5
  400d9c:	b5050513          	addi	a0,a0,-1200 # 4058e8 <malloc+0x710>
  400da0:	7b3030ef          	jal	404d52 <unlink>
  if(link("lf2", "lf1") >= 0){
  400da4:	00005597          	auipc	a1,0x5
  400da8:	b3c58593          	addi	a1,a1,-1220 # 4058e0 <malloc+0x708>
  400dac:	00005517          	auipc	a0,0x5
  400db0:	b3c50513          	addi	a0,a0,-1220 # 4058e8 <malloc+0x710>
  400db4:	7af030ef          	jal	404d62 <link>
  400db8:	0a055a63          	bgez	a0,400e6c <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
  400dbc:	00005597          	auipc	a1,0x5
  400dc0:	b2458593          	addi	a1,a1,-1244 # 4058e0 <malloc+0x708>
  400dc4:	00005517          	auipc	a0,0x5
  400dc8:	c2c50513          	addi	a0,a0,-980 # 4059f0 <malloc+0x818>
  400dcc:	797030ef          	jal	404d62 <link>
  400dd0:	0a055863          	bgez	a0,400e80 <linktest+0x1b4>
}
  400dd4:	60e2                	ld	ra,24(sp)
  400dd6:	6442                	ld	s0,16(sp)
  400dd8:	64a2                	ld	s1,8(sp)
  400dda:	6902                	ld	s2,0(sp)
  400ddc:	6105                	addi	sp,sp,32
  400dde:	8082                	ret
    printf("%s: create lf1 failed\n", s);
  400de0:	85ca                	mv	a1,s2
  400de2:	00005517          	auipc	a0,0x5
  400de6:	b0e50513          	addi	a0,a0,-1266 # 4058f0 <malloc+0x718>
  400dea:	334040ef          	jal	40511e <printf>
    exit(1);
  400dee:	4505                	li	a0,1
  400df0:	713030ef          	jal	404d02 <exit>
    printf("%s: write lf1 failed\n", s);
  400df4:	85ca                	mv	a1,s2
  400df6:	00005517          	auipc	a0,0x5
  400dfa:	b1250513          	addi	a0,a0,-1262 # 405908 <malloc+0x730>
  400dfe:	320040ef          	jal	40511e <printf>
    exit(1);
  400e02:	4505                	li	a0,1
  400e04:	6ff030ef          	jal	404d02 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
  400e08:	85ca                	mv	a1,s2
  400e0a:	00005517          	auipc	a0,0x5
  400e0e:	b1650513          	addi	a0,a0,-1258 # 405920 <malloc+0x748>
  400e12:	30c040ef          	jal	40511e <printf>
    exit(1);
  400e16:	4505                	li	a0,1
  400e18:	6eb030ef          	jal	404d02 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
  400e1c:	85ca                	mv	a1,s2
  400e1e:	00005517          	auipc	a0,0x5
  400e22:	b2250513          	addi	a0,a0,-1246 # 405940 <malloc+0x768>
  400e26:	2f8040ef          	jal	40511e <printf>
    exit(1);
  400e2a:	4505                	li	a0,1
  400e2c:	6d7030ef          	jal	404d02 <exit>
    printf("%s: open lf2 failed\n", s);
  400e30:	85ca                	mv	a1,s2
  400e32:	00005517          	auipc	a0,0x5
  400e36:	b3e50513          	addi	a0,a0,-1218 # 405970 <malloc+0x798>
  400e3a:	2e4040ef          	jal	40511e <printf>
    exit(1);
  400e3e:	4505                	li	a0,1
  400e40:	6c3030ef          	jal	404d02 <exit>
    printf("%s: read lf2 failed\n", s);
  400e44:	85ca                	mv	a1,s2
  400e46:	00005517          	auipc	a0,0x5
  400e4a:	b4250513          	addi	a0,a0,-1214 # 405988 <malloc+0x7b0>
  400e4e:	2d0040ef          	jal	40511e <printf>
    exit(1);
  400e52:	4505                	li	a0,1
  400e54:	6af030ef          	jal	404d02 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
  400e58:	85ca                	mv	a1,s2
  400e5a:	00005517          	auipc	a0,0x5
  400e5e:	b4650513          	addi	a0,a0,-1210 # 4059a0 <malloc+0x7c8>
  400e62:	2bc040ef          	jal	40511e <printf>
    exit(1);
  400e66:	4505                	li	a0,1
  400e68:	69b030ef          	jal	404d02 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
  400e6c:	85ca                	mv	a1,s2
  400e6e:	00005517          	auipc	a0,0x5
  400e72:	b5a50513          	addi	a0,a0,-1190 # 4059c8 <malloc+0x7f0>
  400e76:	2a8040ef          	jal	40511e <printf>
    exit(1);
  400e7a:	4505                	li	a0,1
  400e7c:	687030ef          	jal	404d02 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
  400e80:	85ca                	mv	a1,s2
  400e82:	00005517          	auipc	a0,0x5
  400e86:	b7650513          	addi	a0,a0,-1162 # 4059f8 <malloc+0x820>
  400e8a:	294040ef          	jal	40511e <printf>
    exit(1);
  400e8e:	4505                	li	a0,1
  400e90:	673030ef          	jal	404d02 <exit>

0000000000400e94 <validatetest>:
{
  400e94:	7139                	addi	sp,sp,-64
  400e96:	fc06                	sd	ra,56(sp)
  400e98:	f822                	sd	s0,48(sp)
  400e9a:	f426                	sd	s1,40(sp)
  400e9c:	f04a                	sd	s2,32(sp)
  400e9e:	ec4e                	sd	s3,24(sp)
  400ea0:	e852                	sd	s4,16(sp)
  400ea2:	e456                	sd	s5,8(sp)
  400ea4:	e05a                	sd	s6,0(sp)
  400ea6:	0080                	addi	s0,sp,64
  400ea8:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
  400eaa:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
  400eac:	00005997          	auipc	s3,0x5
  400eb0:	b6c98993          	addi	s3,s3,-1172 # 405a18 <malloc+0x840>
  400eb4:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
  400eb6:	6a85                	lui	s5,0x1
  400eb8:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
  400ebc:	85a6                	mv	a1,s1
  400ebe:	854e                	mv	a0,s3
  400ec0:	6a3030ef          	jal	404d62 <link>
  400ec4:	01251f63          	bne	a0,s2,400ee2 <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
  400ec8:	94d6                	add	s1,s1,s5
  400eca:	ff4499e3          	bne	s1,s4,400ebc <validatetest+0x28>
}
  400ece:	70e2                	ld	ra,56(sp)
  400ed0:	7442                	ld	s0,48(sp)
  400ed2:	74a2                	ld	s1,40(sp)
  400ed4:	7902                	ld	s2,32(sp)
  400ed6:	69e2                	ld	s3,24(sp)
  400ed8:	6a42                	ld	s4,16(sp)
  400eda:	6aa2                	ld	s5,8(sp)
  400edc:	6b02                	ld	s6,0(sp)
  400ede:	6121                	addi	sp,sp,64
  400ee0:	8082                	ret
      printf("%s: link should not succeed\n", s);
  400ee2:	85da                	mv	a1,s6
  400ee4:	00005517          	auipc	a0,0x5
  400ee8:	b4450513          	addi	a0,a0,-1212 # 405a28 <malloc+0x850>
  400eec:	232040ef          	jal	40511e <printf>
      exit(1);
  400ef0:	4505                	li	a0,1
  400ef2:	611030ef          	jal	404d02 <exit>

0000000000400ef6 <bigdir>:
{
  400ef6:	711d                	addi	sp,sp,-96
  400ef8:	ec86                	sd	ra,88(sp)
  400efa:	e8a2                	sd	s0,80(sp)
  400efc:	e4a6                	sd	s1,72(sp)
  400efe:	e0ca                	sd	s2,64(sp)
  400f00:	fc4e                	sd	s3,56(sp)
  400f02:	f852                	sd	s4,48(sp)
  400f04:	f456                	sd	s5,40(sp)
  400f06:	f05a                	sd	s6,32(sp)
  400f08:	ec5e                	sd	s7,24(sp)
  400f0a:	1080                	addi	s0,sp,96
  400f0c:	89aa                	mv	s3,a0
  unlink("bd");
  400f0e:	00005517          	auipc	a0,0x5
  400f12:	b3a50513          	addi	a0,a0,-1222 # 405a48 <malloc+0x870>
  400f16:	63d030ef          	jal	404d52 <unlink>
  fd = open("bd", O_CREATE);
  400f1a:	20000593          	li	a1,512
  400f1e:	00005517          	auipc	a0,0x5
  400f22:	b2a50513          	addi	a0,a0,-1238 # 405a48 <malloc+0x870>
  400f26:	61d030ef          	jal	404d42 <open>
  if(fd < 0){
  400f2a:	0c054463          	bltz	a0,400ff2 <bigdir+0xfc>
  close(fd);
  400f2e:	5fd030ef          	jal	404d2a <close>
  for(i = 0; i < N; i++){
  400f32:	4901                	li	s2,0
    name[0] = 'x';
  400f34:	07800b13          	li	s6,120
    if(link("bd", name) != 0){
  400f38:	fa040a93          	addi	s5,s0,-96
  400f3c:	00005a17          	auipc	s4,0x5
  400f40:	b0ca0a13          	addi	s4,s4,-1268 # 405a48 <malloc+0x870>
  for(i = 0; i < N; i++){
  400f44:	1f400b93          	li	s7,500
    name[0] = 'x';
  400f48:	fb640023          	sb	s6,-96(s0)
    name[1] = '0' + (i / 64);
  400f4c:	41f9571b          	sraiw	a4,s2,0x1f
  400f50:	01a7571b          	srliw	a4,a4,0x1a
  400f54:	012707bb          	addw	a5,a4,s2
  400f58:	4067d69b          	sraiw	a3,a5,0x6
  400f5c:	0306869b          	addiw	a3,a3,48
  400f60:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
  400f64:	03f7f793          	andi	a5,a5,63
  400f68:	9f99                	subw	a5,a5,a4
  400f6a:	0307879b          	addiw	a5,a5,48
  400f6e:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
  400f72:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
  400f76:	85d6                	mv	a1,s5
  400f78:	8552                	mv	a0,s4
  400f7a:	5e9030ef          	jal	404d62 <link>
  400f7e:	84aa                	mv	s1,a0
  400f80:	e159                	bnez	a0,401006 <bigdir+0x110>
  for(i = 0; i < N; i++){
  400f82:	2905                	addiw	s2,s2,1
  400f84:	fd7912e3          	bne	s2,s7,400f48 <bigdir+0x52>
  unlink("bd");
  400f88:	00005517          	auipc	a0,0x5
  400f8c:	ac050513          	addi	a0,a0,-1344 # 405a48 <malloc+0x870>
  400f90:	5c3030ef          	jal	404d52 <unlink>
    name[0] = 'x';
  400f94:	07800a13          	li	s4,120
    if(unlink(name) != 0){
  400f98:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
  400f9c:	1f400a93          	li	s5,500
    name[0] = 'x';
  400fa0:	fb440023          	sb	s4,-96(s0)
    name[1] = '0' + (i / 64);
  400fa4:	41f4d71b          	sraiw	a4,s1,0x1f
  400fa8:	01a7571b          	srliw	a4,a4,0x1a
  400fac:	009707bb          	addw	a5,a4,s1
  400fb0:	4067d69b          	sraiw	a3,a5,0x6
  400fb4:	0306869b          	addiw	a3,a3,48
  400fb8:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
  400fbc:	03f7f793          	andi	a5,a5,63
  400fc0:	9f99                	subw	a5,a5,a4
  400fc2:	0307879b          	addiw	a5,a5,48
  400fc6:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
  400fca:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
  400fce:	854a                	mv	a0,s2
  400fd0:	583030ef          	jal	404d52 <unlink>
  400fd4:	e531                	bnez	a0,401020 <bigdir+0x12a>
  for(i = 0; i < N; i++){
  400fd6:	2485                	addiw	s1,s1,1
  400fd8:	fd5494e3          	bne	s1,s5,400fa0 <bigdir+0xaa>
}
  400fdc:	60e6                	ld	ra,88(sp)
  400fde:	6446                	ld	s0,80(sp)
  400fe0:	64a6                	ld	s1,72(sp)
  400fe2:	6906                	ld	s2,64(sp)
  400fe4:	79e2                	ld	s3,56(sp)
  400fe6:	7a42                	ld	s4,48(sp)
  400fe8:	7aa2                	ld	s5,40(sp)
  400fea:	7b02                	ld	s6,32(sp)
  400fec:	6be2                	ld	s7,24(sp)
  400fee:	6125                	addi	sp,sp,96
  400ff0:	8082                	ret
    printf("%s: bigdir create failed\n", s);
  400ff2:	85ce                	mv	a1,s3
  400ff4:	00005517          	auipc	a0,0x5
  400ff8:	a5c50513          	addi	a0,a0,-1444 # 405a50 <malloc+0x878>
  400ffc:	122040ef          	jal	40511e <printf>
    exit(1);
  401000:	4505                	li	a0,1
  401002:	501030ef          	jal	404d02 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
  401006:	fa040693          	addi	a3,s0,-96
  40100a:	864a                	mv	a2,s2
  40100c:	85ce                	mv	a1,s3
  40100e:	00005517          	auipc	a0,0x5
  401012:	a6250513          	addi	a0,a0,-1438 # 405a70 <malloc+0x898>
  401016:	108040ef          	jal	40511e <printf>
      exit(1);
  40101a:	4505                	li	a0,1
  40101c:	4e7030ef          	jal	404d02 <exit>
      printf("%s: bigdir unlink failed", s);
  401020:	85ce                	mv	a1,s3
  401022:	00005517          	auipc	a0,0x5
  401026:	a7650513          	addi	a0,a0,-1418 # 405a98 <malloc+0x8c0>
  40102a:	0f4040ef          	jal	40511e <printf>
      exit(1);
  40102e:	4505                	li	a0,1
  401030:	4d3030ef          	jal	404d02 <exit>

0000000000401034 <pgbug>:
{
  401034:	7179                	addi	sp,sp,-48
  401036:	f406                	sd	ra,40(sp)
  401038:	f022                	sd	s0,32(sp)
  40103a:	ec26                	sd	s1,24(sp)
  40103c:	1800                	addi	s0,sp,48
  argv[0] = 0;
  40103e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
  401042:	00008497          	auipc	s1,0x8
  401046:	fbe48493          	addi	s1,s1,-66 # 409000 <big>
  40104a:	fd840593          	addi	a1,s0,-40
  40104e:	6088                	ld	a0,0(s1)
  401050:	4eb030ef          	jal	404d3a <exec>
  pipe(big);
  401054:	6088                	ld	a0,0(s1)
  401056:	4bd030ef          	jal	404d12 <pipe>
  exit(0);
  40105a:	4501                	li	a0,0
  40105c:	4a7030ef          	jal	404d02 <exit>

0000000000401060 <badarg>:
{
  401060:	7139                	addi	sp,sp,-64
  401062:	fc06                	sd	ra,56(sp)
  401064:	f822                	sd	s0,48(sp)
  401066:	f426                	sd	s1,40(sp)
  401068:	f04a                	sd	s2,32(sp)
  40106a:	ec4e                	sd	s3,24(sp)
  40106c:	e852                	sd	s4,16(sp)
  40106e:	0080                	addi	s0,sp,64
  401070:	64b1                	lui	s1,0xc
  401072:	35048493          	addi	s1,s1,848 # c350 <copyinstr1-0x3f3cb0>
    argv[0] = (char*)0xffffffff;
  401076:	597d                	li	s2,-1
  401078:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
  40107c:	fc040a13          	addi	s4,s0,-64
  401080:	00004997          	auipc	s3,0x4
  401084:	28898993          	addi	s3,s3,648 # 405308 <malloc+0x130>
    argv[0] = (char*)0xffffffff;
  401088:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
  40108c:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
  401090:	85d2                	mv	a1,s4
  401092:	854e                	mv	a0,s3
  401094:	4a7030ef          	jal	404d3a <exec>
  for(int i = 0; i < 50000; i++){
  401098:	34fd                	addiw	s1,s1,-1
  40109a:	f4fd                	bnez	s1,401088 <badarg+0x28>
  exit(0);
  40109c:	4501                	li	a0,0
  40109e:	465030ef          	jal	404d02 <exit>

00000000004010a2 <copyinstr2>:
{
  4010a2:	7155                	addi	sp,sp,-208
  4010a4:	e586                	sd	ra,200(sp)
  4010a6:	e1a2                	sd	s0,192(sp)
  4010a8:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
  4010aa:	f6840793          	addi	a5,s0,-152
  4010ae:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
  4010b2:	07800713          	li	a4,120
  4010b6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
  4010ba:	0785                	addi	a5,a5,1
  4010bc:	fed79de3          	bne	a5,a3,4010b6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
  4010c0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
  4010c4:	f6840513          	addi	a0,s0,-152
  4010c8:	48b030ef          	jal	404d52 <unlink>
  if(ret != -1){
  4010cc:	57fd                	li	a5,-1
  4010ce:	0cf51263          	bne	a0,a5,401192 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
  4010d2:	20100593          	li	a1,513
  4010d6:	f6840513          	addi	a0,s0,-152
  4010da:	469030ef          	jal	404d42 <open>
  if(fd != -1){
  4010de:	57fd                	li	a5,-1
  4010e0:	0cf51563          	bne	a0,a5,4011aa <copyinstr2+0x108>
  ret = link(b, b);
  4010e4:	f6840513          	addi	a0,s0,-152
  4010e8:	85aa                	mv	a1,a0
  4010ea:	479030ef          	jal	404d62 <link>
  if(ret != -1){
  4010ee:	57fd                	li	a5,-1
  4010f0:	0cf51963          	bne	a0,a5,4011c2 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
  4010f4:	00006797          	auipc	a5,0x6
  4010f8:	af478793          	addi	a5,a5,-1292 # 406be8 <malloc+0x1a10>
  4010fc:	f4f43c23          	sd	a5,-168(s0)
  401100:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
  401104:	f5840593          	addi	a1,s0,-168
  401108:	f6840513          	addi	a0,s0,-152
  40110c:	42f030ef          	jal	404d3a <exec>
  if(ret != -1){
  401110:	57fd                	li	a5,-1
  401112:	0cf51563          	bne	a0,a5,4011dc <copyinstr2+0x13a>
  int pid = fork();
  401116:	3e5030ef          	jal	404cfa <fork>
  if(pid < 0){
  40111a:	0c054d63          	bltz	a0,4011f4 <copyinstr2+0x152>
  if(pid == 0){
  40111e:	0e051863          	bnez	a0,40120e <copyinstr2+0x16c>
  401122:	00008797          	auipc	a5,0x8
  401126:	43e78793          	addi	a5,a5,1086 # 409560 <big.0>
  40112a:	00009697          	auipc	a3,0x9
  40112e:	43668693          	addi	a3,a3,1078 # 40a560 <big.0+0x1000>
      big[i] = 'x';
  401132:	07800713          	li	a4,120
  401136:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
  40113a:	0785                	addi	a5,a5,1
  40113c:	fed79de3          	bne	a5,a3,401136 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
  401140:	00009797          	auipc	a5,0x9
  401144:	42078023          	sb	zero,1056(a5) # 40a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
  401148:	00006797          	auipc	a5,0x6
  40114c:	52078793          	addi	a5,a5,1312 # 407668 <malloc+0x2490>
  401150:	6fb0                	ld	a2,88(a5)
  401152:	73b4                	ld	a3,96(a5)
  401154:	77b8                	ld	a4,104(a5)
  401156:	7bbc                	ld	a5,112(a5)
  401158:	f2c43823          	sd	a2,-208(s0)
  40115c:	f2d43c23          	sd	a3,-200(s0)
  401160:	f4e43023          	sd	a4,-192(s0)
  401164:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
  401168:	f3040593          	addi	a1,s0,-208
  40116c:	00004517          	auipc	a0,0x4
  401170:	19c50513          	addi	a0,a0,412 # 405308 <malloc+0x130>
  401174:	3c7030ef          	jal	404d3a <exec>
    if(ret != -1){
  401178:	57fd                	li	a5,-1
  40117a:	08f50663          	beq	a0,a5,401206 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
  40117e:	85be                	mv	a1,a5
  401180:	00005517          	auipc	a0,0x5
  401184:	9c050513          	addi	a0,a0,-1600 # 405b40 <malloc+0x968>
  401188:	797030ef          	jal	40511e <printf>
      exit(1);
  40118c:	4505                	li	a0,1
  40118e:	375030ef          	jal	404d02 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
  401192:	862a                	mv	a2,a0
  401194:	f6840593          	addi	a1,s0,-152
  401198:	00005517          	auipc	a0,0x5
  40119c:	92050513          	addi	a0,a0,-1760 # 405ab8 <malloc+0x8e0>
  4011a0:	77f030ef          	jal	40511e <printf>
    exit(1);
  4011a4:	4505                	li	a0,1
  4011a6:	35d030ef          	jal	404d02 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
  4011aa:	862a                	mv	a2,a0
  4011ac:	f6840593          	addi	a1,s0,-152
  4011b0:	00005517          	auipc	a0,0x5
  4011b4:	92850513          	addi	a0,a0,-1752 # 405ad8 <malloc+0x900>
  4011b8:	767030ef          	jal	40511e <printf>
    exit(1);
  4011bc:	4505                	li	a0,1
  4011be:	345030ef          	jal	404d02 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
  4011c2:	f6840593          	addi	a1,s0,-152
  4011c6:	86aa                	mv	a3,a0
  4011c8:	862e                	mv	a2,a1
  4011ca:	00005517          	auipc	a0,0x5
  4011ce:	92e50513          	addi	a0,a0,-1746 # 405af8 <malloc+0x920>
  4011d2:	74d030ef          	jal	40511e <printf>
    exit(1);
  4011d6:	4505                	li	a0,1
  4011d8:	32b030ef          	jal	404d02 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
  4011dc:	863e                	mv	a2,a5
  4011de:	f6840593          	addi	a1,s0,-152
  4011e2:	00005517          	auipc	a0,0x5
  4011e6:	93e50513          	addi	a0,a0,-1730 # 405b20 <malloc+0x948>
  4011ea:	735030ef          	jal	40511e <printf>
    exit(1);
  4011ee:	4505                	li	a0,1
  4011f0:	313030ef          	jal	404d02 <exit>
    printf("fork failed\n");
  4011f4:	00006517          	auipc	a0,0x6
  4011f8:	f1450513          	addi	a0,a0,-236 # 407108 <malloc+0x1f30>
  4011fc:	723030ef          	jal	40511e <printf>
    exit(1);
  401200:	4505                	li	a0,1
  401202:	301030ef          	jal	404d02 <exit>
    exit(747); // OK
  401206:	2eb00513          	li	a0,747
  40120a:	2f9030ef          	jal	404d02 <exit>
  int st = 0;
  40120e:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
  401212:	f5440513          	addi	a0,s0,-172
  401216:	2f5030ef          	jal	404d0a <wait>
  if(st != 747){
  40121a:	f5442703          	lw	a4,-172(s0)
  40121e:	2eb00793          	li	a5,747
  401222:	00f71663          	bne	a4,a5,40122e <copyinstr2+0x18c>
}
  401226:	60ae                	ld	ra,200(sp)
  401228:	640e                	ld	s0,192(sp)
  40122a:	6169                	addi	sp,sp,208
  40122c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
  40122e:	00005517          	auipc	a0,0x5
  401232:	93a50513          	addi	a0,a0,-1734 # 405b68 <malloc+0x990>
  401236:	6e9030ef          	jal	40511e <printf>
    exit(1);
  40123a:	4505                	li	a0,1
  40123c:	2c7030ef          	jal	404d02 <exit>

0000000000401240 <truncate3>:
{
  401240:	7175                	addi	sp,sp,-144
  401242:	e506                	sd	ra,136(sp)
  401244:	e122                	sd	s0,128(sp)
  401246:	ecd6                	sd	s5,88(sp)
  401248:	0900                	addi	s0,sp,144
  40124a:	8aaa                	mv	s5,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
  40124c:	60100593          	li	a1,1537
  401250:	00004517          	auipc	a0,0x4
  401254:	11050513          	addi	a0,a0,272 # 405360 <malloc+0x188>
  401258:	2eb030ef          	jal	404d42 <open>
  40125c:	2cf030ef          	jal	404d2a <close>
  pid = fork();
  401260:	29b030ef          	jal	404cfa <fork>
  if(pid < 0){
  401264:	06054d63          	bltz	a0,4012de <truncate3+0x9e>
  if(pid == 0){
  401268:	e171                	bnez	a0,40132c <truncate3+0xec>
  40126a:	fca6                	sd	s1,120(sp)
  40126c:	f8ca                	sd	s2,112(sp)
  40126e:	f4ce                	sd	s3,104(sp)
  401270:	f0d2                	sd	s4,96(sp)
  401272:	e8da                	sd	s6,80(sp)
  401274:	e4de                	sd	s7,72(sp)
  401276:	e0e2                	sd	s8,64(sp)
  401278:	fc66                	sd	s9,56(sp)
  40127a:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
  40127e:	4b05                	li	s6,1
  401280:	00004997          	auipc	s3,0x4
  401284:	0e098993          	addi	s3,s3,224 # 405360 <malloc+0x188>
      int n = write(fd, "1234567890", 10);
  401288:	4a29                	li	s4,10
  40128a:	00005b97          	auipc	s7,0x5
  40128e:	93eb8b93          	addi	s7,s7,-1730 # 405bc8 <malloc+0x9f0>
      read(fd, buf, sizeof(buf));
  401292:	f7840c93          	addi	s9,s0,-136
  401296:	02000c13          	li	s8,32
      int fd = open("truncfile", O_WRONLY);
  40129a:	85da                	mv	a1,s6
  40129c:	854e                	mv	a0,s3
  40129e:	2a5030ef          	jal	404d42 <open>
  4012a2:	84aa                	mv	s1,a0
      if(fd < 0){
  4012a4:	04054f63          	bltz	a0,401302 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
  4012a8:	8652                	mv	a2,s4
  4012aa:	85de                	mv	a1,s7
  4012ac:	277030ef          	jal	404d22 <write>
      if(n != 10){
  4012b0:	07451363          	bne	a0,s4,401316 <truncate3+0xd6>
      close(fd);
  4012b4:	8526                	mv	a0,s1
  4012b6:	275030ef          	jal	404d2a <close>
      fd = open("truncfile", O_RDONLY);
  4012ba:	4581                	li	a1,0
  4012bc:	854e                	mv	a0,s3
  4012be:	285030ef          	jal	404d42 <open>
  4012c2:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
  4012c4:	8662                	mv	a2,s8
  4012c6:	85e6                	mv	a1,s9
  4012c8:	253030ef          	jal	404d1a <read>
      close(fd);
  4012cc:	8526                	mv	a0,s1
  4012ce:	25d030ef          	jal	404d2a <close>
    for(int i = 0; i < 100; i++){
  4012d2:	397d                	addiw	s2,s2,-1
  4012d4:	fc0913e3          	bnez	s2,40129a <truncate3+0x5a>
    exit(0);
  4012d8:	4501                	li	a0,0
  4012da:	229030ef          	jal	404d02 <exit>
  4012de:	fca6                	sd	s1,120(sp)
  4012e0:	f8ca                	sd	s2,112(sp)
  4012e2:	f4ce                	sd	s3,104(sp)
  4012e4:	f0d2                	sd	s4,96(sp)
  4012e6:	e8da                	sd	s6,80(sp)
  4012e8:	e4de                	sd	s7,72(sp)
  4012ea:	e0e2                	sd	s8,64(sp)
  4012ec:	fc66                	sd	s9,56(sp)
    printf("%s: fork failed\n", s);
  4012ee:	85d6                	mv	a1,s5
  4012f0:	00005517          	auipc	a0,0x5
  4012f4:	8a850513          	addi	a0,a0,-1880 # 405b98 <malloc+0x9c0>
  4012f8:	627030ef          	jal	40511e <printf>
    exit(1);
  4012fc:	4505                	li	a0,1
  4012fe:	205030ef          	jal	404d02 <exit>
        printf("%s: open failed\n", s);
  401302:	85d6                	mv	a1,s5
  401304:	00005517          	auipc	a0,0x5
  401308:	8ac50513          	addi	a0,a0,-1876 # 405bb0 <malloc+0x9d8>
  40130c:	613030ef          	jal	40511e <printf>
        exit(1);
  401310:	4505                	li	a0,1
  401312:	1f1030ef          	jal	404d02 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
  401316:	862a                	mv	a2,a0
  401318:	85d6                	mv	a1,s5
  40131a:	00005517          	auipc	a0,0x5
  40131e:	8be50513          	addi	a0,a0,-1858 # 405bd8 <malloc+0xa00>
  401322:	5fd030ef          	jal	40511e <printf>
        exit(1);
  401326:	4505                	li	a0,1
  401328:	1db030ef          	jal	404d02 <exit>
  40132c:	fca6                	sd	s1,120(sp)
  40132e:	f8ca                	sd	s2,112(sp)
  401330:	f4ce                	sd	s3,104(sp)
  401332:	f0d2                	sd	s4,96(sp)
  401334:	e8da                	sd	s6,80(sp)
  401336:	e4de                	sd	s7,72(sp)
  401338:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
  40133c:	60100b13          	li	s6,1537
  401340:	00004a17          	auipc	s4,0x4
  401344:	020a0a13          	addi	s4,s4,32 # 405360 <malloc+0x188>
    int n = write(fd, "xxx", 3);
  401348:	498d                	li	s3,3
  40134a:	00005b97          	auipc	s7,0x5
  40134e:	8aeb8b93          	addi	s7,s7,-1874 # 405bf8 <malloc+0xa20>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
  401352:	85da                	mv	a1,s6
  401354:	8552                	mv	a0,s4
  401356:	1ed030ef          	jal	404d42 <open>
  40135a:	84aa                	mv	s1,a0
    if(fd < 0){
  40135c:	02054e63          	bltz	a0,401398 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
  401360:	864e                	mv	a2,s3
  401362:	85de                	mv	a1,s7
  401364:	1bf030ef          	jal	404d22 <write>
    if(n != 3){
  401368:	05351463          	bne	a0,s3,4013b0 <truncate3+0x170>
    close(fd);
  40136c:	8526                	mv	a0,s1
  40136e:	1bd030ef          	jal	404d2a <close>
  for(int i = 0; i < 150; i++){
  401372:	397d                	addiw	s2,s2,-1
  401374:	fc091fe3          	bnez	s2,401352 <truncate3+0x112>
  401378:	e0e2                	sd	s8,64(sp)
  40137a:	fc66                	sd	s9,56(sp)
  wait(&xstatus);
  40137c:	f9c40513          	addi	a0,s0,-100
  401380:	18b030ef          	jal	404d0a <wait>
  unlink("truncfile");
  401384:	00004517          	auipc	a0,0x4
  401388:	fdc50513          	addi	a0,a0,-36 # 405360 <malloc+0x188>
  40138c:	1c7030ef          	jal	404d52 <unlink>
  exit(xstatus);
  401390:	f9c42503          	lw	a0,-100(s0)
  401394:	16f030ef          	jal	404d02 <exit>
  401398:	e0e2                	sd	s8,64(sp)
  40139a:	fc66                	sd	s9,56(sp)
      printf("%s: open failed\n", s);
  40139c:	85d6                	mv	a1,s5
  40139e:	00005517          	auipc	a0,0x5
  4013a2:	81250513          	addi	a0,a0,-2030 # 405bb0 <malloc+0x9d8>
  4013a6:	579030ef          	jal	40511e <printf>
      exit(1);
  4013aa:	4505                	li	a0,1
  4013ac:	157030ef          	jal	404d02 <exit>
  4013b0:	e0e2                	sd	s8,64(sp)
  4013b2:	fc66                	sd	s9,56(sp)
      printf("%s: write got %d, expected 3\n", s, n);
  4013b4:	862a                	mv	a2,a0
  4013b6:	85d6                	mv	a1,s5
  4013b8:	00005517          	auipc	a0,0x5
  4013bc:	84850513          	addi	a0,a0,-1976 # 405c00 <malloc+0xa28>
  4013c0:	55f030ef          	jal	40511e <printf>
      exit(1);
  4013c4:	4505                	li	a0,1
  4013c6:	13d030ef          	jal	404d02 <exit>

00000000004013ca <exectest>:
{
  4013ca:	715d                	addi	sp,sp,-80
  4013cc:	e486                	sd	ra,72(sp)
  4013ce:	e0a2                	sd	s0,64(sp)
  4013d0:	f84a                	sd	s2,48(sp)
  4013d2:	0880                	addi	s0,sp,80
  4013d4:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
  4013d6:	00004797          	auipc	a5,0x4
  4013da:	f3278793          	addi	a5,a5,-206 # 405308 <malloc+0x130>
  4013de:	fcf43023          	sd	a5,-64(s0)
  4013e2:	00005797          	auipc	a5,0x5
  4013e6:	83e78793          	addi	a5,a5,-1986 # 405c20 <malloc+0xa48>
  4013ea:	fcf43423          	sd	a5,-56(s0)
  4013ee:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
  4013f2:	00005517          	auipc	a0,0x5
  4013f6:	83650513          	addi	a0,a0,-1994 # 405c28 <malloc+0xa50>
  4013fa:	159030ef          	jal	404d52 <unlink>
  pid = fork();
  4013fe:	0fd030ef          	jal	404cfa <fork>
  if(pid < 0) {
  401402:	02054f63          	bltz	a0,401440 <exectest+0x76>
  401406:	fc26                	sd	s1,56(sp)
  401408:	84aa                	mv	s1,a0
  if(pid == 0) {
  40140a:	e935                	bnez	a0,40147e <exectest+0xb4>
    close(1);
  40140c:	4505                	li	a0,1
  40140e:	11d030ef          	jal	404d2a <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
  401412:	20100593          	li	a1,513
  401416:	00005517          	auipc	a0,0x5
  40141a:	81250513          	addi	a0,a0,-2030 # 405c28 <malloc+0xa50>
  40141e:	125030ef          	jal	404d42 <open>
    if(fd < 0) {
  401422:	02054a63          	bltz	a0,401456 <exectest+0x8c>
    if(fd != 1) {
  401426:	4785                	li	a5,1
  401428:	04f50163          	beq	a0,a5,40146a <exectest+0xa0>
      printf("%s: wrong fd\n", s);
  40142c:	85ca                	mv	a1,s2
  40142e:	00005517          	auipc	a0,0x5
  401432:	81a50513          	addi	a0,a0,-2022 # 405c48 <malloc+0xa70>
  401436:	4e9030ef          	jal	40511e <printf>
      exit(1);
  40143a:	4505                	li	a0,1
  40143c:	0c7030ef          	jal	404d02 <exit>
  401440:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
  401442:	85ca                	mv	a1,s2
  401444:	00004517          	auipc	a0,0x4
  401448:	75450513          	addi	a0,a0,1876 # 405b98 <malloc+0x9c0>
  40144c:	4d3030ef          	jal	40511e <printf>
     exit(1);
  401450:	4505                	li	a0,1
  401452:	0b1030ef          	jal	404d02 <exit>
      printf("%s: create failed\n", s);
  401456:	85ca                	mv	a1,s2
  401458:	00004517          	auipc	a0,0x4
  40145c:	7d850513          	addi	a0,a0,2008 # 405c30 <malloc+0xa58>
  401460:	4bf030ef          	jal	40511e <printf>
      exit(1);
  401464:	4505                	li	a0,1
  401466:	09d030ef          	jal	404d02 <exit>
    if(exec("echo", echoargv) < 0){
  40146a:	fc040593          	addi	a1,s0,-64
  40146e:	00004517          	auipc	a0,0x4
  401472:	e9a50513          	addi	a0,a0,-358 # 405308 <malloc+0x130>
  401476:	0c5030ef          	jal	404d3a <exec>
  40147a:	00054d63          	bltz	a0,401494 <exectest+0xca>
  if (wait(&xstatus) != pid) {
  40147e:	fdc40513          	addi	a0,s0,-36
  401482:	089030ef          	jal	404d0a <wait>
  401486:	02951163          	bne	a0,s1,4014a8 <exectest+0xde>
  if(xstatus != 0)
  40148a:	fdc42503          	lw	a0,-36(s0)
  40148e:	c50d                	beqz	a0,4014b8 <exectest+0xee>
    exit(xstatus);
  401490:	073030ef          	jal	404d02 <exit>
      printf("%s: exec echo failed\n", s);
  401494:	85ca                	mv	a1,s2
  401496:	00004517          	auipc	a0,0x4
  40149a:	7c250513          	addi	a0,a0,1986 # 405c58 <malloc+0xa80>
  40149e:	481030ef          	jal	40511e <printf>
      exit(1);
  4014a2:	4505                	li	a0,1
  4014a4:	05f030ef          	jal	404d02 <exit>
    printf("%s: wait failed!\n", s);
  4014a8:	85ca                	mv	a1,s2
  4014aa:	00004517          	auipc	a0,0x4
  4014ae:	7c650513          	addi	a0,a0,1990 # 405c70 <malloc+0xa98>
  4014b2:	46d030ef          	jal	40511e <printf>
  4014b6:	bfd1                	j	40148a <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
  4014b8:	4581                	li	a1,0
  4014ba:	00004517          	auipc	a0,0x4
  4014be:	76e50513          	addi	a0,a0,1902 # 405c28 <malloc+0xa50>
  4014c2:	081030ef          	jal	404d42 <open>
  if(fd < 0) {
  4014c6:	02054463          	bltz	a0,4014ee <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
  4014ca:	4609                	li	a2,2
  4014cc:	fb840593          	addi	a1,s0,-72
  4014d0:	04b030ef          	jal	404d1a <read>
  4014d4:	4789                	li	a5,2
  4014d6:	02f50663          	beq	a0,a5,401502 <exectest+0x138>
    printf("%s: read failed\n", s);
  4014da:	85ca                	mv	a1,s2
  4014dc:	00004517          	auipc	a0,0x4
  4014e0:	1fc50513          	addi	a0,a0,508 # 4056d8 <malloc+0x500>
  4014e4:	43b030ef          	jal	40511e <printf>
    exit(1);
  4014e8:	4505                	li	a0,1
  4014ea:	019030ef          	jal	404d02 <exit>
    printf("%s: open failed\n", s);
  4014ee:	85ca                	mv	a1,s2
  4014f0:	00004517          	auipc	a0,0x4
  4014f4:	6c050513          	addi	a0,a0,1728 # 405bb0 <malloc+0x9d8>
  4014f8:	427030ef          	jal	40511e <printf>
    exit(1);
  4014fc:	4505                	li	a0,1
  4014fe:	005030ef          	jal	404d02 <exit>
  unlink("echo-ok");
  401502:	00004517          	auipc	a0,0x4
  401506:	72650513          	addi	a0,a0,1830 # 405c28 <malloc+0xa50>
  40150a:	049030ef          	jal	404d52 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
  40150e:	fb844703          	lbu	a4,-72(s0)
  401512:	04f00793          	li	a5,79
  401516:	00f71863          	bne	a4,a5,401526 <exectest+0x15c>
  40151a:	fb944703          	lbu	a4,-71(s0)
  40151e:	04b00793          	li	a5,75
  401522:	00f70c63          	beq	a4,a5,40153a <exectest+0x170>
    printf("%s: wrong output\n", s);
  401526:	85ca                	mv	a1,s2
  401528:	00004517          	auipc	a0,0x4
  40152c:	76050513          	addi	a0,a0,1888 # 405c88 <malloc+0xab0>
  401530:	3ef030ef          	jal	40511e <printf>
    exit(1);
  401534:	4505                	li	a0,1
  401536:	7cc030ef          	jal	404d02 <exit>
    exit(0);
  40153a:	4501                	li	a0,0
  40153c:	7c6030ef          	jal	404d02 <exit>

0000000000401540 <pipe1>:
{
  401540:	711d                	addi	sp,sp,-96
  401542:	ec86                	sd	ra,88(sp)
  401544:	e8a2                	sd	s0,80(sp)
  401546:	e0ca                	sd	s2,64(sp)
  401548:	1080                	addi	s0,sp,96
  40154a:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
  40154c:	fa840513          	addi	a0,s0,-88
  401550:	7c2030ef          	jal	404d12 <pipe>
  401554:	e53d                	bnez	a0,4015c2 <pipe1+0x82>
  401556:	e4a6                	sd	s1,72(sp)
  401558:	f852                	sd	s4,48(sp)
  40155a:	84aa                	mv	s1,a0
  pid = fork();
  40155c:	79e030ef          	jal	404cfa <fork>
  401560:	8a2a                	mv	s4,a0
  if(pid == 0){
  401562:	c149                	beqz	a0,4015e4 <pipe1+0xa4>
  } else if(pid > 0){
  401564:	14a05f63          	blez	a0,4016c2 <pipe1+0x182>
  401568:	fc4e                	sd	s3,56(sp)
  40156a:	f456                	sd	s5,40(sp)
    close(fds[1]);
  40156c:	fac42503          	lw	a0,-84(s0)
  401570:	7ba030ef          	jal	404d2a <close>
    total = 0;
  401574:	8a26                	mv	s4,s1
    cc = 1;
  401576:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
  401578:	0000ba97          	auipc	s5,0xb
  40157c:	700a8a93          	addi	s5,s5,1792 # 40cc78 <buf>
  401580:	864e                	mv	a2,s3
  401582:	85d6                	mv	a1,s5
  401584:	fa842503          	lw	a0,-88(s0)
  401588:	792030ef          	jal	404d1a <read>
  40158c:	0ea05963          	blez	a0,40167e <pipe1+0x13e>
  401590:	0000b717          	auipc	a4,0xb
  401594:	6e870713          	addi	a4,a4,1768 # 40cc78 <buf>
  401598:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
  40159c:	00074683          	lbu	a3,0(a4)
  4015a0:	0ff4f793          	zext.b	a5,s1
  4015a4:	2485                	addiw	s1,s1,1
  4015a6:	0af69c63          	bne	a3,a5,40165e <pipe1+0x11e>
      for(i = 0; i < n; i++){
  4015aa:	0705                	addi	a4,a4,1
  4015ac:	fec498e3          	bne	s1,a2,40159c <pipe1+0x5c>
      total += n;
  4015b0:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
  4015b4:	0019999b          	slliw	s3,s3,0x1
      if(cc > sizeof(buf))
  4015b8:	678d                	lui	a5,0x3
  4015ba:	fd37f3e3          	bgeu	a5,s3,401580 <pipe1+0x40>
        cc = sizeof(buf);
  4015be:	89be                	mv	s3,a5
  4015c0:	b7c1                	j	401580 <pipe1+0x40>
  4015c2:	e4a6                	sd	s1,72(sp)
  4015c4:	fc4e                	sd	s3,56(sp)
  4015c6:	f852                	sd	s4,48(sp)
  4015c8:	f456                	sd	s5,40(sp)
  4015ca:	f05a                	sd	s6,32(sp)
  4015cc:	ec5e                	sd	s7,24(sp)
  4015ce:	e862                	sd	s8,16(sp)
    printf("%s: pipe() failed\n", s);
  4015d0:	85ca                	mv	a1,s2
  4015d2:	00004517          	auipc	a0,0x4
  4015d6:	6ce50513          	addi	a0,a0,1742 # 405ca0 <malloc+0xac8>
  4015da:	345030ef          	jal	40511e <printf>
    exit(1);
  4015de:	4505                	li	a0,1
  4015e0:	722030ef          	jal	404d02 <exit>
  4015e4:	fc4e                	sd	s3,56(sp)
  4015e6:	f456                	sd	s5,40(sp)
  4015e8:	f05a                	sd	s6,32(sp)
  4015ea:	ec5e                	sd	s7,24(sp)
  4015ec:	e862                	sd	s8,16(sp)
    close(fds[0]);
  4015ee:	fa842503          	lw	a0,-88(s0)
  4015f2:	738030ef          	jal	404d2a <close>
    for(n = 0; n < N; n++){
  4015f6:	0000bb97          	auipc	s7,0xb
  4015fa:	682b8b93          	addi	s7,s7,1666 # 40cc78 <buf>
  4015fe:	417004bb          	negw	s1,s7
  401602:	0ff4f493          	zext.b	s1,s1
  401606:	409b8993          	addi	s3,s7,1033
      if(write(fds[1], buf, SZ) != SZ){
  40160a:	40900a93          	li	s5,1033
  40160e:	8c5e                	mv	s8,s7
    for(n = 0; n < N; n++){
  401610:	6b05                	lui	s6,0x1
  401612:	42db0b13          	addi	s6,s6,1069 # 142d <copyinstr1-0x3febd3>
{
  401616:	87de                	mv	a5,s7
        buf[i] = seq++;
  401618:	0097873b          	addw	a4,a5,s1
  40161c:	00e78023          	sb	a4,0(a5) # 3000 <copyinstr1-0x3fd000>
      for(i = 0; i < SZ; i++)
  401620:	0785                	addi	a5,a5,1
  401622:	ff379be3          	bne	a5,s3,401618 <pipe1+0xd8>
  401626:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
  40162a:	8656                	mv	a2,s5
  40162c:	85e2                	mv	a1,s8
  40162e:	fac42503          	lw	a0,-84(s0)
  401632:	6f0030ef          	jal	404d22 <write>
  401636:	01551a63          	bne	a0,s5,40164a <pipe1+0x10a>
    for(n = 0; n < N; n++){
  40163a:	24a5                	addiw	s1,s1,9
  40163c:	0ff4f493          	zext.b	s1,s1
  401640:	fd6a1be3          	bne	s4,s6,401616 <pipe1+0xd6>
    exit(0);
  401644:	4501                	li	a0,0
  401646:	6bc030ef          	jal	404d02 <exit>
        printf("%s: pipe1 oops 1\n", s);
  40164a:	85ca                	mv	a1,s2
  40164c:	00004517          	auipc	a0,0x4
  401650:	66c50513          	addi	a0,a0,1644 # 405cb8 <malloc+0xae0>
  401654:	2cb030ef          	jal	40511e <printf>
        exit(1);
  401658:	4505                	li	a0,1
  40165a:	6a8030ef          	jal	404d02 <exit>
          printf("%s: pipe1 oops 2\n", s);
  40165e:	85ca                	mv	a1,s2
  401660:	00004517          	auipc	a0,0x4
  401664:	67050513          	addi	a0,a0,1648 # 405cd0 <malloc+0xaf8>
  401668:	2b7030ef          	jal	40511e <printf>
          return;
  40166c:	64a6                	ld	s1,72(sp)
  40166e:	79e2                	ld	s3,56(sp)
  401670:	7a42                	ld	s4,48(sp)
  401672:	7aa2                	ld	s5,40(sp)
}
  401674:	60e6                	ld	ra,88(sp)
  401676:	6446                	ld	s0,80(sp)
  401678:	6906                	ld	s2,64(sp)
  40167a:	6125                	addi	sp,sp,96
  40167c:	8082                	ret
    if(total != N * SZ){
  40167e:	6785                	lui	a5,0x1
  401680:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr1-0x3febd3>
  401684:	02fa0063          	beq	s4,a5,4016a4 <pipe1+0x164>
  401688:	f05a                	sd	s6,32(sp)
  40168a:	ec5e                	sd	s7,24(sp)
  40168c:	e862                	sd	s8,16(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
  40168e:	8652                	mv	a2,s4
  401690:	85ca                	mv	a1,s2
  401692:	00004517          	auipc	a0,0x4
  401696:	65650513          	addi	a0,a0,1622 # 405ce8 <malloc+0xb10>
  40169a:	285030ef          	jal	40511e <printf>
      exit(1);
  40169e:	4505                	li	a0,1
  4016a0:	662030ef          	jal	404d02 <exit>
  4016a4:	f05a                	sd	s6,32(sp)
  4016a6:	ec5e                	sd	s7,24(sp)
  4016a8:	e862                	sd	s8,16(sp)
    close(fds[0]);
  4016aa:	fa842503          	lw	a0,-88(s0)
  4016ae:	67c030ef          	jal	404d2a <close>
    wait(&xstatus);
  4016b2:	fa440513          	addi	a0,s0,-92
  4016b6:	654030ef          	jal	404d0a <wait>
    exit(xstatus);
  4016ba:	fa442503          	lw	a0,-92(s0)
  4016be:	644030ef          	jal	404d02 <exit>
  4016c2:	fc4e                	sd	s3,56(sp)
  4016c4:	f456                	sd	s5,40(sp)
  4016c6:	f05a                	sd	s6,32(sp)
  4016c8:	ec5e                	sd	s7,24(sp)
  4016ca:	e862                	sd	s8,16(sp)
    printf("%s: fork() failed\n", s);
  4016cc:	85ca                	mv	a1,s2
  4016ce:	00004517          	auipc	a0,0x4
  4016d2:	63a50513          	addi	a0,a0,1594 # 405d08 <malloc+0xb30>
  4016d6:	249030ef          	jal	40511e <printf>
    exit(1);
  4016da:	4505                	li	a0,1
  4016dc:	626030ef          	jal	404d02 <exit>

00000000004016e0 <exitwait>:
{
  4016e0:	715d                	addi	sp,sp,-80
  4016e2:	e486                	sd	ra,72(sp)
  4016e4:	e0a2                	sd	s0,64(sp)
  4016e6:	fc26                	sd	s1,56(sp)
  4016e8:	f84a                	sd	s2,48(sp)
  4016ea:	f44e                	sd	s3,40(sp)
  4016ec:	f052                	sd	s4,32(sp)
  4016ee:	ec56                	sd	s5,24(sp)
  4016f0:	0880                	addi	s0,sp,80
  4016f2:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
  4016f4:	4901                	li	s2,0
      if(wait(&xstate) != pid){
  4016f6:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
  4016fa:	06400a13          	li	s4,100
    pid = fork();
  4016fe:	5fc030ef          	jal	404cfa <fork>
  401702:	84aa                	mv	s1,a0
    if(pid < 0){
  401704:	02054863          	bltz	a0,401734 <exitwait+0x54>
    if(pid){
  401708:	c525                	beqz	a0,401770 <exitwait+0x90>
      if(wait(&xstate) != pid){
  40170a:	854e                	mv	a0,s3
  40170c:	5fe030ef          	jal	404d0a <wait>
  401710:	02951c63          	bne	a0,s1,401748 <exitwait+0x68>
      if(i != xstate) {
  401714:	fbc42783          	lw	a5,-68(s0)
  401718:	05279263          	bne	a5,s2,40175c <exitwait+0x7c>
  for(i = 0; i < 100; i++){
  40171c:	2905                	addiw	s2,s2,1
  40171e:	ff4910e3          	bne	s2,s4,4016fe <exitwait+0x1e>
}
  401722:	60a6                	ld	ra,72(sp)
  401724:	6406                	ld	s0,64(sp)
  401726:	74e2                	ld	s1,56(sp)
  401728:	7942                	ld	s2,48(sp)
  40172a:	79a2                	ld	s3,40(sp)
  40172c:	7a02                	ld	s4,32(sp)
  40172e:	6ae2                	ld	s5,24(sp)
  401730:	6161                	addi	sp,sp,80
  401732:	8082                	ret
      printf("%s: fork failed\n", s);
  401734:	85d6                	mv	a1,s5
  401736:	00004517          	auipc	a0,0x4
  40173a:	46250513          	addi	a0,a0,1122 # 405b98 <malloc+0x9c0>
  40173e:	1e1030ef          	jal	40511e <printf>
      exit(1);
  401742:	4505                	li	a0,1
  401744:	5be030ef          	jal	404d02 <exit>
        printf("%s: wait wrong pid\n", s);
  401748:	85d6                	mv	a1,s5
  40174a:	00004517          	auipc	a0,0x4
  40174e:	5d650513          	addi	a0,a0,1494 # 405d20 <malloc+0xb48>
  401752:	1cd030ef          	jal	40511e <printf>
        exit(1);
  401756:	4505                	li	a0,1
  401758:	5aa030ef          	jal	404d02 <exit>
        printf("%s: wait wrong exit status\n", s);
  40175c:	85d6                	mv	a1,s5
  40175e:	00004517          	auipc	a0,0x4
  401762:	5da50513          	addi	a0,a0,1498 # 405d38 <malloc+0xb60>
  401766:	1b9030ef          	jal	40511e <printf>
        exit(1);
  40176a:	4505                	li	a0,1
  40176c:	596030ef          	jal	404d02 <exit>
      exit(i);
  401770:	854a                	mv	a0,s2
  401772:	590030ef          	jal	404d02 <exit>

0000000000401776 <twochildren>:
{
  401776:	1101                	addi	sp,sp,-32
  401778:	ec06                	sd	ra,24(sp)
  40177a:	e822                	sd	s0,16(sp)
  40177c:	e426                	sd	s1,8(sp)
  40177e:	e04a                	sd	s2,0(sp)
  401780:	1000                	addi	s0,sp,32
  401782:	892a                	mv	s2,a0
  401784:	3e800493          	li	s1,1000
    int pid1 = fork();
  401788:	572030ef          	jal	404cfa <fork>
    if(pid1 < 0){
  40178c:	02054663          	bltz	a0,4017b8 <twochildren+0x42>
    if(pid1 == 0){
  401790:	cd15                	beqz	a0,4017cc <twochildren+0x56>
      int pid2 = fork();
  401792:	568030ef          	jal	404cfa <fork>
      if(pid2 < 0){
  401796:	02054d63          	bltz	a0,4017d0 <twochildren+0x5a>
      if(pid2 == 0){
  40179a:	c529                	beqz	a0,4017e4 <twochildren+0x6e>
        wait(0);
  40179c:	4501                	li	a0,0
  40179e:	56c030ef          	jal	404d0a <wait>
        wait(0);
  4017a2:	4501                	li	a0,0
  4017a4:	566030ef          	jal	404d0a <wait>
  for(int i = 0; i < 1000; i++){
  4017a8:	34fd                	addiw	s1,s1,-1
  4017aa:	fcf9                	bnez	s1,401788 <twochildren+0x12>
}
  4017ac:	60e2                	ld	ra,24(sp)
  4017ae:	6442                	ld	s0,16(sp)
  4017b0:	64a2                	ld	s1,8(sp)
  4017b2:	6902                	ld	s2,0(sp)
  4017b4:	6105                	addi	sp,sp,32
  4017b6:	8082                	ret
      printf("%s: fork failed\n", s);
  4017b8:	85ca                	mv	a1,s2
  4017ba:	00004517          	auipc	a0,0x4
  4017be:	3de50513          	addi	a0,a0,990 # 405b98 <malloc+0x9c0>
  4017c2:	15d030ef          	jal	40511e <printf>
      exit(1);
  4017c6:	4505                	li	a0,1
  4017c8:	53a030ef          	jal	404d02 <exit>
      exit(0);
  4017cc:	536030ef          	jal	404d02 <exit>
        printf("%s: fork failed\n", s);
  4017d0:	85ca                	mv	a1,s2
  4017d2:	00004517          	auipc	a0,0x4
  4017d6:	3c650513          	addi	a0,a0,966 # 405b98 <malloc+0x9c0>
  4017da:	145030ef          	jal	40511e <printf>
        exit(1);
  4017de:	4505                	li	a0,1
  4017e0:	522030ef          	jal	404d02 <exit>
        exit(0);
  4017e4:	51e030ef          	jal	404d02 <exit>

00000000004017e8 <forkfork>:
{
  4017e8:	7179                	addi	sp,sp,-48
  4017ea:	f406                	sd	ra,40(sp)
  4017ec:	f022                	sd	s0,32(sp)
  4017ee:	ec26                	sd	s1,24(sp)
  4017f0:	1800                	addi	s0,sp,48
  4017f2:	84aa                	mv	s1,a0
    int pid = fork();
  4017f4:	506030ef          	jal	404cfa <fork>
    if(pid < 0){
  4017f8:	02054b63          	bltz	a0,40182e <forkfork+0x46>
    if(pid == 0){
  4017fc:	c139                	beqz	a0,401842 <forkfork+0x5a>
    int pid = fork();
  4017fe:	4fc030ef          	jal	404cfa <fork>
    if(pid < 0){
  401802:	02054663          	bltz	a0,40182e <forkfork+0x46>
    if(pid == 0){
  401806:	cd15                	beqz	a0,401842 <forkfork+0x5a>
    wait(&xstatus);
  401808:	fdc40513          	addi	a0,s0,-36
  40180c:	4fe030ef          	jal	404d0a <wait>
    if(xstatus != 0) {
  401810:	fdc42783          	lw	a5,-36(s0)
  401814:	ebb9                	bnez	a5,40186a <forkfork+0x82>
    wait(&xstatus);
  401816:	fdc40513          	addi	a0,s0,-36
  40181a:	4f0030ef          	jal	404d0a <wait>
    if(xstatus != 0) {
  40181e:	fdc42783          	lw	a5,-36(s0)
  401822:	e7a1                	bnez	a5,40186a <forkfork+0x82>
}
  401824:	70a2                	ld	ra,40(sp)
  401826:	7402                	ld	s0,32(sp)
  401828:	64e2                	ld	s1,24(sp)
  40182a:	6145                	addi	sp,sp,48
  40182c:	8082                	ret
      printf("%s: fork failed", s);
  40182e:	85a6                	mv	a1,s1
  401830:	00004517          	auipc	a0,0x4
  401834:	52850513          	addi	a0,a0,1320 # 405d58 <malloc+0xb80>
  401838:	0e7030ef          	jal	40511e <printf>
      exit(1);
  40183c:	4505                	li	a0,1
  40183e:	4c4030ef          	jal	404d02 <exit>
{
  401842:	0c800493          	li	s1,200
        int pid1 = fork();
  401846:	4b4030ef          	jal	404cfa <fork>
        if(pid1 < 0){
  40184a:	00054b63          	bltz	a0,401860 <forkfork+0x78>
        if(pid1 == 0){
  40184e:	cd01                	beqz	a0,401866 <forkfork+0x7e>
        wait(0);
  401850:	4501                	li	a0,0
  401852:	4b8030ef          	jal	404d0a <wait>
      for(int j = 0; j < 200; j++){
  401856:	34fd                	addiw	s1,s1,-1
  401858:	f4fd                	bnez	s1,401846 <forkfork+0x5e>
      exit(0);
  40185a:	4501                	li	a0,0
  40185c:	4a6030ef          	jal	404d02 <exit>
          exit(1);
  401860:	4505                	li	a0,1
  401862:	4a0030ef          	jal	404d02 <exit>
          exit(0);
  401866:	49c030ef          	jal	404d02 <exit>
      printf("%s: fork in child failed", s);
  40186a:	85a6                	mv	a1,s1
  40186c:	00004517          	auipc	a0,0x4
  401870:	4fc50513          	addi	a0,a0,1276 # 405d68 <malloc+0xb90>
  401874:	0ab030ef          	jal	40511e <printf>
      exit(1);
  401878:	4505                	li	a0,1
  40187a:	488030ef          	jal	404d02 <exit>

000000000040187e <reparent2>:
{
  40187e:	1101                	addi	sp,sp,-32
  401880:	ec06                	sd	ra,24(sp)
  401882:	e822                	sd	s0,16(sp)
  401884:	e426                	sd	s1,8(sp)
  401886:	1000                	addi	s0,sp,32
  401888:	32000493          	li	s1,800
    int pid1 = fork();
  40188c:	46e030ef          	jal	404cfa <fork>
    if(pid1 < 0){
  401890:	00054b63          	bltz	a0,4018a6 <reparent2+0x28>
    if(pid1 == 0){
  401894:	c115                	beqz	a0,4018b8 <reparent2+0x3a>
    wait(0);
  401896:	4501                	li	a0,0
  401898:	472030ef          	jal	404d0a <wait>
  for(int i = 0; i < 800; i++){
  40189c:	34fd                	addiw	s1,s1,-1
  40189e:	f4fd                	bnez	s1,40188c <reparent2+0xe>
  exit(0);
  4018a0:	4501                	li	a0,0
  4018a2:	460030ef          	jal	404d02 <exit>
      printf("fork failed\n");
  4018a6:	00006517          	auipc	a0,0x6
  4018aa:	86250513          	addi	a0,a0,-1950 # 407108 <malloc+0x1f30>
  4018ae:	071030ef          	jal	40511e <printf>
      exit(1);
  4018b2:	4505                	li	a0,1
  4018b4:	44e030ef          	jal	404d02 <exit>
      fork();
  4018b8:	442030ef          	jal	404cfa <fork>
      fork();
  4018bc:	43e030ef          	jal	404cfa <fork>
      exit(0);
  4018c0:	4501                	li	a0,0
  4018c2:	440030ef          	jal	404d02 <exit>

00000000004018c6 <createdelete>:
{
  4018c6:	7175                	addi	sp,sp,-144
  4018c8:	e506                	sd	ra,136(sp)
  4018ca:	e122                	sd	s0,128(sp)
  4018cc:	fca6                	sd	s1,120(sp)
  4018ce:	f8ca                	sd	s2,112(sp)
  4018d0:	f4ce                	sd	s3,104(sp)
  4018d2:	f0d2                	sd	s4,96(sp)
  4018d4:	ecd6                	sd	s5,88(sp)
  4018d6:	e8da                	sd	s6,80(sp)
  4018d8:	e4de                	sd	s7,72(sp)
  4018da:	e0e2                	sd	s8,64(sp)
  4018dc:	fc66                	sd	s9,56(sp)
  4018de:	f86a                	sd	s10,48(sp)
  4018e0:	0900                	addi	s0,sp,144
  4018e2:	8d2a                	mv	s10,a0
  for(pi = 0; pi < NCHILD; pi++){
  4018e4:	4901                	li	s2,0
  4018e6:	4991                	li	s3,4
    pid = fork();
  4018e8:	412030ef          	jal	404cfa <fork>
  4018ec:	84aa                	mv	s1,a0
    if(pid < 0){
  4018ee:	02054e63          	bltz	a0,40192a <createdelete+0x64>
    if(pid == 0){
  4018f2:	c531                	beqz	a0,40193e <createdelete+0x78>
  for(pi = 0; pi < NCHILD; pi++){
  4018f4:	2905                	addiw	s2,s2,1
  4018f6:	ff3919e3          	bne	s2,s3,4018e8 <createdelete+0x22>
  4018fa:	4491                	li	s1,4
    wait(&xstatus);
  4018fc:	f7c40993          	addi	s3,s0,-132
  401900:	854e                	mv	a0,s3
  401902:	408030ef          	jal	404d0a <wait>
    if(xstatus != 0)
  401906:	f7c42903          	lw	s2,-132(s0)
  40190a:	0c091063          	bnez	s2,4019ca <createdelete+0x104>
  for(pi = 0; pi < NCHILD; pi++){
  40190e:	34fd                	addiw	s1,s1,-1
  401910:	f8e5                	bnez	s1,401900 <createdelete+0x3a>
  name[0] = name[1] = name[2] = 0;
  401912:	f8040123          	sb	zero,-126(s0)
  401916:	03000993          	li	s3,48
  40191a:	5afd                	li	s5,-1
  40191c:	07000c93          	li	s9,112
      if((i == 0 || i >= N/2) && fd < 0){
  401920:	4ba5                	li	s7,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
  401922:	4c21                	li	s8,8
    for(pi = 0; pi < NCHILD; pi++){
  401924:	07400b13          	li	s6,116
  401928:	a205                	j	401a48 <createdelete+0x182>
      printf("%s: fork failed\n", s);
  40192a:	85ea                	mv	a1,s10
  40192c:	00004517          	auipc	a0,0x4
  401930:	26c50513          	addi	a0,a0,620 # 405b98 <malloc+0x9c0>
  401934:	7ea030ef          	jal	40511e <printf>
      exit(1);
  401938:	4505                	li	a0,1
  40193a:	3c8030ef          	jal	404d02 <exit>
      name[0] = 'p' + pi;
  40193e:	0709091b          	addiw	s2,s2,112
  401942:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
  401946:	f8040123          	sb	zero,-126(s0)
        fd = open(name, O_CREATE | O_RDWR);
  40194a:	f8040913          	addi	s2,s0,-128
  40194e:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
  401952:	4a51                	li	s4,20
  401954:	a815                	j	401988 <createdelete+0xc2>
          printf("%s: create failed\n", s);
  401956:	85ea                	mv	a1,s10
  401958:	00004517          	auipc	a0,0x4
  40195c:	2d850513          	addi	a0,a0,728 # 405c30 <malloc+0xa58>
  401960:	7be030ef          	jal	40511e <printf>
          exit(1);
  401964:	4505                	li	a0,1
  401966:	39c030ef          	jal	404d02 <exit>
          name[1] = '0' + (i / 2);
  40196a:	01f4d79b          	srliw	a5,s1,0x1f
  40196e:	9fa5                	addw	a5,a5,s1
  401970:	4017d79b          	sraiw	a5,a5,0x1
  401974:	0307879b          	addiw	a5,a5,48
  401978:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
  40197c:	854a                	mv	a0,s2
  40197e:	3d4030ef          	jal	404d52 <unlink>
  401982:	02054a63          	bltz	a0,4019b6 <createdelete+0xf0>
      for(i = 0; i < N; i++){
  401986:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
  401988:	0304879b          	addiw	a5,s1,48
  40198c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
  401990:	85ce                	mv	a1,s3
  401992:	854a                	mv	a0,s2
  401994:	3ae030ef          	jal	404d42 <open>
        if(fd < 0){
  401998:	fa054fe3          	bltz	a0,401956 <createdelete+0x90>
        close(fd);
  40199c:	38e030ef          	jal	404d2a <close>
        if(i > 0 && (i % 2 ) == 0){
  4019a0:	fe9053e3          	blez	s1,401986 <createdelete+0xc0>
  4019a4:	0014f793          	andi	a5,s1,1
  4019a8:	d3e9                	beqz	a5,40196a <createdelete+0xa4>
      for(i = 0; i < N; i++){
  4019aa:	2485                	addiw	s1,s1,1
  4019ac:	fd449ee3          	bne	s1,s4,401988 <createdelete+0xc2>
      exit(0);
  4019b0:	4501                	li	a0,0
  4019b2:	350030ef          	jal	404d02 <exit>
            printf("%s: unlink failed\n", s);
  4019b6:	85ea                	mv	a1,s10
  4019b8:	00004517          	auipc	a0,0x4
  4019bc:	3d050513          	addi	a0,a0,976 # 405d88 <malloc+0xbb0>
  4019c0:	75e030ef          	jal	40511e <printf>
            exit(1);
  4019c4:	4505                	li	a0,1
  4019c6:	33c030ef          	jal	404d02 <exit>
      exit(1);
  4019ca:	4505                	li	a0,1
  4019cc:	336030ef          	jal	404d02 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
  4019d0:	f8040613          	addi	a2,s0,-128
  4019d4:	85ea                	mv	a1,s10
  4019d6:	00004517          	auipc	a0,0x4
  4019da:	3ca50513          	addi	a0,a0,970 # 405da0 <malloc+0xbc8>
  4019de:	740030ef          	jal	40511e <printf>
        exit(1);
  4019e2:	4505                	li	a0,1
  4019e4:	31e030ef          	jal	404d02 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
  4019e8:	035c7a63          	bgeu	s8,s5,401a1c <createdelete+0x156>
      if(fd >= 0)
  4019ec:	02055563          	bgez	a0,401a16 <createdelete+0x150>
    for(pi = 0; pi < NCHILD; pi++){
  4019f0:	2485                	addiw	s1,s1,1
  4019f2:	0ff4f493          	zext.b	s1,s1
  4019f6:	05648163          	beq	s1,s6,401a38 <createdelete+0x172>
      name[0] = 'p' + pi;
  4019fa:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
  4019fe:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
  401a02:	4581                	li	a1,0
  401a04:	8552                	mv	a0,s4
  401a06:	33c030ef          	jal	404d42 <open>
      if((i == 0 || i >= N/2) && fd < 0){
  401a0a:	00090463          	beqz	s2,401a12 <createdelete+0x14c>
  401a0e:	fd2bdde3          	bge	s7,s2,4019e8 <createdelete+0x122>
  401a12:	fa054fe3          	bltz	a0,4019d0 <createdelete+0x10a>
        close(fd);
  401a16:	314030ef          	jal	404d2a <close>
  401a1a:	bfd9                	j	4019f0 <createdelete+0x12a>
      } else if((i >= 1 && i < N/2) && fd >= 0){
  401a1c:	fc054ae3          	bltz	a0,4019f0 <createdelete+0x12a>
        printf("%s: oops createdelete %s did exist\n", s, name);
  401a20:	f8040613          	addi	a2,s0,-128
  401a24:	85ea                	mv	a1,s10
  401a26:	00004517          	auipc	a0,0x4
  401a2a:	3a250513          	addi	a0,a0,930 # 405dc8 <malloc+0xbf0>
  401a2e:	6f0030ef          	jal	40511e <printf>
        exit(1);
  401a32:	4505                	li	a0,1
  401a34:	2ce030ef          	jal	404d02 <exit>
  for(i = 0; i < N; i++){
  401a38:	2905                	addiw	s2,s2,1
  401a3a:	2a85                	addiw	s5,s5,1
  401a3c:	2985                	addiw	s3,s3,1
  401a3e:	0ff9f993          	zext.b	s3,s3
  401a42:	47d1                	li	a5,20
  401a44:	00f90663          	beq	s2,a5,401a50 <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
  401a48:	84e6                	mv	s1,s9
      fd = open(name, 0);
  401a4a:	f8040a13          	addi	s4,s0,-128
  401a4e:	b775                	j	4019fa <createdelete+0x134>
  401a50:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
  401a54:	07000b13          	li	s6,112
      unlink(name);
  401a58:	f8040a13          	addi	s4,s0,-128
    for(pi = 0; pi < NCHILD; pi++){
  401a5c:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
  401a60:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
  401a64:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
  401a66:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
  401a6a:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
  401a6e:	8552                	mv	a0,s4
  401a70:	2e2030ef          	jal	404d52 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
  401a74:	2485                	addiw	s1,s1,1
  401a76:	0ff4f493          	zext.b	s1,s1
  401a7a:	ff3496e3          	bne	s1,s3,401a66 <createdelete+0x1a0>
  for(i = 0; i < N; i++){
  401a7e:	2905                	addiw	s2,s2,1
  401a80:	0ff97913          	zext.b	s2,s2
  401a84:	ff5910e3          	bne	s2,s5,401a64 <createdelete+0x19e>
}
  401a88:	60aa                	ld	ra,136(sp)
  401a8a:	640a                	ld	s0,128(sp)
  401a8c:	74e6                	ld	s1,120(sp)
  401a8e:	7946                	ld	s2,112(sp)
  401a90:	79a6                	ld	s3,104(sp)
  401a92:	7a06                	ld	s4,96(sp)
  401a94:	6ae6                	ld	s5,88(sp)
  401a96:	6b46                	ld	s6,80(sp)
  401a98:	6ba6                	ld	s7,72(sp)
  401a9a:	6c06                	ld	s8,64(sp)
  401a9c:	7ce2                	ld	s9,56(sp)
  401a9e:	7d42                	ld	s10,48(sp)
  401aa0:	6149                	addi	sp,sp,144
  401aa2:	8082                	ret

0000000000401aa4 <linkunlink>:
{
  401aa4:	711d                	addi	sp,sp,-96
  401aa6:	ec86                	sd	ra,88(sp)
  401aa8:	e8a2                	sd	s0,80(sp)
  401aaa:	e4a6                	sd	s1,72(sp)
  401aac:	e0ca                	sd	s2,64(sp)
  401aae:	fc4e                	sd	s3,56(sp)
  401ab0:	f852                	sd	s4,48(sp)
  401ab2:	f456                	sd	s5,40(sp)
  401ab4:	f05a                	sd	s6,32(sp)
  401ab6:	ec5e                	sd	s7,24(sp)
  401ab8:	e862                	sd	s8,16(sp)
  401aba:	e466                	sd	s9,8(sp)
  401abc:	e06a                	sd	s10,0(sp)
  401abe:	1080                	addi	s0,sp,96
  401ac0:	84aa                	mv	s1,a0
  unlink("x");
  401ac2:	00004517          	auipc	a0,0x4
  401ac6:	8b650513          	addi	a0,a0,-1866 # 405378 <malloc+0x1a0>
  401aca:	288030ef          	jal	404d52 <unlink>
  pid = fork();
  401ace:	22c030ef          	jal	404cfa <fork>
  if(pid < 0){
  401ad2:	04054363          	bltz	a0,401b18 <linkunlink+0x74>
  401ad6:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
  401ad8:	06100913          	li	s2,97
  401adc:	c111                	beqz	a0,401ae0 <linkunlink+0x3c>
  401ade:	4905                	li	s2,1
  401ae0:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
  401ae4:	41c65ab7          	lui	s5,0x41c65
  401ae8:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x418551f5>
  401aec:	6a0d                	lui	s4,0x3
  401aee:	039a0a1b          	addiw	s4,s4,57 # 3039 <copyinstr1-0x3fcfc7>
    if((x % 3) == 0){
  401af2:	000ab9b7          	lui	s3,0xab
  401af6:	aab98993          	addi	s3,s3,-1365 # aaaab <copyinstr1-0x355555>
  401afa:	09b2                	slli	s3,s3,0xc
  401afc:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
  401b00:	4b85                	li	s7,1
      unlink("x");
  401b02:	00004b17          	auipc	s6,0x4
  401b06:	876b0b13          	addi	s6,s6,-1930 # 405378 <malloc+0x1a0>
      link("cat", "x");
  401b0a:	00004c97          	auipc	s9,0x4
  401b0e:	2e6c8c93          	addi	s9,s9,742 # 405df0 <malloc+0xc18>
      close(open("x", O_RDWR | O_CREATE));
  401b12:	20200c13          	li	s8,514
  401b16:	a03d                	j	401b44 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
  401b18:	85a6                	mv	a1,s1
  401b1a:	00004517          	auipc	a0,0x4
  401b1e:	07e50513          	addi	a0,a0,126 # 405b98 <malloc+0x9c0>
  401b22:	5fc030ef          	jal	40511e <printf>
    exit(1);
  401b26:	4505                	li	a0,1
  401b28:	1da030ef          	jal	404d02 <exit>
      close(open("x", O_RDWR | O_CREATE));
  401b2c:	85e2                	mv	a1,s8
  401b2e:	855a                	mv	a0,s6
  401b30:	212030ef          	jal	404d42 <open>
  401b34:	1f6030ef          	jal	404d2a <close>
  401b38:	a021                	j	401b40 <linkunlink+0x9c>
      unlink("x");
  401b3a:	855a                	mv	a0,s6
  401b3c:	216030ef          	jal	404d52 <unlink>
  for(i = 0; i < 100; i++){
  401b40:	34fd                	addiw	s1,s1,-1
  401b42:	c885                	beqz	s1,401b72 <linkunlink+0xce>
    x = x * 1103515245 + 12345;
  401b44:	035907bb          	mulw	a5,s2,s5
  401b48:	00fa07bb          	addw	a5,s4,a5
  401b4c:	893e                	mv	s2,a5
    if((x % 3) == 0){
  401b4e:	02079713          	slli	a4,a5,0x20
  401b52:	9301                	srli	a4,a4,0x20
  401b54:	03370733          	mul	a4,a4,s3
  401b58:	9305                	srli	a4,a4,0x21
  401b5a:	0017169b          	slliw	a3,a4,0x1
  401b5e:	9f35                	addw	a4,a4,a3
  401b60:	9f99                	subw	a5,a5,a4
  401b62:	d7e9                	beqz	a5,401b2c <linkunlink+0x88>
    } else if((x % 3) == 1){
  401b64:	fd779be3          	bne	a5,s7,401b3a <linkunlink+0x96>
      link("cat", "x");
  401b68:	85da                	mv	a1,s6
  401b6a:	8566                	mv	a0,s9
  401b6c:	1f6030ef          	jal	404d62 <link>
  401b70:	bfc1                	j	401b40 <linkunlink+0x9c>
  if(pid)
  401b72:	020d0363          	beqz	s10,401b98 <linkunlink+0xf4>
    wait(0);
  401b76:	4501                	li	a0,0
  401b78:	192030ef          	jal	404d0a <wait>
}
  401b7c:	60e6                	ld	ra,88(sp)
  401b7e:	6446                	ld	s0,80(sp)
  401b80:	64a6                	ld	s1,72(sp)
  401b82:	6906                	ld	s2,64(sp)
  401b84:	79e2                	ld	s3,56(sp)
  401b86:	7a42                	ld	s4,48(sp)
  401b88:	7aa2                	ld	s5,40(sp)
  401b8a:	7b02                	ld	s6,32(sp)
  401b8c:	6be2                	ld	s7,24(sp)
  401b8e:	6c42                	ld	s8,16(sp)
  401b90:	6ca2                	ld	s9,8(sp)
  401b92:	6d02                	ld	s10,0(sp)
  401b94:	6125                	addi	sp,sp,96
  401b96:	8082                	ret
    exit(0);
  401b98:	4501                	li	a0,0
  401b9a:	168030ef          	jal	404d02 <exit>

0000000000401b9e <forktest>:
{
  401b9e:	7179                	addi	sp,sp,-48
  401ba0:	f406                	sd	ra,40(sp)
  401ba2:	f022                	sd	s0,32(sp)
  401ba4:	ec26                	sd	s1,24(sp)
  401ba6:	e84a                	sd	s2,16(sp)
  401ba8:	e44e                	sd	s3,8(sp)
  401baa:	1800                	addi	s0,sp,48
  401bac:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
  401bae:	4481                	li	s1,0
  401bb0:	3e800913          	li	s2,1000
    pid = fork();
  401bb4:	146030ef          	jal	404cfa <fork>
    if(pid < 0)
  401bb8:	06054063          	bltz	a0,401c18 <forktest+0x7a>
    if(pid == 0)
  401bbc:	cd11                	beqz	a0,401bd8 <forktest+0x3a>
  for(n=0; n<N; n++){
  401bbe:	2485                	addiw	s1,s1,1
  401bc0:	ff249ae3          	bne	s1,s2,401bb4 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
  401bc4:	85ce                	mv	a1,s3
  401bc6:	00004517          	auipc	a0,0x4
  401bca:	27a50513          	addi	a0,a0,634 # 405e40 <malloc+0xc68>
  401bce:	550030ef          	jal	40511e <printf>
    exit(1);
  401bd2:	4505                	li	a0,1
  401bd4:	12e030ef          	jal	404d02 <exit>
      exit(0);
  401bd8:	12a030ef          	jal	404d02 <exit>
    printf("%s: no fork at all!\n", s);
  401bdc:	85ce                	mv	a1,s3
  401bde:	00004517          	auipc	a0,0x4
  401be2:	21a50513          	addi	a0,a0,538 # 405df8 <malloc+0xc20>
  401be6:	538030ef          	jal	40511e <printf>
    exit(1);
  401bea:	4505                	li	a0,1
  401bec:	116030ef          	jal	404d02 <exit>
      printf("%s: wait stopped early\n", s);
  401bf0:	85ce                	mv	a1,s3
  401bf2:	00004517          	auipc	a0,0x4
  401bf6:	21e50513          	addi	a0,a0,542 # 405e10 <malloc+0xc38>
  401bfa:	524030ef          	jal	40511e <printf>
      exit(1);
  401bfe:	4505                	li	a0,1
  401c00:	102030ef          	jal	404d02 <exit>
    printf("%s: wait got too many\n", s);
  401c04:	85ce                	mv	a1,s3
  401c06:	00004517          	auipc	a0,0x4
  401c0a:	22250513          	addi	a0,a0,546 # 405e28 <malloc+0xc50>
  401c0e:	510030ef          	jal	40511e <printf>
    exit(1);
  401c12:	4505                	li	a0,1
  401c14:	0ee030ef          	jal	404d02 <exit>
  if (n == 0) {
  401c18:	d0f1                	beqz	s1,401bdc <forktest+0x3e>
    if(wait(0) < 0){
  401c1a:	4501                	li	a0,0
  401c1c:	0ee030ef          	jal	404d0a <wait>
  401c20:	fc0548e3          	bltz	a0,401bf0 <forktest+0x52>
  for(; n > 0; n--){
  401c24:	34fd                	addiw	s1,s1,-1
  401c26:	fe904ae3          	bgtz	s1,401c1a <forktest+0x7c>
  if(wait(0) != -1){
  401c2a:	4501                	li	a0,0
  401c2c:	0de030ef          	jal	404d0a <wait>
  401c30:	57fd                	li	a5,-1
  401c32:	fcf519e3          	bne	a0,a5,401c04 <forktest+0x66>
}
  401c36:	70a2                	ld	ra,40(sp)
  401c38:	7402                	ld	s0,32(sp)
  401c3a:	64e2                	ld	s1,24(sp)
  401c3c:	6942                	ld	s2,16(sp)
  401c3e:	69a2                	ld	s3,8(sp)
  401c40:	6145                	addi	sp,sp,48
  401c42:	8082                	ret

0000000000401c44 <kernmem>:
{
  401c44:	715d                	addi	sp,sp,-80
  401c46:	e486                	sd	ra,72(sp)
  401c48:	e0a2                	sd	s0,64(sp)
  401c4a:	fc26                	sd	s1,56(sp)
  401c4c:	f84a                	sd	s2,48(sp)
  401c4e:	f44e                	sd	s3,40(sp)
  401c50:	f052                	sd	s4,32(sp)
  401c52:	ec56                	sd	s5,24(sp)
  401c54:	e85a                	sd	s6,16(sp)
  401c56:	0880                	addi	s0,sp,80
  401c58:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
  401c5a:	4485                	li	s1,1
  401c5c:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
  401c5e:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
  401c62:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
  401c64:	69b1                	lui	s3,0xc
  401c66:	35098993          	addi	s3,s3,848 # c350 <copyinstr1-0x3f3cb0>
  401c6a:	1003d937          	lui	s2,0x1003d
  401c6e:	090e                	slli	s2,s2,0x3
  401c70:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0xfc2d808>
    pid = fork();
  401c74:	086030ef          	jal	404cfa <fork>
    if(pid < 0){
  401c78:	02054763          	bltz	a0,401ca6 <kernmem+0x62>
    if(pid == 0){
  401c7c:	cd1d                	beqz	a0,401cba <kernmem+0x76>
    wait(&xstatus);
  401c7e:	8556                	mv	a0,s5
  401c80:	08a030ef          	jal	404d0a <wait>
    if(xstatus != -1)  // did kernel kill child?
  401c84:	fbc42783          	lw	a5,-68(s0)
  401c88:	05479663          	bne	a5,s4,401cd4 <kernmem+0x90>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
  401c8c:	94ce                	add	s1,s1,s3
  401c8e:	ff2493e3          	bne	s1,s2,401c74 <kernmem+0x30>
}
  401c92:	60a6                	ld	ra,72(sp)
  401c94:	6406                	ld	s0,64(sp)
  401c96:	74e2                	ld	s1,56(sp)
  401c98:	7942                	ld	s2,48(sp)
  401c9a:	79a2                	ld	s3,40(sp)
  401c9c:	7a02                	ld	s4,32(sp)
  401c9e:	6ae2                	ld	s5,24(sp)
  401ca0:	6b42                	ld	s6,16(sp)
  401ca2:	6161                	addi	sp,sp,80
  401ca4:	8082                	ret
      printf("%s: fork failed\n", s);
  401ca6:	85da                	mv	a1,s6
  401ca8:	00004517          	auipc	a0,0x4
  401cac:	ef050513          	addi	a0,a0,-272 # 405b98 <malloc+0x9c0>
  401cb0:	46e030ef          	jal	40511e <printf>
      exit(1);
  401cb4:	4505                	li	a0,1
  401cb6:	04c030ef          	jal	404d02 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
  401cba:	0004c683          	lbu	a3,0(s1)
  401cbe:	8626                	mv	a2,s1
  401cc0:	85da                	mv	a1,s6
  401cc2:	00004517          	auipc	a0,0x4
  401cc6:	1a650513          	addi	a0,a0,422 # 405e68 <malloc+0xc90>
  401cca:	454030ef          	jal	40511e <printf>
      exit(1);
  401cce:	4505                	li	a0,1
  401cd0:	032030ef          	jal	404d02 <exit>
      exit(1);
  401cd4:	4505                	li	a0,1
  401cd6:	02c030ef          	jal	404d02 <exit>

0000000000401cda <MAXVAplus>:
{
  401cda:	7139                	addi	sp,sp,-64
  401cdc:	fc06                	sd	ra,56(sp)
  401cde:	f822                	sd	s0,48(sp)
  401ce0:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
  401ce2:	4785                	li	a5,1
  401ce4:	179a                	slli	a5,a5,0x26
  401ce6:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
  401cea:	fc843783          	ld	a5,-56(s0)
  401cee:	cf9d                	beqz	a5,401d2c <MAXVAplus+0x52>
  401cf0:	f426                	sd	s1,40(sp)
  401cf2:	f04a                	sd	s2,32(sp)
  401cf4:	ec4e                	sd	s3,24(sp)
  401cf6:	89aa                	mv	s3,a0
    wait(&xstatus);
  401cf8:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
  401cfc:	54fd                	li	s1,-1
    pid = fork();
  401cfe:	7fd020ef          	jal	404cfa <fork>
    if(pid < 0){
  401d02:	02054963          	bltz	a0,401d34 <MAXVAplus+0x5a>
    if(pid == 0){
  401d06:	c129                	beqz	a0,401d48 <MAXVAplus+0x6e>
    wait(&xstatus);
  401d08:	854a                	mv	a0,s2
  401d0a:	000030ef          	jal	404d0a <wait>
    if(xstatus != -1)  // did kernel kill child?
  401d0e:	fc442783          	lw	a5,-60(s0)
  401d12:	04979d63          	bne	a5,s1,401d6c <MAXVAplus+0x92>
  for( ; a != 0; a <<= 1){
  401d16:	fc843783          	ld	a5,-56(s0)
  401d1a:	0786                	slli	a5,a5,0x1
  401d1c:	fcf43423          	sd	a5,-56(s0)
  401d20:	fc843783          	ld	a5,-56(s0)
  401d24:	ffe9                	bnez	a5,401cfe <MAXVAplus+0x24>
  401d26:	74a2                	ld	s1,40(sp)
  401d28:	7902                	ld	s2,32(sp)
  401d2a:	69e2                	ld	s3,24(sp)
}
  401d2c:	70e2                	ld	ra,56(sp)
  401d2e:	7442                	ld	s0,48(sp)
  401d30:	6121                	addi	sp,sp,64
  401d32:	8082                	ret
      printf("%s: fork failed\n", s);
  401d34:	85ce                	mv	a1,s3
  401d36:	00004517          	auipc	a0,0x4
  401d3a:	e6250513          	addi	a0,a0,-414 # 405b98 <malloc+0x9c0>
  401d3e:	3e0030ef          	jal	40511e <printf>
      exit(1);
  401d42:	4505                	li	a0,1
  401d44:	7bf020ef          	jal	404d02 <exit>
      *(char*)a = 99;
  401d48:	fc843783          	ld	a5,-56(s0)
  401d4c:	06300713          	li	a4,99
  401d50:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
  401d54:	fc843603          	ld	a2,-56(s0)
  401d58:	85ce                	mv	a1,s3
  401d5a:	00004517          	auipc	a0,0x4
  401d5e:	12e50513          	addi	a0,a0,302 # 405e88 <malloc+0xcb0>
  401d62:	3bc030ef          	jal	40511e <printf>
      exit(1);
  401d66:	4505                	li	a0,1
  401d68:	79b020ef          	jal	404d02 <exit>
      exit(1);
  401d6c:	4505                	li	a0,1
  401d6e:	795020ef          	jal	404d02 <exit>

0000000000401d72 <stacktest>:
{
  401d72:	7179                	addi	sp,sp,-48
  401d74:	f406                	sd	ra,40(sp)
  401d76:	f022                	sd	s0,32(sp)
  401d78:	ec26                	sd	s1,24(sp)
  401d7a:	1800                	addi	s0,sp,48
  401d7c:	84aa                	mv	s1,a0
  pid = fork();
  401d7e:	77d020ef          	jal	404cfa <fork>
  if(pid == 0) {
  401d82:	cd11                	beqz	a0,401d9e <stacktest+0x2c>
  } else if(pid < 0){
  401d84:	02054c63          	bltz	a0,401dbc <stacktest+0x4a>
  wait(&xstatus);
  401d88:	fdc40513          	addi	a0,s0,-36
  401d8c:	77f020ef          	jal	404d0a <wait>
  if(xstatus == -1)  // kernel killed child?
  401d90:	fdc42503          	lw	a0,-36(s0)
  401d94:	57fd                	li	a5,-1
  401d96:	02f50d63          	beq	a0,a5,401dd0 <stacktest+0x5e>
    exit(xstatus);
  401d9a:	769020ef          	jal	404d02 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
  401d9e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
  401da0:	77fd                	lui	a5,0xfffff
  401da2:	97ba                	add	a5,a5,a4
  401da4:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffbef388>
  401da8:	85a6                	mv	a1,s1
  401daa:	00004517          	auipc	a0,0x4
  401dae:	0f650513          	addi	a0,a0,246 # 405ea0 <malloc+0xcc8>
  401db2:	36c030ef          	jal	40511e <printf>
    exit(1);
  401db6:	4505                	li	a0,1
  401db8:	74b020ef          	jal	404d02 <exit>
    printf("%s: fork failed\n", s);
  401dbc:	85a6                	mv	a1,s1
  401dbe:	00004517          	auipc	a0,0x4
  401dc2:	dda50513          	addi	a0,a0,-550 # 405b98 <malloc+0x9c0>
  401dc6:	358030ef          	jal	40511e <printf>
    exit(1);
  401dca:	4505                	li	a0,1
  401dcc:	737020ef          	jal	404d02 <exit>
    exit(0);
  401dd0:	4501                	li	a0,0
  401dd2:	731020ef          	jal	404d02 <exit>

0000000000401dd6 <nowrite>:
{
  401dd6:	7159                	addi	sp,sp,-112
  401dd8:	f486                	sd	ra,104(sp)
  401dda:	f0a2                	sd	s0,96(sp)
  401ddc:	eca6                	sd	s1,88(sp)
  401dde:	e8ca                	sd	s2,80(sp)
  401de0:	e4ce                	sd	s3,72(sp)
  401de2:	e0d2                	sd	s4,64(sp)
  401de4:	1880                	addi	s0,sp,112
  401de6:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
  401de8:	00006797          	auipc	a5,0x6
  401dec:	88078793          	addi	a5,a5,-1920 # 407668 <malloc+0x2490>
  401df0:	7788                	ld	a0,40(a5)
  401df2:	7b8c                	ld	a1,48(a5)
  401df4:	7f90                	ld	a2,56(a5)
  401df6:	63b4                	ld	a3,64(a5)
  401df8:	67b8                	ld	a4,72(a5)
  401dfa:	6bbc                	ld	a5,80(a5)
  401dfc:	f8a43c23          	sd	a0,-104(s0)
  401e00:	fab43023          	sd	a1,-96(s0)
  401e04:	fac43423          	sd	a2,-88(s0)
  401e08:	fad43823          	sd	a3,-80(s0)
  401e0c:	fae43c23          	sd	a4,-72(s0)
  401e10:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  401e14:	4481                	li	s1,0
    wait(&xstatus);
  401e16:	fcc40913          	addi	s2,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  401e1a:	4999                	li	s3,6
    pid = fork();
  401e1c:	6df020ef          	jal	404cfa <fork>
    if(pid == 0) {
  401e20:	cd19                	beqz	a0,401e3e <nowrite+0x68>
    } else if(pid < 0){
  401e22:	04054163          	bltz	a0,401e64 <nowrite+0x8e>
    wait(&xstatus);
  401e26:	854a                	mv	a0,s2
  401e28:	6e3020ef          	jal	404d0a <wait>
    if(xstatus == 0){
  401e2c:	fcc42783          	lw	a5,-52(s0)
  401e30:	c7a1                	beqz	a5,401e78 <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
  401e32:	2485                	addiw	s1,s1,1
  401e34:	ff3494e3          	bne	s1,s3,401e1c <nowrite+0x46>
  exit(0);
  401e38:	4501                	li	a0,0
  401e3a:	6c9020ef          	jal	404d02 <exit>
      volatile int *addr = (int *) addrs[ai];
  401e3e:	048e                	slli	s1,s1,0x3
  401e40:	fd048793          	addi	a5,s1,-48
  401e44:	008784b3          	add	s1,a5,s0
  401e48:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
  401e4c:	47a9                	li	a5,10
  401e4e:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
  401e50:	85d2                	mv	a1,s4
  401e52:	00004517          	auipc	a0,0x4
  401e56:	07650513          	addi	a0,a0,118 # 405ec8 <malloc+0xcf0>
  401e5a:	2c4030ef          	jal	40511e <printf>
      exit(0);
  401e5e:	4501                	li	a0,0
  401e60:	6a3020ef          	jal	404d02 <exit>
      printf("%s: fork failed\n", s);
  401e64:	85d2                	mv	a1,s4
  401e66:	00004517          	auipc	a0,0x4
  401e6a:	d3250513          	addi	a0,a0,-718 # 405b98 <malloc+0x9c0>
  401e6e:	2b0030ef          	jal	40511e <printf>
      exit(1);
  401e72:	4505                	li	a0,1
  401e74:	68f020ef          	jal	404d02 <exit>
      exit(1);
  401e78:	4505                	li	a0,1
  401e7a:	689020ef          	jal	404d02 <exit>

0000000000401e7e <manywrites>:
{
  401e7e:	7159                	addi	sp,sp,-112
  401e80:	f486                	sd	ra,104(sp)
  401e82:	f0a2                	sd	s0,96(sp)
  401e84:	eca6                	sd	s1,88(sp)
  401e86:	e8ca                	sd	s2,80(sp)
  401e88:	e4ce                	sd	s3,72(sp)
  401e8a:	fc56                	sd	s5,56(sp)
  401e8c:	1880                	addi	s0,sp,112
  401e8e:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
  401e90:	4901                	li	s2,0
  401e92:	4991                	li	s3,4
    int pid = fork();
  401e94:	667020ef          	jal	404cfa <fork>
  401e98:	84aa                	mv	s1,a0
    if(pid < 0){
  401e9a:	02054d63          	bltz	a0,401ed4 <manywrites+0x56>
    if(pid == 0){
  401e9e:	c931                	beqz	a0,401ef2 <manywrites+0x74>
  for(int ci = 0; ci < nchildren; ci++){
  401ea0:	2905                	addiw	s2,s2,1
  401ea2:	ff3919e3          	bne	s2,s3,401e94 <manywrites+0x16>
  401ea6:	4491                	li	s1,4
    wait(&st);
  401ea8:	f9840913          	addi	s2,s0,-104
    int st = 0;
  401eac:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
  401eb0:	854a                	mv	a0,s2
  401eb2:	659020ef          	jal	404d0a <wait>
    if(st != 0)
  401eb6:	f9842503          	lw	a0,-104(s0)
  401eba:	0e051463          	bnez	a0,401fa2 <manywrites+0x124>
  for(int ci = 0; ci < nchildren; ci++){
  401ebe:	34fd                	addiw	s1,s1,-1
  401ec0:	f4f5                	bnez	s1,401eac <manywrites+0x2e>
  401ec2:	e0d2                	sd	s4,64(sp)
  401ec4:	f85a                	sd	s6,48(sp)
  401ec6:	f45e                	sd	s7,40(sp)
  401ec8:	f062                	sd	s8,32(sp)
  401eca:	ec66                	sd	s9,24(sp)
  401ecc:	e86a                	sd	s10,16(sp)
  exit(0);
  401ece:	4501                	li	a0,0
  401ed0:	633020ef          	jal	404d02 <exit>
  401ed4:	e0d2                	sd	s4,64(sp)
  401ed6:	f85a                	sd	s6,48(sp)
  401ed8:	f45e                	sd	s7,40(sp)
  401eda:	f062                	sd	s8,32(sp)
  401edc:	ec66                	sd	s9,24(sp)
  401ede:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
  401ee0:	00005517          	auipc	a0,0x5
  401ee4:	22850513          	addi	a0,a0,552 # 407108 <malloc+0x1f30>
  401ee8:	236030ef          	jal	40511e <printf>
      exit(1);
  401eec:	4505                	li	a0,1
  401eee:	615020ef          	jal	404d02 <exit>
  401ef2:	e0d2                	sd	s4,64(sp)
  401ef4:	f85a                	sd	s6,48(sp)
  401ef6:	f45e                	sd	s7,40(sp)
  401ef8:	f062                	sd	s8,32(sp)
  401efa:	ec66                	sd	s9,24(sp)
  401efc:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
  401efe:	06200793          	li	a5,98
  401f02:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
  401f06:	0619079b          	addiw	a5,s2,97
  401f0a:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
  401f0e:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
  401f12:	f9840513          	addi	a0,s0,-104
  401f16:	63d020ef          	jal	404d52 <unlink>
  401f1a:	4d79                	li	s10,30
          int fd = open(name, O_CREATE | O_RDWR);
  401f1c:	f9840c13          	addi	s8,s0,-104
  401f20:	20200b93          	li	s7,514
          int cc = write(fd, buf, sz);
  401f24:	6b0d                	lui	s6,0x3
  401f26:	0000bc97          	auipc	s9,0xb
  401f2a:	d52c8c93          	addi	s9,s9,-686 # 40cc78 <buf>
        for(int i = 0; i < ci+1; i++){
  401f2e:	8a26                	mv	s4,s1
          int fd = open(name, O_CREATE | O_RDWR);
  401f30:	85de                	mv	a1,s7
  401f32:	8562                	mv	a0,s8
  401f34:	60f020ef          	jal	404d42 <open>
  401f38:	89aa                	mv	s3,a0
          if(fd < 0){
  401f3a:	02054c63          	bltz	a0,401f72 <manywrites+0xf4>
          int cc = write(fd, buf, sz);
  401f3e:	865a                	mv	a2,s6
  401f40:	85e6                	mv	a1,s9
  401f42:	5e1020ef          	jal	404d22 <write>
          if(cc != sz){
  401f46:	05651263          	bne	a0,s6,401f8a <manywrites+0x10c>
          close(fd);
  401f4a:	854e                	mv	a0,s3
  401f4c:	5df020ef          	jal	404d2a <close>
        for(int i = 0; i < ci+1; i++){
  401f50:	2a05                	addiw	s4,s4,1
  401f52:	fd495fe3          	bge	s2,s4,401f30 <manywrites+0xb2>
        unlink(name);
  401f56:	f9840513          	addi	a0,s0,-104
  401f5a:	5f9020ef          	jal	404d52 <unlink>
      for(int iters = 0; iters < howmany; iters++){
  401f5e:	3d7d                	addiw	s10,s10,-1
  401f60:	fc0d17e3          	bnez	s10,401f2e <manywrites+0xb0>
      unlink(name);
  401f64:	f9840513          	addi	a0,s0,-104
  401f68:	5eb020ef          	jal	404d52 <unlink>
      exit(0);
  401f6c:	4501                	li	a0,0
  401f6e:	595020ef          	jal	404d02 <exit>
            printf("%s: cannot create %s\n", s, name);
  401f72:	f9840613          	addi	a2,s0,-104
  401f76:	85d6                	mv	a1,s5
  401f78:	00004517          	auipc	a0,0x4
  401f7c:	f7050513          	addi	a0,a0,-144 # 405ee8 <malloc+0xd10>
  401f80:	19e030ef          	jal	40511e <printf>
            exit(1);
  401f84:	4505                	li	a0,1
  401f86:	57d020ef          	jal	404d02 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
  401f8a:	86aa                	mv	a3,a0
  401f8c:	660d                	lui	a2,0x3
  401f8e:	85d6                	mv	a1,s5
  401f90:	00003517          	auipc	a0,0x3
  401f94:	44850513          	addi	a0,a0,1096 # 4053d8 <malloc+0x200>
  401f98:	186030ef          	jal	40511e <printf>
            exit(1);
  401f9c:	4505                	li	a0,1
  401f9e:	565020ef          	jal	404d02 <exit>
  401fa2:	e0d2                	sd	s4,64(sp)
  401fa4:	f85a                	sd	s6,48(sp)
  401fa6:	f45e                	sd	s7,40(sp)
  401fa8:	f062                	sd	s8,32(sp)
  401faa:	ec66                	sd	s9,24(sp)
  401fac:	e86a                	sd	s10,16(sp)
      exit(st);
  401fae:	555020ef          	jal	404d02 <exit>

0000000000401fb2 <copyinstr3>:
{
  401fb2:	7179                	addi	sp,sp,-48
  401fb4:	f406                	sd	ra,40(sp)
  401fb6:	f022                	sd	s0,32(sp)
  401fb8:	ec26                	sd	s1,24(sp)
  401fba:	1800                	addi	s0,sp,48
  sbrk(8192);
  401fbc:	6509                	lui	a0,0x2
  401fbe:	5cd020ef          	jal	404d8a <sbrk>
  uint64 top = (uint64) sbrk(0);
  401fc2:	4501                	li	a0,0
  401fc4:	5c7020ef          	jal	404d8a <sbrk>
  if((top % PGSIZE) != 0){
  401fc8:	03451793          	slli	a5,a0,0x34
  401fcc:	e7bd                	bnez	a5,40203a <copyinstr3+0x88>
  top = (uint64) sbrk(0);
  401fce:	4501                	li	a0,0
  401fd0:	5bb020ef          	jal	404d8a <sbrk>
  if(top % PGSIZE){
  401fd4:	03451793          	slli	a5,a0,0x34
  401fd8:	ebb5                	bnez	a5,40204c <copyinstr3+0x9a>
  char *b = (char *) (top - 1);
  401fda:	fff50493          	addi	s1,a0,-1 # 1fff <copyinstr1-0x3fe001>
  *b = 'x';
  401fde:	07800793          	li	a5,120
  401fe2:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
  401fe6:	8526                	mv	a0,s1
  401fe8:	56b020ef          	jal	404d52 <unlink>
  if(ret != -1){
  401fec:	57fd                	li	a5,-1
  401fee:	06f51863          	bne	a0,a5,40205e <copyinstr3+0xac>
  int fd = open(b, O_CREATE | O_WRONLY);
  401ff2:	20100593          	li	a1,513
  401ff6:	8526                	mv	a0,s1
  401ff8:	54b020ef          	jal	404d42 <open>
  if(fd != -1){
  401ffc:	57fd                	li	a5,-1
  401ffe:	06f51b63          	bne	a0,a5,402074 <copyinstr3+0xc2>
  ret = link(b, b);
  402002:	85a6                	mv	a1,s1
  402004:	8526                	mv	a0,s1
  402006:	55d020ef          	jal	404d62 <link>
  if(ret != -1){
  40200a:	57fd                	li	a5,-1
  40200c:	06f51f63          	bne	a0,a5,40208a <copyinstr3+0xd8>
  char *args[] = { "xx", 0 };
  402010:	00005797          	auipc	a5,0x5
  402014:	bd878793          	addi	a5,a5,-1064 # 406be8 <malloc+0x1a10>
  402018:	fcf43823          	sd	a5,-48(s0)
  40201c:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
  402020:	fd040593          	addi	a1,s0,-48
  402024:	8526                	mv	a0,s1
  402026:	515020ef          	jal	404d3a <exec>
  if(ret != -1){
  40202a:	57fd                	li	a5,-1
  40202c:	06f51b63          	bne	a0,a5,4020a2 <copyinstr3+0xf0>
}
  402030:	70a2                	ld	ra,40(sp)
  402032:	7402                	ld	s0,32(sp)
  402034:	64e2                	ld	s1,24(sp)
  402036:	6145                	addi	sp,sp,48
  402038:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
  40203a:	6785                	lui	a5,0x1
  40203c:	fff78713          	addi	a4,a5,-1 # fff <copyinstr1-0x3ff001>
  402040:	8d79                	and	a0,a0,a4
  402042:	40a7853b          	subw	a0,a5,a0
  402046:	545020ef          	jal	404d8a <sbrk>
  40204a:	b751                	j	401fce <copyinstr3+0x1c>
    printf("oops\n");
  40204c:	00004517          	auipc	a0,0x4
  402050:	eb450513          	addi	a0,a0,-332 # 405f00 <malloc+0xd28>
  402054:	0ca030ef          	jal	40511e <printf>
    exit(1);
  402058:	4505                	li	a0,1
  40205a:	4a9020ef          	jal	404d02 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
  40205e:	862a                	mv	a2,a0
  402060:	85a6                	mv	a1,s1
  402062:	00004517          	auipc	a0,0x4
  402066:	a5650513          	addi	a0,a0,-1450 # 405ab8 <malloc+0x8e0>
  40206a:	0b4030ef          	jal	40511e <printf>
    exit(1);
  40206e:	4505                	li	a0,1
  402070:	493020ef          	jal	404d02 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
  402074:	862a                	mv	a2,a0
  402076:	85a6                	mv	a1,s1
  402078:	00004517          	auipc	a0,0x4
  40207c:	a6050513          	addi	a0,a0,-1440 # 405ad8 <malloc+0x900>
  402080:	09e030ef          	jal	40511e <printf>
    exit(1);
  402084:	4505                	li	a0,1
  402086:	47d020ef          	jal	404d02 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
  40208a:	86aa                	mv	a3,a0
  40208c:	8626                	mv	a2,s1
  40208e:	85a6                	mv	a1,s1
  402090:	00004517          	auipc	a0,0x4
  402094:	a6850513          	addi	a0,a0,-1432 # 405af8 <malloc+0x920>
  402098:	086030ef          	jal	40511e <printf>
    exit(1);
  40209c:	4505                	li	a0,1
  40209e:	465020ef          	jal	404d02 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
  4020a2:	863e                	mv	a2,a5
  4020a4:	85a6                	mv	a1,s1
  4020a6:	00004517          	auipc	a0,0x4
  4020aa:	a7a50513          	addi	a0,a0,-1414 # 405b20 <malloc+0x948>
  4020ae:	070030ef          	jal	40511e <printf>
    exit(1);
  4020b2:	4505                	li	a0,1
  4020b4:	44f020ef          	jal	404d02 <exit>

00000000004020b8 <rwsbrk>:
{
  4020b8:	1101                	addi	sp,sp,-32
  4020ba:	ec06                	sd	ra,24(sp)
  4020bc:	e822                	sd	s0,16(sp)
  4020be:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
  4020c0:	6509                	lui	a0,0x2
  4020c2:	4c9020ef          	jal	404d8a <sbrk>
  if(a == 0xffffffffffffffffLL) {
  4020c6:	57fd                	li	a5,-1
  4020c8:	04f50a63          	beq	a0,a5,40211c <rwsbrk+0x64>
  4020cc:	e426                	sd	s1,8(sp)
  4020ce:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
  4020d0:	7579                	lui	a0,0xffffe
  4020d2:	4b9020ef          	jal	404d8a <sbrk>
  4020d6:	57fd                	li	a5,-1
  4020d8:	04f50d63          	beq	a0,a5,402132 <rwsbrk+0x7a>
  4020dc:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
  4020de:	20100593          	li	a1,513
  4020e2:	00004517          	auipc	a0,0x4
  4020e6:	e5e50513          	addi	a0,a0,-418 # 405f40 <malloc+0xd68>
  4020ea:	459020ef          	jal	404d42 <open>
  4020ee:	892a                	mv	s2,a0
  if(fd < 0){
  4020f0:	04054b63          	bltz	a0,402146 <rwsbrk+0x8e>
  n = write(fd, (void*)(a+4096), 1024);
  4020f4:	6785                	lui	a5,0x1
  4020f6:	94be                	add	s1,s1,a5
  4020f8:	40000613          	li	a2,1024
  4020fc:	85a6                	mv	a1,s1
  4020fe:	425020ef          	jal	404d22 <write>
  402102:	862a                	mv	a2,a0
  if(n >= 0){
  402104:	04054a63          	bltz	a0,402158 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
  402108:	85a6                	mv	a1,s1
  40210a:	00004517          	auipc	a0,0x4
  40210e:	e5650513          	addi	a0,a0,-426 # 405f60 <malloc+0xd88>
  402112:	00c030ef          	jal	40511e <printf>
    exit(1);
  402116:	4505                	li	a0,1
  402118:	3eb020ef          	jal	404d02 <exit>
  40211c:	e426                	sd	s1,8(sp)
  40211e:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
  402120:	00004517          	auipc	a0,0x4
  402124:	de850513          	addi	a0,a0,-536 # 405f08 <malloc+0xd30>
  402128:	7f7020ef          	jal	40511e <printf>
    exit(1);
  40212c:	4505                	li	a0,1
  40212e:	3d5020ef          	jal	404d02 <exit>
  402132:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
  402134:	00004517          	auipc	a0,0x4
  402138:	dec50513          	addi	a0,a0,-532 # 405f20 <malloc+0xd48>
  40213c:	7e3020ef          	jal	40511e <printf>
    exit(1);
  402140:	4505                	li	a0,1
  402142:	3c1020ef          	jal	404d02 <exit>
    printf("open(rwsbrk) failed\n");
  402146:	00004517          	auipc	a0,0x4
  40214a:	e0250513          	addi	a0,a0,-510 # 405f48 <malloc+0xd70>
  40214e:	7d1020ef          	jal	40511e <printf>
    exit(1);
  402152:	4505                	li	a0,1
  402154:	3af020ef          	jal	404d02 <exit>
  close(fd);
  402158:	854a                	mv	a0,s2
  40215a:	3d1020ef          	jal	404d2a <close>
  unlink("rwsbrk");
  40215e:	00004517          	auipc	a0,0x4
  402162:	de250513          	addi	a0,a0,-542 # 405f40 <malloc+0xd68>
  402166:	3ed020ef          	jal	404d52 <unlink>
  fd = open("README", O_RDONLY);
  40216a:	4581                	li	a1,0
  40216c:	00003517          	auipc	a0,0x3
  402170:	37450513          	addi	a0,a0,884 # 4054e0 <malloc+0x308>
  402174:	3cf020ef          	jal	404d42 <open>
  402178:	892a                	mv	s2,a0
  if(fd < 0){
  40217a:	02054363          	bltz	a0,4021a0 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+4096), 10);
  40217e:	4629                	li	a2,10
  402180:	85a6                	mv	a1,s1
  402182:	399020ef          	jal	404d1a <read>
  402186:	862a                	mv	a2,a0
  if(n >= 0){
  402188:	02054563          	bltz	a0,4021b2 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
  40218c:	85a6                	mv	a1,s1
  40218e:	00004517          	auipc	a0,0x4
  402192:	e0250513          	addi	a0,a0,-510 # 405f90 <malloc+0xdb8>
  402196:	789020ef          	jal	40511e <printf>
    exit(1);
  40219a:	4505                	li	a0,1
  40219c:	367020ef          	jal	404d02 <exit>
    printf("open(rwsbrk) failed\n");
  4021a0:	00004517          	auipc	a0,0x4
  4021a4:	da850513          	addi	a0,a0,-600 # 405f48 <malloc+0xd70>
  4021a8:	777020ef          	jal	40511e <printf>
    exit(1);
  4021ac:	4505                	li	a0,1
  4021ae:	355020ef          	jal	404d02 <exit>
  close(fd);
  4021b2:	854a                	mv	a0,s2
  4021b4:	377020ef          	jal	404d2a <close>
  exit(0);
  4021b8:	4501                	li	a0,0
  4021ba:	349020ef          	jal	404d02 <exit>

00000000004021be <sbrkbasic>:
{
  4021be:	715d                	addi	sp,sp,-80
  4021c0:	e486                	sd	ra,72(sp)
  4021c2:	e0a2                	sd	s0,64(sp)
  4021c4:	ec56                	sd	s5,24(sp)
  4021c6:	0880                	addi	s0,sp,80
  4021c8:	8aaa                	mv	s5,a0
  pid = fork();
  4021ca:	331020ef          	jal	404cfa <fork>
  if(pid < 0){
  4021ce:	02054c63          	bltz	a0,402206 <sbrkbasic+0x48>
  if(pid == 0){
  4021d2:	ed31                	bnez	a0,40222e <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
  4021d4:	40000537          	lui	a0,0x40000
  4021d8:	3b3020ef          	jal	404d8a <sbrk>
    if(a == (char*)0xffffffffffffffffL){
  4021dc:	57fd                	li	a5,-1
  4021de:	04f50163          	beq	a0,a5,402220 <sbrkbasic+0x62>
  4021e2:	fc26                	sd	s1,56(sp)
  4021e4:	f84a                	sd	s2,48(sp)
  4021e6:	f44e                	sd	s3,40(sp)
  4021e8:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
  4021ea:	400007b7          	lui	a5,0x40000
  4021ee:	97aa                	add	a5,a5,a0
      *b = 99;
  4021f0:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
  4021f4:	6705                	lui	a4,0x1
      *b = 99;
  4021f6:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fbf0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
  4021fa:	953a                	add	a0,a0,a4
  4021fc:	fef51de3          	bne	a0,a5,4021f6 <sbrkbasic+0x38>
    exit(1);
  402200:	4505                	li	a0,1
  402202:	301020ef          	jal	404d02 <exit>
  402206:	fc26                	sd	s1,56(sp)
  402208:	f84a                	sd	s2,48(sp)
  40220a:	f44e                	sd	s3,40(sp)
  40220c:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
  40220e:	00004517          	auipc	a0,0x4
  402212:	daa50513          	addi	a0,a0,-598 # 405fb8 <malloc+0xde0>
  402216:	709020ef          	jal	40511e <printf>
    exit(1);
  40221a:	4505                	li	a0,1
  40221c:	2e7020ef          	jal	404d02 <exit>
  402220:	fc26                	sd	s1,56(sp)
  402222:	f84a                	sd	s2,48(sp)
  402224:	f44e                	sd	s3,40(sp)
  402226:	f052                	sd	s4,32(sp)
      exit(0);
  402228:	4501                	li	a0,0
  40222a:	2d9020ef          	jal	404d02 <exit>
  wait(&xstatus);
  40222e:	fbc40513          	addi	a0,s0,-68
  402232:	2d9020ef          	jal	404d0a <wait>
  if(xstatus == 1){
  402236:	fbc42703          	lw	a4,-68(s0)
  40223a:	4785                	li	a5,1
  40223c:	02f70063          	beq	a4,a5,40225c <sbrkbasic+0x9e>
  402240:	fc26                	sd	s1,56(sp)
  402242:	f84a                	sd	s2,48(sp)
  402244:	f44e                	sd	s3,40(sp)
  402246:	f052                	sd	s4,32(sp)
  a = sbrk(0);
  402248:	4501                	li	a0,0
  40224a:	341020ef          	jal	404d8a <sbrk>
  40224e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
  402250:	4901                	li	s2,0
    b = sbrk(1);
  402252:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
  402254:	6a05                	lui	s4,0x1
  402256:	388a0a13          	addi	s4,s4,904 # 1388 <copyinstr1-0x3fec78>
  40225a:	a005                	j	40227a <sbrkbasic+0xbc>
  40225c:	fc26                	sd	s1,56(sp)
  40225e:	f84a                	sd	s2,48(sp)
  402260:	f44e                	sd	s3,40(sp)
  402262:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
  402264:	85d6                	mv	a1,s5
  402266:	00004517          	auipc	a0,0x4
  40226a:	d7250513          	addi	a0,a0,-654 # 405fd8 <malloc+0xe00>
  40226e:	6b1020ef          	jal	40511e <printf>
    exit(1);
  402272:	4505                	li	a0,1
  402274:	28f020ef          	jal	404d02 <exit>
  402278:	84be                	mv	s1,a5
    b = sbrk(1);
  40227a:	854e                	mv	a0,s3
  40227c:	30f020ef          	jal	404d8a <sbrk>
    if(b != a){
  402280:	04951163          	bne	a0,s1,4022c2 <sbrkbasic+0x104>
    *b = 1;
  402284:	01348023          	sb	s3,0(s1)
    a = b + 1;
  402288:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
  40228c:	2905                	addiw	s2,s2,1
  40228e:	ff4915e3          	bne	s2,s4,402278 <sbrkbasic+0xba>
  pid = fork();
  402292:	269020ef          	jal	404cfa <fork>
  402296:	892a                	mv	s2,a0
  if(pid < 0){
  402298:	04054263          	bltz	a0,4022dc <sbrkbasic+0x11e>
  c = sbrk(1);
  40229c:	4505                	li	a0,1
  40229e:	2ed020ef          	jal	404d8a <sbrk>
  c = sbrk(1);
  4022a2:	4505                	li	a0,1
  4022a4:	2e7020ef          	jal	404d8a <sbrk>
  if(c != a + 1){
  4022a8:	0489                	addi	s1,s1,2
  4022aa:	04a48363          	beq	s1,a0,4022f0 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
  4022ae:	85d6                	mv	a1,s5
  4022b0:	00004517          	auipc	a0,0x4
  4022b4:	d8850513          	addi	a0,a0,-632 # 406038 <malloc+0xe60>
  4022b8:	667020ef          	jal	40511e <printf>
    exit(1);
  4022bc:	4505                	li	a0,1
  4022be:	245020ef          	jal	404d02 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
  4022c2:	872a                	mv	a4,a0
  4022c4:	86a6                	mv	a3,s1
  4022c6:	864a                	mv	a2,s2
  4022c8:	85d6                	mv	a1,s5
  4022ca:	00004517          	auipc	a0,0x4
  4022ce:	d2e50513          	addi	a0,a0,-722 # 405ff8 <malloc+0xe20>
  4022d2:	64d020ef          	jal	40511e <printf>
      exit(1);
  4022d6:	4505                	li	a0,1
  4022d8:	22b020ef          	jal	404d02 <exit>
    printf("%s: sbrk test fork failed\n", s);
  4022dc:	85d6                	mv	a1,s5
  4022de:	00004517          	auipc	a0,0x4
  4022e2:	d3a50513          	addi	a0,a0,-710 # 406018 <malloc+0xe40>
  4022e6:	639020ef          	jal	40511e <printf>
    exit(1);
  4022ea:	4505                	li	a0,1
  4022ec:	217020ef          	jal	404d02 <exit>
  if(pid == 0)
  4022f0:	00091563          	bnez	s2,4022fa <sbrkbasic+0x13c>
    exit(0);
  4022f4:	4501                	li	a0,0
  4022f6:	20d020ef          	jal	404d02 <exit>
  wait(&xstatus);
  4022fa:	fbc40513          	addi	a0,s0,-68
  4022fe:	20d020ef          	jal	404d0a <wait>
  exit(xstatus);
  402302:	fbc42503          	lw	a0,-68(s0)
  402306:	1fd020ef          	jal	404d02 <exit>

000000000040230a <sbrkmuch>:
{
  40230a:	7179                	addi	sp,sp,-48
  40230c:	f406                	sd	ra,40(sp)
  40230e:	f022                	sd	s0,32(sp)
  402310:	ec26                	sd	s1,24(sp)
  402312:	e84a                	sd	s2,16(sp)
  402314:	e44e                	sd	s3,8(sp)
  402316:	e052                	sd	s4,0(sp)
  402318:	1800                	addi	s0,sp,48
  40231a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
  40231c:	4501                	li	a0,0
  40231e:	26d020ef          	jal	404d8a <sbrk>
  402322:	892a                	mv	s2,a0
  a = sbrk(0);
  402324:	4501                	li	a0,0
  402326:	265020ef          	jal	404d8a <sbrk>
  40232a:	84aa                	mv	s1,a0
  p = sbrk(amt);
  40232c:	06400537          	lui	a0,0x6400
  402330:	9d05                	subw	a0,a0,s1
  402332:	259020ef          	jal	404d8a <sbrk>
  if (p != a) {
  402336:	0aa49463          	bne	s1,a0,4023de <sbrkmuch+0xd4>
  char *eee = sbrk(0);
  40233a:	4501                	li	a0,0
  40233c:	24f020ef          	jal	404d8a <sbrk>
  402340:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
  402342:	00a4f963          	bgeu	s1,a0,402354 <sbrkmuch+0x4a>
    *pp = 1;
  402346:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
  402348:	6705                	lui	a4,0x1
    *pp = 1;
  40234a:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
  40234e:	94ba                	add	s1,s1,a4
  402350:	fef4ede3          	bltu	s1,a5,40234a <sbrkmuch+0x40>
  *lastaddr = 99;
  402354:	064007b7          	lui	a5,0x6400
  402358:	06300713          	li	a4,99
  40235c:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x5ff0387>
  a = sbrk(0);
  402360:	4501                	li	a0,0
  402362:	229020ef          	jal	404d8a <sbrk>
  402366:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
  402368:	757d                	lui	a0,0xfffff
  40236a:	221020ef          	jal	404d8a <sbrk>
  if(c == (char*)0xffffffffffffffffL){
  40236e:	57fd                	li	a5,-1
  402370:	08f50163          	beq	a0,a5,4023f2 <sbrkmuch+0xe8>
  c = sbrk(0);
  402374:	4501                	li	a0,0
  402376:	215020ef          	jal	404d8a <sbrk>
  if(c != a - PGSIZE){
  40237a:	77fd                	lui	a5,0xfffff
  40237c:	97a6                	add	a5,a5,s1
  40237e:	08f51463          	bne	a0,a5,402406 <sbrkmuch+0xfc>
  a = sbrk(0);
  402382:	4501                	li	a0,0
  402384:	207020ef          	jal	404d8a <sbrk>
  402388:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
  40238a:	6505                	lui	a0,0x1
  40238c:	1ff020ef          	jal	404d8a <sbrk>
  402390:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
  402392:	08a49663          	bne	s1,a0,40241e <sbrkmuch+0x114>
  402396:	4501                	li	a0,0
  402398:	1f3020ef          	jal	404d8a <sbrk>
  40239c:	6785                	lui	a5,0x1
  40239e:	97a6                	add	a5,a5,s1
  4023a0:	06f51f63          	bne	a0,a5,40241e <sbrkmuch+0x114>
  if(*lastaddr == 99){
  4023a4:	064007b7          	lui	a5,0x6400
  4023a8:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x5ff0387>
  4023ac:	06300793          	li	a5,99
  4023b0:	08f70363          	beq	a4,a5,402436 <sbrkmuch+0x12c>
  a = sbrk(0);
  4023b4:	4501                	li	a0,0
  4023b6:	1d5020ef          	jal	404d8a <sbrk>
  4023ba:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
  4023bc:	4501                	li	a0,0
  4023be:	1cd020ef          	jal	404d8a <sbrk>
  4023c2:	40a9053b          	subw	a0,s2,a0
  4023c6:	1c5020ef          	jal	404d8a <sbrk>
  if(c != a){
  4023ca:	08a49063          	bne	s1,a0,40244a <sbrkmuch+0x140>
}
  4023ce:	70a2                	ld	ra,40(sp)
  4023d0:	7402                	ld	s0,32(sp)
  4023d2:	64e2                	ld	s1,24(sp)
  4023d4:	6942                	ld	s2,16(sp)
  4023d6:	69a2                	ld	s3,8(sp)
  4023d8:	6a02                	ld	s4,0(sp)
  4023da:	6145                	addi	sp,sp,48
  4023dc:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
  4023de:	85ce                	mv	a1,s3
  4023e0:	00004517          	auipc	a0,0x4
  4023e4:	c7850513          	addi	a0,a0,-904 # 406058 <malloc+0xe80>
  4023e8:	537020ef          	jal	40511e <printf>
    exit(1);
  4023ec:	4505                	li	a0,1
  4023ee:	115020ef          	jal	404d02 <exit>
    printf("%s: sbrk could not deallocate\n", s);
  4023f2:	85ce                	mv	a1,s3
  4023f4:	00004517          	auipc	a0,0x4
  4023f8:	cac50513          	addi	a0,a0,-852 # 4060a0 <malloc+0xec8>
  4023fc:	523020ef          	jal	40511e <printf>
    exit(1);
  402400:	4505                	li	a0,1
  402402:	101020ef          	jal	404d02 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
  402406:	86aa                	mv	a3,a0
  402408:	8626                	mv	a2,s1
  40240a:	85ce                	mv	a1,s3
  40240c:	00004517          	auipc	a0,0x4
  402410:	cb450513          	addi	a0,a0,-844 # 4060c0 <malloc+0xee8>
  402414:	50b020ef          	jal	40511e <printf>
    exit(1);
  402418:	4505                	li	a0,1
  40241a:	0e9020ef          	jal	404d02 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
  40241e:	86d2                	mv	a3,s4
  402420:	8626                	mv	a2,s1
  402422:	85ce                	mv	a1,s3
  402424:	00004517          	auipc	a0,0x4
  402428:	cdc50513          	addi	a0,a0,-804 # 406100 <malloc+0xf28>
  40242c:	4f3020ef          	jal	40511e <printf>
    exit(1);
  402430:	4505                	li	a0,1
  402432:	0d1020ef          	jal	404d02 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
  402436:	85ce                	mv	a1,s3
  402438:	00004517          	auipc	a0,0x4
  40243c:	cf850513          	addi	a0,a0,-776 # 406130 <malloc+0xf58>
  402440:	4df020ef          	jal	40511e <printf>
    exit(1);
  402444:	4505                	li	a0,1
  402446:	0bd020ef          	jal	404d02 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
  40244a:	86aa                	mv	a3,a0
  40244c:	8626                	mv	a2,s1
  40244e:	85ce                	mv	a1,s3
  402450:	00004517          	auipc	a0,0x4
  402454:	d1850513          	addi	a0,a0,-744 # 406168 <malloc+0xf90>
  402458:	4c7020ef          	jal	40511e <printf>
    exit(1);
  40245c:	4505                	li	a0,1
  40245e:	0a5020ef          	jal	404d02 <exit>

0000000000402462 <sbrkarg>:
{
  402462:	7179                	addi	sp,sp,-48
  402464:	f406                	sd	ra,40(sp)
  402466:	f022                	sd	s0,32(sp)
  402468:	ec26                	sd	s1,24(sp)
  40246a:	e84a                	sd	s2,16(sp)
  40246c:	e44e                	sd	s3,8(sp)
  40246e:	1800                	addi	s0,sp,48
  402470:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
  402472:	6505                	lui	a0,0x1
  402474:	117020ef          	jal	404d8a <sbrk>
  402478:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
  40247a:	20100593          	li	a1,513
  40247e:	00004517          	auipc	a0,0x4
  402482:	d1250513          	addi	a0,a0,-750 # 406190 <malloc+0xfb8>
  402486:	0bd020ef          	jal	404d42 <open>
  40248a:	84aa                	mv	s1,a0
  unlink("sbrk");
  40248c:	00004517          	auipc	a0,0x4
  402490:	d0450513          	addi	a0,a0,-764 # 406190 <malloc+0xfb8>
  402494:	0bf020ef          	jal	404d52 <unlink>
  if(fd < 0)  {
  402498:	0204c963          	bltz	s1,4024ca <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
  40249c:	6605                	lui	a2,0x1
  40249e:	85ca                	mv	a1,s2
  4024a0:	8526                	mv	a0,s1
  4024a2:	081020ef          	jal	404d22 <write>
  4024a6:	02054c63          	bltz	a0,4024de <sbrkarg+0x7c>
  close(fd);
  4024aa:	8526                	mv	a0,s1
  4024ac:	07f020ef          	jal	404d2a <close>
  a = sbrk(PGSIZE);
  4024b0:	6505                	lui	a0,0x1
  4024b2:	0d9020ef          	jal	404d8a <sbrk>
  if(pipe((int *) a) != 0){
  4024b6:	05d020ef          	jal	404d12 <pipe>
  4024ba:	ed05                	bnez	a0,4024f2 <sbrkarg+0x90>
}
  4024bc:	70a2                	ld	ra,40(sp)
  4024be:	7402                	ld	s0,32(sp)
  4024c0:	64e2                	ld	s1,24(sp)
  4024c2:	6942                	ld	s2,16(sp)
  4024c4:	69a2                	ld	s3,8(sp)
  4024c6:	6145                	addi	sp,sp,48
  4024c8:	8082                	ret
    printf("%s: open sbrk failed\n", s);
  4024ca:	85ce                	mv	a1,s3
  4024cc:	00004517          	auipc	a0,0x4
  4024d0:	ccc50513          	addi	a0,a0,-820 # 406198 <malloc+0xfc0>
  4024d4:	44b020ef          	jal	40511e <printf>
    exit(1);
  4024d8:	4505                	li	a0,1
  4024da:	029020ef          	jal	404d02 <exit>
    printf("%s: write sbrk failed\n", s);
  4024de:	85ce                	mv	a1,s3
  4024e0:	00004517          	auipc	a0,0x4
  4024e4:	cd050513          	addi	a0,a0,-816 # 4061b0 <malloc+0xfd8>
  4024e8:	437020ef          	jal	40511e <printf>
    exit(1);
  4024ec:	4505                	li	a0,1
  4024ee:	015020ef          	jal	404d02 <exit>
    printf("%s: pipe() failed\n", s);
  4024f2:	85ce                	mv	a1,s3
  4024f4:	00003517          	auipc	a0,0x3
  4024f8:	7ac50513          	addi	a0,a0,1964 # 405ca0 <malloc+0xac8>
  4024fc:	423020ef          	jal	40511e <printf>
    exit(1);
  402500:	4505                	li	a0,1
  402502:	001020ef          	jal	404d02 <exit>

0000000000402506 <argptest>:
{
  402506:	1101                	addi	sp,sp,-32
  402508:	ec06                	sd	ra,24(sp)
  40250a:	e822                	sd	s0,16(sp)
  40250c:	e426                	sd	s1,8(sp)
  40250e:	e04a                	sd	s2,0(sp)
  402510:	1000                	addi	s0,sp,32
  402512:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
  402514:	4581                	li	a1,0
  402516:	00004517          	auipc	a0,0x4
  40251a:	cb250513          	addi	a0,a0,-846 # 4061c8 <malloc+0xff0>
  40251e:	025020ef          	jal	404d42 <open>
  if (fd < 0) {
  402522:	02054563          	bltz	a0,40254c <argptest+0x46>
  402526:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
  402528:	4501                	li	a0,0
  40252a:	061020ef          	jal	404d8a <sbrk>
  40252e:	567d                	li	a2,-1
  402530:	00c505b3          	add	a1,a0,a2
  402534:	8526                	mv	a0,s1
  402536:	7e4020ef          	jal	404d1a <read>
  close(fd);
  40253a:	8526                	mv	a0,s1
  40253c:	7ee020ef          	jal	404d2a <close>
}
  402540:	60e2                	ld	ra,24(sp)
  402542:	6442                	ld	s0,16(sp)
  402544:	64a2                	ld	s1,8(sp)
  402546:	6902                	ld	s2,0(sp)
  402548:	6105                	addi	sp,sp,32
  40254a:	8082                	ret
    printf("%s: open failed\n", s);
  40254c:	85ca                	mv	a1,s2
  40254e:	00003517          	auipc	a0,0x3
  402552:	66250513          	addi	a0,a0,1634 # 405bb0 <malloc+0x9d8>
  402556:	3c9020ef          	jal	40511e <printf>
    exit(1);
  40255a:	4505                	li	a0,1
  40255c:	7a6020ef          	jal	404d02 <exit>

0000000000402560 <sbrkbugs>:
{
  402560:	1141                	addi	sp,sp,-16
  402562:	e406                	sd	ra,8(sp)
  402564:	e022                	sd	s0,0(sp)
  402566:	0800                	addi	s0,sp,16
  int pid = fork();
  402568:	792020ef          	jal	404cfa <fork>
  if(pid < 0){
  40256c:	00054c63          	bltz	a0,402584 <sbrkbugs+0x24>
  if(pid == 0){
  402570:	e11d                	bnez	a0,402596 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
  402572:	019020ef          	jal	404d8a <sbrk>
    sbrk(-sz);
  402576:	40a0053b          	negw	a0,a0
  40257a:	011020ef          	jal	404d8a <sbrk>
    exit(0);
  40257e:	4501                	li	a0,0
  402580:	782020ef          	jal	404d02 <exit>
    printf("fork failed\n");
  402584:	00005517          	auipc	a0,0x5
  402588:	b8450513          	addi	a0,a0,-1148 # 407108 <malloc+0x1f30>
  40258c:	393020ef          	jal	40511e <printf>
    exit(1);
  402590:	4505                	li	a0,1
  402592:	770020ef          	jal	404d02 <exit>
  wait(0);
  402596:	4501                	li	a0,0
  402598:	772020ef          	jal	404d0a <wait>
  pid = fork();
  40259c:	75e020ef          	jal	404cfa <fork>
  if(pid < 0){
  4025a0:	00054f63          	bltz	a0,4025be <sbrkbugs+0x5e>
  if(pid == 0){
  4025a4:	e515                	bnez	a0,4025d0 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
  4025a6:	7e4020ef          	jal	404d8a <sbrk>
    sbrk(-(sz - 3500));
  4025aa:	6785                	lui	a5,0x1
  4025ac:	dac7879b          	addiw	a5,a5,-596 # dac <copyinstr1-0x3ff254>
  4025b0:	40a7853b          	subw	a0,a5,a0
  4025b4:	7d6020ef          	jal	404d8a <sbrk>
    exit(0);
  4025b8:	4501                	li	a0,0
  4025ba:	748020ef          	jal	404d02 <exit>
    printf("fork failed\n");
  4025be:	00005517          	auipc	a0,0x5
  4025c2:	b4a50513          	addi	a0,a0,-1206 # 407108 <malloc+0x1f30>
  4025c6:	359020ef          	jal	40511e <printf>
    exit(1);
  4025ca:	4505                	li	a0,1
  4025cc:	736020ef          	jal	404d02 <exit>
  wait(0);
  4025d0:	4501                	li	a0,0
  4025d2:	738020ef          	jal	404d0a <wait>
  pid = fork();
  4025d6:	724020ef          	jal	404cfa <fork>
  if(pid < 0){
  4025da:	02054263          	bltz	a0,4025fe <sbrkbugs+0x9e>
  if(pid == 0){
  4025de:	e90d                	bnez	a0,402610 <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
  4025e0:	7aa020ef          	jal	404d8a <sbrk>
  4025e4:	67ad                	lui	a5,0xb
  4025e6:	8007879b          	addiw	a5,a5,-2048 # a800 <copyinstr1-0x3f5800>
  4025ea:	40a7853b          	subw	a0,a5,a0
  4025ee:	79c020ef          	jal	404d8a <sbrk>
    sbrk(-10);
  4025f2:	5559                	li	a0,-10
  4025f4:	796020ef          	jal	404d8a <sbrk>
    exit(0);
  4025f8:	4501                	li	a0,0
  4025fa:	708020ef          	jal	404d02 <exit>
    printf("fork failed\n");
  4025fe:	00005517          	auipc	a0,0x5
  402602:	b0a50513          	addi	a0,a0,-1270 # 407108 <malloc+0x1f30>
  402606:	319020ef          	jal	40511e <printf>
    exit(1);
  40260a:	4505                	li	a0,1
  40260c:	6f6020ef          	jal	404d02 <exit>
  wait(0);
  402610:	4501                	li	a0,0
  402612:	6f8020ef          	jal	404d0a <wait>
  exit(0);
  402616:	4501                	li	a0,0
  402618:	6ea020ef          	jal	404d02 <exit>

000000000040261c <sbrklast>:
{
  40261c:	7179                	addi	sp,sp,-48
  40261e:	f406                	sd	ra,40(sp)
  402620:	f022                	sd	s0,32(sp)
  402622:	ec26                	sd	s1,24(sp)
  402624:	e84a                	sd	s2,16(sp)
  402626:	e44e                	sd	s3,8(sp)
  402628:	e052                	sd	s4,0(sp)
  40262a:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
  40262c:	4501                	li	a0,0
  40262e:	75c020ef          	jal	404d8a <sbrk>
  if((top % 4096) != 0)
  402632:	03451793          	slli	a5,a0,0x34
  402636:	ebad                	bnez	a5,4026a8 <sbrklast+0x8c>
  sbrk(4096);
  402638:	6505                	lui	a0,0x1
  40263a:	750020ef          	jal	404d8a <sbrk>
  sbrk(10);
  40263e:	4529                	li	a0,10
  402640:	74a020ef          	jal	404d8a <sbrk>
  sbrk(-20);
  402644:	5531                	li	a0,-20
  402646:	744020ef          	jal	404d8a <sbrk>
  top = (uint64) sbrk(0);
  40264a:	4501                	li	a0,0
  40264c:	73e020ef          	jal	404d8a <sbrk>
  402650:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
  402652:	fc050913          	addi	s2,a0,-64 # fc0 <copyinstr1-0x3ff040>
  p[0] = 'x';
  402656:	07800a13          	li	s4,120
  40265a:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
  40265e:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
  402662:	20200593          	li	a1,514
  402666:	854a                	mv	a0,s2
  402668:	6da020ef          	jal	404d42 <open>
  40266c:	89aa                	mv	s3,a0
  write(fd, p, 1);
  40266e:	4605                	li	a2,1
  402670:	85ca                	mv	a1,s2
  402672:	6b0020ef          	jal	404d22 <write>
  close(fd);
  402676:	854e                	mv	a0,s3
  402678:	6b2020ef          	jal	404d2a <close>
  fd = open(p, O_RDWR);
  40267c:	4589                	li	a1,2
  40267e:	854a                	mv	a0,s2
  402680:	6c2020ef          	jal	404d42 <open>
  p[0] = '\0';
  402684:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
  402688:	4605                	li	a2,1
  40268a:	85ca                	mv	a1,s2
  40268c:	68e020ef          	jal	404d1a <read>
  if(p[0] != 'x')
  402690:	fc04c783          	lbu	a5,-64(s1)
  402694:	03479363          	bne	a5,s4,4026ba <sbrklast+0x9e>
}
  402698:	70a2                	ld	ra,40(sp)
  40269a:	7402                	ld	s0,32(sp)
  40269c:	64e2                	ld	s1,24(sp)
  40269e:	6942                	ld	s2,16(sp)
  4026a0:	69a2                	ld	s3,8(sp)
  4026a2:	6a02                	ld	s4,0(sp)
  4026a4:	6145                	addi	sp,sp,48
  4026a6:	8082                	ret
    sbrk(4096 - (top % 4096));
  4026a8:	6785                	lui	a5,0x1
  4026aa:	fff78713          	addi	a4,a5,-1 # fff <copyinstr1-0x3ff001>
  4026ae:	8d79                	and	a0,a0,a4
  4026b0:	40a7853b          	subw	a0,a5,a0
  4026b4:	6d6020ef          	jal	404d8a <sbrk>
  4026b8:	b741                	j	402638 <sbrklast+0x1c>
    exit(1);
  4026ba:	4505                	li	a0,1
  4026bc:	646020ef          	jal	404d02 <exit>

00000000004026c0 <sbrk8000>:
{
  4026c0:	1141                	addi	sp,sp,-16
  4026c2:	e406                	sd	ra,8(sp)
  4026c4:	e022                	sd	s0,0(sp)
  4026c6:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
  4026c8:	80000537          	lui	a0,0x80000
  4026cc:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fbf038c>
  4026ce:	6bc020ef          	jal	404d8a <sbrk>
  volatile char *top = sbrk(0);
  4026d2:	4501                	li	a0,0
  4026d4:	6b6020ef          	jal	404d8a <sbrk>
  *(top-1) = *(top-1) + 1;
  4026d8:	fff54783          	lbu	a5,-1(a0)
  4026dc:	0785                	addi	a5,a5,1
  4026de:	0ff7f793          	zext.b	a5,a5
  4026e2:	fef50fa3          	sb	a5,-1(a0)
}
  4026e6:	60a2                	ld	ra,8(sp)
  4026e8:	6402                	ld	s0,0(sp)
  4026ea:	0141                	addi	sp,sp,16
  4026ec:	8082                	ret

00000000004026ee <execout>:
{
  4026ee:	711d                	addi	sp,sp,-96
  4026f0:	ec86                	sd	ra,88(sp)
  4026f2:	e8a2                	sd	s0,80(sp)
  4026f4:	e4a6                	sd	s1,72(sp)
  4026f6:	e0ca                	sd	s2,64(sp)
  4026f8:	fc4e                	sd	s3,56(sp)
  4026fa:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
  4026fc:	4901                	li	s2,0
  4026fe:	49bd                	li	s3,15
    int pid = fork();
  402700:	5fa020ef          	jal	404cfa <fork>
  402704:	84aa                	mv	s1,a0
    if(pid < 0){
  402706:	00054e63          	bltz	a0,402722 <execout+0x34>
    } else if(pid == 0){
  40270a:	c51d                	beqz	a0,402738 <execout+0x4a>
      wait((int*)0);
  40270c:	4501                	li	a0,0
  40270e:	5fc020ef          	jal	404d0a <wait>
  for(int avail = 0; avail < 15; avail++){
  402712:	2905                	addiw	s2,s2,1
  402714:	ff3916e3          	bne	s2,s3,402700 <execout+0x12>
  402718:	f852                	sd	s4,48(sp)
  40271a:	f456                	sd	s5,40(sp)
  exit(0);
  40271c:	4501                	li	a0,0
  40271e:	5e4020ef          	jal	404d02 <exit>
  402722:	f852                	sd	s4,48(sp)
  402724:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
  402726:	00005517          	auipc	a0,0x5
  40272a:	9e250513          	addi	a0,a0,-1566 # 407108 <malloc+0x1f30>
  40272e:	1f1020ef          	jal	40511e <printf>
      exit(1);
  402732:	4505                	li	a0,1
  402734:	5ce020ef          	jal	404d02 <exit>
  402738:	f852                	sd	s4,48(sp)
  40273a:	f456                	sd	s5,40(sp)
        uint64 a = (uint64) sbrk(4096);
  40273c:	6985                	lui	s3,0x1
        if(a == 0xffffffffffffffffLL)
  40273e:	5a7d                	li	s4,-1
        *(char*)(a + 4096 - 1) = 1;
  402740:	4a85                	li	s5,1
        uint64 a = (uint64) sbrk(4096);
  402742:	854e                	mv	a0,s3
  402744:	646020ef          	jal	404d8a <sbrk>
        if(a == 0xffffffffffffffffLL)
  402748:	01450663          	beq	a0,s4,402754 <execout+0x66>
        *(char*)(a + 4096 - 1) = 1;
  40274c:	954e                	add	a0,a0,s3
  40274e:	ff550fa3          	sb	s5,-1(a0)
      while(1){
  402752:	bfc5                	j	402742 <execout+0x54>
        sbrk(-4096);
  402754:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
  402756:	01205863          	blez	s2,402766 <execout+0x78>
        sbrk(-4096);
  40275a:	854e                	mv	a0,s3
  40275c:	62e020ef          	jal	404d8a <sbrk>
      for(int i = 0; i < avail; i++)
  402760:	2485                	addiw	s1,s1,1
  402762:	ff249ce3          	bne	s1,s2,40275a <execout+0x6c>
      close(1);
  402766:	4505                	li	a0,1
  402768:	5c2020ef          	jal	404d2a <close>
      char *args[] = { "echo", "x", 0 };
  40276c:	00003517          	auipc	a0,0x3
  402770:	b9c50513          	addi	a0,a0,-1124 # 405308 <malloc+0x130>
  402774:	faa43423          	sd	a0,-88(s0)
  402778:	00003797          	auipc	a5,0x3
  40277c:	c0078793          	addi	a5,a5,-1024 # 405378 <malloc+0x1a0>
  402780:	faf43823          	sd	a5,-80(s0)
  402784:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
  402788:	fa840593          	addi	a1,s0,-88
  40278c:	5ae020ef          	jal	404d3a <exec>
      exit(0);
  402790:	4501                	li	a0,0
  402792:	570020ef          	jal	404d02 <exit>

0000000000402796 <fourteen>:
{
  402796:	1101                	addi	sp,sp,-32
  402798:	ec06                	sd	ra,24(sp)
  40279a:	e822                	sd	s0,16(sp)
  40279c:	e426                	sd	s1,8(sp)
  40279e:	1000                	addi	s0,sp,32
  4027a0:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
  4027a2:	00004517          	auipc	a0,0x4
  4027a6:	bfe50513          	addi	a0,a0,-1026 # 4063a0 <malloc+0x11c8>
  4027aa:	5c0020ef          	jal	404d6a <mkdir>
  4027ae:	e555                	bnez	a0,40285a <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
  4027b0:	00004517          	auipc	a0,0x4
  4027b4:	a4850513          	addi	a0,a0,-1464 # 4061f8 <malloc+0x1020>
  4027b8:	5b2020ef          	jal	404d6a <mkdir>
  4027bc:	e94d                	bnez	a0,40286e <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
  4027be:	20000593          	li	a1,512
  4027c2:	00004517          	auipc	a0,0x4
  4027c6:	a8e50513          	addi	a0,a0,-1394 # 406250 <malloc+0x1078>
  4027ca:	578020ef          	jal	404d42 <open>
  if(fd < 0){
  4027ce:	0a054a63          	bltz	a0,402882 <fourteen+0xec>
  close(fd);
  4027d2:	558020ef          	jal	404d2a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
  4027d6:	4581                	li	a1,0
  4027d8:	00004517          	auipc	a0,0x4
  4027dc:	af050513          	addi	a0,a0,-1296 # 4062c8 <malloc+0x10f0>
  4027e0:	562020ef          	jal	404d42 <open>
  if(fd < 0){
  4027e4:	0a054963          	bltz	a0,402896 <fourteen+0x100>
  close(fd);
  4027e8:	542020ef          	jal	404d2a <close>
  if(mkdir("12345678901234/12345678901234") == 0){
  4027ec:	00004517          	auipc	a0,0x4
  4027f0:	b4c50513          	addi	a0,a0,-1204 # 406338 <malloc+0x1160>
  4027f4:	576020ef          	jal	404d6a <mkdir>
  4027f8:	c94d                	beqz	a0,4028aa <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
  4027fa:	00004517          	auipc	a0,0x4
  4027fe:	b9650513          	addi	a0,a0,-1130 # 406390 <malloc+0x11b8>
  402802:	568020ef          	jal	404d6a <mkdir>
  402806:	cd45                	beqz	a0,4028be <fourteen+0x128>
  unlink("123456789012345/12345678901234");
  402808:	00004517          	auipc	a0,0x4
  40280c:	b8850513          	addi	a0,a0,-1144 # 406390 <malloc+0x11b8>
  402810:	542020ef          	jal	404d52 <unlink>
  unlink("12345678901234/12345678901234");
  402814:	00004517          	auipc	a0,0x4
  402818:	b2450513          	addi	a0,a0,-1244 # 406338 <malloc+0x1160>
  40281c:	536020ef          	jal	404d52 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
  402820:	00004517          	auipc	a0,0x4
  402824:	aa850513          	addi	a0,a0,-1368 # 4062c8 <malloc+0x10f0>
  402828:	52a020ef          	jal	404d52 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
  40282c:	00004517          	auipc	a0,0x4
  402830:	a2450513          	addi	a0,a0,-1500 # 406250 <malloc+0x1078>
  402834:	51e020ef          	jal	404d52 <unlink>
  unlink("12345678901234/123456789012345");
  402838:	00004517          	auipc	a0,0x4
  40283c:	9c050513          	addi	a0,a0,-1600 # 4061f8 <malloc+0x1020>
  402840:	512020ef          	jal	404d52 <unlink>
  unlink("12345678901234");
  402844:	00004517          	auipc	a0,0x4
  402848:	b5c50513          	addi	a0,a0,-1188 # 4063a0 <malloc+0x11c8>
  40284c:	506020ef          	jal	404d52 <unlink>
}
  402850:	60e2                	ld	ra,24(sp)
  402852:	6442                	ld	s0,16(sp)
  402854:	64a2                	ld	s1,8(sp)
  402856:	6105                	addi	sp,sp,32
  402858:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
  40285a:	85a6                	mv	a1,s1
  40285c:	00004517          	auipc	a0,0x4
  402860:	97450513          	addi	a0,a0,-1676 # 4061d0 <malloc+0xff8>
  402864:	0bb020ef          	jal	40511e <printf>
    exit(1);
  402868:	4505                	li	a0,1
  40286a:	498020ef          	jal	404d02 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
  40286e:	85a6                	mv	a1,s1
  402870:	00004517          	auipc	a0,0x4
  402874:	9a850513          	addi	a0,a0,-1624 # 406218 <malloc+0x1040>
  402878:	0a7020ef          	jal	40511e <printf>
    exit(1);
  40287c:	4505                	li	a0,1
  40287e:	484020ef          	jal	404d02 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
  402882:	85a6                	mv	a1,s1
  402884:	00004517          	auipc	a0,0x4
  402888:	9fc50513          	addi	a0,a0,-1540 # 406280 <malloc+0x10a8>
  40288c:	093020ef          	jal	40511e <printf>
    exit(1);
  402890:	4505                	li	a0,1
  402892:	470020ef          	jal	404d02 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
  402896:	85a6                	mv	a1,s1
  402898:	00004517          	auipc	a0,0x4
  40289c:	a6050513          	addi	a0,a0,-1440 # 4062f8 <malloc+0x1120>
  4028a0:	07f020ef          	jal	40511e <printf>
    exit(1);
  4028a4:	4505                	li	a0,1
  4028a6:	45c020ef          	jal	404d02 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
  4028aa:	85a6                	mv	a1,s1
  4028ac:	00004517          	auipc	a0,0x4
  4028b0:	aac50513          	addi	a0,a0,-1364 # 406358 <malloc+0x1180>
  4028b4:	06b020ef          	jal	40511e <printf>
    exit(1);
  4028b8:	4505                	li	a0,1
  4028ba:	448020ef          	jal	404d02 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
  4028be:	85a6                	mv	a1,s1
  4028c0:	00004517          	auipc	a0,0x4
  4028c4:	af050513          	addi	a0,a0,-1296 # 4063b0 <malloc+0x11d8>
  4028c8:	057020ef          	jal	40511e <printf>
    exit(1);
  4028cc:	4505                	li	a0,1
  4028ce:	434020ef          	jal	404d02 <exit>

00000000004028d2 <diskfull>:
{
  4028d2:	b6010113          	addi	sp,sp,-1184
  4028d6:	48113c23          	sd	ra,1176(sp)
  4028da:	48813823          	sd	s0,1168(sp)
  4028de:	48913423          	sd	s1,1160(sp)
  4028e2:	49213023          	sd	s2,1152(sp)
  4028e6:	47313c23          	sd	s3,1144(sp)
  4028ea:	47413823          	sd	s4,1136(sp)
  4028ee:	47513423          	sd	s5,1128(sp)
  4028f2:	47613023          	sd	s6,1120(sp)
  4028f6:	45713c23          	sd	s7,1112(sp)
  4028fa:	45813823          	sd	s8,1104(sp)
  4028fe:	45913423          	sd	s9,1096(sp)
  402902:	45a13023          	sd	s10,1088(sp)
  402906:	43b13c23          	sd	s11,1080(sp)
  40290a:	4a010413          	addi	s0,sp,1184
  40290e:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
  402912:	00004517          	auipc	a0,0x4
  402916:	ad650513          	addi	a0,a0,-1322 # 4063e8 <malloc+0x1210>
  40291a:	438020ef          	jal	404d52 <unlink>
  40291e:	03000a93          	li	s5,48
    name[0] = 'b';
  402922:	06200d13          	li	s10,98
    name[1] = 'i';
  402926:	06900c93          	li	s9,105
    name[2] = 'g';
  40292a:	06700c13          	li	s8,103
    unlink(name);
  40292e:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
  402932:	60200b93          	li	s7,1538
  402936:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
  40293a:	b9040a13          	addi	s4,s0,-1136
  40293e:	aa8d                	j	402ab0 <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
  402940:	b7040613          	addi	a2,s0,-1168
  402944:	b6843583          	ld	a1,-1176(s0)
  402948:	00004517          	auipc	a0,0x4
  40294c:	ab050513          	addi	a0,a0,-1360 # 4063f8 <malloc+0x1220>
  402950:	7ce020ef          	jal	40511e <printf>
      break;
  402954:	a039                	j	402962 <diskfull+0x90>
        close(fd);
  402956:	854e                	mv	a0,s3
  402958:	3d2020ef          	jal	404d2a <close>
    close(fd);
  40295c:	854e                	mv	a0,s3
  40295e:	3cc020ef          	jal	404d2a <close>
  for(int i = 0; i < nzz; i++){
  402962:	4481                	li	s1,0
    name[0] = 'z';
  402964:	07a00993          	li	s3,122
    unlink(name);
  402968:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
  40296c:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
  402970:	08000a93          	li	s5,128
    name[0] = 'z';
  402974:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
  402978:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
  40297c:	41f4d71b          	sraiw	a4,s1,0x1f
  402980:	01b7571b          	srliw	a4,a4,0x1b
  402984:	009707bb          	addw	a5,a4,s1
  402988:	4057d69b          	sraiw	a3,a5,0x5
  40298c:	0306869b          	addiw	a3,a3,48
  402990:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
  402994:	8bfd                	andi	a5,a5,31
  402996:	9f99                	subw	a5,a5,a4
  402998:	0307879b          	addiw	a5,a5,48
  40299c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
  4029a0:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
  4029a4:	854a                	mv	a0,s2
  4029a6:	3ac020ef          	jal	404d52 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
  4029aa:	85d2                	mv	a1,s4
  4029ac:	854a                	mv	a0,s2
  4029ae:	394020ef          	jal	404d42 <open>
    if(fd < 0)
  4029b2:	00054763          	bltz	a0,4029c0 <diskfull+0xee>
    close(fd);
  4029b6:	374020ef          	jal	404d2a <close>
  for(int i = 0; i < nzz; i++){
  4029ba:	2485                	addiw	s1,s1,1
  4029bc:	fb549ce3          	bne	s1,s5,402974 <diskfull+0xa2>
  if(mkdir("diskfulldir") == 0)
  4029c0:	00004517          	auipc	a0,0x4
  4029c4:	a2850513          	addi	a0,a0,-1496 # 4063e8 <malloc+0x1210>
  4029c8:	3a2020ef          	jal	404d6a <mkdir>
  4029cc:	12050363          	beqz	a0,402af2 <diskfull+0x220>
  unlink("diskfulldir");
  4029d0:	00004517          	auipc	a0,0x4
  4029d4:	a1850513          	addi	a0,a0,-1512 # 4063e8 <malloc+0x1210>
  4029d8:	37a020ef          	jal	404d52 <unlink>
  for(int i = 0; i < nzz; i++){
  4029dc:	4481                	li	s1,0
    name[0] = 'z';
  4029de:	07a00913          	li	s2,122
    unlink(name);
  4029e2:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
  4029e6:	08000993          	li	s3,128
    name[0] = 'z';
  4029ea:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
  4029ee:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
  4029f2:	41f4d71b          	sraiw	a4,s1,0x1f
  4029f6:	01b7571b          	srliw	a4,a4,0x1b
  4029fa:	009707bb          	addw	a5,a4,s1
  4029fe:	4057d69b          	sraiw	a3,a5,0x5
  402a02:	0306869b          	addiw	a3,a3,48
  402a06:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
  402a0a:	8bfd                	andi	a5,a5,31
  402a0c:	9f99                	subw	a5,a5,a4
  402a0e:	0307879b          	addiw	a5,a5,48
  402a12:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
  402a16:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
  402a1a:	8552                	mv	a0,s4
  402a1c:	336020ef          	jal	404d52 <unlink>
  for(int i = 0; i < nzz; i++){
  402a20:	2485                	addiw	s1,s1,1
  402a22:	fd3494e3          	bne	s1,s3,4029ea <diskfull+0x118>
  402a26:	03000493          	li	s1,48
    name[0] = 'b';
  402a2a:	06200b13          	li	s6,98
    name[1] = 'i';
  402a2e:	06900a93          	li	s5,105
    name[2] = 'g';
  402a32:	06700a13          	li	s4,103
    unlink(name);
  402a36:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
  402a3a:	07f00913          	li	s2,127
    name[0] = 'b';
  402a3e:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
  402a42:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
  402a46:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
  402a4a:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
  402a4e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
  402a52:	854e                	mv	a0,s3
  402a54:	2fe020ef          	jal	404d52 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
  402a58:	2485                	addiw	s1,s1,1
  402a5a:	0ff4f493          	zext.b	s1,s1
  402a5e:	ff2490e3          	bne	s1,s2,402a3e <diskfull+0x16c>
}
  402a62:	49813083          	ld	ra,1176(sp)
  402a66:	49013403          	ld	s0,1168(sp)
  402a6a:	48813483          	ld	s1,1160(sp)
  402a6e:	48013903          	ld	s2,1152(sp)
  402a72:	47813983          	ld	s3,1144(sp)
  402a76:	47013a03          	ld	s4,1136(sp)
  402a7a:	46813a83          	ld	s5,1128(sp)
  402a7e:	46013b03          	ld	s6,1120(sp)
  402a82:	45813b83          	ld	s7,1112(sp)
  402a86:	45013c03          	ld	s8,1104(sp)
  402a8a:	44813c83          	ld	s9,1096(sp)
  402a8e:	44013d03          	ld	s10,1088(sp)
  402a92:	43813d83          	ld	s11,1080(sp)
  402a96:	4a010113          	addi	sp,sp,1184
  402a9a:	8082                	ret
    close(fd);
  402a9c:	854e                	mv	a0,s3
  402a9e:	28c020ef          	jal	404d2a <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
  402aa2:	2a85                	addiw	s5,s5,1
  402aa4:	0ffafa93          	zext.b	s5,s5
  402aa8:	07f00793          	li	a5,127
  402aac:	eafa8be3          	beq	s5,a5,402962 <diskfull+0x90>
    name[0] = 'b';
  402ab0:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
  402ab4:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
  402ab8:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
  402abc:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
  402ac0:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
  402ac4:	855a                	mv	a0,s6
  402ac6:	28c020ef          	jal	404d52 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
  402aca:	85de                	mv	a1,s7
  402acc:	855a                	mv	a0,s6
  402ace:	274020ef          	jal	404d42 <open>
  402ad2:	89aa                	mv	s3,a0
    if(fd < 0){
  402ad4:	e60546e3          	bltz	a0,402940 <diskfull+0x6e>
  402ad8:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
  402ada:	40000913          	li	s2,1024
  402ade:	864a                	mv	a2,s2
  402ae0:	85d2                	mv	a1,s4
  402ae2:	854e                	mv	a0,s3
  402ae4:	23e020ef          	jal	404d22 <write>
  402ae8:	e72517e3          	bne	a0,s2,402956 <diskfull+0x84>
    for(int i = 0; i < MAXFILE; i++){
  402aec:	34fd                	addiw	s1,s1,-1
  402aee:	f8e5                	bnez	s1,402ade <diskfull+0x20c>
  402af0:	b775                	j	402a9c <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
  402af2:	b6843583          	ld	a1,-1176(s0)
  402af6:	00004517          	auipc	a0,0x4
  402afa:	92250513          	addi	a0,a0,-1758 # 406418 <malloc+0x1240>
  402afe:	620020ef          	jal	40511e <printf>
  402b02:	b5f9                	j	4029d0 <diskfull+0xfe>

0000000000402b04 <iputtest>:
{
  402b04:	1101                	addi	sp,sp,-32
  402b06:	ec06                	sd	ra,24(sp)
  402b08:	e822                	sd	s0,16(sp)
  402b0a:	e426                	sd	s1,8(sp)
  402b0c:	1000                	addi	s0,sp,32
  402b0e:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
  402b10:	00004517          	auipc	a0,0x4
  402b14:	93850513          	addi	a0,a0,-1736 # 406448 <malloc+0x1270>
  402b18:	252020ef          	jal	404d6a <mkdir>
  402b1c:	02054f63          	bltz	a0,402b5a <iputtest+0x56>
  if(chdir("iputdir") < 0){
  402b20:	00004517          	auipc	a0,0x4
  402b24:	92850513          	addi	a0,a0,-1752 # 406448 <malloc+0x1270>
  402b28:	24a020ef          	jal	404d72 <chdir>
  402b2c:	04054163          	bltz	a0,402b6e <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
  402b30:	00004517          	auipc	a0,0x4
  402b34:	95850513          	addi	a0,a0,-1704 # 406488 <malloc+0x12b0>
  402b38:	21a020ef          	jal	404d52 <unlink>
  402b3c:	04054363          	bltz	a0,402b82 <iputtest+0x7e>
  if(chdir("/") < 0){
  402b40:	00004517          	auipc	a0,0x4
  402b44:	97850513          	addi	a0,a0,-1672 # 4064b8 <malloc+0x12e0>
  402b48:	22a020ef          	jal	404d72 <chdir>
  402b4c:	04054563          	bltz	a0,402b96 <iputtest+0x92>
}
  402b50:	60e2                	ld	ra,24(sp)
  402b52:	6442                	ld	s0,16(sp)
  402b54:	64a2                	ld	s1,8(sp)
  402b56:	6105                	addi	sp,sp,32
  402b58:	8082                	ret
    printf("%s: mkdir failed\n", s);
  402b5a:	85a6                	mv	a1,s1
  402b5c:	00004517          	auipc	a0,0x4
  402b60:	8f450513          	addi	a0,a0,-1804 # 406450 <malloc+0x1278>
  402b64:	5ba020ef          	jal	40511e <printf>
    exit(1);
  402b68:	4505                	li	a0,1
  402b6a:	198020ef          	jal	404d02 <exit>
    printf("%s: chdir iputdir failed\n", s);
  402b6e:	85a6                	mv	a1,s1
  402b70:	00004517          	auipc	a0,0x4
  402b74:	8f850513          	addi	a0,a0,-1800 # 406468 <malloc+0x1290>
  402b78:	5a6020ef          	jal	40511e <printf>
    exit(1);
  402b7c:	4505                	li	a0,1
  402b7e:	184020ef          	jal	404d02 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
  402b82:	85a6                	mv	a1,s1
  402b84:	00004517          	auipc	a0,0x4
  402b88:	91450513          	addi	a0,a0,-1772 # 406498 <malloc+0x12c0>
  402b8c:	592020ef          	jal	40511e <printf>
    exit(1);
  402b90:	4505                	li	a0,1
  402b92:	170020ef          	jal	404d02 <exit>
    printf("%s: chdir / failed\n", s);
  402b96:	85a6                	mv	a1,s1
  402b98:	00004517          	auipc	a0,0x4
  402b9c:	92850513          	addi	a0,a0,-1752 # 4064c0 <malloc+0x12e8>
  402ba0:	57e020ef          	jal	40511e <printf>
    exit(1);
  402ba4:	4505                	li	a0,1
  402ba6:	15c020ef          	jal	404d02 <exit>

0000000000402baa <exitiputtest>:
{
  402baa:	7179                	addi	sp,sp,-48
  402bac:	f406                	sd	ra,40(sp)
  402bae:	f022                	sd	s0,32(sp)
  402bb0:	ec26                	sd	s1,24(sp)
  402bb2:	1800                	addi	s0,sp,48
  402bb4:	84aa                	mv	s1,a0
  pid = fork();
  402bb6:	144020ef          	jal	404cfa <fork>
  if(pid < 0){
  402bba:	02054e63          	bltz	a0,402bf6 <exitiputtest+0x4c>
  if(pid == 0){
  402bbe:	e541                	bnez	a0,402c46 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
  402bc0:	00004517          	auipc	a0,0x4
  402bc4:	88850513          	addi	a0,a0,-1912 # 406448 <malloc+0x1270>
  402bc8:	1a2020ef          	jal	404d6a <mkdir>
  402bcc:	02054f63          	bltz	a0,402c0a <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
  402bd0:	00004517          	auipc	a0,0x4
  402bd4:	87850513          	addi	a0,a0,-1928 # 406448 <malloc+0x1270>
  402bd8:	19a020ef          	jal	404d72 <chdir>
  402bdc:	04054163          	bltz	a0,402c1e <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
  402be0:	00004517          	auipc	a0,0x4
  402be4:	8a850513          	addi	a0,a0,-1880 # 406488 <malloc+0x12b0>
  402be8:	16a020ef          	jal	404d52 <unlink>
  402bec:	04054363          	bltz	a0,402c32 <exitiputtest+0x88>
    exit(0);
  402bf0:	4501                	li	a0,0
  402bf2:	110020ef          	jal	404d02 <exit>
    printf("%s: fork failed\n", s);
  402bf6:	85a6                	mv	a1,s1
  402bf8:	00003517          	auipc	a0,0x3
  402bfc:	fa050513          	addi	a0,a0,-96 # 405b98 <malloc+0x9c0>
  402c00:	51e020ef          	jal	40511e <printf>
    exit(1);
  402c04:	4505                	li	a0,1
  402c06:	0fc020ef          	jal	404d02 <exit>
      printf("%s: mkdir failed\n", s);
  402c0a:	85a6                	mv	a1,s1
  402c0c:	00004517          	auipc	a0,0x4
  402c10:	84450513          	addi	a0,a0,-1980 # 406450 <malloc+0x1278>
  402c14:	50a020ef          	jal	40511e <printf>
      exit(1);
  402c18:	4505                	li	a0,1
  402c1a:	0e8020ef          	jal	404d02 <exit>
      printf("%s: child chdir failed\n", s);
  402c1e:	85a6                	mv	a1,s1
  402c20:	00004517          	auipc	a0,0x4
  402c24:	8b850513          	addi	a0,a0,-1864 # 4064d8 <malloc+0x1300>
  402c28:	4f6020ef          	jal	40511e <printf>
      exit(1);
  402c2c:	4505                	li	a0,1
  402c2e:	0d4020ef          	jal	404d02 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
  402c32:	85a6                	mv	a1,s1
  402c34:	00004517          	auipc	a0,0x4
  402c38:	86450513          	addi	a0,a0,-1948 # 406498 <malloc+0x12c0>
  402c3c:	4e2020ef          	jal	40511e <printf>
      exit(1);
  402c40:	4505                	li	a0,1
  402c42:	0c0020ef          	jal	404d02 <exit>
  wait(&xstatus);
  402c46:	fdc40513          	addi	a0,s0,-36
  402c4a:	0c0020ef          	jal	404d0a <wait>
  exit(xstatus);
  402c4e:	fdc42503          	lw	a0,-36(s0)
  402c52:	0b0020ef          	jal	404d02 <exit>

0000000000402c56 <dirtest>:
{
  402c56:	1101                	addi	sp,sp,-32
  402c58:	ec06                	sd	ra,24(sp)
  402c5a:	e822                	sd	s0,16(sp)
  402c5c:	e426                	sd	s1,8(sp)
  402c5e:	1000                	addi	s0,sp,32
  402c60:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
  402c62:	00004517          	auipc	a0,0x4
  402c66:	88e50513          	addi	a0,a0,-1906 # 4064f0 <malloc+0x1318>
  402c6a:	100020ef          	jal	404d6a <mkdir>
  402c6e:	02054f63          	bltz	a0,402cac <dirtest+0x56>
  if(chdir("dir0") < 0){
  402c72:	00004517          	auipc	a0,0x4
  402c76:	87e50513          	addi	a0,a0,-1922 # 4064f0 <malloc+0x1318>
  402c7a:	0f8020ef          	jal	404d72 <chdir>
  402c7e:	04054163          	bltz	a0,402cc0 <dirtest+0x6a>
  if(chdir("..") < 0){
  402c82:	00004517          	auipc	a0,0x4
  402c86:	88e50513          	addi	a0,a0,-1906 # 406510 <malloc+0x1338>
  402c8a:	0e8020ef          	jal	404d72 <chdir>
  402c8e:	04054363          	bltz	a0,402cd4 <dirtest+0x7e>
  if(unlink("dir0") < 0){
  402c92:	00004517          	auipc	a0,0x4
  402c96:	85e50513          	addi	a0,a0,-1954 # 4064f0 <malloc+0x1318>
  402c9a:	0b8020ef          	jal	404d52 <unlink>
  402c9e:	04054563          	bltz	a0,402ce8 <dirtest+0x92>
}
  402ca2:	60e2                	ld	ra,24(sp)
  402ca4:	6442                	ld	s0,16(sp)
  402ca6:	64a2                	ld	s1,8(sp)
  402ca8:	6105                	addi	sp,sp,32
  402caa:	8082                	ret
    printf("%s: mkdir failed\n", s);
  402cac:	85a6                	mv	a1,s1
  402cae:	00003517          	auipc	a0,0x3
  402cb2:	7a250513          	addi	a0,a0,1954 # 406450 <malloc+0x1278>
  402cb6:	468020ef          	jal	40511e <printf>
    exit(1);
  402cba:	4505                	li	a0,1
  402cbc:	046020ef          	jal	404d02 <exit>
    printf("%s: chdir dir0 failed\n", s);
  402cc0:	85a6                	mv	a1,s1
  402cc2:	00004517          	auipc	a0,0x4
  402cc6:	83650513          	addi	a0,a0,-1994 # 4064f8 <malloc+0x1320>
  402cca:	454020ef          	jal	40511e <printf>
    exit(1);
  402cce:	4505                	li	a0,1
  402cd0:	032020ef          	jal	404d02 <exit>
    printf("%s: chdir .. failed\n", s);
  402cd4:	85a6                	mv	a1,s1
  402cd6:	00004517          	auipc	a0,0x4
  402cda:	84250513          	addi	a0,a0,-1982 # 406518 <malloc+0x1340>
  402cde:	440020ef          	jal	40511e <printf>
    exit(1);
  402ce2:	4505                	li	a0,1
  402ce4:	01e020ef          	jal	404d02 <exit>
    printf("%s: unlink dir0 failed\n", s);
  402ce8:	85a6                	mv	a1,s1
  402cea:	00004517          	auipc	a0,0x4
  402cee:	84650513          	addi	a0,a0,-1978 # 406530 <malloc+0x1358>
  402cf2:	42c020ef          	jal	40511e <printf>
    exit(1);
  402cf6:	4505                	li	a0,1
  402cf8:	00a020ef          	jal	404d02 <exit>

0000000000402cfc <subdir>:
{
  402cfc:	1101                	addi	sp,sp,-32
  402cfe:	ec06                	sd	ra,24(sp)
  402d00:	e822                	sd	s0,16(sp)
  402d02:	e426                	sd	s1,8(sp)
  402d04:	e04a                	sd	s2,0(sp)
  402d06:	1000                	addi	s0,sp,32
  402d08:	892a                	mv	s2,a0
  unlink("ff");
  402d0a:	00004517          	auipc	a0,0x4
  402d0e:	96e50513          	addi	a0,a0,-1682 # 406678 <malloc+0x14a0>
  402d12:	040020ef          	jal	404d52 <unlink>
  if(mkdir("dd") != 0){
  402d16:	00004517          	auipc	a0,0x4
  402d1a:	83250513          	addi	a0,a0,-1998 # 406548 <malloc+0x1370>
  402d1e:	04c020ef          	jal	404d6a <mkdir>
  402d22:	2e051263          	bnez	a0,403006 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
  402d26:	20200593          	li	a1,514
  402d2a:	00004517          	auipc	a0,0x4
  402d2e:	83e50513          	addi	a0,a0,-1986 # 406568 <malloc+0x1390>
  402d32:	010020ef          	jal	404d42 <open>
  402d36:	84aa                	mv	s1,a0
  if(fd < 0){
  402d38:	2e054163          	bltz	a0,40301a <subdir+0x31e>
  write(fd, "ff", 2);
  402d3c:	4609                	li	a2,2
  402d3e:	00004597          	auipc	a1,0x4
  402d42:	93a58593          	addi	a1,a1,-1734 # 406678 <malloc+0x14a0>
  402d46:	7dd010ef          	jal	404d22 <write>
  close(fd);
  402d4a:	8526                	mv	a0,s1
  402d4c:	7df010ef          	jal	404d2a <close>
  if(unlink("dd") >= 0){
  402d50:	00003517          	auipc	a0,0x3
  402d54:	7f850513          	addi	a0,a0,2040 # 406548 <malloc+0x1370>
  402d58:	7fb010ef          	jal	404d52 <unlink>
  402d5c:	2c055963          	bgez	a0,40302e <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
  402d60:	00004517          	auipc	a0,0x4
  402d64:	86050513          	addi	a0,a0,-1952 # 4065c0 <malloc+0x13e8>
  402d68:	002020ef          	jal	404d6a <mkdir>
  402d6c:	2c051b63          	bnez	a0,403042 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
  402d70:	20200593          	li	a1,514
  402d74:	00004517          	auipc	a0,0x4
  402d78:	87450513          	addi	a0,a0,-1932 # 4065e8 <malloc+0x1410>
  402d7c:	7c7010ef          	jal	404d42 <open>
  402d80:	84aa                	mv	s1,a0
  if(fd < 0){
  402d82:	2c054a63          	bltz	a0,403056 <subdir+0x35a>
  write(fd, "FF", 2);
  402d86:	4609                	li	a2,2
  402d88:	00004597          	auipc	a1,0x4
  402d8c:	89058593          	addi	a1,a1,-1904 # 406618 <malloc+0x1440>
  402d90:	793010ef          	jal	404d22 <write>
  close(fd);
  402d94:	8526                	mv	a0,s1
  402d96:	795010ef          	jal	404d2a <close>
  fd = open("dd/dd/../ff", 0);
  402d9a:	4581                	li	a1,0
  402d9c:	00004517          	auipc	a0,0x4
  402da0:	88450513          	addi	a0,a0,-1916 # 406620 <malloc+0x1448>
  402da4:	79f010ef          	jal	404d42 <open>
  402da8:	84aa                	mv	s1,a0
  if(fd < 0){
  402daa:	2c054063          	bltz	a0,40306a <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
  402dae:	660d                	lui	a2,0x3
  402db0:	0000a597          	auipc	a1,0xa
  402db4:	ec858593          	addi	a1,a1,-312 # 40cc78 <buf>
  402db8:	763010ef          	jal	404d1a <read>
  if(cc != 2 || buf[0] != 'f'){
  402dbc:	4789                	li	a5,2
  402dbe:	2cf51063          	bne	a0,a5,40307e <subdir+0x382>
  402dc2:	0000a717          	auipc	a4,0xa
  402dc6:	eb674703          	lbu	a4,-330(a4) # 40cc78 <buf>
  402dca:	06600793          	li	a5,102
  402dce:	2af71863          	bne	a4,a5,40307e <subdir+0x382>
  close(fd);
  402dd2:	8526                	mv	a0,s1
  402dd4:	757010ef          	jal	404d2a <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
  402dd8:	00004597          	auipc	a1,0x4
  402ddc:	89858593          	addi	a1,a1,-1896 # 406670 <malloc+0x1498>
  402de0:	00004517          	auipc	a0,0x4
  402de4:	80850513          	addi	a0,a0,-2040 # 4065e8 <malloc+0x1410>
  402de8:	77b010ef          	jal	404d62 <link>
  402dec:	2a051363          	bnez	a0,403092 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
  402df0:	00003517          	auipc	a0,0x3
  402df4:	7f850513          	addi	a0,a0,2040 # 4065e8 <malloc+0x1410>
  402df8:	75b010ef          	jal	404d52 <unlink>
  402dfc:	2a051563          	bnez	a0,4030a6 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
  402e00:	4581                	li	a1,0
  402e02:	00003517          	auipc	a0,0x3
  402e06:	7e650513          	addi	a0,a0,2022 # 4065e8 <malloc+0x1410>
  402e0a:	739010ef          	jal	404d42 <open>
  402e0e:	2a055663          	bgez	a0,4030ba <subdir+0x3be>
  if(chdir("dd") != 0){
  402e12:	00003517          	auipc	a0,0x3
  402e16:	73650513          	addi	a0,a0,1846 # 406548 <malloc+0x1370>
  402e1a:	759010ef          	jal	404d72 <chdir>
  402e1e:	2a051863          	bnez	a0,4030ce <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
  402e22:	00004517          	auipc	a0,0x4
  402e26:	8e650513          	addi	a0,a0,-1818 # 406708 <malloc+0x1530>
  402e2a:	749010ef          	jal	404d72 <chdir>
  402e2e:	2a051a63          	bnez	a0,4030e2 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
  402e32:	00004517          	auipc	a0,0x4
  402e36:	90650513          	addi	a0,a0,-1786 # 406738 <malloc+0x1560>
  402e3a:	739010ef          	jal	404d72 <chdir>
  402e3e:	2a051c63          	bnez	a0,4030f6 <subdir+0x3fa>
  if(chdir("./..") != 0){
  402e42:	00004517          	auipc	a0,0x4
  402e46:	92e50513          	addi	a0,a0,-1746 # 406770 <malloc+0x1598>
  402e4a:	729010ef          	jal	404d72 <chdir>
  402e4e:	2a051e63          	bnez	a0,40310a <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
  402e52:	4581                	li	a1,0
  402e54:	00004517          	auipc	a0,0x4
  402e58:	81c50513          	addi	a0,a0,-2020 # 406670 <malloc+0x1498>
  402e5c:	6e7010ef          	jal	404d42 <open>
  402e60:	84aa                	mv	s1,a0
  if(fd < 0){
  402e62:	2a054e63          	bltz	a0,40311e <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
  402e66:	660d                	lui	a2,0x3
  402e68:	0000a597          	auipc	a1,0xa
  402e6c:	e1058593          	addi	a1,a1,-496 # 40cc78 <buf>
  402e70:	6ab010ef          	jal	404d1a <read>
  402e74:	4789                	li	a5,2
  402e76:	2af51e63          	bne	a0,a5,403132 <subdir+0x436>
  close(fd);
  402e7a:	8526                	mv	a0,s1
  402e7c:	6af010ef          	jal	404d2a <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
  402e80:	4581                	li	a1,0
  402e82:	00003517          	auipc	a0,0x3
  402e86:	76650513          	addi	a0,a0,1894 # 4065e8 <malloc+0x1410>
  402e8a:	6b9010ef          	jal	404d42 <open>
  402e8e:	2a055c63          	bgez	a0,403146 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
  402e92:	20200593          	li	a1,514
  402e96:	00004517          	auipc	a0,0x4
  402e9a:	96a50513          	addi	a0,a0,-1686 # 406800 <malloc+0x1628>
  402e9e:	6a5010ef          	jal	404d42 <open>
  402ea2:	2a055c63          	bgez	a0,40315a <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
  402ea6:	20200593          	li	a1,514
  402eaa:	00004517          	auipc	a0,0x4
  402eae:	98650513          	addi	a0,a0,-1658 # 406830 <malloc+0x1658>
  402eb2:	691010ef          	jal	404d42 <open>
  402eb6:	2a055c63          	bgez	a0,40316e <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
  402eba:	20000593          	li	a1,512
  402ebe:	00003517          	auipc	a0,0x3
  402ec2:	68a50513          	addi	a0,a0,1674 # 406548 <malloc+0x1370>
  402ec6:	67d010ef          	jal	404d42 <open>
  402eca:	2a055c63          	bgez	a0,403182 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
  402ece:	4589                	li	a1,2
  402ed0:	00003517          	auipc	a0,0x3
  402ed4:	67850513          	addi	a0,a0,1656 # 406548 <malloc+0x1370>
  402ed8:	66b010ef          	jal	404d42 <open>
  402edc:	2a055d63          	bgez	a0,403196 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
  402ee0:	4585                	li	a1,1
  402ee2:	00003517          	auipc	a0,0x3
  402ee6:	66650513          	addi	a0,a0,1638 # 406548 <malloc+0x1370>
  402eea:	659010ef          	jal	404d42 <open>
  402eee:	2a055e63          	bgez	a0,4031aa <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
  402ef2:	00004597          	auipc	a1,0x4
  402ef6:	9ce58593          	addi	a1,a1,-1586 # 4068c0 <malloc+0x16e8>
  402efa:	00004517          	auipc	a0,0x4
  402efe:	90650513          	addi	a0,a0,-1786 # 406800 <malloc+0x1628>
  402f02:	661010ef          	jal	404d62 <link>
  402f06:	2a050c63          	beqz	a0,4031be <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
  402f0a:	00004597          	auipc	a1,0x4
  402f0e:	9b658593          	addi	a1,a1,-1610 # 4068c0 <malloc+0x16e8>
  402f12:	00004517          	auipc	a0,0x4
  402f16:	91e50513          	addi	a0,a0,-1762 # 406830 <malloc+0x1658>
  402f1a:	649010ef          	jal	404d62 <link>
  402f1e:	2a050a63          	beqz	a0,4031d2 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
  402f22:	00003597          	auipc	a1,0x3
  402f26:	74e58593          	addi	a1,a1,1870 # 406670 <malloc+0x1498>
  402f2a:	00003517          	auipc	a0,0x3
  402f2e:	63e50513          	addi	a0,a0,1598 # 406568 <malloc+0x1390>
  402f32:	631010ef          	jal	404d62 <link>
  402f36:	2a050863          	beqz	a0,4031e6 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
  402f3a:	00004517          	auipc	a0,0x4
  402f3e:	8c650513          	addi	a0,a0,-1850 # 406800 <malloc+0x1628>
  402f42:	629010ef          	jal	404d6a <mkdir>
  402f46:	2a050a63          	beqz	a0,4031fa <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
  402f4a:	00004517          	auipc	a0,0x4
  402f4e:	8e650513          	addi	a0,a0,-1818 # 406830 <malloc+0x1658>
  402f52:	619010ef          	jal	404d6a <mkdir>
  402f56:	2a050c63          	beqz	a0,40320e <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
  402f5a:	00003517          	auipc	a0,0x3
  402f5e:	71650513          	addi	a0,a0,1814 # 406670 <malloc+0x1498>
  402f62:	609010ef          	jal	404d6a <mkdir>
  402f66:	2a050e63          	beqz	a0,403222 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
  402f6a:	00004517          	auipc	a0,0x4
  402f6e:	8c650513          	addi	a0,a0,-1850 # 406830 <malloc+0x1658>
  402f72:	5e1010ef          	jal	404d52 <unlink>
  402f76:	2c050063          	beqz	a0,403236 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
  402f7a:	00004517          	auipc	a0,0x4
  402f7e:	88650513          	addi	a0,a0,-1914 # 406800 <malloc+0x1628>
  402f82:	5d1010ef          	jal	404d52 <unlink>
  402f86:	2c050263          	beqz	a0,40324a <subdir+0x54e>
  if(chdir("dd/ff") == 0){
  402f8a:	00003517          	auipc	a0,0x3
  402f8e:	5de50513          	addi	a0,a0,1502 # 406568 <malloc+0x1390>
  402f92:	5e1010ef          	jal	404d72 <chdir>
  402f96:	2c050463          	beqz	a0,40325e <subdir+0x562>
  if(chdir("dd/xx") == 0){
  402f9a:	00004517          	auipc	a0,0x4
  402f9e:	a7650513          	addi	a0,a0,-1418 # 406a10 <malloc+0x1838>
  402fa2:	5d1010ef          	jal	404d72 <chdir>
  402fa6:	2c050663          	beqz	a0,403272 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
  402faa:	00003517          	auipc	a0,0x3
  402fae:	6c650513          	addi	a0,a0,1734 # 406670 <malloc+0x1498>
  402fb2:	5a1010ef          	jal	404d52 <unlink>
  402fb6:	2c051863          	bnez	a0,403286 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
  402fba:	00003517          	auipc	a0,0x3
  402fbe:	5ae50513          	addi	a0,a0,1454 # 406568 <malloc+0x1390>
  402fc2:	591010ef          	jal	404d52 <unlink>
  402fc6:	2c051a63          	bnez	a0,40329a <subdir+0x59e>
  if(unlink("dd") == 0){
  402fca:	00003517          	auipc	a0,0x3
  402fce:	57e50513          	addi	a0,a0,1406 # 406548 <malloc+0x1370>
  402fd2:	581010ef          	jal	404d52 <unlink>
  402fd6:	2c050c63          	beqz	a0,4032ae <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
  402fda:	00004517          	auipc	a0,0x4
  402fde:	aa650513          	addi	a0,a0,-1370 # 406a80 <malloc+0x18a8>
  402fe2:	571010ef          	jal	404d52 <unlink>
  402fe6:	2c054e63          	bltz	a0,4032c2 <subdir+0x5c6>
  if(unlink("dd") < 0){
  402fea:	00003517          	auipc	a0,0x3
  402fee:	55e50513          	addi	a0,a0,1374 # 406548 <malloc+0x1370>
  402ff2:	561010ef          	jal	404d52 <unlink>
  402ff6:	2e054063          	bltz	a0,4032d6 <subdir+0x5da>
}
  402ffa:	60e2                	ld	ra,24(sp)
  402ffc:	6442                	ld	s0,16(sp)
  402ffe:	64a2                	ld	s1,8(sp)
  403000:	6902                	ld	s2,0(sp)
  403002:	6105                	addi	sp,sp,32
  403004:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
  403006:	85ca                	mv	a1,s2
  403008:	00003517          	auipc	a0,0x3
  40300c:	54850513          	addi	a0,a0,1352 # 406550 <malloc+0x1378>
  403010:	10e020ef          	jal	40511e <printf>
    exit(1);
  403014:	4505                	li	a0,1
  403016:	4ed010ef          	jal	404d02 <exit>
    printf("%s: create dd/ff failed\n", s);
  40301a:	85ca                	mv	a1,s2
  40301c:	00003517          	auipc	a0,0x3
  403020:	55450513          	addi	a0,a0,1364 # 406570 <malloc+0x1398>
  403024:	0fa020ef          	jal	40511e <printf>
    exit(1);
  403028:	4505                	li	a0,1
  40302a:	4d9010ef          	jal	404d02 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
  40302e:	85ca                	mv	a1,s2
  403030:	00003517          	auipc	a0,0x3
  403034:	56050513          	addi	a0,a0,1376 # 406590 <malloc+0x13b8>
  403038:	0e6020ef          	jal	40511e <printf>
    exit(1);
  40303c:	4505                	li	a0,1
  40303e:	4c5010ef          	jal	404d02 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
  403042:	85ca                	mv	a1,s2
  403044:	00003517          	auipc	a0,0x3
  403048:	58450513          	addi	a0,a0,1412 # 4065c8 <malloc+0x13f0>
  40304c:	0d2020ef          	jal	40511e <printf>
    exit(1);
  403050:	4505                	li	a0,1
  403052:	4b1010ef          	jal	404d02 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
  403056:	85ca                	mv	a1,s2
  403058:	00003517          	auipc	a0,0x3
  40305c:	5a050513          	addi	a0,a0,1440 # 4065f8 <malloc+0x1420>
  403060:	0be020ef          	jal	40511e <printf>
    exit(1);
  403064:	4505                	li	a0,1
  403066:	49d010ef          	jal	404d02 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
  40306a:	85ca                	mv	a1,s2
  40306c:	00003517          	auipc	a0,0x3
  403070:	5c450513          	addi	a0,a0,1476 # 406630 <malloc+0x1458>
  403074:	0aa020ef          	jal	40511e <printf>
    exit(1);
  403078:	4505                	li	a0,1
  40307a:	489010ef          	jal	404d02 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
  40307e:	85ca                	mv	a1,s2
  403080:	00003517          	auipc	a0,0x3
  403084:	5d050513          	addi	a0,a0,1488 # 406650 <malloc+0x1478>
  403088:	096020ef          	jal	40511e <printf>
    exit(1);
  40308c:	4505                	li	a0,1
  40308e:	475010ef          	jal	404d02 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
  403092:	85ca                	mv	a1,s2
  403094:	00003517          	auipc	a0,0x3
  403098:	5ec50513          	addi	a0,a0,1516 # 406680 <malloc+0x14a8>
  40309c:	082020ef          	jal	40511e <printf>
    exit(1);
  4030a0:	4505                	li	a0,1
  4030a2:	461010ef          	jal	404d02 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
  4030a6:	85ca                	mv	a1,s2
  4030a8:	00003517          	auipc	a0,0x3
  4030ac:	60050513          	addi	a0,a0,1536 # 4066a8 <malloc+0x14d0>
  4030b0:	06e020ef          	jal	40511e <printf>
    exit(1);
  4030b4:	4505                	li	a0,1
  4030b6:	44d010ef          	jal	404d02 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
  4030ba:	85ca                	mv	a1,s2
  4030bc:	00003517          	auipc	a0,0x3
  4030c0:	60c50513          	addi	a0,a0,1548 # 4066c8 <malloc+0x14f0>
  4030c4:	05a020ef          	jal	40511e <printf>
    exit(1);
  4030c8:	4505                	li	a0,1
  4030ca:	439010ef          	jal	404d02 <exit>
    printf("%s: chdir dd failed\n", s);
  4030ce:	85ca                	mv	a1,s2
  4030d0:	00003517          	auipc	a0,0x3
  4030d4:	62050513          	addi	a0,a0,1568 # 4066f0 <malloc+0x1518>
  4030d8:	046020ef          	jal	40511e <printf>
    exit(1);
  4030dc:	4505                	li	a0,1
  4030de:	425010ef          	jal	404d02 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
  4030e2:	85ca                	mv	a1,s2
  4030e4:	00003517          	auipc	a0,0x3
  4030e8:	63450513          	addi	a0,a0,1588 # 406718 <malloc+0x1540>
  4030ec:	032020ef          	jal	40511e <printf>
    exit(1);
  4030f0:	4505                	li	a0,1
  4030f2:	411010ef          	jal	404d02 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
  4030f6:	85ca                	mv	a1,s2
  4030f8:	00003517          	auipc	a0,0x3
  4030fc:	65050513          	addi	a0,a0,1616 # 406748 <malloc+0x1570>
  403100:	01e020ef          	jal	40511e <printf>
    exit(1);
  403104:	4505                	li	a0,1
  403106:	3fd010ef          	jal	404d02 <exit>
    printf("%s: chdir ./.. failed\n", s);
  40310a:	85ca                	mv	a1,s2
  40310c:	00003517          	auipc	a0,0x3
  403110:	66c50513          	addi	a0,a0,1644 # 406778 <malloc+0x15a0>
  403114:	00a020ef          	jal	40511e <printf>
    exit(1);
  403118:	4505                	li	a0,1
  40311a:	3e9010ef          	jal	404d02 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
  40311e:	85ca                	mv	a1,s2
  403120:	00003517          	auipc	a0,0x3
  403124:	67050513          	addi	a0,a0,1648 # 406790 <malloc+0x15b8>
  403128:	7f7010ef          	jal	40511e <printf>
    exit(1);
  40312c:	4505                	li	a0,1
  40312e:	3d5010ef          	jal	404d02 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
  403132:	85ca                	mv	a1,s2
  403134:	00003517          	auipc	a0,0x3
  403138:	67c50513          	addi	a0,a0,1660 # 4067b0 <malloc+0x15d8>
  40313c:	7e3010ef          	jal	40511e <printf>
    exit(1);
  403140:	4505                	li	a0,1
  403142:	3c1010ef          	jal	404d02 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
  403146:	85ca                	mv	a1,s2
  403148:	00003517          	auipc	a0,0x3
  40314c:	68850513          	addi	a0,a0,1672 # 4067d0 <malloc+0x15f8>
  403150:	7cf010ef          	jal	40511e <printf>
    exit(1);
  403154:	4505                	li	a0,1
  403156:	3ad010ef          	jal	404d02 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
  40315a:	85ca                	mv	a1,s2
  40315c:	00003517          	auipc	a0,0x3
  403160:	6b450513          	addi	a0,a0,1716 # 406810 <malloc+0x1638>
  403164:	7bb010ef          	jal	40511e <printf>
    exit(1);
  403168:	4505                	li	a0,1
  40316a:	399010ef          	jal	404d02 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
  40316e:	85ca                	mv	a1,s2
  403170:	00003517          	auipc	a0,0x3
  403174:	6d050513          	addi	a0,a0,1744 # 406840 <malloc+0x1668>
  403178:	7a7010ef          	jal	40511e <printf>
    exit(1);
  40317c:	4505                	li	a0,1
  40317e:	385010ef          	jal	404d02 <exit>
    printf("%s: create dd succeeded!\n", s);
  403182:	85ca                	mv	a1,s2
  403184:	00003517          	auipc	a0,0x3
  403188:	6dc50513          	addi	a0,a0,1756 # 406860 <malloc+0x1688>
  40318c:	793010ef          	jal	40511e <printf>
    exit(1);
  403190:	4505                	li	a0,1
  403192:	371010ef          	jal	404d02 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
  403196:	85ca                	mv	a1,s2
  403198:	00003517          	auipc	a0,0x3
  40319c:	6e850513          	addi	a0,a0,1768 # 406880 <malloc+0x16a8>
  4031a0:	77f010ef          	jal	40511e <printf>
    exit(1);
  4031a4:	4505                	li	a0,1
  4031a6:	35d010ef          	jal	404d02 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
  4031aa:	85ca                	mv	a1,s2
  4031ac:	00003517          	auipc	a0,0x3
  4031b0:	6f450513          	addi	a0,a0,1780 # 4068a0 <malloc+0x16c8>
  4031b4:	76b010ef          	jal	40511e <printf>
    exit(1);
  4031b8:	4505                	li	a0,1
  4031ba:	349010ef          	jal	404d02 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
  4031be:	85ca                	mv	a1,s2
  4031c0:	00003517          	auipc	a0,0x3
  4031c4:	71050513          	addi	a0,a0,1808 # 4068d0 <malloc+0x16f8>
  4031c8:	757010ef          	jal	40511e <printf>
    exit(1);
  4031cc:	4505                	li	a0,1
  4031ce:	335010ef          	jal	404d02 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
  4031d2:	85ca                	mv	a1,s2
  4031d4:	00003517          	auipc	a0,0x3
  4031d8:	72450513          	addi	a0,a0,1828 # 4068f8 <malloc+0x1720>
  4031dc:	743010ef          	jal	40511e <printf>
    exit(1);
  4031e0:	4505                	li	a0,1
  4031e2:	321010ef          	jal	404d02 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
  4031e6:	85ca                	mv	a1,s2
  4031e8:	00003517          	auipc	a0,0x3
  4031ec:	73850513          	addi	a0,a0,1848 # 406920 <malloc+0x1748>
  4031f0:	72f010ef          	jal	40511e <printf>
    exit(1);
  4031f4:	4505                	li	a0,1
  4031f6:	30d010ef          	jal	404d02 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
  4031fa:	85ca                	mv	a1,s2
  4031fc:	00003517          	auipc	a0,0x3
  403200:	74c50513          	addi	a0,a0,1868 # 406948 <malloc+0x1770>
  403204:	71b010ef          	jal	40511e <printf>
    exit(1);
  403208:	4505                	li	a0,1
  40320a:	2f9010ef          	jal	404d02 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
  40320e:	85ca                	mv	a1,s2
  403210:	00003517          	auipc	a0,0x3
  403214:	75850513          	addi	a0,a0,1880 # 406968 <malloc+0x1790>
  403218:	707010ef          	jal	40511e <printf>
    exit(1);
  40321c:	4505                	li	a0,1
  40321e:	2e5010ef          	jal	404d02 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
  403222:	85ca                	mv	a1,s2
  403224:	00003517          	auipc	a0,0x3
  403228:	76450513          	addi	a0,a0,1892 # 406988 <malloc+0x17b0>
  40322c:	6f3010ef          	jal	40511e <printf>
    exit(1);
  403230:	4505                	li	a0,1
  403232:	2d1010ef          	jal	404d02 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
  403236:	85ca                	mv	a1,s2
  403238:	00003517          	auipc	a0,0x3
  40323c:	77850513          	addi	a0,a0,1912 # 4069b0 <malloc+0x17d8>
  403240:	6df010ef          	jal	40511e <printf>
    exit(1);
  403244:	4505                	li	a0,1
  403246:	2bd010ef          	jal	404d02 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
  40324a:	85ca                	mv	a1,s2
  40324c:	00003517          	auipc	a0,0x3
  403250:	78450513          	addi	a0,a0,1924 # 4069d0 <malloc+0x17f8>
  403254:	6cb010ef          	jal	40511e <printf>
    exit(1);
  403258:	4505                	li	a0,1
  40325a:	2a9010ef          	jal	404d02 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
  40325e:	85ca                	mv	a1,s2
  403260:	00003517          	auipc	a0,0x3
  403264:	79050513          	addi	a0,a0,1936 # 4069f0 <malloc+0x1818>
  403268:	6b7010ef          	jal	40511e <printf>
    exit(1);
  40326c:	4505                	li	a0,1
  40326e:	295010ef          	jal	404d02 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
  403272:	85ca                	mv	a1,s2
  403274:	00003517          	auipc	a0,0x3
  403278:	7a450513          	addi	a0,a0,1956 # 406a18 <malloc+0x1840>
  40327c:	6a3010ef          	jal	40511e <printf>
    exit(1);
  403280:	4505                	li	a0,1
  403282:	281010ef          	jal	404d02 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
  403286:	85ca                	mv	a1,s2
  403288:	00003517          	auipc	a0,0x3
  40328c:	42050513          	addi	a0,a0,1056 # 4066a8 <malloc+0x14d0>
  403290:	68f010ef          	jal	40511e <printf>
    exit(1);
  403294:	4505                	li	a0,1
  403296:	26d010ef          	jal	404d02 <exit>
    printf("%s: unlink dd/ff failed\n", s);
  40329a:	85ca                	mv	a1,s2
  40329c:	00003517          	auipc	a0,0x3
  4032a0:	79c50513          	addi	a0,a0,1948 # 406a38 <malloc+0x1860>
  4032a4:	67b010ef          	jal	40511e <printf>
    exit(1);
  4032a8:	4505                	li	a0,1
  4032aa:	259010ef          	jal	404d02 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
  4032ae:	85ca                	mv	a1,s2
  4032b0:	00003517          	auipc	a0,0x3
  4032b4:	7a850513          	addi	a0,a0,1960 # 406a58 <malloc+0x1880>
  4032b8:	667010ef          	jal	40511e <printf>
    exit(1);
  4032bc:	4505                	li	a0,1
  4032be:	245010ef          	jal	404d02 <exit>
    printf("%s: unlink dd/dd failed\n", s);
  4032c2:	85ca                	mv	a1,s2
  4032c4:	00003517          	auipc	a0,0x3
  4032c8:	7c450513          	addi	a0,a0,1988 # 406a88 <malloc+0x18b0>
  4032cc:	653010ef          	jal	40511e <printf>
    exit(1);
  4032d0:	4505                	li	a0,1
  4032d2:	231010ef          	jal	404d02 <exit>
    printf("%s: unlink dd failed\n", s);
  4032d6:	85ca                	mv	a1,s2
  4032d8:	00003517          	auipc	a0,0x3
  4032dc:	7d050513          	addi	a0,a0,2000 # 406aa8 <malloc+0x18d0>
  4032e0:	63f010ef          	jal	40511e <printf>
    exit(1);
  4032e4:	4505                	li	a0,1
  4032e6:	21d010ef          	jal	404d02 <exit>

00000000004032ea <rmdot>:
{
  4032ea:	1101                	addi	sp,sp,-32
  4032ec:	ec06                	sd	ra,24(sp)
  4032ee:	e822                	sd	s0,16(sp)
  4032f0:	e426                	sd	s1,8(sp)
  4032f2:	1000                	addi	s0,sp,32
  4032f4:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
  4032f6:	00003517          	auipc	a0,0x3
  4032fa:	7ca50513          	addi	a0,a0,1994 # 406ac0 <malloc+0x18e8>
  4032fe:	26d010ef          	jal	404d6a <mkdir>
  403302:	e53d                	bnez	a0,403370 <rmdot+0x86>
  if(chdir("dots") != 0){
  403304:	00003517          	auipc	a0,0x3
  403308:	7bc50513          	addi	a0,a0,1980 # 406ac0 <malloc+0x18e8>
  40330c:	267010ef          	jal	404d72 <chdir>
  403310:	e935                	bnez	a0,403384 <rmdot+0x9a>
  if(unlink(".") == 0){
  403312:	00002517          	auipc	a0,0x2
  403316:	6de50513          	addi	a0,a0,1758 # 4059f0 <malloc+0x818>
  40331a:	239010ef          	jal	404d52 <unlink>
  40331e:	cd2d                	beqz	a0,403398 <rmdot+0xae>
  if(unlink("..") == 0){
  403320:	00003517          	auipc	a0,0x3
  403324:	1f050513          	addi	a0,a0,496 # 406510 <malloc+0x1338>
  403328:	22b010ef          	jal	404d52 <unlink>
  40332c:	c141                	beqz	a0,4033ac <rmdot+0xc2>
  if(chdir("/") != 0){
  40332e:	00003517          	auipc	a0,0x3
  403332:	18a50513          	addi	a0,a0,394 # 4064b8 <malloc+0x12e0>
  403336:	23d010ef          	jal	404d72 <chdir>
  40333a:	e159                	bnez	a0,4033c0 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
  40333c:	00003517          	auipc	a0,0x3
  403340:	7ec50513          	addi	a0,a0,2028 # 406b28 <malloc+0x1950>
  403344:	20f010ef          	jal	404d52 <unlink>
  403348:	c551                	beqz	a0,4033d4 <rmdot+0xea>
  if(unlink("dots/..") == 0){
  40334a:	00004517          	auipc	a0,0x4
  40334e:	80650513          	addi	a0,a0,-2042 # 406b50 <malloc+0x1978>
  403352:	201010ef          	jal	404d52 <unlink>
  403356:	c949                	beqz	a0,4033e8 <rmdot+0xfe>
  if(unlink("dots") != 0){
  403358:	00003517          	auipc	a0,0x3
  40335c:	76850513          	addi	a0,a0,1896 # 406ac0 <malloc+0x18e8>
  403360:	1f3010ef          	jal	404d52 <unlink>
  403364:	ed41                	bnez	a0,4033fc <rmdot+0x112>
}
  403366:	60e2                	ld	ra,24(sp)
  403368:	6442                	ld	s0,16(sp)
  40336a:	64a2                	ld	s1,8(sp)
  40336c:	6105                	addi	sp,sp,32
  40336e:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
  403370:	85a6                	mv	a1,s1
  403372:	00003517          	auipc	a0,0x3
  403376:	75650513          	addi	a0,a0,1878 # 406ac8 <malloc+0x18f0>
  40337a:	5a5010ef          	jal	40511e <printf>
    exit(1);
  40337e:	4505                	li	a0,1
  403380:	183010ef          	jal	404d02 <exit>
    printf("%s: chdir dots failed\n", s);
  403384:	85a6                	mv	a1,s1
  403386:	00003517          	auipc	a0,0x3
  40338a:	75a50513          	addi	a0,a0,1882 # 406ae0 <malloc+0x1908>
  40338e:	591010ef          	jal	40511e <printf>
    exit(1);
  403392:	4505                	li	a0,1
  403394:	16f010ef          	jal	404d02 <exit>
    printf("%s: rm . worked!\n", s);
  403398:	85a6                	mv	a1,s1
  40339a:	00003517          	auipc	a0,0x3
  40339e:	75e50513          	addi	a0,a0,1886 # 406af8 <malloc+0x1920>
  4033a2:	57d010ef          	jal	40511e <printf>
    exit(1);
  4033a6:	4505                	li	a0,1
  4033a8:	15b010ef          	jal	404d02 <exit>
    printf("%s: rm .. worked!\n", s);
  4033ac:	85a6                	mv	a1,s1
  4033ae:	00003517          	auipc	a0,0x3
  4033b2:	76250513          	addi	a0,a0,1890 # 406b10 <malloc+0x1938>
  4033b6:	569010ef          	jal	40511e <printf>
    exit(1);
  4033ba:	4505                	li	a0,1
  4033bc:	147010ef          	jal	404d02 <exit>
    printf("%s: chdir / failed\n", s);
  4033c0:	85a6                	mv	a1,s1
  4033c2:	00003517          	auipc	a0,0x3
  4033c6:	0fe50513          	addi	a0,a0,254 # 4064c0 <malloc+0x12e8>
  4033ca:	555010ef          	jal	40511e <printf>
    exit(1);
  4033ce:	4505                	li	a0,1
  4033d0:	133010ef          	jal	404d02 <exit>
    printf("%s: unlink dots/. worked!\n", s);
  4033d4:	85a6                	mv	a1,s1
  4033d6:	00003517          	auipc	a0,0x3
  4033da:	75a50513          	addi	a0,a0,1882 # 406b30 <malloc+0x1958>
  4033de:	541010ef          	jal	40511e <printf>
    exit(1);
  4033e2:	4505                	li	a0,1
  4033e4:	11f010ef          	jal	404d02 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
  4033e8:	85a6                	mv	a1,s1
  4033ea:	00003517          	auipc	a0,0x3
  4033ee:	76e50513          	addi	a0,a0,1902 # 406b58 <malloc+0x1980>
  4033f2:	52d010ef          	jal	40511e <printf>
    exit(1);
  4033f6:	4505                	li	a0,1
  4033f8:	10b010ef          	jal	404d02 <exit>
    printf("%s: unlink dots failed!\n", s);
  4033fc:	85a6                	mv	a1,s1
  4033fe:	00003517          	auipc	a0,0x3
  403402:	77a50513          	addi	a0,a0,1914 # 406b78 <malloc+0x19a0>
  403406:	519010ef          	jal	40511e <printf>
    exit(1);
  40340a:	4505                	li	a0,1
  40340c:	0f7010ef          	jal	404d02 <exit>

0000000000403410 <dirfile>:
{
  403410:	1101                	addi	sp,sp,-32
  403412:	ec06                	sd	ra,24(sp)
  403414:	e822                	sd	s0,16(sp)
  403416:	e426                	sd	s1,8(sp)
  403418:	e04a                	sd	s2,0(sp)
  40341a:	1000                	addi	s0,sp,32
  40341c:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
  40341e:	20000593          	li	a1,512
  403422:	00003517          	auipc	a0,0x3
  403426:	77650513          	addi	a0,a0,1910 # 406b98 <malloc+0x19c0>
  40342a:	119010ef          	jal	404d42 <open>
  if(fd < 0){
  40342e:	0c054563          	bltz	a0,4034f8 <dirfile+0xe8>
  close(fd);
  403432:	0f9010ef          	jal	404d2a <close>
  if(chdir("dirfile") == 0){
  403436:	00003517          	auipc	a0,0x3
  40343a:	76250513          	addi	a0,a0,1890 # 406b98 <malloc+0x19c0>
  40343e:	135010ef          	jal	404d72 <chdir>
  403442:	c569                	beqz	a0,40350c <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
  403444:	4581                	li	a1,0
  403446:	00003517          	auipc	a0,0x3
  40344a:	79a50513          	addi	a0,a0,1946 # 406be0 <malloc+0x1a08>
  40344e:	0f5010ef          	jal	404d42 <open>
  if(fd >= 0){
  403452:	0c055763          	bgez	a0,403520 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
  403456:	20000593          	li	a1,512
  40345a:	00003517          	auipc	a0,0x3
  40345e:	78650513          	addi	a0,a0,1926 # 406be0 <malloc+0x1a08>
  403462:	0e1010ef          	jal	404d42 <open>
  if(fd >= 0){
  403466:	0c055763          	bgez	a0,403534 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
  40346a:	00003517          	auipc	a0,0x3
  40346e:	77650513          	addi	a0,a0,1910 # 406be0 <malloc+0x1a08>
  403472:	0f9010ef          	jal	404d6a <mkdir>
  403476:	0c050963          	beqz	a0,403548 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
  40347a:	00003517          	auipc	a0,0x3
  40347e:	76650513          	addi	a0,a0,1894 # 406be0 <malloc+0x1a08>
  403482:	0d1010ef          	jal	404d52 <unlink>
  403486:	0c050b63          	beqz	a0,40355c <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
  40348a:	00003597          	auipc	a1,0x3
  40348e:	75658593          	addi	a1,a1,1878 # 406be0 <malloc+0x1a08>
  403492:	00002517          	auipc	a0,0x2
  403496:	04e50513          	addi	a0,a0,78 # 4054e0 <malloc+0x308>
  40349a:	0c9010ef          	jal	404d62 <link>
  40349e:	0c050963          	beqz	a0,403570 <dirfile+0x160>
  if(unlink("dirfile") != 0){
  4034a2:	00003517          	auipc	a0,0x3
  4034a6:	6f650513          	addi	a0,a0,1782 # 406b98 <malloc+0x19c0>
  4034aa:	0a9010ef          	jal	404d52 <unlink>
  4034ae:	0c051b63          	bnez	a0,403584 <dirfile+0x174>
  fd = open(".", O_RDWR);
  4034b2:	4589                	li	a1,2
  4034b4:	00002517          	auipc	a0,0x2
  4034b8:	53c50513          	addi	a0,a0,1340 # 4059f0 <malloc+0x818>
  4034bc:	087010ef          	jal	404d42 <open>
  if(fd >= 0){
  4034c0:	0c055c63          	bgez	a0,403598 <dirfile+0x188>
  fd = open(".", 0);
  4034c4:	4581                	li	a1,0
  4034c6:	00002517          	auipc	a0,0x2
  4034ca:	52a50513          	addi	a0,a0,1322 # 4059f0 <malloc+0x818>
  4034ce:	075010ef          	jal	404d42 <open>
  4034d2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
  4034d4:	4605                	li	a2,1
  4034d6:	00002597          	auipc	a1,0x2
  4034da:	ea258593          	addi	a1,a1,-350 # 405378 <malloc+0x1a0>
  4034de:	045010ef          	jal	404d22 <write>
  4034e2:	0ca04563          	bgtz	a0,4035ac <dirfile+0x19c>
  close(fd);
  4034e6:	8526                	mv	a0,s1
  4034e8:	043010ef          	jal	404d2a <close>
}
  4034ec:	60e2                	ld	ra,24(sp)
  4034ee:	6442                	ld	s0,16(sp)
  4034f0:	64a2                	ld	s1,8(sp)
  4034f2:	6902                	ld	s2,0(sp)
  4034f4:	6105                	addi	sp,sp,32
  4034f6:	8082                	ret
    printf("%s: create dirfile failed\n", s);
  4034f8:	85ca                	mv	a1,s2
  4034fa:	00003517          	auipc	a0,0x3
  4034fe:	6a650513          	addi	a0,a0,1702 # 406ba0 <malloc+0x19c8>
  403502:	41d010ef          	jal	40511e <printf>
    exit(1);
  403506:	4505                	li	a0,1
  403508:	7fa010ef          	jal	404d02 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
  40350c:	85ca                	mv	a1,s2
  40350e:	00003517          	auipc	a0,0x3
  403512:	6b250513          	addi	a0,a0,1714 # 406bc0 <malloc+0x19e8>
  403516:	409010ef          	jal	40511e <printf>
    exit(1);
  40351a:	4505                	li	a0,1
  40351c:	7e6010ef          	jal	404d02 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
  403520:	85ca                	mv	a1,s2
  403522:	00003517          	auipc	a0,0x3
  403526:	6ce50513          	addi	a0,a0,1742 # 406bf0 <malloc+0x1a18>
  40352a:	3f5010ef          	jal	40511e <printf>
    exit(1);
  40352e:	4505                	li	a0,1
  403530:	7d2010ef          	jal	404d02 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
  403534:	85ca                	mv	a1,s2
  403536:	00003517          	auipc	a0,0x3
  40353a:	6ba50513          	addi	a0,a0,1722 # 406bf0 <malloc+0x1a18>
  40353e:	3e1010ef          	jal	40511e <printf>
    exit(1);
  403542:	4505                	li	a0,1
  403544:	7be010ef          	jal	404d02 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
  403548:	85ca                	mv	a1,s2
  40354a:	00003517          	auipc	a0,0x3
  40354e:	6ce50513          	addi	a0,a0,1742 # 406c18 <malloc+0x1a40>
  403552:	3cd010ef          	jal	40511e <printf>
    exit(1);
  403556:	4505                	li	a0,1
  403558:	7aa010ef          	jal	404d02 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
  40355c:	85ca                	mv	a1,s2
  40355e:	00003517          	auipc	a0,0x3
  403562:	6e250513          	addi	a0,a0,1762 # 406c40 <malloc+0x1a68>
  403566:	3b9010ef          	jal	40511e <printf>
    exit(1);
  40356a:	4505                	li	a0,1
  40356c:	796010ef          	jal	404d02 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
  403570:	85ca                	mv	a1,s2
  403572:	00003517          	auipc	a0,0x3
  403576:	6f650513          	addi	a0,a0,1782 # 406c68 <malloc+0x1a90>
  40357a:	3a5010ef          	jal	40511e <printf>
    exit(1);
  40357e:	4505                	li	a0,1
  403580:	782010ef          	jal	404d02 <exit>
    printf("%s: unlink dirfile failed!\n", s);
  403584:	85ca                	mv	a1,s2
  403586:	00003517          	auipc	a0,0x3
  40358a:	70a50513          	addi	a0,a0,1802 # 406c90 <malloc+0x1ab8>
  40358e:	391010ef          	jal	40511e <printf>
    exit(1);
  403592:	4505                	li	a0,1
  403594:	76e010ef          	jal	404d02 <exit>
    printf("%s: open . for writing succeeded!\n", s);
  403598:	85ca                	mv	a1,s2
  40359a:	00003517          	auipc	a0,0x3
  40359e:	71650513          	addi	a0,a0,1814 # 406cb0 <malloc+0x1ad8>
  4035a2:	37d010ef          	jal	40511e <printf>
    exit(1);
  4035a6:	4505                	li	a0,1
  4035a8:	75a010ef          	jal	404d02 <exit>
    printf("%s: write . succeeded!\n", s);
  4035ac:	85ca                	mv	a1,s2
  4035ae:	00003517          	auipc	a0,0x3
  4035b2:	72a50513          	addi	a0,a0,1834 # 406cd8 <malloc+0x1b00>
  4035b6:	369010ef          	jal	40511e <printf>
    exit(1);
  4035ba:	4505                	li	a0,1
  4035bc:	746010ef          	jal	404d02 <exit>

00000000004035c0 <iref>:
{
  4035c0:	715d                	addi	sp,sp,-80
  4035c2:	e486                	sd	ra,72(sp)
  4035c4:	e0a2                	sd	s0,64(sp)
  4035c6:	fc26                	sd	s1,56(sp)
  4035c8:	f84a                	sd	s2,48(sp)
  4035ca:	f44e                	sd	s3,40(sp)
  4035cc:	f052                	sd	s4,32(sp)
  4035ce:	ec56                	sd	s5,24(sp)
  4035d0:	e85a                	sd	s6,16(sp)
  4035d2:	e45e                	sd	s7,8(sp)
  4035d4:	0880                	addi	s0,sp,80
  4035d6:	8baa                	mv	s7,a0
  4035d8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
  4035dc:	00003a97          	auipc	s5,0x3
  4035e0:	714a8a93          	addi	s5,s5,1812 # 406cf0 <malloc+0x1b18>
    mkdir("");
  4035e4:	00003497          	auipc	s1,0x3
  4035e8:	21448493          	addi	s1,s1,532 # 4067f8 <malloc+0x1620>
    link("README", "");
  4035ec:	00002b17          	auipc	s6,0x2
  4035f0:	ef4b0b13          	addi	s6,s6,-268 # 4054e0 <malloc+0x308>
    fd = open("", O_CREATE);
  4035f4:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
  4035f8:	00003997          	auipc	s3,0x3
  4035fc:	5f098993          	addi	s3,s3,1520 # 406be8 <malloc+0x1a10>
  403600:	a835                	j	40363c <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
  403602:	85de                	mv	a1,s7
  403604:	00003517          	auipc	a0,0x3
  403608:	6f450513          	addi	a0,a0,1780 # 406cf8 <malloc+0x1b20>
  40360c:	313010ef          	jal	40511e <printf>
      exit(1);
  403610:	4505                	li	a0,1
  403612:	6f0010ef          	jal	404d02 <exit>
      printf("%s: chdir irefd failed\n", s);
  403616:	85de                	mv	a1,s7
  403618:	00003517          	auipc	a0,0x3
  40361c:	6f850513          	addi	a0,a0,1784 # 406d10 <malloc+0x1b38>
  403620:	2ff010ef          	jal	40511e <printf>
      exit(1);
  403624:	4505                	li	a0,1
  403626:	6dc010ef          	jal	404d02 <exit>
      close(fd);
  40362a:	700010ef          	jal	404d2a <close>
  40362e:	a825                	j	403666 <iref+0xa6>
    unlink("xx");
  403630:	854e                	mv	a0,s3
  403632:	720010ef          	jal	404d52 <unlink>
  for(i = 0; i < NINODE + 1; i++){
  403636:	397d                	addiw	s2,s2,-1
  403638:	04090063          	beqz	s2,403678 <iref+0xb8>
    if(mkdir("irefd") != 0){
  40363c:	8556                	mv	a0,s5
  40363e:	72c010ef          	jal	404d6a <mkdir>
  403642:	f161                	bnez	a0,403602 <iref+0x42>
    if(chdir("irefd") != 0){
  403644:	8556                	mv	a0,s5
  403646:	72c010ef          	jal	404d72 <chdir>
  40364a:	f571                	bnez	a0,403616 <iref+0x56>
    mkdir("");
  40364c:	8526                	mv	a0,s1
  40364e:	71c010ef          	jal	404d6a <mkdir>
    link("README", "");
  403652:	85a6                	mv	a1,s1
  403654:	855a                	mv	a0,s6
  403656:	70c010ef          	jal	404d62 <link>
    fd = open("", O_CREATE);
  40365a:	85d2                	mv	a1,s4
  40365c:	8526                	mv	a0,s1
  40365e:	6e4010ef          	jal	404d42 <open>
    if(fd >= 0)
  403662:	fc0554e3          	bgez	a0,40362a <iref+0x6a>
    fd = open("xx", O_CREATE);
  403666:	85d2                	mv	a1,s4
  403668:	854e                	mv	a0,s3
  40366a:	6d8010ef          	jal	404d42 <open>
    if(fd >= 0)
  40366e:	fc0541e3          	bltz	a0,403630 <iref+0x70>
      close(fd);
  403672:	6b8010ef          	jal	404d2a <close>
  403676:	bf6d                	j	403630 <iref+0x70>
  403678:	03300493          	li	s1,51
    chdir("..");
  40367c:	00003997          	auipc	s3,0x3
  403680:	e9498993          	addi	s3,s3,-364 # 406510 <malloc+0x1338>
    unlink("irefd");
  403684:	00003917          	auipc	s2,0x3
  403688:	66c90913          	addi	s2,s2,1644 # 406cf0 <malloc+0x1b18>
    chdir("..");
  40368c:	854e                	mv	a0,s3
  40368e:	6e4010ef          	jal	404d72 <chdir>
    unlink("irefd");
  403692:	854a                	mv	a0,s2
  403694:	6be010ef          	jal	404d52 <unlink>
  for(i = 0; i < NINODE + 1; i++){
  403698:	34fd                	addiw	s1,s1,-1
  40369a:	f8ed                	bnez	s1,40368c <iref+0xcc>
  chdir("/");
  40369c:	00003517          	auipc	a0,0x3
  4036a0:	e1c50513          	addi	a0,a0,-484 # 4064b8 <malloc+0x12e0>
  4036a4:	6ce010ef          	jal	404d72 <chdir>
}
  4036a8:	60a6                	ld	ra,72(sp)
  4036aa:	6406                	ld	s0,64(sp)
  4036ac:	74e2                	ld	s1,56(sp)
  4036ae:	7942                	ld	s2,48(sp)
  4036b0:	79a2                	ld	s3,40(sp)
  4036b2:	7a02                	ld	s4,32(sp)
  4036b4:	6ae2                	ld	s5,24(sp)
  4036b6:	6b42                	ld	s6,16(sp)
  4036b8:	6ba2                	ld	s7,8(sp)
  4036ba:	6161                	addi	sp,sp,80
  4036bc:	8082                	ret

00000000004036be <openiputtest>:
{
  4036be:	7179                	addi	sp,sp,-48
  4036c0:	f406                	sd	ra,40(sp)
  4036c2:	f022                	sd	s0,32(sp)
  4036c4:	ec26                	sd	s1,24(sp)
  4036c6:	1800                	addi	s0,sp,48
  4036c8:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
  4036ca:	00003517          	auipc	a0,0x3
  4036ce:	65e50513          	addi	a0,a0,1630 # 406d28 <malloc+0x1b50>
  4036d2:	698010ef          	jal	404d6a <mkdir>
  4036d6:	02054a63          	bltz	a0,40370a <openiputtest+0x4c>
  pid = fork();
  4036da:	620010ef          	jal	404cfa <fork>
  if(pid < 0){
  4036de:	04054063          	bltz	a0,40371e <openiputtest+0x60>
  if(pid == 0){
  4036e2:	e939                	bnez	a0,403738 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
  4036e4:	4589                	li	a1,2
  4036e6:	00003517          	auipc	a0,0x3
  4036ea:	64250513          	addi	a0,a0,1602 # 406d28 <malloc+0x1b50>
  4036ee:	654010ef          	jal	404d42 <open>
    if(fd >= 0){
  4036f2:	04054063          	bltz	a0,403732 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
  4036f6:	85a6                	mv	a1,s1
  4036f8:	00003517          	auipc	a0,0x3
  4036fc:	65050513          	addi	a0,a0,1616 # 406d48 <malloc+0x1b70>
  403700:	21f010ef          	jal	40511e <printf>
      exit(1);
  403704:	4505                	li	a0,1
  403706:	5fc010ef          	jal	404d02 <exit>
    printf("%s: mkdir oidir failed\n", s);
  40370a:	85a6                	mv	a1,s1
  40370c:	00003517          	auipc	a0,0x3
  403710:	62450513          	addi	a0,a0,1572 # 406d30 <malloc+0x1b58>
  403714:	20b010ef          	jal	40511e <printf>
    exit(1);
  403718:	4505                	li	a0,1
  40371a:	5e8010ef          	jal	404d02 <exit>
    printf("%s: fork failed\n", s);
  40371e:	85a6                	mv	a1,s1
  403720:	00002517          	auipc	a0,0x2
  403724:	47850513          	addi	a0,a0,1144 # 405b98 <malloc+0x9c0>
  403728:	1f7010ef          	jal	40511e <printf>
    exit(1);
  40372c:	4505                	li	a0,1
  40372e:	5d4010ef          	jal	404d02 <exit>
    exit(0);
  403732:	4501                	li	a0,0
  403734:	5ce010ef          	jal	404d02 <exit>
  sleep(1);
  403738:	4505                	li	a0,1
  40373a:	658010ef          	jal	404d92 <sleep>
  if(unlink("oidir") != 0){
  40373e:	00003517          	auipc	a0,0x3
  403742:	5ea50513          	addi	a0,a0,1514 # 406d28 <malloc+0x1b50>
  403746:	60c010ef          	jal	404d52 <unlink>
  40374a:	c919                	beqz	a0,403760 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
  40374c:	85a6                	mv	a1,s1
  40374e:	00002517          	auipc	a0,0x2
  403752:	63a50513          	addi	a0,a0,1594 # 405d88 <malloc+0xbb0>
  403756:	1c9010ef          	jal	40511e <printf>
    exit(1);
  40375a:	4505                	li	a0,1
  40375c:	5a6010ef          	jal	404d02 <exit>
  wait(&xstatus);
  403760:	fdc40513          	addi	a0,s0,-36
  403764:	5a6010ef          	jal	404d0a <wait>
  exit(xstatus);
  403768:	fdc42503          	lw	a0,-36(s0)
  40376c:	596010ef          	jal	404d02 <exit>

0000000000403770 <forkforkfork>:
{
  403770:	1101                	addi	sp,sp,-32
  403772:	ec06                	sd	ra,24(sp)
  403774:	e822                	sd	s0,16(sp)
  403776:	e426                	sd	s1,8(sp)
  403778:	1000                	addi	s0,sp,32
  40377a:	84aa                	mv	s1,a0
  unlink("stopforking");
  40377c:	00003517          	auipc	a0,0x3
  403780:	5f450513          	addi	a0,a0,1524 # 406d70 <malloc+0x1b98>
  403784:	5ce010ef          	jal	404d52 <unlink>
  int pid = fork();
  403788:	572010ef          	jal	404cfa <fork>
  if(pid < 0){
  40378c:	02054b63          	bltz	a0,4037c2 <forkforkfork+0x52>
  if(pid == 0){
  403790:	c139                	beqz	a0,4037d6 <forkforkfork+0x66>
  sleep(20); // two seconds
  403792:	4551                	li	a0,20
  403794:	5fe010ef          	jal	404d92 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
  403798:	20200593          	li	a1,514
  40379c:	00003517          	auipc	a0,0x3
  4037a0:	5d450513          	addi	a0,a0,1492 # 406d70 <malloc+0x1b98>
  4037a4:	59e010ef          	jal	404d42 <open>
  4037a8:	582010ef          	jal	404d2a <close>
  wait(0);
  4037ac:	4501                	li	a0,0
  4037ae:	55c010ef          	jal	404d0a <wait>
  sleep(10); // one second
  4037b2:	4529                	li	a0,10
  4037b4:	5de010ef          	jal	404d92 <sleep>
}
  4037b8:	60e2                	ld	ra,24(sp)
  4037ba:	6442                	ld	s0,16(sp)
  4037bc:	64a2                	ld	s1,8(sp)
  4037be:	6105                	addi	sp,sp,32
  4037c0:	8082                	ret
    printf("%s: fork failed", s);
  4037c2:	85a6                	mv	a1,s1
  4037c4:	00002517          	auipc	a0,0x2
  4037c8:	59450513          	addi	a0,a0,1428 # 405d58 <malloc+0xb80>
  4037cc:	153010ef          	jal	40511e <printf>
    exit(1);
  4037d0:	4505                	li	a0,1
  4037d2:	530010ef          	jal	404d02 <exit>
      int fd = open("stopforking", 0);
  4037d6:	00003497          	auipc	s1,0x3
  4037da:	59a48493          	addi	s1,s1,1434 # 406d70 <malloc+0x1b98>
  4037de:	4581                	li	a1,0
  4037e0:	8526                	mv	a0,s1
  4037e2:	560010ef          	jal	404d42 <open>
      if(fd >= 0){
  4037e6:	02055163          	bgez	a0,403808 <forkforkfork+0x98>
      if(fork() < 0){
  4037ea:	510010ef          	jal	404cfa <fork>
  4037ee:	fe0558e3          	bgez	a0,4037de <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
  4037f2:	20200593          	li	a1,514
  4037f6:	00003517          	auipc	a0,0x3
  4037fa:	57a50513          	addi	a0,a0,1402 # 406d70 <malloc+0x1b98>
  4037fe:	544010ef          	jal	404d42 <open>
  403802:	528010ef          	jal	404d2a <close>
  403806:	bfe1                	j	4037de <forkforkfork+0x6e>
        exit(0);
  403808:	4501                	li	a0,0
  40380a:	4f8010ef          	jal	404d02 <exit>

000000000040380e <killstatus>:
{
  40380e:	715d                	addi	sp,sp,-80
  403810:	e486                	sd	ra,72(sp)
  403812:	e0a2                	sd	s0,64(sp)
  403814:	fc26                	sd	s1,56(sp)
  403816:	f84a                	sd	s2,48(sp)
  403818:	f44e                	sd	s3,40(sp)
  40381a:	f052                	sd	s4,32(sp)
  40381c:	ec56                	sd	s5,24(sp)
  40381e:	e85a                	sd	s6,16(sp)
  403820:	0880                	addi	s0,sp,80
  403822:	8b2a                	mv	s6,a0
  403824:	06400913          	li	s2,100
    sleep(1);
  403828:	4a85                	li	s5,1
    wait(&xst);
  40382a:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
  40382e:	59fd                	li	s3,-1
    int pid1 = fork();
  403830:	4ca010ef          	jal	404cfa <fork>
  403834:	84aa                	mv	s1,a0
    if(pid1 < 0){
  403836:	02054663          	bltz	a0,403862 <killstatus+0x54>
    if(pid1 == 0){
  40383a:	cd15                	beqz	a0,403876 <killstatus+0x68>
    sleep(1);
  40383c:	8556                	mv	a0,s5
  40383e:	554010ef          	jal	404d92 <sleep>
    kill(pid1);
  403842:	8526                	mv	a0,s1
  403844:	4ee010ef          	jal	404d32 <kill>
    wait(&xst);
  403848:	8552                	mv	a0,s4
  40384a:	4c0010ef          	jal	404d0a <wait>
    if(xst != -1) {
  40384e:	fbc42783          	lw	a5,-68(s0)
  403852:	03379563          	bne	a5,s3,40387c <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
  403856:	397d                	addiw	s2,s2,-1
  403858:	fc091ce3          	bnez	s2,403830 <killstatus+0x22>
  exit(0);
  40385c:	4501                	li	a0,0
  40385e:	4a4010ef          	jal	404d02 <exit>
      printf("%s: fork failed\n", s);
  403862:	85da                	mv	a1,s6
  403864:	00002517          	auipc	a0,0x2
  403868:	33450513          	addi	a0,a0,820 # 405b98 <malloc+0x9c0>
  40386c:	0b3010ef          	jal	40511e <printf>
      exit(1);
  403870:	4505                	li	a0,1
  403872:	490010ef          	jal	404d02 <exit>
        getpid();
  403876:	50c010ef          	jal	404d82 <getpid>
      while(1) {
  40387a:	bff5                	j	403876 <killstatus+0x68>
       printf("%s: status should be -1\n", s);
  40387c:	85da                	mv	a1,s6
  40387e:	00003517          	auipc	a0,0x3
  403882:	50250513          	addi	a0,a0,1282 # 406d80 <malloc+0x1ba8>
  403886:	099010ef          	jal	40511e <printf>
       exit(1);
  40388a:	4505                	li	a0,1
  40388c:	476010ef          	jal	404d02 <exit>

0000000000403890 <preempt>:
{
  403890:	7139                	addi	sp,sp,-64
  403892:	fc06                	sd	ra,56(sp)
  403894:	f822                	sd	s0,48(sp)
  403896:	f426                	sd	s1,40(sp)
  403898:	f04a                	sd	s2,32(sp)
  40389a:	ec4e                	sd	s3,24(sp)
  40389c:	e852                	sd	s4,16(sp)
  40389e:	0080                	addi	s0,sp,64
  4038a0:	892a                	mv	s2,a0
  pid1 = fork();
  4038a2:	458010ef          	jal	404cfa <fork>
  if(pid1 < 0) {
  4038a6:	00054563          	bltz	a0,4038b0 <preempt+0x20>
  4038aa:	84aa                	mv	s1,a0
  if(pid1 == 0)
  4038ac:	ed01                	bnez	a0,4038c4 <preempt+0x34>
    for(;;)
  4038ae:	a001                	j	4038ae <preempt+0x1e>
    printf("%s: fork failed", s);
  4038b0:	85ca                	mv	a1,s2
  4038b2:	00002517          	auipc	a0,0x2
  4038b6:	4a650513          	addi	a0,a0,1190 # 405d58 <malloc+0xb80>
  4038ba:	065010ef          	jal	40511e <printf>
    exit(1);
  4038be:	4505                	li	a0,1
  4038c0:	442010ef          	jal	404d02 <exit>
  pid2 = fork();
  4038c4:	436010ef          	jal	404cfa <fork>
  4038c8:	89aa                	mv	s3,a0
  if(pid2 < 0) {
  4038ca:	00054463          	bltz	a0,4038d2 <preempt+0x42>
  if(pid2 == 0)
  4038ce:	ed01                	bnez	a0,4038e6 <preempt+0x56>
    for(;;)
  4038d0:	a001                	j	4038d0 <preempt+0x40>
    printf("%s: fork failed\n", s);
  4038d2:	85ca                	mv	a1,s2
  4038d4:	00002517          	auipc	a0,0x2
  4038d8:	2c450513          	addi	a0,a0,708 # 405b98 <malloc+0x9c0>
  4038dc:	043010ef          	jal	40511e <printf>
    exit(1);
  4038e0:	4505                	li	a0,1
  4038e2:	420010ef          	jal	404d02 <exit>
  pipe(pfds);
  4038e6:	fc840513          	addi	a0,s0,-56
  4038ea:	428010ef          	jal	404d12 <pipe>
  pid3 = fork();
  4038ee:	40c010ef          	jal	404cfa <fork>
  4038f2:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
  4038f4:	02054863          	bltz	a0,403924 <preempt+0x94>
  if(pid3 == 0){
  4038f8:	e921                	bnez	a0,403948 <preempt+0xb8>
    close(pfds[0]);
  4038fa:	fc842503          	lw	a0,-56(s0)
  4038fe:	42c010ef          	jal	404d2a <close>
    if(write(pfds[1], "x", 1) != 1)
  403902:	4605                	li	a2,1
  403904:	00002597          	auipc	a1,0x2
  403908:	a7458593          	addi	a1,a1,-1420 # 405378 <malloc+0x1a0>
  40390c:	fcc42503          	lw	a0,-52(s0)
  403910:	412010ef          	jal	404d22 <write>
  403914:	4785                	li	a5,1
  403916:	02f51163          	bne	a0,a5,403938 <preempt+0xa8>
    close(pfds[1]);
  40391a:	fcc42503          	lw	a0,-52(s0)
  40391e:	40c010ef          	jal	404d2a <close>
    for(;;)
  403922:	a001                	j	403922 <preempt+0x92>
     printf("%s: fork failed\n", s);
  403924:	85ca                	mv	a1,s2
  403926:	00002517          	auipc	a0,0x2
  40392a:	27250513          	addi	a0,a0,626 # 405b98 <malloc+0x9c0>
  40392e:	7f0010ef          	jal	40511e <printf>
     exit(1);
  403932:	4505                	li	a0,1
  403934:	3ce010ef          	jal	404d02 <exit>
      printf("%s: preempt write error", s);
  403938:	85ca                	mv	a1,s2
  40393a:	00003517          	auipc	a0,0x3
  40393e:	46650513          	addi	a0,a0,1126 # 406da0 <malloc+0x1bc8>
  403942:	7dc010ef          	jal	40511e <printf>
  403946:	bfd1                	j	40391a <preempt+0x8a>
  close(pfds[1]);
  403948:	fcc42503          	lw	a0,-52(s0)
  40394c:	3de010ef          	jal	404d2a <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
  403950:	660d                	lui	a2,0x3
  403952:	00009597          	auipc	a1,0x9
  403956:	32658593          	addi	a1,a1,806 # 40cc78 <buf>
  40395a:	fc842503          	lw	a0,-56(s0)
  40395e:	3bc010ef          	jal	404d1a <read>
  403962:	4785                	li	a5,1
  403964:	02f50163          	beq	a0,a5,403986 <preempt+0xf6>
    printf("%s: preempt read error", s);
  403968:	85ca                	mv	a1,s2
  40396a:	00003517          	auipc	a0,0x3
  40396e:	44e50513          	addi	a0,a0,1102 # 406db8 <malloc+0x1be0>
  403972:	7ac010ef          	jal	40511e <printf>
}
  403976:	70e2                	ld	ra,56(sp)
  403978:	7442                	ld	s0,48(sp)
  40397a:	74a2                	ld	s1,40(sp)
  40397c:	7902                	ld	s2,32(sp)
  40397e:	69e2                	ld	s3,24(sp)
  403980:	6a42                	ld	s4,16(sp)
  403982:	6121                	addi	sp,sp,64
  403984:	8082                	ret
  close(pfds[0]);
  403986:	fc842503          	lw	a0,-56(s0)
  40398a:	3a0010ef          	jal	404d2a <close>
  printf("kill... ");
  40398e:	00003517          	auipc	a0,0x3
  403992:	44250513          	addi	a0,a0,1090 # 406dd0 <malloc+0x1bf8>
  403996:	788010ef          	jal	40511e <printf>
  kill(pid1);
  40399a:	8526                	mv	a0,s1
  40399c:	396010ef          	jal	404d32 <kill>
  kill(pid2);
  4039a0:	854e                	mv	a0,s3
  4039a2:	390010ef          	jal	404d32 <kill>
  kill(pid3);
  4039a6:	8552                	mv	a0,s4
  4039a8:	38a010ef          	jal	404d32 <kill>
  printf("wait... ");
  4039ac:	00003517          	auipc	a0,0x3
  4039b0:	43450513          	addi	a0,a0,1076 # 406de0 <malloc+0x1c08>
  4039b4:	76a010ef          	jal	40511e <printf>
  wait(0);
  4039b8:	4501                	li	a0,0
  4039ba:	350010ef          	jal	404d0a <wait>
  wait(0);
  4039be:	4501                	li	a0,0
  4039c0:	34a010ef          	jal	404d0a <wait>
  wait(0);
  4039c4:	4501                	li	a0,0
  4039c6:	344010ef          	jal	404d0a <wait>
  4039ca:	b775                	j	403976 <preempt+0xe6>

00000000004039cc <reparent>:
{
  4039cc:	7179                	addi	sp,sp,-48
  4039ce:	f406                	sd	ra,40(sp)
  4039d0:	f022                	sd	s0,32(sp)
  4039d2:	ec26                	sd	s1,24(sp)
  4039d4:	e84a                	sd	s2,16(sp)
  4039d6:	e44e                	sd	s3,8(sp)
  4039d8:	e052                	sd	s4,0(sp)
  4039da:	1800                	addi	s0,sp,48
  4039dc:	89aa                	mv	s3,a0
  int master_pid = getpid();
  4039de:	3a4010ef          	jal	404d82 <getpid>
  4039e2:	8a2a                	mv	s4,a0
  4039e4:	0c800913          	li	s2,200
    int pid = fork();
  4039e8:	312010ef          	jal	404cfa <fork>
  4039ec:	84aa                	mv	s1,a0
    if(pid < 0){
  4039ee:	00054e63          	bltz	a0,403a0a <reparent+0x3e>
    if(pid){
  4039f2:	c121                	beqz	a0,403a32 <reparent+0x66>
      if(wait(0) != pid){
  4039f4:	4501                	li	a0,0
  4039f6:	314010ef          	jal	404d0a <wait>
  4039fa:	02951263          	bne	a0,s1,403a1e <reparent+0x52>
  for(int i = 0; i < 200; i++){
  4039fe:	397d                	addiw	s2,s2,-1
  403a00:	fe0914e3          	bnez	s2,4039e8 <reparent+0x1c>
  exit(0);
  403a04:	4501                	li	a0,0
  403a06:	2fc010ef          	jal	404d02 <exit>
      printf("%s: fork failed\n", s);
  403a0a:	85ce                	mv	a1,s3
  403a0c:	00002517          	auipc	a0,0x2
  403a10:	18c50513          	addi	a0,a0,396 # 405b98 <malloc+0x9c0>
  403a14:	70a010ef          	jal	40511e <printf>
      exit(1);
  403a18:	4505                	li	a0,1
  403a1a:	2e8010ef          	jal	404d02 <exit>
        printf("%s: wait wrong pid\n", s);
  403a1e:	85ce                	mv	a1,s3
  403a20:	00002517          	auipc	a0,0x2
  403a24:	30050513          	addi	a0,a0,768 # 405d20 <malloc+0xb48>
  403a28:	6f6010ef          	jal	40511e <printf>
        exit(1);
  403a2c:	4505                	li	a0,1
  403a2e:	2d4010ef          	jal	404d02 <exit>
      int pid2 = fork();
  403a32:	2c8010ef          	jal	404cfa <fork>
      if(pid2 < 0){
  403a36:	00054563          	bltz	a0,403a40 <reparent+0x74>
      exit(0);
  403a3a:	4501                	li	a0,0
  403a3c:	2c6010ef          	jal	404d02 <exit>
        kill(master_pid);
  403a40:	8552                	mv	a0,s4
  403a42:	2f0010ef          	jal	404d32 <kill>
        exit(1);
  403a46:	4505                	li	a0,1
  403a48:	2ba010ef          	jal	404d02 <exit>

0000000000403a4c <sbrkfail>:
{
  403a4c:	7175                	addi	sp,sp,-144
  403a4e:	e506                	sd	ra,136(sp)
  403a50:	e122                	sd	s0,128(sp)
  403a52:	fca6                	sd	s1,120(sp)
  403a54:	f8ca                	sd	s2,112(sp)
  403a56:	f4ce                	sd	s3,104(sp)
  403a58:	f0d2                	sd	s4,96(sp)
  403a5a:	ecd6                	sd	s5,88(sp)
  403a5c:	e8da                	sd	s6,80(sp)
  403a5e:	e4de                	sd	s7,72(sp)
  403a60:	0900                	addi	s0,sp,144
  403a62:	8baa                	mv	s7,a0
  if(pipe(fds) != 0){
  403a64:	fa040513          	addi	a0,s0,-96
  403a68:	2aa010ef          	jal	404d12 <pipe>
  403a6c:	e919                	bnez	a0,403a82 <sbrkfail+0x36>
  403a6e:	f7040493          	addi	s1,s0,-144
  403a72:	f9840993          	addi	s3,s0,-104
  403a76:	8926                	mv	s2,s1
    if(pids[i] != -1)
  403a78:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
  403a7a:	f9f40b13          	addi	s6,s0,-97
  403a7e:	4a85                	li	s5,1
  403a80:	a0a9                	j	403aca <sbrkfail+0x7e>
    printf("%s: pipe() failed\n", s);
  403a82:	85de                	mv	a1,s7
  403a84:	00002517          	auipc	a0,0x2
  403a88:	21c50513          	addi	a0,a0,540 # 405ca0 <malloc+0xac8>
  403a8c:	692010ef          	jal	40511e <printf>
    exit(1);
  403a90:	4505                	li	a0,1
  403a92:	270010ef          	jal	404d02 <exit>
      sbrk(BIG - (uint64)sbrk(0));
  403a96:	2f4010ef          	jal	404d8a <sbrk>
  403a9a:	064007b7          	lui	a5,0x6400
  403a9e:	40a7853b          	subw	a0,a5,a0
  403aa2:	2e8010ef          	jal	404d8a <sbrk>
      write(fds[1], "x", 1);
  403aa6:	4605                	li	a2,1
  403aa8:	00002597          	auipc	a1,0x2
  403aac:	8d058593          	addi	a1,a1,-1840 # 405378 <malloc+0x1a0>
  403ab0:	fa442503          	lw	a0,-92(s0)
  403ab4:	26e010ef          	jal	404d22 <write>
      for(;;) sleep(1000);
  403ab8:	3e800493          	li	s1,1000
  403abc:	8526                	mv	a0,s1
  403abe:	2d4010ef          	jal	404d92 <sleep>
  403ac2:	bfed                	j	403abc <sbrkfail+0x70>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
  403ac4:	0911                	addi	s2,s2,4
  403ac6:	03390063          	beq	s2,s3,403ae6 <sbrkfail+0x9a>
    if((pids[i] = fork()) == 0){
  403aca:	230010ef          	jal	404cfa <fork>
  403ace:	00a92023          	sw	a0,0(s2)
  403ad2:	d171                	beqz	a0,403a96 <sbrkfail+0x4a>
    if(pids[i] != -1)
  403ad4:	ff4508e3          	beq	a0,s4,403ac4 <sbrkfail+0x78>
      read(fds[0], &scratch, 1);
  403ad8:	8656                	mv	a2,s5
  403ada:	85da                	mv	a1,s6
  403adc:	fa042503          	lw	a0,-96(s0)
  403ae0:	23a010ef          	jal	404d1a <read>
  403ae4:	b7c5                	j	403ac4 <sbrkfail+0x78>
  c = sbrk(PGSIZE);
  403ae6:	6505                	lui	a0,0x1
  403ae8:	2a2010ef          	jal	404d8a <sbrk>
  403aec:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
  403aee:	597d                	li	s2,-1
  403af0:	a021                	j	403af8 <sbrkfail+0xac>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
  403af2:	0491                	addi	s1,s1,4
  403af4:	01348b63          	beq	s1,s3,403b0a <sbrkfail+0xbe>
    if(pids[i] == -1)
  403af8:	4088                	lw	a0,0(s1)
  403afa:	ff250ce3          	beq	a0,s2,403af2 <sbrkfail+0xa6>
    kill(pids[i]);
  403afe:	234010ef          	jal	404d32 <kill>
    wait(0);
  403b02:	4501                	li	a0,0
  403b04:	206010ef          	jal	404d0a <wait>
  403b08:	b7ed                	j	403af2 <sbrkfail+0xa6>
  if(c == (char*)0xffffffffffffffffL){
  403b0a:	57fd                	li	a5,-1
  403b0c:	02fa0f63          	beq	s4,a5,403b4a <sbrkfail+0xfe>
  pid = fork();
  403b10:	1ea010ef          	jal	404cfa <fork>
  403b14:	84aa                	mv	s1,a0
  if(pid < 0){
  403b16:	04054463          	bltz	a0,403b5e <sbrkfail+0x112>
  if(pid == 0){
  403b1a:	cd21                	beqz	a0,403b72 <sbrkfail+0x126>
  wait(&xstatus);
  403b1c:	fac40513          	addi	a0,s0,-84
  403b20:	1ea010ef          	jal	404d0a <wait>
  if(xstatus != -1 && xstatus != 2)
  403b24:	fac42783          	lw	a5,-84(s0)
  403b28:	577d                	li	a4,-1
  403b2a:	00e78563          	beq	a5,a4,403b34 <sbrkfail+0xe8>
  403b2e:	4709                	li	a4,2
  403b30:	06e79f63          	bne	a5,a4,403bae <sbrkfail+0x162>
}
  403b34:	60aa                	ld	ra,136(sp)
  403b36:	640a                	ld	s0,128(sp)
  403b38:	74e6                	ld	s1,120(sp)
  403b3a:	7946                	ld	s2,112(sp)
  403b3c:	79a6                	ld	s3,104(sp)
  403b3e:	7a06                	ld	s4,96(sp)
  403b40:	6ae6                	ld	s5,88(sp)
  403b42:	6b46                	ld	s6,80(sp)
  403b44:	6ba6                	ld	s7,72(sp)
  403b46:	6149                	addi	sp,sp,144
  403b48:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
  403b4a:	85de                	mv	a1,s7
  403b4c:	00003517          	auipc	a0,0x3
  403b50:	2a450513          	addi	a0,a0,676 # 406df0 <malloc+0x1c18>
  403b54:	5ca010ef          	jal	40511e <printf>
    exit(1);
  403b58:	4505                	li	a0,1
  403b5a:	1a8010ef          	jal	404d02 <exit>
    printf("%s: fork failed\n", s);
  403b5e:	85de                	mv	a1,s7
  403b60:	00002517          	auipc	a0,0x2
  403b64:	03850513          	addi	a0,a0,56 # 405b98 <malloc+0x9c0>
  403b68:	5b6010ef          	jal	40511e <printf>
    exit(1);
  403b6c:	4505                	li	a0,1
  403b6e:	194010ef          	jal	404d02 <exit>
    a = sbrk(0);
  403b72:	4501                	li	a0,0
  403b74:	216010ef          	jal	404d8a <sbrk>
  403b78:	892a                	mv	s2,a0
    sbrk(10*BIG);
  403b7a:	3e800537          	lui	a0,0x3e800
  403b7e:	20c010ef          	jal	404d8a <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
  403b82:	87ca                	mv	a5,s2
  403b84:	3e800737          	lui	a4,0x3e800
  403b88:	993a                	add	s2,s2,a4
  403b8a:	6705                	lui	a4,0x1
      n += *(a+i);
  403b8c:	0007c603          	lbu	a2,0(a5) # 6400000 <base+0x5ff0388>
  403b90:	9e25                	addw	a2,a2,s1
  403b92:	84b2                	mv	s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
  403b94:	97ba                	add	a5,a5,a4
  403b96:	fef91be3          	bne	s2,a5,403b8c <sbrkfail+0x140>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
  403b9a:	85de                	mv	a1,s7
  403b9c:	00003517          	auipc	a0,0x3
  403ba0:	27450513          	addi	a0,a0,628 # 406e10 <malloc+0x1c38>
  403ba4:	57a010ef          	jal	40511e <printf>
    exit(1);
  403ba8:	4505                	li	a0,1
  403baa:	158010ef          	jal	404d02 <exit>
    exit(1);
  403bae:	4505                	li	a0,1
  403bb0:	152010ef          	jal	404d02 <exit>

0000000000403bb4 <mem>:
{
  403bb4:	7139                	addi	sp,sp,-64
  403bb6:	fc06                	sd	ra,56(sp)
  403bb8:	f822                	sd	s0,48(sp)
  403bba:	f426                	sd	s1,40(sp)
  403bbc:	f04a                	sd	s2,32(sp)
  403bbe:	ec4e                	sd	s3,24(sp)
  403bc0:	0080                	addi	s0,sp,64
  403bc2:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
  403bc4:	136010ef          	jal	404cfa <fork>
    m1 = 0;
  403bc8:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
  403bca:	6909                	lui	s2,0x2
  403bcc:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr1-0x3fd8ef>
  if((pid = fork()) == 0){
  403bd0:	cd11                	beqz	a0,403bec <mem+0x38>
    wait(&xstatus);
  403bd2:	fcc40513          	addi	a0,s0,-52
  403bd6:	134010ef          	jal	404d0a <wait>
    if(xstatus == -1){
  403bda:	fcc42503          	lw	a0,-52(s0)
  403bde:	57fd                	li	a5,-1
  403be0:	04f50363          	beq	a0,a5,403c26 <mem+0x72>
    exit(xstatus);
  403be4:	11e010ef          	jal	404d02 <exit>
      *(char**)m2 = m1;
  403be8:	e104                	sd	s1,0(a0)
      m1 = m2;
  403bea:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
  403bec:	854a                	mv	a0,s2
  403bee:	5ea010ef          	jal	4051d8 <malloc>
  403bf2:	f97d                	bnez	a0,403be8 <mem+0x34>
    while(m1){
  403bf4:	c491                	beqz	s1,403c00 <mem+0x4c>
      m2 = *(char**)m1;
  403bf6:	8526                	mv	a0,s1
  403bf8:	6084                	ld	s1,0(s1)
      free(m1);
  403bfa:	558010ef          	jal	405152 <free>
    while(m1){
  403bfe:	fce5                	bnez	s1,403bf6 <mem+0x42>
    m1 = malloc(1024*20);
  403c00:	6515                	lui	a0,0x5
  403c02:	5d6010ef          	jal	4051d8 <malloc>
    if(m1 == 0){
  403c06:	c511                	beqz	a0,403c12 <mem+0x5e>
    free(m1);
  403c08:	54a010ef          	jal	405152 <free>
    exit(0);
  403c0c:	4501                	li	a0,0
  403c0e:	0f4010ef          	jal	404d02 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
  403c12:	85ce                	mv	a1,s3
  403c14:	00003517          	auipc	a0,0x3
  403c18:	22c50513          	addi	a0,a0,556 # 406e40 <malloc+0x1c68>
  403c1c:	502010ef          	jal	40511e <printf>
      exit(1);
  403c20:	4505                	li	a0,1
  403c22:	0e0010ef          	jal	404d02 <exit>
      exit(0);
  403c26:	4501                	li	a0,0
  403c28:	0da010ef          	jal	404d02 <exit>

0000000000403c2c <sharedfd>:
{
  403c2c:	7119                	addi	sp,sp,-128
  403c2e:	fc86                	sd	ra,120(sp)
  403c30:	f8a2                	sd	s0,112(sp)
  403c32:	e0da                	sd	s6,64(sp)
  403c34:	0100                	addi	s0,sp,128
  403c36:	8b2a                	mv	s6,a0
  unlink("sharedfd");
  403c38:	00003517          	auipc	a0,0x3
  403c3c:	22850513          	addi	a0,a0,552 # 406e60 <malloc+0x1c88>
  403c40:	112010ef          	jal	404d52 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
  403c44:	20200593          	li	a1,514
  403c48:	00003517          	auipc	a0,0x3
  403c4c:	21850513          	addi	a0,a0,536 # 406e60 <malloc+0x1c88>
  403c50:	0f2010ef          	jal	404d42 <open>
  if(fd < 0){
  403c54:	04054b63          	bltz	a0,403caa <sharedfd+0x7e>
  403c58:	f4a6                	sd	s1,104(sp)
  403c5a:	f0ca                	sd	s2,96(sp)
  403c5c:	ecce                	sd	s3,88(sp)
  403c5e:	e8d2                	sd	s4,80(sp)
  403c60:	e4d6                	sd	s5,72(sp)
  403c62:	89aa                	mv	s3,a0
  pid = fork();
  403c64:	096010ef          	jal	404cfa <fork>
  403c68:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
  403c6a:	07000593          	li	a1,112
  403c6e:	e119                	bnez	a0,403c74 <sharedfd+0x48>
  403c70:	06300593          	li	a1,99
  403c74:	4629                	li	a2,10
  403c76:	f9040513          	addi	a0,s0,-112
  403c7a:	67b000ef          	jal	404af4 <memset>
  403c7e:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
  403c82:	f9040a13          	addi	s4,s0,-112
  403c86:	4929                	li	s2,10
  403c88:	864a                	mv	a2,s2
  403c8a:	85d2                	mv	a1,s4
  403c8c:	854e                	mv	a0,s3
  403c8e:	094010ef          	jal	404d22 <write>
  403c92:	03251e63          	bne	a0,s2,403cce <sharedfd+0xa2>
  for(i = 0; i < N; i++){
  403c96:	34fd                	addiw	s1,s1,-1
  403c98:	f8e5                	bnez	s1,403c88 <sharedfd+0x5c>
  if(pid == 0) {
  403c9a:	040a9763          	bnez	s5,403ce8 <sharedfd+0xbc>
  403c9e:	fc5e                	sd	s7,56(sp)
  403ca0:	f862                	sd	s8,48(sp)
  403ca2:	f466                	sd	s9,40(sp)
    exit(0);
  403ca4:	4501                	li	a0,0
  403ca6:	05c010ef          	jal	404d02 <exit>
  403caa:	f4a6                	sd	s1,104(sp)
  403cac:	f0ca                	sd	s2,96(sp)
  403cae:	ecce                	sd	s3,88(sp)
  403cb0:	e8d2                	sd	s4,80(sp)
  403cb2:	e4d6                	sd	s5,72(sp)
  403cb4:	fc5e                	sd	s7,56(sp)
  403cb6:	f862                	sd	s8,48(sp)
  403cb8:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
  403cba:	85da                	mv	a1,s6
  403cbc:	00003517          	auipc	a0,0x3
  403cc0:	1b450513          	addi	a0,a0,436 # 406e70 <malloc+0x1c98>
  403cc4:	45a010ef          	jal	40511e <printf>
    exit(1);
  403cc8:	4505                	li	a0,1
  403cca:	038010ef          	jal	404d02 <exit>
  403cce:	fc5e                	sd	s7,56(sp)
  403cd0:	f862                	sd	s8,48(sp)
  403cd2:	f466                	sd	s9,40(sp)
      printf("%s: write sharedfd failed\n", s);
  403cd4:	85da                	mv	a1,s6
  403cd6:	00003517          	auipc	a0,0x3
  403cda:	1c250513          	addi	a0,a0,450 # 406e98 <malloc+0x1cc0>
  403cde:	440010ef          	jal	40511e <printf>
      exit(1);
  403ce2:	4505                	li	a0,1
  403ce4:	01e010ef          	jal	404d02 <exit>
    wait(&xstatus);
  403ce8:	f8c40513          	addi	a0,s0,-116
  403cec:	01e010ef          	jal	404d0a <wait>
    if(xstatus != 0)
  403cf0:	f8c42a03          	lw	s4,-116(s0)
  403cf4:	000a0863          	beqz	s4,403d04 <sharedfd+0xd8>
  403cf8:	fc5e                	sd	s7,56(sp)
  403cfa:	f862                	sd	s8,48(sp)
  403cfc:	f466                	sd	s9,40(sp)
      exit(xstatus);
  403cfe:	8552                	mv	a0,s4
  403d00:	002010ef          	jal	404d02 <exit>
  403d04:	fc5e                	sd	s7,56(sp)
  close(fd);
  403d06:	854e                	mv	a0,s3
  403d08:	022010ef          	jal	404d2a <close>
  fd = open("sharedfd", 0);
  403d0c:	4581                	li	a1,0
  403d0e:	00003517          	auipc	a0,0x3
  403d12:	15250513          	addi	a0,a0,338 # 406e60 <malloc+0x1c88>
  403d16:	02c010ef          	jal	404d42 <open>
  403d1a:	8baa                	mv	s7,a0
  nc = np = 0;
  403d1c:	89d2                	mv	s3,s4
  if(fd < 0){
  403d1e:	02054763          	bltz	a0,403d4c <sharedfd+0x120>
  403d22:	f862                	sd	s8,48(sp)
  403d24:	f466                	sd	s9,40(sp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  403d26:	f9040c93          	addi	s9,s0,-112
  403d2a:	4c29                	li	s8,10
  403d2c:	f9a40913          	addi	s2,s0,-102
      if(buf[i] == 'c')
  403d30:	06300493          	li	s1,99
      if(buf[i] == 'p')
  403d34:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
  403d38:	8662                	mv	a2,s8
  403d3a:	85e6                	mv	a1,s9
  403d3c:	855e                	mv	a0,s7
  403d3e:	7dd000ef          	jal	404d1a <read>
  403d42:	02a05d63          	blez	a0,403d7c <sharedfd+0x150>
  403d46:	f9040793          	addi	a5,s0,-112
  403d4a:	a00d                	j	403d6c <sharedfd+0x140>
  403d4c:	f862                	sd	s8,48(sp)
  403d4e:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for reading\n", s);
  403d50:	85da                	mv	a1,s6
  403d52:	00003517          	auipc	a0,0x3
  403d56:	16650513          	addi	a0,a0,358 # 406eb8 <malloc+0x1ce0>
  403d5a:	3c4010ef          	jal	40511e <printf>
    exit(1);
  403d5e:	4505                	li	a0,1
  403d60:	7a3000ef          	jal	404d02 <exit>
        nc++;
  403d64:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
  403d66:	0785                	addi	a5,a5,1
  403d68:	fd2788e3          	beq	a5,s2,403d38 <sharedfd+0x10c>
      if(buf[i] == 'c')
  403d6c:	0007c703          	lbu	a4,0(a5)
  403d70:	fe970ae3          	beq	a4,s1,403d64 <sharedfd+0x138>
      if(buf[i] == 'p')
  403d74:	ff5719e3          	bne	a4,s5,403d66 <sharedfd+0x13a>
        np++;
  403d78:	2985                	addiw	s3,s3,1
  403d7a:	b7f5                	j	403d66 <sharedfd+0x13a>
  close(fd);
  403d7c:	855e                	mv	a0,s7
  403d7e:	7ad000ef          	jal	404d2a <close>
  unlink("sharedfd");
  403d82:	00003517          	auipc	a0,0x3
  403d86:	0de50513          	addi	a0,a0,222 # 406e60 <malloc+0x1c88>
  403d8a:	7c9000ef          	jal	404d52 <unlink>
  if(nc == N*SZ && np == N*SZ){
  403d8e:	6789                	lui	a5,0x2
  403d90:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr1-0x3fd8f0>
  403d94:	00fa1763          	bne	s4,a5,403da2 <sharedfd+0x176>
  403d98:	6789                	lui	a5,0x2
  403d9a:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr1-0x3fd8f0>
  403d9e:	00f98c63          	beq	s3,a5,403db6 <sharedfd+0x18a>
    printf("%s: nc/np test fails\n", s);
  403da2:	85da                	mv	a1,s6
  403da4:	00003517          	auipc	a0,0x3
  403da8:	13c50513          	addi	a0,a0,316 # 406ee0 <malloc+0x1d08>
  403dac:	372010ef          	jal	40511e <printf>
    exit(1);
  403db0:	4505                	li	a0,1
  403db2:	751000ef          	jal	404d02 <exit>
    exit(0);
  403db6:	4501                	li	a0,0
  403db8:	74b000ef          	jal	404d02 <exit>

0000000000403dbc <fourfiles>:
{
  403dbc:	7135                	addi	sp,sp,-160
  403dbe:	ed06                	sd	ra,152(sp)
  403dc0:	e922                	sd	s0,144(sp)
  403dc2:	e526                	sd	s1,136(sp)
  403dc4:	e14a                	sd	s2,128(sp)
  403dc6:	fcce                	sd	s3,120(sp)
  403dc8:	f8d2                	sd	s4,112(sp)
  403dca:	f4d6                	sd	s5,104(sp)
  403dcc:	f0da                	sd	s6,96(sp)
  403dce:	ecde                	sd	s7,88(sp)
  403dd0:	e8e2                	sd	s8,80(sp)
  403dd2:	e4e6                	sd	s9,72(sp)
  403dd4:	e0ea                	sd	s10,64(sp)
  403dd6:	fc6e                	sd	s11,56(sp)
  403dd8:	1100                	addi	s0,sp,160
  403dda:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
  403ddc:	00003797          	auipc	a5,0x3
  403de0:	11c78793          	addi	a5,a5,284 # 406ef8 <malloc+0x1d20>
  403de4:	f6f43823          	sd	a5,-144(s0)
  403de8:	00003797          	auipc	a5,0x3
  403dec:	11878793          	addi	a5,a5,280 # 406f00 <malloc+0x1d28>
  403df0:	f6f43c23          	sd	a5,-136(s0)
  403df4:	00003797          	auipc	a5,0x3
  403df8:	11478793          	addi	a5,a5,276 # 406f08 <malloc+0x1d30>
  403dfc:	f8f43023          	sd	a5,-128(s0)
  403e00:	00003797          	auipc	a5,0x3
  403e04:	11078793          	addi	a5,a5,272 # 406f10 <malloc+0x1d38>
  403e08:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
  403e0c:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
  403e10:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
  403e12:	4481                	li	s1,0
  403e14:	4a11                	li	s4,4
    fname = names[pi];
  403e16:	00093983          	ld	s3,0(s2)
    unlink(fname);
  403e1a:	854e                	mv	a0,s3
  403e1c:	737000ef          	jal	404d52 <unlink>
    pid = fork();
  403e20:	6db000ef          	jal	404cfa <fork>
    if(pid < 0){
  403e24:	04054063          	bltz	a0,403e64 <fourfiles+0xa8>
    if(pid == 0){
  403e28:	c921                	beqz	a0,403e78 <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
  403e2a:	2485                	addiw	s1,s1,1
  403e2c:	0921                	addi	s2,s2,8
  403e2e:	ff4494e3          	bne	s1,s4,403e16 <fourfiles+0x5a>
  403e32:	4491                	li	s1,4
    wait(&xstatus);
  403e34:	f6c40913          	addi	s2,s0,-148
  403e38:	854a                	mv	a0,s2
  403e3a:	6d1000ef          	jal	404d0a <wait>
    if(xstatus != 0)
  403e3e:	f6c42b03          	lw	s6,-148(s0)
  403e42:	0a0b1463          	bnez	s6,403eea <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
  403e46:	34fd                	addiw	s1,s1,-1
  403e48:	f8e5                	bnez	s1,403e38 <fourfiles+0x7c>
  403e4a:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
  403e4e:	6a8d                	lui	s5,0x3
  403e50:	00009a17          	auipc	s4,0x9
  403e54:	e28a0a13          	addi	s4,s4,-472 # 40cc78 <buf>
    if(total != N*SZ){
  403e58:	6d05                	lui	s10,0x1
  403e5a:	770d0d13          	addi	s10,s10,1904 # 1770 <copyinstr1-0x3fe890>
  for(i = 0; i < NCHILD; i++){
  403e5e:	03400d93          	li	s11,52
  403e62:	a86d                	j	403f1c <fourfiles+0x160>
      printf("%s: fork failed\n", s);
  403e64:	85e6                	mv	a1,s9
  403e66:	00002517          	auipc	a0,0x2
  403e6a:	d3250513          	addi	a0,a0,-718 # 405b98 <malloc+0x9c0>
  403e6e:	2b0010ef          	jal	40511e <printf>
      exit(1);
  403e72:	4505                	li	a0,1
  403e74:	68f000ef          	jal	404d02 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
  403e78:	20200593          	li	a1,514
  403e7c:	854e                	mv	a0,s3
  403e7e:	6c5000ef          	jal	404d42 <open>
  403e82:	892a                	mv	s2,a0
      if(fd < 0){
  403e84:	04054063          	bltz	a0,403ec4 <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
  403e88:	1f400613          	li	a2,500
  403e8c:	0304859b          	addiw	a1,s1,48
  403e90:	00009517          	auipc	a0,0x9
  403e94:	de850513          	addi	a0,a0,-536 # 40cc78 <buf>
  403e98:	45d000ef          	jal	404af4 <memset>
  403e9c:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
  403e9e:	1f400993          	li	s3,500
  403ea2:	00009a17          	auipc	s4,0x9
  403ea6:	dd6a0a13          	addi	s4,s4,-554 # 40cc78 <buf>
  403eaa:	864e                	mv	a2,s3
  403eac:	85d2                	mv	a1,s4
  403eae:	854a                	mv	a0,s2
  403eb0:	673000ef          	jal	404d22 <write>
  403eb4:	85aa                	mv	a1,a0
  403eb6:	03351163          	bne	a0,s3,403ed8 <fourfiles+0x11c>
      for(i = 0; i < N; i++){
  403eba:	34fd                	addiw	s1,s1,-1
  403ebc:	f4fd                	bnez	s1,403eaa <fourfiles+0xee>
      exit(0);
  403ebe:	4501                	li	a0,0
  403ec0:	643000ef          	jal	404d02 <exit>
        printf("%s: create failed\n", s);
  403ec4:	85e6                	mv	a1,s9
  403ec6:	00002517          	auipc	a0,0x2
  403eca:	d6a50513          	addi	a0,a0,-662 # 405c30 <malloc+0xa58>
  403ece:	250010ef          	jal	40511e <printf>
        exit(1);
  403ed2:	4505                	li	a0,1
  403ed4:	62f000ef          	jal	404d02 <exit>
          printf("write failed %d\n", n);
  403ed8:	00003517          	auipc	a0,0x3
  403edc:	04050513          	addi	a0,a0,64 # 406f18 <malloc+0x1d40>
  403ee0:	23e010ef          	jal	40511e <printf>
          exit(1);
  403ee4:	4505                	li	a0,1
  403ee6:	61d000ef          	jal	404d02 <exit>
      exit(xstatus);
  403eea:	855a                	mv	a0,s6
  403eec:	617000ef          	jal	404d02 <exit>
          printf("%s: wrong char\n", s);
  403ef0:	85e6                	mv	a1,s9
  403ef2:	00003517          	auipc	a0,0x3
  403ef6:	03e50513          	addi	a0,a0,62 # 406f30 <malloc+0x1d58>
  403efa:	224010ef          	jal	40511e <printf>
          exit(1);
  403efe:	4505                	li	a0,1
  403f00:	603000ef          	jal	404d02 <exit>
    close(fd);
  403f04:	854e                	mv	a0,s3
  403f06:	625000ef          	jal	404d2a <close>
    if(total != N*SZ){
  403f0a:	05a91863          	bne	s2,s10,403f5a <fourfiles+0x19e>
    unlink(fname);
  403f0e:	8562                	mv	a0,s8
  403f10:	643000ef          	jal	404d52 <unlink>
  for(i = 0; i < NCHILD; i++){
  403f14:	0ba1                	addi	s7,s7,8
  403f16:	2485                	addiw	s1,s1,1
  403f18:	05b48b63          	beq	s1,s11,403f6e <fourfiles+0x1b2>
    fname = names[i];
  403f1c:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
  403f20:	4581                	li	a1,0
  403f22:	8562                	mv	a0,s8
  403f24:	61f000ef          	jal	404d42 <open>
  403f28:	89aa                	mv	s3,a0
    total = 0;
  403f2a:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
  403f2c:	8656                	mv	a2,s5
  403f2e:	85d2                	mv	a1,s4
  403f30:	854e                	mv	a0,s3
  403f32:	5e9000ef          	jal	404d1a <read>
  403f36:	fca057e3          	blez	a0,403f04 <fourfiles+0x148>
  403f3a:	00009797          	auipc	a5,0x9
  403f3e:	d3e78793          	addi	a5,a5,-706 # 40cc78 <buf>
  403f42:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
  403f46:	0007c703          	lbu	a4,0(a5)
  403f4a:	fa9713e3          	bne	a4,s1,403ef0 <fourfiles+0x134>
      for(j = 0; j < n; j++){
  403f4e:	0785                	addi	a5,a5,1
  403f50:	fed79be3          	bne	a5,a3,403f46 <fourfiles+0x18a>
      total += n;
  403f54:	00a9093b          	addw	s2,s2,a0
  403f58:	bfd1                	j	403f2c <fourfiles+0x170>
      printf("wrong length %d\n", total);
  403f5a:	85ca                	mv	a1,s2
  403f5c:	00003517          	auipc	a0,0x3
  403f60:	fe450513          	addi	a0,a0,-28 # 406f40 <malloc+0x1d68>
  403f64:	1ba010ef          	jal	40511e <printf>
      exit(1);
  403f68:	4505                	li	a0,1
  403f6a:	599000ef          	jal	404d02 <exit>
}
  403f6e:	60ea                	ld	ra,152(sp)
  403f70:	644a                	ld	s0,144(sp)
  403f72:	64aa                	ld	s1,136(sp)
  403f74:	690a                	ld	s2,128(sp)
  403f76:	79e6                	ld	s3,120(sp)
  403f78:	7a46                	ld	s4,112(sp)
  403f7a:	7aa6                	ld	s5,104(sp)
  403f7c:	7b06                	ld	s6,96(sp)
  403f7e:	6be6                	ld	s7,88(sp)
  403f80:	6c46                	ld	s8,80(sp)
  403f82:	6ca6                	ld	s9,72(sp)
  403f84:	6d06                	ld	s10,64(sp)
  403f86:	7de2                	ld	s11,56(sp)
  403f88:	610d                	addi	sp,sp,160
  403f8a:	8082                	ret

0000000000403f8c <concreate>:
{
  403f8c:	7171                	addi	sp,sp,-176
  403f8e:	f506                	sd	ra,168(sp)
  403f90:	f122                	sd	s0,160(sp)
  403f92:	ed26                	sd	s1,152(sp)
  403f94:	e94a                	sd	s2,144(sp)
  403f96:	e54e                	sd	s3,136(sp)
  403f98:	e152                	sd	s4,128(sp)
  403f9a:	fcd6                	sd	s5,120(sp)
  403f9c:	f8da                	sd	s6,112(sp)
  403f9e:	f4de                	sd	s7,104(sp)
  403fa0:	f0e2                	sd	s8,96(sp)
  403fa2:	ece6                	sd	s9,88(sp)
  403fa4:	e8ea                	sd	s10,80(sp)
  403fa6:	1900                	addi	s0,sp,176
  403fa8:	8baa                	mv	s7,a0
  file[0] = 'C';
  403faa:	04300793          	li	a5,67
  403fae:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
  403fb2:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
  403fb6:	4901                	li	s2,0
    unlink(file);
  403fb8:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
  403fbc:	55555b37          	lui	s6,0x55555
  403fc0:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x551458de>
  403fc4:	4c05                	li	s8,1
      fd = open(file, O_CREATE | O_RDWR);
  403fc6:	20200c93          	li	s9,514
      link("C0", file);
  403fca:	00003d17          	auipc	s10,0x3
  403fce:	f8ed0d13          	addi	s10,s10,-114 # 406f58 <malloc+0x1d80>
      wait(&xstatus);
  403fd2:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
  403fd6:	02800a13          	li	s4,40
  403fda:	ac2d                	j	404214 <concreate+0x288>
      link("C0", file);
  403fdc:	85ce                	mv	a1,s3
  403fde:	856a                	mv	a0,s10
  403fe0:	583000ef          	jal	404d62 <link>
    if(pid == 0) {
  403fe4:	ac31                	j	404200 <concreate+0x274>
    } else if(pid == 0 && (i % 5) == 1){
  403fe6:	666667b7          	lui	a5,0x66666
  403fea:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x662569ef>
  403fee:	02f907b3          	mul	a5,s2,a5
  403ff2:	9785                	srai	a5,a5,0x21
  403ff4:	41f9571b          	sraiw	a4,s2,0x1f
  403ff8:	9f99                	subw	a5,a5,a4
  403ffa:	0027971b          	slliw	a4,a5,0x2
  403ffe:	9fb9                	addw	a5,a5,a4
  404000:	40f9093b          	subw	s2,s2,a5
  404004:	4785                	li	a5,1
  404006:	02f90563          	beq	s2,a5,404030 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
  40400a:	20200593          	li	a1,514
  40400e:	f9840513          	addi	a0,s0,-104
  404012:	531000ef          	jal	404d42 <open>
      if(fd < 0){
  404016:	1e055063          	bgez	a0,4041f6 <concreate+0x26a>
        printf("concreate create %s failed\n", file);
  40401a:	f9840593          	addi	a1,s0,-104
  40401e:	00003517          	auipc	a0,0x3
  404022:	f4250513          	addi	a0,a0,-190 # 406f60 <malloc+0x1d88>
  404026:	0f8010ef          	jal	40511e <printf>
        exit(1);
  40402a:	4505                	li	a0,1
  40402c:	4d7000ef          	jal	404d02 <exit>
      link("C0", file);
  404030:	f9840593          	addi	a1,s0,-104
  404034:	00003517          	auipc	a0,0x3
  404038:	f2450513          	addi	a0,a0,-220 # 406f58 <malloc+0x1d80>
  40403c:	527000ef          	jal	404d62 <link>
      exit(0);
  404040:	4501                	li	a0,0
  404042:	4c1000ef          	jal	404d02 <exit>
        exit(1);
  404046:	4505                	li	a0,1
  404048:	4bb000ef          	jal	404d02 <exit>
  memset(fa, 0, sizeof(fa));
  40404c:	02800613          	li	a2,40
  404050:	4581                	li	a1,0
  404052:	f7040513          	addi	a0,s0,-144
  404056:	29f000ef          	jal	404af4 <memset>
  fd = open(".", 0);
  40405a:	4581                	li	a1,0
  40405c:	00002517          	auipc	a0,0x2
  404060:	99450513          	addi	a0,a0,-1644 # 4059f0 <malloc+0x818>
  404064:	4df000ef          	jal	404d42 <open>
  404068:	892a                	mv	s2,a0
  n = 0;
  40406a:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
  40406c:	f6040a13          	addi	s4,s0,-160
  404070:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
  404072:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
  404076:	02700c13          	li	s8,39
      fa[i] = 1;
  40407a:	4c85                	li	s9,1
  while(read(fd, &de, sizeof(de)) > 0){
  40407c:	864e                	mv	a2,s3
  40407e:	85d2                	mv	a1,s4
  404080:	854a                	mv	a0,s2
  404082:	499000ef          	jal	404d1a <read>
  404086:	06a05763          	blez	a0,4040f4 <concreate+0x168>
    if(de.inum == 0)
  40408a:	f6045783          	lhu	a5,-160(s0)
  40408e:	d7fd                	beqz	a5,40407c <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
  404090:	f6244783          	lbu	a5,-158(s0)
  404094:	ff5794e3          	bne	a5,s5,40407c <concreate+0xf0>
  404098:	f6444783          	lbu	a5,-156(s0)
  40409c:	f3e5                	bnez	a5,40407c <concreate+0xf0>
      i = de.name[1] - '0';
  40409e:	f6344783          	lbu	a5,-157(s0)
  4040a2:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
  4040a6:	00fc6f63          	bltu	s8,a5,4040c4 <concreate+0x138>
      if(fa[i]){
  4040aa:	fa078713          	addi	a4,a5,-96
  4040ae:	9722                	add	a4,a4,s0
  4040b0:	fd074703          	lbu	a4,-48(a4) # fd0 <copyinstr1-0x3ff030>
  4040b4:	e705                	bnez	a4,4040dc <concreate+0x150>
      fa[i] = 1;
  4040b6:	fa078793          	addi	a5,a5,-96
  4040ba:	97a2                	add	a5,a5,s0
  4040bc:	fd978823          	sb	s9,-48(a5)
      n++;
  4040c0:	2b05                	addiw	s6,s6,1
  4040c2:	bf6d                	j	40407c <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
  4040c4:	f6240613          	addi	a2,s0,-158
  4040c8:	85de                	mv	a1,s7
  4040ca:	00003517          	auipc	a0,0x3
  4040ce:	eb650513          	addi	a0,a0,-330 # 406f80 <malloc+0x1da8>
  4040d2:	04c010ef          	jal	40511e <printf>
        exit(1);
  4040d6:	4505                	li	a0,1
  4040d8:	42b000ef          	jal	404d02 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
  4040dc:	f6240613          	addi	a2,s0,-158
  4040e0:	85de                	mv	a1,s7
  4040e2:	00003517          	auipc	a0,0x3
  4040e6:	ebe50513          	addi	a0,a0,-322 # 406fa0 <malloc+0x1dc8>
  4040ea:	034010ef          	jal	40511e <printf>
        exit(1);
  4040ee:	4505                	li	a0,1
  4040f0:	413000ef          	jal	404d02 <exit>
  close(fd);
  4040f4:	854a                	mv	a0,s2
  4040f6:	435000ef          	jal	404d2a <close>
  if(n != N){
  4040fa:	02800793          	li	a5,40
  4040fe:	00fb1b63          	bne	s6,a5,404114 <concreate+0x188>
    if(((i % 3) == 0 && pid == 0) ||
  404102:	55555a37          	lui	s4,0x55555
  404106:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x551458de>
      close(open(file, 0));
  40410a:	f9840993          	addi	s3,s0,-104
    if(((i % 3) == 0 && pid == 0) ||
  40410e:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
  404110:	8abe                	mv	s5,a5
  404112:	a049                	j	404194 <concreate+0x208>
    printf("%s: concreate not enough files in directory listing\n", s);
  404114:	85de                	mv	a1,s7
  404116:	00003517          	auipc	a0,0x3
  40411a:	eb250513          	addi	a0,a0,-334 # 406fc8 <malloc+0x1df0>
  40411e:	000010ef          	jal	40511e <printf>
    exit(1);
  404122:	4505                	li	a0,1
  404124:	3df000ef          	jal	404d02 <exit>
      printf("%s: fork failed\n", s);
  404128:	85de                	mv	a1,s7
  40412a:	00002517          	auipc	a0,0x2
  40412e:	a6e50513          	addi	a0,a0,-1426 # 405b98 <malloc+0x9c0>
  404132:	7ed000ef          	jal	40511e <printf>
      exit(1);
  404136:	4505                	li	a0,1
  404138:	3cb000ef          	jal	404d02 <exit>
      close(open(file, 0));
  40413c:	4581                	li	a1,0
  40413e:	854e                	mv	a0,s3
  404140:	403000ef          	jal	404d42 <open>
  404144:	3e7000ef          	jal	404d2a <close>
      close(open(file, 0));
  404148:	4581                	li	a1,0
  40414a:	854e                	mv	a0,s3
  40414c:	3f7000ef          	jal	404d42 <open>
  404150:	3db000ef          	jal	404d2a <close>
      close(open(file, 0));
  404154:	4581                	li	a1,0
  404156:	854e                	mv	a0,s3
  404158:	3eb000ef          	jal	404d42 <open>
  40415c:	3cf000ef          	jal	404d2a <close>
      close(open(file, 0));
  404160:	4581                	li	a1,0
  404162:	854e                	mv	a0,s3
  404164:	3df000ef          	jal	404d42 <open>
  404168:	3c3000ef          	jal	404d2a <close>
      close(open(file, 0));
  40416c:	4581                	li	a1,0
  40416e:	854e                	mv	a0,s3
  404170:	3d3000ef          	jal	404d42 <open>
  404174:	3b7000ef          	jal	404d2a <close>
      close(open(file, 0));
  404178:	4581                	li	a1,0
  40417a:	854e                	mv	a0,s3
  40417c:	3c7000ef          	jal	404d42 <open>
  404180:	3ab000ef          	jal	404d2a <close>
    if(pid == 0)
  404184:	06090663          	beqz	s2,4041f0 <concreate+0x264>
      wait(0);
  404188:	4501                	li	a0,0
  40418a:	381000ef          	jal	404d0a <wait>
  for(i = 0; i < N; i++){
  40418e:	2485                	addiw	s1,s1,1
  404190:	0d548163          	beq	s1,s5,404252 <concreate+0x2c6>
    file[1] = '0' + i;
  404194:	0304879b          	addiw	a5,s1,48
  404198:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
  40419c:	35f000ef          	jal	404cfa <fork>
  4041a0:	892a                	mv	s2,a0
    if(pid < 0){
  4041a2:	f80543e3          	bltz	a0,404128 <concreate+0x19c>
    if(((i % 3) == 0 && pid == 0) ||
  4041a6:	03448733          	mul	a4,s1,s4
  4041aa:	9301                	srli	a4,a4,0x20
  4041ac:	41f4d79b          	sraiw	a5,s1,0x1f
  4041b0:	9f1d                	subw	a4,a4,a5
  4041b2:	0017179b          	slliw	a5,a4,0x1
  4041b6:	9fb9                	addw	a5,a5,a4
  4041b8:	40f487bb          	subw	a5,s1,a5
  4041bc:	873e                	mv	a4,a5
  4041be:	8fc9                	or	a5,a5,a0
  4041c0:	2781                	sext.w	a5,a5
  4041c2:	dfad                	beqz	a5,40413c <concreate+0x1b0>
  4041c4:	01671363          	bne	a4,s6,4041ca <concreate+0x23e>
       ((i % 3) == 1 && pid != 0)){
  4041c8:	f935                	bnez	a0,40413c <concreate+0x1b0>
      unlink(file);
  4041ca:	854e                	mv	a0,s3
  4041cc:	387000ef          	jal	404d52 <unlink>
      unlink(file);
  4041d0:	854e                	mv	a0,s3
  4041d2:	381000ef          	jal	404d52 <unlink>
      unlink(file);
  4041d6:	854e                	mv	a0,s3
  4041d8:	37b000ef          	jal	404d52 <unlink>
      unlink(file);
  4041dc:	854e                	mv	a0,s3
  4041de:	375000ef          	jal	404d52 <unlink>
      unlink(file);
  4041e2:	854e                	mv	a0,s3
  4041e4:	36f000ef          	jal	404d52 <unlink>
      unlink(file);
  4041e8:	854e                	mv	a0,s3
  4041ea:	369000ef          	jal	404d52 <unlink>
  4041ee:	bf59                	j	404184 <concreate+0x1f8>
      exit(0);
  4041f0:	4501                	li	a0,0
  4041f2:	311000ef          	jal	404d02 <exit>
      close(fd);
  4041f6:	335000ef          	jal	404d2a <close>
    if(pid == 0) {
  4041fa:	b599                	j	404040 <concreate+0xb4>
      close(fd);
  4041fc:	32f000ef          	jal	404d2a <close>
      wait(&xstatus);
  404200:	8556                	mv	a0,s5
  404202:	309000ef          	jal	404d0a <wait>
      if(xstatus != 0)
  404206:	f5c42483          	lw	s1,-164(s0)
  40420a:	e2049ee3          	bnez	s1,404046 <concreate+0xba>
  for(i = 0; i < N; i++){
  40420e:	2905                	addiw	s2,s2,1
  404210:	e3490ee3          	beq	s2,s4,40404c <concreate+0xc0>
    file[1] = '0' + i;
  404214:	0309079b          	addiw	a5,s2,48
  404218:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
  40421c:	854e                	mv	a0,s3
  40421e:	335000ef          	jal	404d52 <unlink>
    pid = fork();
  404222:	2d9000ef          	jal	404cfa <fork>
    if(pid && (i % 3) == 1){
  404226:	dc0500e3          	beqz	a0,403fe6 <concreate+0x5a>
  40422a:	036907b3          	mul	a5,s2,s6
  40422e:	9381                	srli	a5,a5,0x20
  404230:	41f9571b          	sraiw	a4,s2,0x1f
  404234:	9f99                	subw	a5,a5,a4
  404236:	0017971b          	slliw	a4,a5,0x1
  40423a:	9fb9                	addw	a5,a5,a4
  40423c:	40f907bb          	subw	a5,s2,a5
  404240:	d9878ee3          	beq	a5,s8,403fdc <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
  404244:	85e6                	mv	a1,s9
  404246:	854e                	mv	a0,s3
  404248:	2fb000ef          	jal	404d42 <open>
      if(fd < 0){
  40424c:	fa0558e3          	bgez	a0,4041fc <concreate+0x270>
  404250:	b3e9                	j	40401a <concreate+0x8e>
}
  404252:	70aa                	ld	ra,168(sp)
  404254:	740a                	ld	s0,160(sp)
  404256:	64ea                	ld	s1,152(sp)
  404258:	694a                	ld	s2,144(sp)
  40425a:	69aa                	ld	s3,136(sp)
  40425c:	6a0a                	ld	s4,128(sp)
  40425e:	7ae6                	ld	s5,120(sp)
  404260:	7b46                	ld	s6,112(sp)
  404262:	7ba6                	ld	s7,104(sp)
  404264:	7c06                	ld	s8,96(sp)
  404266:	6ce6                	ld	s9,88(sp)
  404268:	6d46                	ld	s10,80(sp)
  40426a:	614d                	addi	sp,sp,176
  40426c:	8082                	ret

000000000040426e <bigfile>:
{
  40426e:	7139                	addi	sp,sp,-64
  404270:	fc06                	sd	ra,56(sp)
  404272:	f822                	sd	s0,48(sp)
  404274:	f426                	sd	s1,40(sp)
  404276:	f04a                	sd	s2,32(sp)
  404278:	ec4e                	sd	s3,24(sp)
  40427a:	e852                	sd	s4,16(sp)
  40427c:	e456                	sd	s5,8(sp)
  40427e:	e05a                	sd	s6,0(sp)
  404280:	0080                	addi	s0,sp,64
  404282:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
  404284:	00003517          	auipc	a0,0x3
  404288:	d7c50513          	addi	a0,a0,-644 # 407000 <malloc+0x1e28>
  40428c:	2c7000ef          	jal	404d52 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
  404290:	20200593          	li	a1,514
  404294:	00003517          	auipc	a0,0x3
  404298:	d6c50513          	addi	a0,a0,-660 # 407000 <malloc+0x1e28>
  40429c:	2a7000ef          	jal	404d42 <open>
  if(fd < 0){
  4042a0:	08054a63          	bltz	a0,404334 <bigfile+0xc6>
  4042a4:	8a2a                	mv	s4,a0
  4042a6:	4481                	li	s1,0
    memset(buf, i, SZ);
  4042a8:	25800913          	li	s2,600
  4042ac:	00009997          	auipc	s3,0x9
  4042b0:	9cc98993          	addi	s3,s3,-1588 # 40cc78 <buf>
  for(i = 0; i < N; i++){
  4042b4:	4ad1                	li	s5,20
    memset(buf, i, SZ);
  4042b6:	864a                	mv	a2,s2
  4042b8:	85a6                	mv	a1,s1
  4042ba:	854e                	mv	a0,s3
  4042bc:	039000ef          	jal	404af4 <memset>
    if(write(fd, buf, SZ) != SZ){
  4042c0:	864a                	mv	a2,s2
  4042c2:	85ce                	mv	a1,s3
  4042c4:	8552                	mv	a0,s4
  4042c6:	25d000ef          	jal	404d22 <write>
  4042ca:	07251f63          	bne	a0,s2,404348 <bigfile+0xda>
  for(i = 0; i < N; i++){
  4042ce:	2485                	addiw	s1,s1,1
  4042d0:	ff5493e3          	bne	s1,s5,4042b6 <bigfile+0x48>
  close(fd);
  4042d4:	8552                	mv	a0,s4
  4042d6:	255000ef          	jal	404d2a <close>
  fd = open("bigfile.dat", 0);
  4042da:	4581                	li	a1,0
  4042dc:	00003517          	auipc	a0,0x3
  4042e0:	d2450513          	addi	a0,a0,-732 # 407000 <malloc+0x1e28>
  4042e4:	25f000ef          	jal	404d42 <open>
  4042e8:	8aaa                	mv	s5,a0
  total = 0;
  4042ea:	4a01                	li	s4,0
  for(i = 0; ; i++){
  4042ec:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
  4042ee:	12c00993          	li	s3,300
  4042f2:	00009917          	auipc	s2,0x9
  4042f6:	98690913          	addi	s2,s2,-1658 # 40cc78 <buf>
  if(fd < 0){
  4042fa:	06054163          	bltz	a0,40435c <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
  4042fe:	864e                	mv	a2,s3
  404300:	85ca                	mv	a1,s2
  404302:	8556                	mv	a0,s5
  404304:	217000ef          	jal	404d1a <read>
    if(cc < 0){
  404308:	06054463          	bltz	a0,404370 <bigfile+0x102>
    if(cc == 0)
  40430c:	c145                	beqz	a0,4043ac <bigfile+0x13e>
    if(cc != SZ/2){
  40430e:	07351b63          	bne	a0,s3,404384 <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
  404312:	01f4d79b          	srliw	a5,s1,0x1f
  404316:	9fa5                	addw	a5,a5,s1
  404318:	4017d79b          	sraiw	a5,a5,0x1
  40431c:	00094703          	lbu	a4,0(s2)
  404320:	06f71c63          	bne	a4,a5,404398 <bigfile+0x12a>
  404324:	12b94703          	lbu	a4,299(s2)
  404328:	06f71863          	bne	a4,a5,404398 <bigfile+0x12a>
    total += cc;
  40432c:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
  404330:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
  404332:	b7f1                	j	4042fe <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
  404334:	85da                	mv	a1,s6
  404336:	00003517          	auipc	a0,0x3
  40433a:	cda50513          	addi	a0,a0,-806 # 407010 <malloc+0x1e38>
  40433e:	5e1000ef          	jal	40511e <printf>
    exit(1);
  404342:	4505                	li	a0,1
  404344:	1bf000ef          	jal	404d02 <exit>
      printf("%s: write bigfile failed\n", s);
  404348:	85da                	mv	a1,s6
  40434a:	00003517          	auipc	a0,0x3
  40434e:	ce650513          	addi	a0,a0,-794 # 407030 <malloc+0x1e58>
  404352:	5cd000ef          	jal	40511e <printf>
      exit(1);
  404356:	4505                	li	a0,1
  404358:	1ab000ef          	jal	404d02 <exit>
    printf("%s: cannot open bigfile\n", s);
  40435c:	85da                	mv	a1,s6
  40435e:	00003517          	auipc	a0,0x3
  404362:	cf250513          	addi	a0,a0,-782 # 407050 <malloc+0x1e78>
  404366:	5b9000ef          	jal	40511e <printf>
    exit(1);
  40436a:	4505                	li	a0,1
  40436c:	197000ef          	jal	404d02 <exit>
      printf("%s: read bigfile failed\n", s);
  404370:	85da                	mv	a1,s6
  404372:	00003517          	auipc	a0,0x3
  404376:	cfe50513          	addi	a0,a0,-770 # 407070 <malloc+0x1e98>
  40437a:	5a5000ef          	jal	40511e <printf>
      exit(1);
  40437e:	4505                	li	a0,1
  404380:	183000ef          	jal	404d02 <exit>
      printf("%s: short read bigfile\n", s);
  404384:	85da                	mv	a1,s6
  404386:	00003517          	auipc	a0,0x3
  40438a:	d0a50513          	addi	a0,a0,-758 # 407090 <malloc+0x1eb8>
  40438e:	591000ef          	jal	40511e <printf>
      exit(1);
  404392:	4505                	li	a0,1
  404394:	16f000ef          	jal	404d02 <exit>
      printf("%s: read bigfile wrong data\n", s);
  404398:	85da                	mv	a1,s6
  40439a:	00003517          	auipc	a0,0x3
  40439e:	d0e50513          	addi	a0,a0,-754 # 4070a8 <malloc+0x1ed0>
  4043a2:	57d000ef          	jal	40511e <printf>
      exit(1);
  4043a6:	4505                	li	a0,1
  4043a8:	15b000ef          	jal	404d02 <exit>
  close(fd);
  4043ac:	8556                	mv	a0,s5
  4043ae:	17d000ef          	jal	404d2a <close>
  if(total != N*SZ){
  4043b2:	678d                	lui	a5,0x3
  4043b4:	ee078793          	addi	a5,a5,-288 # 2ee0 <copyinstr1-0x3fd120>
  4043b8:	02fa1263          	bne	s4,a5,4043dc <bigfile+0x16e>
  unlink("bigfile.dat");
  4043bc:	00003517          	auipc	a0,0x3
  4043c0:	c4450513          	addi	a0,a0,-956 # 407000 <malloc+0x1e28>
  4043c4:	18f000ef          	jal	404d52 <unlink>
}
  4043c8:	70e2                	ld	ra,56(sp)
  4043ca:	7442                	ld	s0,48(sp)
  4043cc:	74a2                	ld	s1,40(sp)
  4043ce:	7902                	ld	s2,32(sp)
  4043d0:	69e2                	ld	s3,24(sp)
  4043d2:	6a42                	ld	s4,16(sp)
  4043d4:	6aa2                	ld	s5,8(sp)
  4043d6:	6b02                	ld	s6,0(sp)
  4043d8:	6121                	addi	sp,sp,64
  4043da:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
  4043dc:	85da                	mv	a1,s6
  4043de:	00003517          	auipc	a0,0x3
  4043e2:	cea50513          	addi	a0,a0,-790 # 4070c8 <malloc+0x1ef0>
  4043e6:	539000ef          	jal	40511e <printf>
    exit(1);
  4043ea:	4505                	li	a0,1
  4043ec:	117000ef          	jal	404d02 <exit>

00000000004043f0 <bigargtest>:
{
  4043f0:	7121                	addi	sp,sp,-448
  4043f2:	ff06                	sd	ra,440(sp)
  4043f4:	fb22                	sd	s0,432(sp)
  4043f6:	f726                	sd	s1,424(sp)
  4043f8:	0380                	addi	s0,sp,448
  4043fa:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
  4043fc:	00003517          	auipc	a0,0x3
  404400:	cec50513          	addi	a0,a0,-788 # 4070e8 <malloc+0x1f10>
  404404:	14f000ef          	jal	404d52 <unlink>
  pid = fork();
  404408:	0f3000ef          	jal	404cfa <fork>
  if(pid == 0){
  40440c:	c915                	beqz	a0,404440 <bigargtest+0x50>
  } else if(pid < 0){
  40440e:	08054a63          	bltz	a0,4044a2 <bigargtest+0xb2>
  wait(&xstatus);
  404412:	fdc40513          	addi	a0,s0,-36
  404416:	0f5000ef          	jal	404d0a <wait>
  if(xstatus != 0)
  40441a:	fdc42503          	lw	a0,-36(s0)
  40441e:	ed41                	bnez	a0,4044b6 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
  404420:	4581                	li	a1,0
  404422:	00003517          	auipc	a0,0x3
  404426:	cc650513          	addi	a0,a0,-826 # 4070e8 <malloc+0x1f10>
  40442a:	119000ef          	jal	404d42 <open>
  if(fd < 0){
  40442e:	08054663          	bltz	a0,4044ba <bigargtest+0xca>
  close(fd);
  404432:	0f9000ef          	jal	404d2a <close>
}
  404436:	70fa                	ld	ra,440(sp)
  404438:	745a                	ld	s0,432(sp)
  40443a:	74ba                	ld	s1,424(sp)
  40443c:	6139                	addi	sp,sp,448
  40443e:	8082                	ret
    memset(big, ' ', sizeof(big));
  404440:	19000613          	li	a2,400
  404444:	02000593          	li	a1,32
  404448:	e4840513          	addi	a0,s0,-440
  40444c:	6a8000ef          	jal	404af4 <memset>
    big[sizeof(big)-1] = '\0';
  404450:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
  404454:	00005797          	auipc	a5,0x5
  404458:	00c78793          	addi	a5,a5,12 # 409460 <args.1>
  40445c:	00005697          	auipc	a3,0x5
  404460:	0fc68693          	addi	a3,a3,252 # 409558 <args.1+0xf8>
      args[i] = big;
  404464:	e4840713          	addi	a4,s0,-440
  404468:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
  40446a:	07a1                	addi	a5,a5,8
  40446c:	fed79ee3          	bne	a5,a3,404468 <bigargtest+0x78>
    args[MAXARG-1] = 0;
  404470:	00005597          	auipc	a1,0x5
  404474:	ff058593          	addi	a1,a1,-16 # 409460 <args.1>
  404478:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
  40447c:	00001517          	auipc	a0,0x1
  404480:	e8c50513          	addi	a0,a0,-372 # 405308 <malloc+0x130>
  404484:	0b7000ef          	jal	404d3a <exec>
    fd = open("bigarg-ok", O_CREATE);
  404488:	20000593          	li	a1,512
  40448c:	00003517          	auipc	a0,0x3
  404490:	c5c50513          	addi	a0,a0,-932 # 4070e8 <malloc+0x1f10>
  404494:	0af000ef          	jal	404d42 <open>
    close(fd);
  404498:	093000ef          	jal	404d2a <close>
    exit(0);
  40449c:	4501                	li	a0,0
  40449e:	065000ef          	jal	404d02 <exit>
    printf("%s: bigargtest: fork failed\n", s);
  4044a2:	85a6                	mv	a1,s1
  4044a4:	00003517          	auipc	a0,0x3
  4044a8:	c5450513          	addi	a0,a0,-940 # 4070f8 <malloc+0x1f20>
  4044ac:	473000ef          	jal	40511e <printf>
    exit(1);
  4044b0:	4505                	li	a0,1
  4044b2:	051000ef          	jal	404d02 <exit>
    exit(xstatus);
  4044b6:	04d000ef          	jal	404d02 <exit>
    printf("%s: bigarg test failed!\n", s);
  4044ba:	85a6                	mv	a1,s1
  4044bc:	00003517          	auipc	a0,0x3
  4044c0:	c5c50513          	addi	a0,a0,-932 # 407118 <malloc+0x1f40>
  4044c4:	45b000ef          	jal	40511e <printf>
    exit(1);
  4044c8:	4505                	li	a0,1
  4044ca:	039000ef          	jal	404d02 <exit>

00000000004044ce <fsfull>:
{
  4044ce:	7171                	addi	sp,sp,-176
  4044d0:	f506                	sd	ra,168(sp)
  4044d2:	f122                	sd	s0,160(sp)
  4044d4:	ed26                	sd	s1,152(sp)
  4044d6:	e94a                	sd	s2,144(sp)
  4044d8:	e54e                	sd	s3,136(sp)
  4044da:	e152                	sd	s4,128(sp)
  4044dc:	fcd6                	sd	s5,120(sp)
  4044de:	f8da                	sd	s6,112(sp)
  4044e0:	f4de                	sd	s7,104(sp)
  4044e2:	f0e2                	sd	s8,96(sp)
  4044e4:	ece6                	sd	s9,88(sp)
  4044e6:	e8ea                	sd	s10,80(sp)
  4044e8:	e4ee                	sd	s11,72(sp)
  4044ea:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
  4044ec:	00003517          	auipc	a0,0x3
  4044f0:	c4c50513          	addi	a0,a0,-948 # 407138 <malloc+0x1f60>
  4044f4:	42b000ef          	jal	40511e <printf>
  for(nfiles = 0; ; nfiles++){
  4044f8:	4481                	li	s1,0
    name[0] = 'f';
  4044fa:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
  4044fe:	10625cb7          	lui	s9,0x10625
  404502:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1021515b>
    name[2] = '0' + (nfiles % 1000) / 100;
  404506:	51eb8ab7          	lui	s5,0x51eb8
  40450a:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51aa88a7>
    name[3] = '0' + (nfiles % 100) / 10;
  40450e:	66666a37          	lui	s4,0x66666
  404512:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x662569ef>
    printf("writing %s\n", name);
  404516:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
  40451a:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
  40451e:	039487b3          	mul	a5,s1,s9
  404522:	9799                	srai	a5,a5,0x26
  404524:	41f4d69b          	sraiw	a3,s1,0x1f
  404528:	9f95                	subw	a5,a5,a3
  40452a:	0307871b          	addiw	a4,a5,48
  40452e:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
  404532:	3e800713          	li	a4,1000
  404536:	02f707bb          	mulw	a5,a4,a5
  40453a:	40f487bb          	subw	a5,s1,a5
  40453e:	03578733          	mul	a4,a5,s5
  404542:	9715                	srai	a4,a4,0x25
  404544:	41f7d79b          	sraiw	a5,a5,0x1f
  404548:	40f707bb          	subw	a5,a4,a5
  40454c:	0307879b          	addiw	a5,a5,48
  404550:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
  404554:	035487b3          	mul	a5,s1,s5
  404558:	9795                	srai	a5,a5,0x25
  40455a:	9f95                	subw	a5,a5,a3
  40455c:	06400713          	li	a4,100
  404560:	02f707bb          	mulw	a5,a4,a5
  404564:	40f487bb          	subw	a5,s1,a5
  404568:	03478733          	mul	a4,a5,s4
  40456c:	9709                	srai	a4,a4,0x22
  40456e:	41f7d79b          	sraiw	a5,a5,0x1f
  404572:	40f707bb          	subw	a5,a4,a5
  404576:	0307879b          	addiw	a5,a5,48
  40457a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
  40457e:	03448733          	mul	a4,s1,s4
  404582:	9709                	srai	a4,a4,0x22
  404584:	9f15                	subw	a4,a4,a3
  404586:	0027179b          	slliw	a5,a4,0x2
  40458a:	9fb9                	addw	a5,a5,a4
  40458c:	0017979b          	slliw	a5,a5,0x1
  404590:	40f487bb          	subw	a5,s1,a5
  404594:	0307879b          	addiw	a5,a5,48
  404598:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
  40459c:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
  4045a0:	85ea                	mv	a1,s10
  4045a2:	00003517          	auipc	a0,0x3
  4045a6:	ba650513          	addi	a0,a0,-1114 # 407148 <malloc+0x1f70>
  4045aa:	375000ef          	jal	40511e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
  4045ae:	20200593          	li	a1,514
  4045b2:	856a                	mv	a0,s10
  4045b4:	78e000ef          	jal	404d42 <open>
  4045b8:	892a                	mv	s2,a0
    if(fd < 0){
  4045ba:	0e055863          	bgez	a0,4046aa <fsfull+0x1dc>
      printf("open %s failed\n", name);
  4045be:	f5040593          	addi	a1,s0,-176
  4045c2:	00003517          	auipc	a0,0x3
  4045c6:	b9650513          	addi	a0,a0,-1130 # 407158 <malloc+0x1f80>
  4045ca:	355000ef          	jal	40511e <printf>
    name[0] = 'f';
  4045ce:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
  4045d2:	10625a37          	lui	s4,0x10625
  4045d6:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1021515b>
    name[2] = '0' + (nfiles % 1000) / 100;
  4045da:	3e800b93          	li	s7,1000
  4045de:	51eb89b7          	lui	s3,0x51eb8
  4045e2:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51aa88a7>
    name[3] = '0' + (nfiles % 100) / 10;
  4045e6:	06400b13          	li	s6,100
  4045ea:	66666937          	lui	s2,0x66666
  4045ee:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x662569ef>
    unlink(name);
  4045f2:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
  4045f6:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
  4045fa:	034487b3          	mul	a5,s1,s4
  4045fe:	9799                	srai	a5,a5,0x26
  404600:	41f4d69b          	sraiw	a3,s1,0x1f
  404604:	9f95                	subw	a5,a5,a3
  404606:	0307871b          	addiw	a4,a5,48
  40460a:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
  40460e:	02fb87bb          	mulw	a5,s7,a5
  404612:	40f487bb          	subw	a5,s1,a5
  404616:	03378733          	mul	a4,a5,s3
  40461a:	9715                	srai	a4,a4,0x25
  40461c:	41f7d79b          	sraiw	a5,a5,0x1f
  404620:	40f707bb          	subw	a5,a4,a5
  404624:	0307879b          	addiw	a5,a5,48
  404628:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
  40462c:	033487b3          	mul	a5,s1,s3
  404630:	9795                	srai	a5,a5,0x25
  404632:	9f95                	subw	a5,a5,a3
  404634:	02fb07bb          	mulw	a5,s6,a5
  404638:	40f487bb          	subw	a5,s1,a5
  40463c:	03278733          	mul	a4,a5,s2
  404640:	9709                	srai	a4,a4,0x22
  404642:	41f7d79b          	sraiw	a5,a5,0x1f
  404646:	40f707bb          	subw	a5,a4,a5
  40464a:	0307879b          	addiw	a5,a5,48
  40464e:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
  404652:	03248733          	mul	a4,s1,s2
  404656:	9709                	srai	a4,a4,0x22
  404658:	9f15                	subw	a4,a4,a3
  40465a:	0027179b          	slliw	a5,a4,0x2
  40465e:	9fb9                	addw	a5,a5,a4
  404660:	0017979b          	slliw	a5,a5,0x1
  404664:	40f487bb          	subw	a5,s1,a5
  404668:	0307879b          	addiw	a5,a5,48
  40466c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
  404670:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
  404674:	8556                	mv	a0,s5
  404676:	6dc000ef          	jal	404d52 <unlink>
    nfiles--;
  40467a:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
  40467c:	f604dde3          	bgez	s1,4045f6 <fsfull+0x128>
  printf("fsfull test finished\n");
  404680:	00003517          	auipc	a0,0x3
  404684:	af850513          	addi	a0,a0,-1288 # 407178 <malloc+0x1fa0>
  404688:	297000ef          	jal	40511e <printf>
}
  40468c:	70aa                	ld	ra,168(sp)
  40468e:	740a                	ld	s0,160(sp)
  404690:	64ea                	ld	s1,152(sp)
  404692:	694a                	ld	s2,144(sp)
  404694:	69aa                	ld	s3,136(sp)
  404696:	6a0a                	ld	s4,128(sp)
  404698:	7ae6                	ld	s5,120(sp)
  40469a:	7b46                	ld	s6,112(sp)
  40469c:	7ba6                	ld	s7,104(sp)
  40469e:	7c06                	ld	s8,96(sp)
  4046a0:	6ce6                	ld	s9,88(sp)
  4046a2:	6d46                	ld	s10,80(sp)
  4046a4:	6da6                	ld	s11,72(sp)
  4046a6:	614d                	addi	sp,sp,176
  4046a8:	8082                	ret
    int total = 0;
  4046aa:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
  4046ac:	40000c13          	li	s8,1024
  4046b0:	00008b97          	auipc	s7,0x8
  4046b4:	5c8b8b93          	addi	s7,s7,1480 # 40cc78 <buf>
      if(cc < BSIZE)
  4046b8:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
  4046bc:	8662                	mv	a2,s8
  4046be:	85de                	mv	a1,s7
  4046c0:	854a                	mv	a0,s2
  4046c2:	660000ef          	jal	404d22 <write>
      if(cc < BSIZE)
  4046c6:	00ab5563          	bge	s6,a0,4046d0 <fsfull+0x202>
      total += cc;
  4046ca:	00a989bb          	addw	s3,s3,a0
    while(1){
  4046ce:	b7fd                	j	4046bc <fsfull+0x1ee>
    printf("wrote %d bytes\n", total);
  4046d0:	85ce                	mv	a1,s3
  4046d2:	00003517          	auipc	a0,0x3
  4046d6:	a9650513          	addi	a0,a0,-1386 # 407168 <malloc+0x1f90>
  4046da:	245000ef          	jal	40511e <printf>
    close(fd);
  4046de:	854a                	mv	a0,s2
  4046e0:	64a000ef          	jal	404d2a <close>
    if(total == 0)
  4046e4:	ee0985e3          	beqz	s3,4045ce <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
  4046e8:	2485                	addiw	s1,s1,1
  4046ea:	bd05                	j	40451a <fsfull+0x4c>

00000000004046ec <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
  4046ec:	7179                	addi	sp,sp,-48
  4046ee:	f406                	sd	ra,40(sp)
  4046f0:	f022                	sd	s0,32(sp)
  4046f2:	ec26                	sd	s1,24(sp)
  4046f4:	e84a                	sd	s2,16(sp)
  4046f6:	1800                	addi	s0,sp,48
  4046f8:	84aa                	mv	s1,a0
  4046fa:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
  4046fc:	00003517          	auipc	a0,0x3
  404700:	a9450513          	addi	a0,a0,-1388 # 407190 <malloc+0x1fb8>
  404704:	21b000ef          	jal	40511e <printf>
  if((pid = fork()) < 0) {
  404708:	5f2000ef          	jal	404cfa <fork>
  40470c:	02054a63          	bltz	a0,404740 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
  404710:	c129                	beqz	a0,404752 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
  404712:	fdc40513          	addi	a0,s0,-36
  404716:	5f4000ef          	jal	404d0a <wait>
    if(xstatus != 0) 
  40471a:	fdc42783          	lw	a5,-36(s0)
  40471e:	cf9d                	beqz	a5,40475c <run+0x70>
      printf("FAILED\n");
  404720:	00003517          	auipc	a0,0x3
  404724:	a9850513          	addi	a0,a0,-1384 # 4071b8 <malloc+0x1fe0>
  404728:	1f7000ef          	jal	40511e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
  40472c:	fdc42503          	lw	a0,-36(s0)
  }
}
  404730:	00153513          	seqz	a0,a0
  404734:	70a2                	ld	ra,40(sp)
  404736:	7402                	ld	s0,32(sp)
  404738:	64e2                	ld	s1,24(sp)
  40473a:	6942                	ld	s2,16(sp)
  40473c:	6145                	addi	sp,sp,48
  40473e:	8082                	ret
    printf("runtest: fork error\n");
  404740:	00003517          	auipc	a0,0x3
  404744:	a6050513          	addi	a0,a0,-1440 # 4071a0 <malloc+0x1fc8>
  404748:	1d7000ef          	jal	40511e <printf>
    exit(1);
  40474c:	4505                	li	a0,1
  40474e:	5b4000ef          	jal	404d02 <exit>
    f(s);
  404752:	854a                	mv	a0,s2
  404754:	9482                	jalr	s1
    exit(0);
  404756:	4501                	li	a0,0
  404758:	5aa000ef          	jal	404d02 <exit>
      printf("OK\n");
  40475c:	00003517          	auipc	a0,0x3
  404760:	a6450513          	addi	a0,a0,-1436 # 4071c0 <malloc+0x1fe8>
  404764:	1bb000ef          	jal	40511e <printf>
  404768:	b7d1                	j	40472c <run+0x40>

000000000040476a <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
  40476a:	7139                	addi	sp,sp,-64
  40476c:	fc06                	sd	ra,56(sp)
  40476e:	f822                	sd	s0,48(sp)
  404770:	f04a                	sd	s2,32(sp)
  404772:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
  404774:	00853903          	ld	s2,8(a0)
  404778:	06090463          	beqz	s2,4047e0 <runtests+0x76>
  40477c:	f426                	sd	s1,40(sp)
  40477e:	ec4e                	sd	s3,24(sp)
  404780:	e852                	sd	s4,16(sp)
  404782:	e456                	sd	s5,8(sp)
  404784:	84aa                	mv	s1,a0
  404786:	89ae                	mv	s3,a1
  404788:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
  40478a:	4a89                	li	s5,2
  40478c:	a031                	j	404798 <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
  40478e:	04c1                	addi	s1,s1,16
  404790:	0084b903          	ld	s2,8(s1)
  404794:	02090c63          	beqz	s2,4047cc <runtests+0x62>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
  404798:	00098763          	beqz	s3,4047a6 <runtests+0x3c>
  40479c:	85ce                	mv	a1,s3
  40479e:	854a                	mv	a0,s2
  4047a0:	2f6000ef          	jal	404a96 <strcmp>
  4047a4:	f56d                	bnez	a0,40478e <runtests+0x24>
      if(!run(t->f, t->s)){
  4047a6:	85ca                	mv	a1,s2
  4047a8:	6088                	ld	a0,0(s1)
  4047aa:	f43ff0ef          	jal	4046ec <run>
  4047ae:	f165                	bnez	a0,40478e <runtests+0x24>
        if(continuous != 2){
  4047b0:	fd5a0fe3          	beq	s4,s5,40478e <runtests+0x24>
          printf("SOME TESTS FAILED\n");
  4047b4:	00003517          	auipc	a0,0x3
  4047b8:	a1450513          	addi	a0,a0,-1516 # 4071c8 <malloc+0x1ff0>
  4047bc:	163000ef          	jal	40511e <printf>
          return 1;
  4047c0:	4505                	li	a0,1
  4047c2:	74a2                	ld	s1,40(sp)
  4047c4:	69e2                	ld	s3,24(sp)
  4047c6:	6a42                	ld	s4,16(sp)
  4047c8:	6aa2                	ld	s5,8(sp)
  4047ca:	a031                	j	4047d6 <runtests+0x6c>
        }
      }
    }
  }
  return 0;
  4047cc:	4501                	li	a0,0
  4047ce:	74a2                	ld	s1,40(sp)
  4047d0:	69e2                	ld	s3,24(sp)
  4047d2:	6a42                	ld	s4,16(sp)
  4047d4:	6aa2                	ld	s5,8(sp)
}
  4047d6:	70e2                	ld	ra,56(sp)
  4047d8:	7442                	ld	s0,48(sp)
  4047da:	7902                	ld	s2,32(sp)
  4047dc:	6121                	addi	sp,sp,64
  4047de:	8082                	ret
  return 0;
  4047e0:	4501                	li	a0,0
  4047e2:	bfd5                	j	4047d6 <runtests+0x6c>

00000000004047e4 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
  4047e4:	7139                	addi	sp,sp,-64
  4047e6:	fc06                	sd	ra,56(sp)
  4047e8:	f822                	sd	s0,48(sp)
  4047ea:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
  4047ec:	fc840513          	addi	a0,s0,-56
  4047f0:	522000ef          	jal	404d12 <pipe>
  4047f4:	04054f63          	bltz	a0,404852 <countfree+0x6e>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
  4047f8:	502000ef          	jal	404cfa <fork>

  if(pid < 0){
  4047fc:	06054863          	bltz	a0,40486c <countfree+0x88>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
  404800:	e551                	bnez	a0,40488c <countfree+0xa8>
  404802:	f426                	sd	s1,40(sp)
  404804:	f04a                	sd	s2,32(sp)
  404806:	ec4e                	sd	s3,24(sp)
  404808:	e852                	sd	s4,16(sp)
    close(fds[0]);
  40480a:	fc842503          	lw	a0,-56(s0)
  40480e:	51c000ef          	jal	404d2a <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
  404812:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
  404814:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
  404816:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
  404818:	00001a17          	auipc	s4,0x1
  40481c:	b60a0a13          	addi	s4,s4,-1184 # 405378 <malloc+0x1a0>
      uint64 a = (uint64) sbrk(4096);
  404820:	854a                	mv	a0,s2
  404822:	568000ef          	jal	404d8a <sbrk>
      if(a == 0xffffffffffffffff){
  404826:	07350063          	beq	a0,s3,404886 <countfree+0xa2>
      *(char *)(a + 4096 - 1) = 1;
  40482a:	954a                	add	a0,a0,s2
  40482c:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
  404830:	8626                	mv	a2,s1
  404832:	85d2                	mv	a1,s4
  404834:	fcc42503          	lw	a0,-52(s0)
  404838:	4ea000ef          	jal	404d22 <write>
  40483c:	fe9502e3          	beq	a0,s1,404820 <countfree+0x3c>
        printf("write() failed in countfree()\n");
  404840:	00003517          	auipc	a0,0x3
  404844:	9e050513          	addi	a0,a0,-1568 # 407220 <malloc+0x2048>
  404848:	0d7000ef          	jal	40511e <printf>
        exit(1);
  40484c:	4505                	li	a0,1
  40484e:	4b4000ef          	jal	404d02 <exit>
  404852:	f426                	sd	s1,40(sp)
  404854:	f04a                	sd	s2,32(sp)
  404856:	ec4e                	sd	s3,24(sp)
  404858:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
  40485a:	00003517          	auipc	a0,0x3
  40485e:	98650513          	addi	a0,a0,-1658 # 4071e0 <malloc+0x2008>
  404862:	0bd000ef          	jal	40511e <printf>
    exit(1);
  404866:	4505                	li	a0,1
  404868:	49a000ef          	jal	404d02 <exit>
  40486c:	f426                	sd	s1,40(sp)
  40486e:	f04a                	sd	s2,32(sp)
  404870:	ec4e                	sd	s3,24(sp)
  404872:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
  404874:	00003517          	auipc	a0,0x3
  404878:	98c50513          	addi	a0,a0,-1652 # 407200 <malloc+0x2028>
  40487c:	0a3000ef          	jal	40511e <printf>
    exit(1);
  404880:	4505                	li	a0,1
  404882:	480000ef          	jal	404d02 <exit>
      }
    }

    exit(0);
  404886:	4501                	li	a0,0
  404888:	47a000ef          	jal	404d02 <exit>
  40488c:	f426                	sd	s1,40(sp)
  40488e:	f04a                	sd	s2,32(sp)
  404890:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
  404892:	fcc42503          	lw	a0,-52(s0)
  404896:	494000ef          	jal	404d2a <close>

  int n = 0;
  40489a:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
  40489c:	fc740993          	addi	s3,s0,-57
  4048a0:	4905                	li	s2,1
  4048a2:	864a                	mv	a2,s2
  4048a4:	85ce                	mv	a1,s3
  4048a6:	fc842503          	lw	a0,-56(s0)
  4048aa:	470000ef          	jal	404d1a <read>
    if(cc < 0){
  4048ae:	00054563          	bltz	a0,4048b8 <countfree+0xd4>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
  4048b2:	cd09                	beqz	a0,4048cc <countfree+0xe8>
      break;
    n += 1;
  4048b4:	2485                	addiw	s1,s1,1
  while(1){
  4048b6:	b7f5                	j	4048a2 <countfree+0xbe>
  4048b8:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
  4048ba:	00003517          	auipc	a0,0x3
  4048be:	98650513          	addi	a0,a0,-1658 # 407240 <malloc+0x2068>
  4048c2:	05d000ef          	jal	40511e <printf>
      exit(1);
  4048c6:	4505                	li	a0,1
  4048c8:	43a000ef          	jal	404d02 <exit>
  }

  close(fds[0]);
  4048cc:	fc842503          	lw	a0,-56(s0)
  4048d0:	45a000ef          	jal	404d2a <close>
  wait((int*)0);
  4048d4:	4501                	li	a0,0
  4048d6:	434000ef          	jal	404d0a <wait>
  
  return n;
}
  4048da:	8526                	mv	a0,s1
  4048dc:	74a2                	ld	s1,40(sp)
  4048de:	7902                	ld	s2,32(sp)
  4048e0:	69e2                	ld	s3,24(sp)
  4048e2:	70e2                	ld	ra,56(sp)
  4048e4:	7442                	ld	s0,48(sp)
  4048e6:	6121                	addi	sp,sp,64
  4048e8:	8082                	ret

00000000004048ea <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
  4048ea:	711d                	addi	sp,sp,-96
  4048ec:	ec86                	sd	ra,88(sp)
  4048ee:	e8a2                	sd	s0,80(sp)
  4048f0:	e4a6                	sd	s1,72(sp)
  4048f2:	e0ca                	sd	s2,64(sp)
  4048f4:	fc4e                	sd	s3,56(sp)
  4048f6:	f852                	sd	s4,48(sp)
  4048f8:	f456                	sd	s5,40(sp)
  4048fa:	f05a                	sd	s6,32(sp)
  4048fc:	ec5e                	sd	s7,24(sp)
  4048fe:	e862                	sd	s8,16(sp)
  404900:	e466                	sd	s9,8(sp)
  404902:	e06a                	sd	s10,0(sp)
  404904:	1080                	addi	s0,sp,96
  404906:	8aaa                	mv	s5,a0
  404908:	892e                	mv	s2,a1
  40490a:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
  40490c:	00003b97          	auipc	s7,0x3
  404910:	954b8b93          	addi	s7,s7,-1708 # 407260 <malloc+0x2088>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
  404914:	00004b17          	auipc	s6,0x4
  404918:	6fcb0b13          	addi	s6,s6,1788 # 409010 <quicktests>
      if(continuous != 2) {
  40491c:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
  40491e:	00005c17          	auipc	s8,0x5
  404922:	ac2c0c13          	addi	s8,s8,-1342 # 4093e0 <slowtests>
        printf("usertests slow tests starting\n");
  404926:	00003d17          	auipc	s10,0x3
  40492a:	952d0d13          	addi	s10,s10,-1710 # 407278 <malloc+0x20a0>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
  40492e:	00003c97          	auipc	s9,0x3
  404932:	96ac8c93          	addi	s9,s9,-1686 # 407298 <malloc+0x20c0>
  404936:	a819                	j	40494c <drivetests+0x62>
        printf("usertests slow tests starting\n");
  404938:	856a                	mv	a0,s10
  40493a:	7e4000ef          	jal	40511e <printf>
  40493e:	a80d                	j	404970 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
  404940:	ea5ff0ef          	jal	4047e4 <countfree>
  404944:	04954063          	blt	a0,s1,404984 <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
  404948:	04090963          	beqz	s2,40499a <drivetests+0xb0>
    printf("usertests starting\n");
  40494c:	855e                	mv	a0,s7
  40494e:	7d0000ef          	jal	40511e <printf>
    int free0 = countfree();
  404952:	e93ff0ef          	jal	4047e4 <countfree>
  404956:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
  404958:	864a                	mv	a2,s2
  40495a:	85ce                	mv	a1,s3
  40495c:	855a                	mv	a0,s6
  40495e:	e0dff0ef          	jal	40476a <runtests>
  404962:	c119                	beqz	a0,404968 <drivetests+0x7e>
      if(continuous != 2) {
  404964:	03491963          	bne	s2,s4,404996 <drivetests+0xac>
    if(!quick) {
  404968:	fc0a9ce3          	bnez	s5,404940 <drivetests+0x56>
      if (justone == 0)
  40496c:	fc0986e3          	beqz	s3,404938 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
  404970:	864a                	mv	a2,s2
  404972:	85ce                	mv	a1,s3
  404974:	8562                	mv	a0,s8
  404976:	df5ff0ef          	jal	40476a <runtests>
  40497a:	d179                	beqz	a0,404940 <drivetests+0x56>
        if(continuous != 2) {
  40497c:	fd4902e3          	beq	s2,s4,404940 <drivetests+0x56>
          return 1;
  404980:	4505                	li	a0,1
  404982:	a829                	j	40499c <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
  404984:	8626                	mv	a2,s1
  404986:	85aa                	mv	a1,a0
  404988:	8566                	mv	a0,s9
  40498a:	794000ef          	jal	40511e <printf>
      if(continuous != 2) {
  40498e:	fb490fe3          	beq	s2,s4,40494c <drivetests+0x62>
        return 1;
  404992:	4505                	li	a0,1
  404994:	a021                	j	40499c <drivetests+0xb2>
        return 1;
  404996:	4505                	li	a0,1
  404998:	a011                	j	40499c <drivetests+0xb2>
  return 0;
  40499a:	854a                	mv	a0,s2
}
  40499c:	60e6                	ld	ra,88(sp)
  40499e:	6446                	ld	s0,80(sp)
  4049a0:	64a6                	ld	s1,72(sp)
  4049a2:	6906                	ld	s2,64(sp)
  4049a4:	79e2                	ld	s3,56(sp)
  4049a6:	7a42                	ld	s4,48(sp)
  4049a8:	7aa2                	ld	s5,40(sp)
  4049aa:	7b02                	ld	s6,32(sp)
  4049ac:	6be2                	ld	s7,24(sp)
  4049ae:	6c42                	ld	s8,16(sp)
  4049b0:	6ca2                	ld	s9,8(sp)
  4049b2:	6d02                	ld	s10,0(sp)
  4049b4:	6125                	addi	sp,sp,96
  4049b6:	8082                	ret

00000000004049b8 <main>:

int
main(int argc, char *argv[])
{
  4049b8:	1101                	addi	sp,sp,-32
  4049ba:	ec06                	sd	ra,24(sp)
  4049bc:	e822                	sd	s0,16(sp)
  4049be:	e426                	sd	s1,8(sp)
  4049c0:	e04a                	sd	s2,0(sp)
  4049c2:	1000                	addi	s0,sp,32
  4049c4:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
  4049c6:	4789                	li	a5,2
  4049c8:	00f50f63          	beq	a0,a5,4049e6 <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
  4049cc:	4785                	li	a5,1
  4049ce:	06a7c063          	blt	a5,a0,404a2e <main+0x76>
  char *justone = 0;
  4049d2:	4901                	li	s2,0
  int quick = 0;
  4049d4:	4501                	li	a0,0
  int continuous = 0;
  4049d6:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
  4049d8:	864a                	mv	a2,s2
  4049da:	f11ff0ef          	jal	4048ea <drivetests>
  4049de:	c935                	beqz	a0,404a52 <main+0x9a>
    exit(1);
  4049e0:	4505                	li	a0,1
  4049e2:	320000ef          	jal	404d02 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
  4049e6:	0085b903          	ld	s2,8(a1)
  4049ea:	00003597          	auipc	a1,0x3
  4049ee:	8de58593          	addi	a1,a1,-1826 # 4072c8 <malloc+0x20f0>
  4049f2:	854a                	mv	a0,s2
  4049f4:	0a2000ef          	jal	404a96 <strcmp>
  4049f8:	85aa                	mv	a1,a0
  4049fa:	c139                	beqz	a0,404a40 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
  4049fc:	00003597          	auipc	a1,0x3
  404a00:	8d458593          	addi	a1,a1,-1836 # 4072d0 <malloc+0x20f8>
  404a04:	854a                	mv	a0,s2
  404a06:	090000ef          	jal	404a96 <strcmp>
  404a0a:	cd15                	beqz	a0,404a46 <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
  404a0c:	00003597          	auipc	a1,0x3
  404a10:	8cc58593          	addi	a1,a1,-1844 # 4072d8 <malloc+0x2100>
  404a14:	854a                	mv	a0,s2
  404a16:	080000ef          	jal	404a96 <strcmp>
  404a1a:	c90d                	beqz	a0,404a4c <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
  404a1c:	00094703          	lbu	a4,0(s2) # 1000 <copyinstr1-0x3ff000>
  404a20:	02d00793          	li	a5,45
  404a24:	00f70563          	beq	a4,a5,404a2e <main+0x76>
  int quick = 0;
  404a28:	4501                	li	a0,0
  int continuous = 0;
  404a2a:	4581                	li	a1,0
  404a2c:	b775                	j	4049d8 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
  404a2e:	00003517          	auipc	a0,0x3
  404a32:	8b250513          	addi	a0,a0,-1870 # 4072e0 <malloc+0x2108>
  404a36:	6e8000ef          	jal	40511e <printf>
    exit(1);
  404a3a:	4505                	li	a0,1
  404a3c:	2c6000ef          	jal	404d02 <exit>
  char *justone = 0;
  404a40:	4901                	li	s2,0
    quick = 1;
  404a42:	4505                	li	a0,1
  404a44:	bf51                	j	4049d8 <main+0x20>
  char *justone = 0;
  404a46:	4901                	li	s2,0
    continuous = 1;
  404a48:	4585                	li	a1,1
  404a4a:	b779                	j	4049d8 <main+0x20>
    continuous = 2;
  404a4c:	85a6                	mv	a1,s1
  char *justone = 0;
  404a4e:	4901                	li	s2,0
  404a50:	b761                	j	4049d8 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
  404a52:	00003517          	auipc	a0,0x3
  404a56:	8be50513          	addi	a0,a0,-1858 # 407310 <malloc+0x2138>
  404a5a:	6c4000ef          	jal	40511e <printf>
  exit(0);
  404a5e:	4501                	li	a0,0
  404a60:	2a2000ef          	jal	404d02 <exit>

0000000000404a64 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  404a64:	1141                	addi	sp,sp,-16
  404a66:	e406                	sd	ra,8(sp)
  404a68:	e022                	sd	s0,0(sp)
  404a6a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  404a6c:	f4dff0ef          	jal	4049b8 <main>
  exit(0);
  404a70:	4501                	li	a0,0
  404a72:	290000ef          	jal	404d02 <exit>

0000000000404a76 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  404a76:	1141                	addi	sp,sp,-16
  404a78:	e406                	sd	ra,8(sp)
  404a7a:	e022                	sd	s0,0(sp)
  404a7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  404a7e:	87aa                	mv	a5,a0
  404a80:	0585                	addi	a1,a1,1
  404a82:	0785                	addi	a5,a5,1
  404a84:	fff5c703          	lbu	a4,-1(a1)
  404a88:	fee78fa3          	sb	a4,-1(a5)
  404a8c:	fb75                	bnez	a4,404a80 <strcpy+0xa>
    ;
  return os;
}
  404a8e:	60a2                	ld	ra,8(sp)
  404a90:	6402                	ld	s0,0(sp)
  404a92:	0141                	addi	sp,sp,16
  404a94:	8082                	ret

0000000000404a96 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  404a96:	1141                	addi	sp,sp,-16
  404a98:	e406                	sd	ra,8(sp)
  404a9a:	e022                	sd	s0,0(sp)
  404a9c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  404a9e:	00054783          	lbu	a5,0(a0)
  404aa2:	cb91                	beqz	a5,404ab6 <strcmp+0x20>
  404aa4:	0005c703          	lbu	a4,0(a1)
  404aa8:	00f71763          	bne	a4,a5,404ab6 <strcmp+0x20>
    p++, q++;
  404aac:	0505                	addi	a0,a0,1
  404aae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  404ab0:	00054783          	lbu	a5,0(a0)
  404ab4:	fbe5                	bnez	a5,404aa4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  404ab6:	0005c503          	lbu	a0,0(a1)
}
  404aba:	40a7853b          	subw	a0,a5,a0
  404abe:	60a2                	ld	ra,8(sp)
  404ac0:	6402                	ld	s0,0(sp)
  404ac2:	0141                	addi	sp,sp,16
  404ac4:	8082                	ret

0000000000404ac6 <strlen>:

uint
strlen(const char *s)
{
  404ac6:	1141                	addi	sp,sp,-16
  404ac8:	e406                	sd	ra,8(sp)
  404aca:	e022                	sd	s0,0(sp)
  404acc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  404ace:	00054783          	lbu	a5,0(a0)
  404ad2:	cf99                	beqz	a5,404af0 <strlen+0x2a>
  404ad4:	0505                	addi	a0,a0,1
  404ad6:	87aa                	mv	a5,a0
  404ad8:	86be                	mv	a3,a5
  404ada:	0785                	addi	a5,a5,1
  404adc:	fff7c703          	lbu	a4,-1(a5)
  404ae0:	ff65                	bnez	a4,404ad8 <strlen+0x12>
  404ae2:	40a6853b          	subw	a0,a3,a0
  404ae6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  404ae8:	60a2                	ld	ra,8(sp)
  404aea:	6402                	ld	s0,0(sp)
  404aec:	0141                	addi	sp,sp,16
  404aee:	8082                	ret
  for(n = 0; s[n]; n++)
  404af0:	4501                	li	a0,0
  404af2:	bfdd                	j	404ae8 <strlen+0x22>

0000000000404af4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  404af4:	1141                	addi	sp,sp,-16
  404af6:	e406                	sd	ra,8(sp)
  404af8:	e022                	sd	s0,0(sp)
  404afa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  404afc:	ca19                	beqz	a2,404b12 <memset+0x1e>
  404afe:	87aa                	mv	a5,a0
  404b00:	1602                	slli	a2,a2,0x20
  404b02:	9201                	srli	a2,a2,0x20
  404b04:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  404b08:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  404b0c:	0785                	addi	a5,a5,1
  404b0e:	fee79de3          	bne	a5,a4,404b08 <memset+0x14>
  }
  return dst;
}
  404b12:	60a2                	ld	ra,8(sp)
  404b14:	6402                	ld	s0,0(sp)
  404b16:	0141                	addi	sp,sp,16
  404b18:	8082                	ret

0000000000404b1a <strchr>:

char*
strchr(const char *s, char c)
{
  404b1a:	1141                	addi	sp,sp,-16
  404b1c:	e406                	sd	ra,8(sp)
  404b1e:	e022                	sd	s0,0(sp)
  404b20:	0800                	addi	s0,sp,16
  for(; *s; s++)
  404b22:	00054783          	lbu	a5,0(a0)
  404b26:	cf81                	beqz	a5,404b3e <strchr+0x24>
    if(*s == c)
  404b28:	00f58763          	beq	a1,a5,404b36 <strchr+0x1c>
  for(; *s; s++)
  404b2c:	0505                	addi	a0,a0,1
  404b2e:	00054783          	lbu	a5,0(a0)
  404b32:	fbfd                	bnez	a5,404b28 <strchr+0xe>
      return (char*)s;
  return 0;
  404b34:	4501                	li	a0,0
}
  404b36:	60a2                	ld	ra,8(sp)
  404b38:	6402                	ld	s0,0(sp)
  404b3a:	0141                	addi	sp,sp,16
  404b3c:	8082                	ret
  return 0;
  404b3e:	4501                	li	a0,0
  404b40:	bfdd                	j	404b36 <strchr+0x1c>

0000000000404b42 <gets>:

char*
gets(char *buf, int max)
{
  404b42:	7159                	addi	sp,sp,-112
  404b44:	f486                	sd	ra,104(sp)
  404b46:	f0a2                	sd	s0,96(sp)
  404b48:	eca6                	sd	s1,88(sp)
  404b4a:	e8ca                	sd	s2,80(sp)
  404b4c:	e4ce                	sd	s3,72(sp)
  404b4e:	e0d2                	sd	s4,64(sp)
  404b50:	fc56                	sd	s5,56(sp)
  404b52:	f85a                	sd	s6,48(sp)
  404b54:	f45e                	sd	s7,40(sp)
  404b56:	f062                	sd	s8,32(sp)
  404b58:	ec66                	sd	s9,24(sp)
  404b5a:	e86a                	sd	s10,16(sp)
  404b5c:	1880                	addi	s0,sp,112
  404b5e:	8caa                	mv	s9,a0
  404b60:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  404b62:	892a                	mv	s2,a0
  404b64:	4481                	li	s1,0
    cc = read(0, &c, 1);
  404b66:	f9f40b13          	addi	s6,s0,-97
  404b6a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  404b6c:	4ba9                	li	s7,10
  404b6e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  404b70:	8d26                	mv	s10,s1
  404b72:	0014899b          	addiw	s3,s1,1
  404b76:	84ce                	mv	s1,s3
  404b78:	0349d563          	bge	s3,s4,404ba2 <gets+0x60>
    cc = read(0, &c, 1);
  404b7c:	8656                	mv	a2,s5
  404b7e:	85da                	mv	a1,s6
  404b80:	4501                	li	a0,0
  404b82:	198000ef          	jal	404d1a <read>
    if(cc < 1)
  404b86:	00a05e63          	blez	a0,404ba2 <gets+0x60>
    buf[i++] = c;
  404b8a:	f9f44783          	lbu	a5,-97(s0)
  404b8e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  404b92:	01778763          	beq	a5,s7,404ba0 <gets+0x5e>
  404b96:	0905                	addi	s2,s2,1
  404b98:	fd879ce3          	bne	a5,s8,404b70 <gets+0x2e>
    buf[i++] = c;
  404b9c:	8d4e                	mv	s10,s3
  404b9e:	a011                	j	404ba2 <gets+0x60>
  404ba0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  404ba2:	9d66                	add	s10,s10,s9
  404ba4:	000d0023          	sb	zero,0(s10)
  return buf;
}
  404ba8:	8566                	mv	a0,s9
  404baa:	70a6                	ld	ra,104(sp)
  404bac:	7406                	ld	s0,96(sp)
  404bae:	64e6                	ld	s1,88(sp)
  404bb0:	6946                	ld	s2,80(sp)
  404bb2:	69a6                	ld	s3,72(sp)
  404bb4:	6a06                	ld	s4,64(sp)
  404bb6:	7ae2                	ld	s5,56(sp)
  404bb8:	7b42                	ld	s6,48(sp)
  404bba:	7ba2                	ld	s7,40(sp)
  404bbc:	7c02                	ld	s8,32(sp)
  404bbe:	6ce2                	ld	s9,24(sp)
  404bc0:	6d42                	ld	s10,16(sp)
  404bc2:	6165                	addi	sp,sp,112
  404bc4:	8082                	ret

0000000000404bc6 <stat>:

int
stat(const char *n, struct stat *st)
{
  404bc6:	1101                	addi	sp,sp,-32
  404bc8:	ec06                	sd	ra,24(sp)
  404bca:	e822                	sd	s0,16(sp)
  404bcc:	e04a                	sd	s2,0(sp)
  404bce:	1000                	addi	s0,sp,32
  404bd0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  404bd2:	4581                	li	a1,0
  404bd4:	16e000ef          	jal	404d42 <open>
  if(fd < 0)
  404bd8:	02054263          	bltz	a0,404bfc <stat+0x36>
  404bdc:	e426                	sd	s1,8(sp)
  404bde:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  404be0:	85ca                	mv	a1,s2
  404be2:	178000ef          	jal	404d5a <fstat>
  404be6:	892a                	mv	s2,a0
  close(fd);
  404be8:	8526                	mv	a0,s1
  404bea:	140000ef          	jal	404d2a <close>
  return r;
  404bee:	64a2                	ld	s1,8(sp)
}
  404bf0:	854a                	mv	a0,s2
  404bf2:	60e2                	ld	ra,24(sp)
  404bf4:	6442                	ld	s0,16(sp)
  404bf6:	6902                	ld	s2,0(sp)
  404bf8:	6105                	addi	sp,sp,32
  404bfa:	8082                	ret
    return -1;
  404bfc:	597d                	li	s2,-1
  404bfe:	bfcd                	j	404bf0 <stat+0x2a>

0000000000404c00 <atoi>:

int
atoi(const char *s)
{
  404c00:	1141                	addi	sp,sp,-16
  404c02:	e406                	sd	ra,8(sp)
  404c04:	e022                	sd	s0,0(sp)
  404c06:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  404c08:	00054683          	lbu	a3,0(a0)
  404c0c:	fd06879b          	addiw	a5,a3,-48
  404c10:	0ff7f793          	zext.b	a5,a5
  404c14:	4625                	li	a2,9
  404c16:	02f66963          	bltu	a2,a5,404c48 <atoi+0x48>
  404c1a:	872a                	mv	a4,a0
  n = 0;
  404c1c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  404c1e:	0705                	addi	a4,a4,1
  404c20:	0025179b          	slliw	a5,a0,0x2
  404c24:	9fa9                	addw	a5,a5,a0
  404c26:	0017979b          	slliw	a5,a5,0x1
  404c2a:	9fb5                	addw	a5,a5,a3
  404c2c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  404c30:	00074683          	lbu	a3,0(a4)
  404c34:	fd06879b          	addiw	a5,a3,-48
  404c38:	0ff7f793          	zext.b	a5,a5
  404c3c:	fef671e3          	bgeu	a2,a5,404c1e <atoi+0x1e>
  return n;
}
  404c40:	60a2                	ld	ra,8(sp)
  404c42:	6402                	ld	s0,0(sp)
  404c44:	0141                	addi	sp,sp,16
  404c46:	8082                	ret
  n = 0;
  404c48:	4501                	li	a0,0
  404c4a:	bfdd                	j	404c40 <atoi+0x40>

0000000000404c4c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  404c4c:	1141                	addi	sp,sp,-16
  404c4e:	e406                	sd	ra,8(sp)
  404c50:	e022                	sd	s0,0(sp)
  404c52:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  404c54:	02b57563          	bgeu	a0,a1,404c7e <memmove+0x32>
    while(n-- > 0)
  404c58:	00c05f63          	blez	a2,404c76 <memmove+0x2a>
  404c5c:	1602                	slli	a2,a2,0x20
  404c5e:	9201                	srli	a2,a2,0x20
  404c60:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  404c64:	872a                	mv	a4,a0
      *dst++ = *src++;
  404c66:	0585                	addi	a1,a1,1
  404c68:	0705                	addi	a4,a4,1
  404c6a:	fff5c683          	lbu	a3,-1(a1)
  404c6e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  404c72:	fee79ae3          	bne	a5,a4,404c66 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  404c76:	60a2                	ld	ra,8(sp)
  404c78:	6402                	ld	s0,0(sp)
  404c7a:	0141                	addi	sp,sp,16
  404c7c:	8082                	ret
    dst += n;
  404c7e:	00c50733          	add	a4,a0,a2
    src += n;
  404c82:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  404c84:	fec059e3          	blez	a2,404c76 <memmove+0x2a>
  404c88:	fff6079b          	addiw	a5,a2,-1 # 2fff <copyinstr1-0x3fd001>
  404c8c:	1782                	slli	a5,a5,0x20
  404c8e:	9381                	srli	a5,a5,0x20
  404c90:	fff7c793          	not	a5,a5
  404c94:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  404c96:	15fd                	addi	a1,a1,-1
  404c98:	177d                	addi	a4,a4,-1
  404c9a:	0005c683          	lbu	a3,0(a1)
  404c9e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  404ca2:	fef71ae3          	bne	a4,a5,404c96 <memmove+0x4a>
  404ca6:	bfc1                	j	404c76 <memmove+0x2a>

0000000000404ca8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  404ca8:	1141                	addi	sp,sp,-16
  404caa:	e406                	sd	ra,8(sp)
  404cac:	e022                	sd	s0,0(sp)
  404cae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  404cb0:	ca0d                	beqz	a2,404ce2 <memcmp+0x3a>
  404cb2:	fff6069b          	addiw	a3,a2,-1
  404cb6:	1682                	slli	a3,a3,0x20
  404cb8:	9281                	srli	a3,a3,0x20
  404cba:	0685                	addi	a3,a3,1
  404cbc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  404cbe:	00054783          	lbu	a5,0(a0)
  404cc2:	0005c703          	lbu	a4,0(a1)
  404cc6:	00e79863          	bne	a5,a4,404cd6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  404cca:	0505                	addi	a0,a0,1
    p2++;
  404ccc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  404cce:	fed518e3          	bne	a0,a3,404cbe <memcmp+0x16>
  }
  return 0;
  404cd2:	4501                	li	a0,0
  404cd4:	a019                	j	404cda <memcmp+0x32>
      return *p1 - *p2;
  404cd6:	40e7853b          	subw	a0,a5,a4
}
  404cda:	60a2                	ld	ra,8(sp)
  404cdc:	6402                	ld	s0,0(sp)
  404cde:	0141                	addi	sp,sp,16
  404ce0:	8082                	ret
  return 0;
  404ce2:	4501                	li	a0,0
  404ce4:	bfdd                	j	404cda <memcmp+0x32>

0000000000404ce6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  404ce6:	1141                	addi	sp,sp,-16
  404ce8:	e406                	sd	ra,8(sp)
  404cea:	e022                	sd	s0,0(sp)
  404cec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  404cee:	f5fff0ef          	jal	404c4c <memmove>
}
  404cf2:	60a2                	ld	ra,8(sp)
  404cf4:	6402                	ld	s0,0(sp)
  404cf6:	0141                	addi	sp,sp,16
  404cf8:	8082                	ret

0000000000404cfa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  404cfa:	4885                	li	a7,1
 ecall
  404cfc:	00000073          	ecall
 ret
  404d00:	8082                	ret

0000000000404d02 <exit>:
.global exit
exit:
 li a7, SYS_exit
  404d02:	4889                	li	a7,2
 ecall
  404d04:	00000073          	ecall
 ret
  404d08:	8082                	ret

0000000000404d0a <wait>:
.global wait
wait:
 li a7, SYS_wait
  404d0a:	488d                	li	a7,3
 ecall
  404d0c:	00000073          	ecall
 ret
  404d10:	8082                	ret

0000000000404d12 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  404d12:	4891                	li	a7,4
 ecall
  404d14:	00000073          	ecall
 ret
  404d18:	8082                	ret

0000000000404d1a <read>:
.global read
read:
 li a7, SYS_read
  404d1a:	4895                	li	a7,5
 ecall
  404d1c:	00000073          	ecall
 ret
  404d20:	8082                	ret

0000000000404d22 <write>:
.global write
write:
 li a7, SYS_write
  404d22:	48c1                	li	a7,16
 ecall
  404d24:	00000073          	ecall
 ret
  404d28:	8082                	ret

0000000000404d2a <close>:
.global close
close:
 li a7, SYS_close
  404d2a:	48d5                	li	a7,21
 ecall
  404d2c:	00000073          	ecall
 ret
  404d30:	8082                	ret

0000000000404d32 <kill>:
.global kill
kill:
 li a7, SYS_kill
  404d32:	4899                	li	a7,6
 ecall
  404d34:	00000073          	ecall
 ret
  404d38:	8082                	ret

0000000000404d3a <exec>:
.global exec
exec:
 li a7, SYS_exec
  404d3a:	489d                	li	a7,7
 ecall
  404d3c:	00000073          	ecall
 ret
  404d40:	8082                	ret

0000000000404d42 <open>:
.global open
open:
 li a7, SYS_open
  404d42:	48bd                	li	a7,15
 ecall
  404d44:	00000073          	ecall
 ret
  404d48:	8082                	ret

0000000000404d4a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  404d4a:	48c5                	li	a7,17
 ecall
  404d4c:	00000073          	ecall
 ret
  404d50:	8082                	ret

0000000000404d52 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  404d52:	48c9                	li	a7,18
 ecall
  404d54:	00000073          	ecall
 ret
  404d58:	8082                	ret

0000000000404d5a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  404d5a:	48a1                	li	a7,8
 ecall
  404d5c:	00000073          	ecall
 ret
  404d60:	8082                	ret

0000000000404d62 <link>:
.global link
link:
 li a7, SYS_link
  404d62:	48cd                	li	a7,19
 ecall
  404d64:	00000073          	ecall
 ret
  404d68:	8082                	ret

0000000000404d6a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  404d6a:	48d1                	li	a7,20
 ecall
  404d6c:	00000073          	ecall
 ret
  404d70:	8082                	ret

0000000000404d72 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  404d72:	48a5                	li	a7,9
 ecall
  404d74:	00000073          	ecall
 ret
  404d78:	8082                	ret

0000000000404d7a <dup>:
.global dup
dup:
 li a7, SYS_dup
  404d7a:	48a9                	li	a7,10
 ecall
  404d7c:	00000073          	ecall
 ret
  404d80:	8082                	ret

0000000000404d82 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  404d82:	48ad                	li	a7,11
 ecall
  404d84:	00000073          	ecall
 ret
  404d88:	8082                	ret

0000000000404d8a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  404d8a:	48b1                	li	a7,12
 ecall
  404d8c:	00000073          	ecall
 ret
  404d90:	8082                	ret

0000000000404d92 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  404d92:	48b5                	li	a7,13
 ecall
  404d94:	00000073          	ecall
 ret
  404d98:	8082                	ret

0000000000404d9a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  404d9a:	48b9                	li	a7,14
 ecall
  404d9c:	00000073          	ecall
 ret
  404da0:	8082                	ret

0000000000404da2 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  404da2:	48d9                	li	a7,22
 ecall
  404da4:	00000073          	ecall
 ret
  404da8:	8082                	ret

0000000000404daa <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  404daa:	48dd                	li	a7,23
 ecall
  404dac:	00000073          	ecall
 ret
  404db0:	8082                	ret

0000000000404db2 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  404db2:	48e1                	li	a7,24
 ecall
  404db4:	00000073          	ecall
 ret
  404db8:	8082                	ret

0000000000404dba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  404dba:	1101                	addi	sp,sp,-32
  404dbc:	ec06                	sd	ra,24(sp)
  404dbe:	e822                	sd	s0,16(sp)
  404dc0:	1000                	addi	s0,sp,32
  404dc2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  404dc6:	4605                	li	a2,1
  404dc8:	fef40593          	addi	a1,s0,-17
  404dcc:	f57ff0ef          	jal	404d22 <write>
}
  404dd0:	60e2                	ld	ra,24(sp)
  404dd2:	6442                	ld	s0,16(sp)
  404dd4:	6105                	addi	sp,sp,32
  404dd6:	8082                	ret

0000000000404dd8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  404dd8:	7139                	addi	sp,sp,-64
  404dda:	fc06                	sd	ra,56(sp)
  404ddc:	f822                	sd	s0,48(sp)
  404dde:	f426                	sd	s1,40(sp)
  404de0:	f04a                	sd	s2,32(sp)
  404de2:	ec4e                	sd	s3,24(sp)
  404de4:	0080                	addi	s0,sp,64
  404de6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  404de8:	c299                	beqz	a3,404dee <printint+0x16>
  404dea:	0605ce63          	bltz	a1,404e66 <printint+0x8e>
  neg = 0;
  404dee:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  404df0:	fc040313          	addi	t1,s0,-64
  neg = 0;
  404df4:	869a                	mv	a3,t1
  i = 0;
  404df6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  404df8:	00003817          	auipc	a6,0x3
  404dfc:	8e880813          	addi	a6,a6,-1816 # 4076e0 <digits>
  404e00:	88be                	mv	a7,a5
  404e02:	0017851b          	addiw	a0,a5,1
  404e06:	87aa                	mv	a5,a0
  404e08:	02c5f73b          	remuw	a4,a1,a2
  404e0c:	1702                	slli	a4,a4,0x20
  404e0e:	9301                	srli	a4,a4,0x20
  404e10:	9742                	add	a4,a4,a6
  404e12:	00074703          	lbu	a4,0(a4)
  404e16:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  404e1a:	872e                	mv	a4,a1
  404e1c:	02c5d5bb          	divuw	a1,a1,a2
  404e20:	0685                	addi	a3,a3,1
  404e22:	fcc77fe3          	bgeu	a4,a2,404e00 <printint+0x28>
  if(neg)
  404e26:	000e0c63          	beqz	t3,404e3e <printint+0x66>
    buf[i++] = '-';
  404e2a:	fd050793          	addi	a5,a0,-48
  404e2e:	00878533          	add	a0,a5,s0
  404e32:	02d00793          	li	a5,45
  404e36:	fef50823          	sb	a5,-16(a0)
  404e3a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  404e3e:	fff7899b          	addiw	s3,a5,-1
  404e42:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  404e46:	fff4c583          	lbu	a1,-1(s1)
  404e4a:	854a                	mv	a0,s2
  404e4c:	f6fff0ef          	jal	404dba <putc>
  while(--i >= 0)
  404e50:	39fd                	addiw	s3,s3,-1
  404e52:	14fd                	addi	s1,s1,-1
  404e54:	fe09d9e3          	bgez	s3,404e46 <printint+0x6e>
}
  404e58:	70e2                	ld	ra,56(sp)
  404e5a:	7442                	ld	s0,48(sp)
  404e5c:	74a2                	ld	s1,40(sp)
  404e5e:	7902                	ld	s2,32(sp)
  404e60:	69e2                	ld	s3,24(sp)
  404e62:	6121                	addi	sp,sp,64
  404e64:	8082                	ret
    x = -xx;
  404e66:	40b005bb          	negw	a1,a1
    neg = 1;
  404e6a:	4e05                	li	t3,1
    x = -xx;
  404e6c:	b751                	j	404df0 <printint+0x18>

0000000000404e6e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  404e6e:	711d                	addi	sp,sp,-96
  404e70:	ec86                	sd	ra,88(sp)
  404e72:	e8a2                	sd	s0,80(sp)
  404e74:	e4a6                	sd	s1,72(sp)
  404e76:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  404e78:	0005c483          	lbu	s1,0(a1)
  404e7c:	26048663          	beqz	s1,4050e8 <vprintf+0x27a>
  404e80:	e0ca                	sd	s2,64(sp)
  404e82:	fc4e                	sd	s3,56(sp)
  404e84:	f852                	sd	s4,48(sp)
  404e86:	f456                	sd	s5,40(sp)
  404e88:	f05a                	sd	s6,32(sp)
  404e8a:	ec5e                	sd	s7,24(sp)
  404e8c:	e862                	sd	s8,16(sp)
  404e8e:	e466                	sd	s9,8(sp)
  404e90:	8b2a                	mv	s6,a0
  404e92:	8a2e                	mv	s4,a1
  404e94:	8bb2                	mv	s7,a2
  state = 0;
  404e96:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  404e98:	4901                	li	s2,0
  404e9a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  404e9c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  404ea0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  404ea4:	06c00c93          	li	s9,108
  404ea8:	a00d                	j	404eca <vprintf+0x5c>
        putc(fd, c0);
  404eaa:	85a6                	mv	a1,s1
  404eac:	855a                	mv	a0,s6
  404eae:	f0dff0ef          	jal	404dba <putc>
  404eb2:	a019                	j	404eb8 <vprintf+0x4a>
    } else if(state == '%'){
  404eb4:	03598363          	beq	s3,s5,404eda <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  404eb8:	0019079b          	addiw	a5,s2,1
  404ebc:	893e                	mv	s2,a5
  404ebe:	873e                	mv	a4,a5
  404ec0:	97d2                	add	a5,a5,s4
  404ec2:	0007c483          	lbu	s1,0(a5)
  404ec6:	20048963          	beqz	s1,4050d8 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  404eca:	0004879b          	sext.w	a5,s1
    if(state == 0){
  404ece:	fe0993e3          	bnez	s3,404eb4 <vprintf+0x46>
      if(c0 == '%'){
  404ed2:	fd579ce3          	bne	a5,s5,404eaa <vprintf+0x3c>
        state = '%';
  404ed6:	89be                	mv	s3,a5
  404ed8:	b7c5                	j	404eb8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  404eda:	00ea06b3          	add	a3,s4,a4
  404ede:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  404ee2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  404ee4:	c681                	beqz	a3,404eec <vprintf+0x7e>
  404ee6:	9752                	add	a4,a4,s4
  404ee8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  404eec:	03878e63          	beq	a5,s8,404f28 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  404ef0:	05978863          	beq	a5,s9,404f40 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  404ef4:	07500713          	li	a4,117
  404ef8:	0ee78263          	beq	a5,a4,404fdc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  404efc:	07800713          	li	a4,120
  404f00:	12e78463          	beq	a5,a4,405028 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  404f04:	07000713          	li	a4,112
  404f08:	14e78963          	beq	a5,a4,40505a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  404f0c:	07300713          	li	a4,115
  404f10:	18e78863          	beq	a5,a4,4050a0 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  404f14:	02500713          	li	a4,37
  404f18:	04e79463          	bne	a5,a4,404f60 <vprintf+0xf2>
        putc(fd, '%');
  404f1c:	85ba                	mv	a1,a4
  404f1e:	855a                	mv	a0,s6
  404f20:	e9bff0ef          	jal	404dba <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  404f24:	4981                	li	s3,0
  404f26:	bf49                	j	404eb8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  404f28:	008b8493          	addi	s1,s7,8
  404f2c:	4685                	li	a3,1
  404f2e:	4629                	li	a2,10
  404f30:	000ba583          	lw	a1,0(s7)
  404f34:	855a                	mv	a0,s6
  404f36:	ea3ff0ef          	jal	404dd8 <printint>
  404f3a:	8ba6                	mv	s7,s1
      state = 0;
  404f3c:	4981                	li	s3,0
  404f3e:	bfad                	j	404eb8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  404f40:	06400793          	li	a5,100
  404f44:	02f68963          	beq	a3,a5,404f76 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  404f48:	06c00793          	li	a5,108
  404f4c:	04f68263          	beq	a3,a5,404f90 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  404f50:	07500793          	li	a5,117
  404f54:	0af68063          	beq	a3,a5,404ff4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  404f58:	07800793          	li	a5,120
  404f5c:	0ef68263          	beq	a3,a5,405040 <vprintf+0x1d2>
        putc(fd, '%');
  404f60:	02500593          	li	a1,37
  404f64:	855a                	mv	a0,s6
  404f66:	e55ff0ef          	jal	404dba <putc>
        putc(fd, c0);
  404f6a:	85a6                	mv	a1,s1
  404f6c:	855a                	mv	a0,s6
  404f6e:	e4dff0ef          	jal	404dba <putc>
      state = 0;
  404f72:	4981                	li	s3,0
  404f74:	b791                	j	404eb8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  404f76:	008b8493          	addi	s1,s7,8
  404f7a:	4685                	li	a3,1
  404f7c:	4629                	li	a2,10
  404f7e:	000ba583          	lw	a1,0(s7)
  404f82:	855a                	mv	a0,s6
  404f84:	e55ff0ef          	jal	404dd8 <printint>
        i += 1;
  404f88:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  404f8a:	8ba6                	mv	s7,s1
      state = 0;
  404f8c:	4981                	li	s3,0
        i += 1;
  404f8e:	b72d                	j	404eb8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  404f90:	06400793          	li	a5,100
  404f94:	02f60763          	beq	a2,a5,404fc2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  404f98:	07500793          	li	a5,117
  404f9c:	06f60963          	beq	a2,a5,40500e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  404fa0:	07800793          	li	a5,120
  404fa4:	faf61ee3          	bne	a2,a5,404f60 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  404fa8:	008b8493          	addi	s1,s7,8
  404fac:	4681                	li	a3,0
  404fae:	4641                	li	a2,16
  404fb0:	000ba583          	lw	a1,0(s7)
  404fb4:	855a                	mv	a0,s6
  404fb6:	e23ff0ef          	jal	404dd8 <printint>
        i += 2;
  404fba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  404fbc:	8ba6                	mv	s7,s1
      state = 0;
  404fbe:	4981                	li	s3,0
        i += 2;
  404fc0:	bde5                	j	404eb8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  404fc2:	008b8493          	addi	s1,s7,8
  404fc6:	4685                	li	a3,1
  404fc8:	4629                	li	a2,10
  404fca:	000ba583          	lw	a1,0(s7)
  404fce:	855a                	mv	a0,s6
  404fd0:	e09ff0ef          	jal	404dd8 <printint>
        i += 2;
  404fd4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  404fd6:	8ba6                	mv	s7,s1
      state = 0;
  404fd8:	4981                	li	s3,0
        i += 2;
  404fda:	bdf9                	j	404eb8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  404fdc:	008b8493          	addi	s1,s7,8
  404fe0:	4681                	li	a3,0
  404fe2:	4629                	li	a2,10
  404fe4:	000ba583          	lw	a1,0(s7)
  404fe8:	855a                	mv	a0,s6
  404fea:	defff0ef          	jal	404dd8 <printint>
  404fee:	8ba6                	mv	s7,s1
      state = 0;
  404ff0:	4981                	li	s3,0
  404ff2:	b5d9                	j	404eb8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  404ff4:	008b8493          	addi	s1,s7,8
  404ff8:	4681                	li	a3,0
  404ffa:	4629                	li	a2,10
  404ffc:	000ba583          	lw	a1,0(s7)
  405000:	855a                	mv	a0,s6
  405002:	dd7ff0ef          	jal	404dd8 <printint>
        i += 1;
  405006:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  405008:	8ba6                	mv	s7,s1
      state = 0;
  40500a:	4981                	li	s3,0
        i += 1;
  40500c:	b575                	j	404eb8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  40500e:	008b8493          	addi	s1,s7,8
  405012:	4681                	li	a3,0
  405014:	4629                	li	a2,10
  405016:	000ba583          	lw	a1,0(s7)
  40501a:	855a                	mv	a0,s6
  40501c:	dbdff0ef          	jal	404dd8 <printint>
        i += 2;
  405020:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  405022:	8ba6                	mv	s7,s1
      state = 0;
  405024:	4981                	li	s3,0
        i += 2;
  405026:	bd49                	j	404eb8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  405028:	008b8493          	addi	s1,s7,8
  40502c:	4681                	li	a3,0
  40502e:	4641                	li	a2,16
  405030:	000ba583          	lw	a1,0(s7)
  405034:	855a                	mv	a0,s6
  405036:	da3ff0ef          	jal	404dd8 <printint>
  40503a:	8ba6                	mv	s7,s1
      state = 0;
  40503c:	4981                	li	s3,0
  40503e:	bdad                	j	404eb8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  405040:	008b8493          	addi	s1,s7,8
  405044:	4681                	li	a3,0
  405046:	4641                	li	a2,16
  405048:	000ba583          	lw	a1,0(s7)
  40504c:	855a                	mv	a0,s6
  40504e:	d8bff0ef          	jal	404dd8 <printint>
        i += 1;
  405052:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  405054:	8ba6                	mv	s7,s1
      state = 0;
  405056:	4981                	li	s3,0
        i += 1;
  405058:	b585                	j	404eb8 <vprintf+0x4a>
  40505a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  40505c:	008b8d13          	addi	s10,s7,8
  405060:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  405064:	03000593          	li	a1,48
  405068:	855a                	mv	a0,s6
  40506a:	d51ff0ef          	jal	404dba <putc>
  putc(fd, 'x');
  40506e:	07800593          	li	a1,120
  405072:	855a                	mv	a0,s6
  405074:	d47ff0ef          	jal	404dba <putc>
  405078:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  40507a:	00002b97          	auipc	s7,0x2
  40507e:	666b8b93          	addi	s7,s7,1638 # 4076e0 <digits>
  405082:	03c9d793          	srli	a5,s3,0x3c
  405086:	97de                	add	a5,a5,s7
  405088:	0007c583          	lbu	a1,0(a5)
  40508c:	855a                	mv	a0,s6
  40508e:	d2dff0ef          	jal	404dba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  405092:	0992                	slli	s3,s3,0x4
  405094:	34fd                	addiw	s1,s1,-1
  405096:	f4f5                	bnez	s1,405082 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  405098:	8bea                	mv	s7,s10
      state = 0;
  40509a:	4981                	li	s3,0
  40509c:	6d02                	ld	s10,0(sp)
  40509e:	bd29                	j	404eb8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  4050a0:	008b8993          	addi	s3,s7,8
  4050a4:	000bb483          	ld	s1,0(s7)
  4050a8:	cc91                	beqz	s1,4050c4 <vprintf+0x256>
        for(; *s; s++)
  4050aa:	0004c583          	lbu	a1,0(s1)
  4050ae:	c195                	beqz	a1,4050d2 <vprintf+0x264>
          putc(fd, *s);
  4050b0:	855a                	mv	a0,s6
  4050b2:	d09ff0ef          	jal	404dba <putc>
        for(; *s; s++)
  4050b6:	0485                	addi	s1,s1,1
  4050b8:	0004c583          	lbu	a1,0(s1)
  4050bc:	f9f5                	bnez	a1,4050b0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4050be:	8bce                	mv	s7,s3
      state = 0;
  4050c0:	4981                	li	s3,0
  4050c2:	bbdd                	j	404eb8 <vprintf+0x4a>
          s = "(null)";
  4050c4:	00002497          	auipc	s1,0x2
  4050c8:	59c48493          	addi	s1,s1,1436 # 407660 <malloc+0x2488>
        for(; *s; s++)
  4050cc:	02800593          	li	a1,40
  4050d0:	b7c5                	j	4050b0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  4050d2:	8bce                	mv	s7,s3
      state = 0;
  4050d4:	4981                	li	s3,0
  4050d6:	b3cd                	j	404eb8 <vprintf+0x4a>
  4050d8:	6906                	ld	s2,64(sp)
  4050da:	79e2                	ld	s3,56(sp)
  4050dc:	7a42                	ld	s4,48(sp)
  4050de:	7aa2                	ld	s5,40(sp)
  4050e0:	7b02                	ld	s6,32(sp)
  4050e2:	6be2                	ld	s7,24(sp)
  4050e4:	6c42                	ld	s8,16(sp)
  4050e6:	6ca2                	ld	s9,8(sp)
    }
  }
}
  4050e8:	60e6                	ld	ra,88(sp)
  4050ea:	6446                	ld	s0,80(sp)
  4050ec:	64a6                	ld	s1,72(sp)
  4050ee:	6125                	addi	sp,sp,96
  4050f0:	8082                	ret

00000000004050f2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  4050f2:	715d                	addi	sp,sp,-80
  4050f4:	ec06                	sd	ra,24(sp)
  4050f6:	e822                	sd	s0,16(sp)
  4050f8:	1000                	addi	s0,sp,32
  4050fa:	e010                	sd	a2,0(s0)
  4050fc:	e414                	sd	a3,8(s0)
  4050fe:	e818                	sd	a4,16(s0)
  405100:	ec1c                	sd	a5,24(s0)
  405102:	03043023          	sd	a6,32(s0)
  405106:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  40510a:	8622                	mv	a2,s0
  40510c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  405110:	d5fff0ef          	jal	404e6e <vprintf>
  return 0;
}
  405114:	4501                	li	a0,0
  405116:	60e2                	ld	ra,24(sp)
  405118:	6442                	ld	s0,16(sp)
  40511a:	6161                	addi	sp,sp,80
  40511c:	8082                	ret

000000000040511e <printf>:

int
printf(const char *fmt, ...)
{
  40511e:	711d                	addi	sp,sp,-96
  405120:	ec06                	sd	ra,24(sp)
  405122:	e822                	sd	s0,16(sp)
  405124:	1000                	addi	s0,sp,32
  405126:	e40c                	sd	a1,8(s0)
  405128:	e810                	sd	a2,16(s0)
  40512a:	ec14                	sd	a3,24(s0)
  40512c:	f018                	sd	a4,32(s0)
  40512e:	f41c                	sd	a5,40(s0)
  405130:	03043823          	sd	a6,48(s0)
  405134:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  405138:	00840613          	addi	a2,s0,8
  40513c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  405140:	85aa                	mv	a1,a0
  405142:	4505                	li	a0,1
  405144:	d2bff0ef          	jal	404e6e <vprintf>
  return 0;
}
  405148:	4501                	li	a0,0
  40514a:	60e2                	ld	ra,24(sp)
  40514c:	6442                	ld	s0,16(sp)
  40514e:	6125                	addi	sp,sp,96
  405150:	8082                	ret

0000000000405152 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  405152:	1141                	addi	sp,sp,-16
  405154:	e406                	sd	ra,8(sp)
  405156:	e022                	sd	s0,0(sp)
  405158:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  40515a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40515e:	00004797          	auipc	a5,0x4
  405162:	2f27b783          	ld	a5,754(a5) # 409450 <freep>
  405166:	a02d                	j	405190 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  405168:	4618                	lw	a4,8(a2)
  40516a:	9f2d                	addw	a4,a4,a1
  40516c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  405170:	6398                	ld	a4,0(a5)
  405172:	6310                	ld	a2,0(a4)
  405174:	a83d                	j	4051b2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  405176:	ff852703          	lw	a4,-8(a0)
  40517a:	9f31                	addw	a4,a4,a2
  40517c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  40517e:	ff053683          	ld	a3,-16(a0)
  405182:	a091                	j	4051c6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  405184:	6398                	ld	a4,0(a5)
  405186:	00e7e463          	bltu	a5,a4,40518e <free+0x3c>
  40518a:	00e6ea63          	bltu	a3,a4,40519e <free+0x4c>
{
  40518e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  405190:	fed7fae3          	bgeu	a5,a3,405184 <free+0x32>
  405194:	6398                	ld	a4,0(a5)
  405196:	00e6e463          	bltu	a3,a4,40519e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  40519a:	fee7eae3          	bltu	a5,a4,40518e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  40519e:	ff852583          	lw	a1,-8(a0)
  4051a2:	6390                	ld	a2,0(a5)
  4051a4:	02059813          	slli	a6,a1,0x20
  4051a8:	01c85713          	srli	a4,a6,0x1c
  4051ac:	9736                	add	a4,a4,a3
  4051ae:	fae60de3          	beq	a2,a4,405168 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4051b2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4051b6:	4790                	lw	a2,8(a5)
  4051b8:	02061593          	slli	a1,a2,0x20
  4051bc:	01c5d713          	srli	a4,a1,0x1c
  4051c0:	973e                	add	a4,a4,a5
  4051c2:	fae68ae3          	beq	a3,a4,405176 <free+0x24>
    p->s.ptr = bp->s.ptr;
  4051c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4051c8:	00004717          	auipc	a4,0x4
  4051cc:	28f73423          	sd	a5,648(a4) # 409450 <freep>
}
  4051d0:	60a2                	ld	ra,8(sp)
  4051d2:	6402                	ld	s0,0(sp)
  4051d4:	0141                	addi	sp,sp,16
  4051d6:	8082                	ret

00000000004051d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4051d8:	7139                	addi	sp,sp,-64
  4051da:	fc06                	sd	ra,56(sp)
  4051dc:	f822                	sd	s0,48(sp)
  4051de:	f04a                	sd	s2,32(sp)
  4051e0:	ec4e                	sd	s3,24(sp)
  4051e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  4051e4:	02051993          	slli	s3,a0,0x20
  4051e8:	0209d993          	srli	s3,s3,0x20
  4051ec:	09bd                	addi	s3,s3,15
  4051ee:	0049d993          	srli	s3,s3,0x4
  4051f2:	2985                	addiw	s3,s3,1
  4051f4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  4051f6:	00004517          	auipc	a0,0x4
  4051fa:	25a53503          	ld	a0,602(a0) # 409450 <freep>
  4051fe:	c905                	beqz	a0,40522e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  405200:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  405202:	4798                	lw	a4,8(a5)
  405204:	09377663          	bgeu	a4,s3,405290 <malloc+0xb8>
  405208:	f426                	sd	s1,40(sp)
  40520a:	e852                	sd	s4,16(sp)
  40520c:	e456                	sd	s5,8(sp)
  40520e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  405210:	8a4e                	mv	s4,s3
  405212:	6705                	lui	a4,0x1
  405214:	00e9f363          	bgeu	s3,a4,40521a <malloc+0x42>
  405218:	6a05                	lui	s4,0x1
  40521a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  40521e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  405222:	00004497          	auipc	s1,0x4
  405226:	22e48493          	addi	s1,s1,558 # 409450 <freep>
  if(p == (char*)-1)
  40522a:	5afd                	li	s5,-1
  40522c:	a83d                	j	40526a <malloc+0x92>
  40522e:	f426                	sd	s1,40(sp)
  405230:	e852                	sd	s4,16(sp)
  405232:	e456                	sd	s5,8(sp)
  405234:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  405236:	0000b797          	auipc	a5,0xb
  40523a:	a4278793          	addi	a5,a5,-1470 # 40fc78 <base>
  40523e:	00004717          	auipc	a4,0x4
  405242:	20f73923          	sd	a5,530(a4) # 409450 <freep>
  405246:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  405248:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  40524c:	b7d1                	j	405210 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  40524e:	6398                	ld	a4,0(a5)
  405250:	e118                	sd	a4,0(a0)
  405252:	a899                	j	4052a8 <malloc+0xd0>
  hp->s.size = nu;
  405254:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  405258:	0541                	addi	a0,a0,16
  40525a:	ef9ff0ef          	jal	405152 <free>
  return freep;
  40525e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  405260:	c125                	beqz	a0,4052c0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  405262:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  405264:	4798                	lw	a4,8(a5)
  405266:	03277163          	bgeu	a4,s2,405288 <malloc+0xb0>
    if(p == freep)
  40526a:	6098                	ld	a4,0(s1)
  40526c:	853e                	mv	a0,a5
  40526e:	fef71ae3          	bne	a4,a5,405262 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  405272:	8552                	mv	a0,s4
  405274:	b17ff0ef          	jal	404d8a <sbrk>
  if(p == (char*)-1)
  405278:	fd551ee3          	bne	a0,s5,405254 <malloc+0x7c>
        return 0;
  40527c:	4501                	li	a0,0
  40527e:	74a2                	ld	s1,40(sp)
  405280:	6a42                	ld	s4,16(sp)
  405282:	6aa2                	ld	s5,8(sp)
  405284:	6b02                	ld	s6,0(sp)
  405286:	a03d                	j	4052b4 <malloc+0xdc>
  405288:	74a2                	ld	s1,40(sp)
  40528a:	6a42                	ld	s4,16(sp)
  40528c:	6aa2                	ld	s5,8(sp)
  40528e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  405290:	fae90fe3          	beq	s2,a4,40524e <malloc+0x76>
        p->s.size -= nunits;
  405294:	4137073b          	subw	a4,a4,s3
  405298:	c798                	sw	a4,8(a5)
        p += p->s.size;
  40529a:	02071693          	slli	a3,a4,0x20
  40529e:	01c6d713          	srli	a4,a3,0x1c
  4052a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4052a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4052a8:	00004717          	auipc	a4,0x4
  4052ac:	1aa73423          	sd	a0,424(a4) # 409450 <freep>
      return (void*)(p + 1);
  4052b0:	01078513          	addi	a0,a5,16
  }
}
  4052b4:	70e2                	ld	ra,56(sp)
  4052b6:	7442                	ld	s0,48(sp)
  4052b8:	7902                	ld	s2,32(sp)
  4052ba:	69e2                	ld	s3,24(sp)
  4052bc:	6121                	addi	sp,sp,64
  4052be:	8082                	ret
  4052c0:	74a2                	ld	s1,40(sp)
  4052c2:	6a42                	ld	s4,16(sp)
  4052c4:	6aa2                	ld	s5,8(sp)
  4052c6:	6b02                	ld	s6,0(sp)
  4052c8:	b7f5                	j	4052b4 <malloc+0xdc>
