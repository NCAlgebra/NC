# NCTest {#PackageNCTest}

Members are:

* [NCTest](#NCTest)
* [NCTestRun](#NCTestRun)
* [NCTestSummarize](#NCTestSummarize)

## NCTest {#NCTest}

`NCTest[expr,answer]` asserts whether `expr` is equal to `answer`. The result of the test is collected when `NCTest` is run from `NCTestRun`.

See also:
[#NCTestRun](#NCTestRun), [#NCTestSummarize](#NCTestSummarize)


## NCTestRun {#NCTestRun}

`NCTest[list]` runs the test files listed in `list` after appending
the '.NCTest' suffix and return the results.

For example:

    results = NCTestRun[{"NCCollect", "NCSylvester"}]
	
will run the test files "NCCollec.NCTest" and "NCSylvester.NCTest" and return the results in `results`.

See also:
[#NCTest](#NCTest), [#NCTestSummarize](#NCTestSummarize)


## NCTestSummarize {#NCTestSummarize}

`NCTestSummarize[results]` will print a summary of the results in `results` as produced by `NCTestRun`.

See also:
[#NCTestRun](#NCTestRun)
