# Binutils / GDB Test Script

A single makefile that will configure, build, and test multiple target
configurations of the binutils-gdb repository.  The script is intended
to try an maximise the amount of parallelism that is acomplished by
make.

## Setup

 1. Create a source directory containing the version of binutils-gdb
 to test.

 2. Create a build directory into which the results will be written.

 3. Run as:

    ```
    make -jNN SRC_DIR=/path/to/source/dir BUILD_DIR=/path/to/build/dir TARGET
    ```

    where `-jNN` should be replaced with a suitable parallelism
    number, and `TARGET` is a target from the list below.

## Some Make Targets To Try

The following make targets exist within the makefile:

 * *dirs* builds just the target directories.

 * *configure* configures all the targets, but does not build.  Will
   create the target directory if needed.

 * *build* builds all the targets.  Will configure if needed.

 * *check-gas* run the assembler tests

 * *check-ld* run the linker tests

 * *check-binutils* run the binutils tests

## Results

The `BUILD_DIR` will contain a directory for each target that was
built, inside each of these target directories is the build and test
results for that target.

There's also a summary file for each make target within the top level
`BUILD_DIR`, this summary just lists if the make target was successful
or not for each target.

## Adding New Target

**TODO:** Write some details here.