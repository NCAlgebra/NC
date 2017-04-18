## NCTest {#PackageNCTest}

Members are:

* [NCTest](#NCTest)
* [NCTestCheck](#NCTestCheck)
* [NCTestRun](#NCTestRun)
* [NCTestSummarize](#NCTestSummarize)

### NCTest {#NCTest}

`NCTest[expr,answer]` asserts whether `expr` is equal to `answer`. The result of the test is collected when `NCTest` is run from `NCTestRun`.

See also:
[NCTestCheck](#NCTestCheck),
[NCTestRun](#NCTestRun), 
[NCTestSummarize](#NCTestSummarize).

### NCTestCheck {#NCTestCheck}

`NCTestCheck[expr,messages]` evaluates `expr` and asserts that the messages in `messages` have been issued. The result of the test is collected when `NCTest` is run from `NCTestRun`.

`NCTestCheck[expr,answer,messages]` also asserts whether `expr` is equal to `answer`.

`NCTestCheck[expr,answer,messages,quiet]` quiets messages in `quiet`.

See also:
[NCTest](#NCTest),
[NCTestRun](#NCTestRun),
[NCTestSummarize](#NCTestSummarize).

### NCTestRun {#NCTestRun}

`NCTest[list]` runs the test files listed in `list` after appending
the '.NCTest' suffix and return the results.

For example:

    results = NCTestRun[{"NCCollect", "NCSylvester"}]
	
will run the test files "NCCollec.NCTest" and "NCSylvester.NCTest" and return the results in `results`.

See also:
[NCTest](#NCTest), 
[NCTestCheck](#NCTestCheck), 
[NCTestSummarize](#NCTestSummarize).


### NCTestSummarize {#NCTestSummarize}

`NCTestSummarize[results]` will print a summary of the results in `results` as produced by `NCTestRun`.

See also:
[NCTestRun](#NCTestRun).
