Function Pilih_Buku(Optional ByVal LokasiBerkas As String)
    'Fungsi ini agar pengguna dapat membuka buku excel yang ada dalam lokasi berkas
    
    If LokasiBerkas = "" Then LokasiBerkas = ThisWorkbook.Path
    Dim BukuYangDibuka As String: ChDir LokasiBerkas
    BukuYangDibuka = Application.GetOpenFilename(Title:="Pilih nama buku yang ingin dibuka", _
    FileFilter:="Excel Files .xls (.xls),")
    
    If BukuYangDibuka = "False" Then
        MsgBox "Tidak ada buku yang dibuka.", vbExclamation, "Tidak ada!": Exit Function
    Else: Workbooks.Open Filename:=BukuYangDibuka
    End If

End Function

Function TarikKePojokKiriAtas(ByVal KataKunci As String)
'Fungsi ini bertujuan untuk menarik lokasi kata kunci dan seluruh sisanya ke kiri atas.
    If CariKata(KataKunci) Then
        Application.ScreenUpdating = False
        BarisAtas = ActiveCell.Row: KolomKiri = ActiveCell.Column
        Do Until KolomKiri = 1
            Columns(1).Delete
            CariKata KataKunci: BarisAtas = ActiveCell.Row: KolomKiri = ActiveCell.Column
        Loop
        Do Until BarisAtas = 1
            Rows(1).Delete
            CariKata KataKunci: BarisAtas = ActiveCell.Row: KolomKiri = ActiveCell.Column
        Loop
        Application.ScreenUpdating = True
    End If
End Function

Function SalinIsiLembarAktifKeBukuBaru()
'Fungsi ini bertujuan untuk menyalin isi seluruh sel (value-only) ke buku/excel baru.
'Fungsi akan mengembalikan nama buku yang baru terbentuk dalam bentuk string.
    LembarBukuAktif = ActiveWorkbook.Name
    Workbooks.Add: TungguSiap: NamaBukuBaru = ActiveWorkbook.Name
    Windows(LembarBukuAktif).Activate: Cells.Select: Selection.Copy: TungguSiap
    Windows(NamaBukuBaru).Activate
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False: TungguSiap
    SalinIsiLembarAktifKeBukuBaru = NamaBukuBaru
End Function

Function HitungMundur(ByVal DurasiDetik As Integer, Optional ByVal NamaProses As String)
'Fungsi ini ditujukan untuk menghitung mundur dan menuliskannya pada statusbar Excel.
    NamaProses = NamaProses & " ": i = DurasiDetik: TungguBentar 0.5
    Do Until i = 0: StatusExcel "Proses " & NamaProses & "akan dimulai pada " & i
        TungguBentar 1: i = i - 1: Loop
    StatusExcel "Proses " & NamaProses & "akan dimulai pada " & 0: TungguBentar 1
    Application.StatusBar = ""
End Function 

Function StatusExcel(ByVal Pesan As String)
'Fungsi ini bertujuan untuk menulis pada statusbar Excel
    Application.DisplayStatusBar = True: Application.StatusBar = Pesan
End Function

Function HapusLembar(ByVal NamaLembar As String, ByVal NamaBuku As String)
'Menghapus setiap lembar dengan nama yang sama seperti NamaLembar pada buku yang ditunjuk.
    For Each Sheet In Workbooks(NamaBuku).Sheets
        If Sheet.Name = NamaLembar Then
            Application.DisplayAlerts = False: Sheet.Delete: Application.DisplayAlerts = True
        End If
    Next Sheet
End Function

Function SalinLembarAktif(ByVal BukuAsal As String, ByVal BukuSalin As String)
    Windows(BukuAsal).Activate: ActiveSheet.Copy Before:=Workbooks(BukuSalin).Sheets(1)
End Function

Function MatikanSeluruhRumus(ByVal NamaBukuKerja As String, ByVal NamaLembar As String)
    Workbooks(NamaBukuKerja).Activate
    If Sheets(NamaLembar).Visible = 0 Or Sheets(NamaLembar).Visible = 2 Then Exit Function
    Sheets(NamaLembar).Select: Cells.Select: Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Range("A1").Select: Application.CutCopyMode = False
End Function

Function Bicara(ByVal ApaYangMauDikatakan As String)
    Application.Speech.Speak ApaYangMauDikatakan
End Function

Function PeriksaEnkripsi()
    Dim BukuIni As Workbook: Set BukuIni = ActiveWorkbook
    With BukuIni
        Debug.Print .PasswordEncryptionAlgorithm: Debug.Print .PasswordEncryptionFileProperties
        Debug.Print .PasswordEncryptionKeyLength: Debug.Print .PasswordEncryptionProvider
    End With
End Function 

Function SiapkanPenyaruBuku()
    ActiveWorkbook.SetPasswordEncryptionOptions _
    PasswordEncryptionProvider:="Microsoft RSA SChannel Cryptographic Provider", PasswordEncryptionAlgorithm:="RC4", _
    PasswordEncryptionKeyLength:=4096, PasswordEncryptionFileProperties:=True
