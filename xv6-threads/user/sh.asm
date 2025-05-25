
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000400000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
  400000:	1101                	addi	sp,sp,-32
  400002:	ec06                	sd	ra,24(sp)
  400004:	e822                	sd	s0,16(sp)
  400006:	e426                	sd	s1,8(sp)
  400008:	e04a                	sd	s2,0(sp)
  40000a:	1000                	addi	s0,sp,32
  40000c:	84aa                	mv	s1,a0
  40000e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
  400010:	4609                	li	a2,2
  400012:	00001597          	auipc	a1,0x1
  400016:	20e58593          	addi	a1,a1,526 # 401220 <malloc+0xfe>
  40001a:	8532                	mv	a0,a2
  40001c:	451000ef          	jal	400c6c <write>
  memset(buf, 0, nbuf);
  400020:	864a                	mv	a2,s2
  400022:	4581                	li	a1,0
  400024:	8526                	mv	a0,s1
  400026:	219000ef          	jal	400a3e <memset>
  gets(buf, nbuf);
  40002a:	85ca                	mv	a1,s2
  40002c:	8526                	mv	a0,s1
  40002e:	25f000ef          	jal	400a8c <gets>
  if(buf[0] == 0) // EOF
  400032:	0004c503          	lbu	a0,0(s1)
  400036:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
  40003a:	40a0053b          	negw	a0,a0
  40003e:	60e2                	ld	ra,24(sp)
  400040:	6442                	ld	s0,16(sp)
  400042:	64a2                	ld	s1,8(sp)
  400044:	6902                	ld	s2,0(sp)
  400046:	6105                	addi	sp,sp,32
  400048:	8082                	ret

000000000040004a <panic>:
  exit(0);
}

void
panic(char *s)
{
  40004a:	1141                	addi	sp,sp,-16
  40004c:	e406                	sd	ra,8(sp)
  40004e:	e022                	sd	s0,0(sp)
  400050:	0800                	addi	s0,sp,16
  400052:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
  400054:	00001597          	auipc	a1,0x1
  400058:	1dc58593          	addi	a1,a1,476 # 401230 <malloc+0x10e>
  40005c:	4509                	li	a0,2
  40005e:	7df000ef          	jal	40103c <fprintf>
  exit(1);
  400062:	4505                	li	a0,1
  400064:	3e9000ef          	jal	400c4c <exit>

0000000000400068 <fork1>:
}

int
fork1(void)
{
  400068:	1141                	addi	sp,sp,-16
  40006a:	e406                	sd	ra,8(sp)
  40006c:	e022                	sd	s0,0(sp)
  40006e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
  400070:	3d5000ef          	jal	400c44 <fork>
  if(pid == -1)
  400074:	57fd                	li	a5,-1
  400076:	00f50663          	beq	a0,a5,400082 <fork1+0x1a>
    panic("fork");
  return pid;
}
  40007a:	60a2                	ld	ra,8(sp)
  40007c:	6402                	ld	s0,0(sp)
  40007e:	0141                	addi	sp,sp,16
  400080:	8082                	ret
    panic("fork");
  400082:	00001517          	auipc	a0,0x1
  400086:	1b650513          	addi	a0,a0,438 # 401238 <malloc+0x116>
  40008a:	fc1ff0ef          	jal	40004a <panic>

