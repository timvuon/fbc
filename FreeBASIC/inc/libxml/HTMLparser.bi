''
''
'' HTMLparser -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __HTMLparser_bi__
#define __HTMLparser_bi__

#include once "libxml/xmlversion.bi"
#include once "libxml/parser.bi"

type htmlParserCtxt as xmlParserCtxt
type htmlParserCtxtPtr as xmlParserCtxtPtr
type htmlParserNodeInfo as xmlParserNodeInfo
type htmlSAXHandler as xmlSAXHandler
type htmlSAXHandlerPtr as xmlSAXHandlerPtr
type htmlParserInput as xmlParserInput
type htmlParserInputPtr as xmlParserInputPtr
type htmlDocPtr as xmlDocPtr
type htmlNodePtr as xmlNodePtr
type htmlElemDesc as _htmlElemDesc
type htmlElemDescPtr as htmlElemDesc ptr

type _htmlElemDesc
	name as byte ptr
	startTag as byte
	endTag as byte
	saveEndTag as byte
	empty as byte
	depr as byte
	dtd as byte
	isinline as byte
	desc as byte ptr
	subelts as byte ptr ptr
	defaultsubelt as byte ptr
	attrs_opt as byte ptr ptr
	attrs_depr as byte ptr ptr
	attrs_req as byte ptr ptr
end type

type htmlEntityDesc as _htmlEntityDesc
type htmlEntityDescPtr as htmlEntityDesc ptr

type _htmlEntityDesc
	value as uinteger
	name as byte ptr
	desc as byte ptr
end type

declare function htmlTagLookup cdecl alias "htmlTagLookup" (byval tag as string) as htmlElemDesc ptr
declare function htmlEntityLookup cdecl alias "htmlEntityLookup" (byval name as string) as htmlEntityDesc ptr
declare function htmlEntityValueLookup cdecl alias "htmlEntityValueLookup" (byval value as uinteger) as htmlEntityDesc ptr
declare function htmlIsAutoClosed cdecl alias "htmlIsAutoClosed" (byval doc as htmlDocPtr, byval elem as htmlNodePtr) as integer
declare function htmlAutoCloseTag cdecl alias "htmlAutoCloseTag" (byval doc as htmlDocPtr, byval name as string, byval elem as htmlNodePtr) as integer
declare function htmlParseEntityRef cdecl alias "htmlParseEntityRef" (byval ctxt as htmlParserCtxtPtr, byval str as zstring ptr ptr) as htmlEntityDesc ptr
declare function htmlParseCharRef cdecl alias "htmlParseCharRef" (byval ctxt as htmlParserCtxtPtr) as integer
declare sub htmlParseElement cdecl alias "htmlParseElement" (byval ctxt as htmlParserCtxtPtr)
declare function htmlCreateMemoryParserCtxt cdecl alias "htmlCreateMemoryParserCtxt" (byval buffer as string, byval size as integer) as htmlParserCtxtPtr
declare function htmlParseDocument cdecl alias "htmlParseDocument" (byval ctxt as htmlParserCtxtPtr) as integer
declare function htmlSAXParseDoc cdecl alias "htmlSAXParseDoc" (byval cur as string, byval encoding as string, byval sax as htmlSAXHandlerPtr, byval userData as any ptr) as htmlDocPtr
declare function htmlParseDoc cdecl alias "htmlParseDoc" (byval cur as string, byval encoding as string) as htmlDocPtr
declare function htmlSAXParseFile cdecl alias "htmlSAXParseFile" (byval filename as string, byval encoding as string, byval sax as htmlSAXHandlerPtr, byval userData as any ptr) as htmlDocPtr
declare function htmlParseFile cdecl alias "htmlParseFile" (byval filename as string, byval encoding as string) as htmlDocPtr
declare function UTF8ToHtml cdecl alias "UTF8ToHtml" (byval out as ubyte ptr, byval outlen as integer ptr, byval in as ubyte ptr, byval inlen as integer ptr) as integer
declare function htmlEncodeEntities cdecl alias "htmlEncodeEntities" (byval out as ubyte ptr, byval outlen as integer ptr, byval in as ubyte ptr, byval inlen as integer ptr, byval quoteChar as integer) as integer
declare function htmlIsScriptAttribute cdecl alias "htmlIsScriptAttribute" (byval name as string) as integer
declare function htmlHandleOmittedElem cdecl alias "htmlHandleOmittedElem" (byval val as integer) as integer
declare function htmlCreatePushParserCtxt cdecl alias "htmlCreatePushParserCtxt" (byval sax as htmlSAXHandlerPtr, byval user_data as any ptr, byval chunk as string, byval size as integer, byval filename as string, byval enc as xmlCharEncoding) as htmlParserCtxtPtr
declare function htmlParseChunk cdecl alias "htmlParseChunk" (byval ctxt as htmlParserCtxtPtr, byval chunk as string, byval size as integer, byval terminate as integer) as integer
declare sub htmlFreeParserCtxt cdecl alias "htmlFreeParserCtxt" (byval ctxt as htmlParserCtxtPtr)