End Function 

Function TutupBuku(ByVal NamaBuku As String)
    If NamaBuku = "" Then Exit Function
    On Error GoTo Keluar
    Application.DisplayAlerts = False: Workbooks(NamaBuku).Close: Application.DisplayAlerts = True
Keluar:
End Function

Function Simpan(ByVal LokasiSimpan As String, ByVal NamaBuku As String, ByVal Sandi As String)
    Application.DisplayAlerts = False
    ChDir LokasiSimpan: SiapkanPenyaruBuku
    ActiveWorkbook.SaveAs Filename:=LokasiSimpan & "\" & NamaBuku, FileFormat:=xlOpenXMLWorkbook, CreateBackup:=False, _
        Password:=Sandi
    Application.DisplayAlerts = True
End Function

Function Buka(ByVal LokasiBuku As String, ByVal NamaBuku As String, Optional ByVal Sandi as String)
    If InStr(NamaBuku, ".xls") = 0 Then Exit Function
    On Error GoTo Keluar
    For Each Workbook In Workbooks
        Application.DisplayAlerts = False: If Workbook.Name = NamaBuku Then Workbook.Close: Application.DisplayAlerts = True
    Next: Workbooks.Open LokasiBuku & "\" & NamaBuku, UpdateLinks:=0, Password:= Sandi
Keluar:
End Function

Function SalinBaris(ByVal BarisBerapa As Integer, ByVal BerapaBanyak As Integer)
    BerapaBanyak = BerapaBanyak - 1: Rows(BarisBerapa & ":" & BarisBerapa).Copy
    Rows(BarisBerapa & ":" & (BerapaBanyak + BarisBerapa)).Insert Shift:=xlDown: Application.CutCopyMode = False
End Function

Function ApakahBarisKosong(ByVal BarisBerapa As Integer, Optional ByVal BerapaKolomYgMauDiCek As Integer)
    If BerapaKolomYgMauDiCek = 0 Then BerapaKolomYgMauDiCek = 20
    i = 1: ApakahBarisKosong = True
    Do Until i = BerapaKolomYgMauDiCek + 1
        If Cells(BarisBerapa, i).Value <> vbNullString Then
            ApakahBarisKosong = False: Exit Function
        End If
    i = i + 1: Loop
End Function

Function CariKata(ByVal ApaYangDicari As String) As Boolean 'Dicari per lembar
    CariKata = False: On Error GoTo Keluar
    
CobaLagi:
    
    Cells.Find(What:=ApaYangDicari, After:=ActiveCell, LookIn:=xlFormulas, _
        LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
        MatchCase:=False, SearchFormat:=False).Activate
    CariKata = True
    If ActiveCell.Rows.Hidden Or ActiveCell.Columns.Hidden Then
        CariKata = False: GoTo CobaLagi
    End If
    
    'Kecualikan jika lokasi sel diluar area cetak
    'AreaCetak = ActiveSheet.PageSetup.PrintArea: Set Perpotongan = Application.Intersect(ActiveCell, Range(AreaCetak))
    'If Perpotongan Is Nothing Then CariKata = False
        
Keluar: Err.Clear: On Error GoTo 0
End Function

Function CariKataDalamRentang(ByVal ApaYangDicari As String, ByVal RentangPencarian As String)
    xCariKata = False: On Error GoTo Keluar
    
    CobaLagi:
    Range(RentangPencarian).Select
    Selection.Find(What:=ApaYangDicari, After:=ActiveCell, LookIn:=xlFormulas, _
        LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
        MatchCase:=False, SearchFormat:=False).Activate
    xCariKata = True
    If ActiveCell.Rows.Hidden Or ActiveCell.Columns.Hidden Then
        xCariKata = False: GoTo CobaLagi
    End If
    CariKataDalamRentang = xCariKata & "|" & ActiveCell.Row & "|" & ActiveCell.Column & "|" & ActiveCell.Value
    'Kecualikan jika lokasi sel diluar area cetak
    'AreaCetak = ActiveSheet.PageSetup.PrintArea: Set Perpotongan = Application.Intersect(ActiveCell, Range(AreaCetak))
    'If Perpotongan Is Nothing Then CariKata = False
        
    Keluar:
    CariKataDalamRentang = False
    Err.Clear: On Error GoTo 0
End Function

Function AmbilIsiKolom(ByVal NamaBukuKerja As String, ByVal NamaLembarSistem As String, _
    ByVal LokasiKolom As Integer, ByVal MulaiDariBarisBerapa As Long) As Variant
    
    On Error Resume Next
    i = MulaiDariBarisBerapa: Do Until Workbooks(NamaBukuKerja).Sheets(NamaLembarSistem).Cells(i, LokasiKolom).Value = ""
        If i = MulaiDariBarisBerapa Then: UrutanData = Workbooks(NamaBukuKerja).Sheets(NamaLembarSistem).Cells(i, LokasiKolom).Value: _
            Else: UrutanData = UrutanData & "|" & _
            Workbooks(NamaBukuKerja).Sheets(NamaLembarSistem).Cells(i, LokasiKolom).Value
    i = i + 1: Loop
    Err.Clear: On Error GoTo 0: 'Debug.Print UrutanData
    UrutanData = Split(UrutanData, "|"): AmbilIsiKolom = UrutanData
    
