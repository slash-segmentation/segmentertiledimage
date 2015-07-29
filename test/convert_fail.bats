#!/usr/bin/env bats


# 
# Load the helper functions in test_helper.bash 
# Note the .bash suffix is omitted intentionally
# 
load test_helper

#
# Test to run is denoted with at symbol test like below
# the string after is the test name and will be displayed
# when the test is run
#
@test "Test where convert exits nonzero" {

  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath
  mkdir -p "$THE_TMP/foo/data"
  echo "1,,error," > "$THE_TMP/bin/command.tasks"
  echo "hi" > "$THE_TMP/foo/data/slice.png"
  echo -e "x=10\ny=20\noriginal.name=foo.png" > "$THE_TMP/foo/slice.info"
  # Run kepler.sh
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -inputimagedir "$THE_TMP/foo" -convertCmd "$THE_TMP/bin/command" -CWS_outputdir $THE_TMP $WF

  # Check exit code
  [ "$status" -eq 0 ]

  # will only see this if kepler fails
  echoArray "${lines[@]}"
  

  # Check output from kepler.sh
  [[ "${lines[0]}" == "The base dir is"* ]]

  # Will be output if anything below fails
  cat "$THE_TMP/$README_TXT"
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  # Verify we did not get a WORKFLOW.FAILED.txt file
  [ -e "$THE_TMP/$WORKFLOW_FAILED_TXT" ]

  run cat "$THE_TMP/$WORKFLOW_FAILED_TXT" 

  [ "${lines[0]}" == "simple.error.message=Error tiling image" ]
  [[ "${lines[1]}" == "detailed.error.message=Nonzero exitcode (1) from "* ]]

  # Verify we got a README.txt
  [ -s "$THE_TMP/$README_TXT" ]

  # Check we got a workflow.status file
  [ -s "$THE_TMP/$WORKFLOW_STATUS" ]

}
 