enum htmlParserOption
	HTML_PARSE_NOERROR = 1 shl 5
	HTML_PARSE_NOWARNING = 1 shl 6
	HTML_PARSE_PEDANTIC = 1 shl 7
	HTML_PARSE_NOBLANKS = 1 shl 8
	HTML_PARSE_NONET = 1 shl 11
end enum


declare sub htmlCtxtReset cdecl alias "htmlCtxtReset" (byval ctxt as htmlParserCtxtPtr)
declare function htmlCtxtUseOptions cdecl alias "htmlCtxtUseOptions" (byval ctxt as htmlParserCtxtPtr, byval options as integer) as integer
declare function htmlReadDoc cdecl alias "htmlReadDoc" (byval cur as string, byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlReadFile cdecl alias "htmlReadFile" (byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlReadMemory cdecl alias "htmlReadMemory" (byval buffer as string, byval size as integer, byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlReadFd cdecl alias "htmlReadFd" (byval fd as integer, byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlReadIO cdecl alias "htmlReadIO" (byval ioread as xmlInputReadCallback, byval ioclose as xmlInputCloseCallback, byval ioctx as any ptr, byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlCtxtReadDoc cdecl alias "htmlCtxtReadDoc" (byval ctxt as xmlParserCtxtPtr, byval cur as string, byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlCtxtReadFile cdecl alias "htmlCtxtReadFile" (byval ctxt as xmlParserCtxtPtr, byval filename as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlCtxtReadMemory cdecl alias "htmlCtxtReadMemory" (byval ctxt as xmlParserCtxtPtr, byval buffer as string, byval size as integer, byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlCtxtReadFd cdecl alias "htmlCtxtReadFd" (byval ctxt as xmlParserCtxtPtr, byval fd as integer, byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr
declare function htmlCtxtReadIO cdecl alias "htmlCtxtReadIO" (byval ctxt as xmlParserCtxtPtr, byval ioread as xmlInputReadCallback, byval ioclose as xmlInputCloseCallback, byval ioctx as any ptr, byval URL as string, byval encoding as string, byval options as integer) as htmlDocPtr

enum htmlStatus
	HTML_NA = 0
	HTML_INVALID = &h1
	HTML_DEPRECATED = &h2
	HTML_VALID = &h4
	HTML_REQUIRED = &hc
end enum


declare function htmlAttrAllowed cdecl alias "htmlAttrAllowed" (byval as htmlElemDesc ptr, byval as zstring ptr, byval as integer) as htmlStatus
declare function htmlElementAllowedHere cdecl alias "htmlElementAllowedHere" (byval as htmlElemDesc ptr, byval as zstring ptr) as integer
declare function htmlElementStatusHere cdecl alias "htmlElementStatusHere" (byval as htmlElemDesc ptr, byval as htmlElemDesc ptr) as htmlStatus
declare function htmlNodeStatus cdecl alias "htmlNodeStatus" (byval as htmlNodePtr, byval as integer) as htmlStatus

#endif