End Function

Function AmbilIsiBaris(ByVal LokasiBaris As Integer, ByVal MulaiDariKolomBerapa As Integer, ByVal SampaiKolomBerapa As Integer) As Variant
    On Error Resume Next
    i = MulaiDariKolomBerapa: Do Until Cells(LokasiBaris, i).Column = SampaiKolomBerapa + 1
        If Not Columns(i).Hidden Then
            If i = MulaiDariKolomBerapa Then: UrutanData = Cells(LokasiBaris, i).Value: _
                Else: UrutanData = UrutanData & "|" & Cells(LokasiBaris, i).Value
        End If
    i = i + 1: Loop
    Err.Clear: On Error GoTo 0
    'Debug.Print UrutanData
    UrutanData = Split(UrutanData, "|"): AmbilIsiBaris = UrutanData
End Function

Function AmbilTabel(ByVal TitikMulai As String, ByVal KataKunci As String, ByVal NamaLembar As String)
    
    Sheets(NamaLembar).Select: ToleransiKekosongan = 10
    Range(TitikMulai).Select: LokasiBarisAwal = ActiveCell.Row: LokasiBaris = ActiveCell.Row
    LokasiKolomAwal = ActiveCell.Column: LokasiKolom = ActiveCell.Column
    
    KolomTerakhirLembar = ActiveSheet.UsedRange.Columns.Count: 'Debug.Print KolomTerakhirLembar
    
    KetemuKataKunciSelanjutnya = False
    Do Until KetemuKataKunciSelanjutnya
        i1 = LokasiKolomAwal: x1 = 0: Do Until i1 = KolomTerakhirLembar
            If Not Columns(i1).Hidden Then
                If Cells(LokasiBaris, i1).Value <> "" Then x1 = i1
            End If
            i1 = i1 + 1: Loop: If x1 > KolomTerpakaiAkhir Then KolomTerpakaiAkhir = x1 Else x1 = 0
        i = i + 1: LokasiBaris = LokasiBaris + 1
        If InStr(UCase(Cells(LokasiBaris, LokasiKolom).Value), KataKunci) > 0 Then
            KetemuKataKunciSelanjutnya = True: LokasiBarisTerakhir = LokasiBaris - 2: Exit Do
        End If
        If Not Rows(LokasiBaris).Hidden And Cells(LokasiBaris, LokasiKolom).Value = vbNullString And _
            ApakahBarisKosong(LokasiBaris, KolomTerakhirLembar) Then x = x + 1 Else x = 0
        If x = ToleransiKekosongan Then LokasiBarisTerakhir = LokasiBaris - ToleransiKekosongan: Exit Do
    Loop: 'Debug.Print KolomTerpakaiAkhir & "|" & (LokasiBarisTerakhir - LokasiBarisAwal)
    
    JumlahData = (LokasiBarisTerakhir - LokasiBarisAwal): ReDim Data(JumlahData)
    i1 = 0: For i = LokasiBarisAwal To LokasiBarisTerakhir
        If Not Rows(i).Hidden Then
            Data(i1) = AmbilIsiBaris(i, LokasiKolomAwal, KolomTerpakaiAkhir)
            i1 = i1 + 1: End If: Next: i1 = i1 - 1
    ReDim Preserve Data(i1): AmbilTabel = Data
    
    'For i = 0 To UBound(Data): For j = 0 To UBound(Data(i)): If Isi = "" Then Isi = Data(i)(j) Else Isi = Isi & "|" & Data(i)(j)
    'Next: Debug.Print Isi: Isi = vbNullString: Next
    
End Function

Function AmbilLokasiKunci(ByVal KataKunci As String) As Variant

    CariKunci = True: Range("A1").Select: On Error Resume Next
    If Not CariKata(KataKunci) Then
        AmbilLokasiKunci = "Tidak ada kata kunci": Exit Function
    Else: Range("A1").Select
    End If
    
    x = 0: Do While CariKunci
        CariKata (KataKunci)
        If InStr(LokasiDitemukan, ActiveCell.Address) > 0 Then
            CariKunci = False: Exit Do
        Else
            If x = 0 Then LokasiDitemukan = ActiveCell.Address & ":" & ActiveCell.Value Else _
                LokasiDitemukan = LokasiDitemukan & "||" & ActiveCell.Address & ":" & ActiveCell.Value
        End If: x = x + 1
    Loop: Range("A1").Select: Data = x & ">>" & LokasiDitemukan: Err.Clear: On Error GoTo 0 ':Debug.Print Data
    Data = Split(Data, ">>"): AmbilLokasiKunci = Data
    
End Function
