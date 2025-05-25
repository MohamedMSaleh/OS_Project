
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
  400000:	1141                	addi	sp,sp,-16
  400002:	e406                	sd	ra,8(sp)
  400004:	e022                	sd	s0,0(sp)
  400006:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
  400008:	611c                	ld	a5,0(a0)
  40000a:	0017d693          	srli	a3,a5,0x1
  40000e:	c0000737          	lui	a4,0xc0000
  400012:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfbfdbf9>
  400014:	1706                	slli	a4,a4,0x21
  400016:	0725                	addi	a4,a4,9
  400018:	02e6b733          	mulhu	a4,a3,a4
  40001c:	8375                	srli	a4,a4,0x1d
  40001e:	01e71693          	slli	a3,a4,0x1e
  400022:	40e68733          	sub	a4,a3,a4
  400026:	0706                	slli	a4,a4,0x1
  400028:	8f99                	sub	a5,a5,a4
  40002a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
  40002c:	1fe406b7          	lui	a3,0x1fe40
  400030:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fa3d771>
  400034:	41a70737          	lui	a4,0x41a70
  400038:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x4166e1a7>
  40003c:	1702                	slli	a4,a4,0x20
  40003e:	9736                	add	a4,a4,a3
  400040:	02e79733          	mulh	a4,a5,a4
  400044:	873d                	srai	a4,a4,0xf
  400046:	43f7d693          	srai	a3,a5,0x3f
  40004a:	8f15                	sub	a4,a4,a3
  40004c:	66fd                	lui	a3,0x1f
  40004e:	31d68693          	addi	a3,a3,797 # 1f31d <do_rand-0x3e0ce3>
  400052:	02d706b3          	mul	a3,a4,a3
  400056:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
  400058:	6691                	lui	a3,0x4
  40005a:	1a768693          	addi	a3,a3,423 # 41a7 <do_rand-0x3fbe59>
  40005e:	02d787b3          	mul	a5,a5,a3
  400062:	76fd                	lui	a3,0xfffff
  400064:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffbfd0e4>
  400068:	02d70733          	mul	a4,a4,a3
  40006c:	97ba                	add	a5,a5,a4
    if (x < 0)
  40006e:	0007ca63          	bltz	a5,400082 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
  400072:	17fd                	addi	a5,a5,-1
    *ctx = x;
  400074:	e11c                	sd	a5,0(a0)
    return (x);
}
  400076:	0007851b          	sext.w	a0,a5
  40007a:	60a2                	ld	ra,8(sp)
  40007c:	6402                	ld	s0,0(sp)
  40007e:	0141                	addi	sp,sp,16
  400080:	8082                	ret
        x += 0x7fffffff;
  400082:	80000737          	lui	a4,0x80000
  400086:	fff74713          	not	a4,a4
  40008a:	97ba                	add	a5,a5,a4
  40008c:	b7dd                	j	400072 <do_rand+0x72>

000000000040008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
  40008e:	1141                	addi	sp,sp,-16
  400090:	e406                	sd	ra,8(sp)
  400092:	e022                	sd	s0,0(sp)
  400094:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
  400096:	00002517          	auipc	a0,0x2
  40009a:	f6a50513          	addi	a0,a0,-150 # 402000 <rand_next>
  40009e:	f63ff0ef          	jal	400000 <do_rand>
}
  4000a2:	60a2                	ld	ra,8(sp)
  4000a4:	6402                	ld	s0,0(sp)
  4000a6:	0141                	addi	sp,sp,16
  4000a8:	8082                	ret

00000000004000aa <go>:

