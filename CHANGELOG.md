## OpenGraph 0.1.2

* `Test-OpenGraph` and `Test-OGP` are aliases of `Get-OpenGraph` (#22).
  * Additionally, `Get-OpenGraph` now outputs `$false` when no OpenGraph tags are found.
* `Get-OpenGraph` now accepts any pipeline input and number of arguments (#21)
* `Get-OpenGraph` correctly outputs cached results (#20)
* `Get-OpenGraph` internally encapsulates each scenario into a filter (#25)

---

## OpenGraph 0.1.1

* Simplified Module Scaffolding (#14)
* Supporting open or closed tags (#15)
* Get-OpenGraph -Html supports direct content (#16)
* Get-OpenGraph -Url is now positional and pipeable (#17)
* Improving README (#18)

---

## OpenGraph 0.1

* `OpenGraph.ToString()` now returns HTML (#10)
* `Get-OpenGraph` now caches results (#11)

---

## OpenGraph 0.0.1

* Initial Release of OpenGraph Module (#1)
    * `Get-OpenGraph` gets open graph information (#2)
    * OpenGraph objects can get `.HTML` (#8)
