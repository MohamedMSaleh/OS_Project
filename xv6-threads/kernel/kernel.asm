
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	75013103          	ld	sp,1872(sp) # 8000a750 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda51f>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	e0078793          	addi	a5,a5,-512 # 80000e84 <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a6:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	711d                	addi	sp,sp,-96
    800000d6:	ec86                	sd	ra,88(sp)
    800000d8:	e8a2                	sd	s0,80(sp)
    800000da:	e0ca                	sd	s2,64(sp)
    800000dc:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    800000de:	04c05863          	blez	a2,8000012e <consolewrite+0x5a>
    800000e2:	e4a6                	sd	s1,72(sp)
    800000e4:	fc4e                	sd	s3,56(sp)
    800000e6:	f852                	sd	s4,48(sp)
    800000e8:	f456                	sd	s5,40(sp)
    800000ea:	f05a                	sd	s6,32(sp)
    800000ec:	ec5e                	sd	s7,24(sp)
    800000ee:	8a2a                	mv	s4,a0
    800000f0:	84ae                	mv	s1,a1
    800000f2:	89b2                	mv	s3,a2
    800000f4:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000f6:	faf40b93          	addi	s7,s0,-81
    800000fa:	4b05                	li	s6,1
    800000fc:	5afd                	li	s5,-1
    800000fe:	86da                	mv	a3,s6
    80000100:	8626                	mv	a2,s1
    80000102:	85d2                	mv	a1,s4
    80000104:	855e                	mv	a0,s7
    80000106:	496020ef          	jal	8000259c <either_copyin>
    8000010a:	03550463          	beq	a0,s5,80000132 <consolewrite+0x5e>
      break;
    uartputc(c);
    8000010e:	faf44503          	lbu	a0,-81(s0)
    80000112:	02d000ef          	jal	8000093e <uartputc>
  for(i = 0; i < n; i++){
    80000116:	2905                	addiw	s2,s2,1
    80000118:	0485                	addi	s1,s1,1
    8000011a:	ff2992e3          	bne	s3,s2,800000fe <consolewrite+0x2a>
    8000011e:	894e                	mv	s2,s3
    80000120:	64a6                	ld	s1,72(sp)
    80000122:	79e2                	ld	s3,56(sp)
    80000124:	7a42                	ld	s4,48(sp)
    80000126:	7aa2                	ld	s5,40(sp)
    80000128:	7b02                	ld	s6,32(sp)
    8000012a:	6be2                	ld	s7,24(sp)
    8000012c:	a809                	j	8000013e <consolewrite+0x6a>
    8000012e:	4901                	li	s2,0
    80000130:	a039                	j	8000013e <consolewrite+0x6a>
    80000132:	64a6                	ld	s1,72(sp)
    80000134:	79e2                	ld	s3,56(sp)
    80000136:	7a42                	ld	s4,48(sp)
    80000138:	7aa2                	ld	s5,40(sp)
    8000013a:	7b02                	ld	s6,32(sp)
    8000013c:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60e6                	ld	ra,88(sp)
    80000142:	6446                	ld	s0,80(sp)
    80000144:	6906                	ld	s2,64(sp)
    80000146:	6125                	addi	sp,sp,96
    80000148:	8082                	ret

000000008000014a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000014a:	711d                	addi	sp,sp,-96
    8000014c:	ec86                	sd	ra,88(sp)
    8000014e:	e8a2                	sd	s0,80(sp)
    80000150:	e4a6                	sd	s1,72(sp)
    80000152:	e0ca                	sd	s2,64(sp)
    80000154:	fc4e                	sd	s3,56(sp)
    80000156:	f852                	sd	s4,48(sp)
    80000158:	f456                	sd	s5,40(sp)
    8000015a:	f05a                	sd	s6,32(sp)
    8000015c:	1080                	addi	s0,sp,96
    8000015e:	8aaa                	mv	s5,a0
    80000160:	8a2e                	mv	s4,a1
    80000162:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000164:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80000166:	00012517          	auipc	a0,0x12
    8000016a:	64a50513          	addi	a0,a0,1610 # 800127b0 <cons>
    8000016e:	291000ef          	jal	80000bfe <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000172:	00012497          	auipc	s1,0x12
    80000176:	63e48493          	addi	s1,s1,1598 # 800127b0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000017a:	00012917          	auipc	s2,0x12
    8000017e:	6ce90913          	addi	s2,s2,1742 # 80012848 <cons+0x98>
  while(n > 0){
    80000182:	0b305b63          	blez	s3,80000238 <consoleread+0xee>
    while(cons.r == cons.w){
    80000186:	0984a783          	lw	a5,152(s1)
    8000018a:	09c4a703          	lw	a4,156(s1)
    8000018e:	0af71063          	bne	a4,a5,8000022e <consoleread+0xe4>
      if(killed(myproc())){
    80000192:	74a010ef          	jal	800018dc <myproc>
    80000196:	29e020ef          	jal	80002434 <killed>
    8000019a:	e12d                	bnez	a0,800001fc <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000019c:	85a6                	mv	a1,s1
    8000019e:	854a                	mv	a0,s2
    800001a0:	68f010ef          	jal	8000202e <sleep>
    while(cons.r == cons.w){
    800001a4:	0984a783          	lw	a5,152(s1)
    800001a8:	09c4a703          	lw	a4,156(s1)
    800001ac:	fef703e3          	beq	a4,a5,80000192 <consoleread+0x48>
    800001b0:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001b2:	00012717          	auipc	a4,0x12
    800001b6:	5fe70713          	addi	a4,a4,1534 # 800127b0 <cons>
    800001ba:	0017869b          	addiw	a3,a5,1
    800001be:	08d72c23          	sw	a3,152(a4)
    800001c2:	07f7f693          	andi	a3,a5,127
    800001c6:	9736                	add	a4,a4,a3
    800001c8:	01874703          	lbu	a4,24(a4)
    800001cc:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001d0:	4691                	li	a3,4
    800001d2:	04db8663          	beq	s7,a3,8000021e <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001d6:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001da:	4685                	li	a3,1
    800001dc:	faf40613          	addi	a2,s0,-81
    800001e0:	85d2                	mv	a1,s4
    800001e2:	8556                	mv	a0,s5
    800001e4:	36e020ef          	jal	80002552 <either_copyout>
    800001e8:	57fd                	li	a5,-1
    800001ea:	04f50663          	beq	a0,a5,80000236 <consoleread+0xec>
      break;

    dst++;
    800001ee:	0a05                	addi	s4,s4,1
    --n;
    800001f0:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001f2:	47a9                	li	a5,10
    800001f4:	04fb8b63          	beq	s7,a5,8000024a <consoleread+0x100>
    800001f8:	6be2                	ld	s7,24(sp)
    800001fa:	b761                	j	80000182 <consoleread+0x38>
        release(&cons.lock);
    800001fc:	00012517          	auipc	a0,0x12
    80000200:	5b450513          	addi	a0,a0,1460 # 800127b0 <cons>
    80000204:	28f000ef          	jal	80000c92 <release>
        return -1;
    80000208:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000020a:	60e6                	ld	ra,88(sp)
    8000020c:	6446                	ld	s0,80(sp)
    8000020e:	64a6                	ld	s1,72(sp)
    80000210:	6906                	ld	s2,64(sp)
    80000212:	79e2                	ld	s3,56(sp)
    80000214:	7a42                	ld	s4,48(sp)
    80000216:	7aa2                	ld	s5,40(sp)
    80000218:	7b02                	ld	s6,32(sp)
    8000021a:	6125                	addi	sp,sp,96
    8000021c:	8082                	ret
      if(n < target){
    8000021e:	0169fa63          	bgeu	s3,s6,80000232 <consoleread+0xe8>
        cons.r--;
    80000222:	00012717          	auipc	a4,0x12
    80000226:	62f72323          	sw	a5,1574(a4) # 80012848 <cons+0x98>
    8000022a:	6be2                	ld	s7,24(sp)
    8000022c:	a031                	j	80000238 <consoleread+0xee>
    8000022e:	ec5e                	sd	s7,24(sp)
    80000230:	b749                	j	800001b2 <consoleread+0x68>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	a011                	j	80000238 <consoleread+0xee>
    80000236:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000238:	00012517          	auipc	a0,0x12
    8000023c:	57850513          	addi	a0,a0,1400 # 800127b0 <cons>
    80000240:	253000ef          	jal	80000c92 <release>
  return target - n;
    80000244:	413b053b          	subw	a0,s6,s3
    80000248:	b7c9                	j	8000020a <consoleread+0xc0>
    8000024a:	6be2                	ld	s7,24(sp)
    8000024c:	b7f5                	j	80000238 <consoleread+0xee>

000000008000024e <consputc>:
{
    8000024e:	1141                	addi	sp,sp,-16
    80000250:	e406                	sd	ra,8(sp)
    80000252:	e022                	sd	s0,0(sp)
    80000254:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000256:	10000793          	li	a5,256
    8000025a:	00f50863          	beq	a0,a5,8000026a <consputc+0x1c>
    uartputc_sync(c);
    8000025e:	5fe000ef          	jal	8000085c <uartputc_sync>
}
    80000262:	60a2                	ld	ra,8(sp)
    80000264:	6402                	ld	s0,0(sp)
    80000266:	0141                	addi	sp,sp,16
    80000268:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000026a:	4521                	li	a0,8
    8000026c:	5f0000ef          	jal	8000085c <uartputc_sync>
    80000270:	02000513          	li	a0,32
    80000274:	5e8000ef          	jal	8000085c <uartputc_sync>
    80000278:	4521                	li	a0,8
    8000027a:	5e2000ef          	jal	8000085c <uartputc_sync>
    8000027e:	b7d5                	j	80000262 <consputc+0x14>

0000000080000280 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000280:	7179                	addi	sp,sp,-48
    80000282:	f406                	sd	ra,40(sp)
    80000284:	f022                	sd	s0,32(sp)
    80000286:	ec26                	sd	s1,24(sp)
    80000288:	1800                	addi	s0,sp,48
    8000028a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000028c:	00012517          	auipc	a0,0x12
    80000290:	52450513          	addi	a0,a0,1316 # 800127b0 <cons>
    80000294:	16b000ef          	jal	80000bfe <acquire>

  switch(c){
    80000298:	47d5                	li	a5,21
    8000029a:	08f48e63          	beq	s1,a5,80000336 <consoleintr+0xb6>
    8000029e:	0297c563          	blt	a5,s1,800002c8 <consoleintr+0x48>
    800002a2:	47a1                	li	a5,8
    800002a4:	0ef48863          	beq	s1,a5,80000394 <consoleintr+0x114>
    800002a8:	47c1                	li	a5,16
    800002aa:	10f49963          	bne	s1,a5,800003bc <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    800002ae:	338020ef          	jal	800025e6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	4fe50513          	addi	a0,a0,1278 # 800127b0 <cons>
    800002ba:	1d9000ef          	jal	80000c92 <release>
}
    800002be:	70a2                	ld	ra,40(sp)
    800002c0:	7402                	ld	s0,32(sp)
    800002c2:	64e2                	ld	s1,24(sp)
    800002c4:	6145                	addi	sp,sp,48
    800002c6:	8082                	ret
  switch(c){
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48463          	beq	s1,a5,80000394 <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d0:	00012717          	auipc	a4,0x12
    800002d4:	4e070713          	addi	a4,a4,1248 # 800127b0 <cons>
    800002d8:	0a072783          	lw	a5,160(a4)
    800002dc:	09872703          	lw	a4,152(a4)
    800002e0:	9f99                	subw	a5,a5,a4
    800002e2:	07f00713          	li	a4,127
    800002e6:	fcf766e3          	bltu	a4,a5,800002b2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002ea:	47b5                	li	a5,13
    800002ec:	0cf48b63          	beq	s1,a5,800003c2 <consoleintr+0x142>
      consputc(c);
    800002f0:	8526                	mv	a0,s1
    800002f2:	f5dff0ef          	jal	8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002f6:	00012797          	auipc	a5,0x12
    800002fa:	4ba78793          	addi	a5,a5,1210 # 800127b0 <cons>
    800002fe:	0a07a683          	lw	a3,160(a5)
    80000302:	0016871b          	addiw	a4,a3,1
    80000306:	863a                	mv	a2,a4
    80000308:	0ae7a023          	sw	a4,160(a5)
    8000030c:	07f6f693          	andi	a3,a3,127
    80000310:	97b6                	add	a5,a5,a3
    80000312:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000316:	47a9                	li	a5,10
    80000318:	0cf48963          	beq	s1,a5,800003ea <consoleintr+0x16a>
    8000031c:	4791                	li	a5,4
    8000031e:	0cf48663          	beq	s1,a5,800003ea <consoleintr+0x16a>
    80000322:	00012797          	auipc	a5,0x12
    80000326:	5267a783          	lw	a5,1318(a5) # 80012848 <cons+0x98>
    8000032a:	9f1d                	subw	a4,a4,a5
    8000032c:	08000793          	li	a5,128
    80000330:	f8f711e3          	bne	a4,a5,800002b2 <consoleintr+0x32>
    80000334:	a85d                	j	800003ea <consoleintr+0x16a>
    80000336:	e84a                	sd	s2,16(sp)
    80000338:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	47670713          	addi	a4,a4,1142 # 800127b0 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	46648493          	addi	s1,s1,1126 # 800127b0 <cons>
    while(cons.e != cons.w &&
    80000352:	4929                	li	s2,10
      consputc(BACKSPACE);
    80000354:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80000358:	02f70863          	beq	a4,a5,80000388 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000035c:	37fd                	addiw	a5,a5,-1
    8000035e:	07f7f713          	andi	a4,a5,127
    80000362:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000364:	01874703          	lbu	a4,24(a4)
    80000368:	03270363          	beq	a4,s2,8000038e <consoleintr+0x10e>
      cons.e--;
    8000036c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000370:	854e                	mv	a0,s3
    80000372:	eddff0ef          	jal	8000024e <consputc>
    while(cons.e != cons.w &&
    80000376:	0a04a783          	lw	a5,160(s1)
    8000037a:	09c4a703          	lw	a4,156(s1)
    8000037e:	fcf71fe3          	bne	a4,a5,8000035c <consoleintr+0xdc>
    80000382:	6942                	ld	s2,16(sp)
    80000384:	69a2                	ld	s3,8(sp)
    80000386:	b735                	j	800002b2 <consoleintr+0x32>
    80000388:	6942                	ld	s2,16(sp)
    8000038a:	69a2                	ld	s3,8(sp)
    8000038c:	b71d                	j	800002b2 <consoleintr+0x32>
    8000038e:	6942                	ld	s2,16(sp)
    80000390:	69a2                	ld	s3,8(sp)
    80000392:	b705                	j	800002b2 <consoleintr+0x32>
    if(cons.e != cons.w){
    80000394:	00012717          	auipc	a4,0x12
    80000398:	41c70713          	addi	a4,a4,1052 # 800127b0 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
    800003a4:	f0f707e3          	beq	a4,a5,800002b2 <consoleintr+0x32>
      cons.e--;
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	00012717          	auipc	a4,0x12
    800003ae:	4af72323          	sw	a5,1190(a4) # 80012850 <cons+0xa0>
      consputc(BACKSPACE);
    800003b2:	10000513          	li	a0,256
    800003b6:	e99ff0ef          	jal	8000024e <consputc>
    800003ba:	bde5                	j	800002b2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003bc:	ee048be3          	beqz	s1,800002b2 <consoleintr+0x32>
    800003c0:	bf01                	j	800002d0 <consoleintr+0x50>
      consputc(c);
    800003c2:	4529                	li	a0,10
    800003c4:	e8bff0ef          	jal	8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003c8:	00012797          	auipc	a5,0x12
    800003cc:	3e878793          	addi	a5,a5,1000 # 800127b0 <cons>
    800003d0:	0a07a703          	lw	a4,160(a5)
    800003d4:	0017069b          	addiw	a3,a4,1
    800003d8:	8636                	mv	a2,a3
    800003da:	0ad7a023          	sw	a3,160(a5)
    800003de:	07f77713          	andi	a4,a4,127
    800003e2:	97ba                	add	a5,a5,a4
    800003e4:	4729                	li	a4,10
    800003e6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003ea:	00012797          	auipc	a5,0x12
    800003ee:	46c7a123          	sw	a2,1122(a5) # 8001284c <cons+0x9c>
        wakeup(&cons.r);
    800003f2:	00012517          	auipc	a0,0x12
    800003f6:	45650513          	addi	a0,a0,1110 # 80012848 <cons+0x98>
    800003fa:	5e5010ef          	jal	800021de <wakeup>
    800003fe:	bd55                	j	800002b2 <consoleintr+0x32>

0000000080000400 <consoleinit>:

void
consoleinit(void)
{
    80000400:	1141                	addi	sp,sp,-16
    80000402:	e406                	sd	ra,8(sp)
    80000404:	e022                	sd	s0,0(sp)
    80000406:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000408:	00007597          	auipc	a1,0x7
    8000040c:	bf858593          	addi	a1,a1,-1032 # 80007000 <etext>
    80000410:	00012517          	auipc	a0,0x12
    80000414:	3a050513          	addi	a0,a0,928 # 800127b0 <cons>
    80000418:	762000ef          	jal	80000b7a <initlock>

  uartinit();
    8000041c:	3ea000ef          	jal	80000806 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000420:	00023797          	auipc	a5,0x23
    80000424:	d2878793          	addi	a5,a5,-728 # 80023148 <devsw>
    80000428:	00000717          	auipc	a4,0x0
    8000042c:	d2270713          	addi	a4,a4,-734 # 8000014a <consoleread>
    80000430:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000432:	00000717          	auipc	a4,0x0
    80000436:	ca270713          	addi	a4,a4,-862 # 800000d4 <consolewrite>
    8000043a:	ef98                	sd	a4,24(a5)
}
    8000043c:	60a2                	ld	ra,8(sp)
    8000043e:	6402                	ld	s0,0(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret

0000000080000444 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000444:	7179                	addi	sp,sp,-48
    80000446:	f406                	sd	ra,40(sp)
    80000448:	f022                	sd	s0,32(sp)
    8000044a:	ec26                	sd	s1,24(sp)
    8000044c:	e84a                	sd	s2,16(sp)
    8000044e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000450:	c219                	beqz	a2,80000456 <printint+0x12>
    80000452:	06054a63          	bltz	a0,800004c6 <printint+0x82>
    x = -xx;
  else
    x = xx;
    80000456:	4e01                	li	t3,0

  i = 0;
    80000458:	fd040313          	addi	t1,s0,-48
    x = xx;
    8000045c:	869a                	mv	a3,t1
  i = 0;
    8000045e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000460:	00007817          	auipc	a6,0x7
    80000464:	6a880813          	addi	a6,a6,1704 # 80007b08 <digits>
    80000468:	88be                	mv	a7,a5
    8000046a:	0017861b          	addiw	a2,a5,1
    8000046e:	87b2                	mv	a5,a2
    80000470:	02b57733          	remu	a4,a0,a1
    80000474:	9742                	add	a4,a4,a6
    80000476:	00074703          	lbu	a4,0(a4)
    8000047a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000047e:	872a                	mv	a4,a0
    80000480:	02b55533          	divu	a0,a0,a1
    80000484:	0685                	addi	a3,a3,1
    80000486:	feb771e3          	bgeu	a4,a1,80000468 <printint+0x24>

  if(sign)
    8000048a:	000e0c63          	beqz	t3,800004a2 <printint+0x5e>
    buf[i++] = '-';
    8000048e:	fe060793          	addi	a5,a2,-32
    80000492:	00878633          	add	a2,a5,s0
    80000496:	02d00793          	li	a5,45
    8000049a:	fef60823          	sb	a5,-16(a2)
    8000049e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800004a2:	fff7891b          	addiw	s2,a5,-1
    800004a6:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800004aa:	fff4c503          	lbu	a0,-1(s1)
    800004ae:	da1ff0ef          	jal	8000024e <consputc>
  while(--i >= 0)
    800004b2:	397d                	addiw	s2,s2,-1
    800004b4:	14fd                	addi	s1,s1,-1
    800004b6:	fe095ae3          	bgez	s2,800004aa <printint+0x66>
}
    800004ba:	70a2                	ld	ra,40(sp)
    800004bc:	7402                	ld	s0,32(sp)
    800004be:	64e2                	ld	s1,24(sp)
    800004c0:	6942                	ld	s2,16(sp)
    800004c2:	6145                	addi	sp,sp,48
    800004c4:	8082                	ret
    x = -xx;
    800004c6:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004ca:	4e05                	li	t3,1
    x = -xx;
    800004cc:	b771                	j	80000458 <printint+0x14>

00000000800004ce <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004ce:	7155                	addi	sp,sp,-208
    800004d0:	e506                	sd	ra,136(sp)
    800004d2:	e122                	sd	s0,128(sp)
    800004d4:	f0d2                	sd	s4,96(sp)
    800004d6:	0900                	addi	s0,sp,144
    800004d8:	8a2a                	mv	s4,a0
    800004da:	e40c                	sd	a1,8(s0)
    800004dc:	e810                	sd	a2,16(s0)
    800004de:	ec14                	sd	a3,24(s0)
    800004e0:	f018                	sd	a4,32(s0)
    800004e2:	f41c                	sd	a5,40(s0)
    800004e4:	03043823          	sd	a6,48(s0)
    800004e8:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004ec:	00012797          	auipc	a5,0x12
    800004f0:	3847a783          	lw	a5,900(a5) # 80012870 <pr+0x18>
    800004f4:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004f8:	e3a1                	bnez	a5,80000538 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004fa:	00840793          	addi	a5,s0,8
    800004fe:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000502:	00054503          	lbu	a0,0(a0)
    80000506:	26050663          	beqz	a0,80000772 <printf+0x2a4>
    8000050a:	fca6                	sd	s1,120(sp)
    8000050c:	f8ca                	sd	s2,112(sp)
    8000050e:	f4ce                	sd	s3,104(sp)
    80000510:	ecd6                	sd	s5,88(sp)
    80000512:	e8da                	sd	s6,80(sp)
    80000514:	e0e2                	sd	s8,64(sp)
    80000516:	fc66                	sd	s9,56(sp)
    80000518:	f86a                	sd	s10,48(sp)
    8000051a:	f46e                	sd	s11,40(sp)
    8000051c:	4981                	li	s3,0
    if(cx != '%'){
    8000051e:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000522:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000526:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000052a:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000052e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000532:	07000d93          	li	s11,112
    80000536:	a80d                	j	80000568 <printf+0x9a>
    acquire(&pr.lock);
    80000538:	00012517          	auipc	a0,0x12
    8000053c:	32050513          	addi	a0,a0,800 # 80012858 <pr>
    80000540:	6be000ef          	jal	80000bfe <acquire>
  va_start(ap, fmt);
    80000544:	00840793          	addi	a5,s0,8
    80000548:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054c:	000a4503          	lbu	a0,0(s4)
    80000550:	fd4d                	bnez	a0,8000050a <printf+0x3c>
    80000552:	ac3d                	j	80000790 <printf+0x2c2>
      consputc(cx);
    80000554:	cfbff0ef          	jal	8000024e <consputc>
      continue;
    80000558:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000055a:	2485                	addiw	s1,s1,1
    8000055c:	89a6                	mv	s3,s1
    8000055e:	94d2                	add	s1,s1,s4
    80000560:	0004c503          	lbu	a0,0(s1)
    80000564:	1e050b63          	beqz	a0,8000075a <printf+0x28c>
    if(cx != '%'){
    80000568:	ff5516e3          	bne	a0,s5,80000554 <printf+0x86>
    i++;
    8000056c:	0019879b          	addiw	a5,s3,1
    80000570:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    80000572:	00fa0733          	add	a4,s4,a5
    80000576:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000057a:	1e090063          	beqz	s2,8000075a <printf+0x28c>
    8000057e:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    80000582:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    80000584:	c701                	beqz	a4,8000058c <printf+0xbe>
    80000586:	97d2                	add	a5,a5,s4
    80000588:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    8000058c:	03690763          	beq	s2,s6,800005ba <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80000590:	05890163          	beq	s2,s8,800005d2 <printf+0x104>
    } else if(c0 == 'u'){
    80000594:	0d990b63          	beq	s2,s9,8000066a <printf+0x19c>
    } else if(c0 == 'x'){
    80000598:	13a90163          	beq	s2,s10,800006ba <printf+0x1ec>
    } else if(c0 == 'p'){
    8000059c:	13b90b63          	beq	s2,s11,800006d2 <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005a0:	07300793          	li	a5,115
    800005a4:	16f90a63          	beq	s2,a5,80000718 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005a8:	1b590463          	beq	s2,s5,80000750 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005ac:	8556                	mv	a0,s5
    800005ae:	ca1ff0ef          	jal	8000024e <consputc>
      consputc(c0);
    800005b2:	854a                	mv	a0,s2
    800005b4:	c9bff0ef          	jal	8000024e <consputc>
    800005b8:	b74d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005ba:	f8843783          	ld	a5,-120(s0)
    800005be:	00878713          	addi	a4,a5,8
    800005c2:	f8e43423          	sd	a4,-120(s0)
    800005c6:	4605                	li	a2,1
    800005c8:	45a9                	li	a1,10
    800005ca:	4388                	lw	a0,0(a5)
    800005cc:	e79ff0ef          	jal	80000444 <printint>
    800005d0:	b769                	j	8000055a <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005d2:	03670663          	beq	a4,s6,800005fe <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005d6:	05870263          	beq	a4,s8,8000061a <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    800005da:	0b970463          	beq	a4,s9,80000682 <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    800005de:	fda717e3          	bne	a4,s10,800005ac <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800005e2:	f8843783          	ld	a5,-120(s0)
    800005e6:	00878713          	addi	a4,a5,8
    800005ea:	f8e43423          	sd	a4,-120(s0)
    800005ee:	4601                	li	a2,0
    800005f0:	45c1                	li	a1,16
    800005f2:	6388                	ld	a0,0(a5)
    800005f4:	e51ff0ef          	jal	80000444 <printint>
      i += 1;
    800005f8:	0029849b          	addiw	s1,s3,2
    800005fc:	bfb9                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005fe:	f8843783          	ld	a5,-120(s0)
    80000602:	00878713          	addi	a4,a5,8
    80000606:	f8e43423          	sd	a4,-120(s0)
    8000060a:	4605                	li	a2,1
    8000060c:	45a9                	li	a1,10
    8000060e:	6388                	ld	a0,0(a5)
    80000610:	e35ff0ef          	jal	80000444 <printint>
      i += 1;
    80000614:	0029849b          	addiw	s1,s3,2
    80000618:	b789                	j	8000055a <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000061a:	06400793          	li	a5,100
    8000061e:	02f68863          	beq	a3,a5,8000064e <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000622:	07500793          	li	a5,117
    80000626:	06f68c63          	beq	a3,a5,8000069e <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000062a:	07800793          	li	a5,120
    8000062e:	f6f69fe3          	bne	a3,a5,800005ac <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    80000632:	f8843783          	ld	a5,-120(s0)
    80000636:	00878713          	addi	a4,a5,8
    8000063a:	f8e43423          	sd	a4,-120(s0)
    8000063e:	4601                	li	a2,0
    80000640:	45c1                	li	a1,16
    80000642:	6388                	ld	a0,0(a5)
    80000644:	e01ff0ef          	jal	80000444 <printint>
      i += 2;
    80000648:	0039849b          	addiw	s1,s3,3
    8000064c:	b739                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    8000064e:	f8843783          	ld	a5,-120(s0)
    80000652:	00878713          	addi	a4,a5,8
    80000656:	f8e43423          	sd	a4,-120(s0)
    8000065a:	4605                	li	a2,1
    8000065c:	45a9                	li	a1,10
    8000065e:	6388                	ld	a0,0(a5)
    80000660:	de5ff0ef          	jal	80000444 <printint>
      i += 2;
    80000664:	0039849b          	addiw	s1,s3,3
    80000668:	bdcd                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000066a:	f8843783          	ld	a5,-120(s0)
    8000066e:	00878713          	addi	a4,a5,8
    80000672:	f8e43423          	sd	a4,-120(s0)
    80000676:	4601                	li	a2,0
    80000678:	45a9                	li	a1,10
    8000067a:	4388                	lw	a0,0(a5)
    8000067c:	dc9ff0ef          	jal	80000444 <printint>
    80000680:	bde9                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	addi	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	4601                	li	a2,0
    80000690:	45a9                	li	a1,10
    80000692:	6388                	ld	a0,0(a5)
    80000694:	db1ff0ef          	jal	80000444 <printint>
      i += 1;
    80000698:	0029849b          	addiw	s1,s3,2
    8000069c:	bd7d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	4601                	li	a2,0
    800006ac:	45a9                	li	a1,10
    800006ae:	6388                	ld	a0,0(a5)
    800006b0:	d95ff0ef          	jal	80000444 <printint>
      i += 2;
    800006b4:	0039849b          	addiw	s1,s3,3
    800006b8:	b54d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006ba:	f8843783          	ld	a5,-120(s0)
    800006be:	00878713          	addi	a4,a5,8
    800006c2:	f8e43423          	sd	a4,-120(s0)
    800006c6:	4601                	li	a2,0
    800006c8:	45c1                	li	a1,16
    800006ca:	4388                	lw	a0,0(a5)
    800006cc:	d79ff0ef          	jal	80000444 <printint>
    800006d0:	b569                	j	8000055a <printf+0x8c>
    800006d2:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006d4:	f8843783          	ld	a5,-120(s0)
    800006d8:	00878713          	addi	a4,a5,8
    800006dc:	f8e43423          	sd	a4,-120(s0)
    800006e0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e4:	03000513          	li	a0,48
    800006e8:	b67ff0ef          	jal	8000024e <consputc>
  consputc('x');
    800006ec:	07800513          	li	a0,120
    800006f0:	b5fff0ef          	jal	8000024e <consputc>
    800006f4:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f6:	00007b97          	auipc	s7,0x7
    800006fa:	412b8b93          	addi	s7,s7,1042 # 80007b08 <digits>
    800006fe:	03c9d793          	srli	a5,s3,0x3c
    80000702:	97de                	add	a5,a5,s7
    80000704:	0007c503          	lbu	a0,0(a5)
    80000708:	b47ff0ef          	jal	8000024e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070c:	0992                	slli	s3,s3,0x4
    8000070e:	397d                	addiw	s2,s2,-1
    80000710:	fe0917e3          	bnez	s2,800006fe <printf+0x230>
    80000714:	6ba6                	ld	s7,72(sp)
    80000716:	b591                	j	8000055a <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007b903          	ld	s2,0(a5)
    80000728:	00090d63          	beqz	s2,80000742 <printf+0x274>
      for(; *s; s++)
    8000072c:	00094503          	lbu	a0,0(s2)
    80000730:	e20505e3          	beqz	a0,8000055a <printf+0x8c>
        consputc(*s);
    80000734:	b1bff0ef          	jal	8000024e <consputc>
      for(; *s; s++)
    80000738:	0905                	addi	s2,s2,1
    8000073a:	00094503          	lbu	a0,0(s2)
    8000073e:	f97d                	bnez	a0,80000734 <printf+0x266>
    80000740:	bd29                	j	8000055a <printf+0x8c>
        s = "(null)";
    80000742:	00007917          	auipc	s2,0x7
    80000746:	8c690913          	addi	s2,s2,-1850 # 80007008 <etext+0x8>
      for(; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printf+0x266>
      consputc('%');
    80000750:	02500513          	li	a0,37
    80000754:	afbff0ef          	jal	8000024e <consputc>
    80000758:	b509                	j	8000055a <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000075a:	f7843783          	ld	a5,-136(s0)
    8000075e:	e385                	bnez	a5,8000077e <printf+0x2b0>
    80000760:	74e6                	ld	s1,120(sp)
    80000762:	7946                	ld	s2,112(sp)
    80000764:	79a6                	ld	s3,104(sp)
    80000766:	6ae6                	ld	s5,88(sp)
    80000768:	6b46                	ld	s6,80(sp)
    8000076a:	6c06                	ld	s8,64(sp)
    8000076c:	7ce2                	ld	s9,56(sp)
    8000076e:	7d42                	ld	s10,48(sp)
    80000770:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000772:	4501                	li	a0,0
    80000774:	60aa                	ld	ra,136(sp)
    80000776:	640a                	ld	s0,128(sp)
    80000778:	7a06                	ld	s4,96(sp)
    8000077a:	6169                	addi	sp,sp,208
    8000077c:	8082                	ret
    8000077e:	74e6                	ld	s1,120(sp)
    80000780:	7946                	ld	s2,112(sp)
    80000782:	79a6                	ld	s3,104(sp)
    80000784:	6ae6                	ld	s5,88(sp)
    80000786:	6b46                	ld	s6,80(sp)
    80000788:	6c06                	ld	s8,64(sp)
    8000078a:	7ce2                	ld	s9,56(sp)
    8000078c:	7d42                	ld	s10,48(sp)
    8000078e:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000790:	00012517          	auipc	a0,0x12
    80000794:	0c850513          	addi	a0,a0,200 # 80012858 <pr>
    80000798:	4fa000ef          	jal	80000c92 <release>
    8000079c:	bfd9                	j	80000772 <printf+0x2a4>

000000008000079e <panic>:

void
panic(char *s)
{
    8000079e:	1101                	addi	sp,sp,-32
    800007a0:	ec06                	sd	ra,24(sp)
    800007a2:	e822                	sd	s0,16(sp)
    800007a4:	e426                	sd	s1,8(sp)
    800007a6:	1000                	addi	s0,sp,32
    800007a8:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007aa:	00012797          	auipc	a5,0x12
    800007ae:	0c07a323          	sw	zero,198(a5) # 80012870 <pr+0x18>
  printf("panic: ");
    800007b2:	00007517          	auipc	a0,0x7
    800007b6:	86650513          	addi	a0,a0,-1946 # 80007018 <etext+0x18>
    800007ba:	d15ff0ef          	jal	800004ce <printf>
  printf("%s\n", s);
    800007be:	85a6                	mv	a1,s1
    800007c0:	00007517          	auipc	a0,0x7
    800007c4:	86050513          	addi	a0,a0,-1952 # 80007020 <etext+0x20>
    800007c8:	d07ff0ef          	jal	800004ce <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007cc:	4785                	li	a5,1
    800007ce:	0000a717          	auipc	a4,0xa
    800007d2:	faf72123          	sw	a5,-94(a4) # 8000a770 <panicked>
  for(;;)
    800007d6:	a001                	j	800007d6 <panic+0x38>

00000000800007d8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007d8:	1101                	addi	sp,sp,-32
    800007da:	ec06                	sd	ra,24(sp)
    800007dc:	e822                	sd	s0,16(sp)
    800007de:	e426                	sd	s1,8(sp)
    800007e0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007e2:	00012497          	auipc	s1,0x12
    800007e6:	07648493          	addi	s1,s1,118 # 80012858 <pr>
    800007ea:	00007597          	auipc	a1,0x7
    800007ee:	83e58593          	addi	a1,a1,-1986 # 80007028 <etext+0x28>
    800007f2:	8526                	mv	a0,s1
    800007f4:	386000ef          	jal	80000b7a <initlock>
  pr.locking = 1;
    800007f8:	4785                	li	a5,1
    800007fa:	cc9c                	sw	a5,24(s1)
}
    800007fc:	60e2                	ld	ra,24(sp)
    800007fe:	6442                	ld	s0,16(sp)
    80000800:	64a2                	ld	s1,8(sp)
    80000802:	6105                	addi	sp,sp,32
    80000804:	8082                	ret

0000000080000806 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000806:	1141                	addi	sp,sp,-16
    80000808:	e406                	sd	ra,8(sp)
    8000080a:	e022                	sd	s0,0(sp)
    8000080c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000080e:	100007b7          	lui	a5,0x10000
    80000812:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000816:	10000737          	lui	a4,0x10000
    8000081a:	f8000693          	li	a3,-128
    8000081e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000822:	468d                	li	a3,3
    80000824:	10000637          	lui	a2,0x10000
    80000828:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000082c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000830:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000834:	8732                	mv	a4,a2
    80000836:	461d                	li	a2,7
    80000838:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000083c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000840:	00006597          	auipc	a1,0x6
    80000844:	7f058593          	addi	a1,a1,2032 # 80007030 <etext+0x30>
    80000848:	00012517          	auipc	a0,0x12
    8000084c:	03050513          	addi	a0,a0,48 # 80012878 <uart_tx_lock>
    80000850:	32a000ef          	jal	80000b7a <initlock>
}
    80000854:	60a2                	ld	ra,8(sp)
    80000856:	6402                	ld	s0,0(sp)
    80000858:	0141                	addi	sp,sp,16
    8000085a:	8082                	ret

000000008000085c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000085c:	1101                	addi	sp,sp,-32
    8000085e:	ec06                	sd	ra,24(sp)
    80000860:	e822                	sd	s0,16(sp)
    80000862:	e426                	sd	s1,8(sp)
    80000864:	1000                	addi	s0,sp,32
    80000866:	84aa                	mv	s1,a0
  push_off();
    80000868:	356000ef          	jal	80000bbe <push_off>

  if(panicked){
    8000086c:	0000a797          	auipc	a5,0xa
    80000870:	f047a783          	lw	a5,-252(a5) # 8000a770 <panicked>
    80000874:	e795                	bnez	a5,800008a0 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000876:	10000737          	lui	a4,0x10000
    8000087a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000087c:	00074783          	lbu	a5,0(a4)
    80000880:	0207f793          	andi	a5,a5,32
    80000884:	dfe5                	beqz	a5,8000087c <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000886:	0ff4f513          	zext.b	a0,s1
    8000088a:	100007b7          	lui	a5,0x10000
    8000088e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000892:	3b0000ef          	jal	80000c42 <pop_off>
}
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    for(;;)
    800008a0:	a001                	j	800008a0 <uartputc_sync+0x44>

00000000800008a2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a2:	0000a797          	auipc	a5,0xa
    800008a6:	ed67b783          	ld	a5,-298(a5) # 8000a778 <uart_tx_r>
    800008aa:	0000a717          	auipc	a4,0xa
    800008ae:	ed673703          	ld	a4,-298(a4) # 8000a780 <uart_tx_w>
    800008b2:	08f70163          	beq	a4,a5,80000934 <uartstart+0x92>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	e05a                	sd	s6,0(sp)
    800008c8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ca:	10000937          	lui	s2,0x10000
    800008ce:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d0:	00012a97          	auipc	s5,0x12
    800008d4:	fa8a8a93          	addi	s5,s5,-88 # 80012878 <uart_tx_lock>
    uart_tx_r += 1;
    800008d8:	0000a497          	auipc	s1,0xa
    800008dc:	ea048493          	addi	s1,s1,-352 # 8000a778 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e0:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e4:	0000a997          	auipc	s3,0xa
    800008e8:	e9c98993          	addi	s3,s3,-356 # 8000a780 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ec:	00094703          	lbu	a4,0(s2)
    800008f0:	02077713          	andi	a4,a4,32
    800008f4:	c715                	beqz	a4,80000920 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f6:	01f7f713          	andi	a4,a5,31
    800008fa:	9756                	add	a4,a4,s5
    800008fc:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000900:	0785                	addi	a5,a5,1
    80000902:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000904:	8526                	mv	a0,s1
    80000906:	0d9010ef          	jal	800021de <wakeup>
    WriteReg(THR, c);
    8000090a:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000090e:	609c                	ld	a5,0(s1)
    80000910:	0009b703          	ld	a4,0(s3)
    80000914:	fcf71ce3          	bne	a4,a5,800008ec <uartstart+0x4a>
      ReadReg(ISR);
    80000918:	100007b7          	lui	a5,0x10000
    8000091c:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80000920:	70e2                	ld	ra,56(sp)
    80000922:	7442                	ld	s0,48(sp)
    80000924:	74a2                	ld	s1,40(sp)
    80000926:	7902                	ld	s2,32(sp)
    80000928:	69e2                	ld	s3,24(sp)
    8000092a:	6a42                	ld	s4,16(sp)
    8000092c:	6aa2                	ld	s5,8(sp)
    8000092e:	6b02                	ld	s6,0(sp)
    80000930:	6121                	addi	sp,sp,64
    80000932:	8082                	ret
      ReadReg(ISR);
    80000934:	100007b7          	lui	a5,0x10000
    80000938:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    8000093c:	8082                	ret

000000008000093e <uartputc>:
{
    8000093e:	7179                	addi	sp,sp,-48
    80000940:	f406                	sd	ra,40(sp)
    80000942:	f022                	sd	s0,32(sp)
    80000944:	ec26                	sd	s1,24(sp)
    80000946:	e84a                	sd	s2,16(sp)
    80000948:	e44e                	sd	s3,8(sp)
    8000094a:	e052                	sd	s4,0(sp)
    8000094c:	1800                	addi	s0,sp,48
    8000094e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000950:	00012517          	auipc	a0,0x12
    80000954:	f2850513          	addi	a0,a0,-216 # 80012878 <uart_tx_lock>
    80000958:	2a6000ef          	jal	80000bfe <acquire>
  if(panicked){
    8000095c:	0000a797          	auipc	a5,0xa
    80000960:	e147a783          	lw	a5,-492(a5) # 8000a770 <panicked>
    80000964:	efbd                	bnez	a5,800009e2 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000966:	0000a717          	auipc	a4,0xa
    8000096a:	e1a73703          	ld	a4,-486(a4) # 8000a780 <uart_tx_w>
    8000096e:	0000a797          	auipc	a5,0xa
    80000972:	e0a7b783          	ld	a5,-502(a5) # 8000a778 <uart_tx_r>
    80000976:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	00012997          	auipc	s3,0x12
    8000097e:	efe98993          	addi	s3,s3,-258 # 80012878 <uart_tx_lock>
    80000982:	0000a497          	auipc	s1,0xa
    80000986:	df648493          	addi	s1,s1,-522 # 8000a778 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000098a:	0000a917          	auipc	s2,0xa
    8000098e:	df690913          	addi	s2,s2,-522 # 8000a780 <uart_tx_w>
    80000992:	00e79d63          	bne	a5,a4,800009ac <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000996:	85ce                	mv	a1,s3
    80000998:	8526                	mv	a0,s1
    8000099a:	694010ef          	jal	8000202e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099e:	00093703          	ld	a4,0(s2)
    800009a2:	609c                	ld	a5,0(s1)
    800009a4:	02078793          	addi	a5,a5,32
    800009a8:	fee787e3          	beq	a5,a4,80000996 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009ac:	00012497          	auipc	s1,0x12
    800009b0:	ecc48493          	addi	s1,s1,-308 # 80012878 <uart_tx_lock>
    800009b4:	01f77793          	andi	a5,a4,31
    800009b8:	97a6                	add	a5,a5,s1
    800009ba:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009be:	0705                	addi	a4,a4,1
    800009c0:	0000a797          	auipc	a5,0xa
    800009c4:	dce7b023          	sd	a4,-576(a5) # 8000a780 <uart_tx_w>
  uartstart();
    800009c8:	edbff0ef          	jal	800008a2 <uartstart>
  release(&uart_tx_lock);
    800009cc:	8526                	mv	a0,s1
    800009ce:	2c4000ef          	jal	80000c92 <release>
}
    800009d2:	70a2                	ld	ra,40(sp)
    800009d4:	7402                	ld	s0,32(sp)
    800009d6:	64e2                	ld	s1,24(sp)
    800009d8:	6942                	ld	s2,16(sp)
    800009da:	69a2                	ld	s3,8(sp)
    800009dc:	6a02                	ld	s4,0(sp)
    800009de:	6145                	addi	sp,sp,48
    800009e0:	8082                	ret
    for(;;)
    800009e2:	a001                	j	800009e2 <uartputc+0xa4>

00000000800009e4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e4:	1141                	addi	sp,sp,-16
    800009e6:	e406                	sd	ra,8(sp)
    800009e8:	e022                	sd	s0,0(sp)
    800009ea:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009f4:	8b85                	andi	a5,a5,1
    800009f6:	cb89                	beqz	a5,80000a08 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009f8:	100007b7          	lui	a5,0x10000
    800009fc:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a00:	60a2                	ld	ra,8(sp)
    80000a02:	6402                	ld	s0,0(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret
    return -1;
    80000a08:	557d                	li	a0,-1
    80000a0a:	bfdd                	j	80000a00 <uartgetc+0x1c>

0000000080000a0c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a0c:	1101                	addi	sp,sp,-32
    80000a0e:	ec06                	sd	ra,24(sp)
    80000a10:	e822                	sd	s0,16(sp)
    80000a12:	e426                	sd	s1,8(sp)
    80000a14:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a16:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a18:	fcdff0ef          	jal	800009e4 <uartgetc>
    if(c == -1)
    80000a1c:	00950563          	beq	a0,s1,80000a26 <uartintr+0x1a>
      break;
    consoleintr(c);
    80000a20:	861ff0ef          	jal	80000280 <consoleintr>
  while(1){
    80000a24:	bfd5                	j	80000a18 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a26:	00012497          	auipc	s1,0x12
    80000a2a:	e5248493          	addi	s1,s1,-430 # 80012878 <uart_tx_lock>
    80000a2e:	8526                	mv	a0,s1
    80000a30:	1ce000ef          	jal	80000bfe <acquire>
  uartstart();
    80000a34:	e6fff0ef          	jal	800008a2 <uartstart>
  release(&uart_tx_lock);
    80000a38:	8526                	mv	a0,s1
    80000a3a:	258000ef          	jal	80000c92 <release>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret

0000000080000a48 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a48:	1101                	addi	sp,sp,-32
    80000a4a:	ec06                	sd	ra,24(sp)
    80000a4c:	e822                	sd	s0,16(sp)
    80000a4e:	e426                	sd	s1,8(sp)
    80000a50:	e04a                	sd	s2,0(sp)
    80000a52:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a54:	03451793          	slli	a5,a0,0x34
    80000a58:	e7a9                	bnez	a5,80000aa2 <kfree+0x5a>
    80000a5a:	84aa                	mv	s1,a0
    80000a5c:	00024797          	auipc	a5,0x24
    80000a60:	88478793          	addi	a5,a5,-1916 # 800242e0 <end>
    80000a64:	02f56f63          	bltu	a0,a5,80000aa2 <kfree+0x5a>
    80000a68:	47c5                	li	a5,17
    80000a6a:	07ee                	slli	a5,a5,0x1b
    80000a6c:	02f57b63          	bgeu	a0,a5,80000aa2 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a70:	6605                	lui	a2,0x1
    80000a72:	4585                	li	a1,1
    80000a74:	25a000ef          	jal	80000cce <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a78:	00012917          	auipc	s2,0x12
    80000a7c:	e3890913          	addi	s2,s2,-456 # 800128b0 <kmem>
    80000a80:	854a                	mv	a0,s2
    80000a82:	17c000ef          	jal	80000bfe <acquire>
  r->next = kmem.freelist;
    80000a86:	01893783          	ld	a5,24(s2)
    80000a8a:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a8c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a90:	854a                	mv	a0,s2
    80000a92:	200000ef          	jal	80000c92 <release>
}
    80000a96:	60e2                	ld	ra,24(sp)
    80000a98:	6442                	ld	s0,16(sp)
    80000a9a:	64a2                	ld	s1,8(sp)
    80000a9c:	6902                	ld	s2,0(sp)
    80000a9e:	6105                	addi	sp,sp,32
    80000aa0:	8082                	ret
    panic("kfree");
    80000aa2:	00006517          	auipc	a0,0x6
    80000aa6:	59650513          	addi	a0,a0,1430 # 80007038 <etext+0x38>
    80000aaa:	cf5ff0ef          	jal	8000079e <panic>

0000000080000aae <freerange>:
{
    80000aae:	7179                	addi	sp,sp,-48
    80000ab0:	f406                	sd	ra,40(sp)
    80000ab2:	f022                	sd	s0,32(sp)
    80000ab4:	ec26                	sd	s1,24(sp)
    80000ab6:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000abe:	00e504b3          	add	s1,a0,a4
    80000ac2:	777d                	lui	a4,0xfffff
    80000ac4:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac6:	94be                	add	s1,s1,a5
    80000ac8:	0295e263          	bltu	a1,s1,80000aec <freerange+0x3e>
    80000acc:	e84a                	sd	s2,16(sp)
    80000ace:	e44e                	sd	s3,8(sp)
    80000ad0:	e052                	sd	s4,0(sp)
    80000ad2:	892e                	mv	s2,a1
    kfree(p);
    80000ad4:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad6:	89be                	mv	s3,a5
    kfree(p);
    80000ad8:	01448533          	add	a0,s1,s4
    80000adc:	f6dff0ef          	jal	80000a48 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94ce                	add	s1,s1,s3
    80000ae2:	fe997be3          	bgeu	s2,s1,80000ad8 <freerange+0x2a>
    80000ae6:	6942                	ld	s2,16(sp)
    80000ae8:	69a2                	ld	s3,8(sp)
    80000aea:	6a02                	ld	s4,0(sp)
}
    80000aec:	70a2                	ld	ra,40(sp)
    80000aee:	7402                	ld	s0,32(sp)
    80000af0:	64e2                	ld	s1,24(sp)
    80000af2:	6145                	addi	sp,sp,48
    80000af4:	8082                	ret

0000000080000af6 <kinit>:
{
    80000af6:	1141                	addi	sp,sp,-16
    80000af8:	e406                	sd	ra,8(sp)
    80000afa:	e022                	sd	s0,0(sp)
    80000afc:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000afe:	00006597          	auipc	a1,0x6
    80000b02:	54258593          	addi	a1,a1,1346 # 80007040 <etext+0x40>
    80000b06:	00012517          	auipc	a0,0x12
    80000b0a:	daa50513          	addi	a0,a0,-598 # 800128b0 <kmem>
    80000b0e:	06c000ef          	jal	80000b7a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b12:	45c5                	li	a1,17
    80000b14:	05ee                	slli	a1,a1,0x1b
    80000b16:	00023517          	auipc	a0,0x23
    80000b1a:	7ca50513          	addi	a0,a0,1994 # 800242e0 <end>
    80000b1e:	f91ff0ef          	jal	80000aae <freerange>
}
    80000b22:	60a2                	ld	ra,8(sp)
    80000b24:	6402                	ld	s0,0(sp)
    80000b26:	0141                	addi	sp,sp,16
    80000b28:	8082                	ret

0000000080000b2a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b2a:	1101                	addi	sp,sp,-32
    80000b2c:	ec06                	sd	ra,24(sp)
    80000b2e:	e822                	sd	s0,16(sp)
    80000b30:	e426                	sd	s1,8(sp)
    80000b32:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b34:	00012497          	auipc	s1,0x12
    80000b38:	d7c48493          	addi	s1,s1,-644 # 800128b0 <kmem>
    80000b3c:	8526                	mv	a0,s1
    80000b3e:	0c0000ef          	jal	80000bfe <acquire>
  r = kmem.freelist;
    80000b42:	6c84                	ld	s1,24(s1)
  if(r)
    80000b44:	c485                	beqz	s1,80000b6c <kalloc+0x42>
    kmem.freelist = r->next;
    80000b46:	609c                	ld	a5,0(s1)
    80000b48:	00012517          	auipc	a0,0x12
    80000b4c:	d6850513          	addi	a0,a0,-664 # 800128b0 <kmem>
    80000b50:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b52:	140000ef          	jal	80000c92 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b56:	6605                	lui	a2,0x1
    80000b58:	4595                	li	a1,5
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	172000ef          	jal	80000cce <memset>
  return (void*)r;
}
    80000b60:	8526                	mv	a0,s1
    80000b62:	60e2                	ld	ra,24(sp)
    80000b64:	6442                	ld	s0,16(sp)
    80000b66:	64a2                	ld	s1,8(sp)
    80000b68:	6105                	addi	sp,sp,32
    80000b6a:	8082                	ret
  release(&kmem.lock);
    80000b6c:	00012517          	auipc	a0,0x12
    80000b70:	d4450513          	addi	a0,a0,-700 # 800128b0 <kmem>
    80000b74:	11e000ef          	jal	80000c92 <release>
  if(r)
    80000b78:	b7e5                	j	80000b60 <kalloc+0x36>

0000000080000b7a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b7a:	1141                	addi	sp,sp,-16
    80000b7c:	e406                	sd	ra,8(sp)
    80000b7e:	e022                	sd	s0,0(sp)
    80000b80:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b82:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b84:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b88:	00053823          	sd	zero,16(a0)
}
    80000b8c:	60a2                	ld	ra,8(sp)
    80000b8e:	6402                	ld	s0,0(sp)
    80000b90:	0141                	addi	sp,sp,16
    80000b92:	8082                	ret

0000000080000b94 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	411c                	lw	a5,0(a0)
    80000b96:	e399                	bnez	a5,80000b9c <holding+0x8>
    80000b98:	4501                	li	a0,0
  return r;
}
    80000b9a:	8082                	ret
{
    80000b9c:	1101                	addi	sp,sp,-32
    80000b9e:	ec06                	sd	ra,24(sp)
    80000ba0:	e822                	sd	s0,16(sp)
    80000ba2:	e426                	sd	s1,8(sp)
    80000ba4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba6:	6904                	ld	s1,16(a0)
    80000ba8:	515000ef          	jal	800018bc <mycpu>
    80000bac:	40a48533          	sub	a0,s1,a0
    80000bb0:	00153513          	seqz	a0,a0
}
    80000bb4:	60e2                	ld	ra,24(sp)
    80000bb6:	6442                	ld	s0,16(sp)
    80000bb8:	64a2                	ld	s1,8(sp)
    80000bba:	6105                	addi	sp,sp,32
    80000bbc:	8082                	ret

0000000080000bbe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bbe:	1101                	addi	sp,sp,-32
    80000bc0:	ec06                	sd	ra,24(sp)
    80000bc2:	e822                	sd	s0,16(sp)
    80000bc4:	e426                	sd	s1,8(sp)
    80000bc6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc8:	100024f3          	csrr	s1,sstatus
    80000bcc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bd6:	4e7000ef          	jal	800018bc <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	cb99                	beqz	a5,80000bf2 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bde:	4df000ef          	jal	800018bc <mycpu>
    80000be2:	5d3c                	lw	a5,120(a0)
    80000be4:	2785                	addiw	a5,a5,1
    80000be6:	dd3c                	sw	a5,120(a0)
}
    80000be8:	60e2                	ld	ra,24(sp)
    80000bea:	6442                	ld	s0,16(sp)
    80000bec:	64a2                	ld	s1,8(sp)
    80000bee:	6105                	addi	sp,sp,32
    80000bf0:	8082                	ret
    mycpu()->intena = old;
    80000bf2:	4cb000ef          	jal	800018bc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bf6:	8085                	srli	s1,s1,0x1
    80000bf8:	8885                	andi	s1,s1,1
    80000bfa:	dd64                	sw	s1,124(a0)
    80000bfc:	b7cd                	j	80000bde <push_off+0x20>

0000000080000bfe <acquire>:
{
    80000bfe:	1101                	addi	sp,sp,-32
    80000c00:	ec06                	sd	ra,24(sp)
    80000c02:	e822                	sd	s0,16(sp)
    80000c04:	e426                	sd	s1,8(sp)
    80000c06:	1000                	addi	s0,sp,32
    80000c08:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c0a:	fb5ff0ef          	jal	80000bbe <push_off>
  if(holding(lk))
    80000c0e:	8526                	mv	a0,s1
    80000c10:	f85ff0ef          	jal	80000b94 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c14:	4705                	li	a4,1
  if(holding(lk))
    80000c16:	e105                	bnez	a0,80000c36 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c18:	87ba                	mv	a5,a4
    80000c1a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c1e:	2781                	sext.w	a5,a5
    80000c20:	ffe5                	bnez	a5,80000c18 <acquire+0x1a>
  __sync_synchronize();
    80000c22:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c26:	497000ef          	jal	800018bc <mycpu>
    80000c2a:	e888                	sd	a0,16(s1)
}
    80000c2c:	60e2                	ld	ra,24(sp)
    80000c2e:	6442                	ld	s0,16(sp)
    80000c30:	64a2                	ld	s1,8(sp)
    80000c32:	6105                	addi	sp,sp,32
    80000c34:	8082                	ret
    panic("acquire");
    80000c36:	00006517          	auipc	a0,0x6
    80000c3a:	41250513          	addi	a0,a0,1042 # 80007048 <etext+0x48>
    80000c3e:	b61ff0ef          	jal	8000079e <panic>

0000000080000c42 <pop_off>:

void
pop_off(void)
{
    80000c42:	1141                	addi	sp,sp,-16
    80000c44:	e406                	sd	ra,8(sp)
    80000c46:	e022                	sd	s0,0(sp)
    80000c48:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c4a:	473000ef          	jal	800018bc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c52:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c54:	e39d                	bnez	a5,80000c7a <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c56:	5d3c                	lw	a5,120(a0)
    80000c58:	02f05763          	blez	a5,80000c86 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c5c:	37fd                	addiw	a5,a5,-1
    80000c5e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c60:	eb89                	bnez	a5,80000c72 <pop_off+0x30>
    80000c62:	5d7c                	lw	a5,124(a0)
    80000c64:	c799                	beqz	a5,80000c72 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c6a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c6e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c72:	60a2                	ld	ra,8(sp)
    80000c74:	6402                	ld	s0,0(sp)
    80000c76:	0141                	addi	sp,sp,16
    80000c78:	8082                	ret
    panic("pop_off - interruptible");
    80000c7a:	00006517          	auipc	a0,0x6
    80000c7e:	3d650513          	addi	a0,a0,982 # 80007050 <etext+0x50>
    80000c82:	b1dff0ef          	jal	8000079e <panic>
    panic("pop_off");
    80000c86:	00006517          	auipc	a0,0x6
    80000c8a:	3e250513          	addi	a0,a0,994 # 80007068 <etext+0x68>
    80000c8e:	b11ff0ef          	jal	8000079e <panic>

0000000080000c92 <release>:
{
    80000c92:	1101                	addi	sp,sp,-32
    80000c94:	ec06                	sd	ra,24(sp)
    80000c96:	e822                	sd	s0,16(sp)
    80000c98:	e426                	sd	s1,8(sp)
    80000c9a:	1000                	addi	s0,sp,32
    80000c9c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c9e:	ef7ff0ef          	jal	80000b94 <holding>
    80000ca2:	c105                	beqz	a0,80000cc2 <release+0x30>
  lk->cpu = 0;
    80000ca4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca8:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cac:	0310000f          	fence	rw,w
    80000cb0:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cb4:	f8fff0ef          	jal	80000c42 <pop_off>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    panic("release");
    80000cc2:	00006517          	auipc	a0,0x6
    80000cc6:	3ae50513          	addi	a0,a0,942 # 80007070 <etext+0x70>
    80000cca:	ad5ff0ef          	jal	8000079e <panic>

0000000080000cce <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cce:	1141                	addi	sp,sp,-16
    80000cd0:	e406                	sd	ra,8(sp)
    80000cd2:	e022                	sd	s0,0(sp)
    80000cd4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd6:	ca19                	beqz	a2,80000cec <memset+0x1e>
    80000cd8:	87aa                	mv	a5,a0
    80000cda:	1602                	slli	a2,a2,0x20
    80000cdc:	9201                	srli	a2,a2,0x20
    80000cde:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce6:	0785                	addi	a5,a5,1
    80000ce8:	fee79de3          	bne	a5,a4,80000ce2 <memset+0x14>
  }
  return dst;
}
    80000cec:	60a2                	ld	ra,8(sp)
    80000cee:	6402                	ld	s0,0(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e406                	sd	ra,8(sp)
    80000cf8:	e022                	sd	s0,0(sp)
    80000cfa:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfc:	ca0d                	beqz	a2,80000d2e <memcmp+0x3a>
    80000cfe:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d02:	1682                	slli	a3,a3,0x20
    80000d04:	9281                	srli	a3,a3,0x20
    80000d06:	0685                	addi	a3,a3,1
    80000d08:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d0a:	00054783          	lbu	a5,0(a0)
    80000d0e:	0005c703          	lbu	a4,0(a1)
    80000d12:	00e79863          	bne	a5,a4,80000d22 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000d16:	0505                	addi	a0,a0,1
    80000d18:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d1a:	fed518e3          	bne	a0,a3,80000d0a <memcmp+0x16>
  }

  return 0;
    80000d1e:	4501                	li	a0,0
    80000d20:	a019                	j	80000d26 <memcmp+0x32>
      return *s1 - *s2;
    80000d22:	40e7853b          	subw	a0,a5,a4
}
    80000d26:	60a2                	ld	ra,8(sp)
    80000d28:	6402                	ld	s0,0(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret
  return 0;
    80000d2e:	4501                	li	a0,0
    80000d30:	bfdd                	j	80000d26 <memcmp+0x32>

0000000080000d32 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e406                	sd	ra,8(sp)
    80000d36:	e022                	sd	s0,0(sp)
    80000d38:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d3a:	c205                	beqz	a2,80000d5a <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d3c:	02a5e363          	bltu	a1,a0,80000d62 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d40:	1602                	slli	a2,a2,0x20
    80000d42:	9201                	srli	a2,a2,0x20
    80000d44:	00c587b3          	add	a5,a1,a2
{
    80000d48:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d4a:	0585                	addi	a1,a1,1
    80000d4c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdad21>
    80000d4e:	fff5c683          	lbu	a3,-1(a1)
    80000d52:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d56:	feb79ae3          	bne	a5,a1,80000d4a <memmove+0x18>

  return dst;
}
    80000d5a:	60a2                	ld	ra,8(sp)
    80000d5c:	6402                	ld	s0,0(sp)
    80000d5e:	0141                	addi	sp,sp,16
    80000d60:	8082                	ret
  if(s < d && s + n > d){
    80000d62:	02061693          	slli	a3,a2,0x20
    80000d66:	9281                	srli	a3,a3,0x20
    80000d68:	00d58733          	add	a4,a1,a3
    80000d6c:	fce57ae3          	bgeu	a0,a4,80000d40 <memmove+0xe>
    d += n;
    80000d70:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d72:	fff6079b          	addiw	a5,a2,-1
    80000d76:	1782                	slli	a5,a5,0x20
    80000d78:	9381                	srli	a5,a5,0x20
    80000d7a:	fff7c793          	not	a5,a5
    80000d7e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d80:	177d                	addi	a4,a4,-1
    80000d82:	16fd                	addi	a3,a3,-1
    80000d84:	00074603          	lbu	a2,0(a4)
    80000d88:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d8c:	fee79ae3          	bne	a5,a4,80000d80 <memmove+0x4e>
    80000d90:	b7e9                	j	80000d5a <memmove+0x28>

0000000080000d92 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d92:	1141                	addi	sp,sp,-16
    80000d94:	e406                	sd	ra,8(sp)
    80000d96:	e022                	sd	s0,0(sp)
    80000d98:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d9a:	f99ff0ef          	jal	80000d32 <memmove>
}
    80000d9e:	60a2                	ld	ra,8(sp)
    80000da0:	6402                	ld	s0,0(sp)
    80000da2:	0141                	addi	sp,sp,16
    80000da4:	8082                	ret

0000000080000da6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da6:	1141                	addi	sp,sp,-16
    80000da8:	e406                	sd	ra,8(sp)
    80000daa:	e022                	sd	s0,0(sp)
    80000dac:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dae:	ce11                	beqz	a2,80000dca <strncmp+0x24>
    80000db0:	00054783          	lbu	a5,0(a0)
    80000db4:	cf89                	beqz	a5,80000dce <strncmp+0x28>
    80000db6:	0005c703          	lbu	a4,0(a1)
    80000dba:	00f71a63          	bne	a4,a5,80000dce <strncmp+0x28>
    n--, p++, q++;
    80000dbe:	367d                	addiw	a2,a2,-1
    80000dc0:	0505                	addi	a0,a0,1
    80000dc2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dc4:	f675                	bnez	a2,80000db0 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dc6:	4501                	li	a0,0
    80000dc8:	a801                	j	80000dd8 <strncmp+0x32>
    80000dca:	4501                	li	a0,0
    80000dcc:	a031                	j	80000dd8 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000dce:	00054503          	lbu	a0,0(a0)
    80000dd2:	0005c783          	lbu	a5,0(a1)
    80000dd6:	9d1d                	subw	a0,a0,a5
}
    80000dd8:	60a2                	ld	ra,8(sp)
    80000dda:	6402                	ld	s0,0(sp)
    80000ddc:	0141                	addi	sp,sp,16
    80000dde:	8082                	ret

0000000080000de0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000de0:	1141                	addi	sp,sp,-16
    80000de2:	e406                	sd	ra,8(sp)
    80000de4:	e022                	sd	s0,0(sp)
    80000de6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de8:	87aa                	mv	a5,a0
    80000dea:	86b2                	mv	a3,a2
    80000dec:	367d                	addiw	a2,a2,-1
    80000dee:	02d05563          	blez	a3,80000e18 <strncpy+0x38>
    80000df2:	0785                	addi	a5,a5,1
    80000df4:	0005c703          	lbu	a4,0(a1)
    80000df8:	fee78fa3          	sb	a4,-1(a5)
    80000dfc:	0585                	addi	a1,a1,1
    80000dfe:	f775                	bnez	a4,80000dea <strncpy+0xa>
    ;
  while(n-- > 0)
    80000e00:	873e                	mv	a4,a5
    80000e02:	00c05b63          	blez	a2,80000e18 <strncpy+0x38>
    80000e06:	9fb5                	addw	a5,a5,a3
    80000e08:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e0a:	0705                	addi	a4,a4,1
    80000e0c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e10:	40e786bb          	subw	a3,a5,a4
    80000e14:	fed04be3          	bgtz	a3,80000e0a <strncpy+0x2a>
  return os;
}
    80000e18:	60a2                	ld	ra,8(sp)
    80000e1a:	6402                	ld	s0,0(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret

0000000080000e20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e20:	1141                	addi	sp,sp,-16
    80000e22:	e406                	sd	ra,8(sp)
    80000e24:	e022                	sd	s0,0(sp)
    80000e26:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e28:	02c05363          	blez	a2,80000e4e <safestrcpy+0x2e>
    80000e2c:	fff6069b          	addiw	a3,a2,-1
    80000e30:	1682                	slli	a3,a3,0x20
    80000e32:	9281                	srli	a3,a3,0x20
    80000e34:	96ae                	add	a3,a3,a1
    80000e36:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e38:	00d58963          	beq	a1,a3,80000e4a <safestrcpy+0x2a>
    80000e3c:	0585                	addi	a1,a1,1
    80000e3e:	0785                	addi	a5,a5,1
    80000e40:	fff5c703          	lbu	a4,-1(a1)
    80000e44:	fee78fa3          	sb	a4,-1(a5)
    80000e48:	fb65                	bnez	a4,80000e38 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e4a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e4e:	60a2                	ld	ra,8(sp)
    80000e50:	6402                	ld	s0,0(sp)
    80000e52:	0141                	addi	sp,sp,16
    80000e54:	8082                	ret

0000000080000e56 <strlen>:

int
strlen(const char *s)
{
    80000e56:	1141                	addi	sp,sp,-16
    80000e58:	e406                	sd	ra,8(sp)
    80000e5a:	e022                	sd	s0,0(sp)
    80000e5c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e5e:	00054783          	lbu	a5,0(a0)
    80000e62:	cf99                	beqz	a5,80000e80 <strlen+0x2a>
    80000e64:	0505                	addi	a0,a0,1
    80000e66:	87aa                	mv	a5,a0
    80000e68:	86be                	mv	a3,a5
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff7c703          	lbu	a4,-1(a5)
    80000e70:	ff65                	bnez	a4,80000e68 <strlen+0x12>
    80000e72:	40a6853b          	subw	a0,a3,a0
    80000e76:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e78:	60a2                	ld	ra,8(sp)
    80000e7a:	6402                	ld	s0,0(sp)
    80000e7c:	0141                	addi	sp,sp,16
    80000e7e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e80:	4501                	li	a0,0
    80000e82:	bfdd                	j	80000e78 <strlen+0x22>

0000000080000e84 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e84:	1141                	addi	sp,sp,-16
    80000e86:	e406                	sd	ra,8(sp)
    80000e88:	e022                	sd	s0,0(sp)
    80000e8a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e8c:	21d000ef          	jal	800018a8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e90:	0000a717          	auipc	a4,0xa
    80000e94:	8f870713          	addi	a4,a4,-1800 # 8000a788 <started>
  if(cpuid() == 0){
    80000e98:	c51d                	beqz	a0,80000ec6 <main+0x42>
    while(started == 0)
    80000e9a:	431c                	lw	a5,0(a4)
    80000e9c:	2781                	sext.w	a5,a5
    80000e9e:	dff5                	beqz	a5,80000e9a <main+0x16>
      ;
    __sync_synchronize();
    80000ea0:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ea4:	205000ef          	jal	800018a8 <cpuid>
    80000ea8:	85aa                	mv	a1,a0
    80000eaa:	00006517          	auipc	a0,0x6
    80000eae:	1e650513          	addi	a0,a0,486 # 80007090 <etext+0x90>
    80000eb2:	e1cff0ef          	jal	800004ce <printf>
    kvminithart();    // turn on paging
    80000eb6:	080000ef          	jal	80000f36 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eba:	05f010ef          	jal	80002718 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ebe:	7ca040ef          	jal	80005688 <plicinithart>
  }

  scheduler();        
    80000ec2:	7d3000ef          	jal	80001e94 <scheduler>
    consoleinit();
    80000ec6:	d3aff0ef          	jal	80000400 <consoleinit>
    printfinit();
    80000eca:	90fff0ef          	jal	800007d8 <printfinit>
    printf("\n");
    80000ece:	00006517          	auipc	a0,0x6
    80000ed2:	5ea50513          	addi	a0,a0,1514 # 800074b8 <etext+0x4b8>
    80000ed6:	df8ff0ef          	jal	800004ce <printf>
    printf("xv6 kernel is booting\n");
    80000eda:	00006517          	auipc	a0,0x6
    80000ede:	19e50513          	addi	a0,a0,414 # 80007078 <etext+0x78>
    80000ee2:	decff0ef          	jal	800004ce <printf>
    printf("\n");
    80000ee6:	00006517          	auipc	a0,0x6
    80000eea:	5d250513          	addi	a0,a0,1490 # 800074b8 <etext+0x4b8>
    80000eee:	de0ff0ef          	jal	800004ce <printf>
    kinit();         // physical page allocator
    80000ef2:	c05ff0ef          	jal	80000af6 <kinit>
    kvminit();       // create kernel page table
    80000ef6:	2ce000ef          	jal	800011c4 <kvminit>
    kvminithart();   // turn on paging
    80000efa:	03c000ef          	jal	80000f36 <kvminithart>
    procinit();      // process table
    80000efe:	0fb000ef          	jal	800017f8 <procinit>
    trapinit();      // trap vectors
    80000f02:	7f2010ef          	jal	800026f4 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f06:	013010ef          	jal	80002718 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f0a:	764040ef          	jal	8000566e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f0e:	77a040ef          	jal	80005688 <plicinithart>
    binit();         // buffer cache
    80000f12:	6e7010ef          	jal	80002df8 <binit>
    iinit();         // inode table
    80000f16:	4b2020ef          	jal	800033c8 <iinit>
    fileinit();      // file table
    80000f1a:	280030ef          	jal	8000419a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f1e:	05b040ef          	jal	80005778 <virtio_disk_init>
    userinit();      // first user process
    80000f22:	441000ef          	jal	80001b62 <userinit>
    __sync_synchronize();
    80000f26:	0330000f          	fence	rw,rw
    started = 1;
    80000f2a:	4785                	li	a5,1
    80000f2c:	0000a717          	auipc	a4,0xa
    80000f30:	84f72e23          	sw	a5,-1956(a4) # 8000a788 <started>
    80000f34:	b779                	j	80000ec2 <main+0x3e>

0000000080000f36 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f36:	1141                	addi	sp,sp,-16
    80000f38:	e406                	sd	ra,8(sp)
    80000f3a:	e022                	sd	s0,0(sp)
    80000f3c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f3e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f42:	0000a797          	auipc	a5,0xa
    80000f46:	84e7b783          	ld	a5,-1970(a5) # 8000a790 <kernel_pagetable>
    80000f4a:	83b1                	srli	a5,a5,0xc
    80000f4c:	577d                	li	a4,-1
    80000f4e:	177e                	slli	a4,a4,0x3f
    80000f50:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f52:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f56:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f5a:	60a2                	ld	ra,8(sp)
    80000f5c:	6402                	ld	s0,0(sp)
    80000f5e:	0141                	addi	sp,sp,16
    80000f60:	8082                	ret

0000000080000f62 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f62:	7139                	addi	sp,sp,-64
    80000f64:	fc06                	sd	ra,56(sp)
    80000f66:	f822                	sd	s0,48(sp)
    80000f68:	f426                	sd	s1,40(sp)
    80000f6a:	f04a                	sd	s2,32(sp)
    80000f6c:	ec4e                	sd	s3,24(sp)
    80000f6e:	e852                	sd	s4,16(sp)
    80000f70:	e456                	sd	s5,8(sp)
    80000f72:	e05a                	sd	s6,0(sp)
    80000f74:	0080                	addi	s0,sp,64
    80000f76:	84aa                	mv	s1,a0
    80000f78:	89ae                	mv	s3,a1
    80000f7a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f7c:	57fd                	li	a5,-1
    80000f7e:	83e9                	srli	a5,a5,0x1a
    80000f80:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f82:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f84:	04b7e263          	bltu	a5,a1,80000fc8 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f88:	0149d933          	srl	s2,s3,s4
    80000f8c:	1ff97913          	andi	s2,s2,511
    80000f90:	090e                	slli	s2,s2,0x3
    80000f92:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f94:	00093483          	ld	s1,0(s2)
    80000f98:	0014f793          	andi	a5,s1,1
    80000f9c:	cf85                	beqz	a5,80000fd4 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f9e:	80a9                	srli	s1,s1,0xa
    80000fa0:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000fa2:	3a5d                	addiw	s4,s4,-9
    80000fa4:	ff6a12e3          	bne	s4,s6,80000f88 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fa8:	00c9d513          	srli	a0,s3,0xc
    80000fac:	1ff57513          	andi	a0,a0,511
    80000fb0:	050e                	slli	a0,a0,0x3
    80000fb2:	9526                	add	a0,a0,s1
}
    80000fb4:	70e2                	ld	ra,56(sp)
    80000fb6:	7442                	ld	s0,48(sp)
    80000fb8:	74a2                	ld	s1,40(sp)
    80000fba:	7902                	ld	s2,32(sp)
    80000fbc:	69e2                	ld	s3,24(sp)
    80000fbe:	6a42                	ld	s4,16(sp)
    80000fc0:	6aa2                	ld	s5,8(sp)
    80000fc2:	6b02                	ld	s6,0(sp)
    80000fc4:	6121                	addi	sp,sp,64
    80000fc6:	8082                	ret
    panic("walk");
    80000fc8:	00006517          	auipc	a0,0x6
    80000fcc:	0e050513          	addi	a0,a0,224 # 800070a8 <etext+0xa8>
    80000fd0:	fceff0ef          	jal	8000079e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fd4:	020a8263          	beqz	s5,80000ff8 <walk+0x96>
    80000fd8:	b53ff0ef          	jal	80000b2a <kalloc>
    80000fdc:	84aa                	mv	s1,a0
    80000fde:	d979                	beqz	a0,80000fb4 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fe0:	6605                	lui	a2,0x1
    80000fe2:	4581                	li	a1,0
    80000fe4:	cebff0ef          	jal	80000cce <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fe8:	00c4d793          	srli	a5,s1,0xc
    80000fec:	07aa                	slli	a5,a5,0xa
    80000fee:	0017e793          	ori	a5,a5,1
    80000ff2:	00f93023          	sd	a5,0(s2)
    80000ff6:	b775                	j	80000fa2 <walk+0x40>
        return 0;
    80000ff8:	4501                	li	a0,0
    80000ffa:	bf6d                	j	80000fb4 <walk+0x52>

0000000080000ffc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000ffc:	57fd                	li	a5,-1
    80000ffe:	83e9                	srli	a5,a5,0x1a
    80001000:	00b7f463          	bgeu	a5,a1,80001008 <walkaddr+0xc>
    return 0;
    80001004:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001006:	8082                	ret
{
    80001008:	1141                	addi	sp,sp,-16
    8000100a:	e406                	sd	ra,8(sp)
    8000100c:	e022                	sd	s0,0(sp)
    8000100e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001010:	4601                	li	a2,0
    80001012:	f51ff0ef          	jal	80000f62 <walk>
  if(pte == 0)
    80001016:	c105                	beqz	a0,80001036 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001018:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000101a:	0117f693          	andi	a3,a5,17
    8000101e:	4745                	li	a4,17
    return 0;
    80001020:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001022:	00e68663          	beq	a3,a4,8000102e <walkaddr+0x32>
}
    80001026:	60a2                	ld	ra,8(sp)
    80001028:	6402                	ld	s0,0(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret
  pa = PTE2PA(*pte);
    8000102e:	83a9                	srli	a5,a5,0xa
    80001030:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001034:	bfcd                	j	80001026 <walkaddr+0x2a>
    return 0;
    80001036:	4501                	li	a0,0
    80001038:	b7fd                	j	80001026 <walkaddr+0x2a>

000000008000103a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000103a:	715d                	addi	sp,sp,-80
    8000103c:	e486                	sd	ra,72(sp)
    8000103e:	e0a2                	sd	s0,64(sp)
    80001040:	fc26                	sd	s1,56(sp)
    80001042:	f84a                	sd	s2,48(sp)
    80001044:	f44e                	sd	s3,40(sp)
    80001046:	f052                	sd	s4,32(sp)
    80001048:	ec56                	sd	s5,24(sp)
    8000104a:	e85a                	sd	s6,16(sp)
    8000104c:	e45e                	sd	s7,8(sp)
    8000104e:	e062                	sd	s8,0(sp)
    80001050:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001052:	03459793          	slli	a5,a1,0x34
    80001056:	e7b1                	bnez	a5,800010a2 <mappages+0x68>
    80001058:	8aaa                	mv	s5,a0
    8000105a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000105c:	03461793          	slli	a5,a2,0x34
    80001060:	e7b9                	bnez	a5,800010ae <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    80001062:	ce21                	beqz	a2,800010ba <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001064:	77fd                	lui	a5,0xfffff
    80001066:	963e                	add	a2,a2,a5
    80001068:	00b609b3          	add	s3,a2,a1
  a = va;
    8000106c:	892e                	mv	s2,a1
    8000106e:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001072:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001074:	6c05                	lui	s8,0x1
    80001076:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	865e                	mv	a2,s7
    8000107c:	85ca                	mv	a1,s2
    8000107e:	8556                	mv	a0,s5
    80001080:	ee3ff0ef          	jal	80000f62 <walk>
    80001084:	c539                	beqz	a0,800010d2 <mappages+0x98>
    if(*pte & PTE_V)
    80001086:	611c                	ld	a5,0(a0)
    80001088:	8b85                	andi	a5,a5,1
    8000108a:	ef95                	bnez	a5,800010c6 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000108c:	80b1                	srli	s1,s1,0xc
    8000108e:	04aa                	slli	s1,s1,0xa
    80001090:	0164e4b3          	or	s1,s1,s6
    80001094:	0014e493          	ori	s1,s1,1
    80001098:	e104                	sd	s1,0(a0)
    if(a == last)
    8000109a:	05390963          	beq	s2,s3,800010ec <mappages+0xb2>
    a += PGSIZE;
    8000109e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a0:	bfd9                	j	80001076 <mappages+0x3c>
    panic("mappages: va not aligned");
    800010a2:	00006517          	auipc	a0,0x6
    800010a6:	00e50513          	addi	a0,a0,14 # 800070b0 <etext+0xb0>
    800010aa:	ef4ff0ef          	jal	8000079e <panic>
    panic("mappages: size not aligned");
    800010ae:	00006517          	auipc	a0,0x6
    800010b2:	02250513          	addi	a0,a0,34 # 800070d0 <etext+0xd0>
    800010b6:	ee8ff0ef          	jal	8000079e <panic>
    panic("mappages: size");
    800010ba:	00006517          	auipc	a0,0x6
    800010be:	03650513          	addi	a0,a0,54 # 800070f0 <etext+0xf0>
    800010c2:	edcff0ef          	jal	8000079e <panic>
      panic("mappages: remap");
    800010c6:	00006517          	auipc	a0,0x6
    800010ca:	03a50513          	addi	a0,a0,58 # 80007100 <etext+0x100>
    800010ce:	ed0ff0ef          	jal	8000079e <panic>
      return -1;
    800010d2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010d4:	60a6                	ld	ra,72(sp)
    800010d6:	6406                	ld	s0,64(sp)
    800010d8:	74e2                	ld	s1,56(sp)
    800010da:	7942                	ld	s2,48(sp)
    800010dc:	79a2                	ld	s3,40(sp)
    800010de:	7a02                	ld	s4,32(sp)
    800010e0:	6ae2                	ld	s5,24(sp)
    800010e2:	6b42                	ld	s6,16(sp)
    800010e4:	6ba2                	ld	s7,8(sp)
    800010e6:	6c02                	ld	s8,0(sp)
    800010e8:	6161                	addi	sp,sp,80
    800010ea:	8082                	ret
  return 0;
    800010ec:	4501                	li	a0,0
    800010ee:	b7dd                	j	800010d4 <mappages+0x9a>

00000000800010f0 <kvmmap>:
{
    800010f0:	1141                	addi	sp,sp,-16
    800010f2:	e406                	sd	ra,8(sp)
    800010f4:	e022                	sd	s0,0(sp)
    800010f6:	0800                	addi	s0,sp,16
    800010f8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010fa:	86b2                	mv	a3,a2
    800010fc:	863e                	mv	a2,a5
    800010fe:	f3dff0ef          	jal	8000103a <mappages>
    80001102:	e509                	bnez	a0,8000110c <kvmmap+0x1c>
}
    80001104:	60a2                	ld	ra,8(sp)
    80001106:	6402                	ld	s0,0(sp)
    80001108:	0141                	addi	sp,sp,16
    8000110a:	8082                	ret
    panic("kvmmap");
    8000110c:	00006517          	auipc	a0,0x6
    80001110:	00450513          	addi	a0,a0,4 # 80007110 <etext+0x110>
    80001114:	e8aff0ef          	jal	8000079e <panic>

0000000080001118 <kvmmake>:
{
    80001118:	1101                	addi	sp,sp,-32
    8000111a:	ec06                	sd	ra,24(sp)
    8000111c:	e822                	sd	s0,16(sp)
    8000111e:	e426                	sd	s1,8(sp)
    80001120:	e04a                	sd	s2,0(sp)
    80001122:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001124:	a07ff0ef          	jal	80000b2a <kalloc>
    80001128:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000112a:	6605                	lui	a2,0x1
    8000112c:	4581                	li	a1,0
    8000112e:	ba1ff0ef          	jal	80000cce <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001132:	4719                	li	a4,6
    80001134:	6685                	lui	a3,0x1
    80001136:	10000637          	lui	a2,0x10000
    8000113a:	85b2                	mv	a1,a2
    8000113c:	8526                	mv	a0,s1
    8000113e:	fb3ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001142:	4719                	li	a4,6
    80001144:	6685                	lui	a3,0x1
    80001146:	10001637          	lui	a2,0x10001
    8000114a:	85b2                	mv	a1,a2
    8000114c:	8526                	mv	a0,s1
    8000114e:	fa3ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001152:	4719                	li	a4,6
    80001154:	040006b7          	lui	a3,0x4000
    80001158:	0c000637          	lui	a2,0xc000
    8000115c:	85b2                	mv	a1,a2
    8000115e:	8526                	mv	a0,s1
    80001160:	f91ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001164:	00006917          	auipc	s2,0x6
    80001168:	e9c90913          	addi	s2,s2,-356 # 80007000 <etext>
    8000116c:	4729                	li	a4,10
    8000116e:	80006697          	auipc	a3,0x80006
    80001172:	e9268693          	addi	a3,a3,-366 # 7000 <_entry-0x7fff9000>
    80001176:	4605                	li	a2,1
    80001178:	067e                	slli	a2,a2,0x1f
    8000117a:	85b2                	mv	a1,a2
    8000117c:	8526                	mv	a0,s1
    8000117e:	f73ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001182:	4719                	li	a4,6
    80001184:	46c5                	li	a3,17
    80001186:	06ee                	slli	a3,a3,0x1b
    80001188:	412686b3          	sub	a3,a3,s2
    8000118c:	864a                	mv	a2,s2
    8000118e:	85ca                	mv	a1,s2
    80001190:	8526                	mv	a0,s1
    80001192:	f5fff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001196:	4729                	li	a4,10
    80001198:	6685                	lui	a3,0x1
    8000119a:	00005617          	auipc	a2,0x5
    8000119e:	e6660613          	addi	a2,a2,-410 # 80006000 <_trampoline>
    800011a2:	040005b7          	lui	a1,0x4000
    800011a6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a8:	05b2                	slli	a1,a1,0xc
    800011aa:	8526                	mv	a0,s1
    800011ac:	f45ff0ef          	jal	800010f0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011b0:	8526                	mv	a0,s1
    800011b2:	5a8000ef          	jal	8000175a <proc_mapstacks>
}
    800011b6:	8526                	mv	a0,s1
    800011b8:	60e2                	ld	ra,24(sp)
    800011ba:	6442                	ld	s0,16(sp)
    800011bc:	64a2                	ld	s1,8(sp)
    800011be:	6902                	ld	s2,0(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <kvminit>:
{
    800011c4:	1141                	addi	sp,sp,-16
    800011c6:	e406                	sd	ra,8(sp)
    800011c8:	e022                	sd	s0,0(sp)
    800011ca:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011cc:	f4dff0ef          	jal	80001118 <kvmmake>
    800011d0:	00009797          	auipc	a5,0x9
    800011d4:	5ca7b023          	sd	a0,1472(a5) # 8000a790 <kernel_pagetable>
}
    800011d8:	60a2                	ld	ra,8(sp)
    800011da:	6402                	ld	s0,0(sp)
    800011dc:	0141                	addi	sp,sp,16
    800011de:	8082                	ret

00000000800011e0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011e0:	715d                	addi	sp,sp,-80
    800011e2:	e486                	sd	ra,72(sp)
    800011e4:	e0a2                	sd	s0,64(sp)
    800011e6:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011e8:	03459793          	slli	a5,a1,0x34
    800011ec:	e39d                	bnez	a5,80001212 <uvmunmap+0x32>
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    800011fa:	8a2a                	mv	s4,a0
    800011fc:	892e                	mv	s2,a1
    800011fe:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001200:	0632                	slli	a2,a2,0xc
    80001202:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001206:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001208:	6b05                	lui	s6,0x1
    8000120a:	0735ff63          	bgeu	a1,s3,80001288 <uvmunmap+0xa8>
    8000120e:	fc26                	sd	s1,56(sp)
    80001210:	a0a9                	j	8000125a <uvmunmap+0x7a>
    80001212:	fc26                	sd	s1,56(sp)
    80001214:	f84a                	sd	s2,48(sp)
    80001216:	f44e                	sd	s3,40(sp)
    80001218:	f052                	sd	s4,32(sp)
    8000121a:	ec56                	sd	s5,24(sp)
    8000121c:	e85a                	sd	s6,16(sp)
    8000121e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001220:	00006517          	auipc	a0,0x6
    80001224:	ef850513          	addi	a0,a0,-264 # 80007118 <etext+0x118>
    80001228:	d76ff0ef          	jal	8000079e <panic>
      panic("uvmunmap: walk");
    8000122c:	00006517          	auipc	a0,0x6
    80001230:	f0450513          	addi	a0,a0,-252 # 80007130 <etext+0x130>
    80001234:	d6aff0ef          	jal	8000079e <panic>
      panic("uvmunmap: not mapped");
    80001238:	00006517          	auipc	a0,0x6
    8000123c:	f0850513          	addi	a0,a0,-248 # 80007140 <etext+0x140>
    80001240:	d5eff0ef          	jal	8000079e <panic>
      panic("uvmunmap: not a leaf");
    80001244:	00006517          	auipc	a0,0x6
    80001248:	f1450513          	addi	a0,a0,-236 # 80007158 <etext+0x158>
    8000124c:	d52ff0ef          	jal	8000079e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001250:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001254:	995a                	add	s2,s2,s6
    80001256:	03397863          	bgeu	s2,s3,80001286 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000125a:	4601                	li	a2,0
    8000125c:	85ca                	mv	a1,s2
    8000125e:	8552                	mv	a0,s4
    80001260:	d03ff0ef          	jal	80000f62 <walk>
    80001264:	84aa                	mv	s1,a0
    80001266:	d179                	beqz	a0,8000122c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001268:	6108                	ld	a0,0(a0)
    8000126a:	00157793          	andi	a5,a0,1
    8000126e:	d7e9                	beqz	a5,80001238 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001270:	3ff57793          	andi	a5,a0,1023
    80001274:	fd7788e3          	beq	a5,s7,80001244 <uvmunmap+0x64>
    if(do_free){
    80001278:	fc0a8ce3          	beqz	s5,80001250 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000127c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000127e:	0532                	slli	a0,a0,0xc
    80001280:	fc8ff0ef          	jal	80000a48 <kfree>
    80001284:	b7f1                	j	80001250 <uvmunmap+0x70>
    80001286:	74e2                	ld	s1,56(sp)
    80001288:	7942                	ld	s2,48(sp)
    8000128a:	79a2                	ld	s3,40(sp)
    8000128c:	7a02                	ld	s4,32(sp)
    8000128e:	6ae2                	ld	s5,24(sp)
    80001290:	6b42                	ld	s6,16(sp)
    80001292:	6ba2                	ld	s7,8(sp)
  }
}
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	6161                	addi	sp,sp,80
    8000129a:	8082                	ret

000000008000129c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000129c:	1101                	addi	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012a6:	885ff0ef          	jal	80000b2a <kalloc>
    800012aa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012ac:	c509                	beqz	a0,800012b6 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012ae:	6605                	lui	a2,0x1
    800012b0:	4581                	li	a1,0
    800012b2:	a1dff0ef          	jal	80000cce <memset>
  return pagetable;
}
    800012b6:	8526                	mv	a0,s1
    800012b8:	60e2                	ld	ra,24(sp)
    800012ba:	6442                	ld	s0,16(sp)
    800012bc:	64a2                	ld	s1,8(sp)
    800012be:	6105                	addi	sp,sp,32
    800012c0:	8082                	ret

00000000800012c2 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012c2:	7179                	addi	sp,sp,-48
    800012c4:	f406                	sd	ra,40(sp)
    800012c6:	f022                	sd	s0,32(sp)
    800012c8:	ec26                	sd	s1,24(sp)
    800012ca:	e84a                	sd	s2,16(sp)
    800012cc:	e44e                	sd	s3,8(sp)
    800012ce:	e052                	sd	s4,0(sp)
    800012d0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012d2:	6785                	lui	a5,0x1
    800012d4:	04f67063          	bgeu	a2,a5,80001314 <uvmfirst+0x52>
    800012d8:	8a2a                	mv	s4,a0
    800012da:	89ae                	mv	s3,a1
    800012dc:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012de:	84dff0ef          	jal	80000b2a <kalloc>
    800012e2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012e4:	6605                	lui	a2,0x1
    800012e6:	4581                	li	a1,0
    800012e8:	9e7ff0ef          	jal	80000cce <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012ec:	4779                	li	a4,30
    800012ee:	86ca                	mv	a3,s2
    800012f0:	6605                	lui	a2,0x1
    800012f2:	4581                	li	a1,0
    800012f4:	8552                	mv	a0,s4
    800012f6:	d45ff0ef          	jal	8000103a <mappages>
  memmove(mem, src, sz);
    800012fa:	8626                	mv	a2,s1
    800012fc:	85ce                	mv	a1,s3
    800012fe:	854a                	mv	a0,s2
    80001300:	a33ff0ef          	jal	80000d32 <memmove>
}
    80001304:	70a2                	ld	ra,40(sp)
    80001306:	7402                	ld	s0,32(sp)
    80001308:	64e2                	ld	s1,24(sp)
    8000130a:	6942                	ld	s2,16(sp)
    8000130c:	69a2                	ld	s3,8(sp)
    8000130e:	6a02                	ld	s4,0(sp)
    80001310:	6145                	addi	sp,sp,48
    80001312:	8082                	ret
    panic("uvmfirst: more than a page");
    80001314:	00006517          	auipc	a0,0x6
    80001318:	e5c50513          	addi	a0,a0,-420 # 80007170 <etext+0x170>
    8000131c:	c82ff0ef          	jal	8000079e <panic>

0000000080001320 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001320:	1101                	addi	sp,sp,-32
    80001322:	ec06                	sd	ra,24(sp)
    80001324:	e822                	sd	s0,16(sp)
    80001326:	e426                	sd	s1,8(sp)
    80001328:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000132a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000132c:	00b67d63          	bgeu	a2,a1,80001346 <uvmdealloc+0x26>
    80001330:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001332:	6785                	lui	a5,0x1
    80001334:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001336:	00f60733          	add	a4,a2,a5
    8000133a:	76fd                	lui	a3,0xfffff
    8000133c:	8f75                	and	a4,a4,a3
    8000133e:	97ae                	add	a5,a5,a1
    80001340:	8ff5                	and	a5,a5,a3
    80001342:	00f76863          	bltu	a4,a5,80001352 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001346:	8526                	mv	a0,s1
    80001348:	60e2                	ld	ra,24(sp)
    8000134a:	6442                	ld	s0,16(sp)
    8000134c:	64a2                	ld	s1,8(sp)
    8000134e:	6105                	addi	sp,sp,32
    80001350:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001352:	8f99                	sub	a5,a5,a4
    80001354:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001356:	4685                	li	a3,1
    80001358:	0007861b          	sext.w	a2,a5
    8000135c:	85ba                	mv	a1,a4
    8000135e:	e83ff0ef          	jal	800011e0 <uvmunmap>
    80001362:	b7d5                	j	80001346 <uvmdealloc+0x26>

0000000080001364 <uvmalloc>:
  if(newsz < oldsz)
    80001364:	0ab66363          	bltu	a2,a1,8000140a <uvmalloc+0xa6>
{
    80001368:	715d                	addi	sp,sp,-80
    8000136a:	e486                	sd	ra,72(sp)
    8000136c:	e0a2                	sd	s0,64(sp)
    8000136e:	f052                	sd	s4,32(sp)
    80001370:	ec56                	sd	s5,24(sp)
    80001372:	e85a                	sd	s6,16(sp)
    80001374:	0880                	addi	s0,sp,80
    80001376:	8b2a                	mv	s6,a0
    80001378:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    8000137a:	6785                	lui	a5,0x1
    8000137c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000137e:	95be                	add	a1,a1,a5
    80001380:	77fd                	lui	a5,0xfffff
    80001382:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001386:	08ca7463          	bgeu	s4,a2,8000140e <uvmalloc+0xaa>
    8000138a:	fc26                	sd	s1,56(sp)
    8000138c:	f84a                	sd	s2,48(sp)
    8000138e:	f44e                	sd	s3,40(sp)
    80001390:	e45e                	sd	s7,8(sp)
    80001392:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80001394:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001396:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000139a:	f90ff0ef          	jal	80000b2a <kalloc>
    8000139e:	84aa                	mv	s1,a0
    if(mem == 0){
    800013a0:	c515                	beqz	a0,800013cc <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800013a2:	864e                	mv	a2,s3
    800013a4:	4581                	li	a1,0
    800013a6:	929ff0ef          	jal	80000cce <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013aa:	875e                	mv	a4,s7
    800013ac:	86a6                	mv	a3,s1
    800013ae:	864e                	mv	a2,s3
    800013b0:	85ca                	mv	a1,s2
    800013b2:	855a                	mv	a0,s6
    800013b4:	c87ff0ef          	jal	8000103a <mappages>
    800013b8:	e91d                	bnez	a0,800013ee <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013ba:	994e                	add	s2,s2,s3
    800013bc:	fd596fe3          	bltu	s2,s5,8000139a <uvmalloc+0x36>
  return newsz;
    800013c0:	8556                	mv	a0,s5
    800013c2:	74e2                	ld	s1,56(sp)
    800013c4:	7942                	ld	s2,48(sp)
    800013c6:	79a2                	ld	s3,40(sp)
    800013c8:	6ba2                	ld	s7,8(sp)
    800013ca:	a819                	j	800013e0 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    800013cc:	8652                	mv	a2,s4
    800013ce:	85ca                	mv	a1,s2
    800013d0:	855a                	mv	a0,s6
    800013d2:	f4fff0ef          	jal	80001320 <uvmdealloc>
      return 0;
    800013d6:	4501                	li	a0,0
    800013d8:	74e2                	ld	s1,56(sp)
    800013da:	7942                	ld	s2,48(sp)
    800013dc:	79a2                	ld	s3,40(sp)
    800013de:	6ba2                	ld	s7,8(sp)
}
    800013e0:	60a6                	ld	ra,72(sp)
    800013e2:	6406                	ld	s0,64(sp)
    800013e4:	7a02                	ld	s4,32(sp)
    800013e6:	6ae2                	ld	s5,24(sp)
    800013e8:	6b42                	ld	s6,16(sp)
    800013ea:	6161                	addi	sp,sp,80
    800013ec:	8082                	ret
      kfree(mem);
    800013ee:	8526                	mv	a0,s1
    800013f0:	e58ff0ef          	jal	80000a48 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013f4:	8652                	mv	a2,s4
    800013f6:	85ca                	mv	a1,s2
    800013f8:	855a                	mv	a0,s6
    800013fa:	f27ff0ef          	jal	80001320 <uvmdealloc>
      return 0;
    800013fe:	4501                	li	a0,0
    80001400:	74e2                	ld	s1,56(sp)
    80001402:	7942                	ld	s2,48(sp)
    80001404:	79a2                	ld	s3,40(sp)
    80001406:	6ba2                	ld	s7,8(sp)
    80001408:	bfe1                	j	800013e0 <uvmalloc+0x7c>
    return oldsz;
    8000140a:	852e                	mv	a0,a1
}
    8000140c:	8082                	ret
  return newsz;
    8000140e:	8532                	mv	a0,a2
    80001410:	bfc1                	j	800013e0 <uvmalloc+0x7c>

0000000080001412 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001412:	7179                	addi	sp,sp,-48
    80001414:	f406                	sd	ra,40(sp)
    80001416:	f022                	sd	s0,32(sp)
    80001418:	ec26                	sd	s1,24(sp)
    8000141a:	e84a                	sd	s2,16(sp)
    8000141c:	e44e                	sd	s3,8(sp)
    8000141e:	e052                	sd	s4,0(sp)
    80001420:	1800                	addi	s0,sp,48
    80001422:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001424:	84aa                	mv	s1,a0
    80001426:	6905                	lui	s2,0x1
    80001428:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000142a:	4985                	li	s3,1
    8000142c:	a819                	j	80001442 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000142e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001430:	00c79513          	slli	a0,a5,0xc
    80001434:	fdfff0ef          	jal	80001412 <freewalk>
      pagetable[i] = 0;
    80001438:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000143c:	04a1                	addi	s1,s1,8
    8000143e:	01248f63          	beq	s1,s2,8000145c <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001442:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001444:	00f7f713          	andi	a4,a5,15
    80001448:	ff3703e3          	beq	a4,s3,8000142e <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000144c:	8b85                	andi	a5,a5,1
    8000144e:	d7fd                	beqz	a5,8000143c <freewalk+0x2a>
      panic("freewalk: leaf");
    80001450:	00006517          	auipc	a0,0x6
    80001454:	d4050513          	addi	a0,a0,-704 # 80007190 <etext+0x190>
    80001458:	b46ff0ef          	jal	8000079e <panic>
    }
  }
  kfree((void*)pagetable);
    8000145c:	8552                	mv	a0,s4
    8000145e:	deaff0ef          	jal	80000a48 <kfree>
}
    80001462:	70a2                	ld	ra,40(sp)
    80001464:	7402                	ld	s0,32(sp)
    80001466:	64e2                	ld	s1,24(sp)
    80001468:	6942                	ld	s2,16(sp)
    8000146a:	69a2                	ld	s3,8(sp)
    8000146c:	6a02                	ld	s4,0(sp)
    8000146e:	6145                	addi	sp,sp,48
    80001470:	8082                	ret

0000000080001472 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001472:	1101                	addi	sp,sp,-32
    80001474:	ec06                	sd	ra,24(sp)
    80001476:	e822                	sd	s0,16(sp)
    80001478:	e426                	sd	s1,8(sp)
    8000147a:	1000                	addi	s0,sp,32
    8000147c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000147e:	e989                	bnez	a1,80001490 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001480:	8526                	mv	a0,s1
    80001482:	f91ff0ef          	jal	80001412 <freewalk>
}
    80001486:	60e2                	ld	ra,24(sp)
    80001488:	6442                	ld	s0,16(sp)
    8000148a:	64a2                	ld	s1,8(sp)
    8000148c:	6105                	addi	sp,sp,32
    8000148e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001490:	6785                	lui	a5,0x1
    80001492:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001494:	95be                	add	a1,a1,a5
    80001496:	4685                	li	a3,1
    80001498:	00c5d613          	srli	a2,a1,0xc
    8000149c:	4581                	li	a1,0
    8000149e:	d43ff0ef          	jal	800011e0 <uvmunmap>
    800014a2:	bff9                	j	80001480 <uvmfree+0xe>

00000000800014a4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800014a4:	ca4d                	beqz	a2,80001556 <uvmcopy+0xb2>
{
    800014a6:	715d                	addi	sp,sp,-80
    800014a8:	e486                	sd	ra,72(sp)
    800014aa:	e0a2                	sd	s0,64(sp)
    800014ac:	fc26                	sd	s1,56(sp)
    800014ae:	f84a                	sd	s2,48(sp)
    800014b0:	f44e                	sd	s3,40(sp)
    800014b2:	f052                	sd	s4,32(sp)
    800014b4:	ec56                	sd	s5,24(sp)
    800014b6:	e85a                	sd	s6,16(sp)
    800014b8:	e45e                	sd	s7,8(sp)
    800014ba:	e062                	sd	s8,0(sp)
    800014bc:	0880                	addi	s0,sp,80
    800014be:	8baa                	mv	s7,a0
    800014c0:	8b2e                	mv	s6,a1
    800014c2:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014c4:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014c6:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    800014c8:	4601                	li	a2,0
    800014ca:	85ce                	mv	a1,s3
    800014cc:	855e                	mv	a0,s7
    800014ce:	a95ff0ef          	jal	80000f62 <walk>
    800014d2:	cd1d                	beqz	a0,80001510 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    800014d4:	6118                	ld	a4,0(a0)
    800014d6:	00177793          	andi	a5,a4,1
    800014da:	c3a9                	beqz	a5,8000151c <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    800014dc:	00a75593          	srli	a1,a4,0xa
    800014e0:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014e4:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014e8:	e42ff0ef          	jal	80000b2a <kalloc>
    800014ec:	892a                	mv	s2,a0
    800014ee:	c121                	beqz	a0,8000152e <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    800014f0:	8652                	mv	a2,s4
    800014f2:	85e2                	mv	a1,s8
    800014f4:	83fff0ef          	jal	80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014f8:	8726                	mv	a4,s1
    800014fa:	86ca                	mv	a3,s2
    800014fc:	8652                	mv	a2,s4
    800014fe:	85ce                	mv	a1,s3
    80001500:	855a                	mv	a0,s6
    80001502:	b39ff0ef          	jal	8000103a <mappages>
    80001506:	e10d                	bnez	a0,80001528 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    80001508:	99d2                	add	s3,s3,s4
    8000150a:	fb59efe3          	bltu	s3,s5,800014c8 <uvmcopy+0x24>
    8000150e:	a805                	j	8000153e <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    80001510:	00006517          	auipc	a0,0x6
    80001514:	c9050513          	addi	a0,a0,-880 # 800071a0 <etext+0x1a0>
    80001518:	a86ff0ef          	jal	8000079e <panic>
      panic("uvmcopy: page not present");
    8000151c:	00006517          	auipc	a0,0x6
    80001520:	ca450513          	addi	a0,a0,-860 # 800071c0 <etext+0x1c0>
    80001524:	a7aff0ef          	jal	8000079e <panic>
      kfree(mem);
    80001528:	854a                	mv	a0,s2
    8000152a:	d1eff0ef          	jal	80000a48 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000152e:	4685                	li	a3,1
    80001530:	00c9d613          	srli	a2,s3,0xc
    80001534:	4581                	li	a1,0
    80001536:	855a                	mv	a0,s6
    80001538:	ca9ff0ef          	jal	800011e0 <uvmunmap>
  return -1;
    8000153c:	557d                	li	a0,-1
}
    8000153e:	60a6                	ld	ra,72(sp)
    80001540:	6406                	ld	s0,64(sp)
    80001542:	74e2                	ld	s1,56(sp)
    80001544:	7942                	ld	s2,48(sp)
    80001546:	79a2                	ld	s3,40(sp)
    80001548:	7a02                	ld	s4,32(sp)
    8000154a:	6ae2                	ld	s5,24(sp)
    8000154c:	6b42                	ld	s6,16(sp)
    8000154e:	6ba2                	ld	s7,8(sp)
    80001550:	6c02                	ld	s8,0(sp)
    80001552:	6161                	addi	sp,sp,80
    80001554:	8082                	ret
  return 0;
    80001556:	4501                	li	a0,0
}
    80001558:	8082                	ret

000000008000155a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000155a:	1141                	addi	sp,sp,-16
    8000155c:	e406                	sd	ra,8(sp)
    8000155e:	e022                	sd	s0,0(sp)
    80001560:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001562:	4601                	li	a2,0
    80001564:	9ffff0ef          	jal	80000f62 <walk>
  if(pte == 0)
    80001568:	c901                	beqz	a0,80001578 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000156a:	611c                	ld	a5,0(a0)
    8000156c:	9bbd                	andi	a5,a5,-17
    8000156e:	e11c                	sd	a5,0(a0)
}
    80001570:	60a2                	ld	ra,8(sp)
    80001572:	6402                	ld	s0,0(sp)
    80001574:	0141                	addi	sp,sp,16
    80001576:	8082                	ret
    panic("uvmclear");
    80001578:	00006517          	auipc	a0,0x6
    8000157c:	c6850513          	addi	a0,a0,-920 # 800071e0 <etext+0x1e0>
    80001580:	a1eff0ef          	jal	8000079e <panic>

0000000080001584 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001584:	c2d9                	beqz	a3,8000160a <copyout+0x86>
{
    80001586:	711d                	addi	sp,sp,-96
    80001588:	ec86                	sd	ra,88(sp)
    8000158a:	e8a2                	sd	s0,80(sp)
    8000158c:	e4a6                	sd	s1,72(sp)
    8000158e:	e0ca                	sd	s2,64(sp)
    80001590:	fc4e                	sd	s3,56(sp)
    80001592:	f852                	sd	s4,48(sp)
    80001594:	f456                	sd	s5,40(sp)
    80001596:	f05a                	sd	s6,32(sp)
    80001598:	ec5e                	sd	s7,24(sp)
    8000159a:	e862                	sd	s8,16(sp)
    8000159c:	e466                	sd	s9,8(sp)
    8000159e:	e06a                	sd	s10,0(sp)
    800015a0:	1080                	addi	s0,sp,96
    800015a2:	8c2a                	mv	s8,a0
    800015a4:	892e                	mv	s2,a1
    800015a6:	8ab2                	mv	s5,a2
    800015a8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    800015aa:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    800015ac:	5bfd                	li	s7,-1
    800015ae:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015b2:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    800015b4:	6b05                	lui	s6,0x1
    800015b6:	a015                	j	800015da <copyout+0x56>
    pa0 = PTE2PA(*pte);
    800015b8:	83a9                	srli	a5,a5,0xa
    800015ba:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015bc:	41390533          	sub	a0,s2,s3
    800015c0:	0004861b          	sext.w	a2,s1
    800015c4:	85d6                	mv	a1,s5
    800015c6:	953e                	add	a0,a0,a5
    800015c8:	f6aff0ef          	jal	80000d32 <memmove>

    len -= n;
    800015cc:	409a0a33          	sub	s4,s4,s1
    src += n;
    800015d0:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    800015d2:	01698933          	add	s2,s3,s6
  while(len > 0){
    800015d6:	020a0863          	beqz	s4,80001606 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    800015da:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    800015de:	033be863          	bltu	s7,s3,8000160e <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    800015e2:	4601                	li	a2,0
    800015e4:	85ce                	mv	a1,s3
    800015e6:	8562                	mv	a0,s8
    800015e8:	97bff0ef          	jal	80000f62 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ec:	c121                	beqz	a0,8000162c <copyout+0xa8>
    800015ee:	611c                	ld	a5,0(a0)
    800015f0:	0157f713          	andi	a4,a5,21
    800015f4:	03a71e63          	bne	a4,s10,80001630 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    800015f8:	412984b3          	sub	s1,s3,s2
    800015fc:	94da                	add	s1,s1,s6
    if(n > len)
    800015fe:	fa9a7de3          	bgeu	s4,s1,800015b8 <copyout+0x34>
    80001602:	84d2                	mv	s1,s4
    80001604:	bf55                	j	800015b8 <copyout+0x34>
  }
  return 0;
    80001606:	4501                	li	a0,0
    80001608:	a021                	j	80001610 <copyout+0x8c>
    8000160a:	4501                	li	a0,0
}
    8000160c:	8082                	ret
      return -1;
    8000160e:	557d                	li	a0,-1
}
    80001610:	60e6                	ld	ra,88(sp)
    80001612:	6446                	ld	s0,80(sp)
    80001614:	64a6                	ld	s1,72(sp)
    80001616:	6906                	ld	s2,64(sp)
    80001618:	79e2                	ld	s3,56(sp)
    8000161a:	7a42                	ld	s4,48(sp)
    8000161c:	7aa2                	ld	s5,40(sp)
    8000161e:	7b02                	ld	s6,32(sp)
    80001620:	6be2                	ld	s7,24(sp)
    80001622:	6c42                	ld	s8,16(sp)
    80001624:	6ca2                	ld	s9,8(sp)
    80001626:	6d02                	ld	s10,0(sp)
    80001628:	6125                	addi	sp,sp,96
    8000162a:	8082                	ret
      return -1;
    8000162c:	557d                	li	a0,-1
    8000162e:	b7cd                	j	80001610 <copyout+0x8c>
    80001630:	557d                	li	a0,-1
    80001632:	bff9                	j	80001610 <copyout+0x8c>

0000000080001634 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001634:	c6a5                	beqz	a3,8000169c <copyin+0x68>
{
    80001636:	715d                	addi	sp,sp,-80
    80001638:	e486                	sd	ra,72(sp)
    8000163a:	e0a2                	sd	s0,64(sp)
    8000163c:	fc26                	sd	s1,56(sp)
    8000163e:	f84a                	sd	s2,48(sp)
    80001640:	f44e                	sd	s3,40(sp)
    80001642:	f052                	sd	s4,32(sp)
    80001644:	ec56                	sd	s5,24(sp)
    80001646:	e85a                	sd	s6,16(sp)
    80001648:	e45e                	sd	s7,8(sp)
    8000164a:	e062                	sd	s8,0(sp)
    8000164c:	0880                	addi	s0,sp,80
    8000164e:	8b2a                	mv	s6,a0
    80001650:	8a2e                	mv	s4,a1
    80001652:	8c32                	mv	s8,a2
    80001654:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001656:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001658:	6a85                	lui	s5,0x1
    8000165a:	a00d                	j	8000167c <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000165c:	018505b3          	add	a1,a0,s8
    80001660:	0004861b          	sext.w	a2,s1
    80001664:	412585b3          	sub	a1,a1,s2
    80001668:	8552                	mv	a0,s4
    8000166a:	ec8ff0ef          	jal	80000d32 <memmove>

    len -= n;
    8000166e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001672:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001674:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001678:	02098063          	beqz	s3,80001698 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    8000167c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001680:	85ca                	mv	a1,s2
    80001682:	855a                	mv	a0,s6
    80001684:	979ff0ef          	jal	80000ffc <walkaddr>
    if(pa0 == 0)
    80001688:	cd01                	beqz	a0,800016a0 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000168a:	418904b3          	sub	s1,s2,s8
    8000168e:	94d6                	add	s1,s1,s5
    if(n > len)
    80001690:	fc99f6e3          	bgeu	s3,s1,8000165c <copyin+0x28>
    80001694:	84ce                	mv	s1,s3
    80001696:	b7d9                	j	8000165c <copyin+0x28>
  }
  return 0;
    80001698:	4501                	li	a0,0
    8000169a:	a021                	j	800016a2 <copyin+0x6e>
    8000169c:	4501                	li	a0,0
}
    8000169e:	8082                	ret
      return -1;
    800016a0:	557d                	li	a0,-1
}
    800016a2:	60a6                	ld	ra,72(sp)
    800016a4:	6406                	ld	s0,64(sp)
    800016a6:	74e2                	ld	s1,56(sp)
    800016a8:	7942                	ld	s2,48(sp)
    800016aa:	79a2                	ld	s3,40(sp)
    800016ac:	7a02                	ld	s4,32(sp)
    800016ae:	6ae2                	ld	s5,24(sp)
    800016b0:	6b42                	ld	s6,16(sp)
    800016b2:	6ba2                	ld	s7,8(sp)
    800016b4:	6c02                	ld	s8,0(sp)
    800016b6:	6161                	addi	sp,sp,80
    800016b8:	8082                	ret

00000000800016ba <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800016ba:	715d                	addi	sp,sp,-80
    800016bc:	e486                	sd	ra,72(sp)
    800016be:	e0a2                	sd	s0,64(sp)
    800016c0:	fc26                	sd	s1,56(sp)
    800016c2:	f84a                	sd	s2,48(sp)
    800016c4:	f44e                	sd	s3,40(sp)
    800016c6:	f052                	sd	s4,32(sp)
    800016c8:	ec56                	sd	s5,24(sp)
    800016ca:	e85a                	sd	s6,16(sp)
    800016cc:	e45e                	sd	s7,8(sp)
    800016ce:	0880                	addi	s0,sp,80
    800016d0:	8aaa                	mv	s5,a0
    800016d2:	89ae                	mv	s3,a1
    800016d4:	8bb2                	mv	s7,a2
    800016d6:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    800016d8:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016da:	6a05                	lui	s4,0x1
    800016dc:	a02d                	j	80001706 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016de:	00078023          	sb	zero,0(a5)
    800016e2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016e4:	0017c793          	xori	a5,a5,1
    800016e8:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016ec:	60a6                	ld	ra,72(sp)
    800016ee:	6406                	ld	s0,64(sp)
    800016f0:	74e2                	ld	s1,56(sp)
    800016f2:	7942                	ld	s2,48(sp)
    800016f4:	79a2                	ld	s3,40(sp)
    800016f6:	7a02                	ld	s4,32(sp)
    800016f8:	6ae2                	ld	s5,24(sp)
    800016fa:	6b42                	ld	s6,16(sp)
    800016fc:	6ba2                	ld	s7,8(sp)
    800016fe:	6161                	addi	sp,sp,80
    80001700:	8082                	ret
    srcva = va0 + PGSIZE;
    80001702:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001706:	c4b1                	beqz	s1,80001752 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80001708:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000170c:	85ca                	mv	a1,s2
    8000170e:	8556                	mv	a0,s5
    80001710:	8edff0ef          	jal	80000ffc <walkaddr>
    if(pa0 == 0)
    80001714:	c129                	beqz	a0,80001756 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80001716:	41790633          	sub	a2,s2,s7
    8000171a:	9652                	add	a2,a2,s4
    if(n > max)
    8000171c:	00c4f363          	bgeu	s1,a2,80001722 <copyinstr+0x68>
    80001720:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001722:	412b8bb3          	sub	s7,s7,s2
    80001726:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001728:	de69                	beqz	a2,80001702 <copyinstr+0x48>
    8000172a:	87ce                	mv	a5,s3
      if(*p == '\0'){
    8000172c:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80001730:	964e                	add	a2,a2,s3
    80001732:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001734:	00f68733          	add	a4,a3,a5
    80001738:	00074703          	lbu	a4,0(a4)
    8000173c:	d34d                	beqz	a4,800016de <copyinstr+0x24>
        *dst = *p;
    8000173e:	00e78023          	sb	a4,0(a5)
      dst++;
    80001742:	0785                	addi	a5,a5,1
    while(n > 0){
    80001744:	fec797e3          	bne	a5,a2,80001732 <copyinstr+0x78>
    80001748:	14fd                	addi	s1,s1,-1
    8000174a:	94ce                	add	s1,s1,s3
      --max;
    8000174c:	8c8d                	sub	s1,s1,a1
    8000174e:	89be                	mv	s3,a5
    80001750:	bf4d                	j	80001702 <copyinstr+0x48>
    80001752:	4781                	li	a5,0
    80001754:	bf41                	j	800016e4 <copyinstr+0x2a>
      return -1;
    80001756:	557d                	li	a0,-1
    80001758:	bf51                	j	800016ec <copyinstr+0x32>

000000008000175a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000175a:	715d                	addi	sp,sp,-80
    8000175c:	e486                	sd	ra,72(sp)
    8000175e:	e0a2                	sd	s0,64(sp)
    80001760:	fc26                	sd	s1,56(sp)
    80001762:	f84a                	sd	s2,48(sp)
    80001764:	f44e                	sd	s3,40(sp)
    80001766:	f052                	sd	s4,32(sp)
    80001768:	ec56                	sd	s5,24(sp)
    8000176a:	e85a                	sd	s6,16(sp)
    8000176c:	e45e                	sd	s7,8(sp)
    8000176e:	e062                	sd	s8,0(sp)
    80001770:	0880                	addi	s0,sp,80
    80001772:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001774:	00011497          	auipc	s1,0x11
    80001778:	58c48493          	addi	s1,s1,1420 # 80012d00 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000177c:	8c26                	mv	s8,s1
    8000177e:	1a1f67b7          	lui	a5,0x1a1f6
    80001782:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    80001786:	7d634937          	lui	s2,0x7d634
    8000178a:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    8000178e:	1902                	slli	s2,s2,0x20
    80001790:	993e                	add	s2,s2,a5
    80001792:	040009b7          	lui	s3,0x4000
    80001796:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001798:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000179a:	4b99                	li	s7,6
    8000179c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    8000179e:	00017a97          	auipc	s5,0x17
    800017a2:	762a8a93          	addi	s5,s5,1890 # 80018f00 <tickslock>
    char *pa = kalloc();
    800017a6:	b84ff0ef          	jal	80000b2a <kalloc>
    800017aa:	862a                	mv	a2,a0
    if(pa == 0)
    800017ac:	c121                	beqz	a0,800017ec <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    800017ae:	418485b3          	sub	a1,s1,s8
    800017b2:	858d                	srai	a1,a1,0x3
    800017b4:	032585b3          	mul	a1,a1,s2
    800017b8:	2585                	addiw	a1,a1,1
    800017ba:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017be:	875e                	mv	a4,s7
    800017c0:	86da                	mv	a3,s6
    800017c2:	40b985b3          	sub	a1,s3,a1
    800017c6:	8552                	mv	a0,s4
    800017c8:	929ff0ef          	jal	800010f0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017cc:	18848493          	addi	s1,s1,392
    800017d0:	fd549be3          	bne	s1,s5,800017a6 <proc_mapstacks+0x4c>
  }
}
    800017d4:	60a6                	ld	ra,72(sp)
    800017d6:	6406                	ld	s0,64(sp)
    800017d8:	74e2                	ld	s1,56(sp)
    800017da:	7942                	ld	s2,48(sp)
    800017dc:	79a2                	ld	s3,40(sp)
    800017de:	7a02                	ld	s4,32(sp)
    800017e0:	6ae2                	ld	s5,24(sp)
    800017e2:	6b42                	ld	s6,16(sp)
    800017e4:	6ba2                	ld	s7,8(sp)
    800017e6:	6c02                	ld	s8,0(sp)
    800017e8:	6161                	addi	sp,sp,80
    800017ea:	8082                	ret
      panic("kalloc");
    800017ec:	00006517          	auipc	a0,0x6
    800017f0:	a0450513          	addi	a0,a0,-1532 # 800071f0 <etext+0x1f0>
    800017f4:	fabfe0ef          	jal	8000079e <panic>

00000000800017f8 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017f8:	7139                	addi	sp,sp,-64
    800017fa:	fc06                	sd	ra,56(sp)
    800017fc:	f822                	sd	s0,48(sp)
    800017fe:	f426                	sd	s1,40(sp)
    80001800:	f04a                	sd	s2,32(sp)
    80001802:	ec4e                	sd	s3,24(sp)
    80001804:	e852                	sd	s4,16(sp)
    80001806:	e456                	sd	s5,8(sp)
    80001808:	e05a                	sd	s6,0(sp)
    8000180a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000180c:	00006597          	auipc	a1,0x6
    80001810:	9ec58593          	addi	a1,a1,-1556 # 800071f8 <etext+0x1f8>
    80001814:	00011517          	auipc	a0,0x11
    80001818:	0bc50513          	addi	a0,a0,188 # 800128d0 <pid_lock>
    8000181c:	b5eff0ef          	jal	80000b7a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001820:	00006597          	auipc	a1,0x6
    80001824:	9e058593          	addi	a1,a1,-1568 # 80007200 <etext+0x200>
    80001828:	00011517          	auipc	a0,0x11
    8000182c:	0c050513          	addi	a0,a0,192 # 800128e8 <wait_lock>
    80001830:	b4aff0ef          	jal	80000b7a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001834:	00011497          	auipc	s1,0x11
    80001838:	4cc48493          	addi	s1,s1,1228 # 80012d00 <proc>
      initlock(&p->lock, "proc");
    8000183c:	00006b17          	auipc	s6,0x6
    80001840:	9d4b0b13          	addi	s6,s6,-1580 # 80007210 <etext+0x210>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001844:	8aa6                	mv	s5,s1
    80001846:	1a1f67b7          	lui	a5,0x1a1f6
    8000184a:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    8000184e:	7d634937          	lui	s2,0x7d634
    80001852:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    80001856:	1902                	slli	s2,s2,0x20
    80001858:	993e                	add	s2,s2,a5
    8000185a:	040009b7          	lui	s3,0x4000
    8000185e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001860:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001862:	00017a17          	auipc	s4,0x17
    80001866:	69ea0a13          	addi	s4,s4,1694 # 80018f00 <tickslock>
      initlock(&p->lock, "proc");
    8000186a:	85da                	mv	a1,s6
    8000186c:	8526                	mv	a0,s1
    8000186e:	b0cff0ef          	jal	80000b7a <initlock>
      p->state = UNUSED;
    80001872:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001876:	415487b3          	sub	a5,s1,s5
    8000187a:	878d                	srai	a5,a5,0x3
    8000187c:	032787b3          	mul	a5,a5,s2
    80001880:	2785                	addiw	a5,a5,1
    80001882:	00d7979b          	slliw	a5,a5,0xd
    80001886:	40f987b3          	sub	a5,s3,a5
    8000188a:	f0bc                	sd	a5,96(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188c:	18848493          	addi	s1,s1,392
    80001890:	fd449de3          	bne	s1,s4,8000186a <procinit+0x72>
  }
}
    80001894:	70e2                	ld	ra,56(sp)
    80001896:	7442                	ld	s0,48(sp)
    80001898:	74a2                	ld	s1,40(sp)
    8000189a:	7902                	ld	s2,32(sp)
    8000189c:	69e2                	ld	s3,24(sp)
    8000189e:	6a42                	ld	s4,16(sp)
    800018a0:	6aa2                	ld	s5,8(sp)
    800018a2:	6b02                	ld	s6,0(sp)
    800018a4:	6121                	addi	sp,sp,64
    800018a6:	8082                	ret

00000000800018a8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018a8:	1141                	addi	sp,sp,-16
    800018aa:	e406                	sd	ra,8(sp)
    800018ac:	e022                	sd	s0,0(sp)
    800018ae:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018b0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018b2:	2501                	sext.w	a0,a0
    800018b4:	60a2                	ld	ra,8(sp)
    800018b6:	6402                	ld	s0,0(sp)
    800018b8:	0141                	addi	sp,sp,16
    800018ba:	8082                	ret

00000000800018bc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018bc:	1141                	addi	sp,sp,-16
    800018be:	e406                	sd	ra,8(sp)
    800018c0:	e022                	sd	s0,0(sp)
    800018c2:	0800                	addi	s0,sp,16
    800018c4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018c6:	2781                	sext.w	a5,a5
    800018c8:	079e                	slli	a5,a5,0x7
  return c;
}
    800018ca:	00011517          	auipc	a0,0x11
    800018ce:	03650513          	addi	a0,a0,54 # 80012900 <cpus>
    800018d2:	953e                	add	a0,a0,a5
    800018d4:	60a2                	ld	ra,8(sp)
    800018d6:	6402                	ld	s0,0(sp)
    800018d8:	0141                	addi	sp,sp,16
    800018da:	8082                	ret

00000000800018dc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018dc:	1101                	addi	sp,sp,-32
    800018de:	ec06                	sd	ra,24(sp)
    800018e0:	e822                	sd	s0,16(sp)
    800018e2:	e426                	sd	s1,8(sp)
    800018e4:	1000                	addi	s0,sp,32
  push_off();
    800018e6:	ad8ff0ef          	jal	80000bbe <push_off>
    800018ea:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018ec:	2781                	sext.w	a5,a5
    800018ee:	079e                	slli	a5,a5,0x7
    800018f0:	00011717          	auipc	a4,0x11
    800018f4:	fe070713          	addi	a4,a4,-32 # 800128d0 <pid_lock>
    800018f8:	97ba                	add	a5,a5,a4
    800018fa:	7b84                	ld	s1,48(a5)
  pop_off();
    800018fc:	b46ff0ef          	jal	80000c42 <pop_off>
  return p;
}
    80001900:	8526                	mv	a0,s1
    80001902:	60e2                	ld	ra,24(sp)
    80001904:	6442                	ld	s0,16(sp)
    80001906:	64a2                	ld	s1,8(sp)
    80001908:	6105                	addi	sp,sp,32
    8000190a:	8082                	ret

000000008000190c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000190c:	1141                	addi	sp,sp,-16
    8000190e:	e406                	sd	ra,8(sp)
    80001910:	e022                	sd	s0,0(sp)
    80001912:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001914:	fc9ff0ef          	jal	800018dc <myproc>
    80001918:	b7aff0ef          	jal	80000c92 <release>

  if (first) {
    8000191c:	00009797          	auipc	a5,0x9
    80001920:	de47a783          	lw	a5,-540(a5) # 8000a700 <first.1>
    80001924:	e799                	bnez	a5,80001932 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001926:	60f000ef          	jal	80002734 <usertrapret>
}
    8000192a:	60a2                	ld	ra,8(sp)
    8000192c:	6402                	ld	s0,0(sp)
    8000192e:	0141                	addi	sp,sp,16
    80001930:	8082                	ret
    fsinit(ROOTDEV);
    80001932:	4505                	li	a0,1
    80001934:	229010ef          	jal	8000335c <fsinit>
    first = 0;
    80001938:	00009797          	auipc	a5,0x9
    8000193c:	dc07a423          	sw	zero,-568(a5) # 8000a700 <first.1>
    __sync_synchronize();
    80001940:	0330000f          	fence	rw,rw
    80001944:	b7cd                	j	80001926 <forkret+0x1a>

0000000080001946 <allocpid>:
{
    80001946:	1101                	addi	sp,sp,-32
    80001948:	ec06                	sd	ra,24(sp)
    8000194a:	e822                	sd	s0,16(sp)
    8000194c:	e426                	sd	s1,8(sp)
    8000194e:	e04a                	sd	s2,0(sp)
    80001950:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001952:	00011917          	auipc	s2,0x11
    80001956:	f7e90913          	addi	s2,s2,-130 # 800128d0 <pid_lock>
    8000195a:	854a                	mv	a0,s2
    8000195c:	aa2ff0ef          	jal	80000bfe <acquire>
  pid = nextpid;
    80001960:	00009797          	auipc	a5,0x9
    80001964:	da478793          	addi	a5,a5,-604 # 8000a704 <nextpid>
    80001968:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000196a:	0014871b          	addiw	a4,s1,1
    8000196e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001970:	854a                	mv	a0,s2
    80001972:	b20ff0ef          	jal	80000c92 <release>
}
    80001976:	8526                	mv	a0,s1
    80001978:	60e2                	ld	ra,24(sp)
    8000197a:	6442                	ld	s0,16(sp)
    8000197c:	64a2                	ld	s1,8(sp)
    8000197e:	6902                	ld	s2,0(sp)
    80001980:	6105                	addi	sp,sp,32
    80001982:	8082                	ret

0000000080001984 <proc_pagetable>:
{
    80001984:	1101                	addi	sp,sp,-32
    80001986:	ec06                	sd	ra,24(sp)
    80001988:	e822                	sd	s0,16(sp)
    8000198a:	e426                	sd	s1,8(sp)
    8000198c:	e04a                	sd	s2,0(sp)
    8000198e:	1000                	addi	s0,sp,32
    80001990:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001992:	90bff0ef          	jal	8000129c <uvmcreate>
    80001996:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001998:	cd05                	beqz	a0,800019d0 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000199a:	4729                	li	a4,10
    8000199c:	00004697          	auipc	a3,0x4
    800019a0:	66468693          	addi	a3,a3,1636 # 80006000 <_trampoline>
    800019a4:	6605                	lui	a2,0x1
    800019a6:	040005b7          	lui	a1,0x4000
    800019aa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019ac:	05b2                	slli	a1,a1,0xc
    800019ae:	e8cff0ef          	jal	8000103a <mappages>
    800019b2:	02054663          	bltz	a0,800019de <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019b6:	4719                	li	a4,6
    800019b8:	07893683          	ld	a3,120(s2)
    800019bc:	6605                	lui	a2,0x1
    800019be:	020005b7          	lui	a1,0x2000
    800019c2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019c4:	05b6                	slli	a1,a1,0xd
    800019c6:	8526                	mv	a0,s1
    800019c8:	e72ff0ef          	jal	8000103a <mappages>
    800019cc:	00054f63          	bltz	a0,800019ea <proc_pagetable+0x66>
}
    800019d0:	8526                	mv	a0,s1
    800019d2:	60e2                	ld	ra,24(sp)
    800019d4:	6442                	ld	s0,16(sp)
    800019d6:	64a2                	ld	s1,8(sp)
    800019d8:	6902                	ld	s2,0(sp)
    800019da:	6105                	addi	sp,sp,32
    800019dc:	8082                	ret
    uvmfree(pagetable, 0);
    800019de:	4581                	li	a1,0
    800019e0:	8526                	mv	a0,s1
    800019e2:	a91ff0ef          	jal	80001472 <uvmfree>
    return 0;
    800019e6:	4481                	li	s1,0
    800019e8:	b7e5                	j	800019d0 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019ea:	4681                	li	a3,0
    800019ec:	4605                	li	a2,1
    800019ee:	040005b7          	lui	a1,0x4000
    800019f2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019f4:	05b2                	slli	a1,a1,0xc
    800019f6:	8526                	mv	a0,s1
    800019f8:	fe8ff0ef          	jal	800011e0 <uvmunmap>
    uvmfree(pagetable, 0);
    800019fc:	4581                	li	a1,0
    800019fe:	8526                	mv	a0,s1
    80001a00:	a73ff0ef          	jal	80001472 <uvmfree>
    return 0;
    80001a04:	4481                	li	s1,0
    80001a06:	b7e9                	j	800019d0 <proc_pagetable+0x4c>

0000000080001a08 <proc_freepagetable>:
{
    80001a08:	1101                	addi	sp,sp,-32
    80001a0a:	ec06                	sd	ra,24(sp)
    80001a0c:	e822                	sd	s0,16(sp)
    80001a0e:	e426                	sd	s1,8(sp)
    80001a10:	e04a                	sd	s2,0(sp)
    80001a12:	1000                	addi	s0,sp,32
    80001a14:	84aa                	mv	s1,a0
    80001a16:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a18:	4681                	li	a3,0
    80001a1a:	4605                	li	a2,1
    80001a1c:	040005b7          	lui	a1,0x4000
    80001a20:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a22:	05b2                	slli	a1,a1,0xc
    80001a24:	fbcff0ef          	jal	800011e0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a28:	4681                	li	a3,0
    80001a2a:	4605                	li	a2,1
    80001a2c:	020005b7          	lui	a1,0x2000
    80001a30:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a32:	05b6                	slli	a1,a1,0xd
    80001a34:	8526                	mv	a0,s1
    80001a36:	faaff0ef          	jal	800011e0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a3a:	85ca                	mv	a1,s2
    80001a3c:	8526                	mv	a0,s1
    80001a3e:	a35ff0ef          	jal	80001472 <uvmfree>
}
    80001a42:	60e2                	ld	ra,24(sp)
    80001a44:	6442                	ld	s0,16(sp)
    80001a46:	64a2                	ld	s1,8(sp)
    80001a48:	6902                	ld	s2,0(sp)
    80001a4a:	6105                	addi	sp,sp,32
    80001a4c:	8082                	ret

0000000080001a4e <freeproc>:
{
    80001a4e:	1101                	addi	sp,sp,-32
    80001a50:	ec06                	sd	ra,24(sp)
    80001a52:	e822                	sd	s0,16(sp)
    80001a54:	e426                	sd	s1,8(sp)
    80001a56:	1000                	addi	s0,sp,32
    80001a58:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a5a:	7d28                	ld	a0,120(a0)
    80001a5c:	c119                	beqz	a0,80001a62 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a5e:	febfe0ef          	jal	80000a48 <kfree>
  p->trapframe = 0;
    80001a62:	0604bc23          	sd	zero,120(s1)
  if(p->pagetable && !p->is_thread)
    80001a66:	78a8                	ld	a0,112(s1)
    80001a68:	c119                	beqz	a0,80001a6e <freeproc+0x20>
    80001a6a:	58dc                	lw	a5,52(s1)
    80001a6c:	c7a1                	beqz	a5,80001ab4 <freeproc+0x66>
  p->pagetable = 0;
    80001a6e:	0604b823          	sd	zero,112(s1)
  p->sz = 0;
    80001a72:	0604b423          	sd	zero,104(s1)
  p->pid = 0;
    80001a76:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a7a:	0404bc23          	sd	zero,88(s1)
  p->name[0] = 0;
    80001a7e:	16048c23          	sb	zero,376(s1)
  p->chan = 0;
    80001a82:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a86:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a8a:	0204a623          	sw	zero,44(s1)
  p->is_thread = 0;
    80001a8e:	0204aa23          	sw	zero,52(s1)
  p->tid = 0;
    80001a92:	0204ac23          	sw	zero,56(s1)
  p->tgid = 0;
    80001a96:	0204ae23          	sw	zero,60(s1)
  p->thread_group_leader = 0;
    80001a9a:	0404b023          	sd	zero,64(s1)
  p->parent_thread = 0;
    80001a9e:	0404b423          	sd	zero,72(s1)
  p->ustack = 0;
    80001aa2:	0404b823          	sd	zero,80(s1)
  p->state = UNUSED;
    80001aa6:	0004ac23          	sw	zero,24(s1)
}
    80001aaa:	60e2                	ld	ra,24(sp)
    80001aac:	6442                	ld	s0,16(sp)
    80001aae:	64a2                	ld	s1,8(sp)
    80001ab0:	6105                	addi	sp,sp,32
    80001ab2:	8082                	ret
    proc_freepagetable(p->pagetable, p->sz);
    80001ab4:	74ac                	ld	a1,104(s1)
    80001ab6:	f53ff0ef          	jal	80001a08 <proc_freepagetable>
    80001aba:	bf55                	j	80001a6e <freeproc+0x20>

0000000080001abc <allocproc>:
{
    80001abc:	1101                	addi	sp,sp,-32
    80001abe:	ec06                	sd	ra,24(sp)
    80001ac0:	e822                	sd	s0,16(sp)
    80001ac2:	e426                	sd	s1,8(sp)
    80001ac4:	e04a                	sd	s2,0(sp)
    80001ac6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ac8:	00011497          	auipc	s1,0x11
    80001acc:	23848493          	addi	s1,s1,568 # 80012d00 <proc>
    80001ad0:	00017917          	auipc	s2,0x17
    80001ad4:	43090913          	addi	s2,s2,1072 # 80018f00 <tickslock>
    acquire(&p->lock);
    80001ad8:	8526                	mv	a0,s1
    80001ada:	924ff0ef          	jal	80000bfe <acquire>
    if(p->state == UNUSED) {
    80001ade:	4c9c                	lw	a5,24(s1)
    80001ae0:	cb91                	beqz	a5,80001af4 <allocproc+0x38>
      release(&p->lock);
    80001ae2:	8526                	mv	a0,s1
    80001ae4:	9aeff0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ae8:	18848493          	addi	s1,s1,392
    80001aec:	ff2496e3          	bne	s1,s2,80001ad8 <allocproc+0x1c>
  return 0;
    80001af0:	4481                	li	s1,0
    80001af2:	a089                	j	80001b34 <allocproc+0x78>
  p->pid = allocpid();
    80001af4:	e53ff0ef          	jal	80001946 <allocpid>
    80001af8:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001afa:	4785                	li	a5,1
    80001afc:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001afe:	82cff0ef          	jal	80000b2a <kalloc>
    80001b02:	892a                	mv	s2,a0
    80001b04:	fca8                	sd	a0,120(s1)
    80001b06:	cd15                	beqz	a0,80001b42 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b08:	8526                	mv	a0,s1
    80001b0a:	e7bff0ef          	jal	80001984 <proc_pagetable>
    80001b0e:	892a                	mv	s2,a0
    80001b10:	f8a8                	sd	a0,112(s1)
  if(p->pagetable == 0){
    80001b12:	c121                	beqz	a0,80001b52 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b14:	07000613          	li	a2,112
    80001b18:	4581                	li	a1,0
    80001b1a:	08048513          	addi	a0,s1,128
    80001b1e:	9b0ff0ef          	jal	80000cce <memset>
  p->context.ra = (uint64)forkret;
    80001b22:	00000797          	auipc	a5,0x0
    80001b26:	dea78793          	addi	a5,a5,-534 # 8000190c <forkret>
    80001b2a:	e0dc                	sd	a5,128(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b2c:	70bc                	ld	a5,96(s1)
    80001b2e:	6705                	lui	a4,0x1
    80001b30:	97ba                	add	a5,a5,a4
    80001b32:	e4dc                	sd	a5,136(s1)
}
    80001b34:	8526                	mv	a0,s1
    80001b36:	60e2                	ld	ra,24(sp)
    80001b38:	6442                	ld	s0,16(sp)
    80001b3a:	64a2                	ld	s1,8(sp)
    80001b3c:	6902                	ld	s2,0(sp)
    80001b3e:	6105                	addi	sp,sp,32
    80001b40:	8082                	ret
    freeproc(p);
    80001b42:	8526                	mv	a0,s1
    80001b44:	f0bff0ef          	jal	80001a4e <freeproc>
    release(&p->lock);
    80001b48:	8526                	mv	a0,s1
    80001b4a:	948ff0ef          	jal	80000c92 <release>
    return 0;
    80001b4e:	84ca                	mv	s1,s2
    80001b50:	b7d5                	j	80001b34 <allocproc+0x78>
    freeproc(p);
    80001b52:	8526                	mv	a0,s1
    80001b54:	efbff0ef          	jal	80001a4e <freeproc>
    release(&p->lock);
    80001b58:	8526                	mv	a0,s1
    80001b5a:	938ff0ef          	jal	80000c92 <release>
    return 0;
    80001b5e:	84ca                	mv	s1,s2
    80001b60:	bfd1                	j	80001b34 <allocproc+0x78>

0000000080001b62 <userinit>:
{
    80001b62:	1101                	addi	sp,sp,-32
    80001b64:	ec06                	sd	ra,24(sp)
    80001b66:	e822                	sd	s0,16(sp)
    80001b68:	e426                	sd	s1,8(sp)
    80001b6a:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b6c:	f51ff0ef          	jal	80001abc <allocproc>
    80001b70:	84aa                	mv	s1,a0
  initproc = p;
    80001b72:	00009797          	auipc	a5,0x9
    80001b76:	c2a7b323          	sd	a0,-986(a5) # 8000a798 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b7a:	03400613          	li	a2,52
    80001b7e:	00009597          	auipc	a1,0x9
    80001b82:	b9258593          	addi	a1,a1,-1134 # 8000a710 <initcode>
    80001b86:	7928                	ld	a0,112(a0)
    80001b88:	f3aff0ef          	jal	800012c2 <uvmfirst>
  p->sz = PGSIZE;
    80001b8c:	6785                	lui	a5,0x1
    80001b8e:	f4bc                	sd	a5,104(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b90:	7cb8                	ld	a4,120(s1)
    80001b92:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b96:	7cb8                	ld	a4,120(s1)
    80001b98:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b9a:	4641                	li	a2,16
    80001b9c:	00005597          	auipc	a1,0x5
    80001ba0:	67c58593          	addi	a1,a1,1660 # 80007218 <etext+0x218>
    80001ba4:	17848513          	addi	a0,s1,376
    80001ba8:	a78ff0ef          	jal	80000e20 <safestrcpy>
  p->cwd = namei("/");
    80001bac:	00005517          	auipc	a0,0x5
    80001bb0:	67c50513          	addi	a0,a0,1660 # 80007228 <etext+0x228>
    80001bb4:	0cc020ef          	jal	80003c80 <namei>
    80001bb8:	16a4b823          	sd	a0,368(s1)
  p->state = RUNNABLE;
    80001bbc:	478d                	li	a5,3
    80001bbe:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	8d0ff0ef          	jal	80000c92 <release>
}
    80001bc6:	60e2                	ld	ra,24(sp)
    80001bc8:	6442                	ld	s0,16(sp)
    80001bca:	64a2                	ld	s1,8(sp)
    80001bcc:	6105                	addi	sp,sp,32
    80001bce:	8082                	ret

0000000080001bd0 <growproc>:
{
    80001bd0:	1101                	addi	sp,sp,-32
    80001bd2:	ec06                	sd	ra,24(sp)
    80001bd4:	e822                	sd	s0,16(sp)
    80001bd6:	e426                	sd	s1,8(sp)
    80001bd8:	e04a                	sd	s2,0(sp)
    80001bda:	1000                	addi	s0,sp,32
    80001bdc:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bde:	cffff0ef          	jal	800018dc <myproc>
    80001be2:	84aa                	mv	s1,a0
  sz = p->sz;
    80001be4:	752c                	ld	a1,104(a0)
  if(n > 0){
    80001be6:	01204c63          	bgtz	s2,80001bfe <growproc+0x2e>
  } else if(n < 0){
    80001bea:	02094463          	bltz	s2,80001c12 <growproc+0x42>
  p->sz = sz;
    80001bee:	f4ac                	sd	a1,104(s1)
  return 0;
    80001bf0:	4501                	li	a0,0
}
    80001bf2:	60e2                	ld	ra,24(sp)
    80001bf4:	6442                	ld	s0,16(sp)
    80001bf6:	64a2                	ld	s1,8(sp)
    80001bf8:	6902                	ld	s2,0(sp)
    80001bfa:	6105                	addi	sp,sp,32
    80001bfc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001bfe:	4691                	li	a3,4
    80001c00:	00b90633          	add	a2,s2,a1
    80001c04:	7928                	ld	a0,112(a0)
    80001c06:	f5eff0ef          	jal	80001364 <uvmalloc>
    80001c0a:	85aa                	mv	a1,a0
    80001c0c:	f16d                	bnez	a0,80001bee <growproc+0x1e>
      return -1;
    80001c0e:	557d                	li	a0,-1
    80001c10:	b7cd                	j	80001bf2 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c12:	00b90633          	add	a2,s2,a1
    80001c16:	7928                	ld	a0,112(a0)
    80001c18:	f08ff0ef          	jal	80001320 <uvmdealloc>
    80001c1c:	85aa                	mv	a1,a0
    80001c1e:	bfc1                	j	80001bee <growproc+0x1e>

0000000080001c20 <fork>:
{
    80001c20:	7139                	addi	sp,sp,-64
    80001c22:	fc06                	sd	ra,56(sp)
    80001c24:	f822                	sd	s0,48(sp)
    80001c26:	f04a                	sd	s2,32(sp)
    80001c28:	e456                	sd	s5,8(sp)
    80001c2a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c2c:	cb1ff0ef          	jal	800018dc <myproc>
    80001c30:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c32:	e8bff0ef          	jal	80001abc <allocproc>
    80001c36:	0e050a63          	beqz	a0,80001d2a <fork+0x10a>
    80001c3a:	e852                	sd	s4,16(sp)
    80001c3c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c3e:	068ab603          	ld	a2,104(s5)
    80001c42:	792c                	ld	a1,112(a0)
    80001c44:	070ab503          	ld	a0,112(s5)
    80001c48:	85dff0ef          	jal	800014a4 <uvmcopy>
    80001c4c:	04054a63          	bltz	a0,80001ca0 <fork+0x80>
    80001c50:	f426                	sd	s1,40(sp)
    80001c52:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c54:	068ab783          	ld	a5,104(s5)
    80001c58:	06fa3423          	sd	a5,104(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c5c:	078ab683          	ld	a3,120(s5)
    80001c60:	87b6                	mv	a5,a3
    80001c62:	078a3703          	ld	a4,120(s4)
    80001c66:	12068693          	addi	a3,a3,288
    80001c6a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c6e:	6788                	ld	a0,8(a5)
    80001c70:	6b8c                	ld	a1,16(a5)
    80001c72:	6f90                	ld	a2,24(a5)
    80001c74:	01073023          	sd	a6,0(a4)
    80001c78:	e708                	sd	a0,8(a4)
    80001c7a:	eb0c                	sd	a1,16(a4)
    80001c7c:	ef10                	sd	a2,24(a4)
    80001c7e:	02078793          	addi	a5,a5,32
    80001c82:	02070713          	addi	a4,a4,32
    80001c86:	fed792e3          	bne	a5,a3,80001c6a <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c8a:	078a3783          	ld	a5,120(s4)
    80001c8e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c92:	0f0a8493          	addi	s1,s5,240
    80001c96:	0f0a0913          	addi	s2,s4,240
    80001c9a:	170a8993          	addi	s3,s5,368
    80001c9e:	a831                	j	80001cba <fork+0x9a>
    freeproc(np);
    80001ca0:	8552                	mv	a0,s4
    80001ca2:	dadff0ef          	jal	80001a4e <freeproc>
    release(&np->lock);
    80001ca6:	8552                	mv	a0,s4
    80001ca8:	febfe0ef          	jal	80000c92 <release>
    return -1;
    80001cac:	597d                	li	s2,-1
    80001cae:	6a42                	ld	s4,16(sp)
    80001cb0:	a0b5                	j	80001d1c <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001cb2:	04a1                	addi	s1,s1,8
    80001cb4:	0921                	addi	s2,s2,8
    80001cb6:	01348963          	beq	s1,s3,80001cc8 <fork+0xa8>
    if(p->ofile[i])
    80001cba:	6088                	ld	a0,0(s1)
    80001cbc:	d97d                	beqz	a0,80001cb2 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cbe:	55e020ef          	jal	8000421c <filedup>
    80001cc2:	00a93023          	sd	a0,0(s2)
    80001cc6:	b7f5                	j	80001cb2 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001cc8:	170ab503          	ld	a0,368(s5)
    80001ccc:	08f010ef          	jal	8000355a <idup>
    80001cd0:	16aa3823          	sd	a0,368(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cd4:	4641                	li	a2,16
    80001cd6:	178a8593          	addi	a1,s5,376
    80001cda:	178a0513          	addi	a0,s4,376
    80001cde:	942ff0ef          	jal	80000e20 <safestrcpy>
  pid = np->pid;
    80001ce2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001ce6:	8552                	mv	a0,s4
    80001ce8:	fabfe0ef          	jal	80000c92 <release>
  acquire(&wait_lock);
    80001cec:	00011497          	auipc	s1,0x11
    80001cf0:	bfc48493          	addi	s1,s1,-1028 # 800128e8 <wait_lock>
    80001cf4:	8526                	mv	a0,s1
    80001cf6:	f09fe0ef          	jal	80000bfe <acquire>
  np->parent = p;
    80001cfa:	055a3c23          	sd	s5,88(s4)
  release(&wait_lock);
    80001cfe:	8526                	mv	a0,s1
    80001d00:	f93fe0ef          	jal	80000c92 <release>
  acquire(&np->lock);
    80001d04:	8552                	mv	a0,s4
    80001d06:	ef9fe0ef          	jal	80000bfe <acquire>
  np->state = RUNNABLE;
    80001d0a:	478d                	li	a5,3
    80001d0c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d10:	8552                	mv	a0,s4
    80001d12:	f81fe0ef          	jal	80000c92 <release>
  return pid;
    80001d16:	74a2                	ld	s1,40(sp)
    80001d18:	69e2                	ld	s3,24(sp)
    80001d1a:	6a42                	ld	s4,16(sp)
}
    80001d1c:	854a                	mv	a0,s2
    80001d1e:	70e2                	ld	ra,56(sp)
    80001d20:	7442                	ld	s0,48(sp)
    80001d22:	7902                	ld	s2,32(sp)
    80001d24:	6aa2                	ld	s5,8(sp)
    80001d26:	6121                	addi	sp,sp,64
    80001d28:	8082                	ret
    return -1;
    80001d2a:	597d                	li	s2,-1
    80001d2c:	bfc5                	j	80001d1c <fork+0xfc>

0000000080001d2e <kthread_create>:
int kthread_create(void (*start_func)(), void *stack, uint64 stack_size) {
    80001d2e:	7139                	addi	sp,sp,-64
    80001d30:	fc06                	sd	ra,56(sp)
    80001d32:	f822                	sd	s0,48(sp)
    80001d34:	f426                	sd	s1,40(sp)
    80001d36:	f04a                	sd	s2,32(sp)
    80001d38:	e852                	sd	s4,16(sp)
    80001d3a:	e456                	sd	s5,8(sp)
    80001d3c:	0080                	addi	s0,sp,64
    80001d3e:	8a2a                	mv	s4,a0
    80001d40:	84ae                	mv	s1,a1
    80001d42:	8932                	mv	s2,a2
    struct proc *p = myproc();
    80001d44:	b99ff0ef          	jal	800018dc <myproc>
    80001d48:	8aaa                	mv	s5,a0
    struct proc *nt = allocproc();
    80001d4a:	d73ff0ef          	jal	80001abc <allocproc>
    if (nt == 0) {
    80001d4e:	c171                	beqz	a0,80001e12 <kthread_create+0xe4>
    80001d50:	ec4e                	sd	s3,24(sp)
    80001d52:	89aa                	mv	s3,a0
    nt->is_thread = 1;
    80001d54:	4785                	li	a5,1
    80001d56:	d95c                	sw	a5,52(a0)
    nt->tid = nt->pid;  // Use pid as thread id for simplicity
    80001d58:	590c                	lw	a1,48(a0)
    80001d5a:	dd0c                	sw	a1,56(a0)
    nt->pid = p->pid;   // CRITICAL: threads share parent's pid for scheduler
    80001d5c:	030aa783          	lw	a5,48(s5)
    80001d60:	d91c                	sw	a5,48(a0)
    nt->tgid = p->pid;  // Thread group ID is the parent process's pid
    80001d62:	dd5c                	sw	a5,60(a0)
    nt->thread_group_leader = p->is_thread ? p->thread_group_leader : p;
    80001d64:	034aa703          	lw	a4,52(s5)
    80001d68:	87d6                	mv	a5,s5
    80001d6a:	c319                	beqz	a4,80001d70 <kthread_create+0x42>
    80001d6c:	040ab783          	ld	a5,64(s5)
    80001d70:	04f9b023          	sd	a5,64(s3)
    nt->parent_thread = p;
    80001d74:	0559b423          	sd	s5,72(s3)
    nt->ustack = stack;
    80001d78:	0499b823          	sd	s1,80(s3)
    KTHREAD_DBG("kthread_create: thread struct allocated, tid=%d", nt->tid);
    80001d7c:	00005517          	auipc	a0,0x5
    80001d80:	4ec50513          	addi	a0,a0,1260 # 80007268 <etext+0x268>
    80001d84:	f4afe0ef          	jal	800004ce <printf>
    if (uvmcopy(p->pagetable, nt->pagetable, p->sz) < 0) {
    80001d88:	068ab603          	ld	a2,104(s5)
    80001d8c:	0709b583          	ld	a1,112(s3)
    80001d90:	070ab503          	ld	a0,112(s5)
    80001d94:	f10ff0ef          	jal	800014a4 <uvmcopy>
    80001d98:	08054563          	bltz	a0,80001e22 <kthread_create+0xf4>
    nt->sz = p->sz;
    80001d9c:	068ab783          	ld	a5,104(s5)
    80001da0:	06f9b423          	sd	a5,104(s3)
    *(nt->trapframe) = *(p->trapframe);
    80001da4:	078ab683          	ld	a3,120(s5)
    80001da8:	87b6                	mv	a5,a3
    80001daa:	0789b703          	ld	a4,120(s3)
    80001dae:	12068693          	addi	a3,a3,288
    80001db2:	0007b803          	ld	a6,0(a5)
    80001db6:	6788                	ld	a0,8(a5)
    80001db8:	6b8c                	ld	a1,16(a5)
    80001dba:	6f90                	ld	a2,24(a5)
    80001dbc:	01073023          	sd	a6,0(a4)
    80001dc0:	e708                	sd	a0,8(a4)
    80001dc2:	eb0c                	sd	a1,16(a4)
    80001dc4:	ef10                	sd	a2,24(a4)
    80001dc6:	02078793          	addi	a5,a5,32
    80001dca:	02070713          	addi	a4,a4,32
    80001dce:	fed792e3          	bne	a5,a3,80001db2 <kthread_create+0x84>
    nt->trapframe->epc = (uint64)start_func; // entry point
    80001dd2:	0789b783          	ld	a5,120(s3)
    80001dd6:	0147bc23          	sd	s4,24(a5)
    nt->trapframe->sp = (uint64)stack + stack_size; // top of stack
    80001dda:	0789b783          	ld	a5,120(s3)
    80001dde:	9926                	add	s2,s2,s1
    80001de0:	0327b823          	sd	s2,48(a5)
    nt->trapframe->a0 = (uint64)stack; // Pass stack base as arg, so thread can access its arguments 
    80001de4:	0789b783          	ld	a5,120(s3)
    80001de8:	fba4                	sd	s1,112(a5)
    KTHREAD_DBG("kthread_create: trapframe setup: epc=0x%lx sp=0x%lx a0=0x%lx", nt->trapframe->epc, nt->trapframe->sp, nt->trapframe->a0);
    80001dea:	0789b783          	ld	a5,120(s3)
    80001dee:	7bb4                	ld	a3,112(a5)
    80001df0:	7b90                	ld	a2,48(a5)
    80001df2:	6f8c                	ld	a1,24(a5)
    80001df4:	00005517          	auipc	a0,0x5
    80001df8:	4f450513          	addi	a0,a0,1268 # 800072e8 <etext+0x2e8>
    80001dfc:	ed2fe0ef          	jal	800004ce <printf>
    nt->parent = p;
    80001e00:	0559bc23          	sd	s5,88(s3)
    for (int i = 0; i < NOFILE; i++) {
    80001e04:	0f0a8493          	addi	s1,s5,240
    80001e08:	0f098913          	addi	s2,s3,240
    80001e0c:	170a8a13          	addi	s4,s5,368
    80001e10:	a081                	j	80001e50 <kthread_create+0x122>
        KTHREAD_DBG("kthread_create: allocproc failed");
    80001e12:	00005517          	auipc	a0,0x5
    80001e16:	41e50513          	addi	a0,a0,1054 # 80007230 <etext+0x230>
    80001e1a:	eb4fe0ef          	jal	800004ce <printf>
        return -1;
    80001e1e:	557d                	li	a0,-1
    80001e20:	a095                	j	80001e84 <kthread_create+0x156>
        freeproc(nt);
    80001e22:	854e                	mv	a0,s3
    80001e24:	c2bff0ef          	jal	80001a4e <freeproc>
        KTHREAD_DBG("kthread_create: uvmcopy failed");
    80001e28:	00005517          	auipc	a0,0x5
    80001e2c:	48850513          	addi	a0,a0,1160 # 800072b0 <etext+0x2b0>
    80001e30:	e9efe0ef          	jal	800004ce <printf>
        release(&nt->lock);
    80001e34:	854e                	mv	a0,s3
    80001e36:	e5dfe0ef          	jal	80000c92 <release>
        return -1;
    80001e3a:	557d                	li	a0,-1
    80001e3c:	69e2                	ld	s3,24(sp)
    80001e3e:	a099                	j	80001e84 <kthread_create+0x156>
            nt->ofile[i] = filedup(p->ofile[i]);
    80001e40:	3dc020ef          	jal	8000421c <filedup>
    80001e44:	00a93023          	sd	a0,0(s2)
    for (int i = 0; i < NOFILE; i++) {
    80001e48:	04a1                	addi	s1,s1,8
    80001e4a:	0921                	addi	s2,s2,8
    80001e4c:	01448563          	beq	s1,s4,80001e56 <kthread_create+0x128>
        if (p->ofile[i]) {
    80001e50:	6088                	ld	a0,0(s1)
    80001e52:	f57d                	bnez	a0,80001e40 <kthread_create+0x112>
    80001e54:	bfd5                	j	80001e48 <kthread_create+0x11a>
    nt->cwd = idup(p->cwd);
    80001e56:	170ab503          	ld	a0,368(s5)
    80001e5a:	700010ef          	jal	8000355a <idup>
    80001e5e:	16a9b823          	sd	a0,368(s3)
    nt->state = RUNNABLE;
    80001e62:	478d                	li	a5,3
    80001e64:	00f9ac23          	sw	a5,24(s3)
    KTHREAD_DBG("kthread_create: marking thread RUNNABLE, tid=%d", nt->tid);
    80001e68:	0389a583          	lw	a1,56(s3)
    80001e6c:	00005517          	auipc	a0,0x5
    80001e70:	4cc50513          	addi	a0,a0,1228 # 80007338 <etext+0x338>
    80001e74:	e5afe0ef          	jal	800004ce <printf>
    release(&nt->lock);
    80001e78:	854e                	mv	a0,s3
    80001e7a:	e19fe0ef          	jal	80000c92 <release>
    return nt->tid;
    80001e7e:	0389a503          	lw	a0,56(s3)
    80001e82:	69e2                	ld	s3,24(sp)
}
    80001e84:	70e2                	ld	ra,56(sp)
    80001e86:	7442                	ld	s0,48(sp)
    80001e88:	74a2                	ld	s1,40(sp)
    80001e8a:	7902                	ld	s2,32(sp)
    80001e8c:	6a42                	ld	s4,16(sp)
    80001e8e:	6aa2                	ld	s5,8(sp)
    80001e90:	6121                	addi	sp,sp,64
    80001e92:	8082                	ret

0000000080001e94 <scheduler>:
{
    80001e94:	715d                	addi	sp,sp,-80
    80001e96:	e486                	sd	ra,72(sp)
    80001e98:	e0a2                	sd	s0,64(sp)
    80001e9a:	fc26                	sd	s1,56(sp)
    80001e9c:	f84a                	sd	s2,48(sp)
    80001e9e:	f44e                	sd	s3,40(sp)
    80001ea0:	f052                	sd	s4,32(sp)
    80001ea2:	ec56                	sd	s5,24(sp)
    80001ea4:	e85a                	sd	s6,16(sp)
    80001ea6:	e45e                	sd	s7,8(sp)
    80001ea8:	e062                	sd	s8,0(sp)
    80001eaa:	0880                	addi	s0,sp,80
    80001eac:	8792                	mv	a5,tp
  int id = r_tp();
    80001eae:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001eb0:	00779b13          	slli	s6,a5,0x7
    80001eb4:	00011717          	auipc	a4,0x11
    80001eb8:	a1c70713          	addi	a4,a4,-1508 # 800128d0 <pid_lock>
    80001ebc:	975a                	add	a4,a4,s6
    80001ebe:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ec2:	00011717          	auipc	a4,0x11
    80001ec6:	a4670713          	addi	a4,a4,-1466 # 80012908 <cpus+0x8>
    80001eca:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001ecc:	4c11                	li	s8,4
        c->proc = p;
    80001ece:	079e                	slli	a5,a5,0x7
    80001ed0:	00011a17          	auipc	s4,0x11
    80001ed4:	a00a0a13          	addi	s4,s4,-1536 # 800128d0 <pid_lock>
    80001ed8:	9a3e                	add	s4,s4,a5
        found = 1;
    80001eda:	4b85                	li	s7,1
    80001edc:	a0a9                	j	80001f26 <scheduler+0x92>
      release(&p->lock);
    80001ede:	8526                	mv	a0,s1
    80001ee0:	db3fe0ef          	jal	80000c92 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ee4:	18848493          	addi	s1,s1,392
    80001ee8:	03248563          	beq	s1,s2,80001f12 <scheduler+0x7e>
      acquire(&p->lock);
    80001eec:	8526                	mv	a0,s1
    80001eee:	d11fe0ef          	jal	80000bfe <acquire>
      if(p->state == RUNNABLE) {
    80001ef2:	4c9c                	lw	a5,24(s1)
    80001ef4:	ff3795e3          	bne	a5,s3,80001ede <scheduler+0x4a>
        p->state = RUNNING;
    80001ef8:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001efc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f00:	08048593          	addi	a1,s1,128
    80001f04:	855a                	mv	a0,s6
    80001f06:	784000ef          	jal	8000268a <swtch>
        c->proc = 0;
    80001f0a:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001f0e:	8ade                	mv	s5,s7
    80001f10:	b7f9                	j	80001ede <scheduler+0x4a>
    if(found == 0) {
    80001f12:	000a9a63          	bnez	s5,80001f26 <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f16:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f1a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f1e:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001f22:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f2a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f2e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001f32:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f34:	00011497          	auipc	s1,0x11
    80001f38:	dcc48493          	addi	s1,s1,-564 # 80012d00 <proc>
      if(p->state == RUNNABLE) {
    80001f3c:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f3e:	00017917          	auipc	s2,0x17
    80001f42:	fc290913          	addi	s2,s2,-62 # 80018f00 <tickslock>
    80001f46:	b75d                	j	80001eec <scheduler+0x58>

0000000080001f48 <sched>:
{
    80001f48:	7179                	addi	sp,sp,-48
    80001f4a:	f406                	sd	ra,40(sp)
    80001f4c:	f022                	sd	s0,32(sp)
    80001f4e:	ec26                	sd	s1,24(sp)
    80001f50:	e84a                	sd	s2,16(sp)
    80001f52:	e44e                	sd	s3,8(sp)
    80001f54:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f56:	987ff0ef          	jal	800018dc <myproc>
    80001f5a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f5c:	c39fe0ef          	jal	80000b94 <holding>
    80001f60:	c92d                	beqz	a0,80001fd2 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f62:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f64:	2781                	sext.w	a5,a5
    80001f66:	079e                	slli	a5,a5,0x7
    80001f68:	00011717          	auipc	a4,0x11
    80001f6c:	96870713          	addi	a4,a4,-1688 # 800128d0 <pid_lock>
    80001f70:	97ba                	add	a5,a5,a4
    80001f72:	0a87a703          	lw	a4,168(a5)
    80001f76:	4785                	li	a5,1
    80001f78:	06f71363          	bne	a4,a5,80001fde <sched+0x96>
  if(p->state == RUNNING)
    80001f7c:	4c98                	lw	a4,24(s1)
    80001f7e:	4791                	li	a5,4
    80001f80:	06f70563          	beq	a4,a5,80001fea <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f84:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f88:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f8a:	e7b5                	bnez	a5,80001ff6 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f8c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f8e:	00011917          	auipc	s2,0x11
    80001f92:	94290913          	addi	s2,s2,-1726 # 800128d0 <pid_lock>
    80001f96:	2781                	sext.w	a5,a5
    80001f98:	079e                	slli	a5,a5,0x7
    80001f9a:	97ca                	add	a5,a5,s2
    80001f9c:	0ac7a983          	lw	s3,172(a5)
    80001fa0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fa2:	2781                	sext.w	a5,a5
    80001fa4:	079e                	slli	a5,a5,0x7
    80001fa6:	00011597          	auipc	a1,0x11
    80001faa:	96258593          	addi	a1,a1,-1694 # 80012908 <cpus+0x8>
    80001fae:	95be                	add	a1,a1,a5
    80001fb0:	08048513          	addi	a0,s1,128
    80001fb4:	6d6000ef          	jal	8000268a <swtch>
    80001fb8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fba:	2781                	sext.w	a5,a5
    80001fbc:	079e                	slli	a5,a5,0x7
    80001fbe:	993e                	add	s2,s2,a5
    80001fc0:	0b392623          	sw	s3,172(s2)
}
    80001fc4:	70a2                	ld	ra,40(sp)
    80001fc6:	7402                	ld	s0,32(sp)
    80001fc8:	64e2                	ld	s1,24(sp)
    80001fca:	6942                	ld	s2,16(sp)
    80001fcc:	69a2                	ld	s3,8(sp)
    80001fce:	6145                	addi	sp,sp,48
    80001fd0:	8082                	ret
    panic("sched p->lock");
    80001fd2:	00005517          	auipc	a0,0x5
    80001fd6:	3ae50513          	addi	a0,a0,942 # 80007380 <etext+0x380>
    80001fda:	fc4fe0ef          	jal	8000079e <panic>
    panic("sched locks");
    80001fde:	00005517          	auipc	a0,0x5
    80001fe2:	3b250513          	addi	a0,a0,946 # 80007390 <etext+0x390>
    80001fe6:	fb8fe0ef          	jal	8000079e <panic>
    panic("sched running");
    80001fea:	00005517          	auipc	a0,0x5
    80001fee:	3b650513          	addi	a0,a0,950 # 800073a0 <etext+0x3a0>
    80001ff2:	facfe0ef          	jal	8000079e <panic>
    panic("sched interruptible");
    80001ff6:	00005517          	auipc	a0,0x5
    80001ffa:	3ba50513          	addi	a0,a0,954 # 800073b0 <etext+0x3b0>
    80001ffe:	fa0fe0ef          	jal	8000079e <panic>

0000000080002002 <yield>:
{
    80002002:	1101                	addi	sp,sp,-32
    80002004:	ec06                	sd	ra,24(sp)
    80002006:	e822                	sd	s0,16(sp)
    80002008:	e426                	sd	s1,8(sp)
    8000200a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000200c:	8d1ff0ef          	jal	800018dc <myproc>
    80002010:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002012:	bedfe0ef          	jal	80000bfe <acquire>
  p->state = RUNNABLE;
    80002016:	478d                	li	a5,3
    80002018:	cc9c                	sw	a5,24(s1)
  sched();
    8000201a:	f2fff0ef          	jal	80001f48 <sched>
  release(&p->lock);
    8000201e:	8526                	mv	a0,s1
    80002020:	c73fe0ef          	jal	80000c92 <release>
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6105                	addi	sp,sp,32
    8000202c:	8082                	ret

000000008000202e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000202e:	7179                	addi	sp,sp,-48
    80002030:	f406                	sd	ra,40(sp)
    80002032:	f022                	sd	s0,32(sp)
    80002034:	ec26                	sd	s1,24(sp)
    80002036:	e84a                	sd	s2,16(sp)
    80002038:	e44e                	sd	s3,8(sp)
    8000203a:	1800                	addi	s0,sp,48
    8000203c:	89aa                	mv	s3,a0
    8000203e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002040:	89dff0ef          	jal	800018dc <myproc>
    80002044:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002046:	bb9fe0ef          	jal	80000bfe <acquire>
  release(lk);
    8000204a:	854a                	mv	a0,s2
    8000204c:	c47fe0ef          	jal	80000c92 <release>

  // Go to sleep.
  p->chan = chan;
    80002050:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002054:	4789                	li	a5,2
    80002056:	cc9c                	sw	a5,24(s1)

  sched();
    80002058:	ef1ff0ef          	jal	80001f48 <sched>

  // Tidy up.
  p->chan = 0;
    8000205c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002060:	8526                	mv	a0,s1
    80002062:	c31fe0ef          	jal	80000c92 <release>
  acquire(lk);
    80002066:	854a                	mv	a0,s2
    80002068:	b97fe0ef          	jal	80000bfe <acquire>
}
    8000206c:	70a2                	ld	ra,40(sp)
    8000206e:	7402                	ld	s0,32(sp)
    80002070:	64e2                	ld	s1,24(sp)
    80002072:	6942                	ld	s2,16(sp)
    80002074:	69a2                	ld	s3,8(sp)
    80002076:	6145                	addi	sp,sp,48
    80002078:	8082                	ret

000000008000207a <kthread_join>:
int kthread_join(int tid, int *status) {
    8000207a:	7139                	addi	sp,sp,-64
    8000207c:	fc06                	sd	ra,56(sp)
    8000207e:	f822                	sd	s0,48(sp)
    80002080:	f04a                	sd	s2,32(sp)
    80002082:	e852                	sd	s4,16(sp)
    80002084:	e456                	sd	s5,8(sp)
    80002086:	0080                	addi	s0,sp,64
    80002088:	892a                	mv	s2,a0
    8000208a:	8aae                	mv	s5,a1
  struct proc *p = myproc();
    8000208c:	851ff0ef          	jal	800018dc <myproc>
    80002090:	8a2a                	mv	s4,a0
  KTHREAD_DBG("kthread_join: waiting for tid=%d", tid);
    80002092:	85ca                	mv	a1,s2
    80002094:	00005517          	auipc	a0,0x5
    80002098:	33450513          	addi	a0,a0,820 # 800073c8 <etext+0x3c8>
    8000209c:	c32fe0ef          	jal	800004ce <printf>
  acquire(&wait_lock);
    800020a0:	00011517          	auipc	a0,0x11
    800020a4:	84850513          	addi	a0,a0,-1976 # 800128e8 <wait_lock>
    800020a8:	b57fe0ef          	jal	80000bfe <acquire>
  for (tp = proc; tp < &proc[NPROC]; tp++) {
    800020ac:	00011797          	auipc	a5,0x11
    800020b0:	c5478793          	addi	a5,a5,-940 # 80012d00 <proc>
    800020b4:	00017697          	auipc	a3,0x17
    800020b8:	e4c68693          	addi	a3,a3,-436 # 80018f00 <tickslock>
    800020bc:	a029                	j	800020c6 <kthread_join+0x4c>
    800020be:	18878793          	addi	a5,a5,392
    800020c2:	02d78863          	beq	a5,a3,800020f2 <kthread_join+0x78>
    if (tp->tid == tid && tp->is_thread && tp->state == UNUSED) {
    800020c6:	5f98                	lw	a4,56(a5)
    800020c8:	ff271be3          	bne	a4,s2,800020be <kthread_join+0x44>
    800020cc:	5bd8                	lw	a4,52(a5)
    800020ce:	db65                	beqz	a4,800020be <kthread_join+0x44>
    800020d0:	4f98                	lw	a4,24(a5)
    800020d2:	f775                	bnez	a4,800020be <kthread_join+0x44>
    release(&wait_lock);
    800020d4:	00011517          	auipc	a0,0x11
    800020d8:	81450513          	addi	a0,a0,-2028 # 800128e8 <wait_lock>
    800020dc:	bb7fe0ef          	jal	80000c92 <release>
    KTHREAD_DBG("kthread_join: thread tid=%d already joined", tid);
    800020e0:	85ca                	mv	a1,s2
    800020e2:	00005517          	auipc	a0,0x5
    800020e6:	42650513          	addi	a0,a0,1062 # 80007508 <etext+0x508>
    800020ea:	be4fe0ef          	jal	800004ce <printf>
    return -1;
    800020ee:	557d                	li	a0,-1
    800020f0:	a0c5                	j	800021d0 <kthread_join+0x156>
    800020f2:	f426                	sd	s1,40(sp)
    800020f4:	ec4e                	sd	s3,24(sp)
    for (tp = proc; tp < &proc[NPROC]; tp++) {
    800020f6:	00017997          	auipc	s3,0x17
    800020fa:	e0a98993          	addi	s3,s3,-502 # 80018f00 <tickslock>
    800020fe:	00011497          	auipc	s1,0x11
    80002102:	c0248493          	addi	s1,s1,-1022 # 80012d00 <proc>
    80002106:	a049                	j	80002188 <kthread_join+0x10e>
          if (tp->state == ZOMBIE) {
    80002108:	4c98                	lw	a4,24(s1)
    8000210a:	4795                	li	a5,5
    8000210c:	02f70563          	beq	a4,a5,80002136 <kthread_join+0xbc>
          release(&tp->lock);
    80002110:	8526                	mv	a0,s1
    80002112:	b81fe0ef          	jal	80000c92 <release>
    KTHREAD_DBG("kthread_join: sleeping waiting for tid=%d (channel=%lx)", tid, channel);
    80002116:	864a                	mv	a2,s2
    80002118:	85ca                	mv	a1,s2
    8000211a:	00005517          	auipc	a0,0x5
    8000211e:	35650513          	addi	a0,a0,854 # 80007470 <etext+0x470>
    80002122:	bacfe0ef          	jal	800004ce <printf>
    sleep((void*)channel, &wait_lock);
    80002126:	00010597          	auipc	a1,0x10
    8000212a:	7c258593          	addi	a1,a1,1986 # 800128e8 <wait_lock>
    8000212e:	854a                	mv	a0,s2
    80002130:	effff0ef          	jal	8000202e <sleep>
  for(;;) {
    80002134:	b7e9                	j	800020fe <kthread_join+0x84>
            KTHREAD_DBG("kthread_join: found zombie thread tid=%d", tid);
    80002136:	85ca                	mv	a1,s2
    80002138:	00005517          	auipc	a0,0x5
    8000213c:	2c850513          	addi	a0,a0,712 # 80007400 <etext+0x400>
    80002140:	b8efe0ef          	jal	800004ce <printf>
            if (status != 0) {
    80002144:	000a8563          	beqz	s5,8000214e <kthread_join+0xd4>
              *status = tp->xstate;
    80002148:	54dc                	lw	a5,44(s1)
    8000214a:	00faa023          	sw	a5,0(s5)
            tp->state = UNUSED;
    8000214e:	0004ac23          	sw	zero,24(s1)
            freeproc(tp);
    80002152:	8526                	mv	a0,s1
    80002154:	8fbff0ef          	jal	80001a4e <freeproc>
            release(&tp->lock);
    80002158:	8526                	mv	a0,s1
    8000215a:	b39fe0ef          	jal	80000c92 <release>
            release(&wait_lock);
    8000215e:	00010517          	auipc	a0,0x10
    80002162:	78a50513          	addi	a0,a0,1930 # 800128e8 <wait_lock>
    80002166:	b2dfe0ef          	jal	80000c92 <release>
            KTHREAD_DBG("kthread_join: joined tid=%d", tid);
    8000216a:	85ca                	mv	a1,s2
    8000216c:	00005517          	auipc	a0,0x5
    80002170:	2d450513          	addi	a0,a0,724 # 80007440 <etext+0x440>
    80002174:	b5afe0ef          	jal	800004ce <printf>
            return 0;
    80002178:	4501                	li	a0,0
    8000217a:	74a2                	ld	s1,40(sp)
    8000217c:	69e2                	ld	s3,24(sp)
    8000217e:	a889                	j	800021d0 <kthread_join+0x156>
    for (tp = proc; tp < &proc[NPROC]; tp++) {
    80002180:	18848493          	addi	s1,s1,392
    80002184:	03348663          	beq	s1,s3,800021b0 <kthread_join+0x136>
      if (tp->tid == tid && tp->is_thread) {
    80002188:	5c9c                	lw	a5,56(s1)
    8000218a:	ff279be3          	bne	a5,s2,80002180 <kthread_join+0x106>
    8000218e:	58dc                	lw	a5,52(s1)
    80002190:	dbe5                	beqz	a5,80002180 <kthread_join+0x106>
        acquire(&tp->lock);
    80002192:	8526                	mv	a0,s1
    80002194:	a6bfe0ef          	jal	80000bfe <acquire>
        if (tp->tgid == p->tgid || tp->parent == p) {
    80002198:	5cd8                	lw	a4,60(s1)
    8000219a:	03ca2783          	lw	a5,60(s4)
    8000219e:	f6f705e3          	beq	a4,a5,80002108 <kthread_join+0x8e>
    800021a2:	6cbc                	ld	a5,88(s1)
    800021a4:	f74782e3          	beq	a5,s4,80002108 <kthread_join+0x8e>
          release(&tp->lock);
    800021a8:	8526                	mv	a0,s1
    800021aa:	ae9fe0ef          	jal	80000c92 <release>
    800021ae:	bfc9                	j	80002180 <kthread_join+0x106>
      release(&wait_lock);
    800021b0:	00010517          	auipc	a0,0x10
    800021b4:	73850513          	addi	a0,a0,1848 # 800128e8 <wait_lock>
    800021b8:	adbfe0ef          	jal	80000c92 <release>
      KTHREAD_DBG("kthread_join: tid=%d not found or not in thread group", tid);
    800021bc:	85ca                	mv	a1,s2
    800021be:	00005517          	auipc	a0,0x5
    800021c2:	30250513          	addi	a0,a0,770 # 800074c0 <etext+0x4c0>
    800021c6:	b08fe0ef          	jal	800004ce <printf>
      return -1;
    800021ca:	557d                	li	a0,-1
    800021cc:	74a2                	ld	s1,40(sp)
    800021ce:	69e2                	ld	s3,24(sp)
}
    800021d0:	70e2                	ld	ra,56(sp)
    800021d2:	7442                	ld	s0,48(sp)
    800021d4:	7902                	ld	s2,32(sp)
    800021d6:	6a42                	ld	s4,16(sp)
    800021d8:	6aa2                	ld	s5,8(sp)
    800021da:	6121                	addi	sp,sp,64
    800021dc:	8082                	ret

00000000800021de <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800021de:	7139                	addi	sp,sp,-64
    800021e0:	fc06                	sd	ra,56(sp)
    800021e2:	f822                	sd	s0,48(sp)
    800021e4:	f426                	sd	s1,40(sp)
    800021e6:	f04a                	sd	s2,32(sp)
    800021e8:	ec4e                	sd	s3,24(sp)
    800021ea:	e852                	sd	s4,16(sp)
    800021ec:	e456                	sd	s5,8(sp)
    800021ee:	0080                	addi	s0,sp,64
    800021f0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800021f2:	00011497          	auipc	s1,0x11
    800021f6:	b0e48493          	addi	s1,s1,-1266 # 80012d00 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800021fa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800021fc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800021fe:	00017917          	auipc	s2,0x17
    80002202:	d0290913          	addi	s2,s2,-766 # 80018f00 <tickslock>
    80002206:	a801                	j	80002216 <wakeup+0x38>
      }
      release(&p->lock);
    80002208:	8526                	mv	a0,s1
    8000220a:	a89fe0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000220e:	18848493          	addi	s1,s1,392
    80002212:	03248263          	beq	s1,s2,80002236 <wakeup+0x58>
    if(p != myproc()){
    80002216:	ec6ff0ef          	jal	800018dc <myproc>
    8000221a:	fea48ae3          	beq	s1,a0,8000220e <wakeup+0x30>
      acquire(&p->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	9dffe0ef          	jal	80000bfe <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002224:	4c9c                	lw	a5,24(s1)
    80002226:	ff3791e3          	bne	a5,s3,80002208 <wakeup+0x2a>
    8000222a:	709c                	ld	a5,32(s1)
    8000222c:	fd479ee3          	bne	a5,s4,80002208 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002230:	0154ac23          	sw	s5,24(s1)
    80002234:	bfd1                	j	80002208 <wakeup+0x2a>
    }
  }
}
    80002236:	70e2                	ld	ra,56(sp)
    80002238:	7442                	ld	s0,48(sp)
    8000223a:	74a2                	ld	s1,40(sp)
    8000223c:	7902                	ld	s2,32(sp)
    8000223e:	69e2                	ld	s3,24(sp)
    80002240:	6a42                	ld	s4,16(sp)
    80002242:	6aa2                	ld	s5,8(sp)
    80002244:	6121                	addi	sp,sp,64
    80002246:	8082                	ret

0000000080002248 <kthread_exit>:
void kthread_exit(int status) {
    80002248:	1101                	addi	sp,sp,-32
    8000224a:	ec06                	sd	ra,24(sp)
    8000224c:	e822                	sd	s0,16(sp)
    8000224e:	e426                	sd	s1,8(sp)
    80002250:	e04a                	sd	s2,0(sp)
    80002252:	1000                	addi	s0,sp,32
    80002254:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80002256:	e86ff0ef          	jal	800018dc <myproc>
    8000225a:	84aa                	mv	s1,a0
  if(!p->is_thread) {
    8000225c:	595c                	lw	a5,52(a0)
    8000225e:	c3b1                	beqz	a5,800022a2 <kthread_exit+0x5a>
  acquire(&p->lock);
    80002260:	8526                	mv	a0,s1
    80002262:	99dfe0ef          	jal	80000bfe <acquire>
  p->xstate = status;
    80002266:	0324a623          	sw	s2,44(s1)
  p->state = ZOMBIE;
    8000226a:	4795                	li	a5,5
    8000226c:	cc9c                	sw	a5,24(s1)
  KTHREAD_DBG("kthread_exit: thread tid=%d exiting", p->tid);
    8000226e:	5c8c                	lw	a1,56(s1)
    80002270:	00005517          	auipc	a0,0x5
    80002274:	32850513          	addi	a0,a0,808 # 80007598 <etext+0x598>
    80002278:	a56fe0ef          	jal	800004ce <printf>
  uint64 channel = (uint64)p->tid;
    8000227c:	5c84                	lw	s1,56(s1)
  KTHREAD_DBG("kthread_exit: waking up waiters on channel=%lx", channel);
    8000227e:	85a6                	mv	a1,s1
    80002280:	00005517          	auipc	a0,0x5
    80002284:	35050513          	addi	a0,a0,848 # 800075d0 <etext+0x5d0>
    80002288:	a46fe0ef          	jal	800004ce <printf>
  wakeup((void*)channel);
    8000228c:	8526                	mv	a0,s1
    8000228e:	f51ff0ef          	jal	800021de <wakeup>
  sched();
    80002292:	cb7ff0ef          	jal	80001f48 <sched>
  panic("zombie exit");
    80002296:	00005517          	auipc	a0,0x5
    8000229a:	38250513          	addi	a0,a0,898 # 80007618 <etext+0x618>
    8000229e:	d00fe0ef          	jal	8000079e <panic>
    KTHREAD_DBG("kthread_exit: warning - called on non-thread process pid=%d", p->pid);
    800022a2:	590c                	lw	a1,48(a0)
    800022a4:	00005517          	auipc	a0,0x5
    800022a8:	2a450513          	addi	a0,a0,676 # 80007548 <etext+0x548>
    800022ac:	a22fe0ef          	jal	800004ce <printf>
    800022b0:	bf45                	j	80002260 <kthread_exit+0x18>

00000000800022b2 <reparent>:
{
    800022b2:	7179                	addi	sp,sp,-48
    800022b4:	f406                	sd	ra,40(sp)
    800022b6:	f022                	sd	s0,32(sp)
    800022b8:	ec26                	sd	s1,24(sp)
    800022ba:	e84a                	sd	s2,16(sp)
    800022bc:	e44e                	sd	s3,8(sp)
    800022be:	e052                	sd	s4,0(sp)
    800022c0:	1800                	addi	s0,sp,48
    800022c2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022c4:	00011497          	auipc	s1,0x11
    800022c8:	a3c48493          	addi	s1,s1,-1476 # 80012d00 <proc>
      pp->parent = initproc;
    800022cc:	00008a17          	auipc	s4,0x8
    800022d0:	4cca0a13          	addi	s4,s4,1228 # 8000a798 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022d4:	00017997          	auipc	s3,0x17
    800022d8:	c2c98993          	addi	s3,s3,-980 # 80018f00 <tickslock>
    800022dc:	a029                	j	800022e6 <reparent+0x34>
    800022de:	18848493          	addi	s1,s1,392
    800022e2:	01348b63          	beq	s1,s3,800022f8 <reparent+0x46>
    if(pp->parent == p){
    800022e6:	6cbc                	ld	a5,88(s1)
    800022e8:	ff279be3          	bne	a5,s2,800022de <reparent+0x2c>
      pp->parent = initproc;
    800022ec:	000a3503          	ld	a0,0(s4)
    800022f0:	eca8                	sd	a0,88(s1)
      wakeup(initproc);
    800022f2:	eedff0ef          	jal	800021de <wakeup>
    800022f6:	b7e5                	j	800022de <reparent+0x2c>
}
    800022f8:	70a2                	ld	ra,40(sp)
    800022fa:	7402                	ld	s0,32(sp)
    800022fc:	64e2                	ld	s1,24(sp)
    800022fe:	6942                	ld	s2,16(sp)
    80002300:	69a2                	ld	s3,8(sp)
    80002302:	6a02                	ld	s4,0(sp)
    80002304:	6145                	addi	sp,sp,48
    80002306:	8082                	ret

0000000080002308 <exit>:
{
    80002308:	7179                	addi	sp,sp,-48
    8000230a:	f406                	sd	ra,40(sp)
    8000230c:	f022                	sd	s0,32(sp)
    8000230e:	ec26                	sd	s1,24(sp)
    80002310:	e84a                	sd	s2,16(sp)
    80002312:	e44e                	sd	s3,8(sp)
    80002314:	e052                	sd	s4,0(sp)
    80002316:	1800                	addi	s0,sp,48
    80002318:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000231a:	dc2ff0ef          	jal	800018dc <myproc>
    8000231e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002320:	00008797          	auipc	a5,0x8
    80002324:	4787b783          	ld	a5,1144(a5) # 8000a798 <initproc>
    80002328:	0f050493          	addi	s1,a0,240
    8000232c:	17050913          	addi	s2,a0,368
    80002330:	00a79b63          	bne	a5,a0,80002346 <exit+0x3e>
    panic("init exiting");
    80002334:	00005517          	auipc	a0,0x5
    80002338:	2f450513          	addi	a0,a0,756 # 80007628 <etext+0x628>
    8000233c:	c62fe0ef          	jal	8000079e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002340:	04a1                	addi	s1,s1,8
    80002342:	01248963          	beq	s1,s2,80002354 <exit+0x4c>
    if(p->ofile[fd]){
    80002346:	6088                	ld	a0,0(s1)
    80002348:	dd65                	beqz	a0,80002340 <exit+0x38>
      fileclose(f);
    8000234a:	719010ef          	jal	80004262 <fileclose>
      p->ofile[fd] = 0;
    8000234e:	0004b023          	sd	zero,0(s1)
    80002352:	b7fd                	j	80002340 <exit+0x38>
  begin_op();
    80002354:	2ef010ef          	jal	80003e42 <begin_op>
  iput(p->cwd);
    80002358:	1709b503          	ld	a0,368(s3)
    8000235c:	3b6010ef          	jal	80003712 <iput>
  end_op();
    80002360:	34d010ef          	jal	80003eac <end_op>
  p->cwd = 0;
    80002364:	1609b823          	sd	zero,368(s3)
  acquire(&wait_lock);
    80002368:	00010497          	auipc	s1,0x10
    8000236c:	58048493          	addi	s1,s1,1408 # 800128e8 <wait_lock>
    80002370:	8526                	mv	a0,s1
    80002372:	88dfe0ef          	jal	80000bfe <acquire>
  reparent(p);
    80002376:	854e                	mv	a0,s3
    80002378:	f3bff0ef          	jal	800022b2 <reparent>
  wakeup(p->parent);
    8000237c:	0589b503          	ld	a0,88(s3)
    80002380:	e5fff0ef          	jal	800021de <wakeup>
  acquire(&p->lock);
    80002384:	854e                	mv	a0,s3
    80002386:	879fe0ef          	jal	80000bfe <acquire>
  p->xstate = status;
    8000238a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000238e:	4795                	li	a5,5
    80002390:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002394:	8526                	mv	a0,s1
    80002396:	8fdfe0ef          	jal	80000c92 <release>
  sched();
    8000239a:	bafff0ef          	jal	80001f48 <sched>
  panic("zombie exit");
    8000239e:	00005517          	auipc	a0,0x5
    800023a2:	27a50513          	addi	a0,a0,634 # 80007618 <etext+0x618>
    800023a6:	bf8fe0ef          	jal	8000079e <panic>

00000000800023aa <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023aa:	7179                	addi	sp,sp,-48
    800023ac:	f406                	sd	ra,40(sp)
    800023ae:	f022                	sd	s0,32(sp)
    800023b0:	ec26                	sd	s1,24(sp)
    800023b2:	e84a                	sd	s2,16(sp)
    800023b4:	e44e                	sd	s3,8(sp)
    800023b6:	1800                	addi	s0,sp,48
    800023b8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023ba:	00011497          	auipc	s1,0x11
    800023be:	94648493          	addi	s1,s1,-1722 # 80012d00 <proc>
    800023c2:	00017997          	auipc	s3,0x17
    800023c6:	b3e98993          	addi	s3,s3,-1218 # 80018f00 <tickslock>
    acquire(&p->lock);
    800023ca:	8526                	mv	a0,s1
    800023cc:	833fe0ef          	jal	80000bfe <acquire>
    if(p->pid == pid){
    800023d0:	589c                	lw	a5,48(s1)
    800023d2:	01278b63          	beq	a5,s2,800023e8 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023d6:	8526                	mv	a0,s1
    800023d8:	8bbfe0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023dc:	18848493          	addi	s1,s1,392
    800023e0:	ff3495e3          	bne	s1,s3,800023ca <kill+0x20>
  }
  return -1;
    800023e4:	557d                	li	a0,-1
    800023e6:	a819                	j	800023fc <kill+0x52>
      p->killed = 1;
    800023e8:	4785                	li	a5,1
    800023ea:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800023ec:	4c98                	lw	a4,24(s1)
    800023ee:	4789                	li	a5,2
    800023f0:	00f70d63          	beq	a4,a5,8000240a <kill+0x60>
      release(&p->lock);
    800023f4:	8526                	mv	a0,s1
    800023f6:	89dfe0ef          	jal	80000c92 <release>
      return 0;
    800023fa:	4501                	li	a0,0
}
    800023fc:	70a2                	ld	ra,40(sp)
    800023fe:	7402                	ld	s0,32(sp)
    80002400:	64e2                	ld	s1,24(sp)
    80002402:	6942                	ld	s2,16(sp)
    80002404:	69a2                	ld	s3,8(sp)
    80002406:	6145                	addi	sp,sp,48
    80002408:	8082                	ret
        p->state = RUNNABLE;
    8000240a:	478d                	li	a5,3
    8000240c:	cc9c                	sw	a5,24(s1)
    8000240e:	b7dd                	j	800023f4 <kill+0x4a>

0000000080002410 <setkilled>:

void
setkilled(struct proc *p)
{
    80002410:	1101                	addi	sp,sp,-32
    80002412:	ec06                	sd	ra,24(sp)
    80002414:	e822                	sd	s0,16(sp)
    80002416:	e426                	sd	s1,8(sp)
    80002418:	1000                	addi	s0,sp,32
    8000241a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000241c:	fe2fe0ef          	jal	80000bfe <acquire>
  p->killed = 1;
    80002420:	4785                	li	a5,1
    80002422:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002424:	8526                	mv	a0,s1
    80002426:	86dfe0ef          	jal	80000c92 <release>
}
    8000242a:	60e2                	ld	ra,24(sp)
    8000242c:	6442                	ld	s0,16(sp)
    8000242e:	64a2                	ld	s1,8(sp)
    80002430:	6105                	addi	sp,sp,32
    80002432:	8082                	ret

0000000080002434 <killed>:

int
killed(struct proc *p)
{
    80002434:	1101                	addi	sp,sp,-32
    80002436:	ec06                	sd	ra,24(sp)
    80002438:	e822                	sd	s0,16(sp)
    8000243a:	e426                	sd	s1,8(sp)
    8000243c:	e04a                	sd	s2,0(sp)
    8000243e:	1000                	addi	s0,sp,32
    80002440:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002442:	fbcfe0ef          	jal	80000bfe <acquire>
  k = p->killed;
    80002446:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000244a:	8526                	mv	a0,s1
    8000244c:	847fe0ef          	jal	80000c92 <release>
  return k;
}
    80002450:	854a                	mv	a0,s2
    80002452:	60e2                	ld	ra,24(sp)
    80002454:	6442                	ld	s0,16(sp)
    80002456:	64a2                	ld	s1,8(sp)
    80002458:	6902                	ld	s2,0(sp)
    8000245a:	6105                	addi	sp,sp,32
    8000245c:	8082                	ret

000000008000245e <wait>:
{
    8000245e:	715d                	addi	sp,sp,-80
    80002460:	e486                	sd	ra,72(sp)
    80002462:	e0a2                	sd	s0,64(sp)
    80002464:	fc26                	sd	s1,56(sp)
    80002466:	f84a                	sd	s2,48(sp)
    80002468:	f44e                	sd	s3,40(sp)
    8000246a:	f052                	sd	s4,32(sp)
    8000246c:	ec56                	sd	s5,24(sp)
    8000246e:	e85a                	sd	s6,16(sp)
    80002470:	e45e                	sd	s7,8(sp)
    80002472:	0880                	addi	s0,sp,80
    80002474:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002476:	c66ff0ef          	jal	800018dc <myproc>
    8000247a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000247c:	00010517          	auipc	a0,0x10
    80002480:	46c50513          	addi	a0,a0,1132 # 800128e8 <wait_lock>
    80002484:	f7afe0ef          	jal	80000bfe <acquire>
        if(pp->state == ZOMBIE){
    80002488:	4a15                	li	s4,5
        havekids = 1;
    8000248a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000248c:	00017997          	auipc	s3,0x17
    80002490:	a7498993          	addi	s3,s3,-1420 # 80018f00 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002494:	00010b97          	auipc	s7,0x10
    80002498:	454b8b93          	addi	s7,s7,1108 # 800128e8 <wait_lock>
    8000249c:	a869                	j	80002536 <wait+0xd8>
          pid = pp->pid;
    8000249e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800024a2:	000b0c63          	beqz	s6,800024ba <wait+0x5c>
    800024a6:	4691                	li	a3,4
    800024a8:	02c48613          	addi	a2,s1,44
    800024ac:	85da                	mv	a1,s6
    800024ae:	07093503          	ld	a0,112(s2)
    800024b2:	8d2ff0ef          	jal	80001584 <copyout>
    800024b6:	02054a63          	bltz	a0,800024ea <wait+0x8c>
          freeproc(pp);
    800024ba:	8526                	mv	a0,s1
    800024bc:	d92ff0ef          	jal	80001a4e <freeproc>
          release(&pp->lock);
    800024c0:	8526                	mv	a0,s1
    800024c2:	fd0fe0ef          	jal	80000c92 <release>
          release(&wait_lock);
    800024c6:	00010517          	auipc	a0,0x10
    800024ca:	42250513          	addi	a0,a0,1058 # 800128e8 <wait_lock>
    800024ce:	fc4fe0ef          	jal	80000c92 <release>
}
    800024d2:	854e                	mv	a0,s3
    800024d4:	60a6                	ld	ra,72(sp)
    800024d6:	6406                	ld	s0,64(sp)
    800024d8:	74e2                	ld	s1,56(sp)
    800024da:	7942                	ld	s2,48(sp)
    800024dc:	79a2                	ld	s3,40(sp)
    800024de:	7a02                	ld	s4,32(sp)
    800024e0:	6ae2                	ld	s5,24(sp)
    800024e2:	6b42                	ld	s6,16(sp)
    800024e4:	6ba2                	ld	s7,8(sp)
    800024e6:	6161                	addi	sp,sp,80
    800024e8:	8082                	ret
            release(&pp->lock);
    800024ea:	8526                	mv	a0,s1
    800024ec:	fa6fe0ef          	jal	80000c92 <release>
            release(&wait_lock);
    800024f0:	00010517          	auipc	a0,0x10
    800024f4:	3f850513          	addi	a0,a0,1016 # 800128e8 <wait_lock>
    800024f8:	f9afe0ef          	jal	80000c92 <release>
            return -1;
    800024fc:	59fd                	li	s3,-1
    800024fe:	bfd1                	j	800024d2 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002500:	18848493          	addi	s1,s1,392
    80002504:	03348063          	beq	s1,s3,80002524 <wait+0xc6>
      if(pp->parent == p){
    80002508:	6cbc                	ld	a5,88(s1)
    8000250a:	ff279be3          	bne	a5,s2,80002500 <wait+0xa2>
        acquire(&pp->lock);
    8000250e:	8526                	mv	a0,s1
    80002510:	eeefe0ef          	jal	80000bfe <acquire>
        if(pp->state == ZOMBIE){
    80002514:	4c9c                	lw	a5,24(s1)
    80002516:	f94784e3          	beq	a5,s4,8000249e <wait+0x40>
        release(&pp->lock);
    8000251a:	8526                	mv	a0,s1
    8000251c:	f76fe0ef          	jal	80000c92 <release>
        havekids = 1;
    80002520:	8756                	mv	a4,s5
    80002522:	bff9                	j	80002500 <wait+0xa2>
    if(!havekids || killed(p)){
    80002524:	cf19                	beqz	a4,80002542 <wait+0xe4>
    80002526:	854a                	mv	a0,s2
    80002528:	f0dff0ef          	jal	80002434 <killed>
    8000252c:	e919                	bnez	a0,80002542 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000252e:	85de                	mv	a1,s7
    80002530:	854a                	mv	a0,s2
    80002532:	afdff0ef          	jal	8000202e <sleep>
    havekids = 0;
    80002536:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002538:	00010497          	auipc	s1,0x10
    8000253c:	7c848493          	addi	s1,s1,1992 # 80012d00 <proc>
    80002540:	b7e1                	j	80002508 <wait+0xaa>
      release(&wait_lock);
    80002542:	00010517          	auipc	a0,0x10
    80002546:	3a650513          	addi	a0,a0,934 # 800128e8 <wait_lock>
    8000254a:	f48fe0ef          	jal	80000c92 <release>
      return -1;
    8000254e:	59fd                	li	s3,-1
    80002550:	b749                	j	800024d2 <wait+0x74>

0000000080002552 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002552:	7179                	addi	sp,sp,-48
    80002554:	f406                	sd	ra,40(sp)
    80002556:	f022                	sd	s0,32(sp)
    80002558:	ec26                	sd	s1,24(sp)
    8000255a:	e84a                	sd	s2,16(sp)
    8000255c:	e44e                	sd	s3,8(sp)
    8000255e:	e052                	sd	s4,0(sp)
    80002560:	1800                	addi	s0,sp,48
    80002562:	84aa                	mv	s1,a0
    80002564:	892e                	mv	s2,a1
    80002566:	89b2                	mv	s3,a2
    80002568:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000256a:	b72ff0ef          	jal	800018dc <myproc>
  if(user_dst){
    8000256e:	cc99                	beqz	s1,8000258c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002570:	86d2                	mv	a3,s4
    80002572:	864e                	mv	a2,s3
    80002574:	85ca                	mv	a1,s2
    80002576:	7928                	ld	a0,112(a0)
    80002578:	80cff0ef          	jal	80001584 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000257c:	70a2                	ld	ra,40(sp)
    8000257e:	7402                	ld	s0,32(sp)
    80002580:	64e2                	ld	s1,24(sp)
    80002582:	6942                	ld	s2,16(sp)
    80002584:	69a2                	ld	s3,8(sp)
    80002586:	6a02                	ld	s4,0(sp)
    80002588:	6145                	addi	sp,sp,48
    8000258a:	8082                	ret
    memmove((char *)dst, src, len);
    8000258c:	000a061b          	sext.w	a2,s4
    80002590:	85ce                	mv	a1,s3
    80002592:	854a                	mv	a0,s2
    80002594:	f9efe0ef          	jal	80000d32 <memmove>
    return 0;
    80002598:	8526                	mv	a0,s1
    8000259a:	b7cd                	j	8000257c <either_copyout+0x2a>

000000008000259c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000259c:	7179                	addi	sp,sp,-48
    8000259e:	f406                	sd	ra,40(sp)
    800025a0:	f022                	sd	s0,32(sp)
    800025a2:	ec26                	sd	s1,24(sp)
    800025a4:	e84a                	sd	s2,16(sp)
    800025a6:	e44e                	sd	s3,8(sp)
    800025a8:	e052                	sd	s4,0(sp)
    800025aa:	1800                	addi	s0,sp,48
    800025ac:	892a                	mv	s2,a0
    800025ae:	84ae                	mv	s1,a1
    800025b0:	89b2                	mv	s3,a2
    800025b2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025b4:	b28ff0ef          	jal	800018dc <myproc>
  if(user_src){
    800025b8:	cc99                	beqz	s1,800025d6 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800025ba:	86d2                	mv	a3,s4
    800025bc:	864e                	mv	a2,s3
    800025be:	85ca                	mv	a1,s2
    800025c0:	7928                	ld	a0,112(a0)
    800025c2:	872ff0ef          	jal	80001634 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800025c6:	70a2                	ld	ra,40(sp)
    800025c8:	7402                	ld	s0,32(sp)
    800025ca:	64e2                	ld	s1,24(sp)
    800025cc:	6942                	ld	s2,16(sp)
    800025ce:	69a2                	ld	s3,8(sp)
    800025d0:	6a02                	ld	s4,0(sp)
    800025d2:	6145                	addi	sp,sp,48
    800025d4:	8082                	ret
    memmove(dst, (char*)src, len);
    800025d6:	000a061b          	sext.w	a2,s4
    800025da:	85ce                	mv	a1,s3
    800025dc:	854a                	mv	a0,s2
    800025de:	f54fe0ef          	jal	80000d32 <memmove>
    return 0;
    800025e2:	8526                	mv	a0,s1
    800025e4:	b7cd                	j	800025c6 <either_copyin+0x2a>

00000000800025e6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025e6:	715d                	addi	sp,sp,-80
    800025e8:	e486                	sd	ra,72(sp)
    800025ea:	e0a2                	sd	s0,64(sp)
    800025ec:	fc26                	sd	s1,56(sp)
    800025ee:	f84a                	sd	s2,48(sp)
    800025f0:	f44e                	sd	s3,40(sp)
    800025f2:	f052                	sd	s4,32(sp)
    800025f4:	ec56                	sd	s5,24(sp)
    800025f6:	e85a                	sd	s6,16(sp)
    800025f8:	e45e                	sd	s7,8(sp)
    800025fa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025fc:	00005517          	auipc	a0,0x5
    80002600:	ebc50513          	addi	a0,a0,-324 # 800074b8 <etext+0x4b8>
    80002604:	ecbfd0ef          	jal	800004ce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002608:	00011497          	auipc	s1,0x11
    8000260c:	87048493          	addi	s1,s1,-1936 # 80012e78 <proc+0x178>
    80002610:	00017917          	auipc	s2,0x17
    80002614:	a6890913          	addi	s2,s2,-1432 # 80019078 <bcache+0x160>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002618:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000261a:	00005997          	auipc	s3,0x5
    8000261e:	01e98993          	addi	s3,s3,30 # 80007638 <etext+0x638>
    printf("%d %s %s", p->pid, state, p->name);
    80002622:	00005a97          	auipc	s5,0x5
    80002626:	01ea8a93          	addi	s5,s5,30 # 80007640 <etext+0x640>
    printf("\n");
    8000262a:	00005a17          	auipc	s4,0x5
    8000262e:	e8ea0a13          	addi	s4,s4,-370 # 800074b8 <etext+0x4b8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002632:	00005b97          	auipc	s7,0x5
    80002636:	4eeb8b93          	addi	s7,s7,1262 # 80007b20 <states.0>
    8000263a:	a829                	j	80002654 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000263c:	eb86a583          	lw	a1,-328(a3)
    80002640:	8556                	mv	a0,s5
    80002642:	e8dfd0ef          	jal	800004ce <printf>
    printf("\n");
    80002646:	8552                	mv	a0,s4
    80002648:	e87fd0ef          	jal	800004ce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000264c:	18848493          	addi	s1,s1,392
    80002650:	03248263          	beq	s1,s2,80002674 <procdump+0x8e>
    if(p->state == UNUSED)
    80002654:	86a6                	mv	a3,s1
    80002656:	ea04a783          	lw	a5,-352(s1)
    8000265a:	dbed                	beqz	a5,8000264c <procdump+0x66>
      state = "???";
    8000265c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000265e:	fcfb6fe3          	bltu	s6,a5,8000263c <procdump+0x56>
    80002662:	02079713          	slli	a4,a5,0x20
    80002666:	01d75793          	srli	a5,a4,0x1d
    8000266a:	97de                	add	a5,a5,s7
    8000266c:	6390                	ld	a2,0(a5)
    8000266e:	f679                	bnez	a2,8000263c <procdump+0x56>
      state = "???";
    80002670:	864e                	mv	a2,s3
    80002672:	b7e9                	j	8000263c <procdump+0x56>
  }
}
    80002674:	60a6                	ld	ra,72(sp)
    80002676:	6406                	ld	s0,64(sp)
    80002678:	74e2                	ld	s1,56(sp)
    8000267a:	7942                	ld	s2,48(sp)
    8000267c:	79a2                	ld	s3,40(sp)
    8000267e:	7a02                	ld	s4,32(sp)
    80002680:	6ae2                	ld	s5,24(sp)
    80002682:	6b42                	ld	s6,16(sp)
    80002684:	6ba2                	ld	s7,8(sp)
    80002686:	6161                	addi	sp,sp,80
    80002688:	8082                	ret

000000008000268a <swtch>:
    8000268a:	00153023          	sd	ra,0(a0)
    8000268e:	00253423          	sd	sp,8(a0)
    80002692:	e900                	sd	s0,16(a0)
    80002694:	ed04                	sd	s1,24(a0)
    80002696:	03253023          	sd	s2,32(a0)
    8000269a:	03353423          	sd	s3,40(a0)
    8000269e:	03453823          	sd	s4,48(a0)
    800026a2:	03553c23          	sd	s5,56(a0)
    800026a6:	05653023          	sd	s6,64(a0)
    800026aa:	05753423          	sd	s7,72(a0)
    800026ae:	05853823          	sd	s8,80(a0)
    800026b2:	05953c23          	sd	s9,88(a0)
    800026b6:	07a53023          	sd	s10,96(a0)
    800026ba:	07b53423          	sd	s11,104(a0)
    800026be:	0005b083          	ld	ra,0(a1)
    800026c2:	0085b103          	ld	sp,8(a1)
    800026c6:	6980                	ld	s0,16(a1)
    800026c8:	6d84                	ld	s1,24(a1)
    800026ca:	0205b903          	ld	s2,32(a1)
    800026ce:	0285b983          	ld	s3,40(a1)
    800026d2:	0305ba03          	ld	s4,48(a1)
    800026d6:	0385ba83          	ld	s5,56(a1)
    800026da:	0405bb03          	ld	s6,64(a1)
    800026de:	0485bb83          	ld	s7,72(a1)
    800026e2:	0505bc03          	ld	s8,80(a1)
    800026e6:	0585bc83          	ld	s9,88(a1)
    800026ea:	0605bd03          	ld	s10,96(a1)
    800026ee:	0685bd83          	ld	s11,104(a1)
    800026f2:	8082                	ret

00000000800026f4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026f4:	1141                	addi	sp,sp,-16
    800026f6:	e406                	sd	ra,8(sp)
    800026f8:	e022                	sd	s0,0(sp)
    800026fa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026fc:	00005597          	auipc	a1,0x5
    80002700:	f8458593          	addi	a1,a1,-124 # 80007680 <etext+0x680>
    80002704:	00016517          	auipc	a0,0x16
    80002708:	7fc50513          	addi	a0,a0,2044 # 80018f00 <tickslock>
    8000270c:	c6efe0ef          	jal	80000b7a <initlock>
}
    80002710:	60a2                	ld	ra,8(sp)
    80002712:	6402                	ld	s0,0(sp)
    80002714:	0141                	addi	sp,sp,16
    80002716:	8082                	ret

0000000080002718 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002718:	1141                	addi	sp,sp,-16
    8000271a:	e406                	sd	ra,8(sp)
    8000271c:	e022                	sd	s0,0(sp)
    8000271e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002720:	00003797          	auipc	a5,0x3
    80002724:	ef078793          	addi	a5,a5,-272 # 80005610 <kernelvec>
    80002728:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000272c:	60a2                	ld	ra,8(sp)
    8000272e:	6402                	ld	s0,0(sp)
    80002730:	0141                	addi	sp,sp,16
    80002732:	8082                	ret

0000000080002734 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002734:	1141                	addi	sp,sp,-16
    80002736:	e406                	sd	ra,8(sp)
    80002738:	e022                	sd	s0,0(sp)
    8000273a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000273c:	9a0ff0ef          	jal	800018dc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002740:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002744:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002746:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000274a:	00004697          	auipc	a3,0x4
    8000274e:	8b668693          	addi	a3,a3,-1866 # 80006000 <_trampoline>
    80002752:	00004717          	auipc	a4,0x4
    80002756:	8ae70713          	addi	a4,a4,-1874 # 80006000 <_trampoline>
    8000275a:	8f15                	sub	a4,a4,a3
    8000275c:	040007b7          	lui	a5,0x4000
    80002760:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002762:	07b2                	slli	a5,a5,0xc
    80002764:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002766:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000276a:	7d38                	ld	a4,120(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000276c:	18002673          	csrr	a2,satp
    80002770:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002772:	7d30                	ld	a2,120(a0)
    80002774:	7138                	ld	a4,96(a0)
    80002776:	6585                	lui	a1,0x1
    80002778:	972e                	add	a4,a4,a1
    8000277a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000277c:	7d38                	ld	a4,120(a0)
    8000277e:	00000617          	auipc	a2,0x0
    80002782:	11060613          	addi	a2,a2,272 # 8000288e <usertrap>
    80002786:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002788:	7d38                	ld	a4,120(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000278a:	8612                	mv	a2,tp
    8000278c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000278e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002792:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002796:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000279a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000279e:	7d38                	ld	a4,120(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027a0:	6f18                	ld	a4,24(a4)
    800027a2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800027a6:	7928                	ld	a0,112(a0)
    800027a8:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800027aa:	00004717          	auipc	a4,0x4
    800027ae:	8f270713          	addi	a4,a4,-1806 # 8000609c <userret>
    800027b2:	8f15                	sub	a4,a4,a3
    800027b4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800027b6:	577d                	li	a4,-1
    800027b8:	177e                	slli	a4,a4,0x3f
    800027ba:	8d59                	or	a0,a0,a4
    800027bc:	9782                	jalr	a5
}
    800027be:	60a2                	ld	ra,8(sp)
    800027c0:	6402                	ld	s0,0(sp)
    800027c2:	0141                	addi	sp,sp,16
    800027c4:	8082                	ret

00000000800027c6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800027ce:	8daff0ef          	jal	800018a8 <cpuid>
    800027d2:	cd11                	beqz	a0,800027ee <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800027d4:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800027d8:	000f4737          	lui	a4,0xf4
    800027dc:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800027e0:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800027e2:	14d79073          	csrw	stimecmp,a5
}
    800027e6:	60e2                	ld	ra,24(sp)
    800027e8:	6442                	ld	s0,16(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret
    800027ee:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800027f0:	00016497          	auipc	s1,0x16
    800027f4:	71048493          	addi	s1,s1,1808 # 80018f00 <tickslock>
    800027f8:	8526                	mv	a0,s1
    800027fa:	c04fe0ef          	jal	80000bfe <acquire>
    ticks++;
    800027fe:	00008517          	auipc	a0,0x8
    80002802:	fa250513          	addi	a0,a0,-94 # 8000a7a0 <ticks>
    80002806:	411c                	lw	a5,0(a0)
    80002808:	2785                	addiw	a5,a5,1
    8000280a:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000280c:	9d3ff0ef          	jal	800021de <wakeup>
    release(&tickslock);
    80002810:	8526                	mv	a0,s1
    80002812:	c80fe0ef          	jal	80000c92 <release>
    80002816:	64a2                	ld	s1,8(sp)
    80002818:	bf75                	j	800027d4 <clockintr+0xe>

000000008000281a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000281a:	1101                	addi	sp,sp,-32
    8000281c:	ec06                	sd	ra,24(sp)
    8000281e:	e822                	sd	s0,16(sp)
    80002820:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002822:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002826:	57fd                	li	a5,-1
    80002828:	17fe                	slli	a5,a5,0x3f
    8000282a:	07a5                	addi	a5,a5,9
    8000282c:	00f70c63          	beq	a4,a5,80002844 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002830:	57fd                	li	a5,-1
    80002832:	17fe                	slli	a5,a5,0x3f
    80002834:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002836:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002838:	04f70763          	beq	a4,a5,80002886 <devintr+0x6c>
  }
}
    8000283c:	60e2                	ld	ra,24(sp)
    8000283e:	6442                	ld	s0,16(sp)
    80002840:	6105                	addi	sp,sp,32
    80002842:	8082                	ret
    80002844:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002846:	677020ef          	jal	800056bc <plic_claim>
    8000284a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000284c:	47a9                	li	a5,10
    8000284e:	00f50963          	beq	a0,a5,80002860 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002852:	4785                	li	a5,1
    80002854:	00f50963          	beq	a0,a5,80002866 <devintr+0x4c>
    return 1;
    80002858:	4505                	li	a0,1
    } else if(irq){
    8000285a:	e889                	bnez	s1,8000286c <devintr+0x52>
    8000285c:	64a2                	ld	s1,8(sp)
    8000285e:	bff9                	j	8000283c <devintr+0x22>
      uartintr();
    80002860:	9acfe0ef          	jal	80000a0c <uartintr>
    if(irq)
    80002864:	a819                	j	8000287a <devintr+0x60>
      virtio_disk_intr();
    80002866:	2e6030ef          	jal	80005b4c <virtio_disk_intr>
    if(irq)
    8000286a:	a801                	j	8000287a <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000286c:	85a6                	mv	a1,s1
    8000286e:	00005517          	auipc	a0,0x5
    80002872:	e1a50513          	addi	a0,a0,-486 # 80007688 <etext+0x688>
    80002876:	c59fd0ef          	jal	800004ce <printf>
      plic_complete(irq);
    8000287a:	8526                	mv	a0,s1
    8000287c:	661020ef          	jal	800056dc <plic_complete>
    return 1;
    80002880:	4505                	li	a0,1
    80002882:	64a2                	ld	s1,8(sp)
    80002884:	bf65                	j	8000283c <devintr+0x22>
    clockintr();
    80002886:	f41ff0ef          	jal	800027c6 <clockintr>
    return 2;
    8000288a:	4509                	li	a0,2
    8000288c:	bf45                	j	8000283c <devintr+0x22>

000000008000288e <usertrap>:
{
    8000288e:	1101                	addi	sp,sp,-32
    80002890:	ec06                	sd	ra,24(sp)
    80002892:	e822                	sd	s0,16(sp)
    80002894:	e426                	sd	s1,8(sp)
    80002896:	e04a                	sd	s2,0(sp)
    80002898:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000289a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000289e:	1007f793          	andi	a5,a5,256
    800028a2:	ef85                	bnez	a5,800028da <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028a4:	00003797          	auipc	a5,0x3
    800028a8:	d6c78793          	addi	a5,a5,-660 # 80005610 <kernelvec>
    800028ac:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028b0:	82cff0ef          	jal	800018dc <myproc>
    800028b4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028b6:	7d3c                	ld	a5,120(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028b8:	14102773          	csrr	a4,sepc
    800028bc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028be:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028c2:	47a1                	li	a5,8
    800028c4:	02f70163          	beq	a4,a5,800028e6 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800028c8:	f53ff0ef          	jal	8000281a <devintr>
    800028cc:	892a                	mv	s2,a0
    800028ce:	c135                	beqz	a0,80002932 <usertrap+0xa4>
  if(killed(p))
    800028d0:	8526                	mv	a0,s1
    800028d2:	b63ff0ef          	jal	80002434 <killed>
    800028d6:	cd1d                	beqz	a0,80002914 <usertrap+0x86>
    800028d8:	a81d                	j	8000290e <usertrap+0x80>
    panic("usertrap: not from user mode");
    800028da:	00005517          	auipc	a0,0x5
    800028de:	dce50513          	addi	a0,a0,-562 # 800076a8 <etext+0x6a8>
    800028e2:	ebdfd0ef          	jal	8000079e <panic>
    if(killed(p))
    800028e6:	b4fff0ef          	jal	80002434 <killed>
    800028ea:	e121                	bnez	a0,8000292a <usertrap+0x9c>
    p->trapframe->epc += 4;
    800028ec:	7cb8                	ld	a4,120(s1)
    800028ee:	6f1c                	ld	a5,24(a4)
    800028f0:	0791                	addi	a5,a5,4
    800028f2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028f8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028fc:	10079073          	csrw	sstatus,a5
    syscall();
    80002900:	240000ef          	jal	80002b40 <syscall>
  if(killed(p))
    80002904:	8526                	mv	a0,s1
    80002906:	b2fff0ef          	jal	80002434 <killed>
    8000290a:	c901                	beqz	a0,8000291a <usertrap+0x8c>
    8000290c:	4901                	li	s2,0
    exit(-1);
    8000290e:	557d                	li	a0,-1
    80002910:	9f9ff0ef          	jal	80002308 <exit>
  if(which_dev == 2)
    80002914:	4789                	li	a5,2
    80002916:	04f90563          	beq	s2,a5,80002960 <usertrap+0xd2>
  usertrapret();
    8000291a:	e1bff0ef          	jal	80002734 <usertrapret>
}
    8000291e:	60e2                	ld	ra,24(sp)
    80002920:	6442                	ld	s0,16(sp)
    80002922:	64a2                	ld	s1,8(sp)
    80002924:	6902                	ld	s2,0(sp)
    80002926:	6105                	addi	sp,sp,32
    80002928:	8082                	ret
      exit(-1);
    8000292a:	557d                	li	a0,-1
    8000292c:	9ddff0ef          	jal	80002308 <exit>
    80002930:	bf75                	j	800028ec <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002932:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002936:	5890                	lw	a2,48(s1)
    80002938:	00005517          	auipc	a0,0x5
    8000293c:	d9050513          	addi	a0,a0,-624 # 800076c8 <etext+0x6c8>
    80002940:	b8ffd0ef          	jal	800004ce <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002944:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002948:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000294c:	00005517          	auipc	a0,0x5
    80002950:	dac50513          	addi	a0,a0,-596 # 800076f8 <etext+0x6f8>
    80002954:	b7bfd0ef          	jal	800004ce <printf>
    setkilled(p);
    80002958:	8526                	mv	a0,s1
    8000295a:	ab7ff0ef          	jal	80002410 <setkilled>
    8000295e:	b75d                	j	80002904 <usertrap+0x76>
    yield();
    80002960:	ea2ff0ef          	jal	80002002 <yield>
    80002964:	bf5d                	j	8000291a <usertrap+0x8c>

0000000080002966 <kerneltrap>:
{
    80002966:	7179                	addi	sp,sp,-48
    80002968:	f406                	sd	ra,40(sp)
    8000296a:	f022                	sd	s0,32(sp)
    8000296c:	ec26                	sd	s1,24(sp)
    8000296e:	e84a                	sd	s2,16(sp)
    80002970:	e44e                	sd	s3,8(sp)
    80002972:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002974:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002978:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000297c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002980:	1004f793          	andi	a5,s1,256
    80002984:	c795                	beqz	a5,800029b0 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002986:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000298a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000298c:	eb85                	bnez	a5,800029bc <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    8000298e:	e8dff0ef          	jal	8000281a <devintr>
    80002992:	c91d                	beqz	a0,800029c8 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002994:	4789                	li	a5,2
    80002996:	04f50a63          	beq	a0,a5,800029ea <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000299a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000299e:	10049073          	csrw	sstatus,s1
}
    800029a2:	70a2                	ld	ra,40(sp)
    800029a4:	7402                	ld	s0,32(sp)
    800029a6:	64e2                	ld	s1,24(sp)
    800029a8:	6942                	ld	s2,16(sp)
    800029aa:	69a2                	ld	s3,8(sp)
    800029ac:	6145                	addi	sp,sp,48
    800029ae:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029b0:	00005517          	auipc	a0,0x5
    800029b4:	d7050513          	addi	a0,a0,-656 # 80007720 <etext+0x720>
    800029b8:	de7fd0ef          	jal	8000079e <panic>
    panic("kerneltrap: interrupts enabled");
    800029bc:	00005517          	auipc	a0,0x5
    800029c0:	d8c50513          	addi	a0,a0,-628 # 80007748 <etext+0x748>
    800029c4:	ddbfd0ef          	jal	8000079e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029c8:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029cc:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800029d0:	85ce                	mv	a1,s3
    800029d2:	00005517          	auipc	a0,0x5
    800029d6:	d9650513          	addi	a0,a0,-618 # 80007768 <etext+0x768>
    800029da:	af5fd0ef          	jal	800004ce <printf>
    panic("kerneltrap");
    800029de:	00005517          	auipc	a0,0x5
    800029e2:	db250513          	addi	a0,a0,-590 # 80007790 <etext+0x790>
    800029e6:	db9fd0ef          	jal	8000079e <panic>
  if(which_dev == 2 && myproc() != 0)
    800029ea:	ef3fe0ef          	jal	800018dc <myproc>
    800029ee:	d555                	beqz	a0,8000299a <kerneltrap+0x34>
    yield();
    800029f0:	e12ff0ef          	jal	80002002 <yield>
    800029f4:	b75d                	j	8000299a <kerneltrap+0x34>

00000000800029f6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800029f6:	1101                	addi	sp,sp,-32
    800029f8:	ec06                	sd	ra,24(sp)
    800029fa:	e822                	sd	s0,16(sp)
    800029fc:	e426                	sd	s1,8(sp)
    800029fe:	1000                	addi	s0,sp,32
    80002a00:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a02:	edbfe0ef          	jal	800018dc <myproc>
  switch (n) {
    80002a06:	4795                	li	a5,5
    80002a08:	0497e163          	bltu	a5,s1,80002a4a <argraw+0x54>
    80002a0c:	048a                	slli	s1,s1,0x2
    80002a0e:	00005717          	auipc	a4,0x5
    80002a12:	14270713          	addi	a4,a4,322 # 80007b50 <states.0+0x30>
    80002a16:	94ba                	add	s1,s1,a4
    80002a18:	409c                	lw	a5,0(s1)
    80002a1a:	97ba                	add	a5,a5,a4
    80002a1c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a1e:	7d3c                	ld	a5,120(a0)
    80002a20:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a22:	60e2                	ld	ra,24(sp)
    80002a24:	6442                	ld	s0,16(sp)
    80002a26:	64a2                	ld	s1,8(sp)
    80002a28:	6105                	addi	sp,sp,32
    80002a2a:	8082                	ret
    return p->trapframe->a1;
    80002a2c:	7d3c                	ld	a5,120(a0)
    80002a2e:	7fa8                	ld	a0,120(a5)
    80002a30:	bfcd                	j	80002a22 <argraw+0x2c>
    return p->trapframe->a2;
    80002a32:	7d3c                	ld	a5,120(a0)
    80002a34:	63c8                	ld	a0,128(a5)
    80002a36:	b7f5                	j	80002a22 <argraw+0x2c>
    return p->trapframe->a3;
    80002a38:	7d3c                	ld	a5,120(a0)
    80002a3a:	67c8                	ld	a0,136(a5)
    80002a3c:	b7dd                	j	80002a22 <argraw+0x2c>
    return p->trapframe->a4;
    80002a3e:	7d3c                	ld	a5,120(a0)
    80002a40:	6bc8                	ld	a0,144(a5)
    80002a42:	b7c5                	j	80002a22 <argraw+0x2c>
    return p->trapframe->a5;
    80002a44:	7d3c                	ld	a5,120(a0)
    80002a46:	6fc8                	ld	a0,152(a5)
    80002a48:	bfe9                	j	80002a22 <argraw+0x2c>
  panic("argraw");
    80002a4a:	00005517          	auipc	a0,0x5
    80002a4e:	d5650513          	addi	a0,a0,-682 # 800077a0 <etext+0x7a0>
    80002a52:	d4dfd0ef          	jal	8000079e <panic>

0000000080002a56 <fetchaddr>:
{
    80002a56:	1101                	addi	sp,sp,-32
    80002a58:	ec06                	sd	ra,24(sp)
    80002a5a:	e822                	sd	s0,16(sp)
    80002a5c:	e426                	sd	s1,8(sp)
    80002a5e:	e04a                	sd	s2,0(sp)
    80002a60:	1000                	addi	s0,sp,32
    80002a62:	84aa                	mv	s1,a0
    80002a64:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a66:	e77fe0ef          	jal	800018dc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002a6a:	753c                	ld	a5,104(a0)
    80002a6c:	02f4f663          	bgeu	s1,a5,80002a98 <fetchaddr+0x42>
    80002a70:	00848713          	addi	a4,s1,8
    80002a74:	02e7e463          	bltu	a5,a4,80002a9c <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a78:	46a1                	li	a3,8
    80002a7a:	8626                	mv	a2,s1
    80002a7c:	85ca                	mv	a1,s2
    80002a7e:	7928                	ld	a0,112(a0)
    80002a80:	bb5fe0ef          	jal	80001634 <copyin>
    80002a84:	00a03533          	snez	a0,a0
    80002a88:	40a0053b          	negw	a0,a0
}
    80002a8c:	60e2                	ld	ra,24(sp)
    80002a8e:	6442                	ld	s0,16(sp)
    80002a90:	64a2                	ld	s1,8(sp)
    80002a92:	6902                	ld	s2,0(sp)
    80002a94:	6105                	addi	sp,sp,32
    80002a96:	8082                	ret
    return -1;
    80002a98:	557d                	li	a0,-1
    80002a9a:	bfcd                	j	80002a8c <fetchaddr+0x36>
    80002a9c:	557d                	li	a0,-1
    80002a9e:	b7fd                	j	80002a8c <fetchaddr+0x36>

0000000080002aa0 <fetchstr>:
{
    80002aa0:	7179                	addi	sp,sp,-48
    80002aa2:	f406                	sd	ra,40(sp)
    80002aa4:	f022                	sd	s0,32(sp)
    80002aa6:	ec26                	sd	s1,24(sp)
    80002aa8:	e84a                	sd	s2,16(sp)
    80002aaa:	e44e                	sd	s3,8(sp)
    80002aac:	1800                	addi	s0,sp,48
    80002aae:	892a                	mv	s2,a0
    80002ab0:	84ae                	mv	s1,a1
    80002ab2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002ab4:	e29fe0ef          	jal	800018dc <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002ab8:	86ce                	mv	a3,s3
    80002aba:	864a                	mv	a2,s2
    80002abc:	85a6                	mv	a1,s1
    80002abe:	7928                	ld	a0,112(a0)
    80002ac0:	bfbfe0ef          	jal	800016ba <copyinstr>
    80002ac4:	00054c63          	bltz	a0,80002adc <fetchstr+0x3c>
  return strlen(buf);
    80002ac8:	8526                	mv	a0,s1
    80002aca:	b8cfe0ef          	jal	80000e56 <strlen>
}
    80002ace:	70a2                	ld	ra,40(sp)
    80002ad0:	7402                	ld	s0,32(sp)
    80002ad2:	64e2                	ld	s1,24(sp)
    80002ad4:	6942                	ld	s2,16(sp)
    80002ad6:	69a2                	ld	s3,8(sp)
    80002ad8:	6145                	addi	sp,sp,48
    80002ada:	8082                	ret
    return -1;
    80002adc:	557d                	li	a0,-1
    80002ade:	bfc5                	j	80002ace <fetchstr+0x2e>

0000000080002ae0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ae0:	1101                	addi	sp,sp,-32
    80002ae2:	ec06                	sd	ra,24(sp)
    80002ae4:	e822                	sd	s0,16(sp)
    80002ae6:	e426                	sd	s1,8(sp)
    80002ae8:	1000                	addi	s0,sp,32
    80002aea:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002aec:	f0bff0ef          	jal	800029f6 <argraw>
    80002af0:	c088                	sw	a0,0(s1)
}
    80002af2:	60e2                	ld	ra,24(sp)
    80002af4:	6442                	ld	s0,16(sp)
    80002af6:	64a2                	ld	s1,8(sp)
    80002af8:	6105                	addi	sp,sp,32
    80002afa:	8082                	ret

0000000080002afc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002afc:	1101                	addi	sp,sp,-32
    80002afe:	ec06                	sd	ra,24(sp)
    80002b00:	e822                	sd	s0,16(sp)
    80002b02:	e426                	sd	s1,8(sp)
    80002b04:	1000                	addi	s0,sp,32
    80002b06:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b08:	eefff0ef          	jal	800029f6 <argraw>
    80002b0c:	e088                	sd	a0,0(s1)
}
    80002b0e:	60e2                	ld	ra,24(sp)
    80002b10:	6442                	ld	s0,16(sp)
    80002b12:	64a2                	ld	s1,8(sp)
    80002b14:	6105                	addi	sp,sp,32
    80002b16:	8082                	ret

0000000080002b18 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b18:	1101                	addi	sp,sp,-32
    80002b1a:	ec06                	sd	ra,24(sp)
    80002b1c:	e822                	sd	s0,16(sp)
    80002b1e:	e426                	sd	s1,8(sp)
    80002b20:	e04a                	sd	s2,0(sp)
    80002b22:	1000                	addi	s0,sp,32
    80002b24:	84ae                	mv	s1,a1
    80002b26:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002b28:	ecfff0ef          	jal	800029f6 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002b2c:	864a                	mv	a2,s2
    80002b2e:	85a6                	mv	a1,s1
    80002b30:	f71ff0ef          	jal	80002aa0 <fetchstr>
}
    80002b34:	60e2                	ld	ra,24(sp)
    80002b36:	6442                	ld	s0,16(sp)
    80002b38:	64a2                	ld	s1,8(sp)
    80002b3a:	6902                	ld	s2,0(sp)
    80002b3c:	6105                	addi	sp,sp,32
    80002b3e:	8082                	ret

0000000080002b40 <syscall>:
[SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
    80002b40:	1101                	addi	sp,sp,-32
    80002b42:	ec06                	sd	ra,24(sp)
    80002b44:	e822                	sd	s0,16(sp)
    80002b46:	e426                	sd	s1,8(sp)
    80002b48:	e04a                	sd	s2,0(sp)
    80002b4a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b4c:	d91fe0ef          	jal	800018dc <myproc>
    80002b50:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b52:	07853903          	ld	s2,120(a0)
    80002b56:	0a893783          	ld	a5,168(s2)
    80002b5a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b5e:	37fd                	addiw	a5,a5,-1
    80002b60:	475d                	li	a4,23
    80002b62:	00f76f63          	bltu	a4,a5,80002b80 <syscall+0x40>
    80002b66:	00369713          	slli	a4,a3,0x3
    80002b6a:	00005797          	auipc	a5,0x5
    80002b6e:	ffe78793          	addi	a5,a5,-2 # 80007b68 <syscalls>
    80002b72:	97ba                	add	a5,a5,a4
    80002b74:	639c                	ld	a5,0(a5)
    80002b76:	c789                	beqz	a5,80002b80 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002b78:	9782                	jalr	a5
    80002b7a:	06a93823          	sd	a0,112(s2)
    80002b7e:	a829                	j	80002b98 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b80:	17848613          	addi	a2,s1,376
    80002b84:	588c                	lw	a1,48(s1)
    80002b86:	00005517          	auipc	a0,0x5
    80002b8a:	c2250513          	addi	a0,a0,-990 # 800077a8 <etext+0x7a8>
    80002b8e:	941fd0ef          	jal	800004ce <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b92:	7cbc                	ld	a5,120(s1)
    80002b94:	577d                	li	a4,-1
    80002b96:	fbb8                	sd	a4,112(a5)
  }
}
    80002b98:	60e2                	ld	ra,24(sp)
    80002b9a:	6442                	ld	s0,16(sp)
    80002b9c:	64a2                	ld	s1,8(sp)
    80002b9e:	6902                	ld	s2,0(sp)
    80002ba0:	6105                	addi	sp,sp,32
    80002ba2:	8082                	ret

0000000080002ba4 <sys_exit>:

// Remove prototype for kthread_dbg since it's not used

uint64
sys_exit(void)
{
    80002ba4:	1101                	addi	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002bac:	fec40593          	addi	a1,s0,-20
    80002bb0:	4501                	li	a0,0
    80002bb2:	f2fff0ef          	jal	80002ae0 <argint>
  exit(n);
    80002bb6:	fec42503          	lw	a0,-20(s0)
    80002bba:	f4eff0ef          	jal	80002308 <exit>
  return 0;  // not reached
}
    80002bbe:	4501                	li	a0,0
    80002bc0:	60e2                	ld	ra,24(sp)
    80002bc2:	6442                	ld	s0,16(sp)
    80002bc4:	6105                	addi	sp,sp,32
    80002bc6:	8082                	ret

0000000080002bc8 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002bc8:	1141                	addi	sp,sp,-16
    80002bca:	e406                	sd	ra,8(sp)
    80002bcc:	e022                	sd	s0,0(sp)
    80002bce:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002bd0:	d0dfe0ef          	jal	800018dc <myproc>
}
    80002bd4:	5908                	lw	a0,48(a0)
    80002bd6:	60a2                	ld	ra,8(sp)
    80002bd8:	6402                	ld	s0,0(sp)
    80002bda:	0141                	addi	sp,sp,16
    80002bdc:	8082                	ret

0000000080002bde <sys_fork>:

uint64
sys_fork(void)
{
    80002bde:	1141                	addi	sp,sp,-16
    80002be0:	e406                	sd	ra,8(sp)
    80002be2:	e022                	sd	s0,0(sp)
    80002be4:	0800                	addi	s0,sp,16
  return fork();
    80002be6:	83aff0ef          	jal	80001c20 <fork>
}
    80002bea:	60a2                	ld	ra,8(sp)
    80002bec:	6402                	ld	s0,0(sp)
    80002bee:	0141                	addi	sp,sp,16
    80002bf0:	8082                	ret

0000000080002bf2 <sys_wait>:

uint64
sys_wait(void)
{
    80002bf2:	1101                	addi	sp,sp,-32
    80002bf4:	ec06                	sd	ra,24(sp)
    80002bf6:	e822                	sd	s0,16(sp)
    80002bf8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002bfa:	fe840593          	addi	a1,s0,-24
    80002bfe:	4501                	li	a0,0
    80002c00:	efdff0ef          	jal	80002afc <argaddr>
  return wait(p);
    80002c04:	fe843503          	ld	a0,-24(s0)
    80002c08:	857ff0ef          	jal	8000245e <wait>
}
    80002c0c:	60e2                	ld	ra,24(sp)
    80002c0e:	6442                	ld	s0,16(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret

0000000080002c14 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c14:	7179                	addi	sp,sp,-48
    80002c16:	f406                	sd	ra,40(sp)
    80002c18:	f022                	sd	s0,32(sp)
    80002c1a:	ec26                	sd	s1,24(sp)
    80002c1c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002c1e:	fdc40593          	addi	a1,s0,-36
    80002c22:	4501                	li	a0,0
    80002c24:	ebdff0ef          	jal	80002ae0 <argint>
  addr = myproc()->sz;
    80002c28:	cb5fe0ef          	jal	800018dc <myproc>
    80002c2c:	7524                	ld	s1,104(a0)
  if(growproc(n) < 0)
    80002c2e:	fdc42503          	lw	a0,-36(s0)
    80002c32:	f9ffe0ef          	jal	80001bd0 <growproc>
    80002c36:	00054863          	bltz	a0,80002c46 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002c3a:	8526                	mv	a0,s1
    80002c3c:	70a2                	ld	ra,40(sp)
    80002c3e:	7402                	ld	s0,32(sp)
    80002c40:	64e2                	ld	s1,24(sp)
    80002c42:	6145                	addi	sp,sp,48
    80002c44:	8082                	ret
    return -1;
    80002c46:	54fd                	li	s1,-1
    80002c48:	bfcd                	j	80002c3a <sys_sbrk+0x26>

0000000080002c4a <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c4a:	7139                	addi	sp,sp,-64
    80002c4c:	fc06                	sd	ra,56(sp)
    80002c4e:	f822                	sd	s0,48(sp)
    80002c50:	f04a                	sd	s2,32(sp)
    80002c52:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002c54:	fcc40593          	addi	a1,s0,-52
    80002c58:	4501                	li	a0,0
    80002c5a:	e87ff0ef          	jal	80002ae0 <argint>
  if(n < 0)
    80002c5e:	fcc42783          	lw	a5,-52(s0)
    80002c62:	0607c763          	bltz	a5,80002cd0 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002c66:	00016517          	auipc	a0,0x16
    80002c6a:	29a50513          	addi	a0,a0,666 # 80018f00 <tickslock>
    80002c6e:	f91fd0ef          	jal	80000bfe <acquire>
  ticks0 = ticks;
    80002c72:	00008917          	auipc	s2,0x8
    80002c76:	b2e92903          	lw	s2,-1234(s2) # 8000a7a0 <ticks>
  while(ticks - ticks0 < n){
    80002c7a:	fcc42783          	lw	a5,-52(s0)
    80002c7e:	cf8d                	beqz	a5,80002cb8 <sys_sleep+0x6e>
    80002c80:	f426                	sd	s1,40(sp)
    80002c82:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c84:	00016997          	auipc	s3,0x16
    80002c88:	27c98993          	addi	s3,s3,636 # 80018f00 <tickslock>
    80002c8c:	00008497          	auipc	s1,0x8
    80002c90:	b1448493          	addi	s1,s1,-1260 # 8000a7a0 <ticks>
    if(killed(myproc())){
    80002c94:	c49fe0ef          	jal	800018dc <myproc>
    80002c98:	f9cff0ef          	jal	80002434 <killed>
    80002c9c:	ed0d                	bnez	a0,80002cd6 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002c9e:	85ce                	mv	a1,s3
    80002ca0:	8526                	mv	a0,s1
    80002ca2:	b8cff0ef          	jal	8000202e <sleep>
  while(ticks - ticks0 < n){
    80002ca6:	409c                	lw	a5,0(s1)
    80002ca8:	412787bb          	subw	a5,a5,s2
    80002cac:	fcc42703          	lw	a4,-52(s0)
    80002cb0:	fee7e2e3          	bltu	a5,a4,80002c94 <sys_sleep+0x4a>
    80002cb4:	74a2                	ld	s1,40(sp)
    80002cb6:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002cb8:	00016517          	auipc	a0,0x16
    80002cbc:	24850513          	addi	a0,a0,584 # 80018f00 <tickslock>
    80002cc0:	fd3fd0ef          	jal	80000c92 <release>
  return 0;
    80002cc4:	4501                	li	a0,0
}
    80002cc6:	70e2                	ld	ra,56(sp)
    80002cc8:	7442                	ld	s0,48(sp)
    80002cca:	7902                	ld	s2,32(sp)
    80002ccc:	6121                	addi	sp,sp,64
    80002cce:	8082                	ret
    n = 0;
    80002cd0:	fc042623          	sw	zero,-52(s0)
    80002cd4:	bf49                	j	80002c66 <sys_sleep+0x1c>
      release(&tickslock);
    80002cd6:	00016517          	auipc	a0,0x16
    80002cda:	22a50513          	addi	a0,a0,554 # 80018f00 <tickslock>
    80002cde:	fb5fd0ef          	jal	80000c92 <release>
      return -1;
    80002ce2:	557d                	li	a0,-1
    80002ce4:	74a2                	ld	s1,40(sp)
    80002ce6:	69e2                	ld	s3,24(sp)
    80002ce8:	bff9                	j	80002cc6 <sys_sleep+0x7c>

0000000080002cea <sys_kill>:

uint64
sys_kill(void)
{
    80002cea:	1101                	addi	sp,sp,-32
    80002cec:	ec06                	sd	ra,24(sp)
    80002cee:	e822                	sd	s0,16(sp)
    80002cf0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002cf2:	fec40593          	addi	a1,s0,-20
    80002cf6:	4501                	li	a0,0
    80002cf8:	de9ff0ef          	jal	80002ae0 <argint>
  return kill(pid);
    80002cfc:	fec42503          	lw	a0,-20(s0)
    80002d00:	eaaff0ef          	jal	800023aa <kill>
}
    80002d04:	60e2                	ld	ra,24(sp)
    80002d06:	6442                	ld	s0,16(sp)
    80002d08:	6105                	addi	sp,sp,32
    80002d0a:	8082                	ret

0000000080002d0c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d0c:	1101                	addi	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	e426                	sd	s1,8(sp)
    80002d14:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d16:	00016517          	auipc	a0,0x16
    80002d1a:	1ea50513          	addi	a0,a0,490 # 80018f00 <tickslock>
    80002d1e:	ee1fd0ef          	jal	80000bfe <acquire>
  xticks = ticks;
    80002d22:	00008497          	auipc	s1,0x8
    80002d26:	a7e4a483          	lw	s1,-1410(s1) # 8000a7a0 <ticks>
  release(&tickslock);
    80002d2a:	00016517          	auipc	a0,0x16
    80002d2e:	1d650513          	addi	a0,a0,470 # 80018f00 <tickslock>
    80002d32:	f61fd0ef          	jal	80000c92 <release>
  return xticks;
}
    80002d36:	02049513          	slli	a0,s1,0x20
    80002d3a:	9101                	srli	a0,a0,0x20
    80002d3c:	60e2                	ld	ra,24(sp)
    80002d3e:	6442                	ld	s0,16(sp)
    80002d40:	64a2                	ld	s1,8(sp)
    80002d42:	6105                	addi	sp,sp,32
    80002d44:	8082                	ret

0000000080002d46 <sys_kthread_create>:

uint64
sys_kthread_create(void)
{
    80002d46:	7179                	addi	sp,sp,-48
    80002d48:	f406                	sd	ra,40(sp)
    80002d4a:	f022                	sd	s0,32(sp)
    80002d4c:	1800                	addi	s0,sp,48
  uint64 start_func;
  uint64 stack;
  uint64 stack_size;
  argaddr(0, &start_func);
    80002d4e:	fe840593          	addi	a1,s0,-24
    80002d52:	4501                	li	a0,0
    80002d54:	da9ff0ef          	jal	80002afc <argaddr>
  argaddr(1, &stack);
    80002d58:	fe040593          	addi	a1,s0,-32
    80002d5c:	4505                	li	a0,1
    80002d5e:	d9fff0ef          	jal	80002afc <argaddr>
  argaddr(2, &stack_size);
    80002d62:	fd840593          	addi	a1,s0,-40
    80002d66:	4509                	li	a0,2
    80002d68:	d95ff0ef          	jal	80002afc <argaddr>
  // Comment out kthread_dbg calls to fix linker error
  // kthread_dbg("sys_kthread_create: start_func=%p, stack=%p, stack_size=%d\n", start_func, stack, stack_size);
  return kthread_create((void (*)())start_func, (void *)stack, stack_size);
    80002d6c:	fd843603          	ld	a2,-40(s0)
    80002d70:	fe043583          	ld	a1,-32(s0)
    80002d74:	fe843503          	ld	a0,-24(s0)
    80002d78:	fb7fe0ef          	jal	80001d2e <kthread_create>
}
    80002d7c:	70a2                	ld	ra,40(sp)
    80002d7e:	7402                	ld	s0,32(sp)
    80002d80:	6145                	addi	sp,sp,48
    80002d82:	8082                	ret

0000000080002d84 <sys_kthread_exit>:

uint64
sys_kthread_exit(void)
{
    80002d84:	1101                	addi	sp,sp,-32
    80002d86:	ec06                	sd	ra,24(sp)
    80002d88:	e822                	sd	s0,16(sp)
    80002d8a:	1000                	addi	s0,sp,32
  int status;
  argint(0, &status);
    80002d8c:	fec40593          	addi	a1,s0,-20
    80002d90:	4501                	li	a0,0
    80002d92:	d4fff0ef          	jal	80002ae0 <argint>
  // kthread_dbg("sys_kthread_exit: status=%d\n", status);
  kthread_exit(status);
    80002d96:	fec42503          	lw	a0,-20(s0)
    80002d9a:	caeff0ef          	jal	80002248 <kthread_exit>
  return 0; // not reached
}
    80002d9e:	4501                	li	a0,0
    80002da0:	60e2                	ld	ra,24(sp)
    80002da2:	6442                	ld	s0,16(sp)
    80002da4:	6105                	addi	sp,sp,32
    80002da6:	8082                	ret

0000000080002da8 <sys_kthread_join>:

uint64
sys_kthread_join(void)
{
    80002da8:	7139                	addi	sp,sp,-64
    80002daa:	fc06                	sd	ra,56(sp)
    80002dac:	f822                	sd	s0,48(sp)
    80002dae:	f426                	sd	s1,40(sp)
    80002db0:	0080                	addi	s0,sp,64
  int tid;
  uint64 status_addr;
  argint(0, &tid);
    80002db2:	fdc40593          	addi	a1,s0,-36
    80002db6:	4501                	li	a0,0
    80002db8:	d29ff0ef          	jal	80002ae0 <argint>
  argaddr(1, &status_addr);
    80002dbc:	fd040593          	addi	a1,s0,-48
    80002dc0:	4505                	li	a0,1
    80002dc2:	d3bff0ef          	jal	80002afc <argaddr>
  // kthread_dbg("sys_kthread_join: tid=%d, status_addr=%p\n", tid, status_addr);
  int status;
  int ret = kthread_join(tid, &status);
    80002dc6:	fcc40593          	addi	a1,s0,-52
    80002dca:	fdc42503          	lw	a0,-36(s0)
    80002dce:	aacff0ef          	jal	8000207a <kthread_join>
    80002dd2:	84aa                	mv	s1,a0
  if (ret == 0) {
    80002dd4:	c519                	beqz	a0,80002de2 <sys_kthread_join+0x3a>
    copyout(myproc()->pagetable, status_addr, (char *)&status, sizeof(int));
  }
  return ret;
}
    80002dd6:	8526                	mv	a0,s1
    80002dd8:	70e2                	ld	ra,56(sp)
    80002dda:	7442                	ld	s0,48(sp)
    80002ddc:	74a2                	ld	s1,40(sp)
    80002dde:	6121                	addi	sp,sp,64
    80002de0:	8082                	ret
    copyout(myproc()->pagetable, status_addr, (char *)&status, sizeof(int));
    80002de2:	afbfe0ef          	jal	800018dc <myproc>
    80002de6:	4691                	li	a3,4
    80002de8:	fcc40613          	addi	a2,s0,-52
    80002dec:	fd043583          	ld	a1,-48(s0)
    80002df0:	7928                	ld	a0,112(a0)
    80002df2:	f92fe0ef          	jal	80001584 <copyout>
    80002df6:	b7c5                	j	80002dd6 <sys_kthread_join+0x2e>

0000000080002df8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002df8:	7179                	addi	sp,sp,-48
    80002dfa:	f406                	sd	ra,40(sp)
    80002dfc:	f022                	sd	s0,32(sp)
    80002dfe:	ec26                	sd	s1,24(sp)
    80002e00:	e84a                	sd	s2,16(sp)
    80002e02:	e44e                	sd	s3,8(sp)
    80002e04:	e052                	sd	s4,0(sp)
    80002e06:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e08:	00005597          	auipc	a1,0x5
    80002e0c:	9c058593          	addi	a1,a1,-1600 # 800077c8 <etext+0x7c8>
    80002e10:	00016517          	auipc	a0,0x16
    80002e14:	10850513          	addi	a0,a0,264 # 80018f18 <bcache>
    80002e18:	d63fd0ef          	jal	80000b7a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e1c:	0001e797          	auipc	a5,0x1e
    80002e20:	0fc78793          	addi	a5,a5,252 # 80020f18 <bcache+0x8000>
    80002e24:	0001e717          	auipc	a4,0x1e
    80002e28:	35c70713          	addi	a4,a4,860 # 80021180 <bcache+0x8268>
    80002e2c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e30:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e34:	00016497          	auipc	s1,0x16
    80002e38:	0fc48493          	addi	s1,s1,252 # 80018f30 <bcache+0x18>
    b->next = bcache.head.next;
    80002e3c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e3e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e40:	00005a17          	auipc	s4,0x5
    80002e44:	990a0a13          	addi	s4,s4,-1648 # 800077d0 <etext+0x7d0>
    b->next = bcache.head.next;
    80002e48:	2b893783          	ld	a5,696(s2)
    80002e4c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e4e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e52:	85d2                	mv	a1,s4
    80002e54:	01048513          	addi	a0,s1,16
    80002e58:	244010ef          	jal	8000409c <initsleeplock>
    bcache.head.next->prev = b;
    80002e5c:	2b893783          	ld	a5,696(s2)
    80002e60:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002e62:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e66:	45848493          	addi	s1,s1,1112
    80002e6a:	fd349fe3          	bne	s1,s3,80002e48 <binit+0x50>
  }
}
    80002e6e:	70a2                	ld	ra,40(sp)
    80002e70:	7402                	ld	s0,32(sp)
    80002e72:	64e2                	ld	s1,24(sp)
    80002e74:	6942                	ld	s2,16(sp)
    80002e76:	69a2                	ld	s3,8(sp)
    80002e78:	6a02                	ld	s4,0(sp)
    80002e7a:	6145                	addi	sp,sp,48
    80002e7c:	8082                	ret

0000000080002e7e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002e7e:	7179                	addi	sp,sp,-48
    80002e80:	f406                	sd	ra,40(sp)
    80002e82:	f022                	sd	s0,32(sp)
    80002e84:	ec26                	sd	s1,24(sp)
    80002e86:	e84a                	sd	s2,16(sp)
    80002e88:	e44e                	sd	s3,8(sp)
    80002e8a:	1800                	addi	s0,sp,48
    80002e8c:	892a                	mv	s2,a0
    80002e8e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e90:	00016517          	auipc	a0,0x16
    80002e94:	08850513          	addi	a0,a0,136 # 80018f18 <bcache>
    80002e98:	d67fd0ef          	jal	80000bfe <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e9c:	0001e497          	auipc	s1,0x1e
    80002ea0:	3344b483          	ld	s1,820(s1) # 800211d0 <bcache+0x82b8>
    80002ea4:	0001e797          	auipc	a5,0x1e
    80002ea8:	2dc78793          	addi	a5,a5,732 # 80021180 <bcache+0x8268>
    80002eac:	02f48b63          	beq	s1,a5,80002ee2 <bread+0x64>
    80002eb0:	873e                	mv	a4,a5
    80002eb2:	a021                	j	80002eba <bread+0x3c>
    80002eb4:	68a4                	ld	s1,80(s1)
    80002eb6:	02e48663          	beq	s1,a4,80002ee2 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002eba:	449c                	lw	a5,8(s1)
    80002ebc:	ff279ce3          	bne	a5,s2,80002eb4 <bread+0x36>
    80002ec0:	44dc                	lw	a5,12(s1)
    80002ec2:	ff3799e3          	bne	a5,s3,80002eb4 <bread+0x36>
      b->refcnt++;
    80002ec6:	40bc                	lw	a5,64(s1)
    80002ec8:	2785                	addiw	a5,a5,1
    80002eca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ecc:	00016517          	auipc	a0,0x16
    80002ed0:	04c50513          	addi	a0,a0,76 # 80018f18 <bcache>
    80002ed4:	dbffd0ef          	jal	80000c92 <release>
      acquiresleep(&b->lock);
    80002ed8:	01048513          	addi	a0,s1,16
    80002edc:	1f6010ef          	jal	800040d2 <acquiresleep>
      return b;
    80002ee0:	a889                	j	80002f32 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ee2:	0001e497          	auipc	s1,0x1e
    80002ee6:	2e64b483          	ld	s1,742(s1) # 800211c8 <bcache+0x82b0>
    80002eea:	0001e797          	auipc	a5,0x1e
    80002eee:	29678793          	addi	a5,a5,662 # 80021180 <bcache+0x8268>
    80002ef2:	00f48863          	beq	s1,a5,80002f02 <bread+0x84>
    80002ef6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002ef8:	40bc                	lw	a5,64(s1)
    80002efa:	cb91                	beqz	a5,80002f0e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002efc:	64a4                	ld	s1,72(s1)
    80002efe:	fee49de3          	bne	s1,a4,80002ef8 <bread+0x7a>
  panic("bget: no buffers");
    80002f02:	00005517          	auipc	a0,0x5
    80002f06:	8d650513          	addi	a0,a0,-1834 # 800077d8 <etext+0x7d8>
    80002f0a:	895fd0ef          	jal	8000079e <panic>
      b->dev = dev;
    80002f0e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f12:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002f16:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f1a:	4785                	li	a5,1
    80002f1c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f1e:	00016517          	auipc	a0,0x16
    80002f22:	ffa50513          	addi	a0,a0,-6 # 80018f18 <bcache>
    80002f26:	d6dfd0ef          	jal	80000c92 <release>
      acquiresleep(&b->lock);
    80002f2a:	01048513          	addi	a0,s1,16
    80002f2e:	1a4010ef          	jal	800040d2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f32:	409c                	lw	a5,0(s1)
    80002f34:	cb89                	beqz	a5,80002f46 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f36:	8526                	mv	a0,s1
    80002f38:	70a2                	ld	ra,40(sp)
    80002f3a:	7402                	ld	s0,32(sp)
    80002f3c:	64e2                	ld	s1,24(sp)
    80002f3e:	6942                	ld	s2,16(sp)
    80002f40:	69a2                	ld	s3,8(sp)
    80002f42:	6145                	addi	sp,sp,48
    80002f44:	8082                	ret
    virtio_disk_rw(b, 0);
    80002f46:	4581                	li	a1,0
    80002f48:	8526                	mv	a0,s1
    80002f4a:	1f7020ef          	jal	80005940 <virtio_disk_rw>
    b->valid = 1;
    80002f4e:	4785                	li	a5,1
    80002f50:	c09c                	sw	a5,0(s1)
  return b;
    80002f52:	b7d5                	j	80002f36 <bread+0xb8>

0000000080002f54 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002f54:	1101                	addi	sp,sp,-32
    80002f56:	ec06                	sd	ra,24(sp)
    80002f58:	e822                	sd	s0,16(sp)
    80002f5a:	e426                	sd	s1,8(sp)
    80002f5c:	1000                	addi	s0,sp,32
    80002f5e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f60:	0541                	addi	a0,a0,16
    80002f62:	1ee010ef          	jal	80004150 <holdingsleep>
    80002f66:	c911                	beqz	a0,80002f7a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f68:	4585                	li	a1,1
    80002f6a:	8526                	mv	a0,s1
    80002f6c:	1d5020ef          	jal	80005940 <virtio_disk_rw>
}
    80002f70:	60e2                	ld	ra,24(sp)
    80002f72:	6442                	ld	s0,16(sp)
    80002f74:	64a2                	ld	s1,8(sp)
    80002f76:	6105                	addi	sp,sp,32
    80002f78:	8082                	ret
    panic("bwrite");
    80002f7a:	00005517          	auipc	a0,0x5
    80002f7e:	87650513          	addi	a0,a0,-1930 # 800077f0 <etext+0x7f0>
    80002f82:	81dfd0ef          	jal	8000079e <panic>

0000000080002f86 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f86:	1101                	addi	sp,sp,-32
    80002f88:	ec06                	sd	ra,24(sp)
    80002f8a:	e822                	sd	s0,16(sp)
    80002f8c:	e426                	sd	s1,8(sp)
    80002f8e:	e04a                	sd	s2,0(sp)
    80002f90:	1000                	addi	s0,sp,32
    80002f92:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f94:	01050913          	addi	s2,a0,16
    80002f98:	854a                	mv	a0,s2
    80002f9a:	1b6010ef          	jal	80004150 <holdingsleep>
    80002f9e:	c125                	beqz	a0,80002ffe <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002fa0:	854a                	mv	a0,s2
    80002fa2:	176010ef          	jal	80004118 <releasesleep>

  acquire(&bcache.lock);
    80002fa6:	00016517          	auipc	a0,0x16
    80002faa:	f7250513          	addi	a0,a0,-142 # 80018f18 <bcache>
    80002fae:	c51fd0ef          	jal	80000bfe <acquire>
  b->refcnt--;
    80002fb2:	40bc                	lw	a5,64(s1)
    80002fb4:	37fd                	addiw	a5,a5,-1
    80002fb6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002fb8:	e79d                	bnez	a5,80002fe6 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002fba:	68b8                	ld	a4,80(s1)
    80002fbc:	64bc                	ld	a5,72(s1)
    80002fbe:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002fc0:	68b8                	ld	a4,80(s1)
    80002fc2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002fc4:	0001e797          	auipc	a5,0x1e
    80002fc8:	f5478793          	addi	a5,a5,-172 # 80020f18 <bcache+0x8000>
    80002fcc:	2b87b703          	ld	a4,696(a5)
    80002fd0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002fd2:	0001e717          	auipc	a4,0x1e
    80002fd6:	1ae70713          	addi	a4,a4,430 # 80021180 <bcache+0x8268>
    80002fda:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002fdc:	2b87b703          	ld	a4,696(a5)
    80002fe0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002fe2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002fe6:	00016517          	auipc	a0,0x16
    80002fea:	f3250513          	addi	a0,a0,-206 # 80018f18 <bcache>
    80002fee:	ca5fd0ef          	jal	80000c92 <release>
}
    80002ff2:	60e2                	ld	ra,24(sp)
    80002ff4:	6442                	ld	s0,16(sp)
    80002ff6:	64a2                	ld	s1,8(sp)
    80002ff8:	6902                	ld	s2,0(sp)
    80002ffa:	6105                	addi	sp,sp,32
    80002ffc:	8082                	ret
    panic("brelse");
    80002ffe:	00004517          	auipc	a0,0x4
    80003002:	7fa50513          	addi	a0,a0,2042 # 800077f8 <etext+0x7f8>
    80003006:	f98fd0ef          	jal	8000079e <panic>

000000008000300a <bpin>:

void
bpin(struct buf *b) {
    8000300a:	1101                	addi	sp,sp,-32
    8000300c:	ec06                	sd	ra,24(sp)
    8000300e:	e822                	sd	s0,16(sp)
    80003010:	e426                	sd	s1,8(sp)
    80003012:	1000                	addi	s0,sp,32
    80003014:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003016:	00016517          	auipc	a0,0x16
    8000301a:	f0250513          	addi	a0,a0,-254 # 80018f18 <bcache>
    8000301e:	be1fd0ef          	jal	80000bfe <acquire>
  b->refcnt++;
    80003022:	40bc                	lw	a5,64(s1)
    80003024:	2785                	addiw	a5,a5,1
    80003026:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003028:	00016517          	auipc	a0,0x16
    8000302c:	ef050513          	addi	a0,a0,-272 # 80018f18 <bcache>
    80003030:	c63fd0ef          	jal	80000c92 <release>
}
    80003034:	60e2                	ld	ra,24(sp)
    80003036:	6442                	ld	s0,16(sp)
    80003038:	64a2                	ld	s1,8(sp)
    8000303a:	6105                	addi	sp,sp,32
    8000303c:	8082                	ret

000000008000303e <bunpin>:

void
bunpin(struct buf *b) {
    8000303e:	1101                	addi	sp,sp,-32
    80003040:	ec06                	sd	ra,24(sp)
    80003042:	e822                	sd	s0,16(sp)
    80003044:	e426                	sd	s1,8(sp)
    80003046:	1000                	addi	s0,sp,32
    80003048:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000304a:	00016517          	auipc	a0,0x16
    8000304e:	ece50513          	addi	a0,a0,-306 # 80018f18 <bcache>
    80003052:	badfd0ef          	jal	80000bfe <acquire>
  b->refcnt--;
    80003056:	40bc                	lw	a5,64(s1)
    80003058:	37fd                	addiw	a5,a5,-1
    8000305a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000305c:	00016517          	auipc	a0,0x16
    80003060:	ebc50513          	addi	a0,a0,-324 # 80018f18 <bcache>
    80003064:	c2ffd0ef          	jal	80000c92 <release>
}
    80003068:	60e2                	ld	ra,24(sp)
    8000306a:	6442                	ld	s0,16(sp)
    8000306c:	64a2                	ld	s1,8(sp)
    8000306e:	6105                	addi	sp,sp,32
    80003070:	8082                	ret

0000000080003072 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003072:	1101                	addi	sp,sp,-32
    80003074:	ec06                	sd	ra,24(sp)
    80003076:	e822                	sd	s0,16(sp)
    80003078:	e426                	sd	s1,8(sp)
    8000307a:	e04a                	sd	s2,0(sp)
    8000307c:	1000                	addi	s0,sp,32
    8000307e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003080:	00d5d79b          	srliw	a5,a1,0xd
    80003084:	0001e597          	auipc	a1,0x1e
    80003088:	5705a583          	lw	a1,1392(a1) # 800215f4 <sb+0x1c>
    8000308c:	9dbd                	addw	a1,a1,a5
    8000308e:	df1ff0ef          	jal	80002e7e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003092:	0074f713          	andi	a4,s1,7
    80003096:	4785                	li	a5,1
    80003098:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000309c:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000309e:	90d9                	srli	s1,s1,0x36
    800030a0:	00950733          	add	a4,a0,s1
    800030a4:	05874703          	lbu	a4,88(a4)
    800030a8:	00e7f6b3          	and	a3,a5,a4
    800030ac:	c29d                	beqz	a3,800030d2 <bfree+0x60>
    800030ae:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800030b0:	94aa                	add	s1,s1,a0
    800030b2:	fff7c793          	not	a5,a5
    800030b6:	8f7d                	and	a4,a4,a5
    800030b8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800030bc:	711000ef          	jal	80003fcc <log_write>
  brelse(bp);
    800030c0:	854a                	mv	a0,s2
    800030c2:	ec5ff0ef          	jal	80002f86 <brelse>
}
    800030c6:	60e2                	ld	ra,24(sp)
    800030c8:	6442                	ld	s0,16(sp)
    800030ca:	64a2                	ld	s1,8(sp)
    800030cc:	6902                	ld	s2,0(sp)
    800030ce:	6105                	addi	sp,sp,32
    800030d0:	8082                	ret
    panic("freeing free block");
    800030d2:	00004517          	auipc	a0,0x4
    800030d6:	72e50513          	addi	a0,a0,1838 # 80007800 <etext+0x800>
    800030da:	ec4fd0ef          	jal	8000079e <panic>

00000000800030de <balloc>:
{
    800030de:	715d                	addi	sp,sp,-80
    800030e0:	e486                	sd	ra,72(sp)
    800030e2:	e0a2                	sd	s0,64(sp)
    800030e4:	fc26                	sd	s1,56(sp)
    800030e6:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800030e8:	0001e797          	auipc	a5,0x1e
    800030ec:	4f47a783          	lw	a5,1268(a5) # 800215dc <sb+0x4>
    800030f0:	0e078863          	beqz	a5,800031e0 <balloc+0x102>
    800030f4:	f84a                	sd	s2,48(sp)
    800030f6:	f44e                	sd	s3,40(sp)
    800030f8:	f052                	sd	s4,32(sp)
    800030fa:	ec56                	sd	s5,24(sp)
    800030fc:	e85a                	sd	s6,16(sp)
    800030fe:	e45e                	sd	s7,8(sp)
    80003100:	e062                	sd	s8,0(sp)
    80003102:	8baa                	mv	s7,a0
    80003104:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003106:	0001eb17          	auipc	s6,0x1e
    8000310a:	4d2b0b13          	addi	s6,s6,1234 # 800215d8 <sb>
      m = 1 << (bi % 8);
    8000310e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003110:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003112:	6c09                	lui	s8,0x2
    80003114:	a09d                	j	8000317a <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003116:	97ca                	add	a5,a5,s2
    80003118:	8e55                	or	a2,a2,a3
    8000311a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000311e:	854a                	mv	a0,s2
    80003120:	6ad000ef          	jal	80003fcc <log_write>
        brelse(bp);
    80003124:	854a                	mv	a0,s2
    80003126:	e61ff0ef          	jal	80002f86 <brelse>
  bp = bread(dev, bno);
    8000312a:	85a6                	mv	a1,s1
    8000312c:	855e                	mv	a0,s7
    8000312e:	d51ff0ef          	jal	80002e7e <bread>
    80003132:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003134:	40000613          	li	a2,1024
    80003138:	4581                	li	a1,0
    8000313a:	05850513          	addi	a0,a0,88
    8000313e:	b91fd0ef          	jal	80000cce <memset>
  log_write(bp);
    80003142:	854a                	mv	a0,s2
    80003144:	689000ef          	jal	80003fcc <log_write>
  brelse(bp);
    80003148:	854a                	mv	a0,s2
    8000314a:	e3dff0ef          	jal	80002f86 <brelse>
}
    8000314e:	7942                	ld	s2,48(sp)
    80003150:	79a2                	ld	s3,40(sp)
    80003152:	7a02                	ld	s4,32(sp)
    80003154:	6ae2                	ld	s5,24(sp)
    80003156:	6b42                	ld	s6,16(sp)
    80003158:	6ba2                	ld	s7,8(sp)
    8000315a:	6c02                	ld	s8,0(sp)
}
    8000315c:	8526                	mv	a0,s1
    8000315e:	60a6                	ld	ra,72(sp)
    80003160:	6406                	ld	s0,64(sp)
    80003162:	74e2                	ld	s1,56(sp)
    80003164:	6161                	addi	sp,sp,80
    80003166:	8082                	ret
    brelse(bp);
    80003168:	854a                	mv	a0,s2
    8000316a:	e1dff0ef          	jal	80002f86 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000316e:	015c0abb          	addw	s5,s8,s5
    80003172:	004b2783          	lw	a5,4(s6)
    80003176:	04fafe63          	bgeu	s5,a5,800031d2 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    8000317a:	41fad79b          	sraiw	a5,s5,0x1f
    8000317e:	0137d79b          	srliw	a5,a5,0x13
    80003182:	015787bb          	addw	a5,a5,s5
    80003186:	40d7d79b          	sraiw	a5,a5,0xd
    8000318a:	01cb2583          	lw	a1,28(s6)
    8000318e:	9dbd                	addw	a1,a1,a5
    80003190:	855e                	mv	a0,s7
    80003192:	cedff0ef          	jal	80002e7e <bread>
    80003196:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003198:	004b2503          	lw	a0,4(s6)
    8000319c:	84d6                	mv	s1,s5
    8000319e:	4701                	li	a4,0
    800031a0:	fca4f4e3          	bgeu	s1,a0,80003168 <balloc+0x8a>
      m = 1 << (bi % 8);
    800031a4:	00777693          	andi	a3,a4,7
    800031a8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800031ac:	41f7579b          	sraiw	a5,a4,0x1f
    800031b0:	01d7d79b          	srliw	a5,a5,0x1d
    800031b4:	9fb9                	addw	a5,a5,a4
    800031b6:	4037d79b          	sraiw	a5,a5,0x3
    800031ba:	00f90633          	add	a2,s2,a5
    800031be:	05864603          	lbu	a2,88(a2)
    800031c2:	00c6f5b3          	and	a1,a3,a2
    800031c6:	d9a1                	beqz	a1,80003116 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031c8:	2705                	addiw	a4,a4,1
    800031ca:	2485                	addiw	s1,s1,1
    800031cc:	fd471ae3          	bne	a4,s4,800031a0 <balloc+0xc2>
    800031d0:	bf61                	j	80003168 <balloc+0x8a>
    800031d2:	7942                	ld	s2,48(sp)
    800031d4:	79a2                	ld	s3,40(sp)
    800031d6:	7a02                	ld	s4,32(sp)
    800031d8:	6ae2                	ld	s5,24(sp)
    800031da:	6b42                	ld	s6,16(sp)
    800031dc:	6ba2                	ld	s7,8(sp)
    800031de:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800031e0:	00004517          	auipc	a0,0x4
    800031e4:	63850513          	addi	a0,a0,1592 # 80007818 <etext+0x818>
    800031e8:	ae6fd0ef          	jal	800004ce <printf>
  return 0;
    800031ec:	4481                	li	s1,0
    800031ee:	b7bd                	j	8000315c <balloc+0x7e>

00000000800031f0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800031f0:	7179                	addi	sp,sp,-48
    800031f2:	f406                	sd	ra,40(sp)
    800031f4:	f022                	sd	s0,32(sp)
    800031f6:	ec26                	sd	s1,24(sp)
    800031f8:	e84a                	sd	s2,16(sp)
    800031fa:	e44e                	sd	s3,8(sp)
    800031fc:	1800                	addi	s0,sp,48
    800031fe:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003200:	47ad                	li	a5,11
    80003202:	02b7e363          	bltu	a5,a1,80003228 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003206:	02059793          	slli	a5,a1,0x20
    8000320a:	01e7d593          	srli	a1,a5,0x1e
    8000320e:	00b504b3          	add	s1,a0,a1
    80003212:	0504a903          	lw	s2,80(s1)
    80003216:	06091363          	bnez	s2,8000327c <bmap+0x8c>
      addr = balloc(ip->dev);
    8000321a:	4108                	lw	a0,0(a0)
    8000321c:	ec3ff0ef          	jal	800030de <balloc>
    80003220:	892a                	mv	s2,a0
      if(addr == 0)
    80003222:	cd29                	beqz	a0,8000327c <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    80003224:	c8a8                	sw	a0,80(s1)
    80003226:	a899                	j	8000327c <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003228:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    8000322c:	0ff00793          	li	a5,255
    80003230:	0697e963          	bltu	a5,s1,800032a2 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003234:	08052903          	lw	s2,128(a0)
    80003238:	00091b63          	bnez	s2,8000324e <bmap+0x5e>
      addr = balloc(ip->dev);
    8000323c:	4108                	lw	a0,0(a0)
    8000323e:	ea1ff0ef          	jal	800030de <balloc>
    80003242:	892a                	mv	s2,a0
      if(addr == 0)
    80003244:	cd05                	beqz	a0,8000327c <bmap+0x8c>
    80003246:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003248:	08a9a023          	sw	a0,128(s3)
    8000324c:	a011                	j	80003250 <bmap+0x60>
    8000324e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003250:	85ca                	mv	a1,s2
    80003252:	0009a503          	lw	a0,0(s3)
    80003256:	c29ff0ef          	jal	80002e7e <bread>
    8000325a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000325c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003260:	02049713          	slli	a4,s1,0x20
    80003264:	01e75593          	srli	a1,a4,0x1e
    80003268:	00b784b3          	add	s1,a5,a1
    8000326c:	0004a903          	lw	s2,0(s1)
    80003270:	00090e63          	beqz	s2,8000328c <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003274:	8552                	mv	a0,s4
    80003276:	d11ff0ef          	jal	80002f86 <brelse>
    return addr;
    8000327a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000327c:	854a                	mv	a0,s2
    8000327e:	70a2                	ld	ra,40(sp)
    80003280:	7402                	ld	s0,32(sp)
    80003282:	64e2                	ld	s1,24(sp)
    80003284:	6942                	ld	s2,16(sp)
    80003286:	69a2                	ld	s3,8(sp)
    80003288:	6145                	addi	sp,sp,48
    8000328a:	8082                	ret
      addr = balloc(ip->dev);
    8000328c:	0009a503          	lw	a0,0(s3)
    80003290:	e4fff0ef          	jal	800030de <balloc>
    80003294:	892a                	mv	s2,a0
      if(addr){
    80003296:	dd79                	beqz	a0,80003274 <bmap+0x84>
        a[bn] = addr;
    80003298:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000329a:	8552                	mv	a0,s4
    8000329c:	531000ef          	jal	80003fcc <log_write>
    800032a0:	bfd1                	j	80003274 <bmap+0x84>
    800032a2:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800032a4:	00004517          	auipc	a0,0x4
    800032a8:	58c50513          	addi	a0,a0,1420 # 80007830 <etext+0x830>
    800032ac:	cf2fd0ef          	jal	8000079e <panic>

00000000800032b0 <iget>:
{
    800032b0:	7179                	addi	sp,sp,-48
    800032b2:	f406                	sd	ra,40(sp)
    800032b4:	f022                	sd	s0,32(sp)
    800032b6:	ec26                	sd	s1,24(sp)
    800032b8:	e84a                	sd	s2,16(sp)
    800032ba:	e44e                	sd	s3,8(sp)
    800032bc:	e052                	sd	s4,0(sp)
    800032be:	1800                	addi	s0,sp,48
    800032c0:	89aa                	mv	s3,a0
    800032c2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800032c4:	0001e517          	auipc	a0,0x1e
    800032c8:	33450513          	addi	a0,a0,820 # 800215f8 <itable>
    800032cc:	933fd0ef          	jal	80000bfe <acquire>
  empty = 0;
    800032d0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800032d2:	0001e497          	auipc	s1,0x1e
    800032d6:	33e48493          	addi	s1,s1,830 # 80021610 <itable+0x18>
    800032da:	00020697          	auipc	a3,0x20
    800032de:	dc668693          	addi	a3,a3,-570 # 800230a0 <log>
    800032e2:	a039                	j	800032f0 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032e4:	02090963          	beqz	s2,80003316 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800032e8:	08848493          	addi	s1,s1,136
    800032ec:	02d48863          	beq	s1,a3,8000331c <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800032f0:	449c                	lw	a5,8(s1)
    800032f2:	fef059e3          	blez	a5,800032e4 <iget+0x34>
    800032f6:	4098                	lw	a4,0(s1)
    800032f8:	ff3716e3          	bne	a4,s3,800032e4 <iget+0x34>
    800032fc:	40d8                	lw	a4,4(s1)
    800032fe:	ff4713e3          	bne	a4,s4,800032e4 <iget+0x34>
      ip->ref++;
    80003302:	2785                	addiw	a5,a5,1
    80003304:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003306:	0001e517          	auipc	a0,0x1e
    8000330a:	2f250513          	addi	a0,a0,754 # 800215f8 <itable>
    8000330e:	985fd0ef          	jal	80000c92 <release>
      return ip;
    80003312:	8926                	mv	s2,s1
    80003314:	a02d                	j	8000333e <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003316:	fbe9                	bnez	a5,800032e8 <iget+0x38>
      empty = ip;
    80003318:	8926                	mv	s2,s1
    8000331a:	b7f9                	j	800032e8 <iget+0x38>
  if(empty == 0)
    8000331c:	02090a63          	beqz	s2,80003350 <iget+0xa0>
  ip->dev = dev;
    80003320:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003324:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003328:	4785                	li	a5,1
    8000332a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000332e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003332:	0001e517          	auipc	a0,0x1e
    80003336:	2c650513          	addi	a0,a0,710 # 800215f8 <itable>
    8000333a:	959fd0ef          	jal	80000c92 <release>
}
    8000333e:	854a                	mv	a0,s2
    80003340:	70a2                	ld	ra,40(sp)
    80003342:	7402                	ld	s0,32(sp)
    80003344:	64e2                	ld	s1,24(sp)
    80003346:	6942                	ld	s2,16(sp)
    80003348:	69a2                	ld	s3,8(sp)
    8000334a:	6a02                	ld	s4,0(sp)
    8000334c:	6145                	addi	sp,sp,48
    8000334e:	8082                	ret
    panic("iget: no inodes");
    80003350:	00004517          	auipc	a0,0x4
    80003354:	4f850513          	addi	a0,a0,1272 # 80007848 <etext+0x848>
    80003358:	c46fd0ef          	jal	8000079e <panic>

000000008000335c <fsinit>:
fsinit(int dev) {
    8000335c:	7179                	addi	sp,sp,-48
    8000335e:	f406                	sd	ra,40(sp)
    80003360:	f022                	sd	s0,32(sp)
    80003362:	ec26                	sd	s1,24(sp)
    80003364:	e84a                	sd	s2,16(sp)
    80003366:	e44e                	sd	s3,8(sp)
    80003368:	1800                	addi	s0,sp,48
    8000336a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000336c:	4585                	li	a1,1
    8000336e:	b11ff0ef          	jal	80002e7e <bread>
    80003372:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003374:	0001e997          	auipc	s3,0x1e
    80003378:	26498993          	addi	s3,s3,612 # 800215d8 <sb>
    8000337c:	02000613          	li	a2,32
    80003380:	05850593          	addi	a1,a0,88
    80003384:	854e                	mv	a0,s3
    80003386:	9adfd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    8000338a:	8526                	mv	a0,s1
    8000338c:	bfbff0ef          	jal	80002f86 <brelse>
  if(sb.magic != FSMAGIC)
    80003390:	0009a703          	lw	a4,0(s3)
    80003394:	102037b7          	lui	a5,0x10203
    80003398:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000339c:	02f71063          	bne	a4,a5,800033bc <fsinit+0x60>
  initlog(dev, &sb);
    800033a0:	0001e597          	auipc	a1,0x1e
    800033a4:	23858593          	addi	a1,a1,568 # 800215d8 <sb>
    800033a8:	854a                	mv	a0,s2
    800033aa:	215000ef          	jal	80003dbe <initlog>
}
    800033ae:	70a2                	ld	ra,40(sp)
    800033b0:	7402                	ld	s0,32(sp)
    800033b2:	64e2                	ld	s1,24(sp)
    800033b4:	6942                	ld	s2,16(sp)
    800033b6:	69a2                	ld	s3,8(sp)
    800033b8:	6145                	addi	sp,sp,48
    800033ba:	8082                	ret
    panic("invalid file system");
    800033bc:	00004517          	auipc	a0,0x4
    800033c0:	49c50513          	addi	a0,a0,1180 # 80007858 <etext+0x858>
    800033c4:	bdafd0ef          	jal	8000079e <panic>

00000000800033c8 <iinit>:
{
    800033c8:	7179                	addi	sp,sp,-48
    800033ca:	f406                	sd	ra,40(sp)
    800033cc:	f022                	sd	s0,32(sp)
    800033ce:	ec26                	sd	s1,24(sp)
    800033d0:	e84a                	sd	s2,16(sp)
    800033d2:	e44e                	sd	s3,8(sp)
    800033d4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800033d6:	00004597          	auipc	a1,0x4
    800033da:	49a58593          	addi	a1,a1,1178 # 80007870 <etext+0x870>
    800033de:	0001e517          	auipc	a0,0x1e
    800033e2:	21a50513          	addi	a0,a0,538 # 800215f8 <itable>
    800033e6:	f94fd0ef          	jal	80000b7a <initlock>
  for(i = 0; i < NINODE; i++) {
    800033ea:	0001e497          	auipc	s1,0x1e
    800033ee:	23648493          	addi	s1,s1,566 # 80021620 <itable+0x28>
    800033f2:	00020997          	auipc	s3,0x20
    800033f6:	cbe98993          	addi	s3,s3,-834 # 800230b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800033fa:	00004917          	auipc	s2,0x4
    800033fe:	47e90913          	addi	s2,s2,1150 # 80007878 <etext+0x878>
    80003402:	85ca                	mv	a1,s2
    80003404:	8526                	mv	a0,s1
    80003406:	497000ef          	jal	8000409c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000340a:	08848493          	addi	s1,s1,136
    8000340e:	ff349ae3          	bne	s1,s3,80003402 <iinit+0x3a>
}
    80003412:	70a2                	ld	ra,40(sp)
    80003414:	7402                	ld	s0,32(sp)
    80003416:	64e2                	ld	s1,24(sp)
    80003418:	6942                	ld	s2,16(sp)
    8000341a:	69a2                	ld	s3,8(sp)
    8000341c:	6145                	addi	sp,sp,48
    8000341e:	8082                	ret

0000000080003420 <ialloc>:
{
    80003420:	7139                	addi	sp,sp,-64
    80003422:	fc06                	sd	ra,56(sp)
    80003424:	f822                	sd	s0,48(sp)
    80003426:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003428:	0001e717          	auipc	a4,0x1e
    8000342c:	1bc72703          	lw	a4,444(a4) # 800215e4 <sb+0xc>
    80003430:	4785                	li	a5,1
    80003432:	06e7f063          	bgeu	a5,a4,80003492 <ialloc+0x72>
    80003436:	f426                	sd	s1,40(sp)
    80003438:	f04a                	sd	s2,32(sp)
    8000343a:	ec4e                	sd	s3,24(sp)
    8000343c:	e852                	sd	s4,16(sp)
    8000343e:	e456                	sd	s5,8(sp)
    80003440:	e05a                	sd	s6,0(sp)
    80003442:	8aaa                	mv	s5,a0
    80003444:	8b2e                	mv	s6,a1
    80003446:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003448:	0001ea17          	auipc	s4,0x1e
    8000344c:	190a0a13          	addi	s4,s4,400 # 800215d8 <sb>
    80003450:	00495593          	srli	a1,s2,0x4
    80003454:	018a2783          	lw	a5,24(s4)
    80003458:	9dbd                	addw	a1,a1,a5
    8000345a:	8556                	mv	a0,s5
    8000345c:	a23ff0ef          	jal	80002e7e <bread>
    80003460:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003462:	05850993          	addi	s3,a0,88
    80003466:	00f97793          	andi	a5,s2,15
    8000346a:	079a                	slli	a5,a5,0x6
    8000346c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000346e:	00099783          	lh	a5,0(s3)
    80003472:	cb9d                	beqz	a5,800034a8 <ialloc+0x88>
    brelse(bp);
    80003474:	b13ff0ef          	jal	80002f86 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003478:	0905                	addi	s2,s2,1
    8000347a:	00ca2703          	lw	a4,12(s4)
    8000347e:	0009079b          	sext.w	a5,s2
    80003482:	fce7e7e3          	bltu	a5,a4,80003450 <ialloc+0x30>
    80003486:	74a2                	ld	s1,40(sp)
    80003488:	7902                	ld	s2,32(sp)
    8000348a:	69e2                	ld	s3,24(sp)
    8000348c:	6a42                	ld	s4,16(sp)
    8000348e:	6aa2                	ld	s5,8(sp)
    80003490:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003492:	00004517          	auipc	a0,0x4
    80003496:	3ee50513          	addi	a0,a0,1006 # 80007880 <etext+0x880>
    8000349a:	834fd0ef          	jal	800004ce <printf>
  return 0;
    8000349e:	4501                	li	a0,0
}
    800034a0:	70e2                	ld	ra,56(sp)
    800034a2:	7442                	ld	s0,48(sp)
    800034a4:	6121                	addi	sp,sp,64
    800034a6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800034a8:	04000613          	li	a2,64
    800034ac:	4581                	li	a1,0
    800034ae:	854e                	mv	a0,s3
    800034b0:	81ffd0ef          	jal	80000cce <memset>
      dip->type = type;
    800034b4:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800034b8:	8526                	mv	a0,s1
    800034ba:	313000ef          	jal	80003fcc <log_write>
      brelse(bp);
    800034be:	8526                	mv	a0,s1
    800034c0:	ac7ff0ef          	jal	80002f86 <brelse>
      return iget(dev, inum);
    800034c4:	0009059b          	sext.w	a1,s2
    800034c8:	8556                	mv	a0,s5
    800034ca:	de7ff0ef          	jal	800032b0 <iget>
    800034ce:	74a2                	ld	s1,40(sp)
    800034d0:	7902                	ld	s2,32(sp)
    800034d2:	69e2                	ld	s3,24(sp)
    800034d4:	6a42                	ld	s4,16(sp)
    800034d6:	6aa2                	ld	s5,8(sp)
    800034d8:	6b02                	ld	s6,0(sp)
    800034da:	b7d9                	j	800034a0 <ialloc+0x80>

00000000800034dc <iupdate>:
{
    800034dc:	1101                	addi	sp,sp,-32
    800034de:	ec06                	sd	ra,24(sp)
    800034e0:	e822                	sd	s0,16(sp)
    800034e2:	e426                	sd	s1,8(sp)
    800034e4:	e04a                	sd	s2,0(sp)
    800034e6:	1000                	addi	s0,sp,32
    800034e8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800034ea:	415c                	lw	a5,4(a0)
    800034ec:	0047d79b          	srliw	a5,a5,0x4
    800034f0:	0001e597          	auipc	a1,0x1e
    800034f4:	1005a583          	lw	a1,256(a1) # 800215f0 <sb+0x18>
    800034f8:	9dbd                	addw	a1,a1,a5
    800034fa:	4108                	lw	a0,0(a0)
    800034fc:	983ff0ef          	jal	80002e7e <bread>
    80003500:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003502:	05850793          	addi	a5,a0,88
    80003506:	40d8                	lw	a4,4(s1)
    80003508:	8b3d                	andi	a4,a4,15
    8000350a:	071a                	slli	a4,a4,0x6
    8000350c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000350e:	04449703          	lh	a4,68(s1)
    80003512:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003516:	04649703          	lh	a4,70(s1)
    8000351a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000351e:	04849703          	lh	a4,72(s1)
    80003522:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003526:	04a49703          	lh	a4,74(s1)
    8000352a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000352e:	44f8                	lw	a4,76(s1)
    80003530:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003532:	03400613          	li	a2,52
    80003536:	05048593          	addi	a1,s1,80
    8000353a:	00c78513          	addi	a0,a5,12
    8000353e:	ff4fd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    80003542:	854a                	mv	a0,s2
    80003544:	289000ef          	jal	80003fcc <log_write>
  brelse(bp);
    80003548:	854a                	mv	a0,s2
    8000354a:	a3dff0ef          	jal	80002f86 <brelse>
}
    8000354e:	60e2                	ld	ra,24(sp)
    80003550:	6442                	ld	s0,16(sp)
    80003552:	64a2                	ld	s1,8(sp)
    80003554:	6902                	ld	s2,0(sp)
    80003556:	6105                	addi	sp,sp,32
    80003558:	8082                	ret

000000008000355a <idup>:
{
    8000355a:	1101                	addi	sp,sp,-32
    8000355c:	ec06                	sd	ra,24(sp)
    8000355e:	e822                	sd	s0,16(sp)
    80003560:	e426                	sd	s1,8(sp)
    80003562:	1000                	addi	s0,sp,32
    80003564:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003566:	0001e517          	auipc	a0,0x1e
    8000356a:	09250513          	addi	a0,a0,146 # 800215f8 <itable>
    8000356e:	e90fd0ef          	jal	80000bfe <acquire>
  ip->ref++;
    80003572:	449c                	lw	a5,8(s1)
    80003574:	2785                	addiw	a5,a5,1
    80003576:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003578:	0001e517          	auipc	a0,0x1e
    8000357c:	08050513          	addi	a0,a0,128 # 800215f8 <itable>
    80003580:	f12fd0ef          	jal	80000c92 <release>
}
    80003584:	8526                	mv	a0,s1
    80003586:	60e2                	ld	ra,24(sp)
    80003588:	6442                	ld	s0,16(sp)
    8000358a:	64a2                	ld	s1,8(sp)
    8000358c:	6105                	addi	sp,sp,32
    8000358e:	8082                	ret

0000000080003590 <ilock>:
{
    80003590:	1101                	addi	sp,sp,-32
    80003592:	ec06                	sd	ra,24(sp)
    80003594:	e822                	sd	s0,16(sp)
    80003596:	e426                	sd	s1,8(sp)
    80003598:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000359a:	cd19                	beqz	a0,800035b8 <ilock+0x28>
    8000359c:	84aa                	mv	s1,a0
    8000359e:	451c                	lw	a5,8(a0)
    800035a0:	00f05c63          	blez	a5,800035b8 <ilock+0x28>
  acquiresleep(&ip->lock);
    800035a4:	0541                	addi	a0,a0,16
    800035a6:	32d000ef          	jal	800040d2 <acquiresleep>
  if(ip->valid == 0){
    800035aa:	40bc                	lw	a5,64(s1)
    800035ac:	cf89                	beqz	a5,800035c6 <ilock+0x36>
}
    800035ae:	60e2                	ld	ra,24(sp)
    800035b0:	6442                	ld	s0,16(sp)
    800035b2:	64a2                	ld	s1,8(sp)
    800035b4:	6105                	addi	sp,sp,32
    800035b6:	8082                	ret
    800035b8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800035ba:	00004517          	auipc	a0,0x4
    800035be:	2de50513          	addi	a0,a0,734 # 80007898 <etext+0x898>
    800035c2:	9dcfd0ef          	jal	8000079e <panic>
    800035c6:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800035c8:	40dc                	lw	a5,4(s1)
    800035ca:	0047d79b          	srliw	a5,a5,0x4
    800035ce:	0001e597          	auipc	a1,0x1e
    800035d2:	0225a583          	lw	a1,34(a1) # 800215f0 <sb+0x18>
    800035d6:	9dbd                	addw	a1,a1,a5
    800035d8:	4088                	lw	a0,0(s1)
    800035da:	8a5ff0ef          	jal	80002e7e <bread>
    800035de:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800035e0:	05850593          	addi	a1,a0,88
    800035e4:	40dc                	lw	a5,4(s1)
    800035e6:	8bbd                	andi	a5,a5,15
    800035e8:	079a                	slli	a5,a5,0x6
    800035ea:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800035ec:	00059783          	lh	a5,0(a1)
    800035f0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800035f4:	00259783          	lh	a5,2(a1)
    800035f8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800035fc:	00459783          	lh	a5,4(a1)
    80003600:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003604:	00659783          	lh	a5,6(a1)
    80003608:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000360c:	459c                	lw	a5,8(a1)
    8000360e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003610:	03400613          	li	a2,52
    80003614:	05b1                	addi	a1,a1,12
    80003616:	05048513          	addi	a0,s1,80
    8000361a:	f18fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    8000361e:	854a                	mv	a0,s2
    80003620:	967ff0ef          	jal	80002f86 <brelse>
    ip->valid = 1;
    80003624:	4785                	li	a5,1
    80003626:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003628:	04449783          	lh	a5,68(s1)
    8000362c:	c399                	beqz	a5,80003632 <ilock+0xa2>
    8000362e:	6902                	ld	s2,0(sp)
    80003630:	bfbd                	j	800035ae <ilock+0x1e>
      panic("ilock: no type");
    80003632:	00004517          	auipc	a0,0x4
    80003636:	26e50513          	addi	a0,a0,622 # 800078a0 <etext+0x8a0>
    8000363a:	964fd0ef          	jal	8000079e <panic>

000000008000363e <iunlock>:
{
    8000363e:	1101                	addi	sp,sp,-32
    80003640:	ec06                	sd	ra,24(sp)
    80003642:	e822                	sd	s0,16(sp)
    80003644:	e426                	sd	s1,8(sp)
    80003646:	e04a                	sd	s2,0(sp)
    80003648:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000364a:	c505                	beqz	a0,80003672 <iunlock+0x34>
    8000364c:	84aa                	mv	s1,a0
    8000364e:	01050913          	addi	s2,a0,16
    80003652:	854a                	mv	a0,s2
    80003654:	2fd000ef          	jal	80004150 <holdingsleep>
    80003658:	cd09                	beqz	a0,80003672 <iunlock+0x34>
    8000365a:	449c                	lw	a5,8(s1)
    8000365c:	00f05b63          	blez	a5,80003672 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003660:	854a                	mv	a0,s2
    80003662:	2b7000ef          	jal	80004118 <releasesleep>
}
    80003666:	60e2                	ld	ra,24(sp)
    80003668:	6442                	ld	s0,16(sp)
    8000366a:	64a2                	ld	s1,8(sp)
    8000366c:	6902                	ld	s2,0(sp)
    8000366e:	6105                	addi	sp,sp,32
    80003670:	8082                	ret
    panic("iunlock");
    80003672:	00004517          	auipc	a0,0x4
    80003676:	23e50513          	addi	a0,a0,574 # 800078b0 <etext+0x8b0>
    8000367a:	924fd0ef          	jal	8000079e <panic>

000000008000367e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000367e:	7179                	addi	sp,sp,-48
    80003680:	f406                	sd	ra,40(sp)
    80003682:	f022                	sd	s0,32(sp)
    80003684:	ec26                	sd	s1,24(sp)
    80003686:	e84a                	sd	s2,16(sp)
    80003688:	e44e                	sd	s3,8(sp)
    8000368a:	1800                	addi	s0,sp,48
    8000368c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000368e:	05050493          	addi	s1,a0,80
    80003692:	08050913          	addi	s2,a0,128
    80003696:	a021                	j	8000369e <itrunc+0x20>
    80003698:	0491                	addi	s1,s1,4
    8000369a:	01248b63          	beq	s1,s2,800036b0 <itrunc+0x32>
    if(ip->addrs[i]){
    8000369e:	408c                	lw	a1,0(s1)
    800036a0:	dde5                	beqz	a1,80003698 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800036a2:	0009a503          	lw	a0,0(s3)
    800036a6:	9cdff0ef          	jal	80003072 <bfree>
      ip->addrs[i] = 0;
    800036aa:	0004a023          	sw	zero,0(s1)
    800036ae:	b7ed                	j	80003698 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800036b0:	0809a583          	lw	a1,128(s3)
    800036b4:	ed89                	bnez	a1,800036ce <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800036b6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800036ba:	854e                	mv	a0,s3
    800036bc:	e21ff0ef          	jal	800034dc <iupdate>
}
    800036c0:	70a2                	ld	ra,40(sp)
    800036c2:	7402                	ld	s0,32(sp)
    800036c4:	64e2                	ld	s1,24(sp)
    800036c6:	6942                	ld	s2,16(sp)
    800036c8:	69a2                	ld	s3,8(sp)
    800036ca:	6145                	addi	sp,sp,48
    800036cc:	8082                	ret
    800036ce:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800036d0:	0009a503          	lw	a0,0(s3)
    800036d4:	faaff0ef          	jal	80002e7e <bread>
    800036d8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800036da:	05850493          	addi	s1,a0,88
    800036de:	45850913          	addi	s2,a0,1112
    800036e2:	a021                	j	800036ea <itrunc+0x6c>
    800036e4:	0491                	addi	s1,s1,4
    800036e6:	01248963          	beq	s1,s2,800036f8 <itrunc+0x7a>
      if(a[j])
    800036ea:	408c                	lw	a1,0(s1)
    800036ec:	dde5                	beqz	a1,800036e4 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800036ee:	0009a503          	lw	a0,0(s3)
    800036f2:	981ff0ef          	jal	80003072 <bfree>
    800036f6:	b7fd                	j	800036e4 <itrunc+0x66>
    brelse(bp);
    800036f8:	8552                	mv	a0,s4
    800036fa:	88dff0ef          	jal	80002f86 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800036fe:	0809a583          	lw	a1,128(s3)
    80003702:	0009a503          	lw	a0,0(s3)
    80003706:	96dff0ef          	jal	80003072 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000370a:	0809a023          	sw	zero,128(s3)
    8000370e:	6a02                	ld	s4,0(sp)
    80003710:	b75d                	j	800036b6 <itrunc+0x38>

0000000080003712 <iput>:
{
    80003712:	1101                	addi	sp,sp,-32
    80003714:	ec06                	sd	ra,24(sp)
    80003716:	e822                	sd	s0,16(sp)
    80003718:	e426                	sd	s1,8(sp)
    8000371a:	1000                	addi	s0,sp,32
    8000371c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000371e:	0001e517          	auipc	a0,0x1e
    80003722:	eda50513          	addi	a0,a0,-294 # 800215f8 <itable>
    80003726:	cd8fd0ef          	jal	80000bfe <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000372a:	4498                	lw	a4,8(s1)
    8000372c:	4785                	li	a5,1
    8000372e:	02f70063          	beq	a4,a5,8000374e <iput+0x3c>
  ip->ref--;
    80003732:	449c                	lw	a5,8(s1)
    80003734:	37fd                	addiw	a5,a5,-1
    80003736:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003738:	0001e517          	auipc	a0,0x1e
    8000373c:	ec050513          	addi	a0,a0,-320 # 800215f8 <itable>
    80003740:	d52fd0ef          	jal	80000c92 <release>
}
    80003744:	60e2                	ld	ra,24(sp)
    80003746:	6442                	ld	s0,16(sp)
    80003748:	64a2                	ld	s1,8(sp)
    8000374a:	6105                	addi	sp,sp,32
    8000374c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000374e:	40bc                	lw	a5,64(s1)
    80003750:	d3ed                	beqz	a5,80003732 <iput+0x20>
    80003752:	04a49783          	lh	a5,74(s1)
    80003756:	fff1                	bnez	a5,80003732 <iput+0x20>
    80003758:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000375a:	01048913          	addi	s2,s1,16
    8000375e:	854a                	mv	a0,s2
    80003760:	173000ef          	jal	800040d2 <acquiresleep>
    release(&itable.lock);
    80003764:	0001e517          	auipc	a0,0x1e
    80003768:	e9450513          	addi	a0,a0,-364 # 800215f8 <itable>
    8000376c:	d26fd0ef          	jal	80000c92 <release>
    itrunc(ip);
    80003770:	8526                	mv	a0,s1
    80003772:	f0dff0ef          	jal	8000367e <itrunc>
    ip->type = 0;
    80003776:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000377a:	8526                	mv	a0,s1
    8000377c:	d61ff0ef          	jal	800034dc <iupdate>
    ip->valid = 0;
    80003780:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003784:	854a                	mv	a0,s2
    80003786:	193000ef          	jal	80004118 <releasesleep>
    acquire(&itable.lock);
    8000378a:	0001e517          	auipc	a0,0x1e
    8000378e:	e6e50513          	addi	a0,a0,-402 # 800215f8 <itable>
    80003792:	c6cfd0ef          	jal	80000bfe <acquire>
    80003796:	6902                	ld	s2,0(sp)
    80003798:	bf69                	j	80003732 <iput+0x20>

000000008000379a <iunlockput>:
{
    8000379a:	1101                	addi	sp,sp,-32
    8000379c:	ec06                	sd	ra,24(sp)
    8000379e:	e822                	sd	s0,16(sp)
    800037a0:	e426                	sd	s1,8(sp)
    800037a2:	1000                	addi	s0,sp,32
    800037a4:	84aa                	mv	s1,a0
  iunlock(ip);
    800037a6:	e99ff0ef          	jal	8000363e <iunlock>
  iput(ip);
    800037aa:	8526                	mv	a0,s1
    800037ac:	f67ff0ef          	jal	80003712 <iput>
}
    800037b0:	60e2                	ld	ra,24(sp)
    800037b2:	6442                	ld	s0,16(sp)
    800037b4:	64a2                	ld	s1,8(sp)
    800037b6:	6105                	addi	sp,sp,32
    800037b8:	8082                	ret

00000000800037ba <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800037ba:	1141                	addi	sp,sp,-16
    800037bc:	e406                	sd	ra,8(sp)
    800037be:	e022                	sd	s0,0(sp)
    800037c0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800037c2:	411c                	lw	a5,0(a0)
    800037c4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800037c6:	415c                	lw	a5,4(a0)
    800037c8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800037ca:	04451783          	lh	a5,68(a0)
    800037ce:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800037d2:	04a51783          	lh	a5,74(a0)
    800037d6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800037da:	04c56783          	lwu	a5,76(a0)
    800037de:	e99c                	sd	a5,16(a1)
}
    800037e0:	60a2                	ld	ra,8(sp)
    800037e2:	6402                	ld	s0,0(sp)
    800037e4:	0141                	addi	sp,sp,16
    800037e6:	8082                	ret

00000000800037e8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037e8:	457c                	lw	a5,76(a0)
    800037ea:	0ed7e663          	bltu	a5,a3,800038d6 <readi+0xee>
{
    800037ee:	7159                	addi	sp,sp,-112
    800037f0:	f486                	sd	ra,104(sp)
    800037f2:	f0a2                	sd	s0,96(sp)
    800037f4:	eca6                	sd	s1,88(sp)
    800037f6:	e0d2                	sd	s4,64(sp)
    800037f8:	fc56                	sd	s5,56(sp)
    800037fa:	f85a                	sd	s6,48(sp)
    800037fc:	f45e                	sd	s7,40(sp)
    800037fe:	1880                	addi	s0,sp,112
    80003800:	8b2a                	mv	s6,a0
    80003802:	8bae                	mv	s7,a1
    80003804:	8a32                	mv	s4,a2
    80003806:	84b6                	mv	s1,a3
    80003808:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000380a:	9f35                	addw	a4,a4,a3
    return 0;
    8000380c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000380e:	0ad76b63          	bltu	a4,a3,800038c4 <readi+0xdc>
    80003812:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003814:	00e7f463          	bgeu	a5,a4,8000381c <readi+0x34>
    n = ip->size - off;
    80003818:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000381c:	080a8b63          	beqz	s5,800038b2 <readi+0xca>
    80003820:	e8ca                	sd	s2,80(sp)
    80003822:	f062                	sd	s8,32(sp)
    80003824:	ec66                	sd	s9,24(sp)
    80003826:	e86a                	sd	s10,16(sp)
    80003828:	e46e                	sd	s11,8(sp)
    8000382a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000382c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003830:	5c7d                	li	s8,-1
    80003832:	a80d                	j	80003864 <readi+0x7c>
    80003834:	020d1d93          	slli	s11,s10,0x20
    80003838:	020ddd93          	srli	s11,s11,0x20
    8000383c:	05890613          	addi	a2,s2,88
    80003840:	86ee                	mv	a3,s11
    80003842:	963e                	add	a2,a2,a5
    80003844:	85d2                	mv	a1,s4
    80003846:	855e                	mv	a0,s7
    80003848:	d0bfe0ef          	jal	80002552 <either_copyout>
    8000384c:	05850363          	beq	a0,s8,80003892 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003850:	854a                	mv	a0,s2
    80003852:	f34ff0ef          	jal	80002f86 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003856:	013d09bb          	addw	s3,s10,s3
    8000385a:	009d04bb          	addw	s1,s10,s1
    8000385e:	9a6e                	add	s4,s4,s11
    80003860:	0559f363          	bgeu	s3,s5,800038a6 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003864:	00a4d59b          	srliw	a1,s1,0xa
    80003868:	855a                	mv	a0,s6
    8000386a:	987ff0ef          	jal	800031f0 <bmap>
    8000386e:	85aa                	mv	a1,a0
    if(addr == 0)
    80003870:	c139                	beqz	a0,800038b6 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003872:	000b2503          	lw	a0,0(s6)
    80003876:	e08ff0ef          	jal	80002e7e <bread>
    8000387a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000387c:	3ff4f793          	andi	a5,s1,1023
    80003880:	40fc873b          	subw	a4,s9,a5
    80003884:	413a86bb          	subw	a3,s5,s3
    80003888:	8d3a                	mv	s10,a4
    8000388a:	fae6f5e3          	bgeu	a3,a4,80003834 <readi+0x4c>
    8000388e:	8d36                	mv	s10,a3
    80003890:	b755                	j	80003834 <readi+0x4c>
      brelse(bp);
    80003892:	854a                	mv	a0,s2
    80003894:	ef2ff0ef          	jal	80002f86 <brelse>
      tot = -1;
    80003898:	59fd                	li	s3,-1
      break;
    8000389a:	6946                	ld	s2,80(sp)
    8000389c:	7c02                	ld	s8,32(sp)
    8000389e:	6ce2                	ld	s9,24(sp)
    800038a0:	6d42                	ld	s10,16(sp)
    800038a2:	6da2                	ld	s11,8(sp)
    800038a4:	a831                	j	800038c0 <readi+0xd8>
    800038a6:	6946                	ld	s2,80(sp)
    800038a8:	7c02                	ld	s8,32(sp)
    800038aa:	6ce2                	ld	s9,24(sp)
    800038ac:	6d42                	ld	s10,16(sp)
    800038ae:	6da2                	ld	s11,8(sp)
    800038b0:	a801                	j	800038c0 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038b2:	89d6                	mv	s3,s5
    800038b4:	a031                	j	800038c0 <readi+0xd8>
    800038b6:	6946                	ld	s2,80(sp)
    800038b8:	7c02                	ld	s8,32(sp)
    800038ba:	6ce2                	ld	s9,24(sp)
    800038bc:	6d42                	ld	s10,16(sp)
    800038be:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800038c0:	854e                	mv	a0,s3
    800038c2:	69a6                	ld	s3,72(sp)
}
    800038c4:	70a6                	ld	ra,104(sp)
    800038c6:	7406                	ld	s0,96(sp)
    800038c8:	64e6                	ld	s1,88(sp)
    800038ca:	6a06                	ld	s4,64(sp)
    800038cc:	7ae2                	ld	s5,56(sp)
    800038ce:	7b42                	ld	s6,48(sp)
    800038d0:	7ba2                	ld	s7,40(sp)
    800038d2:	6165                	addi	sp,sp,112
    800038d4:	8082                	ret
    return 0;
    800038d6:	4501                	li	a0,0
}
    800038d8:	8082                	ret

00000000800038da <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038da:	457c                	lw	a5,76(a0)
    800038dc:	0ed7eb63          	bltu	a5,a3,800039d2 <writei+0xf8>
{
    800038e0:	7159                	addi	sp,sp,-112
    800038e2:	f486                	sd	ra,104(sp)
    800038e4:	f0a2                	sd	s0,96(sp)
    800038e6:	e8ca                	sd	s2,80(sp)
    800038e8:	e0d2                	sd	s4,64(sp)
    800038ea:	fc56                	sd	s5,56(sp)
    800038ec:	f85a                	sd	s6,48(sp)
    800038ee:	f45e                	sd	s7,40(sp)
    800038f0:	1880                	addi	s0,sp,112
    800038f2:	8aaa                	mv	s5,a0
    800038f4:	8bae                	mv	s7,a1
    800038f6:	8a32                	mv	s4,a2
    800038f8:	8936                	mv	s2,a3
    800038fa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800038fc:	00e687bb          	addw	a5,a3,a4
    80003900:	0cd7eb63          	bltu	a5,a3,800039d6 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003904:	00043737          	lui	a4,0x43
    80003908:	0cf76963          	bltu	a4,a5,800039da <writei+0x100>
    8000390c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000390e:	0a0b0a63          	beqz	s6,800039c2 <writei+0xe8>
    80003912:	eca6                	sd	s1,88(sp)
    80003914:	f062                	sd	s8,32(sp)
    80003916:	ec66                	sd	s9,24(sp)
    80003918:	e86a                	sd	s10,16(sp)
    8000391a:	e46e                	sd	s11,8(sp)
    8000391c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000391e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003922:	5c7d                	li	s8,-1
    80003924:	a825                	j	8000395c <writei+0x82>
    80003926:	020d1d93          	slli	s11,s10,0x20
    8000392a:	020ddd93          	srli	s11,s11,0x20
    8000392e:	05848513          	addi	a0,s1,88
    80003932:	86ee                	mv	a3,s11
    80003934:	8652                	mv	a2,s4
    80003936:	85de                	mv	a1,s7
    80003938:	953e                	add	a0,a0,a5
    8000393a:	c63fe0ef          	jal	8000259c <either_copyin>
    8000393e:	05850663          	beq	a0,s8,8000398a <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003942:	8526                	mv	a0,s1
    80003944:	688000ef          	jal	80003fcc <log_write>
    brelse(bp);
    80003948:	8526                	mv	a0,s1
    8000394a:	e3cff0ef          	jal	80002f86 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000394e:	013d09bb          	addw	s3,s10,s3
    80003952:	012d093b          	addw	s2,s10,s2
    80003956:	9a6e                	add	s4,s4,s11
    80003958:	0369fc63          	bgeu	s3,s6,80003990 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    8000395c:	00a9559b          	srliw	a1,s2,0xa
    80003960:	8556                	mv	a0,s5
    80003962:	88fff0ef          	jal	800031f0 <bmap>
    80003966:	85aa                	mv	a1,a0
    if(addr == 0)
    80003968:	c505                	beqz	a0,80003990 <writei+0xb6>
    bp = bread(ip->dev, addr);
    8000396a:	000aa503          	lw	a0,0(s5)
    8000396e:	d10ff0ef          	jal	80002e7e <bread>
    80003972:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003974:	3ff97793          	andi	a5,s2,1023
    80003978:	40fc873b          	subw	a4,s9,a5
    8000397c:	413b06bb          	subw	a3,s6,s3
    80003980:	8d3a                	mv	s10,a4
    80003982:	fae6f2e3          	bgeu	a3,a4,80003926 <writei+0x4c>
    80003986:	8d36                	mv	s10,a3
    80003988:	bf79                	j	80003926 <writei+0x4c>
      brelse(bp);
    8000398a:	8526                	mv	a0,s1
    8000398c:	dfaff0ef          	jal	80002f86 <brelse>
  }

  if(off > ip->size)
    80003990:	04caa783          	lw	a5,76(s5)
    80003994:	0327f963          	bgeu	a5,s2,800039c6 <writei+0xec>
    ip->size = off;
    80003998:	052aa623          	sw	s2,76(s5)
    8000399c:	64e6                	ld	s1,88(sp)
    8000399e:	7c02                	ld	s8,32(sp)
    800039a0:	6ce2                	ld	s9,24(sp)
    800039a2:	6d42                	ld	s10,16(sp)
    800039a4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800039a6:	8556                	mv	a0,s5
    800039a8:	b35ff0ef          	jal	800034dc <iupdate>

  return tot;
    800039ac:	854e                	mv	a0,s3
    800039ae:	69a6                	ld	s3,72(sp)
}
    800039b0:	70a6                	ld	ra,104(sp)
    800039b2:	7406                	ld	s0,96(sp)
    800039b4:	6946                	ld	s2,80(sp)
    800039b6:	6a06                	ld	s4,64(sp)
    800039b8:	7ae2                	ld	s5,56(sp)
    800039ba:	7b42                	ld	s6,48(sp)
    800039bc:	7ba2                	ld	s7,40(sp)
    800039be:	6165                	addi	sp,sp,112
    800039c0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039c2:	89da                	mv	s3,s6
    800039c4:	b7cd                	j	800039a6 <writei+0xcc>
    800039c6:	64e6                	ld	s1,88(sp)
    800039c8:	7c02                	ld	s8,32(sp)
    800039ca:	6ce2                	ld	s9,24(sp)
    800039cc:	6d42                	ld	s10,16(sp)
    800039ce:	6da2                	ld	s11,8(sp)
    800039d0:	bfd9                	j	800039a6 <writei+0xcc>
    return -1;
    800039d2:	557d                	li	a0,-1
}
    800039d4:	8082                	ret
    return -1;
    800039d6:	557d                	li	a0,-1
    800039d8:	bfe1                	j	800039b0 <writei+0xd6>
    return -1;
    800039da:	557d                	li	a0,-1
    800039dc:	bfd1                	j	800039b0 <writei+0xd6>

00000000800039de <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800039de:	1141                	addi	sp,sp,-16
    800039e0:	e406                	sd	ra,8(sp)
    800039e2:	e022                	sd	s0,0(sp)
    800039e4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800039e6:	4639                	li	a2,14
    800039e8:	bbefd0ef          	jal	80000da6 <strncmp>
}
    800039ec:	60a2                	ld	ra,8(sp)
    800039ee:	6402                	ld	s0,0(sp)
    800039f0:	0141                	addi	sp,sp,16
    800039f2:	8082                	ret

00000000800039f4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800039f4:	711d                	addi	sp,sp,-96
    800039f6:	ec86                	sd	ra,88(sp)
    800039f8:	e8a2                	sd	s0,80(sp)
    800039fa:	e4a6                	sd	s1,72(sp)
    800039fc:	e0ca                	sd	s2,64(sp)
    800039fe:	fc4e                	sd	s3,56(sp)
    80003a00:	f852                	sd	s4,48(sp)
    80003a02:	f456                	sd	s5,40(sp)
    80003a04:	f05a                	sd	s6,32(sp)
    80003a06:	ec5e                	sd	s7,24(sp)
    80003a08:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003a0a:	04451703          	lh	a4,68(a0)
    80003a0e:	4785                	li	a5,1
    80003a10:	00f71f63          	bne	a4,a5,80003a2e <dirlookup+0x3a>
    80003a14:	892a                	mv	s2,a0
    80003a16:	8aae                	mv	s5,a1
    80003a18:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a1a:	457c                	lw	a5,76(a0)
    80003a1c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a1e:	fa040a13          	addi	s4,s0,-96
    80003a22:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003a24:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003a28:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a2a:	e39d                	bnez	a5,80003a50 <dirlookup+0x5c>
    80003a2c:	a8b9                	j	80003a8a <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003a2e:	00004517          	auipc	a0,0x4
    80003a32:	e8a50513          	addi	a0,a0,-374 # 800078b8 <etext+0x8b8>
    80003a36:	d69fc0ef          	jal	8000079e <panic>
      panic("dirlookup read");
    80003a3a:	00004517          	auipc	a0,0x4
    80003a3e:	e9650513          	addi	a0,a0,-362 # 800078d0 <etext+0x8d0>
    80003a42:	d5dfc0ef          	jal	8000079e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a46:	24c1                	addiw	s1,s1,16
    80003a48:	04c92783          	lw	a5,76(s2)
    80003a4c:	02f4fe63          	bgeu	s1,a5,80003a88 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a50:	874e                	mv	a4,s3
    80003a52:	86a6                	mv	a3,s1
    80003a54:	8652                	mv	a2,s4
    80003a56:	4581                	li	a1,0
    80003a58:	854a                	mv	a0,s2
    80003a5a:	d8fff0ef          	jal	800037e8 <readi>
    80003a5e:	fd351ee3          	bne	a0,s3,80003a3a <dirlookup+0x46>
    if(de.inum == 0)
    80003a62:	fa045783          	lhu	a5,-96(s0)
    80003a66:	d3e5                	beqz	a5,80003a46 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003a68:	85da                	mv	a1,s6
    80003a6a:	8556                	mv	a0,s5
    80003a6c:	f73ff0ef          	jal	800039de <namecmp>
    80003a70:	f979                	bnez	a0,80003a46 <dirlookup+0x52>
      if(poff)
    80003a72:	000b8463          	beqz	s7,80003a7a <dirlookup+0x86>
        *poff = off;
    80003a76:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003a7a:	fa045583          	lhu	a1,-96(s0)
    80003a7e:	00092503          	lw	a0,0(s2)
    80003a82:	82fff0ef          	jal	800032b0 <iget>
    80003a86:	a011                	j	80003a8a <dirlookup+0x96>
  return 0;
    80003a88:	4501                	li	a0,0
}
    80003a8a:	60e6                	ld	ra,88(sp)
    80003a8c:	6446                	ld	s0,80(sp)
    80003a8e:	64a6                	ld	s1,72(sp)
    80003a90:	6906                	ld	s2,64(sp)
    80003a92:	79e2                	ld	s3,56(sp)
    80003a94:	7a42                	ld	s4,48(sp)
    80003a96:	7aa2                	ld	s5,40(sp)
    80003a98:	7b02                	ld	s6,32(sp)
    80003a9a:	6be2                	ld	s7,24(sp)
    80003a9c:	6125                	addi	sp,sp,96
    80003a9e:	8082                	ret

0000000080003aa0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003aa0:	711d                	addi	sp,sp,-96
    80003aa2:	ec86                	sd	ra,88(sp)
    80003aa4:	e8a2                	sd	s0,80(sp)
    80003aa6:	e4a6                	sd	s1,72(sp)
    80003aa8:	e0ca                	sd	s2,64(sp)
    80003aaa:	fc4e                	sd	s3,56(sp)
    80003aac:	f852                	sd	s4,48(sp)
    80003aae:	f456                	sd	s5,40(sp)
    80003ab0:	f05a                	sd	s6,32(sp)
    80003ab2:	ec5e                	sd	s7,24(sp)
    80003ab4:	e862                	sd	s8,16(sp)
    80003ab6:	e466                	sd	s9,8(sp)
    80003ab8:	e06a                	sd	s10,0(sp)
    80003aba:	1080                	addi	s0,sp,96
    80003abc:	84aa                	mv	s1,a0
    80003abe:	8b2e                	mv	s6,a1
    80003ac0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003ac2:	00054703          	lbu	a4,0(a0)
    80003ac6:	02f00793          	li	a5,47
    80003aca:	00f70f63          	beq	a4,a5,80003ae8 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003ace:	e0ffd0ef          	jal	800018dc <myproc>
    80003ad2:	17053503          	ld	a0,368(a0)
    80003ad6:	a85ff0ef          	jal	8000355a <idup>
    80003ada:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003adc:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003ae0:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003ae2:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003ae4:	4b85                	li	s7,1
    80003ae6:	a879                	j	80003b84 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003ae8:	4585                	li	a1,1
    80003aea:	852e                	mv	a0,a1
    80003aec:	fc4ff0ef          	jal	800032b0 <iget>
    80003af0:	8a2a                	mv	s4,a0
    80003af2:	b7ed                	j	80003adc <namex+0x3c>
      iunlockput(ip);
    80003af4:	8552                	mv	a0,s4
    80003af6:	ca5ff0ef          	jal	8000379a <iunlockput>
      return 0;
    80003afa:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003afc:	8552                	mv	a0,s4
    80003afe:	60e6                	ld	ra,88(sp)
    80003b00:	6446                	ld	s0,80(sp)
    80003b02:	64a6                	ld	s1,72(sp)
    80003b04:	6906                	ld	s2,64(sp)
    80003b06:	79e2                	ld	s3,56(sp)
    80003b08:	7a42                	ld	s4,48(sp)
    80003b0a:	7aa2                	ld	s5,40(sp)
    80003b0c:	7b02                	ld	s6,32(sp)
    80003b0e:	6be2                	ld	s7,24(sp)
    80003b10:	6c42                	ld	s8,16(sp)
    80003b12:	6ca2                	ld	s9,8(sp)
    80003b14:	6d02                	ld	s10,0(sp)
    80003b16:	6125                	addi	sp,sp,96
    80003b18:	8082                	ret
      iunlock(ip);
    80003b1a:	8552                	mv	a0,s4
    80003b1c:	b23ff0ef          	jal	8000363e <iunlock>
      return ip;
    80003b20:	bff1                	j	80003afc <namex+0x5c>
      iunlockput(ip);
    80003b22:	8552                	mv	a0,s4
    80003b24:	c77ff0ef          	jal	8000379a <iunlockput>
      return 0;
    80003b28:	8a4e                	mv	s4,s3
    80003b2a:	bfc9                	j	80003afc <namex+0x5c>
  len = path - s;
    80003b2c:	40998633          	sub	a2,s3,s1
    80003b30:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003b34:	09ac5063          	bge	s8,s10,80003bb4 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80003b38:	8666                	mv	a2,s9
    80003b3a:	85a6                	mv	a1,s1
    80003b3c:	8556                	mv	a0,s5
    80003b3e:	9f4fd0ef          	jal	80000d32 <memmove>
    80003b42:	84ce                	mv	s1,s3
  while(*path == '/')
    80003b44:	0004c783          	lbu	a5,0(s1)
    80003b48:	01279763          	bne	a5,s2,80003b56 <namex+0xb6>
    path++;
    80003b4c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b4e:	0004c783          	lbu	a5,0(s1)
    80003b52:	ff278de3          	beq	a5,s2,80003b4c <namex+0xac>
    ilock(ip);
    80003b56:	8552                	mv	a0,s4
    80003b58:	a39ff0ef          	jal	80003590 <ilock>
    if(ip->type != T_DIR){
    80003b5c:	044a1783          	lh	a5,68(s4)
    80003b60:	f9779ae3          	bne	a5,s7,80003af4 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003b64:	000b0563          	beqz	s6,80003b6e <namex+0xce>
    80003b68:	0004c783          	lbu	a5,0(s1)
    80003b6c:	d7dd                	beqz	a5,80003b1a <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003b6e:	4601                	li	a2,0
    80003b70:	85d6                	mv	a1,s5
    80003b72:	8552                	mv	a0,s4
    80003b74:	e81ff0ef          	jal	800039f4 <dirlookup>
    80003b78:	89aa                	mv	s3,a0
    80003b7a:	d545                	beqz	a0,80003b22 <namex+0x82>
    iunlockput(ip);
    80003b7c:	8552                	mv	a0,s4
    80003b7e:	c1dff0ef          	jal	8000379a <iunlockput>
    ip = next;
    80003b82:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003b84:	0004c783          	lbu	a5,0(s1)
    80003b88:	01279763          	bne	a5,s2,80003b96 <namex+0xf6>
    path++;
    80003b8c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b8e:	0004c783          	lbu	a5,0(s1)
    80003b92:	ff278de3          	beq	a5,s2,80003b8c <namex+0xec>
  if(*path == 0)
    80003b96:	cb8d                	beqz	a5,80003bc8 <namex+0x128>
  while(*path != '/' && *path != 0)
    80003b98:	0004c783          	lbu	a5,0(s1)
    80003b9c:	89a6                	mv	s3,s1
  len = path - s;
    80003b9e:	4d01                	li	s10,0
    80003ba0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003ba2:	01278963          	beq	a5,s2,80003bb4 <namex+0x114>
    80003ba6:	d3d9                	beqz	a5,80003b2c <namex+0x8c>
    path++;
    80003ba8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003baa:	0009c783          	lbu	a5,0(s3)
    80003bae:	ff279ce3          	bne	a5,s2,80003ba6 <namex+0x106>
    80003bb2:	bfad                	j	80003b2c <namex+0x8c>
    memmove(name, s, len);
    80003bb4:	2601                	sext.w	a2,a2
    80003bb6:	85a6                	mv	a1,s1
    80003bb8:	8556                	mv	a0,s5
    80003bba:	978fd0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003bbe:	9d56                	add	s10,s10,s5
    80003bc0:	000d0023          	sb	zero,0(s10)
    80003bc4:	84ce                	mv	s1,s3
    80003bc6:	bfbd                	j	80003b44 <namex+0xa4>
  if(nameiparent){
    80003bc8:	f20b0ae3          	beqz	s6,80003afc <namex+0x5c>
    iput(ip);
    80003bcc:	8552                	mv	a0,s4
    80003bce:	b45ff0ef          	jal	80003712 <iput>
    return 0;
    80003bd2:	4a01                	li	s4,0
    80003bd4:	b725                	j	80003afc <namex+0x5c>

0000000080003bd6 <dirlink>:
{
    80003bd6:	715d                	addi	sp,sp,-80
    80003bd8:	e486                	sd	ra,72(sp)
    80003bda:	e0a2                	sd	s0,64(sp)
    80003bdc:	f84a                	sd	s2,48(sp)
    80003bde:	ec56                	sd	s5,24(sp)
    80003be0:	e85a                	sd	s6,16(sp)
    80003be2:	0880                	addi	s0,sp,80
    80003be4:	892a                	mv	s2,a0
    80003be6:	8aae                	mv	s5,a1
    80003be8:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003bea:	4601                	li	a2,0
    80003bec:	e09ff0ef          	jal	800039f4 <dirlookup>
    80003bf0:	ed1d                	bnez	a0,80003c2e <dirlink+0x58>
    80003bf2:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bf4:	04c92483          	lw	s1,76(s2)
    80003bf8:	c4b9                	beqz	s1,80003c46 <dirlink+0x70>
    80003bfa:	f44e                	sd	s3,40(sp)
    80003bfc:	f052                	sd	s4,32(sp)
    80003bfe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c00:	fb040a13          	addi	s4,s0,-80
    80003c04:	49c1                	li	s3,16
    80003c06:	874e                	mv	a4,s3
    80003c08:	86a6                	mv	a3,s1
    80003c0a:	8652                	mv	a2,s4
    80003c0c:	4581                	li	a1,0
    80003c0e:	854a                	mv	a0,s2
    80003c10:	bd9ff0ef          	jal	800037e8 <readi>
    80003c14:	03351163          	bne	a0,s3,80003c36 <dirlink+0x60>
    if(de.inum == 0)
    80003c18:	fb045783          	lhu	a5,-80(s0)
    80003c1c:	c39d                	beqz	a5,80003c42 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c1e:	24c1                	addiw	s1,s1,16
    80003c20:	04c92783          	lw	a5,76(s2)
    80003c24:	fef4e1e3          	bltu	s1,a5,80003c06 <dirlink+0x30>
    80003c28:	79a2                	ld	s3,40(sp)
    80003c2a:	7a02                	ld	s4,32(sp)
    80003c2c:	a829                	j	80003c46 <dirlink+0x70>
    iput(ip);
    80003c2e:	ae5ff0ef          	jal	80003712 <iput>
    return -1;
    80003c32:	557d                	li	a0,-1
    80003c34:	a83d                	j	80003c72 <dirlink+0x9c>
      panic("dirlink read");
    80003c36:	00004517          	auipc	a0,0x4
    80003c3a:	caa50513          	addi	a0,a0,-854 # 800078e0 <etext+0x8e0>
    80003c3e:	b61fc0ef          	jal	8000079e <panic>
    80003c42:	79a2                	ld	s3,40(sp)
    80003c44:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003c46:	4639                	li	a2,14
    80003c48:	85d6                	mv	a1,s5
    80003c4a:	fb240513          	addi	a0,s0,-78
    80003c4e:	992fd0ef          	jal	80000de0 <strncpy>
  de.inum = inum;
    80003c52:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c56:	4741                	li	a4,16
    80003c58:	86a6                	mv	a3,s1
    80003c5a:	fb040613          	addi	a2,s0,-80
    80003c5e:	4581                	li	a1,0
    80003c60:	854a                	mv	a0,s2
    80003c62:	c79ff0ef          	jal	800038da <writei>
    80003c66:	1541                	addi	a0,a0,-16
    80003c68:	00a03533          	snez	a0,a0
    80003c6c:	40a0053b          	negw	a0,a0
    80003c70:	74e2                	ld	s1,56(sp)
}
    80003c72:	60a6                	ld	ra,72(sp)
    80003c74:	6406                	ld	s0,64(sp)
    80003c76:	7942                	ld	s2,48(sp)
    80003c78:	6ae2                	ld	s5,24(sp)
    80003c7a:	6b42                	ld	s6,16(sp)
    80003c7c:	6161                	addi	sp,sp,80
    80003c7e:	8082                	ret

0000000080003c80 <namei>:

struct inode*
namei(char *path)
{
    80003c80:	1101                	addi	sp,sp,-32
    80003c82:	ec06                	sd	ra,24(sp)
    80003c84:	e822                	sd	s0,16(sp)
    80003c86:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003c88:	fe040613          	addi	a2,s0,-32
    80003c8c:	4581                	li	a1,0
    80003c8e:	e13ff0ef          	jal	80003aa0 <namex>
}
    80003c92:	60e2                	ld	ra,24(sp)
    80003c94:	6442                	ld	s0,16(sp)
    80003c96:	6105                	addi	sp,sp,32
    80003c98:	8082                	ret

0000000080003c9a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003c9a:	1141                	addi	sp,sp,-16
    80003c9c:	e406                	sd	ra,8(sp)
    80003c9e:	e022                	sd	s0,0(sp)
    80003ca0:	0800                	addi	s0,sp,16
    80003ca2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ca4:	4585                	li	a1,1
    80003ca6:	dfbff0ef          	jal	80003aa0 <namex>
}
    80003caa:	60a2                	ld	ra,8(sp)
    80003cac:	6402                	ld	s0,0(sp)
    80003cae:	0141                	addi	sp,sp,16
    80003cb0:	8082                	ret

0000000080003cb2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003cb2:	1101                	addi	sp,sp,-32
    80003cb4:	ec06                	sd	ra,24(sp)
    80003cb6:	e822                	sd	s0,16(sp)
    80003cb8:	e426                	sd	s1,8(sp)
    80003cba:	e04a                	sd	s2,0(sp)
    80003cbc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003cbe:	0001f917          	auipc	s2,0x1f
    80003cc2:	3e290913          	addi	s2,s2,994 # 800230a0 <log>
    80003cc6:	01892583          	lw	a1,24(s2)
    80003cca:	02892503          	lw	a0,40(s2)
    80003cce:	9b0ff0ef          	jal	80002e7e <bread>
    80003cd2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003cd4:	02c92603          	lw	a2,44(s2)
    80003cd8:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003cda:	00c05f63          	blez	a2,80003cf8 <write_head+0x46>
    80003cde:	0001f717          	auipc	a4,0x1f
    80003ce2:	3f270713          	addi	a4,a4,1010 # 800230d0 <log+0x30>
    80003ce6:	87aa                	mv	a5,a0
    80003ce8:	060a                	slli	a2,a2,0x2
    80003cea:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003cec:	4314                	lw	a3,0(a4)
    80003cee:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003cf0:	0711                	addi	a4,a4,4
    80003cf2:	0791                	addi	a5,a5,4
    80003cf4:	fec79ce3          	bne	a5,a2,80003cec <write_head+0x3a>
  }
  bwrite(buf);
    80003cf8:	8526                	mv	a0,s1
    80003cfa:	a5aff0ef          	jal	80002f54 <bwrite>
  brelse(buf);
    80003cfe:	8526                	mv	a0,s1
    80003d00:	a86ff0ef          	jal	80002f86 <brelse>
}
    80003d04:	60e2                	ld	ra,24(sp)
    80003d06:	6442                	ld	s0,16(sp)
    80003d08:	64a2                	ld	s1,8(sp)
    80003d0a:	6902                	ld	s2,0(sp)
    80003d0c:	6105                	addi	sp,sp,32
    80003d0e:	8082                	ret

0000000080003d10 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d10:	0001f797          	auipc	a5,0x1f
    80003d14:	3bc7a783          	lw	a5,956(a5) # 800230cc <log+0x2c>
    80003d18:	0af05263          	blez	a5,80003dbc <install_trans+0xac>
{
    80003d1c:	715d                	addi	sp,sp,-80
    80003d1e:	e486                	sd	ra,72(sp)
    80003d20:	e0a2                	sd	s0,64(sp)
    80003d22:	fc26                	sd	s1,56(sp)
    80003d24:	f84a                	sd	s2,48(sp)
    80003d26:	f44e                	sd	s3,40(sp)
    80003d28:	f052                	sd	s4,32(sp)
    80003d2a:	ec56                	sd	s5,24(sp)
    80003d2c:	e85a                	sd	s6,16(sp)
    80003d2e:	e45e                	sd	s7,8(sp)
    80003d30:	0880                	addi	s0,sp,80
    80003d32:	8b2a                	mv	s6,a0
    80003d34:	0001fa97          	auipc	s5,0x1f
    80003d38:	39ca8a93          	addi	s5,s5,924 # 800230d0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d3c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d3e:	0001f997          	auipc	s3,0x1f
    80003d42:	36298993          	addi	s3,s3,866 # 800230a0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d46:	40000b93          	li	s7,1024
    80003d4a:	a829                	j	80003d64 <install_trans+0x54>
    brelse(lbuf);
    80003d4c:	854a                	mv	a0,s2
    80003d4e:	a38ff0ef          	jal	80002f86 <brelse>
    brelse(dbuf);
    80003d52:	8526                	mv	a0,s1
    80003d54:	a32ff0ef          	jal	80002f86 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d58:	2a05                	addiw	s4,s4,1
    80003d5a:	0a91                	addi	s5,s5,4
    80003d5c:	02c9a783          	lw	a5,44(s3)
    80003d60:	04fa5363          	bge	s4,a5,80003da6 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d64:	0189a583          	lw	a1,24(s3)
    80003d68:	014585bb          	addw	a1,a1,s4
    80003d6c:	2585                	addiw	a1,a1,1
    80003d6e:	0289a503          	lw	a0,40(s3)
    80003d72:	90cff0ef          	jal	80002e7e <bread>
    80003d76:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003d78:	000aa583          	lw	a1,0(s5)
    80003d7c:	0289a503          	lw	a0,40(s3)
    80003d80:	8feff0ef          	jal	80002e7e <bread>
    80003d84:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d86:	865e                	mv	a2,s7
    80003d88:	05890593          	addi	a1,s2,88
    80003d8c:	05850513          	addi	a0,a0,88
    80003d90:	fa3fc0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003d94:	8526                	mv	a0,s1
    80003d96:	9beff0ef          	jal	80002f54 <bwrite>
    if(recovering == 0)
    80003d9a:	fa0b19e3          	bnez	s6,80003d4c <install_trans+0x3c>
      bunpin(dbuf);
    80003d9e:	8526                	mv	a0,s1
    80003da0:	a9eff0ef          	jal	8000303e <bunpin>
    80003da4:	b765                	j	80003d4c <install_trans+0x3c>
}
    80003da6:	60a6                	ld	ra,72(sp)
    80003da8:	6406                	ld	s0,64(sp)
    80003daa:	74e2                	ld	s1,56(sp)
    80003dac:	7942                	ld	s2,48(sp)
    80003dae:	79a2                	ld	s3,40(sp)
    80003db0:	7a02                	ld	s4,32(sp)
    80003db2:	6ae2                	ld	s5,24(sp)
    80003db4:	6b42                	ld	s6,16(sp)
    80003db6:	6ba2                	ld	s7,8(sp)
    80003db8:	6161                	addi	sp,sp,80
    80003dba:	8082                	ret
    80003dbc:	8082                	ret

0000000080003dbe <initlog>:
{
    80003dbe:	7179                	addi	sp,sp,-48
    80003dc0:	f406                	sd	ra,40(sp)
    80003dc2:	f022                	sd	s0,32(sp)
    80003dc4:	ec26                	sd	s1,24(sp)
    80003dc6:	e84a                	sd	s2,16(sp)
    80003dc8:	e44e                	sd	s3,8(sp)
    80003dca:	1800                	addi	s0,sp,48
    80003dcc:	892a                	mv	s2,a0
    80003dce:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003dd0:	0001f497          	auipc	s1,0x1f
    80003dd4:	2d048493          	addi	s1,s1,720 # 800230a0 <log>
    80003dd8:	00004597          	auipc	a1,0x4
    80003ddc:	b1858593          	addi	a1,a1,-1256 # 800078f0 <etext+0x8f0>
    80003de0:	8526                	mv	a0,s1
    80003de2:	d99fc0ef          	jal	80000b7a <initlock>
  log.start = sb->logstart;
    80003de6:	0149a583          	lw	a1,20(s3)
    80003dea:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003dec:	0109a783          	lw	a5,16(s3)
    80003df0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003df2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003df6:	854a                	mv	a0,s2
    80003df8:	886ff0ef          	jal	80002e7e <bread>
  log.lh.n = lh->n;
    80003dfc:	4d30                	lw	a2,88(a0)
    80003dfe:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003e00:	00c05f63          	blez	a2,80003e1e <initlog+0x60>
    80003e04:	87aa                	mv	a5,a0
    80003e06:	0001f717          	auipc	a4,0x1f
    80003e0a:	2ca70713          	addi	a4,a4,714 # 800230d0 <log+0x30>
    80003e0e:	060a                	slli	a2,a2,0x2
    80003e10:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003e12:	4ff4                	lw	a3,92(a5)
    80003e14:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e16:	0791                	addi	a5,a5,4
    80003e18:	0711                	addi	a4,a4,4
    80003e1a:	fec79ce3          	bne	a5,a2,80003e12 <initlog+0x54>
  brelse(buf);
    80003e1e:	968ff0ef          	jal	80002f86 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003e22:	4505                	li	a0,1
    80003e24:	eedff0ef          	jal	80003d10 <install_trans>
  log.lh.n = 0;
    80003e28:	0001f797          	auipc	a5,0x1f
    80003e2c:	2a07a223          	sw	zero,676(a5) # 800230cc <log+0x2c>
  write_head(); // clear the log
    80003e30:	e83ff0ef          	jal	80003cb2 <write_head>
}
    80003e34:	70a2                	ld	ra,40(sp)
    80003e36:	7402                	ld	s0,32(sp)
    80003e38:	64e2                	ld	s1,24(sp)
    80003e3a:	6942                	ld	s2,16(sp)
    80003e3c:	69a2                	ld	s3,8(sp)
    80003e3e:	6145                	addi	sp,sp,48
    80003e40:	8082                	ret

0000000080003e42 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003e42:	1101                	addi	sp,sp,-32
    80003e44:	ec06                	sd	ra,24(sp)
    80003e46:	e822                	sd	s0,16(sp)
    80003e48:	e426                	sd	s1,8(sp)
    80003e4a:	e04a                	sd	s2,0(sp)
    80003e4c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003e4e:	0001f517          	auipc	a0,0x1f
    80003e52:	25250513          	addi	a0,a0,594 # 800230a0 <log>
    80003e56:	da9fc0ef          	jal	80000bfe <acquire>
  while(1){
    if(log.committing){
    80003e5a:	0001f497          	auipc	s1,0x1f
    80003e5e:	24648493          	addi	s1,s1,582 # 800230a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003e62:	4979                	li	s2,30
    80003e64:	a029                	j	80003e6e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003e66:	85a6                	mv	a1,s1
    80003e68:	8526                	mv	a0,s1
    80003e6a:	9c4fe0ef          	jal	8000202e <sleep>
    if(log.committing){
    80003e6e:	50dc                	lw	a5,36(s1)
    80003e70:	fbfd                	bnez	a5,80003e66 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003e72:	5098                	lw	a4,32(s1)
    80003e74:	2705                	addiw	a4,a4,1
    80003e76:	0027179b          	slliw	a5,a4,0x2
    80003e7a:	9fb9                	addw	a5,a5,a4
    80003e7c:	0017979b          	slliw	a5,a5,0x1
    80003e80:	54d4                	lw	a3,44(s1)
    80003e82:	9fb5                	addw	a5,a5,a3
    80003e84:	00f95763          	bge	s2,a5,80003e92 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003e88:	85a6                	mv	a1,s1
    80003e8a:	8526                	mv	a0,s1
    80003e8c:	9a2fe0ef          	jal	8000202e <sleep>
    80003e90:	bff9                	j	80003e6e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003e92:	0001f517          	auipc	a0,0x1f
    80003e96:	20e50513          	addi	a0,a0,526 # 800230a0 <log>
    80003e9a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003e9c:	df7fc0ef          	jal	80000c92 <release>
      break;
    }
  }
}
    80003ea0:	60e2                	ld	ra,24(sp)
    80003ea2:	6442                	ld	s0,16(sp)
    80003ea4:	64a2                	ld	s1,8(sp)
    80003ea6:	6902                	ld	s2,0(sp)
    80003ea8:	6105                	addi	sp,sp,32
    80003eaa:	8082                	ret

0000000080003eac <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003eac:	7139                	addi	sp,sp,-64
    80003eae:	fc06                	sd	ra,56(sp)
    80003eb0:	f822                	sd	s0,48(sp)
    80003eb2:	f426                	sd	s1,40(sp)
    80003eb4:	f04a                	sd	s2,32(sp)
    80003eb6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003eb8:	0001f497          	auipc	s1,0x1f
    80003ebc:	1e848493          	addi	s1,s1,488 # 800230a0 <log>
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	d3dfc0ef          	jal	80000bfe <acquire>
  log.outstanding -= 1;
    80003ec6:	509c                	lw	a5,32(s1)
    80003ec8:	37fd                	addiw	a5,a5,-1
    80003eca:	893e                	mv	s2,a5
    80003ecc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003ece:	50dc                	lw	a5,36(s1)
    80003ed0:	ef9d                	bnez	a5,80003f0e <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003ed2:	04091863          	bnez	s2,80003f22 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003ed6:	0001f497          	auipc	s1,0x1f
    80003eda:	1ca48493          	addi	s1,s1,458 # 800230a0 <log>
    80003ede:	4785                	li	a5,1
    80003ee0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	daffc0ef          	jal	80000c92 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003ee8:	54dc                	lw	a5,44(s1)
    80003eea:	04f04c63          	bgtz	a5,80003f42 <end_op+0x96>
    acquire(&log.lock);
    80003eee:	0001f497          	auipc	s1,0x1f
    80003ef2:	1b248493          	addi	s1,s1,434 # 800230a0 <log>
    80003ef6:	8526                	mv	a0,s1
    80003ef8:	d07fc0ef          	jal	80000bfe <acquire>
    log.committing = 0;
    80003efc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003f00:	8526                	mv	a0,s1
    80003f02:	adcfe0ef          	jal	800021de <wakeup>
    release(&log.lock);
    80003f06:	8526                	mv	a0,s1
    80003f08:	d8bfc0ef          	jal	80000c92 <release>
}
    80003f0c:	a02d                	j	80003f36 <end_op+0x8a>
    80003f0e:	ec4e                	sd	s3,24(sp)
    80003f10:	e852                	sd	s4,16(sp)
    80003f12:	e456                	sd	s5,8(sp)
    80003f14:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003f16:	00004517          	auipc	a0,0x4
    80003f1a:	9e250513          	addi	a0,a0,-1566 # 800078f8 <etext+0x8f8>
    80003f1e:	881fc0ef          	jal	8000079e <panic>
    wakeup(&log);
    80003f22:	0001f497          	auipc	s1,0x1f
    80003f26:	17e48493          	addi	s1,s1,382 # 800230a0 <log>
    80003f2a:	8526                	mv	a0,s1
    80003f2c:	ab2fe0ef          	jal	800021de <wakeup>
  release(&log.lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	d61fc0ef          	jal	80000c92 <release>
}
    80003f36:	70e2                	ld	ra,56(sp)
    80003f38:	7442                	ld	s0,48(sp)
    80003f3a:	74a2                	ld	s1,40(sp)
    80003f3c:	7902                	ld	s2,32(sp)
    80003f3e:	6121                	addi	sp,sp,64
    80003f40:	8082                	ret
    80003f42:	ec4e                	sd	s3,24(sp)
    80003f44:	e852                	sd	s4,16(sp)
    80003f46:	e456                	sd	s5,8(sp)
    80003f48:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f4a:	0001fa97          	auipc	s5,0x1f
    80003f4e:	186a8a93          	addi	s5,s5,390 # 800230d0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003f52:	0001fa17          	auipc	s4,0x1f
    80003f56:	14ea0a13          	addi	s4,s4,334 # 800230a0 <log>
    memmove(to->data, from->data, BSIZE);
    80003f5a:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003f5e:	018a2583          	lw	a1,24(s4)
    80003f62:	012585bb          	addw	a1,a1,s2
    80003f66:	2585                	addiw	a1,a1,1
    80003f68:	028a2503          	lw	a0,40(s4)
    80003f6c:	f13fe0ef          	jal	80002e7e <bread>
    80003f70:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003f72:	000aa583          	lw	a1,0(s5)
    80003f76:	028a2503          	lw	a0,40(s4)
    80003f7a:	f05fe0ef          	jal	80002e7e <bread>
    80003f7e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003f80:	865a                	mv	a2,s6
    80003f82:	05850593          	addi	a1,a0,88
    80003f86:	05848513          	addi	a0,s1,88
    80003f8a:	da9fc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    80003f8e:	8526                	mv	a0,s1
    80003f90:	fc5fe0ef          	jal	80002f54 <bwrite>
    brelse(from);
    80003f94:	854e                	mv	a0,s3
    80003f96:	ff1fe0ef          	jal	80002f86 <brelse>
    brelse(to);
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	febfe0ef          	jal	80002f86 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fa0:	2905                	addiw	s2,s2,1
    80003fa2:	0a91                	addi	s5,s5,4
    80003fa4:	02ca2783          	lw	a5,44(s4)
    80003fa8:	faf94be3          	blt	s2,a5,80003f5e <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003fac:	d07ff0ef          	jal	80003cb2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003fb0:	4501                	li	a0,0
    80003fb2:	d5fff0ef          	jal	80003d10 <install_trans>
    log.lh.n = 0;
    80003fb6:	0001f797          	auipc	a5,0x1f
    80003fba:	1007ab23          	sw	zero,278(a5) # 800230cc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003fbe:	cf5ff0ef          	jal	80003cb2 <write_head>
    80003fc2:	69e2                	ld	s3,24(sp)
    80003fc4:	6a42                	ld	s4,16(sp)
    80003fc6:	6aa2                	ld	s5,8(sp)
    80003fc8:	6b02                	ld	s6,0(sp)
    80003fca:	b715                	j	80003eee <end_op+0x42>

0000000080003fcc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003fcc:	1101                	addi	sp,sp,-32
    80003fce:	ec06                	sd	ra,24(sp)
    80003fd0:	e822                	sd	s0,16(sp)
    80003fd2:	e426                	sd	s1,8(sp)
    80003fd4:	e04a                	sd	s2,0(sp)
    80003fd6:	1000                	addi	s0,sp,32
    80003fd8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003fda:	0001f917          	auipc	s2,0x1f
    80003fde:	0c690913          	addi	s2,s2,198 # 800230a0 <log>
    80003fe2:	854a                	mv	a0,s2
    80003fe4:	c1bfc0ef          	jal	80000bfe <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003fe8:	02c92603          	lw	a2,44(s2)
    80003fec:	47f5                	li	a5,29
    80003fee:	06c7c363          	blt	a5,a2,80004054 <log_write+0x88>
    80003ff2:	0001f797          	auipc	a5,0x1f
    80003ff6:	0ca7a783          	lw	a5,202(a5) # 800230bc <log+0x1c>
    80003ffa:	37fd                	addiw	a5,a5,-1
    80003ffc:	04f65c63          	bge	a2,a5,80004054 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004000:	0001f797          	auipc	a5,0x1f
    80004004:	0c07a783          	lw	a5,192(a5) # 800230c0 <log+0x20>
    80004008:	04f05c63          	blez	a5,80004060 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000400c:	4781                	li	a5,0
    8000400e:	04c05f63          	blez	a2,8000406c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004012:	44cc                	lw	a1,12(s1)
    80004014:	0001f717          	auipc	a4,0x1f
    80004018:	0bc70713          	addi	a4,a4,188 # 800230d0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000401c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000401e:	4314                	lw	a3,0(a4)
    80004020:	04b68663          	beq	a3,a1,8000406c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004024:	2785                	addiw	a5,a5,1
    80004026:	0711                	addi	a4,a4,4
    80004028:	fef61be3          	bne	a2,a5,8000401e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000402c:	0621                	addi	a2,a2,8
    8000402e:	060a                	slli	a2,a2,0x2
    80004030:	0001f797          	auipc	a5,0x1f
    80004034:	07078793          	addi	a5,a5,112 # 800230a0 <log>
    80004038:	97b2                	add	a5,a5,a2
    8000403a:	44d8                	lw	a4,12(s1)
    8000403c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000403e:	8526                	mv	a0,s1
    80004040:	fcbfe0ef          	jal	8000300a <bpin>
    log.lh.n++;
    80004044:	0001f717          	auipc	a4,0x1f
    80004048:	05c70713          	addi	a4,a4,92 # 800230a0 <log>
    8000404c:	575c                	lw	a5,44(a4)
    8000404e:	2785                	addiw	a5,a5,1
    80004050:	d75c                	sw	a5,44(a4)
    80004052:	a80d                	j	80004084 <log_write+0xb8>
    panic("too big a transaction");
    80004054:	00004517          	auipc	a0,0x4
    80004058:	8b450513          	addi	a0,a0,-1868 # 80007908 <etext+0x908>
    8000405c:	f42fc0ef          	jal	8000079e <panic>
    panic("log_write outside of trans");
    80004060:	00004517          	auipc	a0,0x4
    80004064:	8c050513          	addi	a0,a0,-1856 # 80007920 <etext+0x920>
    80004068:	f36fc0ef          	jal	8000079e <panic>
  log.lh.block[i] = b->blockno;
    8000406c:	00878693          	addi	a3,a5,8
    80004070:	068a                	slli	a3,a3,0x2
    80004072:	0001f717          	auipc	a4,0x1f
    80004076:	02e70713          	addi	a4,a4,46 # 800230a0 <log>
    8000407a:	9736                	add	a4,a4,a3
    8000407c:	44d4                	lw	a3,12(s1)
    8000407e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004080:	faf60fe3          	beq	a2,a5,8000403e <log_write+0x72>
  }
  release(&log.lock);
    80004084:	0001f517          	auipc	a0,0x1f
    80004088:	01c50513          	addi	a0,a0,28 # 800230a0 <log>
    8000408c:	c07fc0ef          	jal	80000c92 <release>
}
    80004090:	60e2                	ld	ra,24(sp)
    80004092:	6442                	ld	s0,16(sp)
    80004094:	64a2                	ld	s1,8(sp)
    80004096:	6902                	ld	s2,0(sp)
    80004098:	6105                	addi	sp,sp,32
    8000409a:	8082                	ret

000000008000409c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000409c:	1101                	addi	sp,sp,-32
    8000409e:	ec06                	sd	ra,24(sp)
    800040a0:	e822                	sd	s0,16(sp)
    800040a2:	e426                	sd	s1,8(sp)
    800040a4:	e04a                	sd	s2,0(sp)
    800040a6:	1000                	addi	s0,sp,32
    800040a8:	84aa                	mv	s1,a0
    800040aa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800040ac:	00004597          	auipc	a1,0x4
    800040b0:	89458593          	addi	a1,a1,-1900 # 80007940 <etext+0x940>
    800040b4:	0521                	addi	a0,a0,8
    800040b6:	ac5fc0ef          	jal	80000b7a <initlock>
  lk->name = name;
    800040ba:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800040be:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800040c2:	0204a423          	sw	zero,40(s1)
}
    800040c6:	60e2                	ld	ra,24(sp)
    800040c8:	6442                	ld	s0,16(sp)
    800040ca:	64a2                	ld	s1,8(sp)
    800040cc:	6902                	ld	s2,0(sp)
    800040ce:	6105                	addi	sp,sp,32
    800040d0:	8082                	ret

00000000800040d2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800040d2:	1101                	addi	sp,sp,-32
    800040d4:	ec06                	sd	ra,24(sp)
    800040d6:	e822                	sd	s0,16(sp)
    800040d8:	e426                	sd	s1,8(sp)
    800040da:	e04a                	sd	s2,0(sp)
    800040dc:	1000                	addi	s0,sp,32
    800040de:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800040e0:	00850913          	addi	s2,a0,8
    800040e4:	854a                	mv	a0,s2
    800040e6:	b19fc0ef          	jal	80000bfe <acquire>
  while (lk->locked) {
    800040ea:	409c                	lw	a5,0(s1)
    800040ec:	c799                	beqz	a5,800040fa <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800040ee:	85ca                	mv	a1,s2
    800040f0:	8526                	mv	a0,s1
    800040f2:	f3dfd0ef          	jal	8000202e <sleep>
  while (lk->locked) {
    800040f6:	409c                	lw	a5,0(s1)
    800040f8:	fbfd                	bnez	a5,800040ee <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800040fa:	4785                	li	a5,1
    800040fc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800040fe:	fdefd0ef          	jal	800018dc <myproc>
    80004102:	591c                	lw	a5,48(a0)
    80004104:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004106:	854a                	mv	a0,s2
    80004108:	b8bfc0ef          	jal	80000c92 <release>
}
    8000410c:	60e2                	ld	ra,24(sp)
    8000410e:	6442                	ld	s0,16(sp)
    80004110:	64a2                	ld	s1,8(sp)
    80004112:	6902                	ld	s2,0(sp)
    80004114:	6105                	addi	sp,sp,32
    80004116:	8082                	ret

0000000080004118 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004118:	1101                	addi	sp,sp,-32
    8000411a:	ec06                	sd	ra,24(sp)
    8000411c:	e822                	sd	s0,16(sp)
    8000411e:	e426                	sd	s1,8(sp)
    80004120:	e04a                	sd	s2,0(sp)
    80004122:	1000                	addi	s0,sp,32
    80004124:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004126:	00850913          	addi	s2,a0,8
    8000412a:	854a                	mv	a0,s2
    8000412c:	ad3fc0ef          	jal	80000bfe <acquire>
  lk->locked = 0;
    80004130:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004134:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004138:	8526                	mv	a0,s1
    8000413a:	8a4fe0ef          	jal	800021de <wakeup>
  release(&lk->lk);
    8000413e:	854a                	mv	a0,s2
    80004140:	b53fc0ef          	jal	80000c92 <release>
}
    80004144:	60e2                	ld	ra,24(sp)
    80004146:	6442                	ld	s0,16(sp)
    80004148:	64a2                	ld	s1,8(sp)
    8000414a:	6902                	ld	s2,0(sp)
    8000414c:	6105                	addi	sp,sp,32
    8000414e:	8082                	ret

0000000080004150 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004150:	7179                	addi	sp,sp,-48
    80004152:	f406                	sd	ra,40(sp)
    80004154:	f022                	sd	s0,32(sp)
    80004156:	ec26                	sd	s1,24(sp)
    80004158:	e84a                	sd	s2,16(sp)
    8000415a:	1800                	addi	s0,sp,48
    8000415c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000415e:	00850913          	addi	s2,a0,8
    80004162:	854a                	mv	a0,s2
    80004164:	a9bfc0ef          	jal	80000bfe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004168:	409c                	lw	a5,0(s1)
    8000416a:	ef81                	bnez	a5,80004182 <holdingsleep+0x32>
    8000416c:	4481                	li	s1,0
  release(&lk->lk);
    8000416e:	854a                	mv	a0,s2
    80004170:	b23fc0ef          	jal	80000c92 <release>
  return r;
}
    80004174:	8526                	mv	a0,s1
    80004176:	70a2                	ld	ra,40(sp)
    80004178:	7402                	ld	s0,32(sp)
    8000417a:	64e2                	ld	s1,24(sp)
    8000417c:	6942                	ld	s2,16(sp)
    8000417e:	6145                	addi	sp,sp,48
    80004180:	8082                	ret
    80004182:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004184:	0284a983          	lw	s3,40(s1)
    80004188:	f54fd0ef          	jal	800018dc <myproc>
    8000418c:	5904                	lw	s1,48(a0)
    8000418e:	413484b3          	sub	s1,s1,s3
    80004192:	0014b493          	seqz	s1,s1
    80004196:	69a2                	ld	s3,8(sp)
    80004198:	bfd9                	j	8000416e <holdingsleep+0x1e>

000000008000419a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000419a:	1141                	addi	sp,sp,-16
    8000419c:	e406                	sd	ra,8(sp)
    8000419e:	e022                	sd	s0,0(sp)
    800041a0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800041a2:	00003597          	auipc	a1,0x3
    800041a6:	7ae58593          	addi	a1,a1,1966 # 80007950 <etext+0x950>
    800041aa:	0001f517          	auipc	a0,0x1f
    800041ae:	03e50513          	addi	a0,a0,62 # 800231e8 <ftable>
    800041b2:	9c9fc0ef          	jal	80000b7a <initlock>
}
    800041b6:	60a2                	ld	ra,8(sp)
    800041b8:	6402                	ld	s0,0(sp)
    800041ba:	0141                	addi	sp,sp,16
    800041bc:	8082                	ret

00000000800041be <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800041be:	1101                	addi	sp,sp,-32
    800041c0:	ec06                	sd	ra,24(sp)
    800041c2:	e822                	sd	s0,16(sp)
    800041c4:	e426                	sd	s1,8(sp)
    800041c6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800041c8:	0001f517          	auipc	a0,0x1f
    800041cc:	02050513          	addi	a0,a0,32 # 800231e8 <ftable>
    800041d0:	a2ffc0ef          	jal	80000bfe <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041d4:	0001f497          	auipc	s1,0x1f
    800041d8:	02c48493          	addi	s1,s1,44 # 80023200 <ftable+0x18>
    800041dc:	00020717          	auipc	a4,0x20
    800041e0:	fc470713          	addi	a4,a4,-60 # 800241a0 <disk>
    if(f->ref == 0){
    800041e4:	40dc                	lw	a5,4(s1)
    800041e6:	cf89                	beqz	a5,80004200 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041e8:	02848493          	addi	s1,s1,40
    800041ec:	fee49ce3          	bne	s1,a4,800041e4 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800041f0:	0001f517          	auipc	a0,0x1f
    800041f4:	ff850513          	addi	a0,a0,-8 # 800231e8 <ftable>
    800041f8:	a9bfc0ef          	jal	80000c92 <release>
  return 0;
    800041fc:	4481                	li	s1,0
    800041fe:	a809                	j	80004210 <filealloc+0x52>
      f->ref = 1;
    80004200:	4785                	li	a5,1
    80004202:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004204:	0001f517          	auipc	a0,0x1f
    80004208:	fe450513          	addi	a0,a0,-28 # 800231e8 <ftable>
    8000420c:	a87fc0ef          	jal	80000c92 <release>
}
    80004210:	8526                	mv	a0,s1
    80004212:	60e2                	ld	ra,24(sp)
    80004214:	6442                	ld	s0,16(sp)
    80004216:	64a2                	ld	s1,8(sp)
    80004218:	6105                	addi	sp,sp,32
    8000421a:	8082                	ret

000000008000421c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000421c:	1101                	addi	sp,sp,-32
    8000421e:	ec06                	sd	ra,24(sp)
    80004220:	e822                	sd	s0,16(sp)
    80004222:	e426                	sd	s1,8(sp)
    80004224:	1000                	addi	s0,sp,32
    80004226:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004228:	0001f517          	auipc	a0,0x1f
    8000422c:	fc050513          	addi	a0,a0,-64 # 800231e8 <ftable>
    80004230:	9cffc0ef          	jal	80000bfe <acquire>
  if(f->ref < 1)
    80004234:	40dc                	lw	a5,4(s1)
    80004236:	02f05063          	blez	a5,80004256 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000423a:	2785                	addiw	a5,a5,1
    8000423c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000423e:	0001f517          	auipc	a0,0x1f
    80004242:	faa50513          	addi	a0,a0,-86 # 800231e8 <ftable>
    80004246:	a4dfc0ef          	jal	80000c92 <release>
  return f;
}
    8000424a:	8526                	mv	a0,s1
    8000424c:	60e2                	ld	ra,24(sp)
    8000424e:	6442                	ld	s0,16(sp)
    80004250:	64a2                	ld	s1,8(sp)
    80004252:	6105                	addi	sp,sp,32
    80004254:	8082                	ret
    panic("filedup");
    80004256:	00003517          	auipc	a0,0x3
    8000425a:	70250513          	addi	a0,a0,1794 # 80007958 <etext+0x958>
    8000425e:	d40fc0ef          	jal	8000079e <panic>

0000000080004262 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004262:	7139                	addi	sp,sp,-64
    80004264:	fc06                	sd	ra,56(sp)
    80004266:	f822                	sd	s0,48(sp)
    80004268:	f426                	sd	s1,40(sp)
    8000426a:	0080                	addi	s0,sp,64
    8000426c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000426e:	0001f517          	auipc	a0,0x1f
    80004272:	f7a50513          	addi	a0,a0,-134 # 800231e8 <ftable>
    80004276:	989fc0ef          	jal	80000bfe <acquire>
  if(f->ref < 1)
    8000427a:	40dc                	lw	a5,4(s1)
    8000427c:	04f05863          	blez	a5,800042cc <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    80004280:	37fd                	addiw	a5,a5,-1
    80004282:	c0dc                	sw	a5,4(s1)
    80004284:	04f04e63          	bgtz	a5,800042e0 <fileclose+0x7e>
    80004288:	f04a                	sd	s2,32(sp)
    8000428a:	ec4e                	sd	s3,24(sp)
    8000428c:	e852                	sd	s4,16(sp)
    8000428e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004290:	0004a903          	lw	s2,0(s1)
    80004294:	0094ca83          	lbu	s5,9(s1)
    80004298:	0104ba03          	ld	s4,16(s1)
    8000429c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800042a0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800042a4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800042a8:	0001f517          	auipc	a0,0x1f
    800042ac:	f4050513          	addi	a0,a0,-192 # 800231e8 <ftable>
    800042b0:	9e3fc0ef          	jal	80000c92 <release>

  if(ff.type == FD_PIPE){
    800042b4:	4785                	li	a5,1
    800042b6:	04f90063          	beq	s2,a5,800042f6 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800042ba:	3979                	addiw	s2,s2,-2
    800042bc:	4785                	li	a5,1
    800042be:	0527f563          	bgeu	a5,s2,80004308 <fileclose+0xa6>
    800042c2:	7902                	ld	s2,32(sp)
    800042c4:	69e2                	ld	s3,24(sp)
    800042c6:	6a42                	ld	s4,16(sp)
    800042c8:	6aa2                	ld	s5,8(sp)
    800042ca:	a00d                	j	800042ec <fileclose+0x8a>
    800042cc:	f04a                	sd	s2,32(sp)
    800042ce:	ec4e                	sd	s3,24(sp)
    800042d0:	e852                	sd	s4,16(sp)
    800042d2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800042d4:	00003517          	auipc	a0,0x3
    800042d8:	68c50513          	addi	a0,a0,1676 # 80007960 <etext+0x960>
    800042dc:	cc2fc0ef          	jal	8000079e <panic>
    release(&ftable.lock);
    800042e0:	0001f517          	auipc	a0,0x1f
    800042e4:	f0850513          	addi	a0,a0,-248 # 800231e8 <ftable>
    800042e8:	9abfc0ef          	jal	80000c92 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800042ec:	70e2                	ld	ra,56(sp)
    800042ee:	7442                	ld	s0,48(sp)
    800042f0:	74a2                	ld	s1,40(sp)
    800042f2:	6121                	addi	sp,sp,64
    800042f4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800042f6:	85d6                	mv	a1,s5
    800042f8:	8552                	mv	a0,s4
    800042fa:	340000ef          	jal	8000463a <pipeclose>
    800042fe:	7902                	ld	s2,32(sp)
    80004300:	69e2                	ld	s3,24(sp)
    80004302:	6a42                	ld	s4,16(sp)
    80004304:	6aa2                	ld	s5,8(sp)
    80004306:	b7dd                	j	800042ec <fileclose+0x8a>
    begin_op();
    80004308:	b3bff0ef          	jal	80003e42 <begin_op>
    iput(ff.ip);
    8000430c:	854e                	mv	a0,s3
    8000430e:	c04ff0ef          	jal	80003712 <iput>
    end_op();
    80004312:	b9bff0ef          	jal	80003eac <end_op>
    80004316:	7902                	ld	s2,32(sp)
    80004318:	69e2                	ld	s3,24(sp)
    8000431a:	6a42                	ld	s4,16(sp)
    8000431c:	6aa2                	ld	s5,8(sp)
    8000431e:	b7f9                	j	800042ec <fileclose+0x8a>

0000000080004320 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004320:	715d                	addi	sp,sp,-80
    80004322:	e486                	sd	ra,72(sp)
    80004324:	e0a2                	sd	s0,64(sp)
    80004326:	fc26                	sd	s1,56(sp)
    80004328:	f44e                	sd	s3,40(sp)
    8000432a:	0880                	addi	s0,sp,80
    8000432c:	84aa                	mv	s1,a0
    8000432e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004330:	dacfd0ef          	jal	800018dc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004334:	409c                	lw	a5,0(s1)
    80004336:	37f9                	addiw	a5,a5,-2
    80004338:	4705                	li	a4,1
    8000433a:	04f76263          	bltu	a4,a5,8000437e <filestat+0x5e>
    8000433e:	f84a                	sd	s2,48(sp)
    80004340:	f052                	sd	s4,32(sp)
    80004342:	892a                	mv	s2,a0
    ilock(f->ip);
    80004344:	6c88                	ld	a0,24(s1)
    80004346:	a4aff0ef          	jal	80003590 <ilock>
    stati(f->ip, &st);
    8000434a:	fb840a13          	addi	s4,s0,-72
    8000434e:	85d2                	mv	a1,s4
    80004350:	6c88                	ld	a0,24(s1)
    80004352:	c68ff0ef          	jal	800037ba <stati>
    iunlock(f->ip);
    80004356:	6c88                	ld	a0,24(s1)
    80004358:	ae6ff0ef          	jal	8000363e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000435c:	46e1                	li	a3,24
    8000435e:	8652                	mv	a2,s4
    80004360:	85ce                	mv	a1,s3
    80004362:	07093503          	ld	a0,112(s2)
    80004366:	a1efd0ef          	jal	80001584 <copyout>
    8000436a:	41f5551b          	sraiw	a0,a0,0x1f
    8000436e:	7942                	ld	s2,48(sp)
    80004370:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004372:	60a6                	ld	ra,72(sp)
    80004374:	6406                	ld	s0,64(sp)
    80004376:	74e2                	ld	s1,56(sp)
    80004378:	79a2                	ld	s3,40(sp)
    8000437a:	6161                	addi	sp,sp,80
    8000437c:	8082                	ret
  return -1;
    8000437e:	557d                	li	a0,-1
    80004380:	bfcd                	j	80004372 <filestat+0x52>

0000000080004382 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004382:	7179                	addi	sp,sp,-48
    80004384:	f406                	sd	ra,40(sp)
    80004386:	f022                	sd	s0,32(sp)
    80004388:	e84a                	sd	s2,16(sp)
    8000438a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000438c:	00854783          	lbu	a5,8(a0)
    80004390:	cfd1                	beqz	a5,8000442c <fileread+0xaa>
    80004392:	ec26                	sd	s1,24(sp)
    80004394:	e44e                	sd	s3,8(sp)
    80004396:	84aa                	mv	s1,a0
    80004398:	89ae                	mv	s3,a1
    8000439a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000439c:	411c                	lw	a5,0(a0)
    8000439e:	4705                	li	a4,1
    800043a0:	04e78363          	beq	a5,a4,800043e6 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800043a4:	470d                	li	a4,3
    800043a6:	04e78763          	beq	a5,a4,800043f4 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800043aa:	4709                	li	a4,2
    800043ac:	06e79a63          	bne	a5,a4,80004420 <fileread+0x9e>
    ilock(f->ip);
    800043b0:	6d08                	ld	a0,24(a0)
    800043b2:	9deff0ef          	jal	80003590 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800043b6:	874a                	mv	a4,s2
    800043b8:	5094                	lw	a3,32(s1)
    800043ba:	864e                	mv	a2,s3
    800043bc:	4585                	li	a1,1
    800043be:	6c88                	ld	a0,24(s1)
    800043c0:	c28ff0ef          	jal	800037e8 <readi>
    800043c4:	892a                	mv	s2,a0
    800043c6:	00a05563          	blez	a0,800043d0 <fileread+0x4e>
      f->off += r;
    800043ca:	509c                	lw	a5,32(s1)
    800043cc:	9fa9                	addw	a5,a5,a0
    800043ce:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800043d0:	6c88                	ld	a0,24(s1)
    800043d2:	a6cff0ef          	jal	8000363e <iunlock>
    800043d6:	64e2                	ld	s1,24(sp)
    800043d8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800043da:	854a                	mv	a0,s2
    800043dc:	70a2                	ld	ra,40(sp)
    800043de:	7402                	ld	s0,32(sp)
    800043e0:	6942                	ld	s2,16(sp)
    800043e2:	6145                	addi	sp,sp,48
    800043e4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800043e6:	6908                	ld	a0,16(a0)
    800043e8:	3a2000ef          	jal	8000478a <piperead>
    800043ec:	892a                	mv	s2,a0
    800043ee:	64e2                	ld	s1,24(sp)
    800043f0:	69a2                	ld	s3,8(sp)
    800043f2:	b7e5                	j	800043da <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800043f4:	02451783          	lh	a5,36(a0)
    800043f8:	03079693          	slli	a3,a5,0x30
    800043fc:	92c1                	srli	a3,a3,0x30
    800043fe:	4725                	li	a4,9
    80004400:	02d76863          	bltu	a4,a3,80004430 <fileread+0xae>
    80004404:	0792                	slli	a5,a5,0x4
    80004406:	0001f717          	auipc	a4,0x1f
    8000440a:	d4270713          	addi	a4,a4,-702 # 80023148 <devsw>
    8000440e:	97ba                	add	a5,a5,a4
    80004410:	639c                	ld	a5,0(a5)
    80004412:	c39d                	beqz	a5,80004438 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004414:	4505                	li	a0,1
    80004416:	9782                	jalr	a5
    80004418:	892a                	mv	s2,a0
    8000441a:	64e2                	ld	s1,24(sp)
    8000441c:	69a2                	ld	s3,8(sp)
    8000441e:	bf75                	j	800043da <fileread+0x58>
    panic("fileread");
    80004420:	00003517          	auipc	a0,0x3
    80004424:	55050513          	addi	a0,a0,1360 # 80007970 <etext+0x970>
    80004428:	b76fc0ef          	jal	8000079e <panic>
    return -1;
    8000442c:	597d                	li	s2,-1
    8000442e:	b775                	j	800043da <fileread+0x58>
      return -1;
    80004430:	597d                	li	s2,-1
    80004432:	64e2                	ld	s1,24(sp)
    80004434:	69a2                	ld	s3,8(sp)
    80004436:	b755                	j	800043da <fileread+0x58>
    80004438:	597d                	li	s2,-1
    8000443a:	64e2                	ld	s1,24(sp)
    8000443c:	69a2                	ld	s3,8(sp)
    8000443e:	bf71                	j	800043da <fileread+0x58>

0000000080004440 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004440:	00954783          	lbu	a5,9(a0)
    80004444:	10078e63          	beqz	a5,80004560 <filewrite+0x120>
{
    80004448:	711d                	addi	sp,sp,-96
    8000444a:	ec86                	sd	ra,88(sp)
    8000444c:	e8a2                	sd	s0,80(sp)
    8000444e:	e0ca                	sd	s2,64(sp)
    80004450:	f456                	sd	s5,40(sp)
    80004452:	f05a                	sd	s6,32(sp)
    80004454:	1080                	addi	s0,sp,96
    80004456:	892a                	mv	s2,a0
    80004458:	8b2e                	mv	s6,a1
    8000445a:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000445c:	411c                	lw	a5,0(a0)
    8000445e:	4705                	li	a4,1
    80004460:	02e78963          	beq	a5,a4,80004492 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004464:	470d                	li	a4,3
    80004466:	02e78a63          	beq	a5,a4,8000449a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000446a:	4709                	li	a4,2
    8000446c:	0ce79e63          	bne	a5,a4,80004548 <filewrite+0x108>
    80004470:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004472:	0ac05963          	blez	a2,80004524 <filewrite+0xe4>
    80004476:	e4a6                	sd	s1,72(sp)
    80004478:	fc4e                	sd	s3,56(sp)
    8000447a:	ec5e                	sd	s7,24(sp)
    8000447c:	e862                	sd	s8,16(sp)
    8000447e:	e466                	sd	s9,8(sp)
    int i = 0;
    80004480:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004482:	6b85                	lui	s7,0x1
    80004484:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004488:	6c85                	lui	s9,0x1
    8000448a:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000448e:	4c05                	li	s8,1
    80004490:	a8ad                	j	8000450a <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80004492:	6908                	ld	a0,16(a0)
    80004494:	1fe000ef          	jal	80004692 <pipewrite>
    80004498:	a04d                	j	8000453a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000449a:	02451783          	lh	a5,36(a0)
    8000449e:	03079693          	slli	a3,a5,0x30
    800044a2:	92c1                	srli	a3,a3,0x30
    800044a4:	4725                	li	a4,9
    800044a6:	0ad76f63          	bltu	a4,a3,80004564 <filewrite+0x124>
    800044aa:	0792                	slli	a5,a5,0x4
    800044ac:	0001f717          	auipc	a4,0x1f
    800044b0:	c9c70713          	addi	a4,a4,-868 # 80023148 <devsw>
    800044b4:	97ba                	add	a5,a5,a4
    800044b6:	679c                	ld	a5,8(a5)
    800044b8:	cbc5                	beqz	a5,80004568 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    800044ba:	4505                	li	a0,1
    800044bc:	9782                	jalr	a5
    800044be:	a8b5                	j	8000453a <filewrite+0xfa>
      if(n1 > max)
    800044c0:	2981                	sext.w	s3,s3
      begin_op();
    800044c2:	981ff0ef          	jal	80003e42 <begin_op>
      ilock(f->ip);
    800044c6:	01893503          	ld	a0,24(s2)
    800044ca:	8c6ff0ef          	jal	80003590 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800044ce:	874e                	mv	a4,s3
    800044d0:	02092683          	lw	a3,32(s2)
    800044d4:	016a0633          	add	a2,s4,s6
    800044d8:	85e2                	mv	a1,s8
    800044da:	01893503          	ld	a0,24(s2)
    800044de:	bfcff0ef          	jal	800038da <writei>
    800044e2:	84aa                	mv	s1,a0
    800044e4:	00a05763          	blez	a0,800044f2 <filewrite+0xb2>
        f->off += r;
    800044e8:	02092783          	lw	a5,32(s2)
    800044ec:	9fa9                	addw	a5,a5,a0
    800044ee:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800044f2:	01893503          	ld	a0,24(s2)
    800044f6:	948ff0ef          	jal	8000363e <iunlock>
      end_op();
    800044fa:	9b3ff0ef          	jal	80003eac <end_op>

      if(r != n1){
    800044fe:	02999563          	bne	s3,s1,80004528 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    80004502:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004506:	015a5963          	bge	s4,s5,80004518 <filewrite+0xd8>
      int n1 = n - i;
    8000450a:	414a87bb          	subw	a5,s5,s4
    8000450e:	89be                	mv	s3,a5
      if(n1 > max)
    80004510:	fafbd8e3          	bge	s7,a5,800044c0 <filewrite+0x80>
    80004514:	89e6                	mv	s3,s9
    80004516:	b76d                	j	800044c0 <filewrite+0x80>
    80004518:	64a6                	ld	s1,72(sp)
    8000451a:	79e2                	ld	s3,56(sp)
    8000451c:	6be2                	ld	s7,24(sp)
    8000451e:	6c42                	ld	s8,16(sp)
    80004520:	6ca2                	ld	s9,8(sp)
    80004522:	a801                	j	80004532 <filewrite+0xf2>
    int i = 0;
    80004524:	4a01                	li	s4,0
    80004526:	a031                	j	80004532 <filewrite+0xf2>
    80004528:	64a6                	ld	s1,72(sp)
    8000452a:	79e2                	ld	s3,56(sp)
    8000452c:	6be2                	ld	s7,24(sp)
    8000452e:	6c42                	ld	s8,16(sp)
    80004530:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004532:	034a9d63          	bne	s5,s4,8000456c <filewrite+0x12c>
    80004536:	8556                	mv	a0,s5
    80004538:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000453a:	60e6                	ld	ra,88(sp)
    8000453c:	6446                	ld	s0,80(sp)
    8000453e:	6906                	ld	s2,64(sp)
    80004540:	7aa2                	ld	s5,40(sp)
    80004542:	7b02                	ld	s6,32(sp)
    80004544:	6125                	addi	sp,sp,96
    80004546:	8082                	ret
    80004548:	e4a6                	sd	s1,72(sp)
    8000454a:	fc4e                	sd	s3,56(sp)
    8000454c:	f852                	sd	s4,48(sp)
    8000454e:	ec5e                	sd	s7,24(sp)
    80004550:	e862                	sd	s8,16(sp)
    80004552:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004554:	00003517          	auipc	a0,0x3
    80004558:	42c50513          	addi	a0,a0,1068 # 80007980 <etext+0x980>
    8000455c:	a42fc0ef          	jal	8000079e <panic>
    return -1;
    80004560:	557d                	li	a0,-1
}
    80004562:	8082                	ret
      return -1;
    80004564:	557d                	li	a0,-1
    80004566:	bfd1                	j	8000453a <filewrite+0xfa>
    80004568:	557d                	li	a0,-1
    8000456a:	bfc1                	j	8000453a <filewrite+0xfa>
    ret = (i == n ? n : -1);
    8000456c:	557d                	li	a0,-1
    8000456e:	7a42                	ld	s4,48(sp)
    80004570:	b7e9                	j	8000453a <filewrite+0xfa>

0000000080004572 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004572:	7179                	addi	sp,sp,-48
    80004574:	f406                	sd	ra,40(sp)
    80004576:	f022                	sd	s0,32(sp)
    80004578:	ec26                	sd	s1,24(sp)
    8000457a:	e052                	sd	s4,0(sp)
    8000457c:	1800                	addi	s0,sp,48
    8000457e:	84aa                	mv	s1,a0
    80004580:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004582:	0005b023          	sd	zero,0(a1)
    80004586:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000458a:	c35ff0ef          	jal	800041be <filealloc>
    8000458e:	e088                	sd	a0,0(s1)
    80004590:	c549                	beqz	a0,8000461a <pipealloc+0xa8>
    80004592:	c2dff0ef          	jal	800041be <filealloc>
    80004596:	00aa3023          	sd	a0,0(s4)
    8000459a:	cd25                	beqz	a0,80004612 <pipealloc+0xa0>
    8000459c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000459e:	d8cfc0ef          	jal	80000b2a <kalloc>
    800045a2:	892a                	mv	s2,a0
    800045a4:	c12d                	beqz	a0,80004606 <pipealloc+0x94>
    800045a6:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800045a8:	4985                	li	s3,1
    800045aa:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800045ae:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800045b2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800045b6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800045ba:	00003597          	auipc	a1,0x3
    800045be:	3d658593          	addi	a1,a1,982 # 80007990 <etext+0x990>
    800045c2:	db8fc0ef          	jal	80000b7a <initlock>
  (*f0)->type = FD_PIPE;
    800045c6:	609c                	ld	a5,0(s1)
    800045c8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800045cc:	609c                	ld	a5,0(s1)
    800045ce:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800045d2:	609c                	ld	a5,0(s1)
    800045d4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800045d8:	609c                	ld	a5,0(s1)
    800045da:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800045de:	000a3783          	ld	a5,0(s4)
    800045e2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800045e6:	000a3783          	ld	a5,0(s4)
    800045ea:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800045ee:	000a3783          	ld	a5,0(s4)
    800045f2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800045f6:	000a3783          	ld	a5,0(s4)
    800045fa:	0127b823          	sd	s2,16(a5)
  return 0;
    800045fe:	4501                	li	a0,0
    80004600:	6942                	ld	s2,16(sp)
    80004602:	69a2                	ld	s3,8(sp)
    80004604:	a01d                	j	8000462a <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004606:	6088                	ld	a0,0(s1)
    80004608:	c119                	beqz	a0,8000460e <pipealloc+0x9c>
    8000460a:	6942                	ld	s2,16(sp)
    8000460c:	a029                	j	80004616 <pipealloc+0xa4>
    8000460e:	6942                	ld	s2,16(sp)
    80004610:	a029                	j	8000461a <pipealloc+0xa8>
    80004612:	6088                	ld	a0,0(s1)
    80004614:	c10d                	beqz	a0,80004636 <pipealloc+0xc4>
    fileclose(*f0);
    80004616:	c4dff0ef          	jal	80004262 <fileclose>
  if(*f1)
    8000461a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000461e:	557d                	li	a0,-1
  if(*f1)
    80004620:	c789                	beqz	a5,8000462a <pipealloc+0xb8>
    fileclose(*f1);
    80004622:	853e                	mv	a0,a5
    80004624:	c3fff0ef          	jal	80004262 <fileclose>
  return -1;
    80004628:	557d                	li	a0,-1
}
    8000462a:	70a2                	ld	ra,40(sp)
    8000462c:	7402                	ld	s0,32(sp)
    8000462e:	64e2                	ld	s1,24(sp)
    80004630:	6a02                	ld	s4,0(sp)
    80004632:	6145                	addi	sp,sp,48
    80004634:	8082                	ret
  return -1;
    80004636:	557d                	li	a0,-1
    80004638:	bfcd                	j	8000462a <pipealloc+0xb8>

000000008000463a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000463a:	1101                	addi	sp,sp,-32
    8000463c:	ec06                	sd	ra,24(sp)
    8000463e:	e822                	sd	s0,16(sp)
    80004640:	e426                	sd	s1,8(sp)
    80004642:	e04a                	sd	s2,0(sp)
    80004644:	1000                	addi	s0,sp,32
    80004646:	84aa                	mv	s1,a0
    80004648:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000464a:	db4fc0ef          	jal	80000bfe <acquire>
  if(writable){
    8000464e:	02090763          	beqz	s2,8000467c <pipeclose+0x42>
    pi->writeopen = 0;
    80004652:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004656:	21848513          	addi	a0,s1,536
    8000465a:	b85fd0ef          	jal	800021de <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000465e:	2204b783          	ld	a5,544(s1)
    80004662:	e785                	bnez	a5,8000468a <pipeclose+0x50>
    release(&pi->lock);
    80004664:	8526                	mv	a0,s1
    80004666:	e2cfc0ef          	jal	80000c92 <release>
    kfree((char*)pi);
    8000466a:	8526                	mv	a0,s1
    8000466c:	bdcfc0ef          	jal	80000a48 <kfree>
  } else
    release(&pi->lock);
}
    80004670:	60e2                	ld	ra,24(sp)
    80004672:	6442                	ld	s0,16(sp)
    80004674:	64a2                	ld	s1,8(sp)
    80004676:	6902                	ld	s2,0(sp)
    80004678:	6105                	addi	sp,sp,32
    8000467a:	8082                	ret
    pi->readopen = 0;
    8000467c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004680:	21c48513          	addi	a0,s1,540
    80004684:	b5bfd0ef          	jal	800021de <wakeup>
    80004688:	bfd9                	j	8000465e <pipeclose+0x24>
    release(&pi->lock);
    8000468a:	8526                	mv	a0,s1
    8000468c:	e06fc0ef          	jal	80000c92 <release>
}
    80004690:	b7c5                	j	80004670 <pipeclose+0x36>

0000000080004692 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004692:	7159                	addi	sp,sp,-112
    80004694:	f486                	sd	ra,104(sp)
    80004696:	f0a2                	sd	s0,96(sp)
    80004698:	eca6                	sd	s1,88(sp)
    8000469a:	e8ca                	sd	s2,80(sp)
    8000469c:	e4ce                	sd	s3,72(sp)
    8000469e:	e0d2                	sd	s4,64(sp)
    800046a0:	fc56                	sd	s5,56(sp)
    800046a2:	1880                	addi	s0,sp,112
    800046a4:	84aa                	mv	s1,a0
    800046a6:	8aae                	mv	s5,a1
    800046a8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800046aa:	a32fd0ef          	jal	800018dc <myproc>
    800046ae:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800046b0:	8526                	mv	a0,s1
    800046b2:	d4cfc0ef          	jal	80000bfe <acquire>
  while(i < n){
    800046b6:	0d405263          	blez	s4,8000477a <pipewrite+0xe8>
    800046ba:	f85a                	sd	s6,48(sp)
    800046bc:	f45e                	sd	s7,40(sp)
    800046be:	f062                	sd	s8,32(sp)
    800046c0:	ec66                	sd	s9,24(sp)
    800046c2:	e86a                	sd	s10,16(sp)
  int i = 0;
    800046c4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800046c6:	f9f40c13          	addi	s8,s0,-97
    800046ca:	4b85                	li	s7,1
    800046cc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800046ce:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800046d2:	21c48c93          	addi	s9,s1,540
    800046d6:	a82d                	j	80004710 <pipewrite+0x7e>
      release(&pi->lock);
    800046d8:	8526                	mv	a0,s1
    800046da:	db8fc0ef          	jal	80000c92 <release>
      return -1;
    800046de:	597d                	li	s2,-1
    800046e0:	7b42                	ld	s6,48(sp)
    800046e2:	7ba2                	ld	s7,40(sp)
    800046e4:	7c02                	ld	s8,32(sp)
    800046e6:	6ce2                	ld	s9,24(sp)
    800046e8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800046ea:	854a                	mv	a0,s2
    800046ec:	70a6                	ld	ra,104(sp)
    800046ee:	7406                	ld	s0,96(sp)
    800046f0:	64e6                	ld	s1,88(sp)
    800046f2:	6946                	ld	s2,80(sp)
    800046f4:	69a6                	ld	s3,72(sp)
    800046f6:	6a06                	ld	s4,64(sp)
    800046f8:	7ae2                	ld	s5,56(sp)
    800046fa:	6165                	addi	sp,sp,112
    800046fc:	8082                	ret
      wakeup(&pi->nread);
    800046fe:	856a                	mv	a0,s10
    80004700:	adffd0ef          	jal	800021de <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004704:	85a6                	mv	a1,s1
    80004706:	8566                	mv	a0,s9
    80004708:	927fd0ef          	jal	8000202e <sleep>
  while(i < n){
    8000470c:	05495a63          	bge	s2,s4,80004760 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004710:	2204a783          	lw	a5,544(s1)
    80004714:	d3f1                	beqz	a5,800046d8 <pipewrite+0x46>
    80004716:	854e                	mv	a0,s3
    80004718:	d1dfd0ef          	jal	80002434 <killed>
    8000471c:	fd55                	bnez	a0,800046d8 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000471e:	2184a783          	lw	a5,536(s1)
    80004722:	21c4a703          	lw	a4,540(s1)
    80004726:	2007879b          	addiw	a5,a5,512
    8000472a:	fcf70ae3          	beq	a4,a5,800046fe <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000472e:	86de                	mv	a3,s7
    80004730:	01590633          	add	a2,s2,s5
    80004734:	85e2                	mv	a1,s8
    80004736:	0709b503          	ld	a0,112(s3)
    8000473a:	efbfc0ef          	jal	80001634 <copyin>
    8000473e:	05650063          	beq	a0,s6,8000477e <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004742:	21c4a783          	lw	a5,540(s1)
    80004746:	0017871b          	addiw	a4,a5,1
    8000474a:	20e4ae23          	sw	a4,540(s1)
    8000474e:	1ff7f793          	andi	a5,a5,511
    80004752:	97a6                	add	a5,a5,s1
    80004754:	f9f44703          	lbu	a4,-97(s0)
    80004758:	00e78c23          	sb	a4,24(a5)
      i++;
    8000475c:	2905                	addiw	s2,s2,1
    8000475e:	b77d                	j	8000470c <pipewrite+0x7a>
    80004760:	7b42                	ld	s6,48(sp)
    80004762:	7ba2                	ld	s7,40(sp)
    80004764:	7c02                	ld	s8,32(sp)
    80004766:	6ce2                	ld	s9,24(sp)
    80004768:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000476a:	21848513          	addi	a0,s1,536
    8000476e:	a71fd0ef          	jal	800021de <wakeup>
  release(&pi->lock);
    80004772:	8526                	mv	a0,s1
    80004774:	d1efc0ef          	jal	80000c92 <release>
  return i;
    80004778:	bf8d                	j	800046ea <pipewrite+0x58>
  int i = 0;
    8000477a:	4901                	li	s2,0
    8000477c:	b7fd                	j	8000476a <pipewrite+0xd8>
    8000477e:	7b42                	ld	s6,48(sp)
    80004780:	7ba2                	ld	s7,40(sp)
    80004782:	7c02                	ld	s8,32(sp)
    80004784:	6ce2                	ld	s9,24(sp)
    80004786:	6d42                	ld	s10,16(sp)
    80004788:	b7cd                	j	8000476a <pipewrite+0xd8>

000000008000478a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000478a:	711d                	addi	sp,sp,-96
    8000478c:	ec86                	sd	ra,88(sp)
    8000478e:	e8a2                	sd	s0,80(sp)
    80004790:	e4a6                	sd	s1,72(sp)
    80004792:	e0ca                	sd	s2,64(sp)
    80004794:	fc4e                	sd	s3,56(sp)
    80004796:	f852                	sd	s4,48(sp)
    80004798:	f456                	sd	s5,40(sp)
    8000479a:	1080                	addi	s0,sp,96
    8000479c:	84aa                	mv	s1,a0
    8000479e:	892e                	mv	s2,a1
    800047a0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800047a2:	93afd0ef          	jal	800018dc <myproc>
    800047a6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800047a8:	8526                	mv	a0,s1
    800047aa:	c54fc0ef          	jal	80000bfe <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047ae:	2184a703          	lw	a4,536(s1)
    800047b2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800047b6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047ba:	02f71763          	bne	a4,a5,800047e8 <piperead+0x5e>
    800047be:	2244a783          	lw	a5,548(s1)
    800047c2:	cf85                	beqz	a5,800047fa <piperead+0x70>
    if(killed(pr)){
    800047c4:	8552                	mv	a0,s4
    800047c6:	c6ffd0ef          	jal	80002434 <killed>
    800047ca:	e11d                	bnez	a0,800047f0 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800047cc:	85a6                	mv	a1,s1
    800047ce:	854e                	mv	a0,s3
    800047d0:	85ffd0ef          	jal	8000202e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047d4:	2184a703          	lw	a4,536(s1)
    800047d8:	21c4a783          	lw	a5,540(s1)
    800047dc:	fef701e3          	beq	a4,a5,800047be <piperead+0x34>
    800047e0:	f05a                	sd	s6,32(sp)
    800047e2:	ec5e                	sd	s7,24(sp)
    800047e4:	e862                	sd	s8,16(sp)
    800047e6:	a829                	j	80004800 <piperead+0x76>
    800047e8:	f05a                	sd	s6,32(sp)
    800047ea:	ec5e                	sd	s7,24(sp)
    800047ec:	e862                	sd	s8,16(sp)
    800047ee:	a809                	j	80004800 <piperead+0x76>
      release(&pi->lock);
    800047f0:	8526                	mv	a0,s1
    800047f2:	ca0fc0ef          	jal	80000c92 <release>
      return -1;
    800047f6:	59fd                	li	s3,-1
    800047f8:	a0a5                	j	80004860 <piperead+0xd6>
    800047fa:	f05a                	sd	s6,32(sp)
    800047fc:	ec5e                	sd	s7,24(sp)
    800047fe:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004800:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004802:	faf40c13          	addi	s8,s0,-81
    80004806:	4b85                	li	s7,1
    80004808:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000480a:	05505163          	blez	s5,8000484c <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    8000480e:	2184a783          	lw	a5,536(s1)
    80004812:	21c4a703          	lw	a4,540(s1)
    80004816:	02f70b63          	beq	a4,a5,8000484c <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000481a:	0017871b          	addiw	a4,a5,1
    8000481e:	20e4ac23          	sw	a4,536(s1)
    80004822:	1ff7f793          	andi	a5,a5,511
    80004826:	97a6                	add	a5,a5,s1
    80004828:	0187c783          	lbu	a5,24(a5)
    8000482c:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004830:	86de                	mv	a3,s7
    80004832:	8662                	mv	a2,s8
    80004834:	85ca                	mv	a1,s2
    80004836:	070a3503          	ld	a0,112(s4)
    8000483a:	d4bfc0ef          	jal	80001584 <copyout>
    8000483e:	01650763          	beq	a0,s6,8000484c <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004842:	2985                	addiw	s3,s3,1
    80004844:	0905                	addi	s2,s2,1
    80004846:	fd3a94e3          	bne	s5,s3,8000480e <piperead+0x84>
    8000484a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000484c:	21c48513          	addi	a0,s1,540
    80004850:	98ffd0ef          	jal	800021de <wakeup>
  release(&pi->lock);
    80004854:	8526                	mv	a0,s1
    80004856:	c3cfc0ef          	jal	80000c92 <release>
    8000485a:	7b02                	ld	s6,32(sp)
    8000485c:	6be2                	ld	s7,24(sp)
    8000485e:	6c42                	ld	s8,16(sp)
  return i;
}
    80004860:	854e                	mv	a0,s3
    80004862:	60e6                	ld	ra,88(sp)
    80004864:	6446                	ld	s0,80(sp)
    80004866:	64a6                	ld	s1,72(sp)
    80004868:	6906                	ld	s2,64(sp)
    8000486a:	79e2                	ld	s3,56(sp)
    8000486c:	7a42                	ld	s4,48(sp)
    8000486e:	7aa2                	ld	s5,40(sp)
    80004870:	6125                	addi	sp,sp,96
    80004872:	8082                	ret

0000000080004874 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004874:	1141                	addi	sp,sp,-16
    80004876:	e406                	sd	ra,8(sp)
    80004878:	e022                	sd	s0,0(sp)
    8000487a:	0800                	addi	s0,sp,16
    8000487c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000487e:	0035151b          	slliw	a0,a0,0x3
    80004882:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004884:	8b89                	andi	a5,a5,2
    80004886:	c399                	beqz	a5,8000488c <flags2perm+0x18>
      perm |= PTE_W;
    80004888:	00456513          	ori	a0,a0,4
    return perm;
}
    8000488c:	60a2                	ld	ra,8(sp)
    8000488e:	6402                	ld	s0,0(sp)
    80004890:	0141                	addi	sp,sp,16
    80004892:	8082                	ret

0000000080004894 <exec>:

int
exec(char *path, char **argv)
{
    80004894:	de010113          	addi	sp,sp,-544
    80004898:	20113c23          	sd	ra,536(sp)
    8000489c:	20813823          	sd	s0,528(sp)
    800048a0:	20913423          	sd	s1,520(sp)
    800048a4:	21213023          	sd	s2,512(sp)
    800048a8:	1400                	addi	s0,sp,544
    800048aa:	892a                	mv	s2,a0
    800048ac:	dea43823          	sd	a0,-528(s0)
    800048b0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800048b4:	828fd0ef          	jal	800018dc <myproc>
    800048b8:	84aa                	mv	s1,a0

  begin_op();
    800048ba:	d88ff0ef          	jal	80003e42 <begin_op>

  if((ip = namei(path)) == 0){
    800048be:	854a                	mv	a0,s2
    800048c0:	bc0ff0ef          	jal	80003c80 <namei>
    800048c4:	cd21                	beqz	a0,8000491c <exec+0x88>
    800048c6:	fbd2                	sd	s4,496(sp)
    800048c8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800048ca:	cc7fe0ef          	jal	80003590 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800048ce:	04000713          	li	a4,64
    800048d2:	4681                	li	a3,0
    800048d4:	e5040613          	addi	a2,s0,-432
    800048d8:	4581                	li	a1,0
    800048da:	8552                	mv	a0,s4
    800048dc:	f0dfe0ef          	jal	800037e8 <readi>
    800048e0:	04000793          	li	a5,64
    800048e4:	00f51a63          	bne	a0,a5,800048f8 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800048e8:	e5042703          	lw	a4,-432(s0)
    800048ec:	464c47b7          	lui	a5,0x464c4
    800048f0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800048f4:	02f70863          	beq	a4,a5,80004924 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800048f8:	8552                	mv	a0,s4
    800048fa:	ea1fe0ef          	jal	8000379a <iunlockput>
    end_op();
    800048fe:	daeff0ef          	jal	80003eac <end_op>
  }
  return -1;
    80004902:	557d                	li	a0,-1
    80004904:	7a5e                	ld	s4,496(sp)
}
    80004906:	21813083          	ld	ra,536(sp)
    8000490a:	21013403          	ld	s0,528(sp)
    8000490e:	20813483          	ld	s1,520(sp)
    80004912:	20013903          	ld	s2,512(sp)
    80004916:	22010113          	addi	sp,sp,544
    8000491a:	8082                	ret
    end_op();
    8000491c:	d90ff0ef          	jal	80003eac <end_op>
    return -1;
    80004920:	557d                	li	a0,-1
    80004922:	b7d5                	j	80004906 <exec+0x72>
    80004924:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004926:	8526                	mv	a0,s1
    80004928:	85cfd0ef          	jal	80001984 <proc_pagetable>
    8000492c:	8b2a                	mv	s6,a0
    8000492e:	26050d63          	beqz	a0,80004ba8 <exec+0x314>
    80004932:	ffce                	sd	s3,504(sp)
    80004934:	f7d6                	sd	s5,488(sp)
    80004936:	efde                	sd	s7,472(sp)
    80004938:	ebe2                	sd	s8,464(sp)
    8000493a:	e7e6                	sd	s9,456(sp)
    8000493c:	e3ea                	sd	s10,448(sp)
    8000493e:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004940:	e7042683          	lw	a3,-400(s0)
    80004944:	e8845783          	lhu	a5,-376(s0)
    80004948:	0e078763          	beqz	a5,80004a36 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000494c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000494e:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004950:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80004954:	6c85                	lui	s9,0x1
    80004956:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000495a:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000495e:	6a85                	lui	s5,0x1
    80004960:	a085                	j	800049c0 <exec+0x12c>
      panic("loadseg: address should exist");
    80004962:	00003517          	auipc	a0,0x3
    80004966:	03650513          	addi	a0,a0,54 # 80007998 <etext+0x998>
    8000496a:	e35fb0ef          	jal	8000079e <panic>
    if(sz - i < PGSIZE)
    8000496e:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004970:	874a                	mv	a4,s2
    80004972:	009c06bb          	addw	a3,s8,s1
    80004976:	4581                	li	a1,0
    80004978:	8552                	mv	a0,s4
    8000497a:	e6ffe0ef          	jal	800037e8 <readi>
    8000497e:	22a91963          	bne	s2,a0,80004bb0 <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80004982:	009a84bb          	addw	s1,s5,s1
    80004986:	0334f263          	bgeu	s1,s3,800049aa <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    8000498a:	02049593          	slli	a1,s1,0x20
    8000498e:	9181                	srli	a1,a1,0x20
    80004990:	95de                	add	a1,a1,s7
    80004992:	855a                	mv	a0,s6
    80004994:	e68fc0ef          	jal	80000ffc <walkaddr>
    80004998:	862a                	mv	a2,a0
    if(pa == 0)
    8000499a:	d561                	beqz	a0,80004962 <exec+0xce>
    if(sz - i < PGSIZE)
    8000499c:	409987bb          	subw	a5,s3,s1
    800049a0:	893e                	mv	s2,a5
    800049a2:	fcfcf6e3          	bgeu	s9,a5,8000496e <exec+0xda>
    800049a6:	8956                	mv	s2,s5
    800049a8:	b7d9                	j	8000496e <exec+0xda>
    sz = sz1;
    800049aa:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800049ae:	2d05                	addiw	s10,s10,1
    800049b0:	e0843783          	ld	a5,-504(s0)
    800049b4:	0387869b          	addiw	a3,a5,56
    800049b8:	e8845783          	lhu	a5,-376(s0)
    800049bc:	06fd5e63          	bge	s10,a5,80004a38 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800049c0:	e0d43423          	sd	a3,-504(s0)
    800049c4:	876e                	mv	a4,s11
    800049c6:	e1840613          	addi	a2,s0,-488
    800049ca:	4581                	li	a1,0
    800049cc:	8552                	mv	a0,s4
    800049ce:	e1bfe0ef          	jal	800037e8 <readi>
    800049d2:	1db51d63          	bne	a0,s11,80004bac <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    800049d6:	e1842783          	lw	a5,-488(s0)
    800049da:	4705                	li	a4,1
    800049dc:	fce799e3          	bne	a5,a4,800049ae <exec+0x11a>
    if(ph.memsz < ph.filesz)
    800049e0:	e4043483          	ld	s1,-448(s0)
    800049e4:	e3843783          	ld	a5,-456(s0)
    800049e8:	1ef4e263          	bltu	s1,a5,80004bcc <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800049ec:	e2843783          	ld	a5,-472(s0)
    800049f0:	94be                	add	s1,s1,a5
    800049f2:	1ef4e063          	bltu	s1,a5,80004bd2 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    800049f6:	de843703          	ld	a4,-536(s0)
    800049fa:	8ff9                	and	a5,a5,a4
    800049fc:	1c079e63          	bnez	a5,80004bd8 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004a00:	e1c42503          	lw	a0,-484(s0)
    80004a04:	e71ff0ef          	jal	80004874 <flags2perm>
    80004a08:	86aa                	mv	a3,a0
    80004a0a:	8626                	mv	a2,s1
    80004a0c:	85ca                	mv	a1,s2
    80004a0e:	855a                	mv	a0,s6
    80004a10:	955fc0ef          	jal	80001364 <uvmalloc>
    80004a14:	dea43c23          	sd	a0,-520(s0)
    80004a18:	1c050363          	beqz	a0,80004bde <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004a1c:	e2843b83          	ld	s7,-472(s0)
    80004a20:	e2042c03          	lw	s8,-480(s0)
    80004a24:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004a28:	00098463          	beqz	s3,80004a30 <exec+0x19c>
    80004a2c:	4481                	li	s1,0
    80004a2e:	bfb1                	j	8000498a <exec+0xf6>
    sz = sz1;
    80004a30:	df843903          	ld	s2,-520(s0)
    80004a34:	bfad                	j	800049ae <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a36:	4901                	li	s2,0
  iunlockput(ip);
    80004a38:	8552                	mv	a0,s4
    80004a3a:	d61fe0ef          	jal	8000379a <iunlockput>
  end_op();
    80004a3e:	c6eff0ef          	jal	80003eac <end_op>
  p = myproc();
    80004a42:	e9bfc0ef          	jal	800018dc <myproc>
    80004a46:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004a48:	06853d03          	ld	s10,104(a0)
  sz = PGROUNDUP(sz);
    80004a4c:	6985                	lui	s3,0x1
    80004a4e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004a50:	99ca                	add	s3,s3,s2
    80004a52:	77fd                	lui	a5,0xfffff
    80004a54:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004a58:	4691                	li	a3,4
    80004a5a:	6609                	lui	a2,0x2
    80004a5c:	964e                	add	a2,a2,s3
    80004a5e:	85ce                	mv	a1,s3
    80004a60:	855a                	mv	a0,s6
    80004a62:	903fc0ef          	jal	80001364 <uvmalloc>
    80004a66:	8a2a                	mv	s4,a0
    80004a68:	e105                	bnez	a0,80004a88 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80004a6a:	85ce                	mv	a1,s3
    80004a6c:	855a                	mv	a0,s6
    80004a6e:	f9bfc0ef          	jal	80001a08 <proc_freepagetable>
  return -1;
    80004a72:	557d                	li	a0,-1
    80004a74:	79fe                	ld	s3,504(sp)
    80004a76:	7a5e                	ld	s4,496(sp)
    80004a78:	7abe                	ld	s5,488(sp)
    80004a7a:	7b1e                	ld	s6,480(sp)
    80004a7c:	6bfe                	ld	s7,472(sp)
    80004a7e:	6c5e                	ld	s8,464(sp)
    80004a80:	6cbe                	ld	s9,456(sp)
    80004a82:	6d1e                	ld	s10,448(sp)
    80004a84:	7dfa                	ld	s11,440(sp)
    80004a86:	b541                	j	80004906 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004a88:	75f9                	lui	a1,0xffffe
    80004a8a:	95aa                	add	a1,a1,a0
    80004a8c:	855a                	mv	a0,s6
    80004a8e:	acdfc0ef          	jal	8000155a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004a92:	7bfd                	lui	s7,0xfffff
    80004a94:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80004a96:	e0043783          	ld	a5,-512(s0)
    80004a9a:	6388                	ld	a0,0(a5)
  sp = sz;
    80004a9c:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004a9e:	4481                	li	s1,0
    ustack[argc] = sp;
    80004aa0:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004aa4:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004aa8:	cd21                	beqz	a0,80004b00 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80004aaa:	bacfc0ef          	jal	80000e56 <strlen>
    80004aae:	0015079b          	addiw	a5,a0,1
    80004ab2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ab6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004aba:	13796563          	bltu	s2,s7,80004be4 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004abe:	e0043d83          	ld	s11,-512(s0)
    80004ac2:	000db983          	ld	s3,0(s11)
    80004ac6:	854e                	mv	a0,s3
    80004ac8:	b8efc0ef          	jal	80000e56 <strlen>
    80004acc:	0015069b          	addiw	a3,a0,1
    80004ad0:	864e                	mv	a2,s3
    80004ad2:	85ca                	mv	a1,s2
    80004ad4:	855a                	mv	a0,s6
    80004ad6:	aaffc0ef          	jal	80001584 <copyout>
    80004ada:	10054763          	bltz	a0,80004be8 <exec+0x354>
    ustack[argc] = sp;
    80004ade:	00349793          	slli	a5,s1,0x3
    80004ae2:	97e6                	add	a5,a5,s9
    80004ae4:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdad20>
  for(argc = 0; argv[argc]; argc++) {
    80004ae8:	0485                	addi	s1,s1,1
    80004aea:	008d8793          	addi	a5,s11,8
    80004aee:	e0f43023          	sd	a5,-512(s0)
    80004af2:	008db503          	ld	a0,8(s11)
    80004af6:	c509                	beqz	a0,80004b00 <exec+0x26c>
    if(argc >= MAXARG)
    80004af8:	fb8499e3          	bne	s1,s8,80004aaa <exec+0x216>
  sz = sz1;
    80004afc:	89d2                	mv	s3,s4
    80004afe:	b7b5                	j	80004a6a <exec+0x1d6>
  ustack[argc] = 0;
    80004b00:	00349793          	slli	a5,s1,0x3
    80004b04:	f9078793          	addi	a5,a5,-112
    80004b08:	97a2                	add	a5,a5,s0
    80004b0a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004b0e:	00148693          	addi	a3,s1,1
    80004b12:	068e                	slli	a3,a3,0x3
    80004b14:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004b18:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004b1c:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004b1e:	f57966e3          	bltu	s2,s7,80004a6a <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004b22:	e9040613          	addi	a2,s0,-368
    80004b26:	85ca                	mv	a1,s2
    80004b28:	855a                	mv	a0,s6
    80004b2a:	a5bfc0ef          	jal	80001584 <copyout>
    80004b2e:	f2054ee3          	bltz	a0,80004a6a <exec+0x1d6>
  p->trapframe->a1 = sp;
    80004b32:	078ab783          	ld	a5,120(s5) # 1078 <_entry-0x7fffef88>
    80004b36:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004b3a:	df043783          	ld	a5,-528(s0)
    80004b3e:	0007c703          	lbu	a4,0(a5)
    80004b42:	cf11                	beqz	a4,80004b5e <exec+0x2ca>
    80004b44:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004b46:	02f00693          	li	a3,47
    80004b4a:	a029                	j	80004b54 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80004b4c:	0785                	addi	a5,a5,1
    80004b4e:	fff7c703          	lbu	a4,-1(a5)
    80004b52:	c711                	beqz	a4,80004b5e <exec+0x2ca>
    if(*s == '/')
    80004b54:	fed71ce3          	bne	a4,a3,80004b4c <exec+0x2b8>
      last = s+1;
    80004b58:	def43823          	sd	a5,-528(s0)
    80004b5c:	bfc5                	j	80004b4c <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80004b5e:	4641                	li	a2,16
    80004b60:	df043583          	ld	a1,-528(s0)
    80004b64:	178a8513          	addi	a0,s5,376
    80004b68:	ab8fc0ef          	jal	80000e20 <safestrcpy>
  oldpagetable = p->pagetable;
    80004b6c:	070ab503          	ld	a0,112(s5)
  p->pagetable = pagetable;
    80004b70:	076ab823          	sd	s6,112(s5)
  p->sz = sz;
    80004b74:	074ab423          	sd	s4,104(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004b78:	078ab783          	ld	a5,120(s5)
    80004b7c:	e6843703          	ld	a4,-408(s0)
    80004b80:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004b82:	078ab783          	ld	a5,120(s5)
    80004b86:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004b8a:	85ea                	mv	a1,s10
    80004b8c:	e7dfc0ef          	jal	80001a08 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004b90:	0004851b          	sext.w	a0,s1
    80004b94:	79fe                	ld	s3,504(sp)
    80004b96:	7a5e                	ld	s4,496(sp)
    80004b98:	7abe                	ld	s5,488(sp)
    80004b9a:	7b1e                	ld	s6,480(sp)
    80004b9c:	6bfe                	ld	s7,472(sp)
    80004b9e:	6c5e                	ld	s8,464(sp)
    80004ba0:	6cbe                	ld	s9,456(sp)
    80004ba2:	6d1e                	ld	s10,448(sp)
    80004ba4:	7dfa                	ld	s11,440(sp)
    80004ba6:	b385                	j	80004906 <exec+0x72>
    80004ba8:	7b1e                	ld	s6,480(sp)
    80004baa:	b3b9                	j	800048f8 <exec+0x64>
    80004bac:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004bb0:	df843583          	ld	a1,-520(s0)
    80004bb4:	855a                	mv	a0,s6
    80004bb6:	e53fc0ef          	jal	80001a08 <proc_freepagetable>
  if(ip){
    80004bba:	79fe                	ld	s3,504(sp)
    80004bbc:	7abe                	ld	s5,488(sp)
    80004bbe:	7b1e                	ld	s6,480(sp)
    80004bc0:	6bfe                	ld	s7,472(sp)
    80004bc2:	6c5e                	ld	s8,464(sp)
    80004bc4:	6cbe                	ld	s9,456(sp)
    80004bc6:	6d1e                	ld	s10,448(sp)
    80004bc8:	7dfa                	ld	s11,440(sp)
    80004bca:	b33d                	j	800048f8 <exec+0x64>
    80004bcc:	df243c23          	sd	s2,-520(s0)
    80004bd0:	b7c5                	j	80004bb0 <exec+0x31c>
    80004bd2:	df243c23          	sd	s2,-520(s0)
    80004bd6:	bfe9                	j	80004bb0 <exec+0x31c>
    80004bd8:	df243c23          	sd	s2,-520(s0)
    80004bdc:	bfd1                	j	80004bb0 <exec+0x31c>
    80004bde:	df243c23          	sd	s2,-520(s0)
    80004be2:	b7f9                	j	80004bb0 <exec+0x31c>
  sz = sz1;
    80004be4:	89d2                	mv	s3,s4
    80004be6:	b551                	j	80004a6a <exec+0x1d6>
    80004be8:	89d2                	mv	s3,s4
    80004bea:	b541                	j	80004a6a <exec+0x1d6>

0000000080004bec <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004bec:	7179                	addi	sp,sp,-48
    80004bee:	f406                	sd	ra,40(sp)
    80004bf0:	f022                	sd	s0,32(sp)
    80004bf2:	ec26                	sd	s1,24(sp)
    80004bf4:	e84a                	sd	s2,16(sp)
    80004bf6:	1800                	addi	s0,sp,48
    80004bf8:	892e                	mv	s2,a1
    80004bfa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004bfc:	fdc40593          	addi	a1,s0,-36
    80004c00:	ee1fd0ef          	jal	80002ae0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004c04:	fdc42703          	lw	a4,-36(s0)
    80004c08:	47bd                	li	a5,15
    80004c0a:	02e7e963          	bltu	a5,a4,80004c3c <argfd+0x50>
    80004c0e:	ccffc0ef          	jal	800018dc <myproc>
    80004c12:	fdc42703          	lw	a4,-36(s0)
    80004c16:	01e70793          	addi	a5,a4,30
    80004c1a:	078e                	slli	a5,a5,0x3
    80004c1c:	953e                	add	a0,a0,a5
    80004c1e:	611c                	ld	a5,0(a0)
    80004c20:	c385                	beqz	a5,80004c40 <argfd+0x54>
    return -1;
  if(pfd)
    80004c22:	00090463          	beqz	s2,80004c2a <argfd+0x3e>
    *pfd = fd;
    80004c26:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004c2a:	4501                	li	a0,0
  if(pf)
    80004c2c:	c091                	beqz	s1,80004c30 <argfd+0x44>
    *pf = f;
    80004c2e:	e09c                	sd	a5,0(s1)
}
    80004c30:	70a2                	ld	ra,40(sp)
    80004c32:	7402                	ld	s0,32(sp)
    80004c34:	64e2                	ld	s1,24(sp)
    80004c36:	6942                	ld	s2,16(sp)
    80004c38:	6145                	addi	sp,sp,48
    80004c3a:	8082                	ret
    return -1;
    80004c3c:	557d                	li	a0,-1
    80004c3e:	bfcd                	j	80004c30 <argfd+0x44>
    80004c40:	557d                	li	a0,-1
    80004c42:	b7fd                	j	80004c30 <argfd+0x44>

0000000080004c44 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004c44:	1101                	addi	sp,sp,-32
    80004c46:	ec06                	sd	ra,24(sp)
    80004c48:	e822                	sd	s0,16(sp)
    80004c4a:	e426                	sd	s1,8(sp)
    80004c4c:	1000                	addi	s0,sp,32
    80004c4e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004c50:	c8dfc0ef          	jal	800018dc <myproc>
    80004c54:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004c56:	0f050793          	addi	a5,a0,240
    80004c5a:	4501                	li	a0,0
    80004c5c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004c5e:	6398                	ld	a4,0(a5)
    80004c60:	cb19                	beqz	a4,80004c76 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004c62:	2505                	addiw	a0,a0,1
    80004c64:	07a1                	addi	a5,a5,8
    80004c66:	fed51ce3          	bne	a0,a3,80004c5e <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004c6a:	557d                	li	a0,-1
}
    80004c6c:	60e2                	ld	ra,24(sp)
    80004c6e:	6442                	ld	s0,16(sp)
    80004c70:	64a2                	ld	s1,8(sp)
    80004c72:	6105                	addi	sp,sp,32
    80004c74:	8082                	ret
      p->ofile[fd] = f;
    80004c76:	01e50793          	addi	a5,a0,30
    80004c7a:	078e                	slli	a5,a5,0x3
    80004c7c:	963e                	add	a2,a2,a5
    80004c7e:	e204                	sd	s1,0(a2)
      return fd;
    80004c80:	b7f5                	j	80004c6c <fdalloc+0x28>

0000000080004c82 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004c82:	715d                	addi	sp,sp,-80
    80004c84:	e486                	sd	ra,72(sp)
    80004c86:	e0a2                	sd	s0,64(sp)
    80004c88:	fc26                	sd	s1,56(sp)
    80004c8a:	f84a                	sd	s2,48(sp)
    80004c8c:	f44e                	sd	s3,40(sp)
    80004c8e:	ec56                	sd	s5,24(sp)
    80004c90:	e85a                	sd	s6,16(sp)
    80004c92:	0880                	addi	s0,sp,80
    80004c94:	8b2e                	mv	s6,a1
    80004c96:	89b2                	mv	s3,a2
    80004c98:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004c9a:	fb040593          	addi	a1,s0,-80
    80004c9e:	ffdfe0ef          	jal	80003c9a <nameiparent>
    80004ca2:	84aa                	mv	s1,a0
    80004ca4:	10050a63          	beqz	a0,80004db8 <create+0x136>
    return 0;

  ilock(dp);
    80004ca8:	8e9fe0ef          	jal	80003590 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004cac:	4601                	li	a2,0
    80004cae:	fb040593          	addi	a1,s0,-80
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	d41fe0ef          	jal	800039f4 <dirlookup>
    80004cb8:	8aaa                	mv	s5,a0
    80004cba:	c129                	beqz	a0,80004cfc <create+0x7a>
    iunlockput(dp);
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	addfe0ef          	jal	8000379a <iunlockput>
    ilock(ip);
    80004cc2:	8556                	mv	a0,s5
    80004cc4:	8cdfe0ef          	jal	80003590 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004cc8:	4789                	li	a5,2
    80004cca:	02fb1463          	bne	s6,a5,80004cf2 <create+0x70>
    80004cce:	044ad783          	lhu	a5,68(s5)
    80004cd2:	37f9                	addiw	a5,a5,-2
    80004cd4:	17c2                	slli	a5,a5,0x30
    80004cd6:	93c1                	srli	a5,a5,0x30
    80004cd8:	4705                	li	a4,1
    80004cda:	00f76c63          	bltu	a4,a5,80004cf2 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004cde:	8556                	mv	a0,s5
    80004ce0:	60a6                	ld	ra,72(sp)
    80004ce2:	6406                	ld	s0,64(sp)
    80004ce4:	74e2                	ld	s1,56(sp)
    80004ce6:	7942                	ld	s2,48(sp)
    80004ce8:	79a2                	ld	s3,40(sp)
    80004cea:	6ae2                	ld	s5,24(sp)
    80004cec:	6b42                	ld	s6,16(sp)
    80004cee:	6161                	addi	sp,sp,80
    80004cf0:	8082                	ret
    iunlockput(ip);
    80004cf2:	8556                	mv	a0,s5
    80004cf4:	aa7fe0ef          	jal	8000379a <iunlockput>
    return 0;
    80004cf8:	4a81                	li	s5,0
    80004cfa:	b7d5                	j	80004cde <create+0x5c>
    80004cfc:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004cfe:	85da                	mv	a1,s6
    80004d00:	4088                	lw	a0,0(s1)
    80004d02:	f1efe0ef          	jal	80003420 <ialloc>
    80004d06:	8a2a                	mv	s4,a0
    80004d08:	cd15                	beqz	a0,80004d44 <create+0xc2>
  ilock(ip);
    80004d0a:	887fe0ef          	jal	80003590 <ilock>
  ip->major = major;
    80004d0e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004d12:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004d16:	4905                	li	s2,1
    80004d18:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004d1c:	8552                	mv	a0,s4
    80004d1e:	fbefe0ef          	jal	800034dc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004d22:	032b0763          	beq	s6,s2,80004d50 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d26:	004a2603          	lw	a2,4(s4)
    80004d2a:	fb040593          	addi	a1,s0,-80
    80004d2e:	8526                	mv	a0,s1
    80004d30:	ea7fe0ef          	jal	80003bd6 <dirlink>
    80004d34:	06054563          	bltz	a0,80004d9e <create+0x11c>
  iunlockput(dp);
    80004d38:	8526                	mv	a0,s1
    80004d3a:	a61fe0ef          	jal	8000379a <iunlockput>
  return ip;
    80004d3e:	8ad2                	mv	s5,s4
    80004d40:	7a02                	ld	s4,32(sp)
    80004d42:	bf71                	j	80004cde <create+0x5c>
    iunlockput(dp);
    80004d44:	8526                	mv	a0,s1
    80004d46:	a55fe0ef          	jal	8000379a <iunlockput>
    return 0;
    80004d4a:	8ad2                	mv	s5,s4
    80004d4c:	7a02                	ld	s4,32(sp)
    80004d4e:	bf41                	j	80004cde <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004d50:	004a2603          	lw	a2,4(s4)
    80004d54:	00003597          	auipc	a1,0x3
    80004d58:	c6458593          	addi	a1,a1,-924 # 800079b8 <etext+0x9b8>
    80004d5c:	8552                	mv	a0,s4
    80004d5e:	e79fe0ef          	jal	80003bd6 <dirlink>
    80004d62:	02054e63          	bltz	a0,80004d9e <create+0x11c>
    80004d66:	40d0                	lw	a2,4(s1)
    80004d68:	00003597          	auipc	a1,0x3
    80004d6c:	c5858593          	addi	a1,a1,-936 # 800079c0 <etext+0x9c0>
    80004d70:	8552                	mv	a0,s4
    80004d72:	e65fe0ef          	jal	80003bd6 <dirlink>
    80004d76:	02054463          	bltz	a0,80004d9e <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d7a:	004a2603          	lw	a2,4(s4)
    80004d7e:	fb040593          	addi	a1,s0,-80
    80004d82:	8526                	mv	a0,s1
    80004d84:	e53fe0ef          	jal	80003bd6 <dirlink>
    80004d88:	00054b63          	bltz	a0,80004d9e <create+0x11c>
    dp->nlink++;  // for ".."
    80004d8c:	04a4d783          	lhu	a5,74(s1)
    80004d90:	2785                	addiw	a5,a5,1
    80004d92:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d96:	8526                	mv	a0,s1
    80004d98:	f44fe0ef          	jal	800034dc <iupdate>
    80004d9c:	bf71                	j	80004d38 <create+0xb6>
  ip->nlink = 0;
    80004d9e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004da2:	8552                	mv	a0,s4
    80004da4:	f38fe0ef          	jal	800034dc <iupdate>
  iunlockput(ip);
    80004da8:	8552                	mv	a0,s4
    80004daa:	9f1fe0ef          	jal	8000379a <iunlockput>
  iunlockput(dp);
    80004dae:	8526                	mv	a0,s1
    80004db0:	9ebfe0ef          	jal	8000379a <iunlockput>
  return 0;
    80004db4:	7a02                	ld	s4,32(sp)
    80004db6:	b725                	j	80004cde <create+0x5c>
    return 0;
    80004db8:	8aaa                	mv	s5,a0
    80004dba:	b715                	j	80004cde <create+0x5c>

0000000080004dbc <sys_dup>:
{
    80004dbc:	7179                	addi	sp,sp,-48
    80004dbe:	f406                	sd	ra,40(sp)
    80004dc0:	f022                	sd	s0,32(sp)
    80004dc2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004dc4:	fd840613          	addi	a2,s0,-40
    80004dc8:	4581                	li	a1,0
    80004dca:	4501                	li	a0,0
    80004dcc:	e21ff0ef          	jal	80004bec <argfd>
    return -1;
    80004dd0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004dd2:	02054363          	bltz	a0,80004df8 <sys_dup+0x3c>
    80004dd6:	ec26                	sd	s1,24(sp)
    80004dd8:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004dda:	fd843903          	ld	s2,-40(s0)
    80004dde:	854a                	mv	a0,s2
    80004de0:	e65ff0ef          	jal	80004c44 <fdalloc>
    80004de4:	84aa                	mv	s1,a0
    return -1;
    80004de6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004de8:	00054d63          	bltz	a0,80004e02 <sys_dup+0x46>
  filedup(f);
    80004dec:	854a                	mv	a0,s2
    80004dee:	c2eff0ef          	jal	8000421c <filedup>
  return fd;
    80004df2:	87a6                	mv	a5,s1
    80004df4:	64e2                	ld	s1,24(sp)
    80004df6:	6942                	ld	s2,16(sp)
}
    80004df8:	853e                	mv	a0,a5
    80004dfa:	70a2                	ld	ra,40(sp)
    80004dfc:	7402                	ld	s0,32(sp)
    80004dfe:	6145                	addi	sp,sp,48
    80004e00:	8082                	ret
    80004e02:	64e2                	ld	s1,24(sp)
    80004e04:	6942                	ld	s2,16(sp)
    80004e06:	bfcd                	j	80004df8 <sys_dup+0x3c>

0000000080004e08 <sys_read>:
{
    80004e08:	7179                	addi	sp,sp,-48
    80004e0a:	f406                	sd	ra,40(sp)
    80004e0c:	f022                	sd	s0,32(sp)
    80004e0e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e10:	fd840593          	addi	a1,s0,-40
    80004e14:	4505                	li	a0,1
    80004e16:	ce7fd0ef          	jal	80002afc <argaddr>
  argint(2, &n);
    80004e1a:	fe440593          	addi	a1,s0,-28
    80004e1e:	4509                	li	a0,2
    80004e20:	cc1fd0ef          	jal	80002ae0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004e24:	fe840613          	addi	a2,s0,-24
    80004e28:	4581                	li	a1,0
    80004e2a:	4501                	li	a0,0
    80004e2c:	dc1ff0ef          	jal	80004bec <argfd>
    80004e30:	87aa                	mv	a5,a0
    return -1;
    80004e32:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e34:	0007ca63          	bltz	a5,80004e48 <sys_read+0x40>
  return fileread(f, p, n);
    80004e38:	fe442603          	lw	a2,-28(s0)
    80004e3c:	fd843583          	ld	a1,-40(s0)
    80004e40:	fe843503          	ld	a0,-24(s0)
    80004e44:	d3eff0ef          	jal	80004382 <fileread>
}
    80004e48:	70a2                	ld	ra,40(sp)
    80004e4a:	7402                	ld	s0,32(sp)
    80004e4c:	6145                	addi	sp,sp,48
    80004e4e:	8082                	ret

0000000080004e50 <sys_write>:
{
    80004e50:	7179                	addi	sp,sp,-48
    80004e52:	f406                	sd	ra,40(sp)
    80004e54:	f022                	sd	s0,32(sp)
    80004e56:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e58:	fd840593          	addi	a1,s0,-40
    80004e5c:	4505                	li	a0,1
    80004e5e:	c9ffd0ef          	jal	80002afc <argaddr>
  argint(2, &n);
    80004e62:	fe440593          	addi	a1,s0,-28
    80004e66:	4509                	li	a0,2
    80004e68:	c79fd0ef          	jal	80002ae0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004e6c:	fe840613          	addi	a2,s0,-24
    80004e70:	4581                	li	a1,0
    80004e72:	4501                	li	a0,0
    80004e74:	d79ff0ef          	jal	80004bec <argfd>
    80004e78:	87aa                	mv	a5,a0
    return -1;
    80004e7a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e7c:	0007ca63          	bltz	a5,80004e90 <sys_write+0x40>
  return filewrite(f, p, n);
    80004e80:	fe442603          	lw	a2,-28(s0)
    80004e84:	fd843583          	ld	a1,-40(s0)
    80004e88:	fe843503          	ld	a0,-24(s0)
    80004e8c:	db4ff0ef          	jal	80004440 <filewrite>
}
    80004e90:	70a2                	ld	ra,40(sp)
    80004e92:	7402                	ld	s0,32(sp)
    80004e94:	6145                	addi	sp,sp,48
    80004e96:	8082                	ret

0000000080004e98 <sys_close>:
{
    80004e98:	1101                	addi	sp,sp,-32
    80004e9a:	ec06                	sd	ra,24(sp)
    80004e9c:	e822                	sd	s0,16(sp)
    80004e9e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ea0:	fe040613          	addi	a2,s0,-32
    80004ea4:	fec40593          	addi	a1,s0,-20
    80004ea8:	4501                	li	a0,0
    80004eaa:	d43ff0ef          	jal	80004bec <argfd>
    return -1;
    80004eae:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004eb0:	02054063          	bltz	a0,80004ed0 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004eb4:	a29fc0ef          	jal	800018dc <myproc>
    80004eb8:	fec42783          	lw	a5,-20(s0)
    80004ebc:	07f9                	addi	a5,a5,30
    80004ebe:	078e                	slli	a5,a5,0x3
    80004ec0:	953e                	add	a0,a0,a5
    80004ec2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ec6:	fe043503          	ld	a0,-32(s0)
    80004eca:	b98ff0ef          	jal	80004262 <fileclose>
  return 0;
    80004ece:	4781                	li	a5,0
}
    80004ed0:	853e                	mv	a0,a5
    80004ed2:	60e2                	ld	ra,24(sp)
    80004ed4:	6442                	ld	s0,16(sp)
    80004ed6:	6105                	addi	sp,sp,32
    80004ed8:	8082                	ret

0000000080004eda <sys_fstat>:
{
    80004eda:	1101                	addi	sp,sp,-32
    80004edc:	ec06                	sd	ra,24(sp)
    80004ede:	e822                	sd	s0,16(sp)
    80004ee0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004ee2:	fe040593          	addi	a1,s0,-32
    80004ee6:	4505                	li	a0,1
    80004ee8:	c15fd0ef          	jal	80002afc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004eec:	fe840613          	addi	a2,s0,-24
    80004ef0:	4581                	li	a1,0
    80004ef2:	4501                	li	a0,0
    80004ef4:	cf9ff0ef          	jal	80004bec <argfd>
    80004ef8:	87aa                	mv	a5,a0
    return -1;
    80004efa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004efc:	0007c863          	bltz	a5,80004f0c <sys_fstat+0x32>
  return filestat(f, st);
    80004f00:	fe043583          	ld	a1,-32(s0)
    80004f04:	fe843503          	ld	a0,-24(s0)
    80004f08:	c18ff0ef          	jal	80004320 <filestat>
}
    80004f0c:	60e2                	ld	ra,24(sp)
    80004f0e:	6442                	ld	s0,16(sp)
    80004f10:	6105                	addi	sp,sp,32
    80004f12:	8082                	ret

0000000080004f14 <sys_link>:
{
    80004f14:	7169                	addi	sp,sp,-304
    80004f16:	f606                	sd	ra,296(sp)
    80004f18:	f222                	sd	s0,288(sp)
    80004f1a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f1c:	08000613          	li	a2,128
    80004f20:	ed040593          	addi	a1,s0,-304
    80004f24:	4501                	li	a0,0
    80004f26:	bf3fd0ef          	jal	80002b18 <argstr>
    return -1;
    80004f2a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f2c:	0c054e63          	bltz	a0,80005008 <sys_link+0xf4>
    80004f30:	08000613          	li	a2,128
    80004f34:	f5040593          	addi	a1,s0,-176
    80004f38:	4505                	li	a0,1
    80004f3a:	bdffd0ef          	jal	80002b18 <argstr>
    return -1;
    80004f3e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f40:	0c054463          	bltz	a0,80005008 <sys_link+0xf4>
    80004f44:	ee26                	sd	s1,280(sp)
  begin_op();
    80004f46:	efdfe0ef          	jal	80003e42 <begin_op>
  if((ip = namei(old)) == 0){
    80004f4a:	ed040513          	addi	a0,s0,-304
    80004f4e:	d33fe0ef          	jal	80003c80 <namei>
    80004f52:	84aa                	mv	s1,a0
    80004f54:	c53d                	beqz	a0,80004fc2 <sys_link+0xae>
  ilock(ip);
    80004f56:	e3afe0ef          	jal	80003590 <ilock>
  if(ip->type == T_DIR){
    80004f5a:	04449703          	lh	a4,68(s1)
    80004f5e:	4785                	li	a5,1
    80004f60:	06f70663          	beq	a4,a5,80004fcc <sys_link+0xb8>
    80004f64:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004f66:	04a4d783          	lhu	a5,74(s1)
    80004f6a:	2785                	addiw	a5,a5,1
    80004f6c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f70:	8526                	mv	a0,s1
    80004f72:	d6afe0ef          	jal	800034dc <iupdate>
  iunlock(ip);
    80004f76:	8526                	mv	a0,s1
    80004f78:	ec6fe0ef          	jal	8000363e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004f7c:	fd040593          	addi	a1,s0,-48
    80004f80:	f5040513          	addi	a0,s0,-176
    80004f84:	d17fe0ef          	jal	80003c9a <nameiparent>
    80004f88:	892a                	mv	s2,a0
    80004f8a:	cd21                	beqz	a0,80004fe2 <sys_link+0xce>
  ilock(dp);
    80004f8c:	e04fe0ef          	jal	80003590 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004f90:	00092703          	lw	a4,0(s2)
    80004f94:	409c                	lw	a5,0(s1)
    80004f96:	04f71363          	bne	a4,a5,80004fdc <sys_link+0xc8>
    80004f9a:	40d0                	lw	a2,4(s1)
    80004f9c:	fd040593          	addi	a1,s0,-48
    80004fa0:	854a                	mv	a0,s2
    80004fa2:	c35fe0ef          	jal	80003bd6 <dirlink>
    80004fa6:	02054b63          	bltz	a0,80004fdc <sys_link+0xc8>
  iunlockput(dp);
    80004faa:	854a                	mv	a0,s2
    80004fac:	feefe0ef          	jal	8000379a <iunlockput>
  iput(ip);
    80004fb0:	8526                	mv	a0,s1
    80004fb2:	f60fe0ef          	jal	80003712 <iput>
  end_op();
    80004fb6:	ef7fe0ef          	jal	80003eac <end_op>
  return 0;
    80004fba:	4781                	li	a5,0
    80004fbc:	64f2                	ld	s1,280(sp)
    80004fbe:	6952                	ld	s2,272(sp)
    80004fc0:	a0a1                	j	80005008 <sys_link+0xf4>
    end_op();
    80004fc2:	eebfe0ef          	jal	80003eac <end_op>
    return -1;
    80004fc6:	57fd                	li	a5,-1
    80004fc8:	64f2                	ld	s1,280(sp)
    80004fca:	a83d                	j	80005008 <sys_link+0xf4>
    iunlockput(ip);
    80004fcc:	8526                	mv	a0,s1
    80004fce:	fccfe0ef          	jal	8000379a <iunlockput>
    end_op();
    80004fd2:	edbfe0ef          	jal	80003eac <end_op>
    return -1;
    80004fd6:	57fd                	li	a5,-1
    80004fd8:	64f2                	ld	s1,280(sp)
    80004fda:	a03d                	j	80005008 <sys_link+0xf4>
    iunlockput(dp);
    80004fdc:	854a                	mv	a0,s2
    80004fde:	fbcfe0ef          	jal	8000379a <iunlockput>
  ilock(ip);
    80004fe2:	8526                	mv	a0,s1
    80004fe4:	dacfe0ef          	jal	80003590 <ilock>
  ip->nlink--;
    80004fe8:	04a4d783          	lhu	a5,74(s1)
    80004fec:	37fd                	addiw	a5,a5,-1
    80004fee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ff2:	8526                	mv	a0,s1
    80004ff4:	ce8fe0ef          	jal	800034dc <iupdate>
  iunlockput(ip);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	fa0fe0ef          	jal	8000379a <iunlockput>
  end_op();
    80004ffe:	eaffe0ef          	jal	80003eac <end_op>
  return -1;
    80005002:	57fd                	li	a5,-1
    80005004:	64f2                	ld	s1,280(sp)
    80005006:	6952                	ld	s2,272(sp)
}
    80005008:	853e                	mv	a0,a5
    8000500a:	70b2                	ld	ra,296(sp)
    8000500c:	7412                	ld	s0,288(sp)
    8000500e:	6155                	addi	sp,sp,304
    80005010:	8082                	ret

0000000080005012 <sys_unlink>:
{
    80005012:	7111                	addi	sp,sp,-256
    80005014:	fd86                	sd	ra,248(sp)
    80005016:	f9a2                	sd	s0,240(sp)
    80005018:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    8000501a:	08000613          	li	a2,128
    8000501e:	f2040593          	addi	a1,s0,-224
    80005022:	4501                	li	a0,0
    80005024:	af5fd0ef          	jal	80002b18 <argstr>
    80005028:	16054663          	bltz	a0,80005194 <sys_unlink+0x182>
    8000502c:	f5a6                	sd	s1,232(sp)
  begin_op();
    8000502e:	e15fe0ef          	jal	80003e42 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005032:	fa040593          	addi	a1,s0,-96
    80005036:	f2040513          	addi	a0,s0,-224
    8000503a:	c61fe0ef          	jal	80003c9a <nameiparent>
    8000503e:	84aa                	mv	s1,a0
    80005040:	c955                	beqz	a0,800050f4 <sys_unlink+0xe2>
  ilock(dp);
    80005042:	d4efe0ef          	jal	80003590 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005046:	00003597          	auipc	a1,0x3
    8000504a:	97258593          	addi	a1,a1,-1678 # 800079b8 <etext+0x9b8>
    8000504e:	fa040513          	addi	a0,s0,-96
    80005052:	98dfe0ef          	jal	800039de <namecmp>
    80005056:	12050463          	beqz	a0,8000517e <sys_unlink+0x16c>
    8000505a:	00003597          	auipc	a1,0x3
    8000505e:	96658593          	addi	a1,a1,-1690 # 800079c0 <etext+0x9c0>
    80005062:	fa040513          	addi	a0,s0,-96
    80005066:	979fe0ef          	jal	800039de <namecmp>
    8000506a:	10050a63          	beqz	a0,8000517e <sys_unlink+0x16c>
    8000506e:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005070:	f1c40613          	addi	a2,s0,-228
    80005074:	fa040593          	addi	a1,s0,-96
    80005078:	8526                	mv	a0,s1
    8000507a:	97bfe0ef          	jal	800039f4 <dirlookup>
    8000507e:	892a                	mv	s2,a0
    80005080:	0e050e63          	beqz	a0,8000517c <sys_unlink+0x16a>
    80005084:	edce                	sd	s3,216(sp)
  ilock(ip);
    80005086:	d0afe0ef          	jal	80003590 <ilock>
  if(ip->nlink < 1)
    8000508a:	04a91783          	lh	a5,74(s2)
    8000508e:	06f05863          	blez	a5,800050fe <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005092:	04491703          	lh	a4,68(s2)
    80005096:	4785                	li	a5,1
    80005098:	06f70b63          	beq	a4,a5,8000510e <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    8000509c:	fb040993          	addi	s3,s0,-80
    800050a0:	4641                	li	a2,16
    800050a2:	4581                	li	a1,0
    800050a4:	854e                	mv	a0,s3
    800050a6:	c29fb0ef          	jal	80000cce <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800050aa:	4741                	li	a4,16
    800050ac:	f1c42683          	lw	a3,-228(s0)
    800050b0:	864e                	mv	a2,s3
    800050b2:	4581                	li	a1,0
    800050b4:	8526                	mv	a0,s1
    800050b6:	825fe0ef          	jal	800038da <writei>
    800050ba:	47c1                	li	a5,16
    800050bc:	08f51f63          	bne	a0,a5,8000515a <sys_unlink+0x148>
  if(ip->type == T_DIR){
    800050c0:	04491703          	lh	a4,68(s2)
    800050c4:	4785                	li	a5,1
    800050c6:	0af70263          	beq	a4,a5,8000516a <sys_unlink+0x158>
  iunlockput(dp);
    800050ca:	8526                	mv	a0,s1
    800050cc:	ecefe0ef          	jal	8000379a <iunlockput>
  ip->nlink--;
    800050d0:	04a95783          	lhu	a5,74(s2)
    800050d4:	37fd                	addiw	a5,a5,-1
    800050d6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800050da:	854a                	mv	a0,s2
    800050dc:	c00fe0ef          	jal	800034dc <iupdate>
  iunlockput(ip);
    800050e0:	854a                	mv	a0,s2
    800050e2:	eb8fe0ef          	jal	8000379a <iunlockput>
  end_op();
    800050e6:	dc7fe0ef          	jal	80003eac <end_op>
  return 0;
    800050ea:	4501                	li	a0,0
    800050ec:	74ae                	ld	s1,232(sp)
    800050ee:	790e                	ld	s2,224(sp)
    800050f0:	69ee                	ld	s3,216(sp)
    800050f2:	a869                	j	8000518c <sys_unlink+0x17a>
    end_op();
    800050f4:	db9fe0ef          	jal	80003eac <end_op>
    return -1;
    800050f8:	557d                	li	a0,-1
    800050fa:	74ae                	ld	s1,232(sp)
    800050fc:	a841                	j	8000518c <sys_unlink+0x17a>
    800050fe:	e9d2                	sd	s4,208(sp)
    80005100:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80005102:	00003517          	auipc	a0,0x3
    80005106:	8c650513          	addi	a0,a0,-1850 # 800079c8 <etext+0x9c8>
    8000510a:	e94fb0ef          	jal	8000079e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000510e:	04c92703          	lw	a4,76(s2)
    80005112:	02000793          	li	a5,32
    80005116:	f8e7f3e3          	bgeu	a5,a4,8000509c <sys_unlink+0x8a>
    8000511a:	e9d2                	sd	s4,208(sp)
    8000511c:	e5d6                	sd	s5,200(sp)
    8000511e:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005120:	f0840a93          	addi	s5,s0,-248
    80005124:	4a41                	li	s4,16
    80005126:	8752                	mv	a4,s4
    80005128:	86ce                	mv	a3,s3
    8000512a:	8656                	mv	a2,s5
    8000512c:	4581                	li	a1,0
    8000512e:	854a                	mv	a0,s2
    80005130:	eb8fe0ef          	jal	800037e8 <readi>
    80005134:	01451d63          	bne	a0,s4,8000514e <sys_unlink+0x13c>
    if(de.inum != 0)
    80005138:	f0845783          	lhu	a5,-248(s0)
    8000513c:	efb1                	bnez	a5,80005198 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000513e:	29c1                	addiw	s3,s3,16
    80005140:	04c92783          	lw	a5,76(s2)
    80005144:	fef9e1e3          	bltu	s3,a5,80005126 <sys_unlink+0x114>
    80005148:	6a4e                	ld	s4,208(sp)
    8000514a:	6aae                	ld	s5,200(sp)
    8000514c:	bf81                	j	8000509c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000514e:	00003517          	auipc	a0,0x3
    80005152:	89250513          	addi	a0,a0,-1902 # 800079e0 <etext+0x9e0>
    80005156:	e48fb0ef          	jal	8000079e <panic>
    8000515a:	e9d2                	sd	s4,208(sp)
    8000515c:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    8000515e:	00003517          	auipc	a0,0x3
    80005162:	89a50513          	addi	a0,a0,-1894 # 800079f8 <etext+0x9f8>
    80005166:	e38fb0ef          	jal	8000079e <panic>
    dp->nlink--;
    8000516a:	04a4d783          	lhu	a5,74(s1)
    8000516e:	37fd                	addiw	a5,a5,-1
    80005170:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005174:	8526                	mv	a0,s1
    80005176:	b66fe0ef          	jal	800034dc <iupdate>
    8000517a:	bf81                	j	800050ca <sys_unlink+0xb8>
    8000517c:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    8000517e:	8526                	mv	a0,s1
    80005180:	e1afe0ef          	jal	8000379a <iunlockput>
  end_op();
    80005184:	d29fe0ef          	jal	80003eac <end_op>
  return -1;
    80005188:	557d                	li	a0,-1
    8000518a:	74ae                	ld	s1,232(sp)
}
    8000518c:	70ee                	ld	ra,248(sp)
    8000518e:	744e                	ld	s0,240(sp)
    80005190:	6111                	addi	sp,sp,256
    80005192:	8082                	ret
    return -1;
    80005194:	557d                	li	a0,-1
    80005196:	bfdd                	j	8000518c <sys_unlink+0x17a>
    iunlockput(ip);
    80005198:	854a                	mv	a0,s2
    8000519a:	e00fe0ef          	jal	8000379a <iunlockput>
    goto bad;
    8000519e:	790e                	ld	s2,224(sp)
    800051a0:	69ee                	ld	s3,216(sp)
    800051a2:	6a4e                	ld	s4,208(sp)
    800051a4:	6aae                	ld	s5,200(sp)
    800051a6:	bfe1                	j	8000517e <sys_unlink+0x16c>

00000000800051a8 <sys_open>:

uint64
sys_open(void)
{
    800051a8:	7131                	addi	sp,sp,-192
    800051aa:	fd06                	sd	ra,184(sp)
    800051ac:	f922                	sd	s0,176(sp)
    800051ae:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800051b0:	f4c40593          	addi	a1,s0,-180
    800051b4:	4505                	li	a0,1
    800051b6:	92bfd0ef          	jal	80002ae0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800051ba:	08000613          	li	a2,128
    800051be:	f5040593          	addi	a1,s0,-176
    800051c2:	4501                	li	a0,0
    800051c4:	955fd0ef          	jal	80002b18 <argstr>
    800051c8:	87aa                	mv	a5,a0
    return -1;
    800051ca:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800051cc:	0a07c363          	bltz	a5,80005272 <sys_open+0xca>
    800051d0:	f526                	sd	s1,168(sp)

  begin_op();
    800051d2:	c71fe0ef          	jal	80003e42 <begin_op>

  if(omode & O_CREATE){
    800051d6:	f4c42783          	lw	a5,-180(s0)
    800051da:	2007f793          	andi	a5,a5,512
    800051de:	c3dd                	beqz	a5,80005284 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800051e0:	4681                	li	a3,0
    800051e2:	4601                	li	a2,0
    800051e4:	4589                	li	a1,2
    800051e6:	f5040513          	addi	a0,s0,-176
    800051ea:	a99ff0ef          	jal	80004c82 <create>
    800051ee:	84aa                	mv	s1,a0
    if(ip == 0){
    800051f0:	c549                	beqz	a0,8000527a <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800051f2:	04449703          	lh	a4,68(s1)
    800051f6:	478d                	li	a5,3
    800051f8:	00f71763          	bne	a4,a5,80005206 <sys_open+0x5e>
    800051fc:	0464d703          	lhu	a4,70(s1)
    80005200:	47a5                	li	a5,9
    80005202:	0ae7ee63          	bltu	a5,a4,800052be <sys_open+0x116>
    80005206:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005208:	fb7fe0ef          	jal	800041be <filealloc>
    8000520c:	892a                	mv	s2,a0
    8000520e:	c561                	beqz	a0,800052d6 <sys_open+0x12e>
    80005210:	ed4e                	sd	s3,152(sp)
    80005212:	a33ff0ef          	jal	80004c44 <fdalloc>
    80005216:	89aa                	mv	s3,a0
    80005218:	0a054b63          	bltz	a0,800052ce <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000521c:	04449703          	lh	a4,68(s1)
    80005220:	478d                	li	a5,3
    80005222:	0cf70363          	beq	a4,a5,800052e8 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005226:	4789                	li	a5,2
    80005228:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000522c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005230:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005234:	f4c42783          	lw	a5,-180(s0)
    80005238:	0017f713          	andi	a4,a5,1
    8000523c:	00174713          	xori	a4,a4,1
    80005240:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005244:	0037f713          	andi	a4,a5,3
    80005248:	00e03733          	snez	a4,a4
    8000524c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005250:	4007f793          	andi	a5,a5,1024
    80005254:	c791                	beqz	a5,80005260 <sys_open+0xb8>
    80005256:	04449703          	lh	a4,68(s1)
    8000525a:	4789                	li	a5,2
    8000525c:	08f70d63          	beq	a4,a5,800052f6 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005260:	8526                	mv	a0,s1
    80005262:	bdcfe0ef          	jal	8000363e <iunlock>
  end_op();
    80005266:	c47fe0ef          	jal	80003eac <end_op>

  return fd;
    8000526a:	854e                	mv	a0,s3
    8000526c:	74aa                	ld	s1,168(sp)
    8000526e:	790a                	ld	s2,160(sp)
    80005270:	69ea                	ld	s3,152(sp)
}
    80005272:	70ea                	ld	ra,184(sp)
    80005274:	744a                	ld	s0,176(sp)
    80005276:	6129                	addi	sp,sp,192
    80005278:	8082                	ret
      end_op();
    8000527a:	c33fe0ef          	jal	80003eac <end_op>
      return -1;
    8000527e:	557d                	li	a0,-1
    80005280:	74aa                	ld	s1,168(sp)
    80005282:	bfc5                	j	80005272 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80005284:	f5040513          	addi	a0,s0,-176
    80005288:	9f9fe0ef          	jal	80003c80 <namei>
    8000528c:	84aa                	mv	s1,a0
    8000528e:	c11d                	beqz	a0,800052b4 <sys_open+0x10c>
    ilock(ip);
    80005290:	b00fe0ef          	jal	80003590 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005294:	04449703          	lh	a4,68(s1)
    80005298:	4785                	li	a5,1
    8000529a:	f4f71ce3          	bne	a4,a5,800051f2 <sys_open+0x4a>
    8000529e:	f4c42783          	lw	a5,-180(s0)
    800052a2:	d3b5                	beqz	a5,80005206 <sys_open+0x5e>
      iunlockput(ip);
    800052a4:	8526                	mv	a0,s1
    800052a6:	cf4fe0ef          	jal	8000379a <iunlockput>
      end_op();
    800052aa:	c03fe0ef          	jal	80003eac <end_op>
      return -1;
    800052ae:	557d                	li	a0,-1
    800052b0:	74aa                	ld	s1,168(sp)
    800052b2:	b7c1                	j	80005272 <sys_open+0xca>
      end_op();
    800052b4:	bf9fe0ef          	jal	80003eac <end_op>
      return -1;
    800052b8:	557d                	li	a0,-1
    800052ba:	74aa                	ld	s1,168(sp)
    800052bc:	bf5d                	j	80005272 <sys_open+0xca>
    iunlockput(ip);
    800052be:	8526                	mv	a0,s1
    800052c0:	cdafe0ef          	jal	8000379a <iunlockput>
    end_op();
    800052c4:	be9fe0ef          	jal	80003eac <end_op>
    return -1;
    800052c8:	557d                	li	a0,-1
    800052ca:	74aa                	ld	s1,168(sp)
    800052cc:	b75d                	j	80005272 <sys_open+0xca>
      fileclose(f);
    800052ce:	854a                	mv	a0,s2
    800052d0:	f93fe0ef          	jal	80004262 <fileclose>
    800052d4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800052d6:	8526                	mv	a0,s1
    800052d8:	cc2fe0ef          	jal	8000379a <iunlockput>
    end_op();
    800052dc:	bd1fe0ef          	jal	80003eac <end_op>
    return -1;
    800052e0:	557d                	li	a0,-1
    800052e2:	74aa                	ld	s1,168(sp)
    800052e4:	790a                	ld	s2,160(sp)
    800052e6:	b771                	j	80005272 <sys_open+0xca>
    f->type = FD_DEVICE;
    800052e8:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800052ec:	04649783          	lh	a5,70(s1)
    800052f0:	02f91223          	sh	a5,36(s2)
    800052f4:	bf35                	j	80005230 <sys_open+0x88>
    itrunc(ip);
    800052f6:	8526                	mv	a0,s1
    800052f8:	b86fe0ef          	jal	8000367e <itrunc>
    800052fc:	b795                	j	80005260 <sys_open+0xb8>

00000000800052fe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800052fe:	7175                	addi	sp,sp,-144
    80005300:	e506                	sd	ra,136(sp)
    80005302:	e122                	sd	s0,128(sp)
    80005304:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005306:	b3dfe0ef          	jal	80003e42 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000530a:	08000613          	li	a2,128
    8000530e:	f7040593          	addi	a1,s0,-144
    80005312:	4501                	li	a0,0
    80005314:	805fd0ef          	jal	80002b18 <argstr>
    80005318:	02054363          	bltz	a0,8000533e <sys_mkdir+0x40>
    8000531c:	4681                	li	a3,0
    8000531e:	4601                	li	a2,0
    80005320:	4585                	li	a1,1
    80005322:	f7040513          	addi	a0,s0,-144
    80005326:	95dff0ef          	jal	80004c82 <create>
    8000532a:	c911                	beqz	a0,8000533e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000532c:	c6efe0ef          	jal	8000379a <iunlockput>
  end_op();
    80005330:	b7dfe0ef          	jal	80003eac <end_op>
  return 0;
    80005334:	4501                	li	a0,0
}
    80005336:	60aa                	ld	ra,136(sp)
    80005338:	640a                	ld	s0,128(sp)
    8000533a:	6149                	addi	sp,sp,144
    8000533c:	8082                	ret
    end_op();
    8000533e:	b6ffe0ef          	jal	80003eac <end_op>
    return -1;
    80005342:	557d                	li	a0,-1
    80005344:	bfcd                	j	80005336 <sys_mkdir+0x38>

0000000080005346 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005346:	7135                	addi	sp,sp,-160
    80005348:	ed06                	sd	ra,152(sp)
    8000534a:	e922                	sd	s0,144(sp)
    8000534c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000534e:	af5fe0ef          	jal	80003e42 <begin_op>
  argint(1, &major);
    80005352:	f6c40593          	addi	a1,s0,-148
    80005356:	4505                	li	a0,1
    80005358:	f88fd0ef          	jal	80002ae0 <argint>
  argint(2, &minor);
    8000535c:	f6840593          	addi	a1,s0,-152
    80005360:	4509                	li	a0,2
    80005362:	f7efd0ef          	jal	80002ae0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005366:	08000613          	li	a2,128
    8000536a:	f7040593          	addi	a1,s0,-144
    8000536e:	4501                	li	a0,0
    80005370:	fa8fd0ef          	jal	80002b18 <argstr>
    80005374:	02054563          	bltz	a0,8000539e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005378:	f6841683          	lh	a3,-152(s0)
    8000537c:	f6c41603          	lh	a2,-148(s0)
    80005380:	458d                	li	a1,3
    80005382:	f7040513          	addi	a0,s0,-144
    80005386:	8fdff0ef          	jal	80004c82 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000538a:	c911                	beqz	a0,8000539e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000538c:	c0efe0ef          	jal	8000379a <iunlockput>
  end_op();
    80005390:	b1dfe0ef          	jal	80003eac <end_op>
  return 0;
    80005394:	4501                	li	a0,0
}
    80005396:	60ea                	ld	ra,152(sp)
    80005398:	644a                	ld	s0,144(sp)
    8000539a:	610d                	addi	sp,sp,160
    8000539c:	8082                	ret
    end_op();
    8000539e:	b0ffe0ef          	jal	80003eac <end_op>
    return -1;
    800053a2:	557d                	li	a0,-1
    800053a4:	bfcd                	j	80005396 <sys_mknod+0x50>

00000000800053a6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800053a6:	7135                	addi	sp,sp,-160
    800053a8:	ed06                	sd	ra,152(sp)
    800053aa:	e922                	sd	s0,144(sp)
    800053ac:	e14a                	sd	s2,128(sp)
    800053ae:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800053b0:	d2cfc0ef          	jal	800018dc <myproc>
    800053b4:	892a                	mv	s2,a0
  
  begin_op();
    800053b6:	a8dfe0ef          	jal	80003e42 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800053ba:	08000613          	li	a2,128
    800053be:	f6040593          	addi	a1,s0,-160
    800053c2:	4501                	li	a0,0
    800053c4:	f54fd0ef          	jal	80002b18 <argstr>
    800053c8:	04054363          	bltz	a0,8000540e <sys_chdir+0x68>
    800053cc:	e526                	sd	s1,136(sp)
    800053ce:	f6040513          	addi	a0,s0,-160
    800053d2:	8affe0ef          	jal	80003c80 <namei>
    800053d6:	84aa                	mv	s1,a0
    800053d8:	c915                	beqz	a0,8000540c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800053da:	9b6fe0ef          	jal	80003590 <ilock>
  if(ip->type != T_DIR){
    800053de:	04449703          	lh	a4,68(s1)
    800053e2:	4785                	li	a5,1
    800053e4:	02f71963          	bne	a4,a5,80005416 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800053e8:	8526                	mv	a0,s1
    800053ea:	a54fe0ef          	jal	8000363e <iunlock>
  iput(p->cwd);
    800053ee:	17093503          	ld	a0,368(s2)
    800053f2:	b20fe0ef          	jal	80003712 <iput>
  end_op();
    800053f6:	ab7fe0ef          	jal	80003eac <end_op>
  p->cwd = ip;
    800053fa:	16993823          	sd	s1,368(s2)
  return 0;
    800053fe:	4501                	li	a0,0
    80005400:	64aa                	ld	s1,136(sp)
}
    80005402:	60ea                	ld	ra,152(sp)
    80005404:	644a                	ld	s0,144(sp)
    80005406:	690a                	ld	s2,128(sp)
    80005408:	610d                	addi	sp,sp,160
    8000540a:	8082                	ret
    8000540c:	64aa                	ld	s1,136(sp)
    end_op();
    8000540e:	a9ffe0ef          	jal	80003eac <end_op>
    return -1;
    80005412:	557d                	li	a0,-1
    80005414:	b7fd                	j	80005402 <sys_chdir+0x5c>
    iunlockput(ip);
    80005416:	8526                	mv	a0,s1
    80005418:	b82fe0ef          	jal	8000379a <iunlockput>
    end_op();
    8000541c:	a91fe0ef          	jal	80003eac <end_op>
    return -1;
    80005420:	557d                	li	a0,-1
    80005422:	64aa                	ld	s1,136(sp)
    80005424:	bff9                	j	80005402 <sys_chdir+0x5c>

0000000080005426 <sys_exec>:

uint64
sys_exec(void)
{
    80005426:	7105                	addi	sp,sp,-480
    80005428:	ef86                	sd	ra,472(sp)
    8000542a:	eba2                	sd	s0,464(sp)
    8000542c:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000542e:	e2840593          	addi	a1,s0,-472
    80005432:	4505                	li	a0,1
    80005434:	ec8fd0ef          	jal	80002afc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005438:	08000613          	li	a2,128
    8000543c:	f3040593          	addi	a1,s0,-208
    80005440:	4501                	li	a0,0
    80005442:	ed6fd0ef          	jal	80002b18 <argstr>
    80005446:	87aa                	mv	a5,a0
    return -1;
    80005448:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000544a:	0e07c063          	bltz	a5,8000552a <sys_exec+0x104>
    8000544e:	e7a6                	sd	s1,456(sp)
    80005450:	e3ca                	sd	s2,448(sp)
    80005452:	ff4e                	sd	s3,440(sp)
    80005454:	fb52                	sd	s4,432(sp)
    80005456:	f756                	sd	s5,424(sp)
    80005458:	f35a                	sd	s6,416(sp)
    8000545a:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000545c:	e3040a13          	addi	s4,s0,-464
    80005460:	10000613          	li	a2,256
    80005464:	4581                	li	a1,0
    80005466:	8552                	mv	a0,s4
    80005468:	867fb0ef          	jal	80000cce <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000546c:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000546e:	89d2                	mv	s3,s4
    80005470:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005472:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005476:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005478:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000547c:	00391513          	slli	a0,s2,0x3
    80005480:	85d6                	mv	a1,s5
    80005482:	e2843783          	ld	a5,-472(s0)
    80005486:	953e                	add	a0,a0,a5
    80005488:	dcefd0ef          	jal	80002a56 <fetchaddr>
    8000548c:	02054663          	bltz	a0,800054b8 <sys_exec+0x92>
    if(uarg == 0){
    80005490:	e2043783          	ld	a5,-480(s0)
    80005494:	c7a1                	beqz	a5,800054dc <sys_exec+0xb6>
    argv[i] = kalloc();
    80005496:	e94fb0ef          	jal	80000b2a <kalloc>
    8000549a:	85aa                	mv	a1,a0
    8000549c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800054a0:	cd01                	beqz	a0,800054b8 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800054a2:	865a                	mv	a2,s6
    800054a4:	e2043503          	ld	a0,-480(s0)
    800054a8:	df8fd0ef          	jal	80002aa0 <fetchstr>
    800054ac:	00054663          	bltz	a0,800054b8 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800054b0:	0905                	addi	s2,s2,1
    800054b2:	09a1                	addi	s3,s3,8
    800054b4:	fd7914e3          	bne	s2,s7,8000547c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054b8:	100a0a13          	addi	s4,s4,256
    800054bc:	6088                	ld	a0,0(s1)
    800054be:	cd31                	beqz	a0,8000551a <sys_exec+0xf4>
    kfree(argv[i]);
    800054c0:	d88fb0ef          	jal	80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054c4:	04a1                	addi	s1,s1,8
    800054c6:	ff449be3          	bne	s1,s4,800054bc <sys_exec+0x96>
  return -1;
    800054ca:	557d                	li	a0,-1
    800054cc:	64be                	ld	s1,456(sp)
    800054ce:	691e                	ld	s2,448(sp)
    800054d0:	79fa                	ld	s3,440(sp)
    800054d2:	7a5a                	ld	s4,432(sp)
    800054d4:	7aba                	ld	s5,424(sp)
    800054d6:	7b1a                	ld	s6,416(sp)
    800054d8:	6bfa                	ld	s7,408(sp)
    800054da:	a881                	j	8000552a <sys_exec+0x104>
      argv[i] = 0;
    800054dc:	0009079b          	sext.w	a5,s2
    800054e0:	e3040593          	addi	a1,s0,-464
    800054e4:	078e                	slli	a5,a5,0x3
    800054e6:	97ae                	add	a5,a5,a1
    800054e8:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800054ec:	f3040513          	addi	a0,s0,-208
    800054f0:	ba4ff0ef          	jal	80004894 <exec>
    800054f4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054f6:	100a0a13          	addi	s4,s4,256
    800054fa:	6088                	ld	a0,0(s1)
    800054fc:	c511                	beqz	a0,80005508 <sys_exec+0xe2>
    kfree(argv[i]);
    800054fe:	d4afb0ef          	jal	80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005502:	04a1                	addi	s1,s1,8
    80005504:	ff449be3          	bne	s1,s4,800054fa <sys_exec+0xd4>
  return ret;
    80005508:	854a                	mv	a0,s2
    8000550a:	64be                	ld	s1,456(sp)
    8000550c:	691e                	ld	s2,448(sp)
    8000550e:	79fa                	ld	s3,440(sp)
    80005510:	7a5a                	ld	s4,432(sp)
    80005512:	7aba                	ld	s5,424(sp)
    80005514:	7b1a                	ld	s6,416(sp)
    80005516:	6bfa                	ld	s7,408(sp)
    80005518:	a809                	j	8000552a <sys_exec+0x104>
  return -1;
    8000551a:	557d                	li	a0,-1
    8000551c:	64be                	ld	s1,456(sp)
    8000551e:	691e                	ld	s2,448(sp)
    80005520:	79fa                	ld	s3,440(sp)
    80005522:	7a5a                	ld	s4,432(sp)
    80005524:	7aba                	ld	s5,424(sp)
    80005526:	7b1a                	ld	s6,416(sp)
    80005528:	6bfa                	ld	s7,408(sp)
}
    8000552a:	60fe                	ld	ra,472(sp)
    8000552c:	645e                	ld	s0,464(sp)
    8000552e:	613d                	addi	sp,sp,480
    80005530:	8082                	ret

0000000080005532 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005532:	7139                	addi	sp,sp,-64
    80005534:	fc06                	sd	ra,56(sp)
    80005536:	f822                	sd	s0,48(sp)
    80005538:	f426                	sd	s1,40(sp)
    8000553a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000553c:	ba0fc0ef          	jal	800018dc <myproc>
    80005540:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005542:	fd840593          	addi	a1,s0,-40
    80005546:	4501                	li	a0,0
    80005548:	db4fd0ef          	jal	80002afc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000554c:	fc840593          	addi	a1,s0,-56
    80005550:	fd040513          	addi	a0,s0,-48
    80005554:	81eff0ef          	jal	80004572 <pipealloc>
    return -1;
    80005558:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000555a:	0a054463          	bltz	a0,80005602 <sys_pipe+0xd0>
  fd0 = -1;
    8000555e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005562:	fd043503          	ld	a0,-48(s0)
    80005566:	edeff0ef          	jal	80004c44 <fdalloc>
    8000556a:	fca42223          	sw	a0,-60(s0)
    8000556e:	08054163          	bltz	a0,800055f0 <sys_pipe+0xbe>
    80005572:	fc843503          	ld	a0,-56(s0)
    80005576:	eceff0ef          	jal	80004c44 <fdalloc>
    8000557a:	fca42023          	sw	a0,-64(s0)
    8000557e:	06054063          	bltz	a0,800055de <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005582:	4691                	li	a3,4
    80005584:	fc440613          	addi	a2,s0,-60
    80005588:	fd843583          	ld	a1,-40(s0)
    8000558c:	78a8                	ld	a0,112(s1)
    8000558e:	ff7fb0ef          	jal	80001584 <copyout>
    80005592:	00054e63          	bltz	a0,800055ae <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005596:	4691                	li	a3,4
    80005598:	fc040613          	addi	a2,s0,-64
    8000559c:	fd843583          	ld	a1,-40(s0)
    800055a0:	95b6                	add	a1,a1,a3
    800055a2:	78a8                	ld	a0,112(s1)
    800055a4:	fe1fb0ef          	jal	80001584 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800055a8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055aa:	04055c63          	bgez	a0,80005602 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800055ae:	fc442783          	lw	a5,-60(s0)
    800055b2:	07f9                	addi	a5,a5,30
    800055b4:	078e                	slli	a5,a5,0x3
    800055b6:	97a6                	add	a5,a5,s1
    800055b8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800055bc:	fc042783          	lw	a5,-64(s0)
    800055c0:	07f9                	addi	a5,a5,30
    800055c2:	078e                	slli	a5,a5,0x3
    800055c4:	94be                	add	s1,s1,a5
    800055c6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800055ca:	fd043503          	ld	a0,-48(s0)
    800055ce:	c95fe0ef          	jal	80004262 <fileclose>
    fileclose(wf);
    800055d2:	fc843503          	ld	a0,-56(s0)
    800055d6:	c8dfe0ef          	jal	80004262 <fileclose>
    return -1;
    800055da:	57fd                	li	a5,-1
    800055dc:	a01d                	j	80005602 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800055de:	fc442783          	lw	a5,-60(s0)
    800055e2:	0007c763          	bltz	a5,800055f0 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800055e6:	07f9                	addi	a5,a5,30
    800055e8:	078e                	slli	a5,a5,0x3
    800055ea:	97a6                	add	a5,a5,s1
    800055ec:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800055f0:	fd043503          	ld	a0,-48(s0)
    800055f4:	c6ffe0ef          	jal	80004262 <fileclose>
    fileclose(wf);
    800055f8:	fc843503          	ld	a0,-56(s0)
    800055fc:	c67fe0ef          	jal	80004262 <fileclose>
    return -1;
    80005600:	57fd                	li	a5,-1
}
    80005602:	853e                	mv	a0,a5
    80005604:	70e2                	ld	ra,56(sp)
    80005606:	7442                	ld	s0,48(sp)
    80005608:	74a2                	ld	s1,40(sp)
    8000560a:	6121                	addi	sp,sp,64
    8000560c:	8082                	ret
	...

0000000080005610 <kernelvec>:
    80005610:	7111                	addi	sp,sp,-256
    80005612:	e006                	sd	ra,0(sp)
    80005614:	e40a                	sd	sp,8(sp)
    80005616:	e80e                	sd	gp,16(sp)
    80005618:	ec12                	sd	tp,24(sp)
    8000561a:	f016                	sd	t0,32(sp)
    8000561c:	f41a                	sd	t1,40(sp)
    8000561e:	f81e                	sd	t2,48(sp)
    80005620:	e4aa                	sd	a0,72(sp)
    80005622:	e8ae                	sd	a1,80(sp)
    80005624:	ecb2                	sd	a2,88(sp)
    80005626:	f0b6                	sd	a3,96(sp)
    80005628:	f4ba                	sd	a4,104(sp)
    8000562a:	f8be                	sd	a5,112(sp)
    8000562c:	fcc2                	sd	a6,120(sp)
    8000562e:	e146                	sd	a7,128(sp)
    80005630:	edf2                	sd	t3,216(sp)
    80005632:	f1f6                	sd	t4,224(sp)
    80005634:	f5fa                	sd	t5,232(sp)
    80005636:	f9fe                	sd	t6,240(sp)
    80005638:	b2efd0ef          	jal	80002966 <kerneltrap>
    8000563c:	6082                	ld	ra,0(sp)
    8000563e:	6122                	ld	sp,8(sp)
    80005640:	61c2                	ld	gp,16(sp)
    80005642:	7282                	ld	t0,32(sp)
    80005644:	7322                	ld	t1,40(sp)
    80005646:	73c2                	ld	t2,48(sp)
    80005648:	6526                	ld	a0,72(sp)
    8000564a:	65c6                	ld	a1,80(sp)
    8000564c:	6666                	ld	a2,88(sp)
    8000564e:	7686                	ld	a3,96(sp)
    80005650:	7726                	ld	a4,104(sp)
    80005652:	77c6                	ld	a5,112(sp)
    80005654:	7866                	ld	a6,120(sp)
    80005656:	688a                	ld	a7,128(sp)
    80005658:	6e6e                	ld	t3,216(sp)
    8000565a:	7e8e                	ld	t4,224(sp)
    8000565c:	7f2e                	ld	t5,232(sp)
    8000565e:	7fce                	ld	t6,240(sp)
    80005660:	6111                	addi	sp,sp,256
    80005662:	10200073          	sret
    80005666:	00000013          	nop
    8000566a:	00000013          	nop

000000008000566e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000566e:	1141                	addi	sp,sp,-16
    80005670:	e406                	sd	ra,8(sp)
    80005672:	e022                	sd	s0,0(sp)
    80005674:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005676:	0c000737          	lui	a4,0xc000
    8000567a:	4785                	li	a5,1
    8000567c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000567e:	c35c                	sw	a5,4(a4)
}
    80005680:	60a2                	ld	ra,8(sp)
    80005682:	6402                	ld	s0,0(sp)
    80005684:	0141                	addi	sp,sp,16
    80005686:	8082                	ret

0000000080005688 <plicinithart>:

void
plicinithart(void)
{
    80005688:	1141                	addi	sp,sp,-16
    8000568a:	e406                	sd	ra,8(sp)
    8000568c:	e022                	sd	s0,0(sp)
    8000568e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005690:	a18fc0ef          	jal	800018a8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005694:	0085171b          	slliw	a4,a0,0x8
    80005698:	0c0027b7          	lui	a5,0xc002
    8000569c:	97ba                	add	a5,a5,a4
    8000569e:	40200713          	li	a4,1026
    800056a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800056a6:	00d5151b          	slliw	a0,a0,0xd
    800056aa:	0c2017b7          	lui	a5,0xc201
    800056ae:	97aa                	add	a5,a5,a0
    800056b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800056b4:	60a2                	ld	ra,8(sp)
    800056b6:	6402                	ld	s0,0(sp)
    800056b8:	0141                	addi	sp,sp,16
    800056ba:	8082                	ret

00000000800056bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800056bc:	1141                	addi	sp,sp,-16
    800056be:	e406                	sd	ra,8(sp)
    800056c0:	e022                	sd	s0,0(sp)
    800056c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800056c4:	9e4fc0ef          	jal	800018a8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800056c8:	00d5151b          	slliw	a0,a0,0xd
    800056cc:	0c2017b7          	lui	a5,0xc201
    800056d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800056d2:	43c8                	lw	a0,4(a5)
    800056d4:	60a2                	ld	ra,8(sp)
    800056d6:	6402                	ld	s0,0(sp)
    800056d8:	0141                	addi	sp,sp,16
    800056da:	8082                	ret

00000000800056dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800056dc:	1101                	addi	sp,sp,-32
    800056de:	ec06                	sd	ra,24(sp)
    800056e0:	e822                	sd	s0,16(sp)
    800056e2:	e426                	sd	s1,8(sp)
    800056e4:	1000                	addi	s0,sp,32
    800056e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800056e8:	9c0fc0ef          	jal	800018a8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800056ec:	00d5179b          	slliw	a5,a0,0xd
    800056f0:	0c201737          	lui	a4,0xc201
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	c3c4                	sw	s1,4(a5)
}
    800056f8:	60e2                	ld	ra,24(sp)
    800056fa:	6442                	ld	s0,16(sp)
    800056fc:	64a2                	ld	s1,8(sp)
    800056fe:	6105                	addi	sp,sp,32
    80005700:	8082                	ret

0000000080005702 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005702:	1141                	addi	sp,sp,-16
    80005704:	e406                	sd	ra,8(sp)
    80005706:	e022                	sd	s0,0(sp)
    80005708:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000570a:	479d                	li	a5,7
    8000570c:	04a7ca63          	blt	a5,a0,80005760 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005710:	0001f797          	auipc	a5,0x1f
    80005714:	a9078793          	addi	a5,a5,-1392 # 800241a0 <disk>
    80005718:	97aa                	add	a5,a5,a0
    8000571a:	0187c783          	lbu	a5,24(a5)
    8000571e:	e7b9                	bnez	a5,8000576c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005720:	00451693          	slli	a3,a0,0x4
    80005724:	0001f797          	auipc	a5,0x1f
    80005728:	a7c78793          	addi	a5,a5,-1412 # 800241a0 <disk>
    8000572c:	6398                	ld	a4,0(a5)
    8000572e:	9736                	add	a4,a4,a3
    80005730:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005734:	6398                	ld	a4,0(a5)
    80005736:	9736                	add	a4,a4,a3
    80005738:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000573c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005740:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005744:	97aa                	add	a5,a5,a0
    80005746:	4705                	li	a4,1
    80005748:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000574c:	0001f517          	auipc	a0,0x1f
    80005750:	a6c50513          	addi	a0,a0,-1428 # 800241b8 <disk+0x18>
    80005754:	a8bfc0ef          	jal	800021de <wakeup>
}
    80005758:	60a2                	ld	ra,8(sp)
    8000575a:	6402                	ld	s0,0(sp)
    8000575c:	0141                	addi	sp,sp,16
    8000575e:	8082                	ret
    panic("free_desc 1");
    80005760:	00002517          	auipc	a0,0x2
    80005764:	2a850513          	addi	a0,a0,680 # 80007a08 <etext+0xa08>
    80005768:	836fb0ef          	jal	8000079e <panic>
    panic("free_desc 2");
    8000576c:	00002517          	auipc	a0,0x2
    80005770:	2ac50513          	addi	a0,a0,684 # 80007a18 <etext+0xa18>
    80005774:	82afb0ef          	jal	8000079e <panic>

0000000080005778 <virtio_disk_init>:
{
    80005778:	1101                	addi	sp,sp,-32
    8000577a:	ec06                	sd	ra,24(sp)
    8000577c:	e822                	sd	s0,16(sp)
    8000577e:	e426                	sd	s1,8(sp)
    80005780:	e04a                	sd	s2,0(sp)
    80005782:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005784:	00002597          	auipc	a1,0x2
    80005788:	2a458593          	addi	a1,a1,676 # 80007a28 <etext+0xa28>
    8000578c:	0001f517          	auipc	a0,0x1f
    80005790:	b3c50513          	addi	a0,a0,-1220 # 800242c8 <disk+0x128>
    80005794:	be6fb0ef          	jal	80000b7a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005798:	100017b7          	lui	a5,0x10001
    8000579c:	4398                	lw	a4,0(a5)
    8000579e:	2701                	sext.w	a4,a4
    800057a0:	747277b7          	lui	a5,0x74727
    800057a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800057a8:	14f71863          	bne	a4,a5,800058f8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800057ac:	100017b7          	lui	a5,0x10001
    800057b0:	43dc                	lw	a5,4(a5)
    800057b2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800057b4:	4709                	li	a4,2
    800057b6:	14e79163          	bne	a5,a4,800058f8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057ba:	100017b7          	lui	a5,0x10001
    800057be:	479c                	lw	a5,8(a5)
    800057c0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800057c2:	12e79b63          	bne	a5,a4,800058f8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800057c6:	100017b7          	lui	a5,0x10001
    800057ca:	47d8                	lw	a4,12(a5)
    800057cc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057ce:	554d47b7          	lui	a5,0x554d4
    800057d2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800057d6:	12f71163          	bne	a4,a5,800058f8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057da:	100017b7          	lui	a5,0x10001
    800057de:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057e2:	4705                	li	a4,1
    800057e4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057e6:	470d                	li	a4,3
    800057e8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800057ea:	10001737          	lui	a4,0x10001
    800057ee:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800057f0:	c7ffe6b7          	lui	a3,0xc7ffe
    800057f4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fda47f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800057f8:	8f75                	and	a4,a4,a3
    800057fa:	100016b7          	lui	a3,0x10001
    800057fe:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005800:	472d                	li	a4,11
    80005802:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005804:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005808:	439c                	lw	a5,0(a5)
    8000580a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000580e:	8ba1                	andi	a5,a5,8
    80005810:	0e078a63          	beqz	a5,80005904 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005814:	100017b7          	lui	a5,0x10001
    80005818:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000581c:	43fc                	lw	a5,68(a5)
    8000581e:	2781                	sext.w	a5,a5
    80005820:	0e079863          	bnez	a5,80005910 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005824:	100017b7          	lui	a5,0x10001
    80005828:	5bdc                	lw	a5,52(a5)
    8000582a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000582c:	0e078863          	beqz	a5,8000591c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005830:	471d                	li	a4,7
    80005832:	0ef77b63          	bgeu	a4,a5,80005928 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005836:	af4fb0ef          	jal	80000b2a <kalloc>
    8000583a:	0001f497          	auipc	s1,0x1f
    8000583e:	96648493          	addi	s1,s1,-1690 # 800241a0 <disk>
    80005842:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005844:	ae6fb0ef          	jal	80000b2a <kalloc>
    80005848:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000584a:	ae0fb0ef          	jal	80000b2a <kalloc>
    8000584e:	87aa                	mv	a5,a0
    80005850:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005852:	6088                	ld	a0,0(s1)
    80005854:	0e050063          	beqz	a0,80005934 <virtio_disk_init+0x1bc>
    80005858:	0001f717          	auipc	a4,0x1f
    8000585c:	95073703          	ld	a4,-1712(a4) # 800241a8 <disk+0x8>
    80005860:	cb71                	beqz	a4,80005934 <virtio_disk_init+0x1bc>
    80005862:	cbe9                	beqz	a5,80005934 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005864:	6605                	lui	a2,0x1
    80005866:	4581                	li	a1,0
    80005868:	c66fb0ef          	jal	80000cce <memset>
  memset(disk.avail, 0, PGSIZE);
    8000586c:	0001f497          	auipc	s1,0x1f
    80005870:	93448493          	addi	s1,s1,-1740 # 800241a0 <disk>
    80005874:	6605                	lui	a2,0x1
    80005876:	4581                	li	a1,0
    80005878:	6488                	ld	a0,8(s1)
    8000587a:	c54fb0ef          	jal	80000cce <memset>
  memset(disk.used, 0, PGSIZE);
    8000587e:	6605                	lui	a2,0x1
    80005880:	4581                	li	a1,0
    80005882:	6888                	ld	a0,16(s1)
    80005884:	c4afb0ef          	jal	80000cce <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005888:	100017b7          	lui	a5,0x10001
    8000588c:	4721                	li	a4,8
    8000588e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005890:	4098                	lw	a4,0(s1)
    80005892:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005896:	40d8                	lw	a4,4(s1)
    80005898:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000589c:	649c                	ld	a5,8(s1)
    8000589e:	0007869b          	sext.w	a3,a5
    800058a2:	10001737          	lui	a4,0x10001
    800058a6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800058aa:	9781                	srai	a5,a5,0x20
    800058ac:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800058b0:	689c                	ld	a5,16(s1)
    800058b2:	0007869b          	sext.w	a3,a5
    800058b6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800058ba:	9781                	srai	a5,a5,0x20
    800058bc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800058c0:	4785                	li	a5,1
    800058c2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800058c4:	00f48c23          	sb	a5,24(s1)
    800058c8:	00f48ca3          	sb	a5,25(s1)
    800058cc:	00f48d23          	sb	a5,26(s1)
    800058d0:	00f48da3          	sb	a5,27(s1)
    800058d4:	00f48e23          	sb	a5,28(s1)
    800058d8:	00f48ea3          	sb	a5,29(s1)
    800058dc:	00f48f23          	sb	a5,30(s1)
    800058e0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800058e4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800058e8:	07272823          	sw	s2,112(a4)
}
    800058ec:	60e2                	ld	ra,24(sp)
    800058ee:	6442                	ld	s0,16(sp)
    800058f0:	64a2                	ld	s1,8(sp)
    800058f2:	6902                	ld	s2,0(sp)
    800058f4:	6105                	addi	sp,sp,32
    800058f6:	8082                	ret
    panic("could not find virtio disk");
    800058f8:	00002517          	auipc	a0,0x2
    800058fc:	14050513          	addi	a0,a0,320 # 80007a38 <etext+0xa38>
    80005900:	e9ffa0ef          	jal	8000079e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005904:	00002517          	auipc	a0,0x2
    80005908:	15450513          	addi	a0,a0,340 # 80007a58 <etext+0xa58>
    8000590c:	e93fa0ef          	jal	8000079e <panic>
    panic("virtio disk should not be ready");
    80005910:	00002517          	auipc	a0,0x2
    80005914:	16850513          	addi	a0,a0,360 # 80007a78 <etext+0xa78>
    80005918:	e87fa0ef          	jal	8000079e <panic>
    panic("virtio disk has no queue 0");
    8000591c:	00002517          	auipc	a0,0x2
    80005920:	17c50513          	addi	a0,a0,380 # 80007a98 <etext+0xa98>
    80005924:	e7bfa0ef          	jal	8000079e <panic>
    panic("virtio disk max queue too short");
    80005928:	00002517          	auipc	a0,0x2
    8000592c:	19050513          	addi	a0,a0,400 # 80007ab8 <etext+0xab8>
    80005930:	e6ffa0ef          	jal	8000079e <panic>
    panic("virtio disk kalloc");
    80005934:	00002517          	auipc	a0,0x2
    80005938:	1a450513          	addi	a0,a0,420 # 80007ad8 <etext+0xad8>
    8000593c:	e63fa0ef          	jal	8000079e <panic>

0000000080005940 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005940:	711d                	addi	sp,sp,-96
    80005942:	ec86                	sd	ra,88(sp)
    80005944:	e8a2                	sd	s0,80(sp)
    80005946:	e4a6                	sd	s1,72(sp)
    80005948:	e0ca                	sd	s2,64(sp)
    8000594a:	fc4e                	sd	s3,56(sp)
    8000594c:	f852                	sd	s4,48(sp)
    8000594e:	f456                	sd	s5,40(sp)
    80005950:	f05a                	sd	s6,32(sp)
    80005952:	ec5e                	sd	s7,24(sp)
    80005954:	e862                	sd	s8,16(sp)
    80005956:	1080                	addi	s0,sp,96
    80005958:	89aa                	mv	s3,a0
    8000595a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000595c:	00c52b83          	lw	s7,12(a0)
    80005960:	001b9b9b          	slliw	s7,s7,0x1
    80005964:	1b82                	slli	s7,s7,0x20
    80005966:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000596a:	0001f517          	auipc	a0,0x1f
    8000596e:	95e50513          	addi	a0,a0,-1698 # 800242c8 <disk+0x128>
    80005972:	a8cfb0ef          	jal	80000bfe <acquire>
  for(int i = 0; i < NUM; i++){
    80005976:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005978:	0001fa97          	auipc	s5,0x1f
    8000597c:	828a8a93          	addi	s5,s5,-2008 # 800241a0 <disk>
  for(int i = 0; i < 3; i++){
    80005980:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005982:	5c7d                	li	s8,-1
    80005984:	a095                	j	800059e8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005986:	00fa8733          	add	a4,s5,a5
    8000598a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000598e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005990:	0207c563          	bltz	a5,800059ba <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005994:	2905                	addiw	s2,s2,1
    80005996:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005998:	05490c63          	beq	s2,s4,800059f0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000599c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000599e:	0001f717          	auipc	a4,0x1f
    800059a2:	80270713          	addi	a4,a4,-2046 # 800241a0 <disk>
    800059a6:	4781                	li	a5,0
    if(disk.free[i]){
    800059a8:	01874683          	lbu	a3,24(a4)
    800059ac:	fee9                	bnez	a3,80005986 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    800059ae:	2785                	addiw	a5,a5,1
    800059b0:	0705                	addi	a4,a4,1
    800059b2:	fe979be3          	bne	a5,s1,800059a8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800059b6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800059ba:	01205d63          	blez	s2,800059d4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800059be:	fa042503          	lw	a0,-96(s0)
    800059c2:	d41ff0ef          	jal	80005702 <free_desc>
      for(int j = 0; j < i; j++)
    800059c6:	4785                	li	a5,1
    800059c8:	0127d663          	bge	a5,s2,800059d4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800059cc:	fa442503          	lw	a0,-92(s0)
    800059d0:	d33ff0ef          	jal	80005702 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800059d4:	0001f597          	auipc	a1,0x1f
    800059d8:	8f458593          	addi	a1,a1,-1804 # 800242c8 <disk+0x128>
    800059dc:	0001e517          	auipc	a0,0x1e
    800059e0:	7dc50513          	addi	a0,a0,2012 # 800241b8 <disk+0x18>
    800059e4:	e4afc0ef          	jal	8000202e <sleep>
  for(int i = 0; i < 3; i++){
    800059e8:	fa040613          	addi	a2,s0,-96
    800059ec:	4901                	li	s2,0
    800059ee:	b77d                	j	8000599c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059f0:	fa042503          	lw	a0,-96(s0)
    800059f4:	00451693          	slli	a3,a0,0x4

  if(write)
    800059f8:	0001e797          	auipc	a5,0x1e
    800059fc:	7a878793          	addi	a5,a5,1960 # 800241a0 <disk>
    80005a00:	00a50713          	addi	a4,a0,10
    80005a04:	0712                	slli	a4,a4,0x4
    80005a06:	973e                	add	a4,a4,a5
    80005a08:	01603633          	snez	a2,s6
    80005a0c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005a0e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005a12:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a16:	6398                	ld	a4,0(a5)
    80005a18:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a1a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005a1e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a20:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a22:	6390                	ld	a2,0(a5)
    80005a24:	00d605b3          	add	a1,a2,a3
    80005a28:	4741                	li	a4,16
    80005a2a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a2c:	4805                	li	a6,1
    80005a2e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005a32:	fa442703          	lw	a4,-92(s0)
    80005a36:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a3a:	0712                	slli	a4,a4,0x4
    80005a3c:	963a                	add	a2,a2,a4
    80005a3e:	05898593          	addi	a1,s3,88
    80005a42:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005a44:	0007b883          	ld	a7,0(a5)
    80005a48:	9746                	add	a4,a4,a7
    80005a4a:	40000613          	li	a2,1024
    80005a4e:	c710                	sw	a2,8(a4)
  if(write)
    80005a50:	001b3613          	seqz	a2,s6
    80005a54:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005a58:	01066633          	or	a2,a2,a6
    80005a5c:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005a60:	fa842583          	lw	a1,-88(s0)
    80005a64:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005a68:	00250613          	addi	a2,a0,2
    80005a6c:	0612                	slli	a2,a2,0x4
    80005a6e:	963e                	add	a2,a2,a5
    80005a70:	577d                	li	a4,-1
    80005a72:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005a76:	0592                	slli	a1,a1,0x4
    80005a78:	98ae                	add	a7,a7,a1
    80005a7a:	03068713          	addi	a4,a3,48
    80005a7e:	973e                	add	a4,a4,a5
    80005a80:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005a84:	6398                	ld	a4,0(a5)
    80005a86:	972e                	add	a4,a4,a1
    80005a88:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005a8c:	4689                	li	a3,2
    80005a8e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005a92:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005a96:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80005a9a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005a9e:	6794                	ld	a3,8(a5)
    80005aa0:	0026d703          	lhu	a4,2(a3)
    80005aa4:	8b1d                	andi	a4,a4,7
    80005aa6:	0706                	slli	a4,a4,0x1
    80005aa8:	96ba                	add	a3,a3,a4
    80005aaa:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005aae:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005ab2:	6798                	ld	a4,8(a5)
    80005ab4:	00275783          	lhu	a5,2(a4)
    80005ab8:	2785                	addiw	a5,a5,1
    80005aba:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005abe:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005ac2:	100017b7          	lui	a5,0x10001
    80005ac6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005aca:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005ace:	0001e917          	auipc	s2,0x1e
    80005ad2:	7fa90913          	addi	s2,s2,2042 # 800242c8 <disk+0x128>
  while(b->disk == 1) {
    80005ad6:	84c2                	mv	s1,a6
    80005ad8:	01079a63          	bne	a5,a6,80005aec <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80005adc:	85ca                	mv	a1,s2
    80005ade:	854e                	mv	a0,s3
    80005ae0:	d4efc0ef          	jal	8000202e <sleep>
  while(b->disk == 1) {
    80005ae4:	0049a783          	lw	a5,4(s3)
    80005ae8:	fe978ae3          	beq	a5,s1,80005adc <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80005aec:	fa042903          	lw	s2,-96(s0)
    80005af0:	00290713          	addi	a4,s2,2
    80005af4:	0712                	slli	a4,a4,0x4
    80005af6:	0001e797          	auipc	a5,0x1e
    80005afa:	6aa78793          	addi	a5,a5,1706 # 800241a0 <disk>
    80005afe:	97ba                	add	a5,a5,a4
    80005b00:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005b04:	0001e997          	auipc	s3,0x1e
    80005b08:	69c98993          	addi	s3,s3,1692 # 800241a0 <disk>
    80005b0c:	00491713          	slli	a4,s2,0x4
    80005b10:	0009b783          	ld	a5,0(s3)
    80005b14:	97ba                	add	a5,a5,a4
    80005b16:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005b1a:	854a                	mv	a0,s2
    80005b1c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005b20:	be3ff0ef          	jal	80005702 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005b24:	8885                	andi	s1,s1,1
    80005b26:	f0fd                	bnez	s1,80005b0c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005b28:	0001e517          	auipc	a0,0x1e
    80005b2c:	7a050513          	addi	a0,a0,1952 # 800242c8 <disk+0x128>
    80005b30:	962fb0ef          	jal	80000c92 <release>
}
    80005b34:	60e6                	ld	ra,88(sp)
    80005b36:	6446                	ld	s0,80(sp)
    80005b38:	64a6                	ld	s1,72(sp)
    80005b3a:	6906                	ld	s2,64(sp)
    80005b3c:	79e2                	ld	s3,56(sp)
    80005b3e:	7a42                	ld	s4,48(sp)
    80005b40:	7aa2                	ld	s5,40(sp)
    80005b42:	7b02                	ld	s6,32(sp)
    80005b44:	6be2                	ld	s7,24(sp)
    80005b46:	6c42                	ld	s8,16(sp)
    80005b48:	6125                	addi	sp,sp,96
    80005b4a:	8082                	ret

0000000080005b4c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b4c:	1101                	addi	sp,sp,-32
    80005b4e:	ec06                	sd	ra,24(sp)
    80005b50:	e822                	sd	s0,16(sp)
    80005b52:	e426                	sd	s1,8(sp)
    80005b54:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b56:	0001e497          	auipc	s1,0x1e
    80005b5a:	64a48493          	addi	s1,s1,1610 # 800241a0 <disk>
    80005b5e:	0001e517          	auipc	a0,0x1e
    80005b62:	76a50513          	addi	a0,a0,1898 # 800242c8 <disk+0x128>
    80005b66:	898fb0ef          	jal	80000bfe <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b6a:	100017b7          	lui	a5,0x10001
    80005b6e:	53bc                	lw	a5,96(a5)
    80005b70:	8b8d                	andi	a5,a5,3
    80005b72:	10001737          	lui	a4,0x10001
    80005b76:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005b78:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b7c:	689c                	ld	a5,16(s1)
    80005b7e:	0204d703          	lhu	a4,32(s1)
    80005b82:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005b86:	04f70663          	beq	a4,a5,80005bd2 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005b8a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b8e:	6898                	ld	a4,16(s1)
    80005b90:	0204d783          	lhu	a5,32(s1)
    80005b94:	8b9d                	andi	a5,a5,7
    80005b96:	078e                	slli	a5,a5,0x3
    80005b98:	97ba                	add	a5,a5,a4
    80005b9a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b9c:	00278713          	addi	a4,a5,2
    80005ba0:	0712                	slli	a4,a4,0x4
    80005ba2:	9726                	add	a4,a4,s1
    80005ba4:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005ba8:	e321                	bnez	a4,80005be8 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005baa:	0789                	addi	a5,a5,2
    80005bac:	0792                	slli	a5,a5,0x4
    80005bae:	97a6                	add	a5,a5,s1
    80005bb0:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005bb2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005bb6:	e28fc0ef          	jal	800021de <wakeup>

    disk.used_idx += 1;
    80005bba:	0204d783          	lhu	a5,32(s1)
    80005bbe:	2785                	addiw	a5,a5,1
    80005bc0:	17c2                	slli	a5,a5,0x30
    80005bc2:	93c1                	srli	a5,a5,0x30
    80005bc4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005bc8:	6898                	ld	a4,16(s1)
    80005bca:	00275703          	lhu	a4,2(a4)
    80005bce:	faf71ee3          	bne	a4,a5,80005b8a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005bd2:	0001e517          	auipc	a0,0x1e
    80005bd6:	6f650513          	addi	a0,a0,1782 # 800242c8 <disk+0x128>
    80005bda:	8b8fb0ef          	jal	80000c92 <release>
}
    80005bde:	60e2                	ld	ra,24(sp)
    80005be0:	6442                	ld	s0,16(sp)
    80005be2:	64a2                	ld	s1,8(sp)
    80005be4:	6105                	addi	sp,sp,32
    80005be6:	8082                	ret
      panic("virtio_disk_intr status");
    80005be8:	00002517          	auipc	a0,0x2
    80005bec:	f0850513          	addi	a0,a0,-248 # 80007af0 <etext+0xaf0>
    80005bf0:	baffa0ef          	jal	8000079e <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