void
go(int which_child)
{
  4000aa:	7171                	addi	sp,sp,-176
  4000ac:	f506                	sd	ra,168(sp)
  4000ae:	f122                	sd	s0,160(sp)
  4000b0:	ed26                	sd	s1,152(sp)
  4000b2:	1900                	addi	s0,sp,176
  4000b4:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
  4000b6:	4501                	li	a0,0
  4000b8:	3f1000ef          	jal	400ca8 <sbrk>
  4000bc:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
  4000c0:	00001517          	auipc	a0,0x1
  4000c4:	13050513          	addi	a0,a0,304 # 4011f0 <malloc+0xfa>
  4000c8:	3c1000ef          	jal	400c88 <mkdir>
  if(chdir("grindir") != 0){
  4000cc:	00001517          	auipc	a0,0x1
  4000d0:	12450513          	addi	a0,a0,292 # 4011f0 <malloc+0xfa>
  4000d4:	3bd000ef          	jal	400c90 <chdir>
  4000d8:	c505                	beqz	a0,400100 <go+0x56>
  4000da:	e94a                	sd	s2,144(sp)
  4000dc:	e54e                	sd	s3,136(sp)
  4000de:	e152                	sd	s4,128(sp)
  4000e0:	fcd6                	sd	s5,120(sp)
  4000e2:	f8da                	sd	s6,112(sp)
  4000e4:	f4de                	sd	s7,104(sp)
  4000e6:	f0e2                	sd	s8,96(sp)
  4000e8:	ece6                	sd	s9,88(sp)
  4000ea:	e8ea                	sd	s10,80(sp)
  4000ec:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
  4000ee:	00001517          	auipc	a0,0x1
  4000f2:	10a50513          	addi	a0,a0,266 # 4011f8 <malloc+0x102>
  4000f6:	747000ef          	jal	40103c <printf>
    exit(1);
  4000fa:	4505                	li	a0,1
  4000fc:	325000ef          	jal	400c20 <exit>
  400100:	e94a                	sd	s2,144(sp)
  400102:	e54e                	sd	s3,136(sp)
  400104:	e152                	sd	s4,128(sp)
  400106:	fcd6                	sd	s5,120(sp)
  400108:	f8da                	sd	s6,112(sp)
  40010a:	f4de                	sd	s7,104(sp)
  40010c:	f0e2                	sd	s8,96(sp)
  40010e:	ece6                	sd	s9,88(sp)
  400110:	e8ea                	sd	s10,80(sp)
  400112:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
  400114:	00001517          	auipc	a0,0x1
  400118:	10c50513          	addi	a0,a0,268 # 401220 <malloc+0x12a>
  40011c:	375000ef          	jal	400c90 <chdir>
  400120:	00001c17          	auipc	s8,0x1
  400124:	110c0c13          	addi	s8,s8,272 # 401230 <malloc+0x13a>
  400128:	c489                	beqz	s1,400132 <go+0x88>
  40012a:	00001c17          	auipc	s8,0x1
  40012e:	0fec0c13          	addi	s8,s8,254 # 401228 <malloc+0x132>
  uint64 iters = 0;
  400132:	4481                	li	s1,0
  int fd = -1;
  400134:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
  400136:	e353f7b7          	lui	a5,0xe353f
  40013a:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <base+0xffffffffe313d3c7>
  40013e:	20c4a9b7          	lui	s3,0x20c4a
  400142:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <base+0x2084779e>
  400146:	1982                	slli	s3,s3,0x20
  400148:	99be                	add	s3,s3,a5
  40014a:	1f400b13          	li	s6,500
      write(1, which_child?"B":"A", 1);
  40014e:	4b85                	li	s7,1
    int what = rand() % 23;
  400150:	b2164a37          	lui	s4,0xb2164
  400154:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <base+0xffffffffb1d61ec1>
  400158:	4ad9                	li	s5,22
  40015a:	00001917          	auipc	s2,0x1
  40015e:	3a690913          	addi	s2,s2,934 # 401500 <malloc+0x40a>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
  400162:	f6840d93          	addi	s11,s0,-152
  400166:	a819                	j	40017c <go+0xd2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
  400168:	20200593          	li	a1,514
  40016c:	00001517          	auipc	a0,0x1
  400170:	0cc50513          	addi	a0,a0,204 # 401238 <malloc+0x142>
  400174:	2ed000ef          	jal	400c60 <open>
  400178:	2d1000ef          	jal	400c48 <close>
    iters++;
  40017c:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
  40017e:	0024d793          	srli	a5,s1,0x2
  400182:	0337b7b3          	mulhu	a5,a5,s3
  400186:	8391                	srli	a5,a5,0x4
  400188:	036787b3          	mul	a5,a5,s6
  40018c:	00f49763          	bne	s1,a5,40019a <go+0xf0>
      write(1, which_child?"B":"A", 1);
  400190:	865e                	mv	a2,s7
  400192:	85e2                	mv	a1,s8
  400194:	855e                	mv	a0,s7
  400196:	2ab000ef          	jal	400c40 <write>
    int what = rand() % 23;
  40019a:	ef5ff0ef          	jal	40008e <rand>
  40019e:	034507b3          	mul	a5,a0,s4
  4001a2:	9381                	srli	a5,a5,0x20
  4001a4:	9fa9                	addw	a5,a5,a0
  4001a6:	4047d79b          	sraiw	a5,a5,0x4
  4001aa:	41f5571b          	sraiw	a4,a0,0x1f
  4001ae:	9f99                	subw	a5,a5,a4
  4001b0:	0017971b          	slliw	a4,a5,0x1
  4001b4:	9f3d                	addw	a4,a4,a5
  4001b6:	0037171b          	slliw	a4,a4,0x3
  4001ba:	40f707bb          	subw	a5,a4,a5
  4001be:	9d1d                	subw	a0,a0,a5
  4001c0:	faaaeee3          	bltu	s5,a0,40017c <go+0xd2>
  4001c4:	02051793          	slli	a5,a0,0x20
  4001c8:	01e7d513          	srli	a0,a5,0x1e
  4001cc:	954a                	add	a0,a0,s2
  4001ce:	411c                	lw	a5,0(a0)
  4001d0:	97ca                	add	a5,a5,s2
  4001d2:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
  4001d4:	20200593          	li	a1,514
  4001d8:	00001517          	auipc	a0,0x1
  4001dc:	07050513          	addi	a0,a0,112 # 401248 <malloc+0x152>
  4001e0:	281000ef          	jal	400c60 <open>
  4001e4:	265000ef          	jal	400c48 <close>
  4001e8:	bf51                	j	40017c <go+0xd2>
      unlink("grindir/../a");
  4001ea:	00001517          	auipc	a0,0x1
  4001ee:	04e50513          	addi	a0,a0,78 # 401238 <malloc+0x142>
  4001f2:	27f000ef          	jal	400c70 <unlink>
  4001f6:	b759                	j	40017c <go+0xd2>
      if(chdir("grindir") != 0){
  4001f8:	00001517          	auipc	a0,0x1
  4001fc:	ff850513          	addi	a0,a0,-8 # 4011f0 <malloc+0xfa>
  400200:	291000ef          	jal	400c90 <chdir>
  400204:	ed11                	bnez	a0,400220 <go+0x176>
      unlink("../b");
  400206:	00001517          	auipc	a0,0x1
  40020a:	05a50513          	addi	a0,a0,90 # 401260 <malloc+0x16a>
  40020e:	263000ef          	jal	400c70 <unlink>
      chdir("/");
  400212:	00001517          	auipc	a0,0x1
  400216:	00e50513          	addi	a0,a0,14 # 401220 <malloc+0x12a>
  40021a:	277000ef          	jal	400c90 <chdir>
  40021e:	bfb9                	j	40017c <go+0xd2>
        printf("grind: chdir grindir failed\n");
  400220:	00001517          	auipc	a0,0x1
  400224:	fd850513          	addi	a0,a0,-40 # 4011f8 <malloc+0x102>
  400228:	615000ef          	jal	40103c <printf>
        exit(1);
  40022c:	4505                	li	a0,1
  40022e:	1f3000ef          	jal	400c20 <exit>
      close(fd);
  400232:	8566                	mv	a0,s9
  400234:	215000ef          	jal	400c48 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
  400238:	20200593          	li	a1,514
  40023c:	00001517          	auipc	a0,0x1
  400240:	02c50513          	addi	a0,a0,44 # 401268 <malloc+0x172>
  400244:	21d000ef          	jal	400c60 <open>
  400248:	8caa                	mv	s9,a0
  40024a:	bf0d                	j	40017c <go+0xd2>
      close(fd);
  40024c:	8566                	mv	a0,s9
  40024e:	1fb000ef          	jal	400c48 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
  400252:	20200593          	li	a1,514
  400256:	00001517          	auipc	a0,0x1
  40025a:	02250513          	addi	a0,a0,34 # 401278 <malloc+0x182>
  40025e:	203000ef          	jal	400c60 <open>
  400262:	8caa                	mv	s9,a0
  400264:	bf21                	j	40017c <go+0xd2>
      write(fd, buf, sizeof(buf));
  400266:	3e700613          	li	a2,999
  40026a:	00002597          	auipc	a1,0x2
  40026e:	db658593          	addi	a1,a1,-586 # 402020 <buf.0>
  400272:	8566                	mv	a0,s9
  400274:	1cd000ef          	jal	400c40 <write>
  400278:	b711                	j	40017c <go+0xd2>
      read(fd, buf, sizeof(buf));
  40027a:	3e700613          	li	a2,999
  40027e:	00002597          	auipc	a1,0x2
  400282:	da258593          	addi	a1,a1,-606 # 402020 <buf.0>
  400286:	8566                	mv	a0,s9
  400288:	1b1000ef          	jal	400c38 <read>
  40028c:	bdc5                	j	40017c <go+0xd2>
      mkdir("grindir/../a");
  40028e:	00001517          	auipc	a0,0x1
  400292:	faa50513          	addi	a0,a0,-86 # 401238 <malloc+0x142>
  400296:	1f3000ef          	jal	400c88 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
  40029a:	20200593          	li	a1,514
  40029e:	00001517          	auipc	a0,0x1
  4002a2:	ff250513          	addi	a0,a0,-14 # 401290 <malloc+0x19a>
  4002a6:	1bb000ef          	jal	400c60 <open>
  4002aa:	19f000ef          	jal	400c48 <close>
      unlink("a/a");
  4002ae:	00001517          	auipc	a0,0x1
  4002b2:	ff250513          	addi	a0,a0,-14 # 4012a0 <malloc+0x1aa>
  4002b6:	1bb000ef          	jal	400c70 <unlink>
  4002ba:	b5c9                	j	40017c <go+0xd2>
      mkdir("/../b");
  4002bc:	00001517          	auipc	a0,0x1
  4002c0:	fec50513          	addi	a0,a0,-20 # 4012a8 <malloc+0x1b2>
  4002c4:	1c5000ef          	jal	400c88 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
  4002c8:	20200593          	li	a1,514
  4002cc:	00001517          	auipc	a0,0x1
  4002d0:	fe450513          	addi	a0,a0,-28 # 4012b0 <malloc+0x1ba>
  4002d4:	18d000ef          	jal	400c60 <open>
  4002d8:	171000ef          	jal	400c48 <close>
      unlink("b/b");
  4002dc:	00001517          	auipc	a0,0x1
  4002e0:	fe450513          	addi	a0,a0,-28 # 4012c0 <malloc+0x1ca>
  4002e4:	18d000ef          	jal	400c70 <unlink>
  4002e8:	bd51                	j	40017c <go+0xd2>
      unlink("b");
  4002ea:	00001517          	auipc	a0,0x1
  4002ee:	fde50513          	addi	a0,a0,-34 # 4012c8 <malloc+0x1d2>
  4002f2:	17f000ef          	jal	400c70 <unlink>
      link("../grindir/./../a", "../b");
  4002f6:	00001597          	auipc	a1,0x1
  4002fa:	f6a58593          	addi	a1,a1,-150 # 401260 <malloc+0x16a>
  4002fe:	00001517          	auipc	a0,0x1
  400302:	fd250513          	addi	a0,a0,-46 # 4012d0 <malloc+0x1da>
  400306:	17b000ef          	jal	400c80 <link>
  40030a:	bd8d                	j	40017c <go+0xd2>
      unlink("../grindir/../a");
  40030c:	00001517          	auipc	a0,0x1
  400310:	fdc50513          	addi	a0,a0,-36 # 4012e8 <malloc+0x1f2>
  400314:	15d000ef          	jal	400c70 <unlink>
      link(".././b", "/grindir/../a");
  400318:	00001597          	auipc	a1,0x1
  40031c:	f5058593          	addi	a1,a1,-176 # 401268 <malloc+0x172>
  400320:	00001517          	auipc	a0,0x1
  400324:	fd850513          	addi	a0,a0,-40 # 4012f8 <malloc+0x202>
  400328:	159000ef          	jal	400c80 <link>
  40032c:	bd81                	j	40017c <go+0xd2>
      int pid = fork();
  40032e:	0eb000ef          	jal	400c18 <fork>
      if(pid == 0){
  400332:	c519                	beqz	a0,400340 <go+0x296>
      } else if(pid < 0){
  400334:	00054863          	bltz	a0,400344 <go+0x29a>
      wait(0);
  400338:	4501                	li	a0,0
  40033a:	0ef000ef          	jal	400c28 <wait>
  40033e:	bd3d                	j	40017c <go+0xd2>
        exit(0);
  400340:	0e1000ef          	jal	400c20 <exit>
        printf("grind: fork failed\n");
  400344:	00001517          	auipc	a0,0x1
  400348:	fbc50513          	addi	a0,a0,-68 # 401300 <malloc+0x20a>
  40034c:	4f1000ef          	jal	40103c <printf>
        exit(1);
  400350:	4505                	li	a0,1
  400352:	0cf000ef          	jal	400c20 <exit>
      int pid = fork();
  400356:	0c3000ef          	jal	400c18 <fork>
      if(pid == 0){
  40035a:	c519                	beqz	a0,400368 <go+0x2be>
      } else if(pid < 0){
  40035c:	00054d63          	bltz	a0,400376 <go+0x2cc>
      wait(0);
  400360:	4501                	li	a0,0
  400362:	0c7000ef          	jal	400c28 <wait>
  400366:	bd19                	j	40017c <go+0xd2>
        fork();
  400368:	0b1000ef          	jal	400c18 <fork>
        fork();
  40036c:	0ad000ef          	jal	400c18 <fork>
        exit(0);
  400370:	4501                	li	a0,0
  400372:	0af000ef          	jal	400c20 <exit>
        printf("grind: fork failed\n");
  400376:	00001517          	auipc	a0,0x1
  40037a:	f8a50513          	addi	a0,a0,-118 # 401300 <malloc+0x20a>
  40037e:	4bf000ef          	jal	40103c <printf>
        exit(1);
  400382:	4505                	li	a0,1
  400384:	09d000ef          	jal	400c20 <exit>
      sbrk(6011);
  400388:	6505                	lui	a0,0x1
  40038a:	77b50513          	addi	a0,a0,1915 # 177b <do_rand-0x3fe885>
  40038e:	11b000ef          	jal	400ca8 <sbrk>
  400392:	b3ed                	j	40017c <go+0xd2>
      if(sbrk(0) > break0)
  400394:	4501                	li	a0,0
  400396:	113000ef          	jal	400ca8 <sbrk>
  40039a:	f5843783          	ld	a5,-168(s0)
  40039e:	dca7ffe3          	bgeu	a5,a0,40017c <go+0xd2>
        sbrk(-(sbrk(0) - break0));
  4003a2:	4501                	li	a0,0
  4003a4:	105000ef          	jal	400ca8 <sbrk>
  4003a8:	f5843783          	ld	a5,-168(s0)
  4003ac:	40a7853b          	subw	a0,a5,a0
  4003b0:	0f9000ef          	jal	400ca8 <sbrk>
  4003b4:	b3e1                	j	40017c <go+0xd2>
      int pid = fork();
  4003b6:	063000ef          	jal	400c18 <fork>
  4003ba:	8d2a                	mv	s10,a0
      if(pid == 0){
  4003bc:	c10d                	beqz	a0,4003de <go+0x334>
      } else if(pid < 0){
  4003be:	02054d63          	bltz	a0,4003f8 <go+0x34e>
      if(chdir("../grindir/..") != 0){
  4003c2:	00001517          	auipc	a0,0x1
  4003c6:	f5e50513          	addi	a0,a0,-162 # 401320 <malloc+0x22a>
  4003ca:	0c7000ef          	jal	400c90 <chdir>
  4003ce:	ed15                	bnez	a0,40040a <go+0x360>
      kill(pid);
  4003d0:	856a                	mv	a0,s10
  4003d2:	07f000ef          	jal	400c50 <kill>
      wait(0);
  4003d6:	4501                	li	a0,0
  4003d8:	051000ef          	jal	400c28 <wait>
  4003dc:	b345                	j	40017c <go+0xd2>
        close(open("a", O_CREATE|O_RDWR));
  4003de:	20200593          	li	a1,514
  4003e2:	00001517          	auipc	a0,0x1
  4003e6:	f3650513          	addi	a0,a0,-202 # 401318 <malloc+0x222>
  4003ea:	077000ef          	jal	400c60 <open>
  4003ee:	05b000ef          	jal	400c48 <close>
        exit(0);
  4003f2:	4501                	li	a0,0
  4003f4:	02d000ef          	jal	400c20 <exit>
        printf("grind: fork failed\n");
  4003f8:	00001517          	auipc	a0,0x1
  4003fc:	f0850513          	addi	a0,a0,-248 # 401300 <malloc+0x20a>
  400400:	43d000ef          	jal	40103c <printf>
        exit(1);
  400404:	4505                	li	a0,1
  400406:	01b000ef          	jal	400c20 <exit>
        printf("grind: chdir failed\n");
  40040a:	00001517          	auipc	a0,0x1
  40040e:	f2650513          	addi	a0,a0,-218 # 401330 <malloc+0x23a>
  400412:	42b000ef          	jal	40103c <printf>
        exit(1);
  400416:	4505                	li	a0,1
  400418:	009000ef          	jal	400c20 <exit>
      int pid = fork();
  40041c:	7fc000ef          	jal	400c18 <fork>
      if(pid == 0){
  400420:	c519                	beqz	a0,40042e <go+0x384>
      } else if(pid < 0){
  400422:	00054d63          	bltz	a0,40043c <go+0x392>
      wait(0);
  400426:	4501                	li	a0,0
  400428:	001000ef          	jal	400c28 <wait>
  40042c:	bb81                	j	40017c <go+0xd2>
        kill(getpid());
  40042e:	073000ef          	jal	400ca0 <getpid>
  400432:	01f000ef          	jal	400c50 <kill>
        exit(0);
  400436:	4501                	li	a0,0
  400438:	7e8000ef          	jal	400c20 <exit>
        printf("grind: fork failed\n");
  40043c:	00001517          	auipc	a0,0x1
  400440:	ec450513          	addi	a0,a0,-316 # 401300 <malloc+0x20a>
  400444:	3f9000ef          	jal	40103c <printf>
        exit(1);
  400448:	4505                	li	a0,1
  40044a:	7d6000ef          	jal	400c20 <exit>
      if(pipe(fds) < 0){
  40044e:	f7840513          	addi	a0,s0,-136
  400452:	7de000ef          	jal	400c30 <pipe>
  400456:	02054363          	bltz	a0,40047c <go+0x3d2>
      int pid = fork();
  40045a:	7be000ef          	jal	400c18 <fork>
      if(pid == 0){
  40045e:	c905                	beqz	a0,40048e <go+0x3e4>
      } else if(pid < 0){
  400460:	08054263          	bltz	a0,4004e4 <go+0x43a>
      close(fds[0]);
  400464:	f7842503          	lw	a0,-136(s0)
  400468:	7e0000ef          	jal	400c48 <close>
      close(fds[1]);
  40046c:	f7c42503          	lw	a0,-132(s0)
  400470:	7d8000ef          	jal	400c48 <close>
      wait(0);
  400474:	4501                	li	a0,0
  400476:	7b2000ef          	jal	400c28 <wait>
  40047a:	b309                	j	40017c <go+0xd2>
        printf("grind: pipe failed\n");
  40047c:	00001517          	auipc	a0,0x1
  400480:	ecc50513          	addi	a0,a0,-308 # 401348 <malloc+0x252>
  400484:	3b9000ef          	jal	40103c <printf>
        exit(1);
  400488:	4505                	li	a0,1
  40048a:	796000ef          	jal	400c20 <exit>
        fork();
  40048e:	78a000ef          	jal	400c18 <fork>
        fork();
  400492:	786000ef          	jal	400c18 <fork>
        if(write(fds[1], "x", 1) != 1)
  400496:	4605                	li	a2,1
  400498:	00001597          	auipc	a1,0x1
  40049c:	ec858593          	addi	a1,a1,-312 # 401360 <malloc+0x26a>
  4004a0:	f7c42503          	lw	a0,-132(s0)
  4004a4:	79c000ef          	jal	400c40 <write>
  4004a8:	4785                	li	a5,1
  4004aa:	00f51f63          	bne	a0,a5,4004c8 <go+0x41e>
        if(read(fds[0], &c, 1) != 1)
  4004ae:	4605                	li	a2,1
  4004b0:	f7040593          	addi	a1,s0,-144
  4004b4:	f7842503          	lw	a0,-136(s0)
  4004b8:	780000ef          	jal	400c38 <read>
  4004bc:	4785                	li	a5,1
  4004be:	00f51c63          	bne	a0,a5,4004d6 <go+0x42c>
        exit(0);
  4004c2:	4501                	li	a0,0
  4004c4:	75c000ef          	jal	400c20 <exit>
          printf("grind: pipe write failed\n");
  4004c8:	00001517          	auipc	a0,0x1
  4004cc:	ea050513          	addi	a0,a0,-352 # 401368 <malloc+0x272>
  4004d0:	36d000ef          	jal	40103c <printf>
  4004d4:	bfe9                	j	4004ae <go+0x404>
          printf("grind: pipe read failed\n");
  4004d6:	00001517          	auipc	a0,0x1
  4004da:	eb250513          	addi	a0,a0,-334 # 401388 <malloc+0x292>
  4004de:	35f000ef          	jal	40103c <printf>
  4004e2:	b7c5                	j	4004c2 <go+0x418>
        printf("grind: fork failed\n");
  4004e4:	00001517          	auipc	a0,0x1
  4004e8:	e1c50513          	addi	a0,a0,-484 # 401300 <malloc+0x20a>
  4004ec:	351000ef          	jal	40103c <printf>
        exit(1);
  4004f0:	4505                	li	a0,1
  4004f2:	72e000ef          	jal	400c20 <exit>
      int pid = fork();
  4004f6:	722000ef          	jal	400c18 <fork>
      if(pid == 0){
  4004fa:	c519                	beqz	a0,400508 <go+0x45e>
      } else if(pid < 0){
  4004fc:	04054f63          	bltz	a0,40055a <go+0x4b0>
      wait(0);
  400500:	4501                	li	a0,0
  400502:	726000ef          	jal	400c28 <wait>
  400506:	b99d                	j	40017c <go+0xd2>
        unlink("a");
  400508:	00001517          	auipc	a0,0x1
  40050c:	e1050513          	addi	a0,a0,-496 # 401318 <malloc+0x222>
  400510:	760000ef          	jal	400c70 <unlink>
        mkdir("a");
  400514:	00001517          	auipc	a0,0x1
  400518:	e0450513          	addi	a0,a0,-508 # 401318 <malloc+0x222>
  40051c:	76c000ef          	jal	400c88 <mkdir>
        chdir("a");
  400520:	00001517          	auipc	a0,0x1
  400524:	df850513          	addi	a0,a0,-520 # 401318 <malloc+0x222>
  400528:	768000ef          	jal	400c90 <chdir>
        unlink("../a");
  40052c:	00001517          	auipc	a0,0x1
  400530:	e7c50513          	addi	a0,a0,-388 # 4013a8 <malloc+0x2b2>
  400534:	73c000ef          	jal	400c70 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
  400538:	20200593          	li	a1,514
  40053c:	00001517          	auipc	a0,0x1
  400540:	e2450513          	addi	a0,a0,-476 # 401360 <malloc+0x26a>
  400544:	71c000ef          	jal	400c60 <open>
        unlink("x");
  400548:	00001517          	auipc	a0,0x1
  40054c:	e1850513          	addi	a0,a0,-488 # 401360 <malloc+0x26a>
  400550:	720000ef          	jal	400c70 <unlink>
        exit(0);
  400554:	4501                	li	a0,0
  400556:	6ca000ef          	jal	400c20 <exit>
        printf("grind: fork failed\n");
  40055a:	00001517          	auipc	a0,0x1
  40055e:	da650513          	addi	a0,a0,-602 # 401300 <malloc+0x20a>
  400562:	2db000ef          	jal	40103c <printf>
        exit(1);
  400566:	4505                	li	a0,1
  400568:	6b8000ef          	jal	400c20 <exit>
      unlink("c");
  40056c:	00001517          	auipc	a0,0x1
  400570:	e4450513          	addi	a0,a0,-444 # 4013b0 <malloc+0x2ba>
  400574:	6fc000ef          	jal	400c70 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
  400578:	20200593          	li	a1,514
  40057c:	00001517          	auipc	a0,0x1
  400580:	e3450513          	addi	a0,a0,-460 # 4013b0 <malloc+0x2ba>
  400584:	6dc000ef          	jal	400c60 <open>
  400588:	8d2a                	mv	s10,a0
      if(fd1 < 0){
  40058a:	04054563          	bltz	a0,4005d4 <go+0x52a>
      if(write(fd1, "x", 1) != 1){
  40058e:	865e                	mv	a2,s7
  400590:	00001597          	auipc	a1,0x1
  400594:	dd058593          	addi	a1,a1,-560 # 401360 <malloc+0x26a>
  400598:	6a8000ef          	jal	400c40 <write>
  40059c:	05751563          	bne	a0,s7,4005e6 <go+0x53c>
      if(fstat(fd1, &st) != 0){
  4005a0:	f7840593          	addi	a1,s0,-136
  4005a4:	856a                	mv	a0,s10
  4005a6:	6d2000ef          	jal	400c78 <fstat>
  4005aa:	e539                	bnez	a0,4005f8 <go+0x54e>
      if(st.size != 1){
  4005ac:	f8843583          	ld	a1,-120(s0)
  4005b0:	05759d63          	bne	a1,s7,40060a <go+0x560>
      if(st.ino > 200){
  4005b4:	f7c42583          	lw	a1,-132(s0)
  4005b8:	0c800793          	li	a5,200
  4005bc:	06b7e163          	bltu	a5,a1,40061e <go+0x574>
      close(fd1);
  4005c0:	856a                	mv	a0,s10
  4005c2:	686000ef          	jal	400c48 <close>
      unlink("c");
  4005c6:	00001517          	auipc	a0,0x1
  4005ca:	dea50513          	addi	a0,a0,-534 # 4013b0 <malloc+0x2ba>
  4005ce:	6a2000ef          	jal	400c70 <unlink>
  4005d2:	b66d                	j	40017c <go+0xd2>
        printf("grind: create c failed\n");
  4005d4:	00001517          	auipc	a0,0x1
  4005d8:	de450513          	addi	a0,a0,-540 # 4013b8 <malloc+0x2c2>
  4005dc:	261000ef          	jal	40103c <printf>
        exit(1);
  4005e0:	4505                	li	a0,1
  4005e2:	63e000ef          	jal	400c20 <exit>
        printf("grind: write c failed\n");
  4005e6:	00001517          	auipc	a0,0x1
  4005ea:	dea50513          	addi	a0,a0,-534 # 4013d0 <malloc+0x2da>
  4005ee:	24f000ef          	jal	40103c <printf>
        exit(1);
  4005f2:	4505                	li	a0,1
  4005f4:	62c000ef          	jal	400c20 <exit>
        printf("grind: fstat failed\n");
  4005f8:	00001517          	auipc	a0,0x1
  4005fc:	df050513          	addi	a0,a0,-528 # 4013e8 <malloc+0x2f2>
  400600:	23d000ef          	jal	40103c <printf>
        exit(1);
  400604:	4505                	li	a0,1
  400606:	61a000ef          	jal	400c20 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
  40060a:	2581                	sext.w	a1,a1
  40060c:	00001517          	auipc	a0,0x1
  400610:	df450513          	addi	a0,a0,-524 # 401400 <malloc+0x30a>
  400614:	229000ef          	jal	40103c <printf>
        exit(1);
  400618:	4505                	li	a0,1
  40061a:	606000ef          	jal	400c20 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
  40061e:	00001517          	auipc	a0,0x1
  400622:	e0a50513          	addi	a0,a0,-502 # 401428 <malloc+0x332>
  400626:	217000ef          	jal	40103c <printf>
        exit(1);
  40062a:	4505                	li	a0,1
  40062c:	5f4000ef          	jal	400c20 <exit>
      if(pipe(aa) < 0){
  400630:	856e                	mv	a0,s11
  400632:	5fe000ef          	jal	400c30 <pipe>
  400636:	0a054863          	bltz	a0,4006e6 <go+0x63c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
  40063a:	f7040513          	addi	a0,s0,-144
  40063e:	5f2000ef          	jal	400c30 <pipe>
  400642:	0a054c63          	bltz	a0,4006fa <go+0x650>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
  400646:	5d2000ef          	jal	400c18 <fork>
      if(pid1 == 0){
  40064a:	0c050263          	beqz	a0,40070e <go+0x664>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
  40064e:	14054463          	bltz	a0,400796 <go+0x6ec>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
  400652:	5c6000ef          	jal	400c18 <fork>
      if(pid2 == 0){
  400656:	14050a63          	beqz	a0,4007aa <go+0x700>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
  40065a:	1e054863          	bltz	a0,40084a <go+0x7a0>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
  40065e:	f6842503          	lw	a0,-152(s0)
  400662:	5e6000ef          	jal	400c48 <close>
      close(aa[1]);
  400666:	f6c42503          	lw	a0,-148(s0)
  40066a:	5de000ef          	jal	400c48 <close>
      close(bb[1]);
  40066e:	f7442503          	lw	a0,-140(s0)
  400672:	5d6000ef          	jal	400c48 <close>
      char buf[4] = { 0, 0, 0, 0 };
  400676:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
  40067a:	865e                	mv	a2,s7
  40067c:	f6040593          	addi	a1,s0,-160
  400680:	f7042503          	lw	a0,-144(s0)
  400684:	5b4000ef          	jal	400c38 <read>
      read(bb[0], buf+1, 1);
  400688:	865e                	mv	a2,s7
  40068a:	f6140593          	addi	a1,s0,-159
  40068e:	f7042503          	lw	a0,-144(s0)
  400692:	5a6000ef          	jal	400c38 <read>
      read(bb[0], buf+2, 1);
  400696:	865e                	mv	a2,s7
  400698:	f6240593          	addi	a1,s0,-158
  40069c:	f7042503          	lw	a0,-144(s0)
  4006a0:	598000ef          	jal	400c38 <read>
      close(bb[0]);
  4006a4:	f7042503          	lw	a0,-144(s0)
  4006a8:	5a0000ef          	jal	400c48 <close>
      int st1, st2;
      wait(&st1);
  4006ac:	f6440513          	addi	a0,s0,-156
  4006b0:	578000ef          	jal	400c28 <wait>
      wait(&st2);
  4006b4:	f7840513          	addi	a0,s0,-136
  4006b8:	570000ef          	jal	400c28 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
  4006bc:	f6442783          	lw	a5,-156(s0)
  4006c0:	f7842703          	lw	a4,-136(s0)
  4006c4:	f4e43823          	sd	a4,-176(s0)
  4006c8:	00e7ed33          	or	s10,a5,a4
  4006cc:	180d1963          	bnez	s10,40085e <go+0x7b4>
  4006d0:	00001597          	auipc	a1,0x1
  4006d4:	df858593          	addi	a1,a1,-520 # 4014c8 <malloc+0x3d2>
  4006d8:	f6040513          	addi	a0,s0,-160
  4006dc:	2d8000ef          	jal	4009b4 <strcmp>
  4006e0:	a8050ee3          	beqz	a0,40017c <go+0xd2>
  4006e4:	aab5                	j	400860 <go+0x7b6>
        fprintf(2, "grind: pipe failed\n");
  4006e6:	00001597          	auipc	a1,0x1
  4006ea:	c6258593          	addi	a1,a1,-926 # 401348 <malloc+0x252>
  4006ee:	4509                	li	a0,2
  4006f0:	121000ef          	jal	401010 <fprintf>
        exit(1);
  4006f4:	4505                	li	a0,1
  4006f6:	52a000ef          	jal	400c20 <exit>
        fprintf(2, "grind: pipe failed\n");
  4006fa:	00001597          	auipc	a1,0x1
  4006fe:	c4e58593          	addi	a1,a1,-946 # 401348 <malloc+0x252>
  400702:	4509                	li	a0,2
  400704:	10d000ef          	jal	401010 <fprintf>
        exit(1);
  400708:	4505                	li	a0,1
  40070a:	516000ef          	jal	400c20 <exit>
        close(bb[0]);
  40070e:	f7042503          	lw	a0,-144(s0)
  400712:	536000ef          	jal	400c48 <close>
        close(bb[1]);
  400716:	f7442503          	lw	a0,-140(s0)
  40071a:	52e000ef          	jal	400c48 <close>
        close(aa[0]);
  40071e:	f6842503          	lw	a0,-152(s0)
  400722:	526000ef          	jal	400c48 <close>
        close(1);
  400726:	4505                	li	a0,1
  400728:	520000ef          	jal	400c48 <close>
        if(dup(aa[1]) != 1){
  40072c:	f6c42503          	lw	a0,-148(s0)
  400730:	568000ef          	jal	400c98 <dup>
  400734:	4785                	li	a5,1
  400736:	00f50c63          	beq	a0,a5,40074e <go+0x6a4>
          fprintf(2, "grind: dup failed\n");
  40073a:	00001597          	auipc	a1,0x1
  40073e:	d1658593          	addi	a1,a1,-746 # 401450 <malloc+0x35a>
  400742:	4509                	li	a0,2
  400744:	0cd000ef          	jal	401010 <fprintf>
          exit(1);
  400748:	4505                	li	a0,1
  40074a:	4d6000ef          	jal	400c20 <exit>
        close(aa[1]);
  40074e:	f6c42503          	lw	a0,-148(s0)
  400752:	4f6000ef          	jal	400c48 <close>
        char *args[3] = { "echo", "hi", 0 };
  400756:	00001797          	auipc	a5,0x1
  40075a:	d1278793          	addi	a5,a5,-750 # 401468 <malloc+0x372>
  40075e:	f6f43c23          	sd	a5,-136(s0)
  400762:	00001797          	auipc	a5,0x1
  400766:	d0e78793          	addi	a5,a5,-754 # 401470 <malloc+0x37a>
  40076a:	f8f43023          	sd	a5,-128(s0)
  40076e:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
  400772:	f7840593          	addi	a1,s0,-136
  400776:	00001517          	auipc	a0,0x1
  40077a:	d0250513          	addi	a0,a0,-766 # 401478 <malloc+0x382>
  40077e:	4da000ef          	jal	400c58 <exec>
        fprintf(2, "grind: echo: not found\n");
  400782:	00001597          	auipc	a1,0x1
  400786:	d0658593          	addi	a1,a1,-762 # 401488 <malloc+0x392>
  40078a:	4509                	li	a0,2
  40078c:	085000ef          	jal	401010 <fprintf>
        exit(2);
  400790:	4509                	li	a0,2
  400792:	48e000ef          	jal	400c20 <exit>
        fprintf(2, "grind: fork failed\n");
  400796:	00001597          	auipc	a1,0x1
  40079a:	b6a58593          	addi	a1,a1,-1174 # 401300 <malloc+0x20a>
  40079e:	4509                	li	a0,2
  4007a0:	071000ef          	jal	401010 <fprintf>
        exit(3);
  4007a4:	450d                	li	a0,3
  4007a6:	47a000ef          	jal	400c20 <exit>
        close(aa[1]);
  4007aa:	f6c42503          	lw	a0,-148(s0)
  4007ae:	49a000ef          	jal	400c48 <close>
        close(bb[0]);
  4007b2:	f7042503          	lw	a0,-144(s0)
  4007b6:	492000ef          	jal	400c48 <close>
        close(0);
  4007ba:	4501                	li	a0,0
  4007bc:	48c000ef          	jal	400c48 <close>
        if(dup(aa[0]) != 0){
  4007c0:	f6842503          	lw	a0,-152(s0)
  4007c4:	4d4000ef          	jal	400c98 <dup>
  4007c8:	c919                	beqz	a0,4007de <go+0x734>
          fprintf(2, "grind: dup failed\n");
  4007ca:	00001597          	auipc	a1,0x1
  4007ce:	c8658593          	addi	a1,a1,-890 # 401450 <malloc+0x35a>
  4007d2:	4509                	li	a0,2
  4007d4:	03d000ef          	jal	401010 <fprintf>
          exit(4);
  4007d8:	4511                	li	a0,4
  4007da:	446000ef          	jal	400c20 <exit>
        close(aa[0]);
  4007de:	f6842503          	lw	a0,-152(s0)
  4007e2:	466000ef          	jal	400c48 <close>
        close(1);
  4007e6:	4505                	li	a0,1
  4007e8:	460000ef          	jal	400c48 <close>
        if(dup(bb[1]) != 1){
  4007ec:	f7442503          	lw	a0,-140(s0)
  4007f0:	4a8000ef          	jal	400c98 <dup>
  4007f4:	4785                	li	a5,1
  4007f6:	00f50c63          	beq	a0,a5,40080e <go+0x764>
          fprintf(2, "grind: dup failed\n");
  4007fa:	00001597          	auipc	a1,0x1
  4007fe:	c5658593          	addi	a1,a1,-938 # 401450 <malloc+0x35a>
  400802:	4509                	li	a0,2
  400804:	00d000ef          	jal	401010 <fprintf>
          exit(5);
  400808:	4515                	li	a0,5
  40080a:	416000ef          	jal	400c20 <exit>
        close(bb[1]);
  40080e:	f7442503          	lw	a0,-140(s0)
  400812:	436000ef          	jal	400c48 <close>
        char *args[2] = { "cat", 0 };
  400816:	00001797          	auipc	a5,0x1
  40081a:	c8a78793          	addi	a5,a5,-886 # 4014a0 <malloc+0x3aa>
  40081e:	f6f43c23          	sd	a5,-136(s0)
  400822:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
  400826:	f7840593          	addi	a1,s0,-136
  40082a:	00001517          	auipc	a0,0x1
  40082e:	c7e50513          	addi	a0,a0,-898 # 4014a8 <malloc+0x3b2>
  400832:	426000ef          	jal	400c58 <exec>
        fprintf(2, "grind: cat: not found\n");
  400836:	00001597          	auipc	a1,0x1
  40083a:	c7a58593          	addi	a1,a1,-902 # 4014b0 <malloc+0x3ba>
  40083e:	4509                	li	a0,2
  400840:	7d0000ef          	jal	401010 <fprintf>
        exit(6);
  400844:	4519                	li	a0,6
  400846:	3da000ef          	jal	400c20 <exit>
        fprintf(2, "grind: fork failed\n");
  40084a:	00001597          	auipc	a1,0x1
  40084e:	ab658593          	addi	a1,a1,-1354 # 401300 <malloc+0x20a>
  400852:	4509                	li	a0,2
  400854:	7bc000ef          	jal	401010 <fprintf>
        exit(7);
  400858:	451d                	li	a0,7
  40085a:	3c6000ef          	jal	400c20 <exit>
  40085e:	8d3e                	mv	s10,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
  400860:	f6040693          	addi	a3,s0,-160
  400864:	f5043603          	ld	a2,-176(s0)
  400868:	85ea                	mv	a1,s10
  40086a:	00001517          	auipc	a0,0x1
  40086e:	c6650513          	addi	a0,a0,-922 # 4014d0 <malloc+0x3da>
  400872:	7ca000ef          	jal	40103c <printf>
        exit(1);
  400876:	4505                	li	a0,1
  400878:	3a8000ef          	jal	400c20 <exit>

000000000040087c <iter>:
  }
}

void
iter()
{
  40087c:	7179                	addi	sp,sp,-48
  40087e:	f406                	sd	ra,40(sp)
  400880:	f022                	sd	s0,32(sp)
  400882:	1800                	addi	s0,sp,48
  unlink("a");
  400884:	00001517          	auipc	a0,0x1
  400888:	a9450513          	addi	a0,a0,-1388 # 401318 <malloc+0x222>
  40088c:	3e4000ef          	jal	400c70 <unlink>
  unlink("b");
  400890:	00001517          	auipc	a0,0x1
  400894:	a3850513          	addi	a0,a0,-1480 # 4012c8 <malloc+0x1d2>
  400898:	3d8000ef          	jal	400c70 <unlink>
  
  int pid1 = fork();
  40089c:	37c000ef          	jal	400c18 <fork>
  if(pid1 < 0){
  4008a0:	02054163          	bltz	a0,4008c2 <iter+0x46>
  4008a4:	ec26                	sd	s1,24(sp)
  4008a6:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
  4008a8:	e905                	bnez	a0,4008d8 <iter+0x5c>
  4008aa:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
  4008ac:	00001717          	auipc	a4,0x1
  4008b0:	75470713          	addi	a4,a4,1876 # 402000 <rand_next>
  4008b4:	631c                	ld	a5,0(a4)
  4008b6:	01f7c793          	xori	a5,a5,31
  4008ba:	e31c                	sd	a5,0(a4)
    go(0);
  4008bc:	4501                	li	a0,0
  4008be:	fecff0ef          	jal	4000aa <go>
  4008c2:	ec26                	sd	s1,24(sp)
  4008c4:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
  4008c6:	00001517          	auipc	a0,0x1
  4008ca:	a3a50513          	addi	a0,a0,-1478 # 401300 <malloc+0x20a>
  4008ce:	76e000ef          	jal	40103c <printf>
    exit(1);
  4008d2:	4505                	li	a0,1
  4008d4:	34c000ef          	jal	400c20 <exit>
  4008d8:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
  4008da:	33e000ef          	jal	400c18 <fork>
  4008de:	892a                	mv	s2,a0
  if(pid2 < 0){
  4008e0:	02054063          	bltz	a0,400900 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
  4008e4:	e51d                	bnez	a0,400912 <iter+0x96>
    rand_next ^= 7177;
  4008e6:	00001697          	auipc	a3,0x1
  4008ea:	71a68693          	addi	a3,a3,1818 # 402000 <rand_next>
  4008ee:	629c                	ld	a5,0(a3)
  4008f0:	6709                	lui	a4,0x2
  4008f2:	c0970713          	addi	a4,a4,-1015 # 1c09 <do_rand-0x3fe3f7>
  4008f6:	8fb9                	xor	a5,a5,a4
  4008f8:	e29c                	sd	a5,0(a3)
    go(1);
  4008fa:	4505                	li	a0,1
  4008fc:	faeff0ef          	jal	4000aa <go>
    printf("grind: fork failed\n");
  400900:	00001517          	auipc	a0,0x1
  400904:	a0050513          	addi	a0,a0,-1536 # 401300 <malloc+0x20a>
  400908:	734000ef          	jal	40103c <printf>
    exit(1);
  40090c:	4505                	li	a0,1
  40090e:	312000ef          	jal	400c20 <exit>
    exit(0);
  }

  int st1 = -1;
  400912:	57fd                	li	a5,-1
  400914:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
  400918:	fdc40513          	addi	a0,s0,-36
  40091c:	30c000ef          	jal	400c28 <wait>
  if(st1 != 0){
  400920:	fdc42783          	lw	a5,-36(s0)
  400924:	eb99                	bnez	a5,40093a <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
  400926:	57fd                	li	a5,-1
  400928:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
  40092c:	fd840513          	addi	a0,s0,-40
  400930:	2f8000ef          	jal	400c28 <wait>

  exit(0);
  400934:	4501                	li	a0,0
  400936:	2ea000ef          	jal	400c20 <exit>
    kill(pid1);
  40093a:	8526                	mv	a0,s1
  40093c:	314000ef          	jal	400c50 <kill>
    kill(pid2);
  400940:	854a                	mv	a0,s2
  400942:	30e000ef          	jal	400c50 <kill>
  400946:	b7c5                	j	400926 <iter+0xaa>

0000000000400948 <main>:
}

int
main()
{
  400948:	1101                	addi	sp,sp,-32
  40094a:	ec06                	sd	ra,24(sp)
  40094c:	e822                	sd	s0,16(sp)
  40094e:	e426                	sd	s1,8(sp)
  400950:	e04a                	sd	s2,0(sp)
  400952:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
  400954:	4951                	li	s2,20
    rand_next += 1;
  400956:	00001497          	auipc	s1,0x1
  40095a:	6aa48493          	addi	s1,s1,1706 # 402000 <rand_next>
  40095e:	a809                	j	400970 <main+0x28>
      iter();
  400960:	f1dff0ef          	jal	40087c <iter>
    sleep(20);
  400964:	854a                	mv	a0,s2
  400966:	34a000ef          	jal	400cb0 <sleep>
    rand_next += 1;
  40096a:	609c                	ld	a5,0(s1)
  40096c:	0785                	addi	a5,a5,1
  40096e:	e09c                	sd	a5,0(s1)
    int pid = fork();
  400970:	2a8000ef          	jal	400c18 <fork>
    if(pid == 0){
  400974:	d575                	beqz	a0,400960 <main+0x18>
    if(pid > 0){
  400976:	fea057e3          	blez	a0,400964 <main+0x1c>
      wait(0);
  40097a:	4501                	li	a0,0
  40097c:	2ac000ef          	jal	400c28 <wait>
  400980:	b7d5                	j	400964 <main+0x1c>

0000000000400982 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  400982:	1141                	addi	sp,sp,-16
  400984:	e406                	sd	ra,8(sp)
  400986:	e022                	sd	s0,0(sp)
  400988:	0800                	addi	s0,sp,16
  extern int main();
  main();
  40098a:	fbfff0ef          	jal	400948 <main>
  exit(0);
  40098e:	4501                	li	a0,0
  400990:	290000ef          	jal	400c20 <exit>

0000000000400994 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  400994:	1141                	addi	sp,sp,-16
  400996:	e406                	sd	ra,8(sp)
  400998:	e022                	sd	s0,0(sp)
  40099a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40099c:	87aa                	mv	a5,a0
  40099e:	0585                	addi	a1,a1,1
  4009a0:	0785                	addi	a5,a5,1
  4009a2:	fff5c703          	lbu	a4,-1(a1)
  4009a6:	fee78fa3          	sb	a4,-1(a5)
  4009aa:	fb75                	bnez	a4,40099e <strcpy+0xa>
    ;
  return os;
}
  4009ac:	60a2                	ld	ra,8(sp)
  4009ae:	6402                	ld	s0,0(sp)
  4009b0:	0141                	addi	sp,sp,16
  4009b2:	8082                	ret

00000000004009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4009b4:	1141                	addi	sp,sp,-16
  4009b6:	e406                	sd	ra,8(sp)
  4009b8:	e022                	sd	s0,0(sp)
  4009ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4009bc:	00054783          	lbu	a5,0(a0)
  4009c0:	cb91                	beqz	a5,4009d4 <strcmp+0x20>
  4009c2:	0005c703          	lbu	a4,0(a1)
  4009c6:	00f71763          	bne	a4,a5,4009d4 <strcmp+0x20>
    p++, q++;
  4009ca:	0505                	addi	a0,a0,1
  4009cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4009ce:	00054783          	lbu	a5,0(a0)
  4009d2:	fbe5                	bnez	a5,4009c2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  4009d4:	0005c503          	lbu	a0,0(a1)
}
  4009d8:	40a7853b          	subw	a0,a5,a0
  4009dc:	60a2                	ld	ra,8(sp)
  4009de:	6402                	ld	s0,0(sp)
  4009e0:	0141                	addi	sp,sp,16
  4009e2:	8082                	ret

00000000004009e4 <strlen>:

uint
strlen(const char *s)
{
  4009e4:	1141                	addi	sp,sp,-16
  4009e6:	e406                	sd	ra,8(sp)
  4009e8:	e022                	sd	s0,0(sp)
  4009ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4009ec:	00054783          	lbu	a5,0(a0)
  4009f0:	cf99                	beqz	a5,400a0e <strlen+0x2a>
  4009f2:	0505                	addi	a0,a0,1
  4009f4:	87aa                	mv	a5,a0
  4009f6:	86be                	mv	a3,a5
  4009f8:	0785                	addi	a5,a5,1
  4009fa:	fff7c703          	lbu	a4,-1(a5)
  4009fe:	ff65                	bnez	a4,4009f6 <strlen+0x12>
  400a00:	40a6853b          	subw	a0,a3,a0
  400a04:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  400a06:	60a2                	ld	ra,8(sp)
  400a08:	6402                	ld	s0,0(sp)
  400a0a:	0141                	addi	sp,sp,16
  400a0c:	8082                	ret
  for(n = 0; s[n]; n++)
  400a0e:	4501                	li	a0,0
  400a10:	bfdd                	j	400a06 <strlen+0x22>

0000000000400a12 <memset>:

void*
memset(void *dst, int c, uint n)
{
  400a12:	1141                	addi	sp,sp,-16
  400a14:	e406                	sd	ra,8(sp)
  400a16:	e022                	sd	s0,0(sp)
  400a18:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400a1a:	ca19                	beqz	a2,400a30 <memset+0x1e>
  400a1c:	87aa                	mv	a5,a0
  400a1e:	1602                	slli	a2,a2,0x20
  400a20:	9201                	srli	a2,a2,0x20
  400a22:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400a26:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400a2a:	0785                	addi	a5,a5,1
  400a2c:	fee79de3          	bne	a5,a4,400a26 <memset+0x14>
  }
  return dst;
}
  400a30:	60a2                	ld	ra,8(sp)
  400a32:	6402                	ld	s0,0(sp)
  400a34:	0141                	addi	sp,sp,16
  400a36:	8082                	ret

0000000000400a38 <strchr>:

char*
strchr(const char *s, char c)
{
  400a38:	1141                	addi	sp,sp,-16
  400a3a:	e406                	sd	ra,8(sp)
  400a3c:	e022                	sd	s0,0(sp)
  400a3e:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400a40:	00054783          	lbu	a5,0(a0)
  400a44:	cf81                	beqz	a5,400a5c <strchr+0x24>
    if(*s == c)
  400a46:	00f58763          	beq	a1,a5,400a54 <strchr+0x1c>
  for(; *s; s++)
  400a4a:	0505                	addi	a0,a0,1
  400a4c:	00054783          	lbu	a5,0(a0)
  400a50:	fbfd                	bnez	a5,400a46 <strchr+0xe>
      return (char*)s;
  return 0;
  400a52:	4501                	li	a0,0
}
  400a54:	60a2                	ld	ra,8(sp)
  400a56:	6402                	ld	s0,0(sp)
  400a58:	0141                	addi	sp,sp,16
  400a5a:	8082                	ret
  return 0;
  400a5c:	4501                	li	a0,0
  400a5e:	bfdd                	j	400a54 <strchr+0x1c>

0000000000400a60 <gets>:

char*
gets(char *buf, int max)
{
  400a60:	7159                	addi	sp,sp,-112
  400a62:	f486                	sd	ra,104(sp)
  400a64:	f0a2                	sd	s0,96(sp)
  400a66:	eca6                	sd	s1,88(sp)
  400a68:	e8ca                	sd	s2,80(sp)
  400a6a:	e4ce                	sd	s3,72(sp)
  400a6c:	e0d2                	sd	s4,64(sp)
  400a6e:	fc56                	sd	s5,56(sp)
  400a70:	f85a                	sd	s6,48(sp)
  400a72:	f45e                	sd	s7,40(sp)
  400a74:	f062                	sd	s8,32(sp)
  400a76:	ec66                	sd	s9,24(sp)
  400a78:	e86a                	sd	s10,16(sp)
  400a7a:	1880                	addi	s0,sp,112
  400a7c:	8caa                	mv	s9,a0
  400a7e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400a80:	892a                	mv	s2,a0
  400a82:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400a84:	f9f40b13          	addi	s6,s0,-97
  400a88:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400a8a:	4ba9                	li	s7,10
  400a8c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400a8e:	8d26                	mv	s10,s1
  400a90:	0014899b          	addiw	s3,s1,1
  400a94:	84ce                	mv	s1,s3
  400a96:	0349d563          	bge	s3,s4,400ac0 <gets+0x60>
    cc = read(0, &c, 1);
  400a9a:	8656                	mv	a2,s5
  400a9c:	85da                	mv	a1,s6
  400a9e:	4501                	li	a0,0
  400aa0:	198000ef          	jal	400c38 <read>
    if(cc < 1)
  400aa4:	00a05e63          	blez	a0,400ac0 <gets+0x60>
    buf[i++] = c;
  400aa8:	f9f44783          	lbu	a5,-97(s0)
  400aac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400ab0:	01778763          	beq	a5,s7,400abe <gets+0x5e>
  400ab4:	0905                	addi	s2,s2,1
  400ab6:	fd879ce3          	bne	a5,s8,400a8e <gets+0x2e>
    buf[i++] = c;
  400aba:	8d4e                	mv	s10,s3
  400abc:	a011                	j	400ac0 <gets+0x60>
  400abe:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  400ac0:	9d66                	add	s10,s10,s9
  400ac2:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400ac6:	8566                	mv	a0,s9
  400ac8:	70a6                	ld	ra,104(sp)
  400aca:	7406                	ld	s0,96(sp)
  400acc:	64e6                	ld	s1,88(sp)
  400ace:	6946                	ld	s2,80(sp)
  400ad0:	69a6                	ld	s3,72(sp)
  400ad2:	6a06                	ld	s4,64(sp)
  400ad4:	7ae2                	ld	s5,56(sp)
  400ad6:	7b42                	ld	s6,48(sp)
  400ad8:	7ba2                	ld	s7,40(sp)
  400ada:	7c02                	ld	s8,32(sp)
  400adc:	6ce2                	ld	s9,24(sp)
  400ade:	6d42                	ld	s10,16(sp)
  400ae0:	6165                	addi	sp,sp,112
  400ae2:	8082                	ret

0000000000400ae4 <stat>:

int
stat(const char *n, struct stat *st)
{
  400ae4:	1101                	addi	sp,sp,-32
  400ae6:	ec06                	sd	ra,24(sp)
  400ae8:	e822                	sd	s0,16(sp)
  400aea:	e04a                	sd	s2,0(sp)
  400aec:	1000                	addi	s0,sp,32
  400aee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  400af0:	4581                	li	a1,0
  400af2:	16e000ef          	jal	400c60 <open>
  if(fd < 0)
  400af6:	02054263          	bltz	a0,400b1a <stat+0x36>
  400afa:	e426                	sd	s1,8(sp)
  400afc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  400afe:	85ca                	mv	a1,s2
  400b00:	178000ef          	jal	400c78 <fstat>
  400b04:	892a                	mv	s2,a0
  close(fd);
  400b06:	8526                	mv	a0,s1
  400b08:	140000ef          	jal	400c48 <close>
  return r;
  400b0c:	64a2                	ld	s1,8(sp)
}
  400b0e:	854a                	mv	a0,s2
  400b10:	60e2                	ld	ra,24(sp)
  400b12:	6442                	ld	s0,16(sp)
  400b14:	6902                	ld	s2,0(sp)
  400b16:	6105                	addi	sp,sp,32
  400b18:	8082                	ret
    return -1;
  400b1a:	597d                	li	s2,-1
  400b1c:	bfcd                	j	400b0e <stat+0x2a>

0000000000400b1e <atoi>:

int
atoi(const char *s)
{
  400b1e:	1141                	addi	sp,sp,-16
  400b20:	e406                	sd	ra,8(sp)
  400b22:	e022                	sd	s0,0(sp)
  400b24:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400b26:	00054683          	lbu	a3,0(a0)
  400b2a:	fd06879b          	addiw	a5,a3,-48
  400b2e:	0ff7f793          	zext.b	a5,a5
  400b32:	4625                	li	a2,9
  400b34:	02f66963          	bltu	a2,a5,400b66 <atoi+0x48>
  400b38:	872a                	mv	a4,a0
  n = 0;
  400b3a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400b3c:	0705                	addi	a4,a4,1
  400b3e:	0025179b          	slliw	a5,a0,0x2
  400b42:	9fa9                	addw	a5,a5,a0
  400b44:	0017979b          	slliw	a5,a5,0x1
  400b48:	9fb5                	addw	a5,a5,a3
  400b4a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400b4e:	00074683          	lbu	a3,0(a4)
  400b52:	fd06879b          	addiw	a5,a3,-48
  400b56:	0ff7f793          	zext.b	a5,a5
  400b5a:	fef671e3          	bgeu	a2,a5,400b3c <atoi+0x1e>
  return n;
}
  400b5e:	60a2                	ld	ra,8(sp)
  400b60:	6402                	ld	s0,0(sp)
  400b62:	0141                	addi	sp,sp,16
  400b64:	8082                	ret
  n = 0;
  400b66:	4501                	li	a0,0
  400b68:	bfdd                	j	400b5e <atoi+0x40>

0000000000400b6a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400b6a:	1141                	addi	sp,sp,-16
  400b6c:	e406                	sd	ra,8(sp)
  400b6e:	e022                	sd	s0,0(sp)
  400b70:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400b72:	02b57563          	bgeu	a0,a1,400b9c <memmove+0x32>
    while(n-- > 0)
  400b76:	00c05f63          	blez	a2,400b94 <memmove+0x2a>
  400b7a:	1602                	slli	a2,a2,0x20
  400b7c:	9201                	srli	a2,a2,0x20
  400b7e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400b82:	872a                	mv	a4,a0
      *dst++ = *src++;
  400b84:	0585                	addi	a1,a1,1
  400b86:	0705                	addi	a4,a4,1
  400b88:	fff5c683          	lbu	a3,-1(a1)
  400b8c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400b90:	fee79ae3          	bne	a5,a4,400b84 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400b94:	60a2                	ld	ra,8(sp)
  400b96:	6402                	ld	s0,0(sp)
  400b98:	0141                	addi	sp,sp,16
  400b9a:	8082                	ret
    dst += n;
  400b9c:	00c50733          	add	a4,a0,a2
    src += n;
  400ba0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400ba2:	fec059e3          	blez	a2,400b94 <memmove+0x2a>
  400ba6:	fff6079b          	addiw	a5,a2,-1
  400baa:	1782                	slli	a5,a5,0x20
  400bac:	9381                	srli	a5,a5,0x20
  400bae:	fff7c793          	not	a5,a5
  400bb2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400bb4:	15fd                	addi	a1,a1,-1
  400bb6:	177d                	addi	a4,a4,-1
  400bb8:	0005c683          	lbu	a3,0(a1)
  400bbc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  400bc0:	fef71ae3          	bne	a4,a5,400bb4 <memmove+0x4a>
  400bc4:	bfc1                	j	400b94 <memmove+0x2a>

0000000000400bc6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400bc6:	1141                	addi	sp,sp,-16
  400bc8:	e406                	sd	ra,8(sp)
  400bca:	e022                	sd	s0,0(sp)
  400bcc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  400bce:	ca0d                	beqz	a2,400c00 <memcmp+0x3a>
  400bd0:	fff6069b          	addiw	a3,a2,-1
  400bd4:	1682                	slli	a3,a3,0x20
  400bd6:	9281                	srli	a3,a3,0x20
  400bd8:	0685                	addi	a3,a3,1
  400bda:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  400bdc:	00054783          	lbu	a5,0(a0)
  400be0:	0005c703          	lbu	a4,0(a1)
  400be4:	00e79863          	bne	a5,a4,400bf4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  400be8:	0505                	addi	a0,a0,1
    p2++;
  400bea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  400bec:	fed518e3          	bne	a0,a3,400bdc <memcmp+0x16>
  }
  return 0;
  400bf0:	4501                	li	a0,0
  400bf2:	a019                	j	400bf8 <memcmp+0x32>
      return *p1 - *p2;
  400bf4:	40e7853b          	subw	a0,a5,a4
}
  400bf8:	60a2                	ld	ra,8(sp)
  400bfa:	6402                	ld	s0,0(sp)
  400bfc:	0141                	addi	sp,sp,16
  400bfe:	8082                	ret
  return 0;
  400c00:	4501                	li	a0,0
  400c02:	bfdd                	j	400bf8 <memcmp+0x32>

0000000000400c04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  400c04:	1141                	addi	sp,sp,-16
  400c06:	e406                	sd	ra,8(sp)
  400c08:	e022                	sd	s0,0(sp)
  400c0a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400c0c:	f5fff0ef          	jal	400b6a <memmove>
}
  400c10:	60a2                	ld	ra,8(sp)
  400c12:	6402                	ld	s0,0(sp)
  400c14:	0141                	addi	sp,sp,16
  400c16:	8082                	ret

0000000000400c18 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  400c18:	4885                	li	a7,1
 ecall
  400c1a:	00000073          	ecall
 ret
  400c1e:	8082                	ret

0000000000400c20 <exit>:
.global exit
exit:
 li a7, SYS_exit
  400c20:	4889                	li	a7,2
 ecall
  400c22:	00000073          	ecall
 ret
  400c26:	8082                	ret

0000000000400c28 <wait>:
.global wait
wait:
 li a7, SYS_wait
  400c28:	488d                	li	a7,3
 ecall
  400c2a:	00000073          	ecall
 ret
  400c2e:	8082                	ret

0000000000400c30 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400c30:	4891                	li	a7,4
 ecall
  400c32:	00000073          	ecall
 ret
  400c36:	8082                	ret

0000000000400c38 <read>:
.global read
read:
 li a7, SYS_read
  400c38:	4895                	li	a7,5
 ecall
  400c3a:	00000073          	ecall
 ret
  400c3e:	8082                	ret

0000000000400c40 <write>:
.global write
write:
 li a7, SYS_write
  400c40:	48c1                	li	a7,16
 ecall
  400c42:	00000073          	ecall
 ret
  400c46:	8082                	ret

0000000000400c48 <close>:
.global close
close:
 li a7, SYS_close
  400c48:	48d5                	li	a7,21
 ecall
  400c4a:	00000073          	ecall
 ret
  400c4e:	8082                	ret

0000000000400c50 <kill>:
.global kill
kill:
 li a7, SYS_kill
  400c50:	4899                	li	a7,6
 ecall
  400c52:	00000073          	ecall
 ret
  400c56:	8082                	ret

0000000000400c58 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400c58:	489d                	li	a7,7
 ecall
  400c5a:	00000073          	ecall
 ret
  400c5e:	8082                	ret

0000000000400c60 <open>:
.global open
open:
 li a7, SYS_open
  400c60:	48bd                	li	a7,15
 ecall
  400c62:	00000073          	ecall
 ret
  400c66:	8082                	ret

0000000000400c68 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400c68:	48c5                	li	a7,17
 ecall
  400c6a:	00000073          	ecall
 ret
  400c6e:	8082                	ret

0000000000400c70 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400c70:	48c9                	li	a7,18
 ecall
  400c72:	00000073          	ecall
 ret
  400c76:	8082                	ret

0000000000400c78 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  400c78:	48a1                	li	a7,8
 ecall
  400c7a:	00000073          	ecall
 ret
  400c7e:	8082                	ret

0000000000400c80 <link>:
.global link
link:
 li a7, SYS_link
  400c80:	48cd                	li	a7,19
 ecall
  400c82:	00000073          	ecall
 ret
  400c86:	8082                	ret

0000000000400c88 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400c88:	48d1                	li	a7,20
 ecall
  400c8a:	00000073          	ecall
 ret
  400c8e:	8082                	ret

0000000000400c90 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400c90:	48a5                	li	a7,9
 ecall
  400c92:	00000073          	ecall
 ret
  400c96:	8082                	ret

0000000000400c98 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400c98:	48a9                	li	a7,10
 ecall
  400c9a:	00000073          	ecall
 ret
  400c9e:	8082                	ret

0000000000400ca0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400ca0:	48ad                	li	a7,11
 ecall
  400ca2:	00000073          	ecall
 ret
  400ca6:	8082                	ret

0000000000400ca8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  400ca8:	48b1                	li	a7,12
 ecall
  400caa:	00000073          	ecall
 ret
  400cae:	8082                	ret

0000000000400cb0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400cb0:	48b5                	li	a7,13
 ecall
  400cb2:	00000073          	ecall
 ret
  400cb6:	8082                	ret

0000000000400cb8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  400cb8:	48b9                	li	a7,14
 ecall
  400cba:	00000073          	ecall
 ret
  400cbe:	8082                	ret

0000000000400cc0 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  400cc0:	48d9                	li	a7,22
 ecall
  400cc2:	00000073          	ecall
 ret
  400cc6:	8082                	ret

0000000000400cc8 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  400cc8:	48dd                	li	a7,23
 ecall
  400cca:	00000073          	ecall
 ret
  400cce:	8082                	ret

0000000000400cd0 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  400cd0:	48e1                	li	a7,24
 ecall
  400cd2:	00000073          	ecall
 ret
  400cd6:	8082                	ret

0000000000400cd8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  400cd8:	1101                	addi	sp,sp,-32
  400cda:	ec06                	sd	ra,24(sp)
  400cdc:	e822                	sd	s0,16(sp)
  400cde:	1000                	addi	s0,sp,32
  400ce0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  400ce4:	4605                	li	a2,1
  400ce6:	fef40593          	addi	a1,s0,-17
  400cea:	f57ff0ef          	jal	400c40 <write>
}
  400cee:	60e2                	ld	ra,24(sp)
  400cf0:	6442                	ld	s0,16(sp)
  400cf2:	6105                	addi	sp,sp,32
  400cf4:	8082                	ret

0000000000400cf6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  400cf6:	7139                	addi	sp,sp,-64
  400cf8:	fc06                	sd	ra,56(sp)
  400cfa:	f822                	sd	s0,48(sp)
  400cfc:	f426                	sd	s1,40(sp)
  400cfe:	f04a                	sd	s2,32(sp)
  400d00:	ec4e                	sd	s3,24(sp)
  400d02:	0080                	addi	s0,sp,64
  400d04:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  400d06:	c299                	beqz	a3,400d0c <printint+0x16>
  400d08:	0605ce63          	bltz	a1,400d84 <printint+0x8e>
  neg = 0;
  400d0c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400d0e:	fc040313          	addi	t1,s0,-64
  neg = 0;
  400d12:	869a                	mv	a3,t1
  i = 0;
  400d14:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  400d16:	00001817          	auipc	a6,0x1
  400d1a:	84a80813          	addi	a6,a6,-1974 # 401560 <digits>
  400d1e:	88be                	mv	a7,a5
  400d20:	0017851b          	addiw	a0,a5,1
  400d24:	87aa                	mv	a5,a0
  400d26:	02c5f73b          	remuw	a4,a1,a2
  400d2a:	1702                	slli	a4,a4,0x20
  400d2c:	9301                	srli	a4,a4,0x20
  400d2e:	9742                	add	a4,a4,a6
  400d30:	00074703          	lbu	a4,0(a4)
  400d34:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400d38:	872e                	mv	a4,a1
  400d3a:	02c5d5bb          	divuw	a1,a1,a2
  400d3e:	0685                	addi	a3,a3,1
  400d40:	fcc77fe3          	bgeu	a4,a2,400d1e <printint+0x28>
  if(neg)
  400d44:	000e0c63          	beqz	t3,400d5c <printint+0x66>
    buf[i++] = '-';
  400d48:	fd050793          	addi	a5,a0,-48
  400d4c:	00878533          	add	a0,a5,s0
  400d50:	02d00793          	li	a5,45
  400d54:	fef50823          	sb	a5,-16(a0)
  400d58:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400d5c:	fff7899b          	addiw	s3,a5,-1
  400d60:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400d64:	fff4c583          	lbu	a1,-1(s1)
  400d68:	854a                	mv	a0,s2
  400d6a:	f6fff0ef          	jal	400cd8 <putc>
  while(--i >= 0)
  400d6e:	39fd                	addiw	s3,s3,-1
  400d70:	14fd                	addi	s1,s1,-1
  400d72:	fe09d9e3          	bgez	s3,400d64 <printint+0x6e>
}
  400d76:	70e2                	ld	ra,56(sp)
  400d78:	7442                	ld	s0,48(sp)
  400d7a:	74a2                	ld	s1,40(sp)
  400d7c:	7902                	ld	s2,32(sp)
  400d7e:	69e2                	ld	s3,24(sp)
  400d80:	6121                	addi	sp,sp,64
  400d82:	8082                	ret
    x = -xx;
  400d84:	40b005bb          	negw	a1,a1
    neg = 1;
  400d88:	4e05                	li	t3,1
    x = -xx;
  400d8a:	b751                	j	400d0e <printint+0x18>

0000000000400d8c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400d8c:	711d                	addi	sp,sp,-96
  400d8e:	ec86                	sd	ra,88(sp)
  400d90:	e8a2                	sd	s0,80(sp)
  400d92:	e4a6                	sd	s1,72(sp)
  400d94:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400d96:	0005c483          	lbu	s1,0(a1)
  400d9a:	26048663          	beqz	s1,401006 <vprintf+0x27a>
  400d9e:	e0ca                	sd	s2,64(sp)
  400da0:	fc4e                	sd	s3,56(sp)
  400da2:	f852                	sd	s4,48(sp)
  400da4:	f456                	sd	s5,40(sp)
  400da6:	f05a                	sd	s6,32(sp)
  400da8:	ec5e                	sd	s7,24(sp)
  400daa:	e862                	sd	s8,16(sp)
  400dac:	e466                	sd	s9,8(sp)
  400dae:	8b2a                	mv	s6,a0
  400db0:	8a2e                	mv	s4,a1
  400db2:	8bb2                	mv	s7,a2
  state = 0;
  400db4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400db6:	4901                	li	s2,0
  400db8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  400dba:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  400dbe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  400dc2:	06c00c93          	li	s9,108
  400dc6:	a00d                	j	400de8 <vprintf+0x5c>
        putc(fd, c0);
  400dc8:	85a6                	mv	a1,s1
  400dca:	855a                	mv	a0,s6
  400dcc:	f0dff0ef          	jal	400cd8 <putc>
  400dd0:	a019                	j	400dd6 <vprintf+0x4a>
    } else if(state == '%'){
  400dd2:	03598363          	beq	s3,s5,400df8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  400dd6:	0019079b          	addiw	a5,s2,1
  400dda:	893e                	mv	s2,a5
  400ddc:	873e                	mv	a4,a5
  400dde:	97d2                	add	a5,a5,s4
  400de0:	0007c483          	lbu	s1,0(a5)
  400de4:	20048963          	beqz	s1,400ff6 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  400de8:	0004879b          	sext.w	a5,s1
    if(state == 0){
  400dec:	fe0993e3          	bnez	s3,400dd2 <vprintf+0x46>
      if(c0 == '%'){
  400df0:	fd579ce3          	bne	a5,s5,400dc8 <vprintf+0x3c>
        state = '%';
  400df4:	89be                	mv	s3,a5
  400df6:	b7c5                	j	400dd6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  400df8:	00ea06b3          	add	a3,s4,a4
  400dfc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  400e00:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  400e02:	c681                	beqz	a3,400e0a <vprintf+0x7e>
  400e04:	9752                	add	a4,a4,s4
  400e06:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  400e0a:	03878e63          	beq	a5,s8,400e46 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400e0e:	05978863          	beq	a5,s9,400e5e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  400e12:	07500713          	li	a4,117
  400e16:	0ee78263          	beq	a5,a4,400efa <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400e1a:	07800713          	li	a4,120
  400e1e:	12e78463          	beq	a5,a4,400f46 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400e22:	07000713          	li	a4,112
  400e26:	14e78963          	beq	a5,a4,400f78 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400e2a:	07300713          	li	a4,115
  400e2e:	18e78863          	beq	a5,a4,400fbe <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400e32:	02500713          	li	a4,37
  400e36:	04e79463          	bne	a5,a4,400e7e <vprintf+0xf2>
        putc(fd, '%');
  400e3a:	85ba                	mv	a1,a4
  400e3c:	855a                	mv	a0,s6
  400e3e:	e9bff0ef          	jal	400cd8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400e42:	4981                	li	s3,0
  400e44:	bf49                	j	400dd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400e46:	008b8493          	addi	s1,s7,8
  400e4a:	4685                	li	a3,1
  400e4c:	4629                	li	a2,10
  400e4e:	000ba583          	lw	a1,0(s7)
  400e52:	855a                	mv	a0,s6
  400e54:	ea3ff0ef          	jal	400cf6 <printint>
  400e58:	8ba6                	mv	s7,s1
      state = 0;
  400e5a:	4981                	li	s3,0
  400e5c:	bfad                	j	400dd6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400e5e:	06400793          	li	a5,100
  400e62:	02f68963          	beq	a3,a5,400e94 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400e66:	06c00793          	li	a5,108
  400e6a:	04f68263          	beq	a3,a5,400eae <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400e6e:	07500793          	li	a5,117
  400e72:	0af68063          	beq	a3,a5,400f12 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400e76:	07800793          	li	a5,120
  400e7a:	0ef68263          	beq	a3,a5,400f5e <vprintf+0x1d2>
        putc(fd, '%');
  400e7e:	02500593          	li	a1,37
  400e82:	855a                	mv	a0,s6
  400e84:	e55ff0ef          	jal	400cd8 <putc>
        putc(fd, c0);
  400e88:	85a6                	mv	a1,s1
  400e8a:	855a                	mv	a0,s6
  400e8c:	e4dff0ef          	jal	400cd8 <putc>
      state = 0;
  400e90:	4981                	li	s3,0
  400e92:	b791                	j	400dd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400e94:	008b8493          	addi	s1,s7,8
  400e98:	4685                	li	a3,1
  400e9a:	4629                	li	a2,10
  400e9c:	000ba583          	lw	a1,0(s7)
  400ea0:	855a                	mv	a0,s6
  400ea2:	e55ff0ef          	jal	400cf6 <printint>
        i += 1;
  400ea6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  400ea8:	8ba6                	mv	s7,s1
      state = 0;
  400eaa:	4981                	li	s3,0
        i += 1;
  400eac:	b72d                	j	400dd6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400eae:	06400793          	li	a5,100
  400eb2:	02f60763          	beq	a2,a5,400ee0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400eb6:	07500793          	li	a5,117
  400eba:	06f60963          	beq	a2,a5,400f2c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  400ebe:	07800793          	li	a5,120
  400ec2:	faf61ee3          	bne	a2,a5,400e7e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400ec6:	008b8493          	addi	s1,s7,8
  400eca:	4681                	li	a3,0
  400ecc:	4641                	li	a2,16
  400ece:	000ba583          	lw	a1,0(s7)
  400ed2:	855a                	mv	a0,s6
  400ed4:	e23ff0ef          	jal	400cf6 <printint>
        i += 2;
  400ed8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  400eda:	8ba6                	mv	s7,s1
      state = 0;
  400edc:	4981                	li	s3,0
        i += 2;
  400ede:	bde5                	j	400dd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400ee0:	008b8493          	addi	s1,s7,8
  400ee4:	4685                	li	a3,1
  400ee6:	4629                	li	a2,10
  400ee8:	000ba583          	lw	a1,0(s7)
  400eec:	855a                	mv	a0,s6
  400eee:	e09ff0ef          	jal	400cf6 <printint>
        i += 2;
  400ef2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  400ef4:	8ba6                	mv	s7,s1
      state = 0;
  400ef6:	4981                	li	s3,0
        i += 2;
  400ef8:	bdf9                	j	400dd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  400efa:	008b8493          	addi	s1,s7,8
  400efe:	4681                	li	a3,0
  400f00:	4629                	li	a2,10
  400f02:	000ba583          	lw	a1,0(s7)
  400f06:	855a                	mv	a0,s6
  400f08:	defff0ef          	jal	400cf6 <printint>
  400f0c:	8ba6                	mv	s7,s1
      state = 0;
  400f0e:	4981                	li	s3,0
  400f10:	b5d9                	j	400dd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400f12:	008b8493          	addi	s1,s7,8
  400f16:	4681                	li	a3,0
  400f18:	4629                	li	a2,10
  400f1a:	000ba583          	lw	a1,0(s7)
  400f1e:	855a                	mv	a0,s6
  400f20:	dd7ff0ef          	jal	400cf6 <printint>
        i += 1;
  400f24:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400f26:	8ba6                	mv	s7,s1
      state = 0;
  400f28:	4981                	li	s3,0
        i += 1;
  400f2a:	b575                	j	400dd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400f2c:	008b8493          	addi	s1,s7,8
  400f30:	4681                	li	a3,0
  400f32:	4629                	li	a2,10
  400f34:	000ba583          	lw	a1,0(s7)
  400f38:	855a                	mv	a0,s6
  400f3a:	dbdff0ef          	jal	400cf6 <printint>
        i += 2;
  400f3e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400f40:	8ba6                	mv	s7,s1
      state = 0;
  400f42:	4981                	li	s3,0
        i += 2;
  400f44:	bd49                	j	400dd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400f46:	008b8493          	addi	s1,s7,8
  400f4a:	4681                	li	a3,0
  400f4c:	4641                	li	a2,16
  400f4e:	000ba583          	lw	a1,0(s7)
  400f52:	855a                	mv	a0,s6
  400f54:	da3ff0ef          	jal	400cf6 <printint>
  400f58:	8ba6                	mv	s7,s1
      state = 0;
  400f5a:	4981                	li	s3,0
  400f5c:	bdad                	j	400dd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400f5e:	008b8493          	addi	s1,s7,8
  400f62:	4681                	li	a3,0
  400f64:	4641                	li	a2,16
  400f66:	000ba583          	lw	a1,0(s7)
  400f6a:	855a                	mv	a0,s6
  400f6c:	d8bff0ef          	jal	400cf6 <printint>
        i += 1;
  400f70:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400f72:	8ba6                	mv	s7,s1
      state = 0;
  400f74:	4981                	li	s3,0
        i += 1;
  400f76:	b585                	j	400dd6 <vprintf+0x4a>
  400f78:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  400f7a:	008b8d13          	addi	s10,s7,8
  400f7e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400f82:	03000593          	li	a1,48
  400f86:	855a                	mv	a0,s6
  400f88:	d51ff0ef          	jal	400cd8 <putc>
  putc(fd, 'x');
  400f8c:	07800593          	li	a1,120
  400f90:	855a                	mv	a0,s6
  400f92:	d47ff0ef          	jal	400cd8 <putc>
  400f96:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400f98:	00000b97          	auipc	s7,0x0
  400f9c:	5c8b8b93          	addi	s7,s7,1480 # 401560 <digits>
  400fa0:	03c9d793          	srli	a5,s3,0x3c
  400fa4:	97de                	add	a5,a5,s7
  400fa6:	0007c583          	lbu	a1,0(a5)
  400faa:	855a                	mv	a0,s6
  400fac:	d2dff0ef          	jal	400cd8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400fb0:	0992                	slli	s3,s3,0x4
  400fb2:	34fd                	addiw	s1,s1,-1
  400fb4:	f4f5                	bnez	s1,400fa0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400fb6:	8bea                	mv	s7,s10
      state = 0;
  400fb8:	4981                	li	s3,0
  400fba:	6d02                	ld	s10,0(sp)
  400fbc:	bd29                	j	400dd6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  400fbe:	008b8993          	addi	s3,s7,8
  400fc2:	000bb483          	ld	s1,0(s7)
  400fc6:	cc91                	beqz	s1,400fe2 <vprintf+0x256>
        for(; *s; s++)
  400fc8:	0004c583          	lbu	a1,0(s1)
  400fcc:	c195                	beqz	a1,400ff0 <vprintf+0x264>
          putc(fd, *s);
  400fce:	855a                	mv	a0,s6
  400fd0:	d09ff0ef          	jal	400cd8 <putc>
        for(; *s; s++)
  400fd4:	0485                	addi	s1,s1,1
  400fd6:	0004c583          	lbu	a1,0(s1)
  400fda:	f9f5                	bnez	a1,400fce <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400fdc:	8bce                	mv	s7,s3
      state = 0;
  400fde:	4981                	li	s3,0
  400fe0:	bbdd                	j	400dd6 <vprintf+0x4a>
          s = "(null)";
  400fe2:	00000497          	auipc	s1,0x0
  400fe6:	51648493          	addi	s1,s1,1302 # 4014f8 <malloc+0x402>
        for(; *s; s++)
  400fea:	02800593          	li	a1,40
  400fee:	b7c5                	j	400fce <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  400ff0:	8bce                	mv	s7,s3
      state = 0;
  400ff2:	4981                	li	s3,0
  400ff4:	b3cd                	j	400dd6 <vprintf+0x4a>
  400ff6:	6906                	ld	s2,64(sp)
  400ff8:	79e2                	ld	s3,56(sp)
  400ffa:	7a42                	ld	s4,48(sp)
  400ffc:	7aa2                	ld	s5,40(sp)
  400ffe:	7b02                	ld	s6,32(sp)
  401000:	6be2                	ld	s7,24(sp)
  401002:	6c42                	ld	s8,16(sp)
  401004:	6ca2                	ld	s9,8(sp)
    }
  }
}
  401006:	60e6                	ld	ra,88(sp)
  401008:	6446                	ld	s0,80(sp)
  40100a:	64a6                	ld	s1,72(sp)
  40100c:	6125                	addi	sp,sp,96
  40100e:	8082                	ret

0000000000401010 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  401010:	715d                	addi	sp,sp,-80
  401012:	ec06                	sd	ra,24(sp)
  401014:	e822                	sd	s0,16(sp)
  401016:	1000                	addi	s0,sp,32
  401018:	e010                	sd	a2,0(s0)
  40101a:	e414                	sd	a3,8(s0)
  40101c:	e818                	sd	a4,16(s0)
  40101e:	ec1c                	sd	a5,24(s0)
  401020:	03043023          	sd	a6,32(s0)
  401024:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  401028:	8622                	mv	a2,s0
  40102a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  40102e:	d5fff0ef          	jal	400d8c <vprintf>
  return 0;
}
  401032:	4501                	li	a0,0
  401034:	60e2                	ld	ra,24(sp)
  401036:	6442                	ld	s0,16(sp)
  401038:	6161                	addi	sp,sp,80
  40103a:	8082                	ret

000000000040103c <printf>:

int
printf(const char *fmt, ...)
{
  40103c:	711d                	addi	sp,sp,-96
  40103e:	ec06                	sd	ra,24(sp)
  401040:	e822                	sd	s0,16(sp)
  401042:	1000                	addi	s0,sp,32
  401044:	e40c                	sd	a1,8(s0)
  401046:	e810                	sd	a2,16(s0)
  401048:	ec14                	sd	a3,24(s0)
  40104a:	f018                	sd	a4,32(s0)
  40104c:	f41c                	sd	a5,40(s0)
  40104e:	03043823          	sd	a6,48(s0)
  401052:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  401056:	00840613          	addi	a2,s0,8
  40105a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  40105e:	85aa                	mv	a1,a0
  401060:	4505                	li	a0,1
  401062:	d2bff0ef          	jal	400d8c <vprintf>
  return 0;
}
  401066:	4501                	li	a0,0
  401068:	60e2                	ld	ra,24(sp)
  40106a:	6442                	ld	s0,16(sp)
  40106c:	6125                	addi	sp,sp,96
  40106e:	8082                	ret

0000000000401070 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  401070:	1141                	addi	sp,sp,-16
  401072:	e406                	sd	ra,8(sp)
  401074:	e022                	sd	s0,0(sp)
  401076:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  401078:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  40107c:	00001797          	auipc	a5,0x1
  401080:	f947b783          	ld	a5,-108(a5) # 402010 <freep>
  401084:	a02d                	j	4010ae <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  401086:	4618                	lw	a4,8(a2)
  401088:	9f2d                	addw	a4,a4,a1
  40108a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  40108e:	6398                	ld	a4,0(a5)
  401090:	6310                	ld	a2,0(a4)
  401092:	a83d                	j	4010d0 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  401094:	ff852703          	lw	a4,-8(a0)
  401098:	9f31                	addw	a4,a4,a2
  40109a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  40109c:	ff053683          	ld	a3,-16(a0)
  4010a0:	a091                	j	4010e4 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4010a2:	6398                	ld	a4,0(a5)
  4010a4:	00e7e463          	bltu	a5,a4,4010ac <free+0x3c>
  4010a8:	00e6ea63          	bltu	a3,a4,4010bc <free+0x4c>
{
  4010ac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4010ae:	fed7fae3          	bgeu	a5,a3,4010a2 <free+0x32>
  4010b2:	6398                	ld	a4,0(a5)
  4010b4:	00e6e463          	bltu	a3,a4,4010bc <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4010b8:	fee7eae3          	bltu	a5,a4,4010ac <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4010bc:	ff852583          	lw	a1,-8(a0)
  4010c0:	6390                	ld	a2,0(a5)
  4010c2:	02059813          	slli	a6,a1,0x20
  4010c6:	01c85713          	srli	a4,a6,0x1c
  4010ca:	9736                	add	a4,a4,a3
  4010cc:	fae60de3          	beq	a2,a4,401086 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4010d0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  4010d4:	4790                	lw	a2,8(a5)
  4010d6:	02061593          	slli	a1,a2,0x20
  4010da:	01c5d713          	srli	a4,a1,0x1c
  4010de:	973e                	add	a4,a4,a5
  4010e0:	fae68ae3          	beq	a3,a4,401094 <free+0x24>
    p->s.ptr = bp->s.ptr;
  4010e4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  4010e6:	00001717          	auipc	a4,0x1
  4010ea:	f2f73523          	sd	a5,-214(a4) # 402010 <freep>
}
  4010ee:	60a2                	ld	ra,8(sp)
  4010f0:	6402                	ld	s0,0(sp)
  4010f2:	0141                	addi	sp,sp,16
  4010f4:	8082                	ret

00000000004010f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  4010f6:	7139                	addi	sp,sp,-64
  4010f8:	fc06                	sd	ra,56(sp)
  4010fa:	f822                	sd	s0,48(sp)
  4010fc:	f04a                	sd	s2,32(sp)
  4010fe:	ec4e                	sd	s3,24(sp)
  401100:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  401102:	02051993          	slli	s3,a0,0x20
  401106:	0209d993          	srli	s3,s3,0x20
  40110a:	09bd                	addi	s3,s3,15
  40110c:	0049d993          	srli	s3,s3,0x4
  401110:	2985                	addiw	s3,s3,1
  401112:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  401114:	00001517          	auipc	a0,0x1
  401118:	efc53503          	ld	a0,-260(a0) # 402010 <freep>
  40111c:	c905                	beqz	a0,40114c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  40111e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  401120:	4798                	lw	a4,8(a5)
  401122:	09377663          	bgeu	a4,s3,4011ae <malloc+0xb8>
  401126:	f426                	sd	s1,40(sp)
  401128:	e852                	sd	s4,16(sp)
  40112a:	e456                	sd	s5,8(sp)
  40112c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  40112e:	8a4e                	mv	s4,s3
  401130:	6705                	lui	a4,0x1
  401132:	00e9f363          	bgeu	s3,a4,401138 <malloc+0x42>
  401136:	6a05                	lui	s4,0x1
  401138:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  40113c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  401140:	00001497          	auipc	s1,0x1
  401144:	ed048493          	addi	s1,s1,-304 # 402010 <freep>
  if(p == (char*)-1)
  401148:	5afd                	li	s5,-1
  40114a:	a83d                	j	401188 <malloc+0x92>
  40114c:	f426                	sd	s1,40(sp)
  40114e:	e852                	sd	s4,16(sp)
  401150:	e456                	sd	s5,8(sp)
  401152:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  401154:	00001797          	auipc	a5,0x1
  401158:	2b478793          	addi	a5,a5,692 # 402408 <base>
  40115c:	00001717          	auipc	a4,0x1
  401160:	eaf73a23          	sd	a5,-332(a4) # 402010 <freep>
  401164:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  401166:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  40116a:	b7d1                	j	40112e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  40116c:	6398                	ld	a4,0(a5)
  40116e:	e118                	sd	a4,0(a0)
  401170:	a899                	j	4011c6 <malloc+0xd0>
  hp->s.size = nu;
  401172:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  401176:	0541                	addi	a0,a0,16
  401178:	ef9ff0ef          	jal	401070 <free>
  return freep;
  40117c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  40117e:	c125                	beqz	a0,4011de <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  401180:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  401182:	4798                	lw	a4,8(a5)
  401184:	03277163          	bgeu	a4,s2,4011a6 <malloc+0xb0>
    if(p == freep)
  401188:	6098                	ld	a4,0(s1)
  40118a:	853e                	mv	a0,a5
  40118c:	fef71ae3          	bne	a4,a5,401180 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  401190:	8552                	mv	a0,s4
  401192:	b17ff0ef          	jal	400ca8 <sbrk>
  if(p == (char*)-1)
  401196:	fd551ee3          	bne	a0,s5,401172 <malloc+0x7c>
        return 0;
  40119a:	4501                	li	a0,0
  40119c:	74a2                	ld	s1,40(sp)
  40119e:	6a42                	ld	s4,16(sp)
  4011a0:	6aa2                	ld	s5,8(sp)
  4011a2:	6b02                	ld	s6,0(sp)
  4011a4:	a03d                	j	4011d2 <malloc+0xdc>
  4011a6:	74a2                	ld	s1,40(sp)
  4011a8:	6a42                	ld	s4,16(sp)
  4011aa:	6aa2                	ld	s5,8(sp)
  4011ac:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  4011ae:	fae90fe3          	beq	s2,a4,40116c <malloc+0x76>
        p->s.size -= nunits;
  4011b2:	4137073b          	subw	a4,a4,s3
  4011b6:	c798                	sw	a4,8(a5)
        p += p->s.size;
  4011b8:	02071693          	slli	a3,a4,0x20
  4011bc:	01c6d713          	srli	a4,a3,0x1c
  4011c0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4011c2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4011c6:	00001717          	auipc	a4,0x1
  4011ca:	e4a73523          	sd	a0,-438(a4) # 402010 <freep>
      return (void*)(p + 1);
  4011ce:	01078513          	addi	a0,a5,16
  }
}
  4011d2:	70e2                	ld	ra,56(sp)
  4011d4:	7442                	ld	s0,48(sp)
  4011d6:	7902                	ld	s2,32(sp)
  4011d8:	69e2                	ld	s3,24(sp)
  4011da:	6121                	addi	sp,sp,64
  4011dc:	8082                	ret
  4011de:	74a2                	ld	s1,40(sp)
  4011e0:	6a42                	ld	s4,16(sp)
  4011e2:	6aa2                	ld	s5,8(sp)
  4011e4:	6b02                	ld	s6,0(sp)
  4011e6:	b7f5                	j	4011d2 <malloc+0xdc>
