AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->80];

(* ADJUST YOUR DIRECTORY SETTINGS HERE! *)
SetDirectory[$HomeDirectory <> "/work/projects/ipsolver"]

<< SDP`
<< SDPSylvester`

SolveProblem[fileName_, solution_, stream_, results_] := Module[
  {
    maxTimeSDP = 1800, (* Seconds allowed to finish SDP *)
    time1 = 0, time2 = 0, (* Used for timing *)
    out, (* output from SDPSolve calls *)
    Id, Ze
  },

  WriteString[stream, "Running... ", fileName, "\n"];
  
  (* Load problem file *)
  Get[fileName];

  WriteString[stream, \
              (nx*(nx+1))/2+(nz*(nz+1))/2+nx*nu, " variables. W is ", nz, \
              "x", nz, ", L is ", nu, "x", nx, ", X is ", nx, "x", nx, "\n"];

  (* Setup Leibfritz H_2 problem *)

  Id[n_] := IdentityMatrix[n] // N;
  Ze[m_, n_] := ConstantArray[0, {m, n}] // N;

  C1X = ArrayFlatten[{{C1}, {Ze[nx, nx]}}];
  IdX = ArrayFlatten[{{Ze[nz, nx]}, {Id[nx]}}];
  D12L = ArrayFlatten[{{D12}, {Ze[nx, nu]}}];
  IdW = ArrayFlatten[{{Id[nz]}, {Ze[nx, nz]}}];

  AA = {
     (* A X + B L + 0 W < -B1 B1^T *)
     {
       {2 A, Id[nx]}, 
       {2 B, Id[nx]}, 
       {Ze[nx, nz], Ze[nz, nx]}
     },
     (* -[W, C1 X + L D12; X C1^T + D12^T L^T X] < 0 *)
     {
       {ArrayFlatten[{{-IdX, -2 C1X}}],
        ArrayFlatten[{{Transpose[IdX], Transpose[IdX]}}]},
       {-2 D12L, Transpose[IdX]}, 
       {- IdW, Transpose[IdW]}
     }
   };
  CC = {-B1.Transpose[B1], Ze[nx + nz, nx + nz]};
  BB = {Ze[nx, nx], Ze[nu, nx], -Id[nz]};

  (* Run the algorithm *)

  WriteString[stream, "Starting SDP Solver...\n"];

  time1 = TimeUsed[];

  out = TimeConstrained[
          SDPSolve[{AA, BB, CC}, 
                   SymmetricVariables -> {1, 3}, 
                   DebugLevel -> 0],
          maxTimeSDP 
        ];

  time2 = TimeUsed[];

  WriteString[stream, "Done.\n"];

  If [ out === $Aborted, 

     Print["Can't optimize in ", maxTimeSDP, " seconds."];
     WriteString[stream, "Can't optimize in ", maxTimeSDP, \
                 " seconds.\n\n\n"];

     status = "TIMEOUT";

    ,

     status = "SUCCESS";

  ];

  (* Write results *)
  PutAppend[{fileName, DateString[], status, time2-time1,
             $MachineName, $MachineType, $ProcessorType}, results];

  (* Write solution *)
  Put[out, solution];

  Return[];

];

(* Extract problem to run from input line *)

problemCode = ToFileName["COMPleib", $CommandLine[[2]]];
solutionFileName = ToFileName["COMPleib", $CommandLine[[3]]];
outputFileName = ToFileName["COMPleib", $CommandLine[[4]]];
resultsFileName = ToFileName["COMPleib", $CommandLine[[5]]];

outputStream = If[ FileExistsQ[outputFileName], 
                   OpenAppend[outputFileName], 
                   OpenWrite[outputFileName] ];
SetOptions[outputStream, FormatType -> StandardForm];

SolveProblem[ problemCode <> ".m", solutionFileName, 
              outputStream, resultsFileName ];

Close[outputStream];

$Echo = DeleteCases[$Echo, "stdout"];
