## OpenGraph 0.1.1

* `Get-OpenGraph` now supports unclosed `<meta>` tags (#23)
* `Test-OpenGraph` and `Test-OGP` are aliases of `Get-OpenGraph` (#22).
  * Additionally, `Get-OpenGraph` now outputs `$false` when no OpenGraph tags are found.
* `Get-OpenGraph` now accepts any pipeline input and number of arguments (#21)
* `Get-OpenGraph` correctly outputs cached results (#20)

---

## OpenGraph 0.1

* `OpenGraph.ToString()` now returns HTML (#10)
* `Get-OpenGraph` now caches results (#11)

---

## OpenGraph 0.0.1

* Initial Release of OpenGraph Module (#1)
    * `Get-OpenGraph` gets open graph information (#2)
    * OpenGraph objects can get `.HTML` (#8)
