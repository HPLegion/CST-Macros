' CSTExportTrajectories

Const FilePath = GetProjectPath("Root") + "\TrajectoryExport\"' + "ascii_export.csv"
Const SeparatorChar = ";"
Const CommentChar = "% "



Const SaveSourceNames = True
Const SaveParticleConstants = True
Const SaveParticleTrajectories = True


Sub Main
    Dim FileName As String
    Dim nTrajectories As Long
    Dim n As Long
    Dim SourceIDs() As Long
    Dim Line As String

	'If necessary create folder
	If Len(Dir(FilePath, vbDirectory)) = 0 Then
   		MkDir FilePath
	End If

    'Load Data
    ParticleTrajectoryReader.Reset()
	ParticleTrajectoryReader.LoadTrajectoryData()

    ' Create Source ID File
    If SaveSourceNames Then

        'Get Source IDs
	    SourceIDs = ParticleTrajectoryReader.GetSourceIDs()

        'Open File
        FileName = "source_names.txt"
        Open (FilePath + FileName) For Output As #1

        'Write Header
        Print #1, CommentChar; "sourceID"; SeparatorChar; "sourceName"

        'Write Content
        For Each id In SourceIDs
		    Print #1, CStr(id); SeparatorChar; ParticleTrajectoryReader.GetSourceName(id)
	    Next

        'Close File
        Print #1, "EOF";
        Close #1
    End If

    ' Create File containing time-invariant particle Info
    If SaveParticleConstants Then

        'Get number of trajectories
        nTrajectories = ParticleTrajectoryReader.GetNTrajectories()

        'Open File
        FileName = "particle_constants.txt"
        Open (FilePath + FileName) For Output As #1

        'Write Header
        Print #1, CommentChar;
        Print #1, "particleID"; SeparatorChar;
        Print #1, "mass(kg)"; SeparatorChar;
        Print #1, "macroCharge(C)"; SeparatorChar;
        Print #1, "sourceID";
        Print #1

        'Write Content
        Dim sID() As Single
        Dim mass() As Single
        Dim macroCharge() As Single

        For n = 0 To nTrajectories-1
            ParticleTrajectoryReader.SelectTrajectory(n)
            sID = ParticleTrajectoryReader.GetQuantityValues("EmissionID","")
            mass = ParticleTrajectoryReader.GetQuantityValues("Mass","")
            macroCharge = ParticleTrajectoryReader.GetQuantityValues("ChargeMacro","")
            ' Print #1, n; SeparatorChar;
            ' Print #1, mass(0); SeparatorChar;
            ' Print #1, macroCharge(0); SeparatorChar;
            ' Print #1, CLng(sID(0)); SeparatorChar;
            ' Print #1
            Line = CStr(n) + SeparatorChar + CStr(mass(0)) + SeparatorChar + CStr(macroCharge(0)) + SeparatorChar + CStr(CLng(sID(0)))
            Print #1, Line
        Next

        'Close File
        Print #1, "EOF";
        Close #1
    End If

    ' Create File containing Trajectory Information
    If SaveParticleTrajectories Then

        'Get number of trajectories
        nTrajectories = ParticleTrajectoryReader.GetNTrajectories()

        'Open File
        FileName = "particle_trajectories.txt"
        Open (FilePath + FileName) For Output As #1

        'Write Header
        Print #1, CommentChar;
        Print #1, "particleID"; SeparatorChar;
        Print #1, "Time"; SeparatorChar;
        Print #1, "x"; SeparatorChar; "y"; SeparatorChar; "z"; SeparatorChar;
        Print #1, "px(normed)"; SeparatorChar; "py(normed)"; SeparatorChar; "pz(normed)";
        Print #1

        'Write Content
        Dim t() As Single
        Dim x() As Single
        Dim y() As Single
        Dim z() As Single
        Dim px() As Single
        Dim py() As Single
        Dim pz() As Single
        Dim Steps As Long

        For n = 0 To nTrajectories-1
            ParticleTrajectoryReader.SelectTrajectory(n)

            t = ParticleTrajectoryReader.GetQuantityValues("Time","")
            x = ParticleTrajectoryReader.GetPositionsX()
            y = ParticleTrajectoryReader.GetPositionsY()
            z = ParticleTrajectoryReader.GetPositionsZ()
            px = ParticleTrajectoryReader.GetMomentaX()
            py = ParticleTrajectoryReader.GetMomentaY()
            pz = ParticleTrajectoryReader.GetMomentaZ()

            Steps = ParticleTrajectoryReader.GetNParticles() 'Weird way to test number of timesteps
            For s = 0 To Steps - 1
                ' Print #1, n; SeparatorChar;
                ' Print #1, t(s); SeparatorChar;
                ' Print #1, x(s); SeparatorChar;
                ' Print #1, y(s); SeparatorChar;
                ' Print #1, z(s); SeparatorChar;
                ' Print #1, px(s); SeparatorChar;
                ' Print #1, py(s); SeparatorChar;
                ' Print #1, pz(s); SeparatorChar;
                ' Print #1
                Line = CStr(n) + SeparatorChar + CStr(t(s)) + SeparatorChar + CStr(x(s)) + SeparatorChar + CStr(y(s)) + SeparatorChar + CStr(z(s)) + SeparatorChar + CStr(px(s)) + SeparatorChar + CStr(py(s)) + SeparatorChar + CStr(pz(s))
                Print #1, Line
            Next

        Next

        'Close File
        Print #1, "EOF";
        Close #1
    End If

End Sub
