# Tree editor

1. Init should recrate and recync composites from this point onward

```mermaid
graph LR
    A[Feature] --> B[Composite0]
    A --> C[Composite1]
    C --> D[DeepComposite0]
    C --> E[DeepComposite1]
    C --> F[DeepComposite2]
```

1. Update feature in  tree should destroy whole subtree from this point,
and then recreate and resync it from this point onward

1a) UpdateFeature -> recreate childreen -> sync composites

recrete childreen will destroy current controllers

```mermaid
graph LR
    A[Feature] --> B[Composite0]
    B --> D[DeepComposite0]
    B --> E[DeepComposite1]
    B --> F[DeepComposite2]
```

2. Adding composite should 