* THIS FILE LOADS KODNET FOR .NET FRAMEWORK v4.5 OR SUPERIOR
try 
    do (getenv("Userprofile") + "\kwruntime\kodnet\loader.prg")
    _screen.kodnetLoader.load("v4")

    messagebox("Kodnet Loaded")

catch to ex 
    messagebox("Failed load kodnet: " + ex.message, 48, "Kodnet Load Failed")
endtry 