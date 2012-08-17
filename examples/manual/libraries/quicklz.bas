'' examples/manual/libraries/quicklz.bas
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
'' See Also: http://www.freebasic.net/wiki/wikka.php?wakka=ExtLibquicklz
'' --------

'Real World Demonstration Program for the QuickLZ compression library:
'A command line file compression tool.

#include "quicklz.bi"

Declare Sub PrintUsage()
Declare Sub CompressFile( ByRef infile As String, ByRef outfile As String )
Declare Sub DecompressFile( ByRef infile As String, ByRef outfile As String )

If Len(Command(1)) <> 1 Then PrintUsage()
If Len(Command(2)) = 0 Then PrintUsage()
If Len(Command(3)) = 0 Then PrintUsage()

Select Case LCase(Command(1))
Case "c"
	CompressFile( Command(2), Command(3) )
Case "d"
	DeCompressFile( Command(2), Command(3) )
Case Else
	PrintUsage()
End Select

Sub CompressFile( ByRef infile As String, ByRef outfile As String )
	Dim As UByte Ptr inBuffer, outBuffer
	Dim As UInteger CSize, FSize
	Dim As Integer FF

	FF = FreeFile()
	If Open(infile For Binary Access Read As #FF) <> 0 Then
		Print "Unable to open file for input"
		End 2
	End If

	FSize = LOF(FF)
	inBuffer = Allocate(FSize)
	outBuffer = Allocate(QLZ_BUFFER_SIZE(FSize))

	Get #FF, , *inBuffer, FSize
	Close #FF

	CSize = qlz_compress(inBuffer, outBuffer, FSize)
	If CSize = 0 Then
		Print "Compression failed!"
		End 3
	End If

	FF = FreeFile()
	If Open(outfile For Binary Access Write As #FF) <> 0 Then
		Print "Unable to write compressed data!"
		End 4
	End If
	
	Put #FF, ,*outBuffer, CSize
	Close #FF

	Deallocate(inBuffer)
	Deallocate(outBuffer)

	Print "Uncompressed file: " & FSize & " bytes"
	Print "Compressed file: " & CSize & " bytes"
	Print "Difference: " & CInt(CSize - FSize) & " bytes"
End Sub

Sub DecompressFile( ByRef infile As String, ByRef outfile As String )
	Dim As UByte Ptr inBuffer, outBuffer
	Dim As UInteger CSize, FSize
	Dim As UByte FF

	FF = FreeFile()
	If Open(infile For Binary Access Read As #FF) <> 0 Then
		Print "Unable to open compressed file for input"
		End 5
	End If

	FSize = LOF(FF)
	inBuffer = Allocate(FSize)
	Get #FF, , *inBuffer, FSize

	Close #FF

	outBuffer = Allocate(qlz_size_decompressed(inBuffer))

	CSize = qlz_decompress(inBuffer, outBuffer)
	If CSize = 0 Then
		Print "Decompression failed, or uncompressed file is empty!"
		End 6
	End If

	FF = FreeFile()
	If Open(outfile For Binary Access Write As #FF) <> 0 Then
		Print "Unable to write uncompressed data!"
		End 7
	End If

	Put #FF, ,*outBuffer, CSize
	Close #FF

	Deallocate(inBuffer)
	Deallocate(outBuffer)

	Print "Compressed file: " & FSize & " bytes"
	Print "Uncompressed file: " & CSize & " bytes"
	Print "Difference: " & CInt(CSize - FSize) & " bytes"
End Sub

Sub PrintUsage()
	Print "QuickLZ 1.20 Demonstration Program"
	Print "Usage: qlz {c|d} infile outfile"
	Print "c flag is for compression"
	Print "d flag is for decompression"
	End 1
End Sub
