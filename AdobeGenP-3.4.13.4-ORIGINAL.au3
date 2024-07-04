#NoTrayIcon
#RequireAdmin
Global Const $0 = 12582912
Global Const $1 = 78
Global Const $2 = 0 - 2
Global Const $3 = 0 - 5
Global Const $4 = BitOR(131072, $0, -2147483648, 524288)
Global Enum $5, $6, $7, $8, $9, $a, $b, $c

Func _c(ByRef $d, $e, $f = 0, $g = "|", $h = @CRLF, $i = $5)
	If $f = Default Then $f = 0
	If $g = Default Then $g = "|"
	If $h = Default Then $h = @CRLF
	If $i = Default Then $i = $5
	If NOT IsArray($d) Then Return SetError(1, 0, -1)
	Local $j = UBound($d, 1)
	Local $k = 0
	Switch $i
		Case $7
			$k = Int
		Case $8
			$k = Number
		Case $9
			$k = Ptr
		Case $a
			$k = HWnd
		Case $b
			$k = String
		Case $c
			$k = "Boolean"
	EndSwitch
	Switch UBound($d, 0)
		Case 1
			If $i = $6 Then
				ReDim $d[$j + 1]
				$d[$j] = $e
				Return $j
			EndIf
			If IsArray($e) Then
				If UBound($e, 0) <> 1 Then Return SetError(5, 0, -1)
				$k = 0
			Else
				Local $l = StringSplit($e, $g, 2 + 1)
				If UBound($l, 1) = 1 Then
					$l[0] = $e
				EndIf
				$e = $l
			EndIf
			Local $m = UBound($e, 1)
			ReDim $d[$j + $m]
			For $n = 0 To $m - 1
				If String($k) = "Boolean" Then
					Switch $e[$n]
						Case "True", "1"
							$d[$j + $n] = True
						Case "False", "0", ""
							$d[$j + $n] = False
					EndSwitch
				ElseIf IsFunc($k) Then
					$d[$j + $n] = $k($e[$n])
				Else
					$d[$j + $n] = $e[$n]
				EndIf
			Next
			Return $j + $m - 1
		Case 2
			Local $o = UBound($d, 2)
			If $f < 0 OR $f > $o - 1 Then Return SetError(4, 0, -1)
			Local $p, $q = 0, $r
			If IsArray($e) Then
				If UBound($e, 0) <> 2 Then Return SetError(5, 0, -1)
				$p = UBound($e, 1)
				$q = UBound($e, 2)
				$k = 0
			Else
				Local $s = StringSplit($e, $h, 2 + 1)
				$p = UBound($s, 1)
				Local $l[$p][0], $t
				For $n = 0 To $p - 1
					$t = StringSplit($s[$n], $g, 2 + 1)
					$r = UBound($t)
					If $r > $q Then
						$q = $r
						ReDim $l[$p][$q]
					EndIf
					For $u = 0 To $r - 1
						$l[$n][$u] = $t[$u]
					Next
				Next
				$e = $l
			EndIf
			If UBound($e, 2) + $f > UBound($d, 2) Then Return SetError(3, 0, -1)
			ReDim $d[$j + $p][$o]
			For $v = 0 To $p - 1
				For $u = 0 To $o - 1
					If $u < $f Then
						$d[$v + $j][$u] = ""
					ElseIf $u - $f > $q - 1 Then
						$d[$v + $j][$u] = ""
					Else
						If String($k) = "Boolean" Then
							Switch $e[$v][$u - $f]
								Case "True", "1"
									$d[$v + $j][$u] = True
								Case "False", "0", ""
									$d[$v + $j][$u] = False
							EndSwitch
						ElseIf IsFunc($k) Then
							$d[$v + $j][$u] = $k($e[$v][$u - $f])
						Else
							$d[$v + $j][$u] = $e[$v][$u - $f]
						EndIf
					EndIf
				Next
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return UBound($d, 1) - 1
EndFunc

Global Const $w = "SeDebugPrivilege"
Global Enum $x = 0, $y, $0z, $10

Func _1l(Const $11 = @error, Const $12 = @extended)
	Local $13 = DllCall("kernel32.dll", "dword", "GetLastError")
	Return SetError($11, $12, $13[0])
EndFunc

Func _1p($14, Const $11 = @error, Const $12 = @extended)
	DllCall("kernel32.dll", "none", "SetLastError", "dword", $14)
	Return SetError($11, $12, NULL )
EndFunc

Func _1u($15, $16, $17, $18, $19 = 0, $1a = 0)
	Local $13 = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $15, "bool", $16, "struct*", $17, "dword", $18, "struct*", $19, "struct*", $1a)
	If @error Then Return SetError(@error, @extended, False)
	Return NOT ($13[0] = 0)
EndFunc

Func _20($1b = $0z)
	Local $13 = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $1b)
	If @error Then Return SetError(@error, @extended, False)
	Return NOT ($13[0] = 0)
EndFunc

Func _24($1c, $1d)
	Local $13 = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $1c, "wstr", $1d, "int64*", 0)
	If @error OR NOT $13[0] Then Return SetError(@error + 10, @extended, 0)
	Return $13[3]
EndFunc

Func _26($1e, $1f = 0, $1g = False)
	Local $13
	If $1f = 0 Then
		$13 = DllCall("kernel32.dll", "handle", "GetCurrentThread")
		If @error Then Return SetError(@error + 20, @extended, 0)
		$1f = $13[0]
	EndIf
	$13 = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $1f, "dword", $1e, "bool", $1g, "handle*", 0)
	If @error OR NOT $13[0] Then Return SetError(@error + 10, @extended, 0)
	Return $13[4]
EndFunc

Func _27($1e, $1f = 0, $1g = False)
	Local $15 = _26($1e, $1f, $1g)
	If $15 = 0 Then
		Local Const $1h = 1008
		If _1l() <> $1h Then Return SetError(20, _1l(), 0)
		If NOT _20() Then Return SetError(@error + 10, _1l(), 0)
		$15 = _26($1e, $1f, $1g)
		If $15 = 0 Then Return SetError(@error, _1l(), 0)
	EndIf
	Return $15
EndFunc

Func _28($15, $1i, $1j)
	Local $1k = _24("", $1i)
	If $1k = 0 Then Return SetError(@error + 10, @extended, False)
	Local Const $1l = "dword Count;align 4;int64 LUID;dword Attributes"
	Local $1m = DllStructCreate($1l)
	Local $1n = DllStructGetSize($1m)
	Local $19 = DllStructCreate($1l)
	Local $1o = DllStructGetSize($19)
	Local $1p = DllStructCreate("int Data")
	DllStructSetData($1m, "Count", 1)
	DllStructSetData($1m, "LUID", $1k)
	If NOT _1u($15, False, $1m, $1n, $19, $1p) Then Return SetError(2, @error, False)
	DllStructSetData($19, "Count", 1)
	DllStructSetData($19, "LUID", $1k)
	Local $1q = DllStructGetData($19, "Attributes")
	If $1j Then
		$1q = BitOR($1q, 2)
	Else
		$1q = BitAND($1q, BitNOT(2))
	EndIf
	DllStructSetData($19, "Attributes", $1q)
	If NOT _1u($15, False, $19, $1o, $1m, $1p) Then Return SetError(3, @error, False)
	Return True
EndFunc

Global Const $1r = "struct;long X;long Y;endstruct"
Global Const $1s = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $1t = "struct;hwnd hWndFrom;uint_ptr IDFrom;INT Code;endstruct"
Global Const $1u = $1r & ";uint Flags;int Item;int SubItem;int iGroup"
Global Const $1v = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
Global Const $1w = $1t & ";int Index;int SubItem;uint NewState;uint OldState;uint Changed;" & $1r & ";lparam lParam;uint KeyFlags"
Global Const $1x = "dword Length;ptr Descriptor;bool InheritHandle"
Global Const $1y = "handle hProc;ulong_ptr Size;ptr Mem"

Func _2d(ByRef $1z)
	Local $20 = DllStructGetData($1z, "Mem")
	Local $21 = DllStructGetData($1z, "hProc")
	Local $22 = _2r($21, $20, 0, 32768)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $21)
	If @error Then Return SetError(@error, @extended, False)
	Return $22
EndFunc

Func _2k($23, $24, ByRef $1z)
	Local $13 = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $23, "dword*", 0)
	If @error Then Return SetError(@error + 10, @extended, 0)
	Local $25 = $13[2]
	If $25 = 0 Then Return SetError(1, 0, 0)
	Local $1e = BitOR(8, 16, 32)
	Local $21 = _2s($1e, False, $25, True)
	Local $26 = BitOR(8192, 4096)
	Local $20 = _2p($21, 0, $24, $26, 4)
	If $20 = 0 Then Return SetError(2, 0, 0)
	$1z = DllStructCreate($1y)
	DllStructSetData($1z, "hProc", $21)
	DllStructSetData($1z, "Size", $24)
	DllStructSetData($1z, "Mem", $20)
	Return $20
EndFunc

Func _2m(ByRef $1z, $27, $28, $24)
	Local $13 = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($1z, "hProc"), "ptr", $27, "struct*", $28, "ulong_ptr", $24, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $13[0]
EndFunc

Func _2n(ByRef $1z, $27, $28 = 0, $24 = 0, $29 = "struct*")
	If $28 = 0 Then $28 = DllStructGetData($1z, "Mem")
	If $24 = 0 Then $24 = DllStructGetData($1z, "Size")
	Local $13 = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($1z, "hProc"), "ptr", $28, $29, $27, "ulong_ptr", $24, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $13[0]
EndFunc

Func _2p($21, $2a, $24, $2b, $2c)
	Local $13 = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $21, "ptr", $2a, "ulong_ptr", $24, "dword", $2b, "dword", $2c)
	If @error Then Return SetError(@error, @extended, 0)
	Return $13[0]
EndFunc

Func _2r($21, $2a, $24, $2d)
	Local $13 = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $21, "ptr", $2a, "ulong_ptr", $24, "dword", $2d)
	If @error Then Return SetError(@error, @extended, False)
	Return $13[0]
EndFunc

Func _2s($1e, $2e, $2f, $2g = False)
	Local $13 = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $1e, "bool", $2e, "dword", $2f)
	If @error Then Return SetError(@error, @extended, 0)
	If $13[0] Then Return $13[0]
	If NOT $2g Then Return SetError(100, 0, 0)
	Local $15 = _27(BitOR(32, 8))
	If @error Then Return SetError(@error + 10, @extended, 0)
	_28($15, $w, True)
	Local $2h = @error
	Local $2i = @extended
	Local $2j = 0
	If NOT @error Then
		$13 = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $1e, "bool", $2e, "dword", $2f)
		$2h = @error
		$2i = @extended
		If $13[0] Then $2j = $13[0]
		_28($15, $w, False)
		If @error Then
			$2h = @error + 20
			$2i = @extended
		EndIf
	Else
		$2h = @error + 30
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $15)
	Return SetError($2h, $2i, $2j)
EndFunc

Func _2t($23, $2k, $2l = 0, $2m = 0, $2n = 0, $2o = "wparam", $2p = "lparam", $2q = "lresult")
	Local $13 = DllCall("user32.dll", $2q, "SendMessageW", "hwnd", $23, "uint", $2k, $2o, $2l, $2p, $2m)
	If @error Then Return SetError(@error, @extended, "")
	If $2n >= 0 AND $2n <= 4 Then Return $13[$2n]
	Return $13
EndFunc

Func _2y($23)
	Local $13 = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $23)
	If @error Then Return SetError(@error, @extended, 0)
	Return $13[0]
EndFunc

Func _30($2r, $2s = True)
	Local $2t = _37($2r, $2s)
	If @error OR NOT $2t Then Return SetError(@error + 10, @extended, "")
	Local $2u = DllStructCreate(($2s ? "wchar" : "char") & "[" & ($2t + 1) & "]", $2r)
	If @error Then Return SetError(@error, @extended, "")
	Return SetExtended($2t, DllStructGetData($2u, 1))
EndFunc

