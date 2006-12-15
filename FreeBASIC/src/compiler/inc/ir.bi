#ifndef __IR_BI__
#define __IR_BI__

''	FreeBASIC - 32-bit BASIC Compiler.
''	Copyright (C) 2004-2007 The FreeBASIC development team.
''
''	This program is free software; you can redistribute it and/or modify
''	it under the terms of the GNU General Public License as published by
''	the Free Software Foundation; either version 2 of the License, or
''	(at your option) any later version.
''
''	This program is distributed in the hope that it will be useful,
''	but WITHOUT ANY WARRANTY; without even the implied warranty of
''	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
''	GNU General Public License for more details.
''
''	You should have received a copy of the GNU General Public License
''	along with this program; if not, write to the Free Software
''	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA.


const IR_INITVREGNODES		= 1024

const IR_INITADDRNODES		= 2048

const IR_MAXDIST			= 2147483647

''
enum IRVREGTYPE_ENUM
	IR_VREGTYPE_OPER							'' used by DAG only
	IR_VREGTYPE_IMM
	IR_VREGTYPE_VAR
	IR_VREGTYPE_IDX
	IR_VREGTYPE_PTR
	IR_VREGTYPE_REG
	IR_VREGTYPE_OFS
end enum

'' sections
enum IR_SECTION
	IR_SECTION_CONST
	IR_SECTION_DATA
	IR_SECTION_BSS
	IR_SECTION_CODE
	IR_SECTION_DIRECTIVE
    IR_SECTION_CONSTRUCTOR
    IR_SECTION_DESTRUCTOR
end enum

''
type IRVREG_ as IRVREG
type IRTAC_ as IRTAC

type IRTACVREG
	vreg		as IRVREG_ ptr
	pParent		as IRVREG_ ptr ptr              '' pointer to parent if idx or aux
	next		as IRTACVREG ptr				'' next in tac (-> vr, v1 or v2)
end type

type IRTACVREG_GRP
	reg			as IRTACVREG
	idx			as IRTACVREG					'' index
	aux			as IRTACVREG                    '' auxiliary
end type

type IRTAC
	pos			as integer

	op			as AST_OP						'' opcode

	vr			as IRTACVREG_GRP                '' result
	v1			as IRTACVREG_GRP                '' operand 1
	v2			as IRTACVREG_GRP				'' operand 2

	ex1			as FBSYMBOL ptr					'' extra field, used by call/jmp
	ex2			as integer						'' /
end type

