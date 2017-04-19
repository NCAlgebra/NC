BeginPackage["Unzip`",{"JLink`"}]

  Clear[CopyRemote, Unzip, URLFileByteSize];

  CopyRemote::usage = "CopyRemote[url, localfilename] copies a file from an http location to localfilename.";
  Unzip::usage = "Unzip[file] unzips file.";
  URLFileByteSize::usage = "gives the remote file size in Byte."

  Begin["`Private`"]

  InstallJava[];

  Options[Unzip] = {Verbose -> True};

  Unzip[zipfilein_String?FileExistsQ, 
        dir_: Directory[], 
        OptionsPattern[]] :=
    JavaBlock[
    Module[ 
        {enum, saveEntry, startdir, zf, buf, zipfile, comments, targets, target, len, dirs},
        zipfile = If[ DirectoryName[zipfilein] === "",
                      FileNameJoin[{Directory[],zipfilein}],
                      zipfilein
                  ];
        buf = JavaNew["[B", 10000]; (* ] *)
        If[ startdir =!= dir,
            If[ !DirectoryQ[dir],
                mkdirs[dir]
            ];
            SetDirectory[dir]
        ];
        saveEntry[zipfi_, zipentry_] :=
            JavaBlock[
             Block[ {bos, fi, fos, numRead, stream, outStream, fromcharcode, topdirle},
                 fi = zipentry[getName[]];
                 If[ zipentry[isDirectory[]],
                     mkdirs[FileNameJoin[{dir, fi}]],
                     stream = JavaNew["java.io.BufferedInputStream", 
                       zipfi[getInputStream[zipentry]]];
                     outStream = 
                      JavaNew["java.io.BufferedOutputStream", 
                       JavaNew["java.io.FileOutputStream", FileNameJoin[{dir, fi}]]];
                     While[(numRead = stream[read[buf]]) > 0, outStream[write[buf, 0, numRead]]];
                     stream[close[]];
                     outStream[close[]];
                 ]
             ]];
        zf = JavaNew["java.util.zip.ZipFile", zipfile];
        len = zf[size[]];
        enum = zf[entries[]];
        comments = OptionValue[Verbose] /. Options[Unzip];
        targets = Table[enum[nextElement[]],{len}];
        dirs = Function[x, If[ !DirectoryQ[x],
                               CreateDirectory[x, CreateIntermediateDirectories -> True]
                           ]] /@ (Union[DirectoryName[#[getName[]]]& /@ targets]/."":>Sequence[]);
        Do[
               If[ comments,
                   Print[StringJoin["extracting: ", FileNameJoin[{dir, StringReplace[target[getName[]], "/" -> $PathnameSeparator]}]]]
               ];
               saveEntry[zf, target],
           {target, targets}
        ];
        zf @ close[];
        dir
    ]];

    (* You need JLink 2.0 or higher.
       this code is based on the GetRemote example in the JLink
       documentation *)

    Options[CopyRemote] = {ProxyHost :> None, ProxyPort :> None};

    CopyRemote[url_String /; StringMatchQ[url, "http*://*.*", IgnoreCase-> True],
               localfile_:Automatic, opts___?OptionQ] :=
    (
      Needs["JLink`"];
      JLink`JavaBlock[
          Module[ {u, stream, numRead, outFile, buf, prxyHost, prxyPort},
              {prxyHost, prxyPort} = {ProxyHost, ProxyPort} /.
              Flatten[{opts}] /. Options[CopyRemote];
              JLink`InstallJava[];
              If[ StringQ[prxyHost],
                  (* Set properties to force use of proxy. *)
                  JLink`SetInternetProxy[prxyHost, prxyPort]
              ];
              u = JLink`JavaNew["java.net.URL", url];
              (* This is where the error will show up if the URL is not valid.
                 A Java exception will be thrown during openStream, which
                 causes the method to return $Failed.
              *)
              stream = u@openStream[];
              If[ stream === $Failed,
                  Return[$Failed]
              ];
              buf = JLink`JavaNew["[B", 5000];
              (* 5000 is an arbitrary buffer size *)
              If[ StringQ[localfile],
                  outFile = OpenWrite[localfile, DOSTextFormat -> False],
                  outFile = OpenTemporary[DOSTextFormat->False];
              ];
              While[(numRead = stream@read[buf]) > 0,
               WriteString[outFile, FromCharacterCode[If[ # < 0,
                                                          #+256,
                                                          #
                                                      ]& /@ Take[JLink`Val[buf], numRead]]]
              ];
              stream@close[];
              Close[outFile]
          (* Close returns the filename *)
          ]
      ] );

    URLFileByteSize[link_String] :=
      Module[ 
          {url, urlcon, len},
          url = JavaNew["java.net.URL", link];
          urlcon = url@openConnection[];
          len = urlcon@getContentLength[];
          urlcon@getInputStream[]@close[];
          len
      ];

End[]

EndPackage[]