Func _37($2r, $2s = True)
	Local $2v = ""
	If $2s Then $2v = "W"
	Local $13 = DllCall("kernel32.dll", "int", "lstrlen" & $2v, "struct*", $2r)
	If @error Then Return SetError(@error, @extended, 0)
	Return $13[0]
EndFunc

Global $2w[64][2] = [[0, 0]]
Global Const $2x = -16

Func _3w($23, $2y)
	Local $2z = "GetWindowLongW"
	If @AutoItX64 Then $2z = "GetWindowLongPtrW"
	Local $13 = DllCall("user32.dll", "long_ptr", $2z, "hwnd", $23, "int", $2y)
	If @error OR NOT $13[0] Then Return SetError(@error + 10, @extended, 0)
	Return $13[0]
EndFunc

Func _3z($23, ByRef $2f)
	Local $13 = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $23, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	$2f = $13[2]
	Return $13[0]
EndFunc

Func _41($23, ByRef $30)
	If $23 = $30 Then Return True
	For $31 = $2w[0][0] To 1 Step -1
		If $23 = $2w[$31][0] Then
			If $2w[$31][1] Then
				$30 = $23
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
	Local $2f
	_3z($23, $2f)
	Local $32 = $2w[0][0] + 1
	If $32 >= 64 Then $32 = 1
	$2w[0][0] = $32
	$2w[$32][0] = $23
	$2w[$32][1] = ($2f = @AutoItPID)
	Return $2w[$32][1]
EndFunc

Func _42($23, $33 = 0, $34 = True)
	If NOT IsHWnd($23) Then $23 = GUICtrlGetHandle($23)
	Local $13 = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $23, "struct*", $33, "bool", $34)
	If @error Then Return SetError(@error, @extended, False)
	Return $13[0]
EndFunc

Global $35

Func _4h($23, $2k, $2y, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	If $39 > 0 Then
		DllStructSetData($36, $39, DllStructGetPtr($37))
		If $39 = $3b Then DllStructSetData($36, $39 + 1, DllStructGetSize($37))
	EndIf
	Local $2j
	If IsHWnd($23) Then
		If _41($23, $35) Then
			$2j = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $23, "uint", $2k, "wparam", $2y, "struct*", $36)[0]
		Else
			Local $3c = DllStructGetSize($36)
			Local $1z, $3d
			Local $3e = 0
			If ($39 > 0) OR ($3b = 0) Then $3e = DllStructGetSize($37)
			Local $20 = _2k($23, $3c + $3e, $1z)
			If $3e Then
				$3d = $20 + $3c
				If $3b Then
					DllStructSetData($36, $39, $3d)
				Else
					$2y = $3d
				EndIf
				_2n($1z, $37, $3d, $3e)
			EndIf
			_2n($1z, $36, $20, $3c)
			$2j = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $23, "uint", $2k, "wparam", $2y, "ptr", $20)[0]
			If $3e AND $3a Then _2m($1z, $3d, $37, $3e)
			If $38 Then _2m($1z, $20, $36, $3c)
			_2d($1z)
		EndIf
	Else
		$2j = GUICtrlSendMsg($23, $2k, $2y, DllStructGetPtr($36))
	EndIf
	Return $2j
EndFunc

Func _4i($23, $2k, $2y, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	#forceref $2k, $2y, $38, $3a
	DllStructSetData($36, $39, DllStructGetPtr($37))
	If $39 = $3b Then DllStructSetData($36, $39 + 1, DllStructGetSize($37))
	Local $3f
	If IsHWnd($23) Then
		If _41($23, $35) Then
			$3f = _4j
			SetExtended(1)
		Else
			$3f = _4k
			SetExtended(2)
		EndIf
	Else
		$3f = _4l
		SetExtended(3)
	EndIf
	Return $3f
EndFunc

Func _4j($23, $2k, $2y, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	#forceref $37, $38, $3a, $3b
	Return DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $23, "uint", $2k, "wparam", $2y, "struct*", $36)[0]
EndFunc

Func _4k($23, $2k, $2y, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	Local $3c = DllStructGetSize($36)
	Local $1z, $3d
	Local $3e = 0
	If ($39 > 0) OR ($3b = 0) Then $3e = DllStructGetSize($37)
	Local $20 = _2k($23, $3c + $3e, $1z)
	If $3e Then
		$3d = $20 + $3c
		If $3b Then
			DllStructSetData($36, $39, $3d)
		Else
			$2y = $3d
		EndIf
		_2n($1z, $37, $3d, $3e)
	EndIf
	_2n($1z, $36, $20, $3c)
	Local $2j = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $23, "uint", $2k, "wparam", $2y, "ptr", $20)[0]
	If $3e AND $3a Then _2m($1z, $3d, $37, $3e)
	If $38 Then _2m($1z, $20, $36, $3c)
	_2d($1z)
	Return $2j
EndFunc

Func _4l($23, $2k, $2y, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	#forceref $37, $38, $3a, $3b
	Return GUICtrlSendMsg($23, $2k, $2y, DllStructGetPtr($36))
EndFunc

Func _5d($3g, $3h = 0, $3i = 0, $3j = False)
	Local $3k = ""
	If IsString($3g) Then $3k = "str"
	If (IsDllStruct($3g) OR IsPtr($3g)) Then $3k = "struct*"
	If $3k = "" Then Return SetError(1, 0, 0)
	Local $13 = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $3h, "dword", $3i, $3k, $3g, "int", -1, "ptr", 0, "int", 0)
	If @error OR NOT $13[0] Then Return SetError(@error + 10, @extended, 0)
	Local $3l = $13[0]
	Local $3m = DllStructCreate("wchar[" & $3l & "]")
	$13 = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $3h, "dword", $3i, $3k, $3g, "int", -1, "struct*", $3m, "int", $3l)
	If @error OR NOT $13[0] Then Return SetError(@error + 20, @extended, 0)
	If $3j Then Return DllStructGetData($3m, 1)
	Return $3m
EndFunc

Global Const $3n = BitOR(2, 4, 8)
Global Const $3o = (4096 + 9)
Global Const $3p = (4096 + 157)
Global Const $3q = (4096 + 19)
Global Const $3r = (4096 + 152)
Global Const $3s = (4096 + 149)
Global Const $3t = (4096 + 153)
Global Const $3u = (4096 + 31)
Global Const $3v = (4096 + 5)
Global Const $3w = (4096 + 75)
Global Const $3x = (4096 + 4)
Global Const $3y = (4096 + 14)
Global Const $3z = (4096 + 45)
Global Const $40 = (4096 + 115)
Global Const $41 = (4096 + 50)
Global Const $42 = 8192 + 6
Global Const $43 = (4096 + 143)
Global Const $44 = (4096 + 34)
Global Const $45 = (4096 + 18)
Global Const $46 = (4096 + 27)
Global Const $47 = (4096 + 97)
Global Const $48 = (4096 + 145)
Global Const $49 = (4096 + 7)
Global Const $4a = (4096 + 77)
Global Const $4b = (4096 + 150)
Global Const $4c = (4096 + 20)
Global Const $4d = (4096 + 26)
Global Const $4e = (4096 + 96)
Global Const $4f = (4096 + 30)
Global Const $4g = (4096 + 54)
Global Const $4h = (4096 + 147)
Global Const $4i = (4096 + 6)
Global Const $4j = (4096 + 76)
Global Const $4k = (4096 + 47)
Global Const $4l = (4096 + 43)
Global Const $4m = (-100 - 8)
Global $4n[1][11]
Global $4o, $4p
Global $4q = DllStructCreate($1v)
Global Const $4r = 11
Global Const $4s = "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order;int cxMin;int cxDefault;int cxIdeal"
Global Const $4t = "uint Size;uint Mask;ptr Header;int HeaderMax;ptr Footer;int FooterMax;int GroupID;uint StateMask;uint State;uint Align;" & "ptr  pszSubtitle;uint cchSubtitle;ptr pszTask;uint cchTask;ptr pszDescriptionTop;uint cchDescriptionTop;ptr pszDescriptionBottom;" & "uint cchDescriptionBottom;int iTitleImage;int iExtendedImage;int iFirstItem;uint cItems;ptr pszSubsetTitle;uint cchSubsetTitle"

Func _ie($23, ByRef $4u)
	Local $37, $2k, $4v
	If _la($23) Then
		$37 = $4o
		$2k = $4a
		$4v = $4j
	Else
		$37 = $4p
		$2k = $49
		$4v = $4i
	EndIf
	Local $36 = $4q
	DllStructSetData($36, "Mask", 1)
	Local $4w = _k5($23)
	_in($23)
	Local $4x = _4i($23, $2k, 0, $36, $37, False, 6)
	For $31 = 0 To UBound($4u) - 1
		DllStructSetData($36, "Item", $31 + $4w)
		DllStructSetData($36, "SubItem", 0)
		DllStructSetData($37, 1, $4u[$31][0])
		$4x($23, $2k, 0, $36, $37, False, 6)
		For $4y = 1 To UBound($4u, 2) - 1
			DllStructSetData($36, "SubItem", $4y)
			DllStructSetData($37, 1, $4u[$31][$4y])
			$4x($23, $4v, 0, $36, $37, False, 6)
		Next
	Next
	_j3($23)
EndFunc

Func _if($23, $4z, $50 = 50, $51 = -1, $52 = -1, $53 = False)
	Return _lm($23, _je($23), $4z, $50, $51, $52, $53)
EndFunc

Func _ig($23, $4z, $52 = -1, $54 = 0)
	Return _lo($23, $4z, -1, $52, $54)
EndFunc

Func _ih($23, $2y, $4z, $55, $52 = -1)
	Local $37, $2k
	If _la($23) Then
		$37 = $4o
		$2k = $4j
	Else
		$37 = $4p
		$2k = $4i
	EndIf
	Local $36 = $4q
	Local $56 = 1
	If $52 <> -1 Then $56 = BitOR($56, 2)
	DllStructSetData($37, 1, $4z)
	DllStructSetData($36, "Mask", $56)
	DllStructSetData($36, "Item", $2y)
	DllStructSetData($36, "SubItem", $55)
	DllStructSetData($36, "Image", $52)
	Local $2j = _4h($23, $2k, 0, $36, $37, False, 6, False, -1)
	Return $2j <> 0
EndFunc

Func _in($23)
	If IsHWnd($23) Then
		Return _2t($23, $4r, False) = 0
	Else
		Return GUICtrlSendMsg($23, $4r, False, 0) = 0
	EndIf
EndFunc

Func _iu($23)
	If _k5($23) = 0 Then Return True
	Local $57 = 0
	If IsHWnd($23) Then
		$57 = _2y($23)
	Else
		$57 = $23
		$23 = GUICtrlGetHandle($23)
	EndIf
	If $57 < 10000 Then
		Local $54 = 0
		For $2y = _k5($23) - 1 To 0 Step -1
			$54 = _ke($23, $2y)
			If GUICtrlGetState($54) > 0 AND GUICtrlGetHandle($54) = 0 Then
				GUICtrlDelete($54)
			EndIf
		Next
		If _k5($23) = 0 Then Return True
	EndIf
	Return _2t($23, $3o) <> 0
EndFunc

Func _j2($23, $1j = True)
	If IsHWnd($23) Then
		Return _2t($23, $3p, $1j)
	Else
		Return GUICtrlSendMsg($23, $3p, $1j, 0)
	EndIf
EndFunc

Func _j3($23)
	If IsHWnd($23) Then
		Return _2t($23, $4r, True) = 0
	Else
		Return GUICtrlSendMsg($23, $4r, True, 0) = 0
	EndIf
EndFunc

Func _j4($23, $2y, $58 = False)
	If IsHWnd($23) Then
		Return _2t($23, $3q, $2y, $58)
	Else
		Return GUICtrlSendMsg($23, $3q, $2y, $58)
	EndIf
EndFunc

Func _je($23)
	Return _2t(_ju($23), 4608)
EndFunc

Func _jn($23)
	If IsHWnd($23) Then
		Return _2t($23, $3r)
	Else
		Return GUICtrlSendMsg($23, $3r, 0, 0)
	EndIf
EndFunc

