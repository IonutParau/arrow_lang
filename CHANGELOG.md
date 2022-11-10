## 0.0.1

- Initial version.

## 0.1.0

- Added `Memory.Buffer`
- Added `Memory.Pool`
- Added `tostring`
- Added `tonumber`
- Added `tojson`
- Added `fromjson`
- Added `isShape`
- Added syntactic sugar for shapes

```
shape SomeType {
  test: number,
  other: Memory.Pool,
}
```

- Made field classes (classed defined as fields of maps) properly show their type
- Made maps ignore hidden fields (fields starting with `__`), as those are considered hidden