000000000040008e <runcmd>:
{
  40008e:	7179                	addi	sp,sp,-48
  400090:	f406                	sd	ra,40(sp)
  400092:	f022                	sd	s0,32(sp)
  400094:	1800                	addi	s0,sp,48
  if(cmd == 0)
  400096:	c115                	beqz	a0,4000ba <runcmd+0x2c>
  400098:	ec26                	sd	s1,24(sp)
  40009a:	84aa                	mv	s1,a0
  switch(cmd->type){
  40009c:	4118                	lw	a4,0(a0)
  40009e:	4795                	li	a5,5
  4000a0:	02e7e163          	bltu	a5,a4,4000c2 <runcmd+0x34>
  4000a4:	00056783          	lwu	a5,0(a0)
  4000a8:	078a                	slli	a5,a5,0x2
  4000aa:	00001717          	auipc	a4,0x1
  4000ae:	28e70713          	addi	a4,a4,654 # 401338 <malloc+0x216>
  4000b2:	97ba                	add	a5,a5,a4
  4000b4:	439c                	lw	a5,0(a5)
  4000b6:	97ba                	add	a5,a5,a4
  4000b8:	8782                	jr	a5
  4000ba:	ec26                	sd	s1,24(sp)
    exit(1);
  4000bc:	4505                	li	a0,1
  4000be:	38f000ef          	jal	400c4c <exit>
    panic("runcmd");
  4000c2:	00001517          	auipc	a0,0x1
  4000c6:	17e50513          	addi	a0,a0,382 # 401240 <malloc+0x11e>
  4000ca:	f81ff0ef          	jal	40004a <panic>
    if(ecmd->argv[0] == 0)
  4000ce:	6508                	ld	a0,8(a0)
  4000d0:	c105                	beqz	a0,4000f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
  4000d2:	00848593          	addi	a1,s1,8
  4000d6:	3af000ef          	jal	400c84 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
  4000da:	6490                	ld	a2,8(s1)
  4000dc:	00001597          	auipc	a1,0x1
  4000e0:	16c58593          	addi	a1,a1,364 # 401248 <malloc+0x126>
  4000e4:	4509                	li	a0,2
  4000e6:	757000ef          	jal	40103c <fprintf>
  exit(0);
  4000ea:	4501                	li	a0,0
  4000ec:	361000ef          	jal	400c4c <exit>
      exit(1);
  4000f0:	4505                	li	a0,1
  4000f2:	35b000ef          	jal	400c4c <exit>
    close(rcmd->fd);
  4000f6:	5148                	lw	a0,36(a0)
  4000f8:	37d000ef          	jal	400c74 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
  4000fc:	508c                	lw	a1,32(s1)
  4000fe:	6888                	ld	a0,16(s1)
  400100:	38d000ef          	jal	400c8c <open>
  400104:	00054563          	bltz	a0,40010e <runcmd+0x80>
    runcmd(rcmd->cmd);
  400108:	6488                	ld	a0,8(s1)
  40010a:	f85ff0ef          	jal	40008e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
  40010e:	6890                	ld	a2,16(s1)
  400110:	00001597          	auipc	a1,0x1
  400114:	14858593          	addi	a1,a1,328 # 401258 <malloc+0x136>
  400118:	4509                	li	a0,2
  40011a:	723000ef          	jal	40103c <fprintf>
      exit(1);
  40011e:	4505                	li	a0,1
  400120:	32d000ef          	jal	400c4c <exit>
    if(fork1() == 0)
  400124:	f45ff0ef          	jal	400068 <fork1>
  400128:	e501                	bnez	a0,400130 <runcmd+0xa2>
      runcmd(lcmd->left);
  40012a:	6488                	ld	a0,8(s1)
  40012c:	f63ff0ef          	jal	40008e <runcmd>
    wait(0);
  400130:	4501                	li	a0,0
  400132:	323000ef          	jal	400c54 <wait>
    runcmd(lcmd->right);
  400136:	6888                	ld	a0,16(s1)
  400138:	f57ff0ef          	jal	40008e <runcmd>
    if(pipe(p) < 0)
  40013c:	fd840513          	addi	a0,s0,-40
  400140:	31d000ef          	jal	400c5c <pipe>
  400144:	02054763          	bltz	a0,400172 <runcmd+0xe4>
    if(fork1() == 0){
  400148:	f21ff0ef          	jal	400068 <fork1>
  40014c:	e90d                	bnez	a0,40017e <runcmd+0xf0>
      close(1);
  40014e:	4505                	li	a0,1
  400150:	325000ef          	jal	400c74 <close>
      dup(p[1]);
  400154:	fdc42503          	lw	a0,-36(s0)
  400158:	36d000ef          	jal	400cc4 <dup>
      close(p[0]);
  40015c:	fd842503          	lw	a0,-40(s0)
  400160:	315000ef          	jal	400c74 <close>
      close(p[1]);
  400164:	fdc42503          	lw	a0,-36(s0)
  400168:	30d000ef          	jal	400c74 <close>
      runcmd(pcmd->left);
  40016c:	6488                	ld	a0,8(s1)
  40016e:	f21ff0ef          	jal	40008e <runcmd>
      panic("pipe");
  400172:	00001517          	auipc	a0,0x1
  400176:	0f650513          	addi	a0,a0,246 # 401268 <malloc+0x146>
  40017a:	ed1ff0ef          	jal	40004a <panic>
    if(fork1() == 0){
  40017e:	eebff0ef          	jal	400068 <fork1>
  400182:	e115                	bnez	a0,4001a6 <runcmd+0x118>
      close(0);
  400184:	2f1000ef          	jal	400c74 <close>
      dup(p[0]);
  400188:	fd842503          	lw	a0,-40(s0)
  40018c:	339000ef          	jal	400cc4 <dup>
      close(p[0]);
  400190:	fd842503          	lw	a0,-40(s0)
  400194:	2e1000ef          	jal	400c74 <close>
      close(p[1]);
  400198:	fdc42503          	lw	a0,-36(s0)
  40019c:	2d9000ef          	jal	400c74 <close>
      runcmd(pcmd->right);
  4001a0:	6888                	ld	a0,16(s1)
  4001a2:	eedff0ef          	jal	40008e <runcmd>
    close(p[0]);
  4001a6:	fd842503          	lw	a0,-40(s0)
  4001aa:	2cb000ef          	jal	400c74 <close>
    close(p[1]);
  4001ae:	fdc42503          	lw	a0,-36(s0)
  4001b2:	2c3000ef          	jal	400c74 <close>
    wait(0);
  4001b6:	4501                	li	a0,0
  4001b8:	29d000ef          	jal	400c54 <wait>
    wait(0);
  4001bc:	4501                	li	a0,0
  4001be:	297000ef          	jal	400c54 <wait>
    break;
  4001c2:	b725                	j	4000ea <runcmd+0x5c>
    if(fork1() == 0)
  4001c4:	ea5ff0ef          	jal	400068 <fork1>
  4001c8:	f20511e3          	bnez	a0,4000ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
  4001cc:	6488                	ld	a0,8(s1)
  4001ce:	ec1ff0ef          	jal	40008e <runcmd>

00000000004001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
  4001d2:	1101                	addi	sp,sp,-32
  4001d4:	ec06                	sd	ra,24(sp)
  4001d6:	e822                	sd	s0,16(sp)
  4001d8:	e426                	sd	s1,8(sp)
  4001da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  4001dc:	0a800513          	li	a0,168
  4001e0:	743000ef          	jal	401122 <malloc>
  4001e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
  4001e6:	0a800613          	li	a2,168
  4001ea:	4581                	li	a1,0
  4001ec:	053000ef          	jal	400a3e <memset>
  cmd->type = EXEC;
  4001f0:	4785                	li	a5,1
  4001f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
  4001f4:	8526                	mv	a0,s1
  4001f6:	60e2                	ld	ra,24(sp)
  4001f8:	6442                	ld	s0,16(sp)
  4001fa:	64a2                	ld	s1,8(sp)
  4001fc:	6105                	addi	sp,sp,32
  4001fe:	8082                	ret

0000000000400200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  400200:	7139                	addi	sp,sp,-64
  400202:	fc06                	sd	ra,56(sp)
  400204:	f822                	sd	s0,48(sp)
  400206:	f426                	sd	s1,40(sp)
  400208:	f04a                	sd	s2,32(sp)
  40020a:	ec4e                	sd	s3,24(sp)
  40020c:	e852                	sd	s4,16(sp)
  40020e:	e456                	sd	s5,8(sp)
  400210:	e05a                	sd	s6,0(sp)
  400212:	0080                	addi	s0,sp,64
  400214:	8b2a                	mv	s6,a0
  400216:	8aae                	mv	s5,a1
  400218:	8a32                	mv	s4,a2
  40021a:	89b6                	mv	s3,a3
  40021c:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  40021e:	02800513          	li	a0,40
  400222:	701000ef          	jal	401122 <malloc>
  400226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
  400228:	02800613          	li	a2,40
  40022c:	4581                	li	a1,0
  40022e:	011000ef          	jal	400a3e <memset>
  cmd->type = REDIR;
  400232:	4789                	li	a5,2
  400234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
  400236:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
  40023a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
  40023e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
  400242:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
  400246:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
  40024a:	8526                	mv	a0,s1
  40024c:	70e2                	ld	ra,56(sp)
  40024e:	7442                	ld	s0,48(sp)
  400250:	74a2                	ld	s1,40(sp)
  400252:	7902                	ld	s2,32(sp)
  400254:	69e2                	ld	s3,24(sp)
  400256:	6a42                	ld	s4,16(sp)
  400258:	6aa2                	ld	s5,8(sp)
  40025a:	6b02                	ld	s6,0(sp)
  40025c:	6121                	addi	sp,sp,64
  40025e:	8082                	ret

0000000000400260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  400260:	7179                	addi	sp,sp,-48
  400262:	f406                	sd	ra,40(sp)
  400264:	f022                	sd	s0,32(sp)
  400266:	ec26                	sd	s1,24(sp)
  400268:	e84a                	sd	s2,16(sp)
  40026a:	e44e                	sd	s3,8(sp)
  40026c:	1800                	addi	s0,sp,48
  40026e:	89aa                	mv	s3,a0
  400270:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  400272:	4561                	li	a0,24
  400274:	6af000ef          	jal	401122 <malloc>
  400278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
  40027a:	4661                	li	a2,24
  40027c:	4581                	li	a1,0
  40027e:	7c0000ef          	jal	400a3e <memset>
  cmd->type = PIPE;
  400282:	478d                	li	a5,3
  400284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
  400286:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
  40028a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
  40028e:	8526                	mv	a0,s1
  400290:	70a2                	ld	ra,40(sp)
  400292:	7402                	ld	s0,32(sp)
  400294:	64e2                	ld	s1,24(sp)
  400296:	6942                	ld	s2,16(sp)
  400298:	69a2                	ld	s3,8(sp)
  40029a:	6145                	addi	sp,sp,48
  40029c:	8082                	ret

000000000040029e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  40029e:	7179                	addi	sp,sp,-48
  4002a0:	f406                	sd	ra,40(sp)
  4002a2:	f022                	sd	s0,32(sp)
  4002a4:	ec26                	sd	s1,24(sp)
  4002a6:	e84a                	sd	s2,16(sp)
  4002a8:	e44e                	sd	s3,8(sp)
  4002aa:	1800                	addi	s0,sp,48
  4002ac:	89aa                	mv	s3,a0
  4002ae:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  4002b0:	4561                	li	a0,24
  4002b2:	671000ef          	jal	401122 <malloc>
  4002b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
  4002b8:	4661                	li	a2,24
  4002ba:	4581                	li	a1,0
  4002bc:	782000ef          	jal	400a3e <memset>
  cmd->type = LIST;
  4002c0:	4791                	li	a5,4
  4002c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
  4002c4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
  4002c8:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
  4002cc:	8526                	mv	a0,s1
  4002ce:	70a2                	ld	ra,40(sp)
  4002d0:	7402                	ld	s0,32(sp)
  4002d2:	64e2                	ld	s1,24(sp)
  4002d4:	6942                	ld	s2,16(sp)
  4002d6:	69a2                	ld	s3,8(sp)
  4002d8:	6145                	addi	sp,sp,48
  4002da:	8082                	ret

00000000004002dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
  4002dc:	1101                	addi	sp,sp,-32
  4002de:	ec06                	sd	ra,24(sp)
  4002e0:	e822                	sd	s0,16(sp)
  4002e2:	e426                	sd	s1,8(sp)
  4002e4:	e04a                	sd	s2,0(sp)
  4002e6:	1000                	addi	s0,sp,32
  4002e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  4002ea:	4541                	li	a0,16
  4002ec:	637000ef          	jal	401122 <malloc>
  4002f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
  4002f2:	4641                	li	a2,16
  4002f4:	4581                	li	a1,0
  4002f6:	748000ef          	jal	400a3e <memset>
  cmd->type = BACK;
  4002fa:	4795                	li	a5,5
  4002fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
  4002fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
  400302:	8526                	mv	a0,s1
  400304:	60e2                	ld	ra,24(sp)
  400306:	6442                	ld	s0,16(sp)
  400308:	64a2                	ld	s1,8(sp)
  40030a:	6902                	ld	s2,0(sp)
  40030c:	6105                	addi	sp,sp,32
  40030e:	8082                	ret

0000000000400310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
  400310:	7139                	addi	sp,sp,-64
  400312:	fc06                	sd	ra,56(sp)
  400314:	f822                	sd	s0,48(sp)
  400316:	f426                	sd	s1,40(sp)
  400318:	f04a                	sd	s2,32(sp)
  40031a:	ec4e                	sd	s3,24(sp)
  40031c:	e852                	sd	s4,16(sp)
  40031e:	e456                	sd	s5,8(sp)
  400320:	e05a                	sd	s6,0(sp)
  400322:	0080                	addi	s0,sp,64
  400324:	8a2a                	mv	s4,a0
  400326:	892e                	mv	s2,a1
  400328:	8ab2                	mv	s5,a2
  40032a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
  40032c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
  40032e:	00002997          	auipc	s3,0x2
  400332:	cda98993          	addi	s3,s3,-806 # 402008 <whitespace>
  400336:	00b4fc63          	bgeu	s1,a1,40034e <gettoken+0x3e>
  40033a:	0004c583          	lbu	a1,0(s1)
  40033e:	854e                	mv	a0,s3
  400340:	724000ef          	jal	400a64 <strchr>
  400344:	c509                	beqz	a0,40034e <gettoken+0x3e>
    s++;
  400346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
  400348:	fe9919e3          	bne	s2,s1,40033a <gettoken+0x2a>
  40034c:	84ca                	mv	s1,s2
  if(q)
  40034e:	000a8463          	beqz	s5,400356 <gettoken+0x46>
    *q = s;
  400352:	009ab023          	sd	s1,0(s5)
  ret = *s;
  400356:	0004c783          	lbu	a5,0(s1)
  40035a:	00078a9b          	sext.w	s5,a5
  switch(*s){
  40035e:	03c00713          	li	a4,60
  400362:	06f76463          	bltu	a4,a5,4003ca <gettoken+0xba>
  400366:	03a00713          	li	a4,58
  40036a:	00f76e63          	bltu	a4,a5,400386 <gettoken+0x76>
  40036e:	cf89                	beqz	a5,400388 <gettoken+0x78>
  400370:	02600713          	li	a4,38
  400374:	00e78963          	beq	a5,a4,400386 <gettoken+0x76>
  400378:	fd87879b          	addiw	a5,a5,-40
  40037c:	0ff7f793          	zext.b	a5,a5
  400380:	4705                	li	a4,1
  400382:	06f76b63          	bltu	a4,a5,4003f8 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
  400386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
  400388:	000b0463          	beqz	s6,400390 <gettoken+0x80>
    *eq = s;
  40038c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
  400390:	00002997          	auipc	s3,0x2
  400394:	c7898993          	addi	s3,s3,-904 # 402008 <whitespace>
  400398:	0124fc63          	bgeu	s1,s2,4003b0 <gettoken+0xa0>
  40039c:	0004c583          	lbu	a1,0(s1)
  4003a0:	854e                	mv	a0,s3
  4003a2:	6c2000ef          	jal	400a64 <strchr>
  4003a6:	c509                	beqz	a0,4003b0 <gettoken+0xa0>
    s++;
  4003a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
  4003aa:	fe9919e3          	bne	s2,s1,40039c <gettoken+0x8c>
  4003ae:	84ca                	mv	s1,s2
  *ps = s;
  4003b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
  4003b4:	8556                	mv	a0,s5
  4003b6:	70e2                	ld	ra,56(sp)
  4003b8:	7442                	ld	s0,48(sp)
  4003ba:	74a2                	ld	s1,40(sp)
  4003bc:	7902                	ld	s2,32(sp)
  4003be:	69e2                	ld	s3,24(sp)
  4003c0:	6a42                	ld	s4,16(sp)
  4003c2:	6aa2                	ld	s5,8(sp)
  4003c4:	6b02                	ld	s6,0(sp)
  4003c6:	6121                	addi	sp,sp,64
  4003c8:	8082                	ret
  switch(*s){
  4003ca:	03e00713          	li	a4,62
  4003ce:	02e79163          	bne	a5,a4,4003f0 <gettoken+0xe0>
    s++;
  4003d2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
  4003d6:	0014c703          	lbu	a4,1(s1)
  4003da:	03e00793          	li	a5,62
      s++;
  4003de:	0489                	addi	s1,s1,2
      ret = '+';
  4003e0:	02b00a93          	li	s5,43
    if(*s == '>'){
  4003e4:	faf702e3          	beq	a4,a5,400388 <gettoken+0x78>
    s++;
  4003e8:	84b6                	mv	s1,a3
  ret = *s;
  4003ea:	03e00a93          	li	s5,62
  4003ee:	bf69                	j	400388 <gettoken+0x78>
  switch(*s){
  4003f0:	07c00713          	li	a4,124
  4003f4:	f8e789e3          	beq	a5,a4,400386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
  4003f8:	00002997          	auipc	s3,0x2
  4003fc:	c1098993          	addi	s3,s3,-1008 # 402008 <whitespace>
  400400:	00002a97          	auipc	s5,0x2
  400404:	c00a8a93          	addi	s5,s5,-1024 # 402000 <symbols>
  400408:	0324fd63          	bgeu	s1,s2,400442 <gettoken+0x132>
  40040c:	0004c583          	lbu	a1,0(s1)
  400410:	854e                	mv	a0,s3
  400412:	652000ef          	jal	400a64 <strchr>
  400416:	e11d                	bnez	a0,40043c <gettoken+0x12c>
  400418:	0004c583          	lbu	a1,0(s1)
  40041c:	8556                	mv	a0,s5
  40041e:	646000ef          	jal	400a64 <strchr>
  400422:	e911                	bnez	a0,400436 <gettoken+0x126>
      s++;
  400424:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
  400426:	fe9913e3          	bne	s2,s1,40040c <gettoken+0xfc>
  if(eq)
  40042a:	84ca                	mv	s1,s2
    ret = 'a';
  40042c:	06100a93          	li	s5,97
  if(eq)
  400430:	f40b1ee3          	bnez	s6,40038c <gettoken+0x7c>
  400434:	bfb5                	j	4003b0 <gettoken+0xa0>
    ret = 'a';
  400436:	06100a93          	li	s5,97
  40043a:	b7b9                	j	400388 <gettoken+0x78>
  40043c:	06100a93          	li	s5,97
  400440:	b7a1                	j	400388 <gettoken+0x78>
  400442:	06100a93          	li	s5,97
  if(eq)
  400446:	f40b13e3          	bnez	s6,40038c <gettoken+0x7c>
  40044a:	b79d                	j	4003b0 <gettoken+0xa0>

000000000040044c <peek>:

int
peek(char **ps, char *es, char *toks)
{
  40044c:	7139                	addi	sp,sp,-64
  40044e:	fc06                	sd	ra,56(sp)
  400450:	f822                	sd	s0,48(sp)
  400452:	f426                	sd	s1,40(sp)
  400454:	f04a                	sd	s2,32(sp)
  400456:	ec4e                	sd	s3,24(sp)
  400458:	e852                	sd	s4,16(sp)
  40045a:	e456                	sd	s5,8(sp)
  40045c:	0080                	addi	s0,sp,64
  40045e:	8a2a                	mv	s4,a0
  400460:	892e                	mv	s2,a1
  400462:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
  400464:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
  400466:	00002997          	auipc	s3,0x2
  40046a:	ba298993          	addi	s3,s3,-1118 # 402008 <whitespace>
  40046e:	00b4fc63          	bgeu	s1,a1,400486 <peek+0x3a>
  400472:	0004c583          	lbu	a1,0(s1)
  400476:	854e                	mv	a0,s3
  400478:	5ec000ef          	jal	400a64 <strchr>
  40047c:	c509                	beqz	a0,400486 <peek+0x3a>
    s++;
  40047e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
  400480:	fe9919e3          	bne	s2,s1,400472 <peek+0x26>
  400484:	84ca                	mv	s1,s2
  *ps = s;
  400486:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
  40048a:	0004c583          	lbu	a1,0(s1)
  40048e:	4501                	li	a0,0
  400490:	e991                	bnez	a1,4004a4 <peek+0x58>
}
  400492:	70e2                	ld	ra,56(sp)
  400494:	7442                	ld	s0,48(sp)
  400496:	74a2                	ld	s1,40(sp)
  400498:	7902                	ld	s2,32(sp)
  40049a:	69e2                	ld	s3,24(sp)
  40049c:	6a42                	ld	s4,16(sp)
  40049e:	6aa2                	ld	s5,8(sp)
  4004a0:	6121                	addi	sp,sp,64
  4004a2:	8082                	ret
  return *s && strchr(toks, *s);
  4004a4:	8556                	mv	a0,s5
  4004a6:	5be000ef          	jal	400a64 <strchr>
  4004aa:	00a03533          	snez	a0,a0
  4004ae:	b7d5                	j	400492 <peek+0x46>

00000000004004b0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  4004b0:	7159                	addi	sp,sp,-112
  4004b2:	f486                	sd	ra,104(sp)
  4004b4:	f0a2                	sd	s0,96(sp)
  4004b6:	eca6                	sd	s1,88(sp)
  4004b8:	e8ca                	sd	s2,80(sp)
  4004ba:	e4ce                	sd	s3,72(sp)
  4004bc:	e0d2                	sd	s4,64(sp)
  4004be:	fc56                	sd	s5,56(sp)
  4004c0:	f85a                	sd	s6,48(sp)
  4004c2:	f45e                	sd	s7,40(sp)
  4004c4:	f062                	sd	s8,32(sp)
  4004c6:	ec66                	sd	s9,24(sp)
  4004c8:	1880                	addi	s0,sp,112
  4004ca:	8a2a                	mv	s4,a0
  4004cc:	89ae                	mv	s3,a1
  4004ce:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
  4004d0:	00001b17          	auipc	s6,0x1
  4004d4:	dc0b0b13          	addi	s6,s6,-576 # 401290 <malloc+0x16e>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
  4004d8:	f9040c93          	addi	s9,s0,-112
  4004dc:	f9840c13          	addi	s8,s0,-104
  4004e0:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
  4004e4:	a00d                	j	400506 <parseredirs+0x56>
      panic("missing file for redirection");
  4004e6:	00001517          	auipc	a0,0x1
  4004ea:	d8a50513          	addi	a0,a0,-630 # 401270 <malloc+0x14e>
  4004ee:	b5dff0ef          	jal	40004a <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
  4004f2:	4701                	li	a4,0
  4004f4:	4681                	li	a3,0
  4004f6:	f9043603          	ld	a2,-112(s0)
  4004fa:	f9843583          	ld	a1,-104(s0)
  4004fe:	8552                	mv	a0,s4
  400500:	d01ff0ef          	jal	400200 <redircmd>
  400504:	8a2a                	mv	s4,a0
    switch(tok){
  400506:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
  40050a:	865a                	mv	a2,s6
  40050c:	85ca                	mv	a1,s2
  40050e:	854e                	mv	a0,s3
  400510:	f3dff0ef          	jal	40044c <peek>
  400514:	c135                	beqz	a0,400578 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
  400516:	4681                	li	a3,0
  400518:	4601                	li	a2,0
  40051a:	85ca                	mv	a1,s2
  40051c:	854e                	mv	a0,s3
  40051e:	df3ff0ef          	jal	400310 <gettoken>
  400522:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
  400524:	86e6                	mv	a3,s9
  400526:	8662                	mv	a2,s8
  400528:	85ca                	mv	a1,s2
  40052a:	854e                	mv	a0,s3
  40052c:	de5ff0ef          	jal	400310 <gettoken>
  400530:	fb751be3          	bne	a0,s7,4004e6 <parseredirs+0x36>
    switch(tok){
  400534:	fb548fe3          	beq	s1,s5,4004f2 <parseredirs+0x42>
  400538:	03e00793          	li	a5,62
  40053c:	02f48263          	beq	s1,a5,400560 <parseredirs+0xb0>
  400540:	02b00793          	li	a5,43
  400544:	fcf493e3          	bne	s1,a5,40050a <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
  400548:	4705                	li	a4,1
  40054a:	20100693          	li	a3,513
  40054e:	f9043603          	ld	a2,-112(s0)
  400552:	f9843583          	ld	a1,-104(s0)
  400556:	8552                	mv	a0,s4
  400558:	ca9ff0ef          	jal	400200 <redircmd>
  40055c:	8a2a                	mv	s4,a0
      break;
  40055e:	b765                	j	400506 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
  400560:	4705                	li	a4,1
  400562:	60100693          	li	a3,1537
  400566:	f9043603          	ld	a2,-112(s0)
  40056a:	f9843583          	ld	a1,-104(s0)
  40056e:	8552                	mv	a0,s4
  400570:	c91ff0ef          	jal	400200 <redircmd>
  400574:	8a2a                	mv	s4,a0
      break;
  400576:	bf41                	j	400506 <parseredirs+0x56>
    }
  }
  return cmd;
}
  400578:	8552                	mv	a0,s4
  40057a:	70a6                	ld	ra,104(sp)
  40057c:	7406                	ld	s0,96(sp)
  40057e:	64e6                	ld	s1,88(sp)
  400580:	6946                	ld	s2,80(sp)
  400582:	69a6                	ld	s3,72(sp)
  400584:	6a06                	ld	s4,64(sp)
  400586:	7ae2                	ld	s5,56(sp)
  400588:	7b42                	ld	s6,48(sp)
  40058a:	7ba2                	ld	s7,40(sp)
  40058c:	7c02                	ld	s8,32(sp)
  40058e:	6ce2                	ld	s9,24(sp)
  400590:	6165                	addi	sp,sp,112
  400592:	8082                	ret

0000000000400594 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
  400594:	7119                	addi	sp,sp,-128
  400596:	fc86                	sd	ra,120(sp)
  400598:	f8a2                	sd	s0,112(sp)
  40059a:	f4a6                	sd	s1,104(sp)
  40059c:	e8d2                	sd	s4,80(sp)
  40059e:	e4d6                	sd	s5,72(sp)
  4005a0:	0100                	addi	s0,sp,128
  4005a2:	8a2a                	mv	s4,a0
  4005a4:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
  4005a6:	00001617          	auipc	a2,0x1
  4005aa:	cf260613          	addi	a2,a2,-782 # 401298 <malloc+0x176>
  4005ae:	e9fff0ef          	jal	40044c <peek>
  4005b2:	e121                	bnez	a0,4005f2 <parseexec+0x5e>
  4005b4:	f0ca                	sd	s2,96(sp)
  4005b6:	ecce                	sd	s3,88(sp)
  4005b8:	e0da                	sd	s6,64(sp)
  4005ba:	fc5e                	sd	s7,56(sp)
  4005bc:	f862                	sd	s8,48(sp)
  4005be:	f466                	sd	s9,40(sp)
  4005c0:	f06a                	sd	s10,32(sp)
  4005c2:	ec6e                	sd	s11,24(sp)
  4005c4:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
  4005c6:	c0dff0ef          	jal	4001d2 <execcmd>
  4005ca:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  4005cc:	8656                	mv	a2,s5
  4005ce:	85d2                	mv	a1,s4
  4005d0:	ee1ff0ef          	jal	4004b0 <parseredirs>
  4005d4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
  4005d6:	008d8913          	addi	s2,s11,8
  4005da:	00001b17          	auipc	s6,0x1
  4005de:	cdeb0b13          	addi	s6,s6,-802 # 4012b8 <malloc+0x196>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
  4005e2:	f8040c13          	addi	s8,s0,-128
  4005e6:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
  4005ea:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
  4005ee:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
  4005f0:	a815                	j	400624 <parseexec+0x90>
    return parseblock(ps, es);
  4005f2:	85d6                	mv	a1,s5
  4005f4:	8552                	mv	a0,s4
  4005f6:	170000ef          	jal	400766 <parseblock>
  4005fa:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
  4005fc:	8526                	mv	a0,s1
  4005fe:	70e6                	ld	ra,120(sp)
  400600:	7446                	ld	s0,112(sp)
  400602:	74a6                	ld	s1,104(sp)
  400604:	6a46                	ld	s4,80(sp)
  400606:	6aa6                	ld	s5,72(sp)
  400608:	6109                	addi	sp,sp,128
  40060a:	8082                	ret
      panic("syntax");
  40060c:	00001517          	auipc	a0,0x1
  400610:	c9450513          	addi	a0,a0,-876 # 4012a0 <malloc+0x17e>
  400614:	a37ff0ef          	jal	40004a <panic>
    ret = parseredirs(ret, ps, es);
  400618:	8656                	mv	a2,s5
  40061a:	85d2                	mv	a1,s4
  40061c:	8526                	mv	a0,s1
  40061e:	e93ff0ef          	jal	4004b0 <parseredirs>
  400622:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
  400624:	865a                	mv	a2,s6
  400626:	85d6                	mv	a1,s5
  400628:	8552                	mv	a0,s4
  40062a:	e23ff0ef          	jal	40044c <peek>
  40062e:	ed05                	bnez	a0,400666 <parseexec+0xd2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
  400630:	86e2                	mv	a3,s8
  400632:	865e                	mv	a2,s7
  400634:	85d6                	mv	a1,s5
  400636:	8552                	mv	a0,s4
  400638:	cd9ff0ef          	jal	400310 <gettoken>
  40063c:	c50d                	beqz	a0,400666 <parseexec+0xd2>
    if(tok != 'a')
  40063e:	fda517e3          	bne	a0,s10,40060c <parseexec+0x78>
    cmd->argv[argc] = q;
  400642:	f8843783          	ld	a5,-120(s0)
  400646:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
  40064a:	f8043783          	ld	a5,-128(s0)
  40064e:	04f93823          	sd	a5,80(s2)
    argc++;
  400652:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
  400654:	0921                	addi	s2,s2,8
  400656:	fd9991e3          	bne	s3,s9,400618 <parseexec+0x84>
      panic("too many args");
  40065a:	00001517          	auipc	a0,0x1
  40065e:	c4e50513          	addi	a0,a0,-946 # 4012a8 <malloc+0x186>
  400662:	9e9ff0ef          	jal	40004a <panic>
  cmd->argv[argc] = 0;
  400666:	098e                	slli	s3,s3,0x3
  400668:	9dce                	add	s11,s11,s3
  40066a:	000db423          	sd	zero,8(s11)
  cmd->eargv[argc] = 0;
  40066e:	040dbc23          	sd	zero,88(s11)
  400672:	7906                	ld	s2,96(sp)
  400674:	69e6                	ld	s3,88(sp)
  400676:	6b06                	ld	s6,64(sp)
  400678:	7be2                	ld	s7,56(sp)
  40067a:	7c42                	ld	s8,48(sp)
  40067c:	7ca2                	ld	s9,40(sp)
  40067e:	7d02                	ld	s10,32(sp)
  400680:	6de2                	ld	s11,24(sp)
  return ret;
  400682:	bfad                	j	4005fc <parseexec+0x68>

0000000000400684 <parsepipe>:
{
  400684:	7179                	addi	sp,sp,-48
  400686:	f406                	sd	ra,40(sp)
  400688:	f022                	sd	s0,32(sp)
  40068a:	ec26                	sd	s1,24(sp)
  40068c:	e84a                	sd	s2,16(sp)
  40068e:	e44e                	sd	s3,8(sp)
  400690:	1800                	addi	s0,sp,48
  400692:	892a                	mv	s2,a0
  400694:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
  400696:	effff0ef          	jal	400594 <parseexec>
  40069a:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
  40069c:	00001617          	auipc	a2,0x1
  4006a0:	c2460613          	addi	a2,a2,-988 # 4012c0 <malloc+0x19e>
  4006a4:	85ce                	mv	a1,s3
  4006a6:	854a                	mv	a0,s2
  4006a8:	da5ff0ef          	jal	40044c <peek>
  4006ac:	e909                	bnez	a0,4006be <parsepipe+0x3a>
}
  4006ae:	8526                	mv	a0,s1
  4006b0:	70a2                	ld	ra,40(sp)
  4006b2:	7402                	ld	s0,32(sp)
  4006b4:	64e2                	ld	s1,24(sp)
  4006b6:	6942                	ld	s2,16(sp)
  4006b8:	69a2                	ld	s3,8(sp)
  4006ba:	6145                	addi	sp,sp,48
  4006bc:	8082                	ret
    gettoken(ps, es, 0, 0);
  4006be:	4681                	li	a3,0
  4006c0:	4601                	li	a2,0
  4006c2:	85ce                	mv	a1,s3
  4006c4:	854a                	mv	a0,s2
  4006c6:	c4bff0ef          	jal	400310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
  4006ca:	85ce                	mv	a1,s3
  4006cc:	854a                	mv	a0,s2
  4006ce:	fb7ff0ef          	jal	400684 <parsepipe>
  4006d2:	85aa                	mv	a1,a0
  4006d4:	8526                	mv	a0,s1
  4006d6:	b8bff0ef          	jal	400260 <pipecmd>
  4006da:	84aa                	mv	s1,a0
  return cmd;
  4006dc:	bfc9                	j	4006ae <parsepipe+0x2a>

00000000004006de <parseline>:
{
  4006de:	7179                	addi	sp,sp,-48
  4006e0:	f406                	sd	ra,40(sp)
  4006e2:	f022                	sd	s0,32(sp)
  4006e4:	ec26                	sd	s1,24(sp)
  4006e6:	e84a                	sd	s2,16(sp)
  4006e8:	e44e                	sd	s3,8(sp)
  4006ea:	e052                	sd	s4,0(sp)
  4006ec:	1800                	addi	s0,sp,48
  4006ee:	892a                	mv	s2,a0
  4006f0:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
  4006f2:	f93ff0ef          	jal	400684 <parsepipe>
  4006f6:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
  4006f8:	00001a17          	auipc	s4,0x1
  4006fc:	bd0a0a13          	addi	s4,s4,-1072 # 4012c8 <malloc+0x1a6>
  400700:	a819                	j	400716 <parseline+0x38>
    gettoken(ps, es, 0, 0);
  400702:	4681                	li	a3,0
  400704:	4601                	li	a2,0
  400706:	85ce                	mv	a1,s3
  400708:	854a                	mv	a0,s2
  40070a:	c07ff0ef          	jal	400310 <gettoken>
    cmd = backcmd(cmd);
  40070e:	8526                	mv	a0,s1
  400710:	bcdff0ef          	jal	4002dc <backcmd>
  400714:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
  400716:	8652                	mv	a2,s4
  400718:	85ce                	mv	a1,s3
  40071a:	854a                	mv	a0,s2
  40071c:	d31ff0ef          	jal	40044c <peek>
  400720:	f16d                	bnez	a0,400702 <parseline+0x24>
  if(peek(ps, es, ";")){
  400722:	00001617          	auipc	a2,0x1
  400726:	bae60613          	addi	a2,a2,-1106 # 4012d0 <malloc+0x1ae>
  40072a:	85ce                	mv	a1,s3
  40072c:	854a                	mv	a0,s2
  40072e:	d1fff0ef          	jal	40044c <peek>
  400732:	e911                	bnez	a0,400746 <parseline+0x68>
}
  400734:	8526                	mv	a0,s1
  400736:	70a2                	ld	ra,40(sp)
  400738:	7402                	ld	s0,32(sp)
  40073a:	64e2                	ld	s1,24(sp)
  40073c:	6942                	ld	s2,16(sp)
  40073e:	69a2                	ld	s3,8(sp)
  400740:	6a02                	ld	s4,0(sp)
  400742:	6145                	addi	sp,sp,48
  400744:	8082                	ret
    gettoken(ps, es, 0, 0);
  400746:	4681                	li	a3,0
  400748:	4601                	li	a2,0
  40074a:	85ce                	mv	a1,s3
  40074c:	854a                	mv	a0,s2
  40074e:	bc3ff0ef          	jal	400310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
  400752:	85ce                	mv	a1,s3
  400754:	854a                	mv	a0,s2
  400756:	f89ff0ef          	jal	4006de <parseline>
  40075a:	85aa                	mv	a1,a0
  40075c:	8526                	mv	a0,s1
  40075e:	b41ff0ef          	jal	40029e <listcmd>
  400762:	84aa                	mv	s1,a0
  return cmd;
  400764:	bfc1                	j	400734 <parseline+0x56>

0000000000400766 <parseblock>:
{
  400766:	7179                	addi	sp,sp,-48
  400768:	f406                	sd	ra,40(sp)
  40076a:	f022                	sd	s0,32(sp)
  40076c:	ec26                	sd	s1,24(sp)
  40076e:	e84a                	sd	s2,16(sp)
  400770:	e44e                	sd	s3,8(sp)
  400772:	1800                	addi	s0,sp,48
  400774:	84aa                	mv	s1,a0
  400776:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
  400778:	00001617          	auipc	a2,0x1
  40077c:	b2060613          	addi	a2,a2,-1248 # 401298 <malloc+0x176>
  400780:	ccdff0ef          	jal	40044c <peek>
  400784:	c539                	beqz	a0,4007d2 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
  400786:	4681                	li	a3,0
  400788:	4601                	li	a2,0
  40078a:	85ca                	mv	a1,s2
  40078c:	8526                	mv	a0,s1
  40078e:	b83ff0ef          	jal	400310 <gettoken>
  cmd = parseline(ps, es);
  400792:	85ca                	mv	a1,s2
  400794:	8526                	mv	a0,s1
  400796:	f49ff0ef          	jal	4006de <parseline>
  40079a:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
  40079c:	00001617          	auipc	a2,0x1
  4007a0:	b4c60613          	addi	a2,a2,-1204 # 4012e8 <malloc+0x1c6>
  4007a4:	85ca                	mv	a1,s2
  4007a6:	8526                	mv	a0,s1
  4007a8:	ca5ff0ef          	jal	40044c <peek>
  4007ac:	c90d                	beqz	a0,4007de <parseblock+0x78>
  gettoken(ps, es, 0, 0);
  4007ae:	4681                	li	a3,0
  4007b0:	4601                	li	a2,0
  4007b2:	85ca                	mv	a1,s2
  4007b4:	8526                	mv	a0,s1
  4007b6:	b5bff0ef          	jal	400310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
  4007ba:	864a                	mv	a2,s2
  4007bc:	85a6                	mv	a1,s1
  4007be:	854e                	mv	a0,s3
  4007c0:	cf1ff0ef          	jal	4004b0 <parseredirs>
}
  4007c4:	70a2                	ld	ra,40(sp)
  4007c6:	7402                	ld	s0,32(sp)
  4007c8:	64e2                	ld	s1,24(sp)
  4007ca:	6942                	ld	s2,16(sp)
  4007cc:	69a2                	ld	s3,8(sp)
  4007ce:	6145                	addi	sp,sp,48
  4007d0:	8082                	ret
    panic("parseblock");
  4007d2:	00001517          	auipc	a0,0x1
  4007d6:	b0650513          	addi	a0,a0,-1274 # 4012d8 <malloc+0x1b6>
  4007da:	871ff0ef          	jal	40004a <panic>
    panic("syntax - missing )");
  4007de:	00001517          	auipc	a0,0x1
  4007e2:	b1250513          	addi	a0,a0,-1262 # 4012f0 <malloc+0x1ce>
  4007e6:	865ff0ef          	jal	40004a <panic>

00000000004007ea <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
  4007ea:	1101                	addi	sp,sp,-32
  4007ec:	ec06                	sd	ra,24(sp)
  4007ee:	e822                	sd	s0,16(sp)
  4007f0:	e426                	sd	s1,8(sp)
  4007f2:	1000                	addi	s0,sp,32
  4007f4:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
  4007f6:	c131                	beqz	a0,40083a <nulterminate+0x50>
    return 0;

  switch(cmd->type){
  4007f8:	4118                	lw	a4,0(a0)
  4007fa:	4795                	li	a5,5
  4007fc:	02e7ef63          	bltu	a5,a4,40083a <nulterminate+0x50>
  400800:	00056783          	lwu	a5,0(a0)
  400804:	078a                	slli	a5,a5,0x2
  400806:	00001717          	auipc	a4,0x1
  40080a:	b4a70713          	addi	a4,a4,-1206 # 401350 <malloc+0x22e>
  40080e:	97ba                	add	a5,a5,a4
  400810:	439c                	lw	a5,0(a5)
  400812:	97ba                	add	a5,a5,a4
  400814:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
  400816:	651c                	ld	a5,8(a0)
  400818:	c38d                	beqz	a5,40083a <nulterminate+0x50>
  40081a:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
  40081e:	67b8                	ld	a4,72(a5)
  400820:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
  400824:	07a1                	addi	a5,a5,8
  400826:	ff87b703          	ld	a4,-8(a5)
  40082a:	fb75                	bnez	a4,40081e <nulterminate+0x34>
  40082c:	a039                	j	40083a <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
  40082e:	6508                	ld	a0,8(a0)
  400830:	fbbff0ef          	jal	4007ea <nulterminate>
    *rcmd->efile = 0;
  400834:	6c9c                	ld	a5,24(s1)
  400836:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
  40083a:	8526                	mv	a0,s1
  40083c:	60e2                	ld	ra,24(sp)
  40083e:	6442                	ld	s0,16(sp)
  400840:	64a2                	ld	s1,8(sp)
  400842:	6105                	addi	sp,sp,32
  400844:	8082                	ret
    nulterminate(pcmd->left);
  400846:	6508                	ld	a0,8(a0)
  400848:	fa3ff0ef          	jal	4007ea <nulterminate>
    nulterminate(pcmd->right);
  40084c:	6888                	ld	a0,16(s1)
  40084e:	f9dff0ef          	jal	4007ea <nulterminate>
    break;
  400852:	b7e5                	j	40083a <nulterminate+0x50>
    nulterminate(lcmd->left);
  400854:	6508                	ld	a0,8(a0)
  400856:	f95ff0ef          	jal	4007ea <nulterminate>
    nulterminate(lcmd->right);
  40085a:	6888                	ld	a0,16(s1)
  40085c:	f8fff0ef          	jal	4007ea <nulterminate>
    break;
  400860:	bfe9                	j	40083a <nulterminate+0x50>
    nulterminate(bcmd->cmd);
  400862:	6508                	ld	a0,8(a0)
  400864:	f87ff0ef          	jal	4007ea <nulterminate>
    break;
  400868:	bfc9                	j	40083a <nulterminate+0x50>

000000000040086a <parsecmd>:
{
  40086a:	7139                	addi	sp,sp,-64
  40086c:	fc06                	sd	ra,56(sp)
  40086e:	f822                	sd	s0,48(sp)
  400870:	f426                	sd	s1,40(sp)
  400872:	f04a                	sd	s2,32(sp)
  400874:	ec4e                	sd	s3,24(sp)
  400876:	0080                	addi	s0,sp,64
  400878:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
  40087c:	84aa                	mv	s1,a0
  40087e:	192000ef          	jal	400a10 <strlen>
  400882:	1502                	slli	a0,a0,0x20
  400884:	9101                	srli	a0,a0,0x20
  400886:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
  400888:	fc840993          	addi	s3,s0,-56
  40088c:	85a6                	mv	a1,s1
  40088e:	854e                	mv	a0,s3
  400890:	e4fff0ef          	jal	4006de <parseline>
  400894:	892a                	mv	s2,a0
  peek(&s, es, "");
  400896:	00001617          	auipc	a2,0x1
  40089a:	99260613          	addi	a2,a2,-1646 # 401228 <malloc+0x106>
  40089e:	85a6                	mv	a1,s1
  4008a0:	854e                	mv	a0,s3
  4008a2:	babff0ef          	jal	40044c <peek>
  if(s != es){
  4008a6:	fc843603          	ld	a2,-56(s0)
  4008aa:	00961d63          	bne	a2,s1,4008c4 <parsecmd+0x5a>
  nulterminate(cmd);
  4008ae:	854a                	mv	a0,s2
  4008b0:	f3bff0ef          	jal	4007ea <nulterminate>
}
  4008b4:	854a                	mv	a0,s2
  4008b6:	70e2                	ld	ra,56(sp)
  4008b8:	7442                	ld	s0,48(sp)
  4008ba:	74a2                	ld	s1,40(sp)
  4008bc:	7902                	ld	s2,32(sp)
  4008be:	69e2                	ld	s3,24(sp)
  4008c0:	6121                	addi	sp,sp,64
  4008c2:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
  4008c4:	00001597          	auipc	a1,0x1
  4008c8:	a4458593          	addi	a1,a1,-1468 # 401308 <malloc+0x1e6>
  4008cc:	4509                	li	a0,2
  4008ce:	76e000ef          	jal	40103c <fprintf>
    panic("syntax");
  4008d2:	00001517          	auipc	a0,0x1
  4008d6:	9ce50513          	addi	a0,a0,-1586 # 4012a0 <malloc+0x17e>
  4008da:	f70ff0ef          	jal	40004a <panic>

00000000004008de <main>:
{
  4008de:	7139                	addi	sp,sp,-64
  4008e0:	fc06                	sd	ra,56(sp)
  4008e2:	f822                	sd	s0,48(sp)
  4008e4:	f426                	sd	s1,40(sp)
  4008e6:	f04a                	sd	s2,32(sp)
  4008e8:	ec4e                	sd	s3,24(sp)
  4008ea:	e852                	sd	s4,16(sp)
  4008ec:	e456                	sd	s5,8(sp)
  4008ee:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
  4008f0:	4489                	li	s1,2
  4008f2:	00001917          	auipc	s2,0x1
  4008f6:	a2690913          	addi	s2,s2,-1498 # 401318 <malloc+0x1f6>
  4008fa:	85a6                	mv	a1,s1
  4008fc:	854a                	mv	a0,s2
  4008fe:	38e000ef          	jal	400c8c <open>
  400902:	00054663          	bltz	a0,40090e <main+0x30>
    if(fd >= 3){
  400906:	fea4dae3          	bge	s1,a0,4008fa <main+0x1c>
      close(fd);
  40090a:	36a000ef          	jal	400c74 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
  40090e:	00001497          	auipc	s1,0x1
  400912:	71248493          	addi	s1,s1,1810 # 402020 <buf.0>
  400916:	06400913          	li	s2,100
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
  40091a:	06300993          	li	s3,99
  40091e:	02000a13          	li	s4,32
  400922:	a039                	j	400930 <main+0x52>
    if(fork1() == 0)
  400924:	f44ff0ef          	jal	400068 <fork1>
  400928:	c925                	beqz	a0,400998 <main+0xba>
    wait(0);
  40092a:	4501                	li	a0,0
  40092c:	328000ef          	jal	400c54 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
  400930:	85ca                	mv	a1,s2
  400932:	8526                	mv	a0,s1
  400934:	eccff0ef          	jal	400000 <getcmd>
  400938:	06054863          	bltz	a0,4009a8 <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
  40093c:	0004c783          	lbu	a5,0(s1)
  400940:	ff3792e3          	bne	a5,s3,400924 <main+0x46>
  400944:	0014c783          	lbu	a5,1(s1)
  400948:	fd279ee3          	bne	a5,s2,400924 <main+0x46>
  40094c:	0024c783          	lbu	a5,2(s1)
  400950:	fd479ae3          	bne	a5,s4,400924 <main+0x46>
      buf[strlen(buf)-1] = 0;  // chop \n
  400954:	00001a97          	auipc	s5,0x1
  400958:	6cca8a93          	addi	s5,s5,1740 # 402020 <buf.0>
  40095c:	8556                	mv	a0,s5
  40095e:	0b2000ef          	jal	400a10 <strlen>
  400962:	fff5079b          	addiw	a5,a0,-1
  400966:	1782                	slli	a5,a5,0x20
  400968:	9381                	srli	a5,a5,0x20
  40096a:	9abe                	add	s5,s5,a5
  40096c:	000a8023          	sb	zero,0(s5)
      if(chdir(buf+3) < 0)
  400970:	00001517          	auipc	a0,0x1
  400974:	6b350513          	addi	a0,a0,1715 # 402023 <buf.0+0x3>
  400978:	344000ef          	jal	400cbc <chdir>
  40097c:	fa055ae3          	bgez	a0,400930 <main+0x52>
        fprintf(2, "cannot cd %s\n", buf+3);
  400980:	00001617          	auipc	a2,0x1
  400984:	6a360613          	addi	a2,a2,1699 # 402023 <buf.0+0x3>
  400988:	00001597          	auipc	a1,0x1
  40098c:	99858593          	addi	a1,a1,-1640 # 401320 <malloc+0x1fe>
  400990:	4509                	li	a0,2
  400992:	6aa000ef          	jal	40103c <fprintf>
  400996:	bf69                	j	400930 <main+0x52>
      runcmd(parsecmd(buf));
  400998:	00001517          	auipc	a0,0x1
  40099c:	68850513          	addi	a0,a0,1672 # 402020 <buf.0>
  4009a0:	ecbff0ef          	jal	40086a <parsecmd>
  4009a4:	eeaff0ef          	jal	40008e <runcmd>
  exit(0);
  4009a8:	4501                	li	a0,0
  4009aa:	2a2000ef          	jal	400c4c <exit>

00000000004009ae <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4009ae:	1141                	addi	sp,sp,-16
  4009b0:	e406                	sd	ra,8(sp)
  4009b2:	e022                	sd	s0,0(sp)
  4009b4:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4009b6:	f29ff0ef          	jal	4008de <main>
  exit(0);
  4009ba:	4501                	li	a0,0
  4009bc:	290000ef          	jal	400c4c <exit>

00000000004009c0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  4009c0:	1141                	addi	sp,sp,-16
  4009c2:	e406                	sd	ra,8(sp)
  4009c4:	e022                	sd	s0,0(sp)
  4009c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4009c8:	87aa                	mv	a5,a0
  4009ca:	0585                	addi	a1,a1,1
  4009cc:	0785                	addi	a5,a5,1
  4009ce:	fff5c703          	lbu	a4,-1(a1)
  4009d2:	fee78fa3          	sb	a4,-1(a5)
  4009d6:	fb75                	bnez	a4,4009ca <strcpy+0xa>
    ;
  return os;
}
  4009d8:	60a2                	ld	ra,8(sp)
  4009da:	6402                	ld	s0,0(sp)
  4009dc:	0141                	addi	sp,sp,16
  4009de:	8082                	ret

00000000004009e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4009e0:	1141                	addi	sp,sp,-16
  4009e2:	e406                	sd	ra,8(sp)
  4009e4:	e022                	sd	s0,0(sp)
  4009e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4009e8:	00054783          	lbu	a5,0(a0)
  4009ec:	cb91                	beqz	a5,400a00 <strcmp+0x20>
  4009ee:	0005c703          	lbu	a4,0(a1)
  4009f2:	00f71763          	bne	a4,a5,400a00 <strcmp+0x20>
    p++, q++;
  4009f6:	0505                	addi	a0,a0,1
  4009f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4009fa:	00054783          	lbu	a5,0(a0)
  4009fe:	fbe5                	bnez	a5,4009ee <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  400a00:	0005c503          	lbu	a0,0(a1)
}
  400a04:	40a7853b          	subw	a0,a5,a0
  400a08:	60a2                	ld	ra,8(sp)
  400a0a:	6402                	ld	s0,0(sp)
  400a0c:	0141                	addi	sp,sp,16
  400a0e:	8082                	ret

0000000000400a10 <strlen>:

uint
strlen(const char *s)
{
  400a10:	1141                	addi	sp,sp,-16
  400a12:	e406                	sd	ra,8(sp)
  400a14:	e022                	sd	s0,0(sp)
  400a16:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  400a18:	00054783          	lbu	a5,0(a0)
  400a1c:	cf99                	beqz	a5,400a3a <strlen+0x2a>
  400a1e:	0505                	addi	a0,a0,1
  400a20:	87aa                	mv	a5,a0
  400a22:	86be                	mv	a3,a5
  400a24:	0785                	addi	a5,a5,1
  400a26:	fff7c703          	lbu	a4,-1(a5)
  400a2a:	ff65                	bnez	a4,400a22 <strlen+0x12>
  400a2c:	40a6853b          	subw	a0,a3,a0
  400a30:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  400a32:	60a2                	ld	ra,8(sp)
  400a34:	6402                	ld	s0,0(sp)
  400a36:	0141                	addi	sp,sp,16
  400a38:	8082                	ret
  for(n = 0; s[n]; n++)
  400a3a:	4501                	li	a0,0
  400a3c:	bfdd                	j	400a32 <strlen+0x22>

0000000000400a3e <memset>:

void*
memset(void *dst, int c, uint n)
{
  400a3e:	1141                	addi	sp,sp,-16
  400a40:	e406                	sd	ra,8(sp)
  400a42:	e022                	sd	s0,0(sp)
  400a44:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  400a46:	ca19                	beqz	a2,400a5c <memset+0x1e>
  400a48:	87aa                	mv	a5,a0
  400a4a:	1602                	slli	a2,a2,0x20
  400a4c:	9201                	srli	a2,a2,0x20
  400a4e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  400a52:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  400a56:	0785                	addi	a5,a5,1
  400a58:	fee79de3          	bne	a5,a4,400a52 <memset+0x14>
  }
  return dst;
}
  400a5c:	60a2                	ld	ra,8(sp)
  400a5e:	6402                	ld	s0,0(sp)
  400a60:	0141                	addi	sp,sp,16
  400a62:	8082                	ret

0000000000400a64 <strchr>:

char*
strchr(const char *s, char c)
{
  400a64:	1141                	addi	sp,sp,-16
  400a66:	e406                	sd	ra,8(sp)
  400a68:	e022                	sd	s0,0(sp)
  400a6a:	0800                	addi	s0,sp,16
  for(; *s; s++)
  400a6c:	00054783          	lbu	a5,0(a0)
  400a70:	cf81                	beqz	a5,400a88 <strchr+0x24>
    if(*s == c)
  400a72:	00f58763          	beq	a1,a5,400a80 <strchr+0x1c>
  for(; *s; s++)
  400a76:	0505                	addi	a0,a0,1
  400a78:	00054783          	lbu	a5,0(a0)
  400a7c:	fbfd                	bnez	a5,400a72 <strchr+0xe>
      return (char*)s;
  return 0;
  400a7e:	4501                	li	a0,0
}
  400a80:	60a2                	ld	ra,8(sp)
  400a82:	6402                	ld	s0,0(sp)
  400a84:	0141                	addi	sp,sp,16
  400a86:	8082                	ret
  return 0;
  400a88:	4501                	li	a0,0
  400a8a:	bfdd                	j	400a80 <strchr+0x1c>

0000000000400a8c <gets>:

char*
gets(char *buf, int max)
{
  400a8c:	7159                	addi	sp,sp,-112
  400a8e:	f486                	sd	ra,104(sp)
  400a90:	f0a2                	sd	s0,96(sp)
  400a92:	eca6                	sd	s1,88(sp)
  400a94:	e8ca                	sd	s2,80(sp)
  400a96:	e4ce                	sd	s3,72(sp)
  400a98:	e0d2                	sd	s4,64(sp)
  400a9a:	fc56                	sd	s5,56(sp)
  400a9c:	f85a                	sd	s6,48(sp)
  400a9e:	f45e                	sd	s7,40(sp)
  400aa0:	f062                	sd	s8,32(sp)
  400aa2:	ec66                	sd	s9,24(sp)
  400aa4:	e86a                	sd	s10,16(sp)
  400aa6:	1880                	addi	s0,sp,112
  400aa8:	8caa                	mv	s9,a0
  400aaa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  400aac:	892a                	mv	s2,a0
  400aae:	4481                	li	s1,0
    cc = read(0, &c, 1);
  400ab0:	f9f40b13          	addi	s6,s0,-97
  400ab4:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  400ab6:	4ba9                	li	s7,10
  400ab8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
  400aba:	8d26                	mv	s10,s1
  400abc:	0014899b          	addiw	s3,s1,1
  400ac0:	84ce                	mv	s1,s3
  400ac2:	0349d563          	bge	s3,s4,400aec <gets+0x60>
    cc = read(0, &c, 1);
  400ac6:	8656                	mv	a2,s5
  400ac8:	85da                	mv	a1,s6
  400aca:	4501                	li	a0,0
  400acc:	198000ef          	jal	400c64 <read>
    if(cc < 1)
  400ad0:	00a05e63          	blez	a0,400aec <gets+0x60>
    buf[i++] = c;
  400ad4:	f9f44783          	lbu	a5,-97(s0)
  400ad8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  400adc:	01778763          	beq	a5,s7,400aea <gets+0x5e>
  400ae0:	0905                	addi	s2,s2,1
  400ae2:	fd879ce3          	bne	a5,s8,400aba <gets+0x2e>
    buf[i++] = c;
  400ae6:	8d4e                	mv	s10,s3
  400ae8:	a011                	j	400aec <gets+0x60>
  400aea:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
  400aec:	9d66                	add	s10,s10,s9
  400aee:	000d0023          	sb	zero,0(s10)
  return buf;
}
  400af2:	8566                	mv	a0,s9
  400af4:	70a6                	ld	ra,104(sp)
  400af6:	7406                	ld	s0,96(sp)
  400af8:	64e6                	ld	s1,88(sp)
  400afa:	6946                	ld	s2,80(sp)
  400afc:	69a6                	ld	s3,72(sp)
  400afe:	6a06                	ld	s4,64(sp)
  400b00:	7ae2                	ld	s5,56(sp)
  400b02:	7b42                	ld	s6,48(sp)
  400b04:	7ba2                	ld	s7,40(sp)
  400b06:	7c02                	ld	s8,32(sp)
  400b08:	6ce2                	ld	s9,24(sp)
  400b0a:	6d42                	ld	s10,16(sp)
  400b0c:	6165                	addi	sp,sp,112
  400b0e:	8082                	ret

0000000000400b10 <stat>:

int
stat(const char *n, struct stat *st)
{
  400b10:	1101                	addi	sp,sp,-32
  400b12:	ec06                	sd	ra,24(sp)
  400b14:	e822                	sd	s0,16(sp)
  400b16:	e04a                	sd	s2,0(sp)
  400b18:	1000                	addi	s0,sp,32
  400b1a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  400b1c:	4581                	li	a1,0
  400b1e:	16e000ef          	jal	400c8c <open>
  if(fd < 0)
  400b22:	02054263          	bltz	a0,400b46 <stat+0x36>
  400b26:	e426                	sd	s1,8(sp)
  400b28:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
  400b2a:	85ca                	mv	a1,s2
  400b2c:	178000ef          	jal	400ca4 <fstat>
  400b30:	892a                	mv	s2,a0
  close(fd);
  400b32:	8526                	mv	a0,s1
  400b34:	140000ef          	jal	400c74 <close>
  return r;
  400b38:	64a2                	ld	s1,8(sp)
}
  400b3a:	854a                	mv	a0,s2
  400b3c:	60e2                	ld	ra,24(sp)
  400b3e:	6442                	ld	s0,16(sp)
  400b40:	6902                	ld	s2,0(sp)
  400b42:	6105                	addi	sp,sp,32
  400b44:	8082                	ret
    return -1;
  400b46:	597d                	li	s2,-1
  400b48:	bfcd                	j	400b3a <stat+0x2a>

0000000000400b4a <atoi>:

int
atoi(const char *s)
{
  400b4a:	1141                	addi	sp,sp,-16
  400b4c:	e406                	sd	ra,8(sp)
  400b4e:	e022                	sd	s0,0(sp)
  400b50:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
  400b52:	00054683          	lbu	a3,0(a0)
  400b56:	fd06879b          	addiw	a5,a3,-48
  400b5a:	0ff7f793          	zext.b	a5,a5
  400b5e:	4625                	li	a2,9
  400b60:	02f66963          	bltu	a2,a5,400b92 <atoi+0x48>
  400b64:	872a                	mv	a4,a0
  n = 0;
  400b66:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
  400b68:	0705                	addi	a4,a4,1
  400b6a:	0025179b          	slliw	a5,a0,0x2
  400b6e:	9fa9                	addw	a5,a5,a0
  400b70:	0017979b          	slliw	a5,a5,0x1
  400b74:	9fb5                	addw	a5,a5,a3
  400b76:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
  400b7a:	00074683          	lbu	a3,0(a4)
  400b7e:	fd06879b          	addiw	a5,a3,-48
  400b82:	0ff7f793          	zext.b	a5,a5
  400b86:	fef671e3          	bgeu	a2,a5,400b68 <atoi+0x1e>
  return n;
}
  400b8a:	60a2                	ld	ra,8(sp)
  400b8c:	6402                	ld	s0,0(sp)
  400b8e:	0141                	addi	sp,sp,16
  400b90:	8082                	ret
  n = 0;
  400b92:	4501                	li	a0,0
  400b94:	bfdd                	j	400b8a <atoi+0x40>

0000000000400b96 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
  400b96:	1141                	addi	sp,sp,-16
  400b98:	e406                	sd	ra,8(sp)
  400b9a:	e022                	sd	s0,0(sp)
  400b9c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
  400b9e:	02b57563          	bgeu	a0,a1,400bc8 <memmove+0x32>
    while(n-- > 0)
  400ba2:	00c05f63          	blez	a2,400bc0 <memmove+0x2a>
  400ba6:	1602                	slli	a2,a2,0x20
  400ba8:	9201                	srli	a2,a2,0x20
  400baa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
  400bae:	872a                	mv	a4,a0
      *dst++ = *src++;
  400bb0:	0585                	addi	a1,a1,1
  400bb2:	0705                	addi	a4,a4,1
  400bb4:	fff5c683          	lbu	a3,-1(a1)
  400bb8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
  400bbc:	fee79ae3          	bne	a5,a4,400bb0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
  400bc0:	60a2                	ld	ra,8(sp)
  400bc2:	6402                	ld	s0,0(sp)
  400bc4:	0141                	addi	sp,sp,16
  400bc6:	8082                	ret
    dst += n;
  400bc8:	00c50733          	add	a4,a0,a2
    src += n;
  400bcc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
  400bce:	fec059e3          	blez	a2,400bc0 <memmove+0x2a>
  400bd2:	fff6079b          	addiw	a5,a2,-1
  400bd6:	1782                	slli	a5,a5,0x20
  400bd8:	9381                	srli	a5,a5,0x20
  400bda:	fff7c793          	not	a5,a5
  400bde:	97ba                	add	a5,a5,a4
      *--dst = *--src;
  400be0:	15fd                	addi	a1,a1,-1
  400be2:	177d                	addi	a4,a4,-1
  400be4:	0005c683          	lbu	a3,0(a1)
  400be8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
  400bec:	fef71ae3          	bne	a4,a5,400be0 <memmove+0x4a>
  400bf0:	bfc1                	j	400bc0 <memmove+0x2a>

0000000000400bf2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
  400bf2:	1141                	addi	sp,sp,-16
  400bf4:	e406                	sd	ra,8(sp)
  400bf6:	e022                	sd	s0,0(sp)
  400bf8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
  400bfa:	ca0d                	beqz	a2,400c2c <memcmp+0x3a>
  400bfc:	fff6069b          	addiw	a3,a2,-1
  400c00:	1682                	slli	a3,a3,0x20
  400c02:	9281                	srli	a3,a3,0x20
  400c04:	0685                	addi	a3,a3,1
  400c06:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
  400c08:	00054783          	lbu	a5,0(a0)
  400c0c:	0005c703          	lbu	a4,0(a1)
  400c10:	00e79863          	bne	a5,a4,400c20 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
  400c14:	0505                	addi	a0,a0,1
    p2++;
  400c16:	0585                	addi	a1,a1,1
  while (n-- > 0) {
  400c18:	fed518e3          	bne	a0,a3,400c08 <memcmp+0x16>
  }
  return 0;
  400c1c:	4501                	li	a0,0
  400c1e:	a019                	j	400c24 <memcmp+0x32>
      return *p1 - *p2;
  400c20:	40e7853b          	subw	a0,a5,a4
}
  400c24:	60a2                	ld	ra,8(sp)
  400c26:	6402                	ld	s0,0(sp)
  400c28:	0141                	addi	sp,sp,16
  400c2a:	8082                	ret
  return 0;
  400c2c:	4501                	li	a0,0
  400c2e:	bfdd                	j	400c24 <memcmp+0x32>

0000000000400c30 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
  400c30:	1141                	addi	sp,sp,-16
  400c32:	e406                	sd	ra,8(sp)
  400c34:	e022                	sd	s0,0(sp)
  400c36:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
  400c38:	f5fff0ef          	jal	400b96 <memmove>
}
  400c3c:	60a2                	ld	ra,8(sp)
  400c3e:	6402                	ld	s0,0(sp)
  400c40:	0141                	addi	sp,sp,16
  400c42:	8082                	ret

0000000000400c44 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
  400c44:	4885                	li	a7,1
 ecall
  400c46:	00000073          	ecall
 ret
  400c4a:	8082                	ret

0000000000400c4c <exit>:
.global exit
exit:
 li a7, SYS_exit
  400c4c:	4889                	li	a7,2
 ecall
  400c4e:	00000073          	ecall
 ret
  400c52:	8082                	ret

0000000000400c54 <wait>:
.global wait
wait:
 li a7, SYS_wait
  400c54:	488d                	li	a7,3
 ecall
  400c56:	00000073          	ecall
 ret
  400c5a:	8082                	ret

0000000000400c5c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
  400c5c:	4891                	li	a7,4
 ecall
  400c5e:	00000073          	ecall
 ret
  400c62:	8082                	ret

0000000000400c64 <read>:
.global read
read:
 li a7, SYS_read
  400c64:	4895                	li	a7,5
 ecall
  400c66:	00000073          	ecall
 ret
  400c6a:	8082                	ret

0000000000400c6c <write>:
.global write
write:
 li a7, SYS_write
  400c6c:	48c1                	li	a7,16
 ecall
  400c6e:	00000073          	ecall
 ret
  400c72:	8082                	ret

0000000000400c74 <close>:
.global close
close:
 li a7, SYS_close
  400c74:	48d5                	li	a7,21
 ecall
  400c76:	00000073          	ecall
 ret
  400c7a:	8082                	ret

0000000000400c7c <kill>:
.global kill
kill:
 li a7, SYS_kill
  400c7c:	4899                	li	a7,6
 ecall
  400c7e:	00000073          	ecall
 ret
  400c82:	8082                	ret

0000000000400c84 <exec>:
.global exec
exec:
 li a7, SYS_exec
  400c84:	489d                	li	a7,7
 ecall
  400c86:	00000073          	ecall
 ret
  400c8a:	8082                	ret

0000000000400c8c <open>:
.global open
open:
 li a7, SYS_open
  400c8c:	48bd                	li	a7,15
 ecall
  400c8e:	00000073          	ecall
 ret
  400c92:	8082                	ret

0000000000400c94 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
  400c94:	48c5                	li	a7,17
 ecall
  400c96:	00000073          	ecall
 ret
  400c9a:	8082                	ret

0000000000400c9c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
  400c9c:	48c9                	li	a7,18
 ecall
  400c9e:	00000073          	ecall
 ret
  400ca2:	8082                	ret

0000000000400ca4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
  400ca4:	48a1                	li	a7,8
 ecall
  400ca6:	00000073          	ecall
 ret
  400caa:	8082                	ret

0000000000400cac <link>:
.global link
link:
 li a7, SYS_link
  400cac:	48cd                	li	a7,19
 ecall
  400cae:	00000073          	ecall
 ret
  400cb2:	8082                	ret

0000000000400cb4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
  400cb4:	48d1                	li	a7,20
 ecall
  400cb6:	00000073          	ecall
 ret
  400cba:	8082                	ret

0000000000400cbc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
  400cbc:	48a5                	li	a7,9
 ecall
  400cbe:	00000073          	ecall
 ret
  400cc2:	8082                	ret

0000000000400cc4 <dup>:
.global dup
dup:
 li a7, SYS_dup
  400cc4:	48a9                	li	a7,10
 ecall
  400cc6:	00000073          	ecall
 ret
  400cca:	8082                	ret

0000000000400ccc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
  400ccc:	48ad                	li	a7,11
 ecall
  400cce:	00000073          	ecall
 ret
  400cd2:	8082                	ret

0000000000400cd4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
  400cd4:	48b1                	li	a7,12
 ecall
  400cd6:	00000073          	ecall
 ret
  400cda:	8082                	ret

0000000000400cdc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
  400cdc:	48b5                	li	a7,13
 ecall
  400cde:	00000073          	ecall
 ret
  400ce2:	8082                	ret

0000000000400ce4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
  400ce4:	48b9                	li	a7,14
 ecall
  400ce6:	00000073          	ecall
 ret
  400cea:	8082                	ret

0000000000400cec <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
  400cec:	48d9                	li	a7,22
 ecall
  400cee:	00000073          	ecall
 ret
  400cf2:	8082                	ret

0000000000400cf4 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
  400cf4:	48dd                	li	a7,23
 ecall
  400cf6:	00000073          	ecall
 ret
  400cfa:	8082                	ret

0000000000400cfc <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
  400cfc:	48e1                	li	a7,24
 ecall
  400cfe:	00000073          	ecall
 ret
  400d02:	8082                	ret

0000000000400d04 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
  400d04:	1101                	addi	sp,sp,-32
  400d06:	ec06                	sd	ra,24(sp)
  400d08:	e822                	sd	s0,16(sp)
  400d0a:	1000                	addi	s0,sp,32
  400d0c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
  400d10:	4605                	li	a2,1
  400d12:	fef40593          	addi	a1,s0,-17
  400d16:	f57ff0ef          	jal	400c6c <write>
}
  400d1a:	60e2                	ld	ra,24(sp)
  400d1c:	6442                	ld	s0,16(sp)
  400d1e:	6105                	addi	sp,sp,32
  400d20:	8082                	ret

0000000000400d22 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  400d22:	7139                	addi	sp,sp,-64
  400d24:	fc06                	sd	ra,56(sp)
  400d26:	f822                	sd	s0,48(sp)
  400d28:	f426                	sd	s1,40(sp)
  400d2a:	f04a                	sd	s2,32(sp)
  400d2c:	ec4e                	sd	s3,24(sp)
  400d2e:	0080                	addi	s0,sp,64
  400d30:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  400d32:	c299                	beqz	a3,400d38 <printint+0x16>
  400d34:	0605ce63          	bltz	a1,400db0 <printint+0x8e>
  neg = 0;
  400d38:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  400d3a:	fc040313          	addi	t1,s0,-64
  neg = 0;
  400d3e:	869a                	mv	a3,t1
  i = 0;
  400d40:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
  400d42:	00000817          	auipc	a6,0x0
  400d46:	62680813          	addi	a6,a6,1574 # 401368 <digits>
  400d4a:	88be                	mv	a7,a5
  400d4c:	0017851b          	addiw	a0,a5,1
  400d50:	87aa                	mv	a5,a0
  400d52:	02c5f73b          	remuw	a4,a1,a2
  400d56:	1702                	slli	a4,a4,0x20
  400d58:	9301                	srli	a4,a4,0x20
  400d5a:	9742                	add	a4,a4,a6
  400d5c:	00074703          	lbu	a4,0(a4)
  400d60:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
  400d64:	872e                	mv	a4,a1
  400d66:	02c5d5bb          	divuw	a1,a1,a2
  400d6a:	0685                	addi	a3,a3,1
  400d6c:	fcc77fe3          	bgeu	a4,a2,400d4a <printint+0x28>
  if(neg)
  400d70:	000e0c63          	beqz	t3,400d88 <printint+0x66>
    buf[i++] = '-';
  400d74:	fd050793          	addi	a5,a0,-48
  400d78:	00878533          	add	a0,a5,s0
  400d7c:	02d00793          	li	a5,45
  400d80:	fef50823          	sb	a5,-16(a0)
  400d84:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
  400d88:	fff7899b          	addiw	s3,a5,-1
  400d8c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
  400d90:	fff4c583          	lbu	a1,-1(s1)
  400d94:	854a                	mv	a0,s2
  400d96:	f6fff0ef          	jal	400d04 <putc>
  while(--i >= 0)
  400d9a:	39fd                	addiw	s3,s3,-1
  400d9c:	14fd                	addi	s1,s1,-1
  400d9e:	fe09d9e3          	bgez	s3,400d90 <printint+0x6e>
}
  400da2:	70e2                	ld	ra,56(sp)
  400da4:	7442                	ld	s0,48(sp)
  400da6:	74a2                	ld	s1,40(sp)
  400da8:	7902                	ld	s2,32(sp)
  400daa:	69e2                	ld	s3,24(sp)
  400dac:	6121                	addi	sp,sp,64
  400dae:	8082                	ret
    x = -xx;
  400db0:	40b005bb          	negw	a1,a1
    neg = 1;
  400db4:	4e05                	li	t3,1
    x = -xx;
  400db6:	b751                	j	400d3a <printint+0x18>

0000000000400db8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
  400db8:	711d                	addi	sp,sp,-96
  400dba:	ec86                	sd	ra,88(sp)
  400dbc:	e8a2                	sd	s0,80(sp)
  400dbe:	e4a6                	sd	s1,72(sp)
  400dc0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
  400dc2:	0005c483          	lbu	s1,0(a1)
  400dc6:	26048663          	beqz	s1,401032 <vprintf+0x27a>
  400dca:	e0ca                	sd	s2,64(sp)
  400dcc:	fc4e                	sd	s3,56(sp)
  400dce:	f852                	sd	s4,48(sp)
  400dd0:	f456                	sd	s5,40(sp)
  400dd2:	f05a                	sd	s6,32(sp)
  400dd4:	ec5e                	sd	s7,24(sp)
  400dd6:	e862                	sd	s8,16(sp)
  400dd8:	e466                	sd	s9,8(sp)
  400dda:	8b2a                	mv	s6,a0
  400ddc:	8a2e                	mv	s4,a1
  400dde:	8bb2                	mv	s7,a2
  state = 0;
  400de0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
  400de2:	4901                	li	s2,0
  400de4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
  400de6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
  400dea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
  400dee:	06c00c93          	li	s9,108
  400df2:	a00d                	j	400e14 <vprintf+0x5c>
        putc(fd, c0);
  400df4:	85a6                	mv	a1,s1
  400df6:	855a                	mv	a0,s6
  400df8:	f0dff0ef          	jal	400d04 <putc>
  400dfc:	a019                	j	400e02 <vprintf+0x4a>
    } else if(state == '%'){
  400dfe:	03598363          	beq	s3,s5,400e24 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
  400e02:	0019079b          	addiw	a5,s2,1
  400e06:	893e                	mv	s2,a5
  400e08:	873e                	mv	a4,a5
  400e0a:	97d2                	add	a5,a5,s4
  400e0c:	0007c483          	lbu	s1,0(a5)
  400e10:	20048963          	beqz	s1,401022 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
  400e14:	0004879b          	sext.w	a5,s1
    if(state == 0){
  400e18:	fe0993e3          	bnez	s3,400dfe <vprintf+0x46>
      if(c0 == '%'){
  400e1c:	fd579ce3          	bne	a5,s5,400df4 <vprintf+0x3c>
        state = '%';
  400e20:	89be                	mv	s3,a5
  400e22:	b7c5                	j	400e02 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
  400e24:	00ea06b3          	add	a3,s4,a4
  400e28:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
  400e2c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
  400e2e:	c681                	beqz	a3,400e36 <vprintf+0x7e>
  400e30:	9752                	add	a4,a4,s4
  400e32:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
  400e36:	03878e63          	beq	a5,s8,400e72 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
  400e3a:	05978863          	beq	a5,s9,400e8a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
  400e3e:	07500713          	li	a4,117
  400e42:	0ee78263          	beq	a5,a4,400f26 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
  400e46:	07800713          	li	a4,120
  400e4a:	12e78463          	beq	a5,a4,400f72 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
  400e4e:	07000713          	li	a4,112
  400e52:	14e78963          	beq	a5,a4,400fa4 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
  400e56:	07300713          	li	a4,115
  400e5a:	18e78863          	beq	a5,a4,400fea <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
  400e5e:	02500713          	li	a4,37
  400e62:	04e79463          	bne	a5,a4,400eaa <vprintf+0xf2>
        putc(fd, '%');
  400e66:	85ba                	mv	a1,a4
  400e68:	855a                	mv	a0,s6
  400e6a:	e9bff0ef          	jal	400d04 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
  400e6e:	4981                	li	s3,0
  400e70:	bf49                	j	400e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
  400e72:	008b8493          	addi	s1,s7,8
  400e76:	4685                	li	a3,1
  400e78:	4629                	li	a2,10
  400e7a:	000ba583          	lw	a1,0(s7)
  400e7e:	855a                	mv	a0,s6
  400e80:	ea3ff0ef          	jal	400d22 <printint>
  400e84:	8ba6                	mv	s7,s1
      state = 0;
  400e86:	4981                	li	s3,0
  400e88:	bfad                	j	400e02 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
  400e8a:	06400793          	li	a5,100
  400e8e:	02f68963          	beq	a3,a5,400ec0 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400e92:	06c00793          	li	a5,108
  400e96:	04f68263          	beq	a3,a5,400eda <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
  400e9a:	07500793          	li	a5,117
  400e9e:	0af68063          	beq	a3,a5,400f3e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
  400ea2:	07800793          	li	a5,120
  400ea6:	0ef68263          	beq	a3,a5,400f8a <vprintf+0x1d2>
        putc(fd, '%');
  400eaa:	02500593          	li	a1,37
  400eae:	855a                	mv	a0,s6
  400eb0:	e55ff0ef          	jal	400d04 <putc>
        putc(fd, c0);
  400eb4:	85a6                	mv	a1,s1
  400eb6:	855a                	mv	a0,s6
  400eb8:	e4dff0ef          	jal	400d04 <putc>
      state = 0;
  400ebc:	4981                	li	s3,0
  400ebe:	b791                	j	400e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400ec0:	008b8493          	addi	s1,s7,8
  400ec4:	4685                	li	a3,1
  400ec6:	4629                	li	a2,10
  400ec8:	000ba583          	lw	a1,0(s7)
  400ecc:	855a                	mv	a0,s6
  400ece:	e55ff0ef          	jal	400d22 <printint>
        i += 1;
  400ed2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
  400ed4:	8ba6                	mv	s7,s1
      state = 0;
  400ed6:	4981                	li	s3,0
        i += 1;
  400ed8:	b72d                	j	400e02 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
  400eda:	06400793          	li	a5,100
  400ede:	02f60763          	beq	a2,a5,400f0c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
  400ee2:	07500793          	li	a5,117
  400ee6:	06f60963          	beq	a2,a5,400f58 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
  400eea:	07800793          	li	a5,120
  400eee:	faf61ee3          	bne	a2,a5,400eaa <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400ef2:	008b8493          	addi	s1,s7,8
  400ef6:	4681                	li	a3,0
  400ef8:	4641                	li	a2,16
  400efa:	000ba583          	lw	a1,0(s7)
  400efe:	855a                	mv	a0,s6
  400f00:	e23ff0ef          	jal	400d22 <printint>
        i += 2;
  400f04:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
  400f06:	8ba6                	mv	s7,s1
      state = 0;
  400f08:	4981                	li	s3,0
        i += 2;
  400f0a:	bde5                	j	400e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
  400f0c:	008b8493          	addi	s1,s7,8
  400f10:	4685                	li	a3,1
  400f12:	4629                	li	a2,10
  400f14:	000ba583          	lw	a1,0(s7)
  400f18:	855a                	mv	a0,s6
  400f1a:	e09ff0ef          	jal	400d22 <printint>
        i += 2;
  400f1e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
  400f20:	8ba6                	mv	s7,s1
      state = 0;
  400f22:	4981                	li	s3,0
        i += 2;
  400f24:	bdf9                	j	400e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
  400f26:	008b8493          	addi	s1,s7,8
  400f2a:	4681                	li	a3,0
  400f2c:	4629                	li	a2,10
  400f2e:	000ba583          	lw	a1,0(s7)
  400f32:	855a                	mv	a0,s6
  400f34:	defff0ef          	jal	400d22 <printint>
  400f38:	8ba6                	mv	s7,s1
      state = 0;
  400f3a:	4981                	li	s3,0
  400f3c:	b5d9                	j	400e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400f3e:	008b8493          	addi	s1,s7,8
  400f42:	4681                	li	a3,0
  400f44:	4629                	li	a2,10
  400f46:	000ba583          	lw	a1,0(s7)
  400f4a:	855a                	mv	a0,s6
  400f4c:	dd7ff0ef          	jal	400d22 <printint>
        i += 1;
  400f50:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
  400f52:	8ba6                	mv	s7,s1
      state = 0;
  400f54:	4981                	li	s3,0
        i += 1;
  400f56:	b575                	j	400e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
  400f58:	008b8493          	addi	s1,s7,8
  400f5c:	4681                	li	a3,0
  400f5e:	4629                	li	a2,10
  400f60:	000ba583          	lw	a1,0(s7)
  400f64:	855a                	mv	a0,s6
  400f66:	dbdff0ef          	jal	400d22 <printint>
        i += 2;
  400f6a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
  400f6c:	8ba6                	mv	s7,s1
      state = 0;
  400f6e:	4981                	li	s3,0
        i += 2;
  400f70:	bd49                	j	400e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
  400f72:	008b8493          	addi	s1,s7,8
  400f76:	4681                	li	a3,0
  400f78:	4641                	li	a2,16
  400f7a:	000ba583          	lw	a1,0(s7)
  400f7e:	855a                	mv	a0,s6
  400f80:	da3ff0ef          	jal	400d22 <printint>
  400f84:	8ba6                	mv	s7,s1
      state = 0;
  400f86:	4981                	li	s3,0
  400f88:	bdad                	j	400e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
  400f8a:	008b8493          	addi	s1,s7,8
  400f8e:	4681                	li	a3,0
  400f90:	4641                	li	a2,16
  400f92:	000ba583          	lw	a1,0(s7)
  400f96:	855a                	mv	a0,s6
  400f98:	d8bff0ef          	jal	400d22 <printint>
        i += 1;
  400f9c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
  400f9e:	8ba6                	mv	s7,s1
      state = 0;
  400fa0:	4981                	li	s3,0
        i += 1;
  400fa2:	b585                	j	400e02 <vprintf+0x4a>
  400fa4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
  400fa6:	008b8d13          	addi	s10,s7,8
  400faa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
  400fae:	03000593          	li	a1,48
  400fb2:	855a                	mv	a0,s6
  400fb4:	d51ff0ef          	jal	400d04 <putc>
  putc(fd, 'x');
  400fb8:	07800593          	li	a1,120
  400fbc:	855a                	mv	a0,s6
  400fbe:	d47ff0ef          	jal	400d04 <putc>
  400fc2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
  400fc4:	00000b97          	auipc	s7,0x0
  400fc8:	3a4b8b93          	addi	s7,s7,932 # 401368 <digits>
  400fcc:	03c9d793          	srli	a5,s3,0x3c
  400fd0:	97de                	add	a5,a5,s7
  400fd2:	0007c583          	lbu	a1,0(a5)
  400fd6:	855a                	mv	a0,s6
  400fd8:	d2dff0ef          	jal	400d04 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
  400fdc:	0992                	slli	s3,s3,0x4
  400fde:	34fd                	addiw	s1,s1,-1
  400fe0:	f4f5                	bnez	s1,400fcc <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
  400fe2:	8bea                	mv	s7,s10
      state = 0;
  400fe4:	4981                	li	s3,0
  400fe6:	6d02                	ld	s10,0(sp)
  400fe8:	bd29                	j	400e02 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
  400fea:	008b8993          	addi	s3,s7,8
  400fee:	000bb483          	ld	s1,0(s7)
  400ff2:	cc91                	beqz	s1,40100e <vprintf+0x256>
        for(; *s; s++)
  400ff4:	0004c583          	lbu	a1,0(s1)
  400ff8:	c195                	beqz	a1,40101c <vprintf+0x264>
          putc(fd, *s);
  400ffa:	855a                	mv	a0,s6
  400ffc:	d09ff0ef          	jal	400d04 <putc>
        for(; *s; s++)
  401000:	0485                	addi	s1,s1,1
  401002:	0004c583          	lbu	a1,0(s1)
  401006:	f9f5                	bnez	a1,400ffa <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  401008:	8bce                	mv	s7,s3
      state = 0;
  40100a:	4981                	li	s3,0
  40100c:	bbdd                	j	400e02 <vprintf+0x4a>
          s = "(null)";
  40100e:	00000497          	auipc	s1,0x0
  401012:	32248493          	addi	s1,s1,802 # 401330 <malloc+0x20e>
        for(; *s; s++)
  401016:	02800593          	li	a1,40
  40101a:	b7c5                	j	400ffa <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
  40101c:	8bce                	mv	s7,s3
      state = 0;
  40101e:	4981                	li	s3,0
  401020:	b3cd                	j	400e02 <vprintf+0x4a>
  401022:	6906                	ld	s2,64(sp)
  401024:	79e2                	ld	s3,56(sp)
  401026:	7a42                	ld	s4,48(sp)
  401028:	7aa2                	ld	s5,40(sp)
  40102a:	7b02                	ld	s6,32(sp)
  40102c:	6be2                	ld	s7,24(sp)
  40102e:	6c42                	ld	s8,16(sp)
  401030:	6ca2                	ld	s9,8(sp)
    }
  }
}
  401032:	60e6                	ld	ra,88(sp)
  401034:	6446                	ld	s0,80(sp)
  401036:	64a6                	ld	s1,72(sp)
  401038:	6125                	addi	sp,sp,96
  40103a:	8082                	ret

000000000040103c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  40103c:	715d                	addi	sp,sp,-80
  40103e:	ec06                	sd	ra,24(sp)
  401040:	e822                	sd	s0,16(sp)
  401042:	1000                	addi	s0,sp,32
  401044:	e010                	sd	a2,0(s0)
  401046:	e414                	sd	a3,8(s0)
  401048:	e818                	sd	a4,16(s0)
  40104a:	ec1c                	sd	a5,24(s0)
  40104c:	03043023          	sd	a6,32(s0)
  401050:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
  401054:	8622                	mv	a2,s0
  401056:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
  40105a:	d5fff0ef          	jal	400db8 <vprintf>
  return 0;
}
  40105e:	4501                	li	a0,0
  401060:	60e2                	ld	ra,24(sp)
  401062:	6442                	ld	s0,16(sp)
  401064:	6161                	addi	sp,sp,80
  401066:	8082                	ret

0000000000401068 <printf>:

int
printf(const char *fmt, ...)
{
  401068:	711d                	addi	sp,sp,-96
  40106a:	ec06                	sd	ra,24(sp)
  40106c:	e822                	sd	s0,16(sp)
  40106e:	1000                	addi	s0,sp,32
  401070:	e40c                	sd	a1,8(s0)
  401072:	e810                	sd	a2,16(s0)
  401074:	ec14                	sd	a3,24(s0)
  401076:	f018                	sd	a4,32(s0)
  401078:	f41c                	sd	a5,40(s0)
  40107a:	03043823          	sd	a6,48(s0)
  40107e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
  401082:	00840613          	addi	a2,s0,8
  401086:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
  40108a:	85aa                	mv	a1,a0
  40108c:	4505                	li	a0,1
  40108e:	d2bff0ef          	jal	400db8 <vprintf>
  return 0;
}
  401092:	4501                	li	a0,0
  401094:	60e2                	ld	ra,24(sp)
  401096:	6442                	ld	s0,16(sp)
  401098:	6125                	addi	sp,sp,96
  40109a:	8082                	ret

000000000040109c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
  40109c:	1141                	addi	sp,sp,-16
  40109e:	e406                	sd	ra,8(sp)
  4010a0:	e022                	sd	s0,0(sp)
  4010a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
  4010a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4010a8:	00001797          	auipc	a5,0x1
  4010ac:	f687b783          	ld	a5,-152(a5) # 402010 <freep>
  4010b0:	a02d                	j	4010da <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
  4010b2:	4618                	lw	a4,8(a2)
  4010b4:	9f2d                	addw	a4,a4,a1
  4010b6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
  4010ba:	6398                	ld	a4,0(a5)
  4010bc:	6310                	ld	a2,0(a4)
  4010be:	a83d                	j	4010fc <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
  4010c0:	ff852703          	lw	a4,-8(a0)
  4010c4:	9f31                	addw	a4,a4,a2
  4010c6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
  4010c8:	ff053683          	ld	a3,-16(a0)
  4010cc:	a091                	j	401110 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4010ce:	6398                	ld	a4,0(a5)
  4010d0:	00e7e463          	bltu	a5,a4,4010d8 <free+0x3c>
  4010d4:	00e6ea63          	bltu	a3,a4,4010e8 <free+0x4c>
{
  4010d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
  4010da:	fed7fae3          	bgeu	a5,a3,4010ce <free+0x32>
  4010de:	6398                	ld	a4,0(a5)
  4010e0:	00e6e463          	bltu	a3,a4,4010e8 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
  4010e4:	fee7eae3          	bltu	a5,a4,4010d8 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
  4010e8:	ff852583          	lw	a1,-8(a0)
  4010ec:	6390                	ld	a2,0(a5)
  4010ee:	02059813          	slli	a6,a1,0x20
  4010f2:	01c85713          	srli	a4,a6,0x1c
  4010f6:	9736                	add	a4,a4,a3
  4010f8:	fae60de3          	beq	a2,a4,4010b2 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
  4010fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
  401100:	4790                	lw	a2,8(a5)
  401102:	02061593          	slli	a1,a2,0x20
  401106:	01c5d713          	srli	a4,a1,0x1c
  40110a:	973e                	add	a4,a4,a5
  40110c:	fae68ae3          	beq	a3,a4,4010c0 <free+0x24>
    p->s.ptr = bp->s.ptr;
  401110:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
  401112:	00001717          	auipc	a4,0x1
  401116:	eef73f23          	sd	a5,-258(a4) # 402010 <freep>
}
  40111a:	60a2                	ld	ra,8(sp)
  40111c:	6402                	ld	s0,0(sp)
  40111e:	0141                	addi	sp,sp,16
  401120:	8082                	ret

0000000000401122 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
  401122:	7139                	addi	sp,sp,-64
  401124:	fc06                	sd	ra,56(sp)
  401126:	f822                	sd	s0,48(sp)
  401128:	f04a                	sd	s2,32(sp)
  40112a:	ec4e                	sd	s3,24(sp)
  40112c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  40112e:	02051993          	slli	s3,a0,0x20
  401132:	0209d993          	srli	s3,s3,0x20
  401136:	09bd                	addi	s3,s3,15
  401138:	0049d993          	srli	s3,s3,0x4
  40113c:	2985                	addiw	s3,s3,1
  40113e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
  401140:	00001517          	auipc	a0,0x1
  401144:	ed053503          	ld	a0,-304(a0) # 402010 <freep>
  401148:	c905                	beqz	a0,401178 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  40114a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  40114c:	4798                	lw	a4,8(a5)
  40114e:	09377663          	bgeu	a4,s3,4011da <malloc+0xb8>
  401152:	f426                	sd	s1,40(sp)
  401154:	e852                	sd	s4,16(sp)
  401156:	e456                	sd	s5,8(sp)
  401158:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
  40115a:	8a4e                	mv	s4,s3
  40115c:	6705                	lui	a4,0x1
  40115e:	00e9f363          	bgeu	s3,a4,401164 <malloc+0x42>
  401162:	6a05                	lui	s4,0x1
  401164:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
  401168:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
  40116c:	00001497          	auipc	s1,0x1
  401170:	ea448493          	addi	s1,s1,-348 # 402010 <freep>
  if(p == (char*)-1)
  401174:	5afd                	li	s5,-1
  401176:	a83d                	j	4011b4 <malloc+0x92>
  401178:	f426                	sd	s1,40(sp)
  40117a:	e852                	sd	s4,16(sp)
  40117c:	e456                	sd	s5,8(sp)
  40117e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
  401180:	00001797          	auipc	a5,0x1
  401184:	f0878793          	addi	a5,a5,-248 # 402088 <base>
  401188:	00001717          	auipc	a4,0x1
  40118c:	e8f73423          	sd	a5,-376(a4) # 402010 <freep>
  401190:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
  401192:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
  401196:	b7d1                	j	40115a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
  401198:	6398                	ld	a4,0(a5)
  40119a:	e118                	sd	a4,0(a0)
  40119c:	a899                	j	4011f2 <malloc+0xd0>
  hp->s.size = nu;
  40119e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
  4011a2:	0541                	addi	a0,a0,16
  4011a4:	ef9ff0ef          	jal	40109c <free>
  return freep;
  4011a8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
  4011aa:	c125                	beqz	a0,40120a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
  4011ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
  4011ae:	4798                	lw	a4,8(a5)
  4011b0:	03277163          	bgeu	a4,s2,4011d2 <malloc+0xb0>
    if(p == freep)
  4011b4:	6098                	ld	a4,0(s1)
  4011b6:	853e                	mv	a0,a5
  4011b8:	fef71ae3          	bne	a4,a5,4011ac <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
  4011bc:	8552                	mv	a0,s4
  4011be:	b17ff0ef          	jal	400cd4 <sbrk>
  if(p == (char*)-1)
  4011c2:	fd551ee3          	bne	a0,s5,40119e <malloc+0x7c>
        return 0;
  4011c6:	4501                	li	a0,0
  4011c8:	74a2                	ld	s1,40(sp)
  4011ca:	6a42                	ld	s4,16(sp)
  4011cc:	6aa2                	ld	s5,8(sp)
  4011ce:	6b02                	ld	s6,0(sp)
  4011d0:	a03d                	j	4011fe <malloc+0xdc>
  4011d2:	74a2                	ld	s1,40(sp)
  4011d4:	6a42                	ld	s4,16(sp)
  4011d6:	6aa2                	ld	s5,8(sp)
  4011d8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
  4011da:	fae90fe3          	beq	s2,a4,401198 <malloc+0x76>
        p->s.size -= nunits;
  4011de:	4137073b          	subw	a4,a4,s3
  4011e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
  4011e4:	02071693          	slli	a3,a4,0x20
  4011e8:	01c6d713          	srli	a4,a3,0x1c
  4011ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
  4011ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
  4011f2:	00001717          	auipc	a4,0x1
  4011f6:	e0a73f23          	sd	a0,-482(a4) # 402010 <freep>
      return (void*)(p + 1);
  4011fa:	01078513          	addi	a0,a5,16
  }
}
  4011fe:	70e2                	ld	ra,56(sp)
  401200:	7442                	ld	s0,48(sp)
  401202:	7902                	ld	s2,32(sp)
  401204:	69e2                	ld	s3,24(sp)
  401206:	6121                	addi	sp,sp,64
  401208:	8082                	ret
  40120a:	74a2                	ld	s1,40(sp)
  40120c:	6a42                	ld	s4,16(sp)
  40120e:	6aa2                	ld	s5,8(sp)
  401210:	6b02                	ld	s6,0(sp)
  401212:	b7f5                	j	4011fe <malloc+0xdc>