Func _jo($23, $59)
	Local $5a = _jp($23, $59, BitOR(1, 8))
	Local $5b = @error
	Local $5c[2]
	$5c[0] = _30(DllStructGetData($5a, "Header"))
	Select 
		Case BitAND(DllStructGetData($5a, "Align"), 2) <> 0
			$5c[1] = 1
		Case BitAND(DllStructGetData($5a, "Align"), 4) <> 0
			$5c[1] = 2
		Case Else
			$5c[1] = 0
	EndSelect
	Return SetError($5b, 0, $5c)
EndFunc

Func _jp($23, $59, $56)
	Local $5a = DllStructCreate($4t)
	Local $5d = DllStructGetSize($5a)
	DllStructSetData($5a, "Size", $5d)
	DllStructSetData($5a, "Mask", $56)
	Local $2j = _4h($23, $3s, $59, $5a, 0, True, -1)
	Return SetError($2j <> $59, 0, $5a)
EndFunc

Func _jq($23, $2y)
	Local $5a = DllStructCreate($4t)
	Local $5d = DllStructGetSize($5a)
	DllStructSetData($5a, "Size", $5d)
	DllStructSetData($5a, "Mask", BitOR(1, 8, 16))
	Local $2j = _4h($23, $3t, $2y, $5a, 0, True, -1)
	Local $5c[3]
	$5c[0] = _30(DllStructGetData($5a, "Header"))
	Select 
		Case BitAND(DllStructGetData($5a, "Align"), 2) <> 0
			$5c[1] = 1
		Case BitAND(DllStructGetData($5a, "Align"), 4) <> 0
			$5c[1] = 2
		Case Else
			$5c[1] = 0
	EndSelect
	$5c[2] = DllStructGetData($5a, "GroupID")
	Return SetError($2j = 0, 0, $5c)
EndFunc

Func _ju($23)
	If IsHWnd($23) Then
		Return HWnd(_2t($23, $3u))
	Else
		Return HWnd(GUICtrlSendMsg($23, $3u, 0, 0))
	EndIf
EndFunc

Func _k4($23, $2y)
	Local $2k
	If _la($23) Then
		$2k = $3w
	Else
		$2k = $3v
	EndIf
	Local $36 = $4q
	DllStructSetData($36, "Mask", 8)
	DllStructSetData($36, "Item", $2y)
	DllStructSetData($36, "SubItem", 0)
	DllStructSetData($36, "StateMask", 65535)
	Local $2j = _4h($23, $2k, 0, $36, 0, True, -1)
	If NOT $2j Then Return SetError(-1, -1, False)
	Return BitAND(DllStructGetData($36, "State"), 8192) <> 0
EndFunc

Func _k5($23)
	If IsHWnd($23) Then
		Return _2t($23, $3x)
	Else
		Return GUICtrlSendMsg($23, $3x, 0, 0)
	EndIf
EndFunc

Func _k8($23, ByRef $36)
	Local $2k
	If _la($23) Then
		$2k = $3w
	Else
		$2k = $3v
	EndIf
	Local $2j = _4h($23, $2k, 0, $36, 0, True, -1)
	Return $2j <> 0
EndFunc

Func _ka($23, $2y)
	Local $36 = $4q
	DllStructSetData($36, "Mask", 256)
	DllStructSetData($36, "Item", $2y)
	DllStructSetData($36, "SubItem", 0)
	_k8($23, $36)
	Return DllStructGetData($36, "GroupID")
EndFunc

Func _ke($23, $2y)
	Local $36 = $4q
	DllStructSetData($36, "Mask", 4)
	DllStructSetData($36, "Item", $2y)
	DllStructSetData($36, "SubItem", 0)
	_k8($23, $36)
	Return DllStructGetData($36, "Param")
EndFunc

Func _ki($23, $2y, $5e = 3)
	Local $33 = _kj($23, $2y, $5e)
	Local $5f[4]
	$5f[0] = DllStructGetData($33, "Left")
	$5f[1] = DllStructGetData($33, "Top")
	$5f[2] = DllStructGetData($33, "Right")
	$5f[3] = DllStructGetData($33, "Bottom")
	Return $5f
EndFunc

Func _kj($23, $2y, $5e = 3)
	Local $33 = DllStructCreate($1s)
	DllStructSetData($33, "Left", $5e)
	_4h($23, $3y, $2y, $33, 0, True, -1)
	Return $33
EndFunc

Func _kq($23, $2y, $55 = 0)
	Local $37, $2k
	If _la($23) Then
		$37 = $4o
		$2k = $40
	Else
		$37 = $4p
		$2k = $3z
	EndIf
	Local $36 = $4q
	DllStructSetData($37, 1, "")
	DllStructSetData($36, "Mask", 1)
	DllStructSetData($36, "SubItem", $55)
	_4h($23, $2k, $2y, $36, $37, False, 6, True)
	Return DllStructGetData($37, 1)
EndFunc

Func _l0($23)
	If IsHWnd($23) Then
		Return _2t($23, $41)
	Else
		Return GUICtrlSendMsg($23, $41, 0, 0)
	EndIf
EndFunc

Func _la($23)
	If NOT IsDllStruct($4o) Then
		$4o = DllStructCreate("wchar Text[4096]")
		$4p = DllStructCreate("char Text[4096]", DllStructGetPtr($4o))
	EndIf
	If IsHWnd($23) Then
		Return _2t($23, $42) <> 0
	Else
		Return GUICtrlSendMsg($23, $42, 0, 0) <> 0
	EndIf
EndFunc

Func _lb($23)
	Local $5g
	If IsHWnd($23) Then
		$5g = _2t($23, $43)
	Else
		$5g = GUICtrlSendMsg($23, $43, 0, 0)
	EndIf
	Switch $5g
		Case 0
			Return Int(0)
		Case 1
			Return Int(1)
		Case 3
			Return Int(3)
		Case 2
			Return Int(2)
		Case 4
			Return Int(4)
		Case Else
			Return -1
	EndSwitch
EndFunc

Func _lh($23)
	Local $5f[4] = [0, 0, 0, 0]
	Local $5g = _lb($23)
	If ($5g < 0) AND ($5g > 4) Then Return $5f
	Local $33 = DllStructCreate($1s)
	_4h($23, $44, 0, $33, 0, True, -1)
	$5f[0] = DllStructGetData($33, "Left")
	$5f[1] = DllStructGetData($33, "Top")
	$5f[2] = DllStructGetData($33, "Right")
	$5f[3] = DllStructGetData($33, "Bottom")
	Return $5f
EndFunc

Func _lj($23, $5h = -1, $5i = -1)
	Local $5j = Opt("MouseCoordMode", 1)
	Local $5k = MouseGetPos()
	Opt("MouseCoordMode", $5j)
	Local $5l = DllStructCreate($1r)
	DllStructSetData($5l, "X", $5k[0])
	DllStructSetData($5l, "Y", $5k[1])
	Local $13 = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $23, "struct*", $5l)
	If @error Then Return SetError(@error, @extended, 0)
	If $13[0] = 0 Then Return 0
	If $5h = -1 Then $5h = DllStructGetData($5l, "X")
	If $5i = -1 Then $5i = DllStructGetData($5l, "Y")
	Local $5m = DllStructCreate($1u)
	DllStructSetData($5m, "X", $5h)
	DllStructSetData($5m, "Y", $5i)
	Local $5n[10]
	$5n[0] = _4h($23, $45, 0, $5m, 0, True, -1)
	Local $3i = DllStructGetData($5m, "Flags")
	$5n[1] = BitAND($3i, 1) <> 0
	$5n[2] = BitAND($3i, 2) <> 0
	$5n[3] = BitAND($3i, 4) <> 0
	$5n[4] = BitAND($3i, 8) <> 0
	$5n[5] = BitAND($3i, $3n) <> 0
	$5n[6] = BitAND($3i, 8) <> 0
	$5n[7] = BitAND($3i, 16) <> 0
	$5n[8] = BitAND($3i, 64) <> 0
	$5n[9] = BitAND($3i, 32) <> 0
	Return $5n
EndFunc

Func _lm($23, $2y, $4z, $50 = 50, $51 = -1, $52 = -1, $53 = False)
	Local $5o[3] = [0, 1, 2]
	Local $37, $2k
	If _la($23) Then
		$37 = $4o
		$2k = $47
	Else
		$37 = $4p
		$2k = $46
	EndIf
	Local $5p = DllStructCreate($4s)
	Local $56 = BitOR(1, 2, 4)
	If $51 < 0 OR $51 > 2 Then $51 = 0
	Local $5q = $5o[$51]
	If $52 <> -1 Then
		$56 = BitOR($56, 16)
		$5q = BitOR($5q, 32768, 2048)
	EndIf
	If $53 Then $5q = BitOR($5q, 4096)
	DllStructSetData($37, 1, $4z)
	DllStructSetData($5p, "Mask", $56)
	DllStructSetData($5p, "Fmt", $5q)
	DllStructSetData($5p, "CX", $50)
	DllStructSetData($5p, "Image", $52)
	Local $2j = _4h($23, $2k, $2y, $5p, $37, False, 4)
	If $51 > 0 Then _m6($23, $2j, $4z, $50, $51, $52, $53)
	Return $2j
EndFunc

Func _ln($23, $2y, $59, $5r, $51 = 0)
	Local $5o[3] = [1, 2, 4]
	If $51 < 0 OR $51 > 2 Then $51 = 0
	Local $5s = _5d($5r)
	Local $5a = DllStructCreate($4t)
	Local $56 = BitOR(1, 8, 16)
	DllStructSetData($5a, "Size", DllStructGetSize($5a))
	DllStructSetData($5a, "Mask", $56)
	DllStructSetData($5a, "GroupID", $59)
	DllStructSetData($5a, "Align", $5o[$51])
	Local $2j = _4h($23, $48, $2y, $5a, $5s, False, 3)
	Return $2j
EndFunc

Func _lo($23, $4z, $2y = -1, $52 = -1, $54 = 0)
	Local $37, $2k
	If _la($23) Then
		$37 = $4o
		$2k = $4a
	Else
		$37 = $4p
		$2k = $49
	EndIf
	Local $36 = $4q
	If $2y = -1 Then $2y = 999999999
	DllStructSetData($37, 1, $4z)
	Local $56 = BitOR(1, 4)
	If $52 >= 0 Then $56 = BitOR($56, 2)
	DllStructSetData($36, "Mask", $56)
	DllStructSetData($36, "Item", $2y)
	DllStructSetData($36, "SubItem", 0)
	DllStructSetData($36, "Image", $52)
	DllStructSetData($36, "Param", $54)
	Local $2j = _4h($23, $2k, 0, $36, $37, False, 6)
	Return $2j
EndFunc

Func _ly($23)
	_in($23)
	Local $59
	For $5t = _jn($23) - 1 To 0 Step -1
		$59 = _jq($23, $5t)[2]
		_lz($23, $59)
	Next
	_j3($23)
EndFunc

Func _lz($23, $59)
	If IsHWnd($23) Then
		Return _2t($23, $4b, $59)
	Else
		Return GUICtrlSendMsg($23, $4b, $59, 0)
	EndIf
EndFunc

Func _m1($23, $5u, $5v)
	If IsHWnd($23) Then
		Return _2t($23, $4c, $5u, $5v) <> 0
	Else
		Return GUICtrlSendMsg($23, $4c, $5u, $5v) <> 0
	EndIf
EndFunc

Func _m6($23, $2y, $4z, $50 = -1, $51 = -1, $52 = -1, $53 = False)
	Local $5o[3] = [0, 1, 2]
	Local $37, $2k
	If _la($23) Then
		$37 = $4o
		$2k = $4e
	Else
		$37 = $4p
		$2k = $4d
	EndIf
	Local $5p = DllStructCreate($4s)
	Local $56 = 4
	If $51 < 0 OR $51 > 2 Then $51 = 0
	$56 = BitOR($56, 1)
	Local $5q = $5o[$51]
	If $50 <> -1 Then $56 = BitOR($56, 2)
	If $52 <> -1 Then
		$56 = BitOR($56, 16)
		$5q = BitOR($5q, 32768, 2048)
	Else
		$52 = 0
	EndIf
	If $53 Then $5q = BitOR($5q, 4096)
	DllStructSetData($37, 1, $4z)
	DllStructSetData($5p, "Mask", $56)
	DllStructSetData($5p, "Fmt", $5q)
	DllStructSetData($5p, "CX", $50)
	DllStructSetData($5p, "Image", $52)
	Local $2j = _4h($23, $2k, $2y, $5p, $37, False, 4)
	Return $2j <> 0