type IRVREG
	typ			as IRVREGTYPE_ENUM				'' VAR, IMM, IDX, etc
	dtype		as FB_DATATYPE					'' CHAR, INTEGER, ...

	reg			as integer						'' reg
	value		as integer						'' imm value (hi-word of longint's at vaux->value)

	sym			as FBSYMBOL ptr					'' symbol
	ofs			as integer						'' +offset
	mult		as integer						'' multipler

	vidx		as IRVREG ptr					'' index vreg
	vaux		as IRVREG ptr					'' aux vreg (used with longint's)

	tacvhead	as IRTACVREG ptr				'' back-link to tac table
	tacvtail	as IRTACVREG ptr				'' /
	taclast		as IRTAC ptr					'' /
end type

type IR_VTBL
	init as function _
	( _
		byval backend as FB_BACKEND _
	) as integer

	end as sub _
	( _
	)

	flush as sub _
	( _
	)

	emitBegin as function _
	( _
	) as integer

	emitEnd as sub _
	( _
		byval tottime as double _
	)

	procBegin as sub _
	( _
		byval proc as FBSYMBOL ptr _
	)

	procEnd as sub _
	( _
		byval proc as FBSYMBOL ptr _
	)

	procAllocArg as function _
	( _
		byval proc as FBSYMBOL ptr, _
		byval lgt as integer _
	) as integer

	procAllocLocal as function _
	( _
		byval proc as FBSYMBOL ptr, _
		byval lgt as integer _
	) as integer

	procGetFrameRegName as function _
	( _
	) as zstring ptr

	scopeBegin as sub _
	( _
		byval s as FBSYMBOL ptr _
	)

	scopeEnd as sub _
	( _
		byval s as FBSYMBOL ptr _
	)

	procAllocStaticVars as function _
	( _
		byval head_sym as FBSYMBOL ptr _
	) as integer

	emit as sub _
	( _
		byval op as integer, _
		byval v1 as IRVREG ptr, _
		byval v2 as IRVREG ptr, _
		byval vr as IRVREG ptr, _
		byval ex1 as FBSYMBOL ptr = NULL, _
		byval ex2 as integer = 0 _
	)

	emitConvert as sub _
	( _
		byval v1 as IRVREG ptr, _
		byval dtype1 as integer, _
		byval v2 as IRVREG ptr, _
		byval dtype2 as integer _
	)

	emitLabel as sub _
	( _
		byval label as FBSYMBOL ptr _
	)

	emitLabelNF as sub _
	( _
		byval l as FBSYMBOL ptr _
	)

	emitReturn as sub _
	( _
		byval bytestopop as integer _
	)

	emitProcBegin as sub _
	( _
		byval proc as FBSYMBOL ptr, _
		byval initlabel as FBSYMBOL ptr _
	)

	emitProcEnd as sub _
	( _
		byval proc as FBSYMBOL ptr, _
		byval initlabel as FBSYMBOL ptr, _
		byval exitlabel as FBSYMBOL ptr _
	)

	emitPushArg as sub _
	( _
		byval vr as IRVREG ptr, _
		byval plen as integer _
	)

	emitASM as sub _
	( _
		byval text as zstring ptr _
	)

	emitComment as sub _
	( _
		byval text as zstring ptr _
	)

	emitJmpTb as sub _
	( _
		byval dtype as integer, _
		byval label as FBSYMBOL ptr _
	)

	emitBop as sub _
	( _
		byval op as integer, _
		byval v1 as IRVREG ptr, _
		byval v2 as IRVREG ptr, _
		byval vr as IRVREG ptr _
	)

	emitBopEx as sub _
	( _
		byval op as integer, _
		byval v1 as IRVREG ptr, _
		byval v2 as IRVREG ptr, _
		byval vr as IRVREG ptr, _
		byval ex as FBSYMBOL ptr _
	)

	emitUop as sub _
	( _
		byval op as integer, _
		byval v1 as IRVREG ptr, _
		byval vr as IRVREG ptr _
	)

	emitStore as sub _
	( _
		byval v1 as IRVREG ptr, _
		byval v2 as IRVREG ptr _
	)

	emitSpillRegs as sub _
	( _
	)

	emitLoad as sub _
	( _
		byval v1 as IRVREG ptr _
	)

	emitLoadRes as sub _
	( _
		byval v1 as IRVREG ptr, _
		byval vr as IRVREG ptr _
	)

	emitStack as sub _
	( _
		byval op as integer, _
		byval v1 as IRVREG ptr _
	)

	emitPushUDT as sub _
	( _
		byval v1 as IRVREG ptr, _
		byval lgt as integer _
	)

	emitAddr as sub _
	( _
		byval op as integer, _
		byval v1 as IRVREG ptr, _
		byval vr as IRVREG ptr _
	)

	emitCall as sub _
	( _
		byval proc as FBSYMBOL ptr, _
		byval bytestopop as integer, _
		byval vr as IRVREG ptr _
	)

	emitCallPtr as sub _
	( _
		byval v1 as IRVREG ptr, _
		byval vr as IRVREG ptr, _
		byval bytestopop as integer _
	)

	emitStackAlign as sub _
	( _
		byval bytes as integer _
	)

	emitJumpPtr as sub _
	( _
		byval v1 as IRVREG ptr _
	)

	emitBranch as sub _
	( _
		byval op as integer, _
		byval label as FBSYMBOL ptr _
	)

	emitMem as sub _
	( _
		byval op as integer, _
		byval v1 as IRVREG ptr, _
		byval v2 as IRVREG ptr, _
		byval bytes as integer _
	)

	emitScopeBegin as sub _
	( _
		byval s as FBSYMBOL ptr _
	)

	emitScopeEnd as sub _
	( _
		byval s as FBSYMBOL ptr _
	)

	emitDBG as sub _
	( _
		byval op as integer, _
		byval proc as FBSYMBOL ptr, _
		byval ex as integer _
	)

	emitVarIniBegin as sub _
	( _
		byval sym as FBSYMBOL ptr _
	)

	emitVarIniEnd as sub _
	( _
		byval sym as FBSYMBOL ptr _
	)

	emitVarIniI as sub _
	( _
		byval dtype as integer, _
		byval value as integer _
	)

	emitVarIniF as sub _
	( _
		byval dtype as integer, _
		byval value as double _
	)

	emitVarIniI64 as sub _
	( _
		byval dtype as integer, _
		byval value as longint _
	)

	emitVarIniOfs as sub _
	( _
		byval sym as FBSYMBOL ptr, _
		byval ofs as integer _
	)

	emitVarIniStr as sub _
	( _
		byval totlgt as integer, _
		byval litstr as zstring ptr, _
		byval litlgt as integer _
	)

	emitVarIniWstr as sub _
	( _
		byval totlgt as integer, _
		byval litstr as wstring ptr, _
		byval litlgt as integer _
	)

	emitVarIniPad as sub _
	( _
		byval bytes as integer _
	)

	allocVreg as function _
	( _
		byval dtype as integer _
	) as IRVREG ptr

	allocVrImm as function _
	( _
		byval dtype as integer, _
		byval value as integer _
	) as IRVREG ptr

	allocVrImm64 as function _
	( _
		byval dtype as integer, _
		byval value as longint _
	) as IRVREG ptr

	allocVrVar as function _
	( _
		byval dtype as integer, _
		byval symbol as FBSYMBOL ptr, _
		byval ofs as integer _
	) as IRVREG ptr

	allocVrIdx as function _
	( _
		byval dtype as integer, _
		byval symbol as FBSYMBOL ptr, _
		byval ofs as integer, _
		byval mult as integer, _
		byval vidx as IRVREG ptr _
	) as IRVREG ptr

	allocVrPtr as function _
	( _
		byval dtype as integer, _
		byval ofs as integer, _
		byval vidx as IRVREG ptr _
	) as IRVREG ptr

	allocVrOfs as function _
	( _
		byval dtype as integer, _
		byval symbol as FBSYMBOL ptr, _
		byval ofs as integer _
	) as IRVREG ptr

	getDistance as function _
	( _
		byval vreg as IRVREG ptr _
	) as uinteger

	loadVr as sub _
	( _
		byval reg as integer, _
		byval vreg as IRVREG ptr, _
		byval doload as integer _
	)

	storeVr as sub _
	( _
		byval vreg as IRVREG ptr, _
		byval reg as integer _
	)

	xchgTOS as sub _
	( _
		byval reg as integer _
	)
end type

type IRCTX
	inited			as integer

	vtbl			as IR_VTBL
end type

''
''
''
declare function irInit _
	( _
		byval backend as FB_BACKEND _
	) as integer

declare sub irEnd _
	( _
	)

declare function irGetVRDataClass _
	( _
		byval vreg as IRVREG ptr _
	) as integer

declare function irGetVRDataSize _
	( _
		byval vreg as IRVREG ptr _
	) as integer

''
'' macros
''
#define irAllocVREG(dtype) ir.vtbl.allocVreg( dtype )

#define irAllocVRIMM(dtype, value) ir.vtbl.allocVrImm( dtype, value )

#define irAllocVRIMM64(dtype, value) ir.vtbl.allocVrImm64( dtype, value )

#define irAllocVRVAR(dtype, sym, ofs) ir.vtbl.allocVrVar( dtype, sym, ofs )

#define irAllocVRIDX(dtype, sym, ofs, mult, vidx) ir.vtbl.allocVrIdx( dtype, sym, ofs, mult, vidx )

#define irAllocVRPTR(dtype, ofs, vidx) ir.vtbl.allocVrPtr( dtype, ofs, vidx )

#define irAllocVROFS(dtype, sym, ofs) ir.vtbl.allocVrOfs( dtype, sym, ofs )

#define irProcBegin(proc) ir.vtbl.procBegin( proc )

#define irProcEnd(proc) ir.vtbl.procEnd( proc )

#define irScopeBegin(s) ir.vtbl.scopeBegin( s )

#define irScopeEnd(s) ir.vtbl.scopeEnd( s )

#define irProcAllocArg(proc,lgt) ir.vtbl.procAllocArg( proc, lgt )

#define irProcAllocLocal(proc, lgt) ir.vtbl.procAllocLocal( proc, lgt )

#define irProcAllocStaticVars(head_sym) ir.vtbl.procAllocStaticVars( head_sym )

#define irProcGetFrameRegName() ir.vtbl.procGetFrameRegName( )

#define irEmitBegin() ir.vtbl.emitBegin( )

#define irEmitEnd(tottime) ir.vtbl.emitEnd( tottime )

#define irEmit(op, v1, v2, vr, ex1, ex2) ir.vtbl.emit( op, v1, v2, vr, ex1, ex2 )

#define irEmitPROCBEGIN(proc, initlabel) ir.vtbl.emitProcBegin( proc, initlabel )

#define irEmitPROCEND(proc, initlabel, exitlabel) ir.vtbl.emitProcEnd( proc, initlabel, exitlabel )

#define irEmitVARINIBEGIN(sym) ir.vtbl.emitVarIniBegin( sym )

#define irEmitVARINIEND(sym) ir.vtbl.emitVarIniEnd( sym )

#define irEmitVARINIi(dtype, value) ir.vtbl.emitVarIniI( dtype, value )

#define irEmitVARINIf(dtype, value) ir.vtbl.emitVarIniF( dtype, value )

#define irEmitVARINI64(dtype, value) ir.vtbl.emitVarIniI64( dtype, value )

#define irEmitVARINIOFS(sym, ofs) ir.vtbl.emitVarIniOfs( sym, ofs )

#define irEmitVARINISTR(totlgt, litstr, litlgt) ir.vtbl.emitVarIniStr( totlgt, litstr, litlgt )

#define irEmitVARINIWSTR(totlgt, litstr, litlgt) ir.vtbl.emitVarIniWstr( totlgt, litstr, litlgt )

#define irEmitVARINIPAD(bytes) ir.vtbl.emitVarIniPad( bytes )

#define irEmitCONVERT(v1, dtype1, v2, dtype2) ir.vtbl.emitConvert( v1, dtype1, v2, dtype2 )

#define irEmitLABEL(label) ir.vtbl.emitLabel( label )

#define irEmitRETURN(bytestopop) ir.vtbl.emitReturn( bytestopop )

#define irEmitPUSHARG(vr, plen) ir.vtbl.emitPushArg( vr, plen )

#define irEmitASM(text) ir.vtbl.emitASM( text )

#define irEmitCOMMENT(text) ir.vtbl.emitComment( text )

#define irEmitJMPTB(dtype, label) ir.vtbl.emitJmpTb( dtype, label )

#define irFlush() ir.vtbl.flush( )

#define irGetDistance(vreg) ir.vtbl.getDistance( vreg )

#define irLoadVR(reg, vreg, doload) ir.vtbl.loadVR( reg, vreg, doload )

#define irStoreVR(vreg, reg) ir.vtbl.storeVR( vreg, reg )

#define irXchgTOS(reg) ir.vtbl.xchgTOS( reg )

#define irEmitBOP(op, v1, v2, vr) ir.vtbl.emitBop( op, v1, v2, vr )

#define irEmitBOPEx(op, v1, v2, vr, ex) ir.vtbl.emitBopEx( op, v1, v2, vr, ex )

#define irEmitUOP(op, v1, vr) ir.vtbl.emitUop( op, v1, vr )

#define irEmitSTORE(v1, v2) ir.vtbl.emitStore( v1, v2 )

#define irEmitSPILLREGS() ir.vtbl.emitSpillRegs( )

#define irEmitLOAD(v1) ir.vtbl.emitLoad( v1 )

#define irEmitLOADRES(v1, vr) ir.vtbl.emitLoadRes( v1, vr )

#define irEmitSTACK(op, v1) ir.vtbl.emitStack( op, v1 )

#define irEmitPUSH(v1) ir.vtbl.emitStack( AST_OP_PUSH, v1 )

#define irEmitPOP(v1) ir.vtbl.emitStack( AST_OP_POP, v1 )

#define irEmitPUSHUDT(v1, lgt) ir.vtbl.emitPushUDT( v1, lgt )

#define irEmitADDR(op, v1, vr) ir.vtbl.emitAddr( op, v1, vr )

#define irEmitLABELNF(s) ir.vtbl.emitLabelNF( s )

#define irEmitCALLFUNCT(proc, bytestopop, vr) ir.vtbl.emitCall( proc, bytestopop, vr )

#define irEmitCALLPTR(v1, vr, bytestopop) ir.vtbl.emitCallPtr( v1, vr, bytestopop )

#define irEmitSTACKALIGN(bytes) ir.vtbl.emitStackAlign( bytes )

#define irEmitJUMPPTR(v1) ir.vtbl.emitJumpPtr( v1 )

#define irEmitBRANCH(op, label) ir.vtbl.emitBranch( op, label )

#define irEmitMEM(op, v1, v2, bytes) ir.vtbl.emitMem( op, v1, v2, bytes )

#define irEmitSCOPEBEGIN(s) ir.vtbl.emitScopeBegin( s )

#define irEmitSCOPEEND(s) ir.vtbl.emitScopeEnd( s )

#define irEmitDBG(op, proc, ex) ir.vtbl.emitDBG( op, proc, ex )


#define irIsREG(v) (v->typ = IR_VREGTYPE_REG)

#define irIsIMM(v) (v->typ = IR_VREGTYPE_IMM)

#define irGetVRType(v) v->typ

#define irGetVRDataType(v) v->dtype

#define ISLONGINT(t) ((t = FB_DATATYPE_LONGINT) or (t = FB_DATATYPE_ULONGINT))


''
'' inter-module globals
''
extern ir as IRCTX


#endif '' __IR_BI__
