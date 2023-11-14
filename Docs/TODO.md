# TODO - `DGSwiftUtilites`

- [ ] `TODO:2023-11-15-04-52-41` - Impl: Protocol - `EnumCasesStringConvertible`, 
- [ ] `TODO:2023-11-15-04-52-55` - Impl: Protocol - `EnumAssociatedValuesDictionaryRepresentable`
- [ ] `TODO:2023-11-15-05-07-11` Impl: Protocol - `EnumComparable` + `EnumHashable`
  * Enum `Comparable` automatic conformance via comparing "case name string" + "associated values".
  * `extension EnumComparable where Self: EnumCasesStringConvertible & EnumAssociatedValuesDictionaryRepresentable`