EndFunc

Func _ma($23, $5w, $5x = 0)
	Local $2j
	If IsHWnd($23) Then
		$2j = _2t($23, $4g, $5x, $5w)
	Else
		$2j = GUICtrlSendMsg($23, $4g, $5x, $5w)
	EndIf
	_42($23)
	Return $2j
EndFunc

Func _mb($23, $59, $5r, $51 = 0, $5y = 0)
	Local $5a = 0
	If BitAND($5y, 32) Then
		$5a = _jp($23, $59, BitOR(16, 16384))
		If @error OR DllStructGetData($5a, "cItems") = 0 Then Return False
	EndIf
	Local $5o[3] = [1, 2, 4]
	If $51 < 0 OR $51 > 2 Then $51 = 0
	Local $5s = _5d($5r)
	$5a = DllStructCreate($4t)
	Local $56 = BitOR(1, 8, 4)
	DllStructSetData($5a, "Size", DllStructGetSize($5a))
	DllStructSetData($5a, "Mask", $56)
	DllStructSetData($5a, "Align", $5o[$51])
	DllStructSetData($5a, "State", $5y)
	DllStructSetData($5a, "StateMask", $5y)
	Local $2j = _4h($23, $4h, $59, $5a, $5s, False, 3)
	DllStructSetData($5a, "Mask", 16)
	DllStructSetData($5a, "GroupID", $59)
	_4h($23, $4h, 0, $5a, 0, False, -1)
	_42($23)
	Return $2j <> 0
EndFunc

Func _ml($23, $2y, $5z = True)
	Local $2k
	If _la($23) Then
		$2k = $4j
	Else
		$2k = $4i
	EndIf
	Local $36 = $4q
	If ($5z) Then
		DllStructSetData($36, "State", 8192)
	Else
		DllStructSetData($36, "State", 4096)
	EndIf
	DllStructSetData($36, "StateMask", 61440)
	DllStructSetData($36, "Mask", 8)
	DllStructSetData($36, "SubItem", 0)
	Local $60 = $2y
	If $2y = -1 Then
		$2y = 0
		$60 = _k5($23) - 1
	EndIf
	Local $2j
	For $5t = $2y To $60
		DllStructSetData($36, "Item", $5t)
		$2j = _4h($23, $2k, 0, $36, 0, False, -1)
		If $2j = 0 Then ExitLoop
	Next
	Return $2j <> 0
EndFunc

Func _mm($23, $61)
	If IsHWnd($23) Then
		Return _2t($23, $4k, $61, BitOR(1, 2)) <> 0
	Else
		Return GUICtrlSendMsg($23, $4k, $61, BitOR(1, 2)) <> 0
	EndIf
EndFunc

Func _mp($23, ByRef $36, $62 = 0)
	Local $37, $2k
	If _la($23) Then
		$37 = $4o
		$2k = $4j
	Else
		$37 = $4p
		$2k = $4i
	EndIf
	Local $3e = 0
	If $62 Then
		$37 = 0
		DllStructSetData($36, "Text", 0)
	Else
		If DllStructGetData($36, "Text") <> -1 Then
			$3e = DllStructGetSize($37)
		Else
		EndIf
	EndIf
	DllStructSetData($36, "TextMax", $3e)
	Local $2j = _4h($23, $2k, 0, $36, $37, False, -1)
	Return $2j <> 0
EndFunc

Func _mr($23, $2y, $59)
	Local $36 = $4q
	DllStructSetData($36, "Mask", 256)
	DllStructSetData($36, "Item", $2y)
	DllStructSetData($36, "SubItem", 0)
	DllStructSetData($36, "GroupID", $59)
	Return _mp($23, $36, 1)
EndFunc

Func _my($23, $2y, $63 = True, $64 = False)
	Local $36 = $4q
	Local $65 = 0, $66 = 0
	If ($63 = True) Then $65 = 2
	If ($64 = True AND $2y <> -1) Then $66 = 1
	DllStructSetData($36, "Mask", 8)
	DllStructSetData($36, "Item", $2y)
	DllStructSetData($36, "SubItem", 0)
	DllStructSetData($36, "State", BitOR($65, $66))
	DllStructSetData($36, "StateMask", BitOR(2, $66))
	Local $2j = _4h($23, $4l, $2y, $36, 0, False, -1)
	Return $2j <> 0
EndFunc

Func _n1($23, $2y, $4z, $55 = 0)
	Local $2j
	If $55 = -1 Then
		Local $67 = Opt("GUIDataSeparatorChar")
		Local $68 = _je($23)
		Local $69 = StringSplit($4z, $67)
		If $68 > $69[0] Then $68 = $69[0]
		For $n = 1 To $68
			$2j = _n1($23, $2y, $69[$n], $n - 1)
			If NOT $2j Then ExitLoop
		Next
		Return $2j
	EndIf
	Local $37, $2k
	If _la($23) Then
		$37 = $4o
		$2k = $4j
	Else
		$37 = $4p
		$2k = $4i
	EndIf
	Local $36 = $4q
	DllStructSetData($37, 1, $4z)
	DllStructSetData($36, "Mask", 1)
	DllStructSetData($36, "Item", $2y)
	DllStructSetData($36, "SubItem", $55)
	$2j = _4h($23, $2k, 0, $36, $37, False, 6, False, -1)
	Return $2j <> 0
EndFunc

#Au3Stripper_Ignore_Funcs=__GUICtrlListView_Sort

Func __guictrllistview_sort($6a, $6b, $23)
	Local $2y, $6c, $6d, $6e
	Local $37, $2k
	If $4n[$2y][0] Then
		$37 = $4o
		$2k = $40
	Else
		$37 = $4p
		$2k = $3z
	EndIf
	Local $36 = $4q
	For $5t = 1 To $4n[0][0]
		If $23 = $4n[$5t][1] Then
			$2y = $5t
			ExitLoop
		EndIf
	Next
	If $4n[$2y][3] = $4n[$2y][4] Then
		If NOT $4n[$2y][7] Then
			$4n[$2y][5] *= -1
			$4n[$2y][7] = 1
		EndIf
	Else
		$4n[$2y][7] = 1
	EndIf
	$4n[$2y][6] = $4n[$2y][3]
	DllStructSetData($36, "Mask", 1)
	DllStructSetData($36, "SubItem", $4n[$2y][3])
	_4h($23, $2k, $6a, $36, $37, False, 6, True)
	$6c = DllStructGetData($37, 1)
	_4h($23, $2k, $6b, $36, $37, False, 6, True)
	$6d = DllStructGetData($37, 1)
	If $4n[$2y][8] = 1 Then
		If (StringIsFloat($6c) OR StringIsInt($6c)) Then $6c = Number($6c)
		If (StringIsFloat($6d) OR StringIsInt($6d)) Then $6d = Number($6d)
	EndIf
	If $4n[$2y][8] < 2 Then
		$6e = 0
		If $6c < $6d Then
			$6e = -1
		ElseIf $6c > $6d Then
			$6e = 1
		EndIf
	Else
		$6e = DllCall("shlwapi.dll", "int", "StrCmpLogicalW", "wstr", $6c, "wstr", $6d)[0]
	EndIf
	$6e = $6e * $4n[$2y][5]
	Return $6e
EndFunc

Func _r7($6f, $6g)
	$6g = Int($6g)
	If $6g = 0 Then Return ""
	If StringLen($6f) < 1 OR $6g < 0 Then Return SetError(1, 0, "")
	Local $6h = ""
	While $6g > 1
		If BitAND($6g, 1) Then $6h &= $6f
		$6f &= $6f
		$6g = BitShift($6g, 1)
	WEnd
	Return $6f & $6h
EndFunc

Global Const $6i = Ptr(-1)
Global Const $6j = Ptr(-1)
Global Const $6k = BitShift(256, 8)
Global Const $6l = BitShift(8192, 8)
Global Const $6m = BitShift(32768, 8)

Func _xz($23, $2y, $6n)
	_1p(0)
	Local $2z = "SetWindowLongW"
	If @AutoItX64 Then $2z = "SetWindowLongPtrW"
	Local $13 = DllCall("user32.dll", "long_ptr", $2z, "hwnd", $23, "int", $2y, "long_ptr", $6n)
	If @error Then Return SetError(@error, @extended, 0)
	Return $13[0]
EndFunc

Func _116($6o, $6p = 0)
	Local Const $6q = 183
	Local Const $6r = 1
	Local $6s = 0
	If BitAND($6p, 2) Then
		Local $6t = DllStructCreate("byte;byte;word;ptr[4]")
		Local $13 = DllCall("advapi32.dll", "bool", "InitializeSecurityDescriptor", "struct*", $6t, "dword", $6r)
		If @error Then Return SetError(@error, @extended, 0)
		If $13[0] Then
			$13 = DllCall("advapi32.dll", "bool", "SetSecurityDescriptorDacl", "struct*", $6t, "bool", 1, "ptr", 0, "bool", 0)
			If @error Then Return SetError(@error, @extended, 0)
			If $13[0] Then
				$6s = DllStructCreate($1x)
				DllStructSetData($6s, 1, DllStructGetSize($6s))
				DllStructSetData($6s, 2, DllStructGetPtr($6t))
				DllStructSetData($6s, 3, 0)
			EndIf
		EndIf
	EndIf
	Local $6u = DllCall("kernel32.dll", "handle", "CreateMutexW", "struct*", $6s, "bool", 1, "wstr", $6o)
	If @error Then Return SetError(@error, @extended, 0)
	Local $6v = DllCall("kernel32.dll", "dword", "GetLastError")
	If @error Then Return SetError(@error, @extended, 0)
	If $6v[0] = $6q Then
		If BitAND($6p, 1) Then
			DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $6u[0])
			If @error Then Return SetError(@error, @extended, 0)
			Return SetError($6v[0], $6v[0], 0)
		Else
			Exit -1
		EndIf
	EndIf
	Return $6u[0]
EndFunc

AutoItSetOption("GUICloseOnESC", 0)
Global Const $6w = "Adobe GenP v3.4.13.4", $6x = "Original version by uncia - CGP + GenP Community Edition - v3.4.13.4"
If _116($6w, 1) = 0 Then
	Exit
EndIf
Global $6y = True
Global $6z = 0
Global $70[0][1], $71[0][1]
Global $72[0][1], $73 = 0
Global $74, $75, $76, $77, $78, $79, $7a, $7b, $7c
Global $7d, $7e, $7f, $7g = 1
Global $7h, $7i, $7j, $7k, $7l, $7m, $7n
Global $7o = @ScriptDir & "\config.ini"
If NOT FileExists($7o) Then
	FileInstall("config.ini", @ScriptDir & "\config.ini")
EndIf
Global $7p = IniRead($7o, "Default", "Path", "C:\Program Files")
If NOT FileExists($7p) OR NOT StringInStr(FileGetAttrib($7p), "D") Then
	IniWrite($7o, "Default", "Path", "C:\Program Files")
	$7p = "C:\Program Files"
EndIf
If NOT (@UserName = "SYSTEM") AND FileExists("NSudoLG.exe") Then
	Exit Run(@ScriptDir & '\NSudoLG.exe -U:T -P:E -M:S "' & @ScriptFullPath & '"')
EndIf
Global $7q = 0, $7r = 0, $7s
Global $7t[0], $7u[0], $7v[0]
Global $7w, $7x = False, $7y = False, $7z = False, $80 = False, $81 = False, $82, $83 = "|"
Global $84, $85
Local $86 = IniReadSection($7o, "TargetFiles")
Global $87[0]
If NOT @error Then
	ReDim $87[$86[0][0]]
	For $n = 1 To $86[0][0]
		$87[$n - 1] = StringReplace($86[$n][1], '"', "")
	Next
