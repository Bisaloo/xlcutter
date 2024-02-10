# xlcutter (development version)

* `xlsx_cutter()` internal loop won't be interrupted in case a file can't be
  parsed. This avoid loosing potentially hours of computation when one of the
  last files fails and made the entire function crash. All parsing issues are
  now returned as warnings at the end (#13, @Bisaloo).

# xlcutter 0.1.1

* `xlsx_cutter()` no longer fails when reading excel files with comments on
  blank cells (#14, @Bisaloo).

# xlcutter 0.1.0

* Added a `NEWS.md` file to track changes to the package.
