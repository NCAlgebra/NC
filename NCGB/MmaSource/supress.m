supressOutput := 
   (MoraAlg`ChangeNCMakeGBOptions[ReturnRelations,True];
    MoraAlg`ChangeNCMakeGBOptions[SupressCOutput,True];);
supressAllOutput := 
   (MoraAlg`ChangeNCMakeGBOptions[ReturnRelations,True];
    MoraAlg`ChangeNCMakeGBOptions[SupressCOutput,True];
    MoraAlg`ChangeNCMakeGBOptions[SupressAllCOutput,True];);
supressRelations := 
   (MoraAlg`ChangeNCMakeGBOptions[ReturnRelations,False];
    MoraAlg`ChangeNCMakeGBOptions[SupressCOutput,False];);
supressAll := 
   (MoraAlg`ChangeNCMakeGBOptions[ReturnRelations,False];
    MoraAlg`ChangeNCMakeGBOptions[SupressAllCOutput,False];
    MoraAlg`ChangeNCMakeGBOptions[SupressCOutput,True];);
supressNone := 
   (MoraAlg`ChangeNCMakeGBOptions[ReturnRelations,True];
    MoraAlg`ChangeNCMakeGBOptions[SupressCOutput,False];);

supressNone;