EndIf
$82 = IniReadSection($7o, "CustomPatterns")
For $n = 1 To UBound($82) - 1
	$83 = $83 & $82[$n][0] & "|"
Next
GUIRegisterMsg(273, "_11z")
_11c()
While 1
	$78 = GUIGetMsg()
	Select 
		Case $78 = -3
			GUIDelete($74)
			Exit
		Case $78 = -12
			ContinueCase
		Case $78 = -5
			ContinueCase
		Case $78 = -6
			Local $50
			Local $88 = WinGetPos($74)
			Local $5f = _lh($7a)
			If ($5f[2] > $88[2]) Then
				$50 = $88[2] - 75
			Else
				$50 = $5f[2] - 25
			EndIf
			GUICtrlSendMsg($79, $4f, 1, $50)
		Case $78 = $7c
			$7g = 0
			_11e()
			_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7p & @CRLF & "---" & @CRLF & "Waiting for user action.")
			GUICtrlSetState($7c, 32)
			GUICtrlSetState($7b, 16)
			GUICtrlSetState($7b, 64)
			GUICtrlSetState($7m, 32)
			GUICtrlSetState($7h, 16)
			GUICtrlSetState($7h, 64)
			GUICtrlSetState($7f, 128)
			GUICtrlSetState($7e, 128)
			GUICtrlSetState($7i, 64)
		Case $78 = $7b
			$6z = 0
			GUICtrlSetState($7b, 32)
			GUICtrlSetState($7c, 16)
			_11i(0)
			GUICtrlSetState($7f, 128)
			GUICtrlSetState($7h, 128)
			GUICtrlSetState($79, 128)
			GUICtrlSetState($7e, 128)
			GUICtrlSetState($7d, 128)
			GUICtrlSetState($7i, 128)
			_iu($7a)
			_ma($79, BitOR(32, 1, 65536))
			_ig($79, "", 0)
			_ig($79, "", 1)
			_ig($79, "", 2)
			_ig($79, "", 2)
			_ly($79)
			_ln($79, -1, 1, "", 1)
			_mb($79, 1, "Info", 1, 8)
			_ih($79, 0, "", 1)
			_ih($79, 1, "Preparing...", 1)
			_ih($79, 2, "", 1)
			_ih($79, 3, "Be patient, please.", 1)
			_mr($79, 0, 1)
			_mr($79, 1, 1)
			_mr($79, 2, 1)
			_mr($79, 3, 1)
			_11y()
			_mb($79, 1, "Info", 1, 8)
			$70 = $71
			$72 = $71
			$7k = TimerInit()
			Local $89
			Local $8a = DirGetSize($7p, 1)
			If UBound($8a) >= 2 Then
				$89 = $8a[1]
				$84 = 100 / $89
				$85 = 0
				_11l(0)
				_11d($7p, 0, $89)
				Sleep(100)
				_11l(0)
			EndIf
			If $7p = "C:\Program Files" OR $7p = "C:\Program Files\Adobe" Then
				Local $8b = EnvGet("ProgramFiles(x86)") & "\Common Files\Adobe"
				$8a = DirGetSize($8b, 1)
				If UBound($8a) >= 2 Then
					$89 = $8a[1]
					_11d($8b, 0, $89)
					_11l(0)
				EndIf
			EndIf
			_11f()
			If _k5($79) > 0 Then
				_11w()
				$7g = 1
				GUICtrlSetState($7b, 128)
				GUICtrlSetState($7f, 128)
				GUICtrlSetState($7e, 64)
				GUICtrlSetState($7e, 256)
				If UBound($72) > 0 Then
					GUICtrlSetState($7h, 32)
					GUICtrlSetState($7m, 64)
					GUICtrlSetState($7m, 16)
				EndIf
			Else
				$7g = 0
				_11e()
				GUICtrlSetState($7e, 128)
				GUICtrlSetState($7f, 128)
				GUICtrlSetState($7b, 64)
				GUICtrlSetState($7b, 256)
			EndIf
			_11y()
			GUICtrlSetState($7f, 64)
			GUICtrlSetState($7h, 64)
			GUICtrlSetState($79, 64)
			GUICtrlSetState($7d, 64)
			GUICtrlSetState($7b, 16)
			GUICtrlSetState($7c, 32)
			GUICtrlSetState($7i, 64)
		Case $78 = $7d
			_11i(0)
			_11m()
			_11y()
			If $73 = 0 Then
				GUICtrlSetState($7e, 128)
				GUICtrlSetState($7f, 128)
				GUICtrlSetState($7b, 64)
				GUICtrlSetState($7b, 256)
			Else
				GUICtrlSetState($7b, 128)
				GUICtrlSetState($7f, 64)
				GUICtrlSetState($7e, 64)
				GUICtrlSetState($7e, 256)
			EndIf
		Case $78 = $7f
			_11i(0)
			If $7g = 1 Then
				For $n = 0 To _k5($79) - 1
					_ml($79, $n, 0)
				Next
				$7g = 0
			Else
				For $n = 0 To _k5($79) - 1
					_ml($79, $n, 1)
				Next
				$7g = 1
			EndIf
		Case $78 = $7h
			_11i(0)
			_11t()
		Case $78 = $7i
			Global $8c
			Global $8d
			Global $8e
			_11i(0)
			GUICtrlSetState($77, 16)
			GUICtrlSetState($7f, 128)
			GUICtrlSetState($7h, 128)
			GUICtrlSetState($79, 128)
			GUICtrlSetState($7d, 128)
			GUICtrlSetState($7b, 128)
			GUICtrlSetState($7i, 128)
			If FileExists("C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll") Then
				$8c = "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll"
			Else
				$8c = FileOpenDialog("Select a File", @ScriptDir, "AppsPanelBL.dll (AppsPanelBL.dll)")
			EndIf
			_11l(0)
			If FileExists($8c) Then
				_11o($8c)
				Sleep(100)
				_11g(@CRLF & "File Path:" & @CRLF & "" & @CRLF & $8c & @CRLF & "" & @CRLF & "")
				Sleep(100)
				_11r($8c, $7t)
				Sleep(500)
			EndIf
			_11l(0)
			If $7z = False Then
				If FileExists("C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\ADS\ContainerBL.dll") Then
					$8d = "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\ADS\ContainerBL.dll"
				Else
					$8d = FileOpenDialog("Select a File", @ScriptDir, "ContainerBL.dll (ContainerBL.dll)")
				EndIf
				_11l(0)
				If FileExists($8d) Then
					_11o($8d)
					Sleep(100)
					_11g(@CRLF & "File Path:" & @CRLF & "" & @CRLF & $8d & @CRLF & "" & @CRLF & "")
					Sleep(100)
					_11r($8d, $7t)
					Sleep(500)
				EndIf
				_11l(0)
				If FileExists("C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe") Then
					$8e = "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe"
				Else
					$8e = FileOpenDialog("Select a File", @ScriptDir, "Adobe Desktop Service.exe (Adobe Desktop Service.exe)")
				EndIf
				If FileExists($8e) Then
					_11o($8e)
					Sleep(100)
					_11g(@CRLF & "File Path:" & @CRLF & "" & @CRLF & $8e & @CRLF & "" & @CRLF & "")
					Sleep(100)
					_11r($8e, $7t)
					Sleep(500)
				EndIf
				_11l(0)
				_11g(@CRLF & "All files patched." & @CRLF & "" & @CRLF & "")
			Else
				_11l(0)
				_11g(@CRLF & "Creative Cloud patching aborted due to unsupported architecture." & @CRLF & "" & @CRLF & "")
				$7z = False
			EndIf
			GUICtrlSetState($7f, 64)
			GUICtrlSetState($7h, 64)
			GUICtrlSetState($79, 64)
			GUICtrlSetState($7d, 64)
			GUICtrlSetState($7b, 64)
			GUICtrlSetState($7i, 64)
		Case $78 = $7e
			_11i(0)
			GUICtrlSetState($79, 128)
			GUICtrlSetState($7f, 128)
			GUICtrlSetState($7b, 128)
			GUICtrlSetState($7e, 128)
			GUICtrlSetState($7h, 128)
			GUICtrlSetState($7m, 128)
			GUICtrlSetState($7d, 128)
			GUICtrlSetState($7i, 128)
			_11y()
			_j4($79, 0, 0)
			Local $8f
			For $n = 0 To _k5($79) - 1
				If _k4($79, $n) = True Then
					_my($79, $n)
					$8f = _kq($79, $n, 1)
					_11o($8f)
					_11l(0)
					Sleep(100)
					_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $8f & @CRLF & "---" & @CRLF & "medication :)")
					_11h(1, $8f)
					Sleep(100)
					_11r($8f, $7t)
					_m1($79, 0, 10)
					_j4($79, $n, 0)
					Sleep(100)
				EndIf
				_ml($79, $n, False)
			Next
			_iu($7a)
			_ma($79, BitOR(32, 1, 65536))
			_ly($79)
			_ln($79, -1, 1, "", 1)
			_mb($79, 1, "Info", 1, 8)
			_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7p & @CRLF & "---" & @CRLF & "waiting for user action")
			GUICtrlSetState($79, 64)
			GUICtrlSetState($7b, 64)
			GUICtrlSetState($7d, 64)
			GUICtrlSetState($7h, 64)
			GUICtrlSetState($7h, 16)
			GUICtrlSetState($7m, 32)
			GUICtrlSetState($7e, 128)
			GUICtrlSetState($7b, 256)
			GUICtrlSetState($7i, 64)
			_11e()
			If $7x = True Then
				MsgBox(4096, "Information", "GenP does not patch the x86 version of Acrobat. Please use the x64 version of Acrobat.")
				_11h(1, "GenP does not patch the x86 version of Acrobat. Please use the x64 version of Acrobat.")
			EndIf
			If $7y = True Then
				MsgBox(4096, "Information", "GenP does not patch the ARM version of Lightroom. Please use the x64 version of Lightroom.")
				_11h(1, "GenP does not patch the ARM version of Lightroom. Please use the x64 version of Lightroom.")
			EndIf
			If $80 = True Then
				MsgBox(4096, "Information", "GenP does not patch the ARM version of Photoshop. Please use the x64 version of Photoshop.")
				_11h(1, "GenP does not patch the ARM version of Photoshop. Please use the x64 version of Photoshop.")
			EndIf
			If $81 = True Then
				MsgBox(4096, "Information", "GenP cannot patch files with ARM architecture.")
				_11h(1, "GenP cannot patch files with ARM architecture.")
			EndIf
			_11i(1)
			GUICtrlSetState($77, 16)
		Case $78 = $7m
			GUICtrlSetData($7l, "Activity Log" & @CRLF)
			_11i(0)
			GUICtrlSetState($79, 128)
			GUICtrlSetState($7f, 128)
			GUICtrlSetState($7b, 128)
			GUICtrlSetState($7e, 128)
			GUICtrlSetState($7h, 128)
			GUICtrlSetState($7m, 128)
			GUICtrlSetState($7d, 128)
			GUICtrlSetState($7i, 128)
			_11y()
			_j4($79, 0, 0)
			Local $8f, $8g, $8h
			For $n = 0 To _k5($79) - 1
				If _k4($79, $n) = True Then
					_my($79, $n)
					$8f = _kq($79, $n, 1)
					$8g = _l0($79)
					$8h = 100 / $8g
					_11l(0)
					_11s($8f)
					_11l($8h)
					Sleep(100)
					_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $8f & @CRLF & "---" & @CRLF & "restoring :)")
					Sleep(100)
					_m1($79, 0, 10)
					_j4($79, $n, 0)
					Sleep(100)
				EndIf
				_ml($79, $n, False)
			Next
			_iu($7a)
			_ma($79, BitOR(32, 1, 65536))
			_ly($79)
			_ln($79, -1, 1, "", 1)
			_mb($79, 1, "Info", 1, 8)
			_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7p & @CRLF & "---" & @CRLF & "waiting for user action")
			GUICtrlSetState($79, 64)
			GUICtrlSetState($7d, 64)
			GUICtrlSetState($7h, 64)
			GUICtrlSetState($7h, 16)
			GUICtrlSetState($7m, 32)
			GUICtrlSetState($7m, 64)
			GUICtrlSetState($7e, 128)
			GUICtrlSetState($7b, 64)
			GUICtrlSetState($7b, 256)
			GUICtrlSetState($7i, 64)
			_11e()
			_11i(1)
		Case $78 = $7n
			_11j()
	EndSelect
