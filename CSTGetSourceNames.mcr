' Prints the names and ids of all sources in one file for identification

Sub Main ()
	Dim ids() As Long
	ParticleTrajectoryReader.LoadTrajectoryData
	ids = ParticleTrajectoryReader.GetSourceIDs()
	Open "source_names.txt" For Output As #1
	For Each id In ids
		Print #1, id; " = "; ParticleTrajectoryReader.GetSourceName(id)
	Next
	Close #1
End Sub

