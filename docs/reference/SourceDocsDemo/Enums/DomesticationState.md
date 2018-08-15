**ENUM**

# `DomesticationState`

```swift
public enum DomesticationState
```

> Describes the state of domestication
>
> _Italics_ are supported with a leading and trailing underscore
>
> __Bold__ is supported with 2 leading and trailing asterisks
>
> These are the supported headings using `#`:
>
> # h1
> ## h2
> ### h3
> #### h4
> ---
> ---
>
>
> - domesticated: For animal that are domesticated.
> - undomesticated: For animal that are not domesticated.
> - unknown: For animals which have an unknown domestication state.
>
> Here is a comment with [link that is](http://www.link.com) embedded
>
> ![dog gif](https://media.giphy.com/media/mCRJDo24UvJMA/giphy.gif)

## Cases
### `domesticated`

```swift
case domesticated
```

> For animal that are domesticated.

### `undomesticated`

```swift
case undomesticated
```

> For animal that are not domesticated.

### `unknown`

```swift
case unknown(String)
```

> For animals which have an unknown domestication state.