WEnd

Func _11c()
	$74 = GUICreate($6w, 595, 710, -1, -1, BitOR(65536, 131072, 262144, $4))
	$75 = GUICtrlCreateTab(0, 1, 597, 710)
	$76 = GUICtrlCreateTabItem("Main")
	$79 = GUICtrlCreateListView("", 10, 35, 575, 555)
	GUICtrlSetResizing(-1, 1)
	$7a = GUICtrlGetHandle($79)
	_ma($79, BitOR(32, 1, 65536, 4))
	$8i = _3w($74, $2x)
	_xz($74, $2x, BitXOR($8i, 262144, 131072, 65536))
	_mm($79, UBound($70))
	_if($79, "", 20)
	_if($79, "", 532, 2)
	_j2($79)
	_ln($79, -1, 1, "", 1)
	_mb($79, 1, "Info", 1, 8)
	_11e()
	$7d = GUICtrlCreateButton("Path", 10, 630, 80, 30)
	GUICtrlSetTip(-1, "Select Path that You want -> press Search -> press Patch button")
	GUICtrlSetImage(-1, "imageres.dll", -4, 0)
	GUICtrlSetResizing(-1, 1)
	$7b = GUICtrlCreateButton("Search", 110, 630, 80, 30)
	GUICtrlSetTip(-1, "Let GenP find Apps automatically in current path")
	GUICtrlSetImage(-1, "imageres.dll", -8, 0)
	GUICtrlSetResizing(-1, 1)
	$7c = GUICtrlCreateButton("Stop", 110, 630, 80, 30)
	GUICtrlSetState(-1, 32)
	GUICtrlSetTip(-1, "Stop searching for Apps")
	GUICtrlSetImage(-1, "imageres.dll", -8, 0)
	GUICtrlSetResizing(-1, 1)
	$7f = GUICtrlCreateButton("De/Select", 210, 630, 80, 30)
	GUICtrlSetState(-1, 128)
	GUICtrlSetTip(-1, "De/Select All files")
	GUICtrlSetImage(-1, "imageres.dll", -76, 0)
	GUICtrlSetResizing(-1, 1)
	$7e = GUICtrlCreateButton("Patch", 305, 630, 80, 30)
	GUICtrlSetState(-1, 128)
	GUICtrlSetTip(-1, "Patch all selected files")
	GUICtrlSetImage(-1, "imageres.dll", -102, 0)
	GUICtrlSetResizing(-1, 1)
	$7h = GUICtrlCreateButton("Pop-up", 405, 630, 80, 30)
	GUICtrlSetTip(-1, "Block Unlicensed Pop-up via Windows Firewall")
	GUICtrlSetImage(-1, "imageres.dll", -101, 0)
	GUICtrlSetResizing(-1, 1)
	$7m = GUICtrlCreateButton("Restore", 405, 630, 80, 30)
	GUICtrlSetState(-1, 32)
	GUICtrlSetTip(-1, "Restore Original Files")
	GUICtrlSetImage(-1, "imageres.dll", -113, 0)
	GUICtrlSetResizing(-1, 1)
	$7i = GUICtrlCreateButton("Patch CC", 505, 630, 80, 30)
	GUICtrlSetImage(-1, "imageres.dll", -74, 0)
	GUICtrlSetTip(-1, "Patch Creative Cloud")
	GUICtrlSetResizing(-1, 1)
	$7s = GUICtrlCreateProgress(10, 597, 575, 25, 16)
	GUICtrlSetResizing(-1, 128)
	GUICtrlCreateLabel($6x, 10, 677, 575, 25, 1)
	GUICtrlSetResizing(-1, 64)
	GUICtrlCreateTabItem("")
	$77 = GUICtrlCreateTabItem("Log")
	$7j = GUICtrlCreateEdit("", 10, 35, 575, 555, BitOR(2048, 1, 134217728))
	GUICtrlSetResizing(-1, 128)
	$7l = GUICtrlCreateEdit("", 10, 35, 575, 555, BitOR(2097152, 64, 2048))
	GUICtrlSetResizing(-1, 128)
	GUICtrlSetState($7l, 32)
	GUICtrlSetData($7l, "Activity Log" & @CRLF)
	$7n = GUICtrlCreateButton("Copy", 257, 630, 80, 30)
	GUICtrlSetTip(-1, "Copy log to the clipboard")
	GUICtrlSetImage(-1, "imageres.dll", -77, 0)
	GUICtrlSetResizing(-1, 1)
	GUICtrlCreateLabel($6x, 10, 677, 575, 25, 1)
	GUICtrlSetResizing(-1, 64)
	GUICtrlCreateTabItem("")
	_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7p & @CRLF & "---" & @CRLF & "Waiting for user action.")
	GUICtrlSetState($7b, 256)
	GUISetState(@SW_SHOW)
	GUIRegisterMsg($1, "_120")
EndFunc

Func _11d($8j, $8k, $89)
	_n1($79, 1, "Searching for files.", 1)
	Local $8l = 6
	If $8k > $8l Then Return 
	Local $8m = $8j & "\"
	$85 += 1
	Local $8n = FileFindFirstFile($8m & "*.*")
	If @error Then Return 
	Local $8o, $8p, $8q
	While $6z = 0
		$8o = FileFindNextFile($8n)
		$85 += 1
		If @error Then ExitLoop
		$8q = StringInStr(FileGetAttrib($8m & $8o), "D")
		If $8q Then
			Local $8r
			$8r = _11d($8m & $8o, $8k + 1, $89)
		Else
			$8p = $8m & $8o
			Local $8s
			If (IsArray($87)) Then
				For $8t In $87
					$8s = StringSplit(StringLower($8p), StringLower($8t), 1)
					If @error <> 1 Then
						If NOT StringInStr($8p, ".bak") Then
							If StringInStr($8p, "Adobe") OR StringInStr($8p, "Acrobat") OR StringInStr($8p, "Maxon") Then
								_c($70, $8p)
							EndIf
						Else
							_c($72, $8p)
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	WEnd
	If 1 = Random(0, 10, 1) Then
		_11g(@CRLF & "Searching in " & $89 & " files" & @TAB & @TAB & "Found : " & UBound($70) & @CRLF & "---" & @CRLF & "Level: " & $8k & " Time elapsed : " & Round(TimerDiff($7k) / 1000, 0) & " second(s)" & @TAB & @TAB & "Excluded because of *.bak: " & UBound($72) & @CRLF & "---" & @CRLF & $8j)
		_11l($84 * $85)
	EndIf
	FileClose($8n)
EndFunc

Func _11e()
	_iu($7a)
	_ma($79, BitOR(32, 1, 65536))
	_11y()
	_mb($79, 1, "Info", 1, 8)
	For $n = 0 To 28
		_ig($79, "", $n)
		_mr($79, $n, 1)
	Next
	_ih($79, 0, "", 1)
	_ih($79, 1, "To patch all Adobe apps in default location:", 1)
	_ih($79, 2, "Press 'Search Files' - Press 'Patch Files'", 1)
	_ih($79, 3, "Default path - C:\Program Files", 1)
	_ih($79, 4, "-------------------------------------------------------------", 1)
	_ih($79, 5, "To patch Creative Cloud (CC), press 'Patch CC'", 1)
	_ih($79, 6, "-------------------------------------------------------------", 1)
	_ih($79, 7, "After searching, some products may already be patched.", 1)
	_ih($79, 8, "To select\deselect products to patch, LEFT CLICK on the product group", 1)
	_ih($79, 9, "To select\deselect individual files, RIGHT CLICK on the file", 1)
	_ih($79, 10, "-------------------------------------------------------------", 1)
	_ih($79, 11, "What's new in GenP:", 1)
	_ih($79, 12, "Can patch apps from 2019 version to current and future releases", 1)
	_ih($79, 13, "Automatic search and patch in selected folder", 1)
	_ih($79, 14, "New patching logic. 'Unlicensed Pop-up' Blocker", 1)
	_ih($79, 15, "Support for all Substance products", 1)
	_ih($79, 16, "-------------------------------------------------------------", 1)
	_ih($79, 17, "Known issues:", 1)
	_ih($79, 18, "Animate will have some problems with home screen if Signed Out", 1)
	_ih($79, 19, "XD, Lightroom Classic will partially work if Signed Out", 1)
	_ih($79, 20, "Premiere Rush, Lightroom Online, Photoshop Express", 1)
	_ih($79, 21, "Won't be fully unlocked", 1)
	_ih($79, 22, "-------------------------------------------------------------", 1)
	_ih($79, 23, "Some Apps demand Creative Cloud App and mandatory SignIn", 1)
	_ih($79, 24, "Fresco, Aero, Lightroom Online, Premiere Rush, Photoshop Express", 1)
	_ih($79, 25, "-------------------------------------------------------------", 1)
	_ih($79, 26, "Cinema 4D will remain in Lite mode if it's already been launched. Clear the 'AppData'", 1)
	_ih($79, 27, "directories, including 'Roaming' and 'Local' of folders mentioning Maxon or Cinema 4D.", 1)
	_ih($79, 28, "v2024.2.0 and below are supported. Redshift Renderer will automatically be disabled.", 1)
	$73 = 0
EndFunc

Func _11f()
	_iu($7a)
	_ma($79, BitOR(32, 1, 65536, 4))
	If UBound($70) > 0 Then
		Global $4u[UBound($70)][2]
		For $n = 0 To UBound($4u) - 1
			$4u[$n][0] = $n
			$4u[$n][1] = $70[$n][0]
		Next
		_ie($79, $4u)
		_11g(@CRLF & UBound($70) & " File(s) were found in " & Round(TimerDiff($7k) / 1000, 0) & " second(s) at:" & @CRLF & "---" & @CRLF & $7p & @CRLF & "---" & @CRLF & "Press the 'Patch Files'")
		_11h(1, UBound($70) & " File(s) were found in " & Round(TimerDiff($7k) / 1000, 0) & " second(s)" & @CRLF)
		$73 = 1
	Else
		_11g(@CRLF & "Nothing was found in" & @CRLF & "---" & @CRLF & $7p & @CRLF & "---" & @CRLF & "waiting for user action")
		_11h(1, "Nothing was found in " & $7p)
		$73 = 0
	EndIf
EndFunc

Func _11g($8u)
	GUICtrlSetData($7j, $8u)
EndFunc

Func _11h($8v, $8u)
	_11k($7l, $8u, $8v)
EndFunc

Func _11i($8w)
	If $8w = 1 Then
		GUICtrlSetState($7j, 32)
		GUICtrlSetState($7l, 16)
	Else
		GUICtrlSetState($7l, 32)
		GUICtrlSetState($7j, 16)
	EndIf
EndFunc

Func _11j()
	If BitAND(GUICtrlGetState($7j), 32) = 32 Then
		ClipPut(GUICtrlRead($7l))
	Else
		ClipPut(GUICtrlRead($7j))
	EndIf
EndFunc

Func _11k($23, $4z, $8v)
	If NOT IsHWnd($23) Then $23 = GUICtrlGetHandle($23)
	Local $2t = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $23, "uint", 14, "wparam", 0, "lparam", 0)
	DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $23, "uint", 177, "wparam", $2t[0], "lparam", $2t[0])
	If $8v = 1 Then
		Local $8x = @CRLF & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " " & $4z
	Else
		Local $8x = $4z
	EndIf
	DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $23, "uint", 194, "wparam", True, "wstr", $8x)
EndFunc

Func _11l($8y)
	GUICtrlSetData($7s, $8y)
EndFunc

Func _11m()
	Local Const $8u = "Select a Path"
	FileSetAttrib("C:\Program Files\WindowsApps", "-H")
	Local $8z = FileSelectFolder($8u, $7p, 0, $7p, $74)
	If @error Then
		FileSetAttrib("C:\Program Files\WindowsApps", "+H")
		_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7p & @CRLF & "---" & @CRLF & "waiting for user action")
	Else
		GUICtrlSetState($7e, 128)
		$7p = $8z
		IniWrite($7o, "Default", "Path", $7p)
		_iu($7a)
		_ma($79, BitOR(1, 32, 2))
		_ig($79, "", 0)
		_ig($79, "", 1)
		_ig($79, "", 2)
		_ig($79, "", 3)
		_ig($79, "", 4)
		_ig($79, "", 5)
		_ig($79, "", 6)
		_ih($79, 0, "", 1)
		_ih($79, 1, "Path:", 1)
		_ih($79, 2, " " & $7p, 1)
		_ih($79, 3, "Step 1:", 1)
		_ih($79, 4, " Press 'Search Files' - wait until GenP finds all files", 1)
		_ih($79, 5, "Step 2:", 1)
		_ih($79, 6, " Press 'Patch Files' - wait until GenP will do it's job", 1)
		_mr($79, 0, 1)
		_mr($79, 1, 1)
		_mr($79, 2, 1)
		_mr($79, 3, 1)
		_mr($79, 4, 1)
		_mr($79, 5, 1)
		_mr($79, 6, 1)
		_mb($79, 1, "Info", 1, 8)
		FileSetAttrib("C:\Program Files\WindowsApps", "+H")
		_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7p & @CRLF & "---" & @CRLF & "Press the Search button")
		GUICtrlSetState($7h, 16)
		GUICtrlSetState($7m, 32)
		$73 = 0
	EndIf
EndFunc

Func _11n($1d)
	Local $2f = Run("TASKKILL /F /T /IM " & $1d, @TempDir, @SW_HIDE)
	ProcessWaitClose($2f)
EndFunc

Func _11o($90)
	$7v = $7u
	$7t = $7u
	_11l(0)
	$7q = 0
	$7r = 15
	Local $91 = StringRegExpReplace($90, "^.*\\", "")
	Local $92 = StringRegExpReplace($91, "^.*\.", "")
	_11g(@CRLF & $90 & @CRLF & "---" & @CRLF & "Preparing to Analyze" & @CRLF & "---" & @CRLF & "*****")
	_11h(1, "Checking File: " & $91 & " ")
	If $92 = "exe" Then
		_11n('"' & $91 & '"')
	EndIf
	If $91 = "AppsPanelBL.dll" OR $91 = "ContainerBL.dll" OR $91 = "Adobe Desktop Service.exe" Then
		_11n('"Creative Cloud.exe"')
		_11n('"Adobe Desktop Service.exe"')
		Sleep(100)
	EndIf
	If $91 = "c4d_base.xdl64" OR $91 = "gui.module.xdl64" OR $91 = "redshift4c4d.xdl64" Then
		_11n('"Cinema 4D.exe"')
		Sleep(100)
	EndIf
	If StringInStr($83, $91) Then
		_11h(0, " - using Custom Patterns")
		_11p($91, 0, $90)
	Else
		_11h(0, " - using Default Patterns")
		_11p($91, 1, $90)
	EndIf
	Sleep(100)
EndFunc

Func _11p($93, $94, $90)
	Local $95, $96, $97, $d, $98, $99, $9a
	If $94 = 0 Then
		$95 = _121($7o, "CustomPatterns", $93, "")
	Else
		$95 = _121($7o, "DefaultPatterns", "Values", "")
	EndIf
	For $n = 0 To UBound($95) - 1
		$96 = $95[$n]
		$97 = IniRead($7o, "Patches", $96, "")
		If StringInStr($97, "|") Then
			$d = StringSplit($97, "|")
			If UBound($d) = 3 Then
				$98 = StringReplace($d[1], '"', "")
				$99 = StringReplace($d[2], '"', "")
				$9a = StringLen($98)
				If $9a <> StringLen($99) OR Mod($9a, 2) <> 0 Then
					MsgBox(4096, "Error", "Pattern Error in config.ini:" & $96 & @CRLF & $98 & @CRLF & $99)
					Exit
				EndIf
				_11h(1, "Searching for: " & $96 & ": " & $98)
				_11q($90, $98, $99, $96)
			EndIf
		EndIf
	Next
EndFunc

Func _11q($9b, $9c, $9d, $9e)
	Local $9f = FileOpen($9b, 0 + 16)
	FileSetPos($9f, 60, 0)
	$7w = FileRead($9f, 4)
	FileSetPos($9f, Number($7w) + 4, 0)
	$7w = FileRead($9f, 2)
	If $7w = "0x4C01" AND StringInStr($9b, "Acrobat", 2) > 0 Then
		_11g(@CRLF & $9b & @CRLF & "---" & @CRLF & "File is 32bit. Aborting..." & @CRLF & "---")
		FileClose($9f)
		Sleep(100)
		$7x = True
	ElseIf $7w = "0x64AA" Then
		If StringInStr($9b, "Lightroom", 2) > 0 Then
			_11g(@CRLF & $9b & @CRLF & "---" & @CRLF & "Acrobat is ARM. Aborting..." & @CRLF & "---")
			FileClose($9f)
			Sleep(100)
			$7y = True
		ElseIf StringInStr($9b, "AppsPanelBL.dll", 2) OR StringInStr($9b, "ContainerlBL.dll", 2) OR StringInStr($9b, "Adobe Desktop Service", 2) > 0 Then
			_11g(@CRLF & $9b & @CRLF & "---" & @CRLF & "Creative Cloud is ARM. Aborting..." & @CRLF & "---")
			FileClose($9f)
			Sleep(100)
			$7z = True
		ElseIf StringInStr($9b, "Photoshop", 2) > 0 Then
			_11g(@CRLF & $9b & @CRLF & "---" & @CRLF & "Photoshop is ARM. Aborting..." & @CRLF & "---")
			FileClose($9f)
			Sleep(100)
			$80 = True
		Else
			_11g(@CRLF & $9b & @CRLF & "---" & @CRLF & "File is ARM. Aborting..." & @CRLF & "---")
			FileClose($9f)
			Sleep(100)
			$81 = True
		EndIf
	Else
		FileSetPos($9f, 0, 0)
		Local $9g = FileRead($9f)
		Local $9h, $9i, $9j
		For $n = 256 To 1 Step -2
			$9h = _r7("??", $n / 2)
			$9i = "(.{" & $n & "})"
			$9j = StringReplace($9c, $9h, $9i)
			$9c = $9j
		Next
		Local $9k = $9j
		Local $9l = $9d
		Local $9m = "", $9n = "", $9o = ""
		Local $9p[0]
		Local $9q = "", $9r = ""
		$9p = $7u
		$9p = StringRegExp($9g, $9k, 4, 1)
		For $n = 0 To UBound($9p) - 1
			$7v = $7u
			$9q = ""
			$9r = ""
			$9m = ""
			$9n = ""
			$9o = ""
			$7v = $9p[$n]
			If @error = 0 Then
				$9m = $7v[0]
				$9n = $9l
				If StringInStr($9n, "?") Then
					For $u = 1 To StringLen($9n) + 1
						$9q = StringMid($9m, $u, 1)
						$9r = StringMid($9n, $u, 1)
						If $9r <> "?" Then
							$9o &= $9r
						Else
							$9o &= $9q
						EndIf
					Next
				Else
					$9o = $9n
				EndIf
				_c($7t, $9m)
				_c($7t, $9o)
				ConsoleWrite($9e & "---" & @TAB & $9m & "	" & @CRLF)
				ConsoleWrite($9e & "R" & "--" & @TAB & $9o & "	" & @CRLF)
				_11g(@CRLF & $9b & @CRLF & "---" & @CRLF & $9e & @CRLF & "---" & @CRLF & $9m & @CRLF & $9o)
				_11h(1, "Replacing with: " & $9o)
			Else
				ConsoleWrite($9e & "---" & @TAB & "No" & "	" & @CRLF)
				_11g(@CRLF & $9b & @CRLF & "---" & @CRLF & $9e & "---" & "No")
			EndIf
			$7q += 1
		Next
		FileClose($9f)
		$9g = ""
		_11l(Round($7q / $7r * 100))
		Sleep(100)
	EndIf
EndFunc

Func _11r($9s, $9t)
	_11l(0)
	Local $9u = UBound($9t)
	If $9u > 0 Then
		_11g(@CRLF & "Path" & @CRLF & "---" & @CRLF & $9s & @CRLF & "---" & @CRLF & "medication :)")
		Local $9f = FileOpen($9s, 0 + 16)
		Local $9g = FileRead($9f)
		Local $9v
		For $n = 0 To $9u - 1 Step 2
			$9v = StringReplace($9g, $9t[$n], $9t[$n + 1], 0, 1)
			$9g = $9v
			$9v = $9g
			_11l(Round($n / $9u * 100))
		Next
		FileClose($9f)
		FileMove($9s, $9s & ".bak", 1)
		Local $9w = FileOpen($9s, 2 + 16)
		FileWrite($9w, Binary($9v))
		FileClose($9w)
		_11l(0)
		Sleep(100)
		_11h(1, "File patched." & @CRLF)
	Else
		_11g(@CRLF & "No patterns were found" & @CRLF & "---" & @CRLF & "or" & @CRLF & "---" & @CRLF & "file is already patched.")
		Sleep(100)
		_11h(1, "No patterns were found or file already patched." & @CRLF)
	EndIf
EndFunc

Func _11s($9x)
	If FileExists($9x & ".bak") Then
		FileDelete($9x)
		FileMove($9x & ".bak", $9x, 1)
		Sleep(100)
		_11g(@CRLF & "File restored" & @CRLF & "---" & @CRLF & $9x)
		_11h(1, $9x)
		_11h(1, "File restored.")
	Else
		Sleep(100)
		_11g(@CRLF & "No backup file found" & @CRLF & "---" & @CRLF & $9x)
		_11h(1, $9x)
		_11h(1, "No backup file found.")
	EndIf
EndFunc

Func _11t()
	GUICtrlSetState($77, 16)
	GUICtrlSetState($7h, 128)
	_11g(@CRLF & "Checking for an active internet connection..." & @CRLF & "" & @CRLF & "")
	Local $9y = '"C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe" -Command "Test-Connection 8.8.8.8 -Count 1 -Quiet"'
	Local $2f = Run($9y, "", @SW_HIDE, BitOR(4, 2))
	Local $9z = ""
	While 1
		$9z &= StdoutRead($2f)
		If @error Then ExitLoop
	WEnd
	ProcessWaitClose($2f)
	If StringReplace($9z, @CRLF, "") = "True" Then
		_11g(@CRLF & "Resolving ip-addresses..." & @CRLF & "" & @CRLF & "")
		$9y = """C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe"" -Command ""$currentDate=Get-Date;$ipAddresses=@();try{$SOA=(Resolve-DnsName -Name adobe.io -Type SOA -ErrorAction Stop).PrimaryServer}catch{$SOA=$null};if($SOA){Do{if((New-TimeSpan -Start $currentDate -End (Get-Date)).TotalSeconds -gt 5){if($ipAddresses.Count -eq 0){$ipAddresses+='False'};break};try{$ipAddress=(Resolve-DnsName -Name adobe.io -Server $SOA -ErrorAction Stop).IPAddress}catch{$ipAddress=$null};if($ipAddress){$ipAddresses+=$ipAddress};$ipAddresses=$ipAddresses|Select -Unique|Sort-Object}While($ipAddresses.Count -lt 8)}else{$ipAddresses+='False'};Do{if((New-TimeSpan -Start $currentDate -End (Get-Date)).TotalSeconds -gt 5 -or $ipAddresses[0] -eq 'False'){break};try{$ipAddress=(Resolve-DnsName -Name 3u6k9as4bj.adobestats.io -ErrorAction Stop).IPAddress}catch{$ipAddress=$null};if($ipAddress){$ipAddresses+=$ipAddress};$ipAddresses=$ipAddresses|Select -Unique|Sort-Object}While($ipAddresses.Count -lt 12 -and $ipAddresses[0] -ne 'False');$ipAddresses=$ipAddresses -ne 'False'|Select -Unique|Sort-Object;$ipAddressList=if($ipAddresses.Count -eq 0){'False'}else{$ipAddresses -join ','};$ipAddressList"""
		$2f = Run($9y, "", @SW_HIDE, BitOR(4, 2))
		$9z = ""
		While 1
			$9z &= StdoutRead($2f)
			If @error Then ExitLoop
		WEnd
		ProcessWaitClose($2f)
		If StringInStr($9z, "False") Then
			_11g(@CRLF & "Failed to resolve ip-addresses, try using a VPN..." & @CRLF & "" & @CRLF & "")
			Sleep(2000)
		Else
			_11g(@CRLF & "Adding Windows Firewall rule..." & @CRLF & "" & @CRLF & "")
			$9y = 'netsh advfirewall firewall delete rule name="Adobe Unlicensed Pop-up"'
			$2f = Run($9y, "", @SW_HIDE, BitOR(4, 2))
			ProcessWaitClose($2f)
			$9y = 'netsh advfirewall firewall add rule name="Adobe Unlicensed Pop-up" dir=out action=block remoteip="' & StringReplace($9z, @CRLF, "") & '"'
			$2f = Run($9y, "", @SW_HIDE, BitOR(4, 2))
			ProcessWaitClose($2f)
		EndIf
		_11g(@CRLF & "Blocking hosts..." & @CRLF & "" & @CRLF & "")
		$9y = "C:\Windows\system32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -Command ""if(-not([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){Write-Host 'Script execution failed...';exit};$hostsPath='C:\Windows\System32\drivers\etc\hosts';$webContent=(Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/ignaciocastro/adobe-is-dumb/main/list.txt' -UseBasicParsing).Split($([char]0x0A))|ForEach-Object{ $_.Trim()};$currentHostsContent=Get-Content -Path $hostsPath;$startMarker='#region Adobe URL Blacklist';$endMarker='#endregion';$blockStart=$currentHostsContent.IndexOf($startMarker);$blockEnd=$currentHostsContent.IndexOf($endMarker);if($blockStart -ne -1 -and $blockEnd -ne -1){$currentHostsContent=$currentHostsContent[0..($blockStart-1)]+$currentHostsContent[($blockEnd+1)..$currentHostsContent.Length]};$newBlock=@($startMarker)+$webContent+$endMarker;$newHostsContent=$currentHostsContent+$newBlock;Set-Content -Path $hostsPath -Value $newHostsContent;Write-Host 'Script execution complete.';exit"""
		$2f = Run($9y, "", @SW_HIDE, 2)
		$9z = ""
		While 1
			$a0 = StdoutRead($2f)
			If @error Then ExitLoop
			$9z &= $a0
		WEnd
		If StringInStr($9z, "Script execution complete.") Then
			_11g(@CRLF & "All hosts blocked." & @CRLF & "" & @CRLF & "")
		Else
			_11g(@CRLF & "Failed to block hosts, try using a VPN..." & @CRLF & "" & @CRLF & "")
		EndIf
	Else
		_11g(@CRLF & "You are not connected to the internet..." & @CRLF & "" & @CRLF & "")
		GUICtrlSetState($7h, 64)
	EndIf
EndFunc

Func _11u($a1, $2m)
	Local $a2 = DllStructCreate($1w, $2m)
	Local $2y = DllStructGetData($a2, "Index")
	If $2y <> -1 Then
		Local $5h = DllStructGetData($a2, "X")
		Local $a3 = _ki($a1, $2y, 1)
		If $5h < $a3[0] AND $5h >= 5 Then
			Return 0
		Else
			Local $a4
			$a4 = _lj($7a)
			If $a4[0] <> -1 Then
				Local $a5 = _ka($79, $a4[0])
				If _k4($7a, $a4[0]) = 1 Then
					For $n = 0 To _k5($79) - 1
						If _ka($79, $n) = $a5 Then
							_ml($7a, $n, 0)
						EndIf
					Next
				Else
					For $n = 0 To _k5($79) - 1
						If _ka($79, $n) = $a5 Then
							_ml($7a, $n, 1)
						EndIf
					Next
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc

Func _11v()
	Local $a4
	$a4 = _lj($7a)
	If $a4[0] <> -1 Then
		If _k4($7a, $a4[0]) = 1 Then
			_ml($7a, $a4[0], 0)
		Else
			_ml($7a, $a4[0], 1)
		EndIf
	EndIf
EndFunc

Func _11w()
	Local $a6 = _k5($79)
	Local $8f
	For $n = 0 To $a6 - 1
		_ml($79, $n)
		$8f = _kq($79, $n, 1)
		Select 
			Case StringInStr($8f, "Acrobat")
				_ln($79, $n, 1, "", 1)
				_mr($79, $n, 1)
				_mb($79, 1, "Acrobat", 1, 8)
			Case StringInStr($8f, "Aero")
				_ln($79, $n, 2, "", 1)
				_mr($79, $n, 2)
				_mb($79, 2, "Aero", 1, 8)
			Case StringInStr($8f, "After Effects")
				_ln($79, $n, 3, "", 1)
				_mr($79, $n, 3)
				_mb($79, 3, "After Effects", 1, 8)
			Case StringInStr($8f, "Animate")
				_ln($79, $n, 4, "", 1)
				_mr($79, $n, 4)
				_mb($79, 4, "Animate", 1, 8)
			Case StringInStr($8f, "Audition")
				_ln($79, $n, 5, "", 1)
				_mr($79, $n, 5)
				_mb($79, 5, "Audition", 1, 8)
			Case StringInStr($8f, "Adobe Bridge")
				_ln($79, $n, 6, "", 1)
				_mr($79, $n, 6)
				_mb($79, 6, "Bridge", 1, 8)
			Case StringInStr($8f, "Character Animator")
				_ln($79, $n, 7, "", 1)
				_mr($79, $n, 7)
				_mb($79, 7, "Character Animator", 1, 8)
			Case StringInStr($8f, "Dimension")
				_ln($79, $n, 9, "", 1)
				_mr($79, $n, 9)
				_mb($79, 9, "Dimension", 1, 8)
			Case StringInStr($8f, "Dreamweaver")
				_ln($79, $n, 10, "", 1)
				_mr($79, $n, 10)
				_mb($79, 10, "Dreamweaver", 1, 8)
			Case StringInStr($8f, "Illustrator")
				_ln($79, $n, 11, "", 1)
				_mr($79, $n, 11)
				_mb($79, 11, "Illustrator", 1, 8)
			Case StringInStr($8f, "InCopy")
				_ln($79, $n, 12, "", 1)
				_mr($79, $n, 12)
				_mb($79, 12, "InCopy", 1, 8)
			Case StringInStr($8f, "InDesign")
				_ln($79, $n, 13, "", 1)
				_mr($79, $n, 13)
				_mb($79, 13, "InDesign", 1, 8)
			Case StringInStr($8f, "Lightroom CC")
				_ln($79, $n, 14, "", 1)
				_mr($79, $n, 14)
				_mb($79, 14, "Lightroom CC", 1, 8)
			Case StringInStr($8f, "Lightroom Classic")
				_ln($79, $n, 15, "", 1)
				_mr($79, $n, 15)
				_mb($79, 15, "Lightroom Classic", 1, 8)
			Case StringInStr($8f, "Media Encoder")
				_ln($79, $n, 16, "", 1)
				_mr($79, $n, 16)
				_mb($79, 16, "Media Encoder", 1, 8)
			Case StringInStr($8f, "Photoshop")
				_ln($79, $n, 17, "", 1)
				_mr($79, $n, 17)
				_mb($79, 17, "Photoshop", 1, 8)
			Case StringInStr($8f, "Premiere Pro")
				_ln($79, $n, 18, "", 1)
				_mr($79, $n, 18)
				_mb($79, 18, "Premiere Pro", 1, 8)
			Case StringInStr($8f, "Premiere Rush")
				_ln($79, $n, 19, "", 1)
				_mr($79, $n, 19)
				_mb($79, 19, "Premiere Rush", 1, 8)
			Case StringInStr($8f, "Substance 3D Designer")
				_ln($79, $n, 20, "", 1)
				_mr($79, $n, 20)
				_mb($79, 20, "Substance 3D Designer", 1, 8)
			Case StringInStr($8f, "Substance 3D Modeler")
				_ln($79, $n, 21, "", 1)
				_mr($79, $n, 21)
				_mb($79, 21, "Substance 3D Modeler", 1, 8)
			Case StringInStr($8f, "Substance 3D Painter")
				_ln($79, $n, 22, "", 1)
				_mr($79, $n, 22)
				_mb($79, 22, "Substance 3D Painter", 1, 8)
			Case StringInStr($8f, "Substance 3D Sampler")
				_ln($79, $n, 23, "", 1)
				_mr($79, $n, 23)
				_mb($79, 23, "Substance 3D Sampler", 1, 8)
			Case StringInStr($8f, "Substance 3D Stager")
				_ln($79, $n, 24, "", 1)
				_mr($79, $n, 24)
				_mb($79, 24, "Substance 3D Stager", 1, 8)
			Case StringInStr($8f, "Adobe.Fresco")
				_ln($79, $n, 25, "", 1)
				_mr($79, $n, 25)
				_mb($79, 25, "Fresco", 1, 8)
			Case StringInStr($8f, "Adobe.XD")
				_ln($79, $n, 26, "", 1)
				_mr($79, $n, 26)
				_mb($79, 26, "XD", 1, 8)
			Case StringInStr($8f, "PhotoshopExpress")
				_ln($79, $n, 27, "", 1)
				_mr($79, $n, 27)
				_mb($79, 27, "PhotoshopExpress", 1, 8)
			Case StringInStr($8f, "Maxon Cinema 4D")
				_ln($79, $n, 28, "", 1)
				_mr($79, $n, 28)
				_mb($79, 28, "Maxon Cinema 4D", 1, 8)
			Case Else
				_ln($79, $n, 29, "", 1)
				_mr($79, $n, 29)
				_mb($79, 29, "Miscellaneous", 1, 8)
		EndSelect
	Next
EndFunc

Func _11x()
	Local $a7, $a8 = _jn($79)
	If $a8 > 0 Then
		If $6y = 1 Then
			For $n = 1 To 28
				$a7 = _jo($79, $n)
				_mb($79, $n, $a7[0], $a7[1], 1)
			Next
		Else
			_11y()
		EndIf
		$6y = NOT $6y
	EndIf
EndFunc

Func _11y()
	Local $a7, $a8 = _jn($79)
	If $a8 > 0 Then
		For $n = 1 To 28
			$a7 = _jo($79, $n)
			_mb($79, $n, $a7[0], $a7[1], 0)
			_mb($79, $n, $a7[0], $a7[1], 8)
		Next
	EndIf
EndFunc

Func _11z($23, $a9, $2l, $2m)
	If BitAND($2l, 65535) = $7c Then $6z = 1
	Return "GUI_RUNDEFMSG"
EndFunc

Func _120($23, $2k, $2l, $2m)
	#forceref $23, $2k, $2l, $2m
	Local $aa = DllStructCreate($1t, $2m)
	Local $ab = HWnd(DllStructGetData($aa, "hWndFrom"))
	Local $ac = DllStructGetData($aa, "Code")
	Switch $ab
		Case $7a
			Switch $ac
				Case $4m
					_11x()
				Case $2
					_11u($7a, $2m)
				Case $3
					_11v()
			EndSwitch
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc

Func _121($93, $ad, $ae, $af)
	Local $ag = IniRead($93, $ad, $ae, $af)
	$ag = StringReplace($ag, '"', "")
	StringReplace($ag, ",", ",")
	Local $8a = @extended
	Local $ah[$8a + 1]
	Local $ai = StringSplit($ag, ",")
	For $n = 0 To $8a
		$ah[$n] = $ai[$n + 1]
	Next
	Return $ah
EndFunc
